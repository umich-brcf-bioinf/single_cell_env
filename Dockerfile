FROM bioconductor/bioconductor_docker:RELEASE_3_10

RUN Rscript -e "\
    BiocManager::install(c(\
        'AnnotationDbi', \
        'AnnotationFilter', \
        'BiocGenerics', \
        'GenomeInfoDb', \
        'GenomicFeatures', \
        'GenomicRanges', \
        'ggbio', \
        'IRanges', \
        'MAST', \
        'monocle', \
        'motifmatchr', \
        'multtest', \
        'Rsamtools', \
        'S4Vectors', \
        'ggbio', \
        'motifmatchr')); \
    install.packages(c(\  
        'cowplot', \
        'dplyr', \
        'reticulate', \
        'Seurat', \
        'Signac', \
        'tidyverse'));"

RUN wget -P /tmp https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh && \
    sha256sum /tmp/Miniconda3-py37_4.8.2-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-py37_4.8.2-Linux-x86_64.sh -p /miniconda -b && \
    rm /tmp/Miniconda3-py37_4.8.2-Linux-x86_64.sh

ENV PATH=/miniconda/bin:${PATH}

RUN mkdir -p /root/.local/share && \
    echo "/miniconda/bin/conda" > /root/.local/share/r-miniconda

RUN apt-get update && \
    apt-get install -y python3-pip

RUN pip3 install umap-learn

ENV FOO="BAR"

#RUN apt-get update && \
#    apt-get install -y libxkbcommon-x11-0 && \
#    wget -P /tmp/ https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.5033-amd64.deb && \
#    dpkg -i /tmp/rstudio-1.2.5033-amd64.deb
#

