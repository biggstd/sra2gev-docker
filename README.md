# sra2gev-docker
The sra2gev-docker package contains the necessary components to build a Docker image for testing the [sra2gev](https://github.com/SystemsGenetics/sra2gev) workflow. The sra2gev workflow is a Nextflow workflow that downloads a set of samples from the NCBI Short Read Archive (SRA) and generates a file for each sample containing FPKM values for all genes in a genome annotation set. In other words, a Gene Expression Vector (GEV) for each sample.   Therefore, the resulting docker image will contain the necessary tools: Lmod module system, sratoolkit, trimmomatic, hisat2, samtools, stringtie and the sra2gev workflow.  The image also supports integration with iRODs such that experiment files can be prepared on an iRODs server and automatically downloaded for execution when the image is run.

This image is meant to be used for development and testing purposes with small datasets.

## Pull this Image from DockerHub
You can pull an existing image built from this repository from DockerHub using this command:

```bash
docker pull systemsgenetics/sra2gev-docker
```

## Build the Docker Image
To build the image, first clone it then build the image with this command

```bash
cd sra2gev-docker
docker build -t sra2gev-docker .
```

## Run the Container Interactivevly
To execute the **sra2gev** workflow manually by providing your own input files you can use the following command:

```bash
docker run -it sra2gev-docker /bin/bash
```
This will log you into the image as the **bioinfo** user and you will find the **sra2gev** directory. Enter the **sra2gev** directory to configure the workflow as desired.  It is setup, by default, to run using the local scheduler.

If you would like to use iRODs in this interactive session you can setup iRODs by running this command:

```bash
iinit
```
And follow the command-line prompts to configure the iRODs client.

## Log in to the Container as Root
To login as root run this command:

```bash
docker run -u 0 -it sra2gev-docker /bin/bash
```

## Run the Container Automatically with iRODs
To execute the **sra2gev** workflow automatically you must have the sra2gev input files already available on an iRODs server.  These files include a directory named **reference** with a prepared reference genome, the **SRA_IDs.txt** file containing the the list of SRA IDs that should be used by the workflow, and a **basename.txt** file that contains the basename used to name all of the files in the reference folder.  These files must be stored in a directory whose name serves as the experiment ID.  Here is a sample directory containing the necessary files on an iRODs server:

```
/scidasZone/sysbio/experiments/sra2gev/test:
  basename.txt
  SRA_IDs.txt
  C- /scidasZone/sysbio/experiments/sra2gev/test/reference
/scidasZone/sysbio/experiments/sra2gev/test/reference:
  Oryza_sativa-IRGSP-1.1.ht2
  Oryza_sativa-IRGSP-1.2.ht2
  Oryza_sativa-IRGSP-1.3.ht2
  Oryza_sativa-IRGSP-1.4.ht2
  Oryza_sativa-IRGSP-1.5.ht2
  Oryza_sativa-IRGSP-1.6.ht2
  Oryza_sativa-IRGSP-1.7.ht2
  Oryza_sativa-IRGSP-1.8.ht2
  Oryza_sativa-IRGSP-1.fa
  Oryza_sativa-IRGSP-1.gff3
  Oryza_sativa-IRGSP-1.gtf
  Oryza_sativa-IRGSP-1.Splice_sites.txt
```

To execute the workflow use the following command:

```bash
docker run -it -e IRODS_HOST="{irods_host}" -e IRODS_PORT={irods_port} -e IRODS_USER_NAME="{irods_user}" -e IRODS_ZONE_NAME="{irods_zone}" -e EXP_PATH="{exp_path}" sra2gev-docker
```
Where:
- {irods_host}: the fully qualified domain name of the iRODs server
- {irods_port}: the port number for the iRODs server (usually 1247)
- {irods_zone}: the iRODs zone name
- {irods_user}: the iRODs user name
- {exp_path}: the full path within the iRODs zone where the experiment files are located.

When the workflow begins you will be asked for your iRODs password.  The image will then connect to iRODs, download the input files and execute the workflow.  


