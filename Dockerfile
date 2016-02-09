FROM    ubuntu:14.04

MAINTAINER  keiranmraine@gmail.com

LABEL   uk.ac.sanger.cgp="Cancer Genome Project, Wellcome Trust Sanger Institute" \
        version="0.0" \
        description="The CGP somatic calling pipeline 'in-a-box'"

USER    root

RUN     mkdir /tmp/downloads

RUN     apt-get -yq update
RUN     apt-get -yq install build-essential autoconf software-properties-common python-software-properties \
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

# BRASS
RUN     curl -sL https://github.com/cancerit/BRASS/archive/v4.0.11.tar.gz | tar xz
RUN     cd /tmp/downloads/BRASS-4.0.11; ./setup.sh /opt/wtsi-cgp

RUN rm -rf /tmp/downloads
