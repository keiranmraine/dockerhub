FROM    ubuntu:14.04

MAINTAINER  keiranmraine@gmail.com

LABEL   uk.ac.sanger.cgp="Cancer Genome Project, Wellcome Trust Sanger Institute" \
        version="0.0" \
        description="The CGP somatic calling pipeline 'in-a-box'"

USER    root

# needed for R packages
# why and how here: https://cran.rstudio.com/bin/linux/ubuntu/
RUN     apt-get -yq update
RUN     apt-get -yq install build-essential autoconf software-properties-common python-software-properties
RUN     echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
RUN     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN     add-apt-repository -y ppa:marutter/rdev
RUN     apt-get -yq update
RUN     apt-get -yq upgrade

# general tools
RUN     apt-get -qy install wget curl rsync nano s3cmd

# htslib/samtools deps
RUN     apt-get -qy install zlib1g-dev

# Bio::DB::Sam dep
RUN     apt-get -qy install libncurses5-dev

# PCAP-code prereq for perl libs
RUN     apt-get -qy install libgd-dev libgd2-xpm-dev libexpat1-dev

# BRASS deps
RUN     apt-get -qy install python unzip libboost-dev libboost-iostreams-dev libpstreams-dev libglib2.0-dev
RUN     apt-get -qy install r-base r-base-core r-cran-rcolorbrewer r-cran-gam r-cran-VGAM r-cran-stringr

RUN     mkdir /tmp/downloads

# PCAP-core
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/ICGC-TCGA-PanCancer/PCAP-core/archive/v1.12.1.tar.gz | tar xz
WORKDIR /tmp/downloads/PCAP-core-1.12.1
RUN     ./setup.sh /opt/wtsi-cgp
# this is inside the biobambam distribution, make sure it’s not present downstream
RUN     rm -f /opt/wtsi-cgp/bin/curl

# cgpVcf
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/cgpVcf/archive/v1.3.1.tar.gz | tar xz
WORKDIR /tmp/downloads/cgpVcf-1.3.1
RUN     ./setup.sh /opt/wtsi-cgp

# cgpPindel
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/cgpPindel/archive/v1.5.4.tar.gz | tar xz
WORKDIR /tmp/downloads/cgpPindel-1.5.4
RUN     ./setup.sh /opt/wtsi-cgp

# alleleCount
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/alleleCount/archive/v2.1.2.tar.gz | tar xz
WORKDIR /tmp/downloads/alleleCount-2.1.2
RUN     ./setup.sh /opt/wtsi-cgp

# ascatNgs
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/ascatNgs/archive/v1.5.2.tar.gz | tar xz
WORKDIR /tmp/downloads/ascatNgs-1.5.2
RUN     ./setup.sh /opt/wtsi-cgp

# cgpCaVEManPostProcessing
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/cgpCaVEManPostProcessing/archive/v1.4.1.tar.gz | tar xz
WORKDIR /tmp/downloads/cgpCaVEManPostProcessing-1.4.1
RUN     ./setup.sh /opt/wtsi-cgp

# cgpCaVEManWrapper
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/cgpCaVEManWrapper/archive/1.9.0.tar.gz | tar xz
WORKDIR /tmp/downloads/cgpCaVEManWrapper-1.9.0
RUN     ./setup.sh /opt/wtsi-cgp

# VAGrENT
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/VAGrENT/archive/v2.1.2.tar.gz | tar xz
WORKDIR /tmp/downloads/VAGrENT-2.1.2
RUN     ./setup.sh /opt/wtsi-cgp

# grass
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/grass/archive/v1.1.6.tar.gz | tar xz
WORKDIR /tmp/downloads/grass-1.1.6
RUN     ./setup.sh /opt/wtsi-cgp

# fasta36 dependancy of BRASS
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/wrpearson/fasta36/archive/v36.3.8.tar.gz | tar xz
WORKDIR /tmp/downloads/fasta36-36.3.8/src
RUN     make -f ../make/Makefile.linux64 install XDIR=/opt/wtsi-cgp/bin

# BRASS Bioconductor packages not available via apt-get:
WORKDIR /tmp/downloads
RUN     wget https://www.bioconductor.org/packages/release/bioc/src/contrib/BiocGenerics_0.16.1.tar.gz \
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
WORKDIR /tmp/downloads
RUN     curl -sL https://github.com/cancerit/BRASS/archive/v4.0.11.tar.gz | tar xz
WORKDIR /tmp/downloads/BRASS-4.0.11
RUN     ./setup.sh /opt/wtsi-cgp

WORKDIR /opt/wtsi-cgp
RUN     curl -sL https://s3-eu-west-1.amazonaws.com/wtsi-pancancer/reference/seqware_ref.tar.gz | tar xz

RUN rm -rf /tmp/downloads
