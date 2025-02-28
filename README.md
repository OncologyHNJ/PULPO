# PULPO

PULPO es un pipeline basado en Snakemake para el análisis de variantes estructurales (SVs) y copy number variations (CNVs) en datos de Optical Genome Mapping (OGM).

## Instalación

Para ejecutar PULPO, sigue los siguientes pasos:

1. **Clona el repositorio:**
   ```bash
   git clone https://github.com/tuusuario/PULPO.git
   cd PULPO
   ```

2. **Instala Conda y Snakemake:**
   Si aún no tienes Conda instalado, puedes descargar Miniconda desde [aquí](https://docs.conda.io/en/latest/miniconda.html).
   Luego, instala Snakemake:
   ```bash
   conda install -c conda-forge -c bioconda snakemake
   ```

3. **Crea y activa un entorno Conda con las dependencias necesarias:**
   ```bash
   conda env create -f environment.yaml
   conda activate pulpo_env
   ```

## Uso

Para ejecutar el pipeline en modo estándar:
```bash
snakemake --cores <n>
```
Donde `<n>` es el número de hilos que quieres usar.

Si deseas ejecutar PULPO en un clúster:
```bash
snakemake --profile cluster
```

## Estructura del repositorio

- `Snakefile` - Archivo principal del pipeline.
- `rules/` - Reglas de Snakemake organizadas por etapas del análisis.
- `scriptsdef/` - Scripts adicionales para procesamiento de datos.
- `config/` - Archivos de configuración.

## Contacto
Si tienes dudas o problemas, abre un issue en GitHub o contacta a los desarrolladores.

