rule check_cnvs:
    input:
        input= f"{resultsdir}/Patients/{{anonymised}}/OGMdata/"
    output:
        output= f"{resultsdir}/Patients/{{anonymised}}/OGMdata/check_cnvs_done.txt"
    params:
        script = f"{config['directories']['scriptsdir']}/CheckfilesCNVs.R",
        log= f"{resultsdir}/Checkpoints/check_cnvs_all.txt"
    shell:
        """
        mkdir -p {resultsdir}/Checkpoints  
        echo "Processing sample {wildcards.anonymised}..." >> {params.log}
        Rscript {params.script} {wildcards.anonymised} {input.input} >> {params.log} 2>&1
        echo "Finished processing sample {wildcards.anonymised}" >> {params.log}
        touch {output.output}
        """

rule bionanotosigprofilercnv:
    input:
        bionanodirectory = f"{resultsdir}/Patients/{{anonymised}}/OGMdata",
    output:
        outputdirectoryfile = f"{resultsdir}/Patients/{{anonymised}}/SigProfiler/data/SigProfilerCNVdf.tsv"
    log:
        log_file = f"{logsdir}/SigProfiler/Patients/{{anonymised}}/bionanotosigprofilercnv.log"
    params:
        mkdir = f"{resultsdir}/Patients/{{anonymised}}/SigProfiler/data/",
        script = f"{config['directories']['scriptsdir']}/9.CNVTOFORMAT.R",
    shell:
        """
        Rscript {params.script} {input.bionanodirectory} {output.outputdirectoryfile} {wildcards.anonymised} #&> {log.log_file}
        """


