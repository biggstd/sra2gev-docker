# Use ubuntu 16.04 as the parent image
FROM ubuntu:xenial

#
# Add some basic utilities 
#
RUN apt-get update \
  && apt-get -y install git tcl wget unzip default-jre vim zlib1g-dev libbz2-dev liblzma-dev python

#
# Create an unpriviledged user named 'bioinfo'
#
RUN useradd -ms /bin/bash bioinfo \
  && echo "source /etc/profile.d/z00_lmod.sh" >> ~bioinfo/.bashrc \
  && chown -R bioinfo /home/bioinfo

#
# Install the Lmod modules system for package managmenet since
# the GEV workflow expects it
#
WORKDIR /usr/local/src
RUN apt-get install -y lua5.2 liblua5.2-dev libtool-bin lua-posix lua-filesystem lua-filesystem-dev \
  && git clone https://github.com/TACC/Lmod.git --branch 7.7.13 \
  && cd Lmod \
  && ./configure --prefix=/usr/local \
  && make install \
  && ln -s /usr/local/lmod/lmod/init/profile /etc/profile.d/z00_lmod.sh \
  && ln -s /usr/local/lmod/lmod/init/cshrc /etc/profile.d/z00_lmod.csh \
  && mkdir -p /usr/local/modulefiles/Linux

#
# Install bioinformatics tools needed for the GEV workflow
#

# Install SRAToolkit v2.8.2
RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2/sratoolkit.2.8.2-ubuntu64.tar.gz \
  && tar -zxvf sratoolkit.2.8.2-ubuntu64.tar.gz \
  && mv sratoolkit.2.8.2-ubuntu64 /usr/local/sratoolkit.2.8.2 

# Install trimmomatic
RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip \
  && unzip Trimmomatic-0.36.zip \
  && mv Trimmomatic-0.36 /usr/local

# Install hisat2
RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip \
  && unzip hisat2-2.1.0-Linux_x86_64.zip \
  && mv hisat2-2.1.0 /usr/local

# Install samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2 \
  && bunzip2 samtools-1.6.tar.bz2 \
  && tar -xvf samtools-1.6.tar \
  && cd samtools-1.6 \
  && ./configure --prefix=/usr/local/samtools-1.6 --without-curses \
  && make install

# Install stringtie
RUN wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.3b.Linux_x86_64.tar.gz \
  && tar -zxvf stringtie-1.3.3b.Linux_x86_64.tar.gz \
  && mv stringtie-1.3.3b.Linux_x86_64 /usr/local/stringtie-1.3.3b 
   

# Add the module files for all of the installed tools
ADD modulefiles/. /usr/local/modulefiles/Linux

#
# Now setup the GEV workflow as the bioinfo user
#
USER bioinfo
WORKDIR /home/bioinfo
RUN git clone https://github.com/spficklin/SRA2GEV.git 
