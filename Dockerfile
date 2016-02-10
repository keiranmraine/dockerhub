FROM    ubuntu:14.04

MAINTAINER  keiranmraine@gmail.com

LABEL   uk.ac.sanger.cgp="Cancer Genome Project, Wellcome Trust Sanger Institute" \
        version="0.0" \
        description="The CGP somatic calling pipeline 'in-a-box'"

USER    root

RUN     mkdir /tmp/downloads

RUN     apt-get -myq update
RUN     apt-get -myq install build-essential autoconf software-properties-common python-software-properties \
                            wget curl rsync nano zlib1g-dev libncurses5-dev libgd-dev \
                            libgd2-xpm-dev libexpat1-dev python unzip libboost-dev libboost-iostreams-dev \
                            libpstreams-dev libglib2.0-dev

WORKDIR /tmp/downloads
# PCAP-core
RUN     curl -sL https://github.com/ICGC-TCGA-PanCancer/PCAP-core/archive/v1.12.1.tar.gz | tar xz
RUN     cd /tmp/downloads/PCAP-core-1.12.1; ./setup.sh /opt/wtsi-cgp


# cgpVcf
RUN     curl -sL https://github.com/cancerit/cgpVcf/archive/v1.3.1.tar.gz | tar xz
RUN     cd /tmp/downloads/cgpVcf-1.3.1; ./setup.sh /opt/wtsi-cgp

# cgpPindel
RUN     curl -sL https://github.com/cancerit/cgpPindel/archive/v1.5.4.tar.gz | tar xz
RUN     cd /tmp/downloads/cgpPindel-1.5.4; ./setup.sh /opt/wtsi-cgp

# alleleCount
RUN     curl -sL https://github.com/cancerit/alleleCount/archive/v2.1.2.tar.gz | tar xz
RUN     cd /tmp/downloads/alleleCount-2.1.2; ./setup.sh /opt/wtsi-cgp

# ascatNgs
RUN     curl -sL https://github.com/cancerit/ascatNgs/archive/v1.5.2.tar.gz | tar xz
RUN     cd /tmp/downloads/ascatNgs-1.5.2; ./setup.sh /opt/wtsi-cgp

# cgpCaVEManPostProcessing
RUN     curl -sL https://github.com/cancerit/cgpCaVEManPostProcessing/archive/v1.4.1.tar.gz | tar xz
RUN     cd /tmp/downloads/cgpCaVEManPostProcessing-1.4.1; ./setup.sh /opt/wtsi-cgp

# cgpCaVEManWrapper
RUN     curl -sL https://github.com/cancerit/cgpCaVEManWrapper/archive/1.9.0.tar.gz | tar xz
RUN     cd /tmp/downloads/cgpCaVEManWrapper-1.9.0; ./setup.sh /opt/wtsi-cgp

# VAGrENT
RUN     curl -sL https://github.com/cancerit/VAGrENT/archive/v2.1.2.tar.gz | tar xz
RUN     cd /tmp/downloads/VAGrENT-2.1.2; ./setup.sh /opt/wtsi-cgp

# grass
RUN     curl -sL https://github.com/cancerit/grass/archive/v1.1.6.tar.gz | tar xz
RUN     cd /tmp/downloads/grass-1.1.6;./setup.sh /opt/wtsi-cgp

# fasta36 dependancy of BRASS
RUN     curl -sL https://github.com/wrpearson/fasta36/archive/v36.3.8.tar.gz | tar xz
RUN     cd /tmp/downloads/fasta36-36.3.8/src; make -f ../make/Makefile.linux64 install XDIR=/opt/wtsi-cgp/bin

# BRASS deps
RUN     echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
RUN     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN     add-apt-repository -y ppa:marutter/rdev
RUN     apt-get -myq update
RUN     apt-get -myq upgrade
RUN     apt-get -mqy install python unzip libboost-dev libboost-iostreams-dev libpstreams-dev libglib2.0-dev
RUN     apt-get -mqy install r-base r-base-core r-cran-rcolorbrewer r-cran-gam r-cran-VGAM r-cran-stringr

# BRASS Bioconductor packages not available via apt-get:
RUN     wget -q https://www.bioconductor.org/packages/release/bioc/src/contrib/BiocGenerics_0.16.1.tar.gz \
             https://cran.r-project.org/src/contrib/poweRlaw_0.50.0.tar.gz \
             https://www.bioconductor.org/packages/release/bioc/src/contrib/S4Vectors_0.8.11.tar.gz \
             https://www.bioconductor.org/packages/release/bioc/src/contrib/IRanges_2.4.6.tar.gz \
             https://www.bioconductor.org/packages/release/bioc/src/contrib/GenomeInfoDb_1.6.3.tar.gz \
             https://www.bioconductor.org/packages/release/bioc/src/contrib/zlibbioc_1.16.0.tar.gz \
             https://www.bioconductor.org/packages/release/bioc/src/contrib/XVector_0.10.0.tar.gz \
             https://www.bioconductor.org/packages/release/bioc/src/contrib/GenomicRanges_1.22.4.tar.gz \
             https://www.bioconductor.org/packages/release/bioc/src/contrib/copynumber_1.10.0.tar.gz

RUN     R CMD INSTALL BiocGenerics_0.16.1.tar.gz \
                      poweRlaw_0.50.0.tar.gz \
                      S4Vectors_0.8.11.tar.gz \
                      IRanges_2.4.6.tar.gz \
                      GenomeInfoDb_1.6.3.tar.gz \
                      zlibbioc_1.16.0.tar.gz \
                      XVector_0.10.0.tar.gz

# GenomicRanges fails if in the middle of a bulk install
RUN     R CMD INSTALL GenomicRanges_1.22.4.tar.gz \
                      copynumber_1.10.0.tar.gz

# BRASS
RUN     curl -sL https://github.com/cancerit/BRASS/archive/v4.0.12.tar.gz | tar xz
RUN     cd /tmp/downloads/BRASS-4.0.12; ./setup.sh /opt/wtsi-cgp

RUN rm -rf /tmp/downloads /root/.cache/hts-ref
