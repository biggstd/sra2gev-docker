# Create the iRODs user settings file.
mkdir ~/.irods
echo "Setting up iRODs..."
echo '{' > ~/.irods/irods_environment.json
echo "  \"irods_host\": \"$IRODS_HOST\"," >> ~/.irods/irods_environment.json
echo "  \"irods_port\": \"$IRODS_PORT\"," >> ~/.irods/irods_environment.json
echo "  \"irods_user_name\": \"$IRODS_USER_NAME\"," >> ~/.irods/irods_environment.json
echo "  \"irods_zone_name\": \"$IRODS_ZONE_NAME\"" >> ~/.irods/irods_environment.json
echo "}" >> ~/.irods/irods_environment.json
iinit

# Move the files from iRODs for execution
cd SRA2GEV
icd /scidasZone/sysbio/experiments/SRA2GEV/$EXPID
echo "Copying SRA_IDs.txt..."
iget SRA_IDs.txt .
echo "Copying basename.txt..."
iget basename.txt .

# Adjust the nextflow config file
echo "Adjusting the nextflow.config file..."
perl -pi -e 's/.\/examples\/SRA_IDs.txt/.\/SRA_IDs.txt/' nextflow.config
perl -pi -e 's/examples\/reference/reference/' nextflow.config
export BASENAME=`cat basename.txt`
perl -pi -e "s/GCA_002793175.1_ASM279317v1_genomic/$BASENAME/" nextflow.config

# Finish copying the reference files.
echo "Copying reference genome files. This may take awhile..."
iget -r reference .

# Run the workflow
source ~/.bashrc
module add trimmomatic
nextflow run SRA2GEV.nf -profile standard
