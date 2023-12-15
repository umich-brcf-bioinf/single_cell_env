FROM bioconductor/bioconductor_docker:RELEASE_3_18

RUN Rscript -e "\
    install.packages(c(\
        'bookdown', \
        'ComplexUpset', \
        'cowplot', \
        'dplyr', \
        'ggplot2', \
        'ggrepel', \
        'hdf5r', \
        'Hmisc', \
        'kableExtra', \
        'locfit', \
        'metap', \
        'patchwork', \
        'plotly', \
        'reticulate', \
        'Seurat', \
        'Signac', \
        'tidyverse')); \
    BiocManager::install(c(\
        'AnnotationDbi', \
        'AnnotationFilter', \
        'batchelor', \
        'BiocGenerics', \
        'DelayedArray', \
        'DelayedMatrixStats', \
        'DESeq2', \
        'EnsDb.Mmusculus.v79', \
        'EnsDb.Hsapiens.v75', \
        'GenomeInfoDb', \
        'GenomicFeatures', \
        'GenomicRanges', \
        'ggbio', \
        'glmGamPoi', \
        'IRanges', \
        'limma', \
        'MAST', \
        'Matrix.utils', \
        'monocle', \
        'motifmatchr', \
        'multtest', \
        'Rsamtools', \
        'S4Vectors', \
        'SingleCellExperiment', \
        'SummarizedExperiment'));"

RUN wget -P /tmp https://repo.anaconda.com/miniconda/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh && \
    sha256sum /tmp/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh -p /miniconda -b && \
    rm /tmp/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh

ENV PATH=/miniconda/bin:${PATH}

RUN mkdir -p /root/.local/share && \
    echo "/miniconda/bin/conda" > /root/.local/share/r-miniconda

RUN apt-get update && \
    apt-get install -y fonts-dejavu libxkbcommon-x11-0 && \
    wget -P /tmp/ https://download1.rstudio.org/desktop/jammy/amd64/rstudio-2022.07.2-576-amd64.deb && \
    dpkg -i /tmp/rstudio-2022.07.2-576-amd64.deb

RUN pip install scanpy loompy scvelo

RUN apt-get install -y libboost-all-dev && \
    Rscript -e "\
        BiocManager::install('pcaMethods'); \
        library(devtools); \
        install_github('velocyto-team/velocyto.R');"

RUN Rscript -e "\
        library(devtools); \
        install_github('ZJUFanLab/scCATCH');"

RUN Rscript -e "\
    BiocManager::install(c(\
        'celda')); \
    install.packages(c(\
        'SoupX'));"

RUN Rscript -e "\
        library(devtools); \
        install_github('bnprks/BPCells'); \
        install_github('immunogenomics/presto');"
