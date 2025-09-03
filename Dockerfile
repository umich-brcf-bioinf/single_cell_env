FROM bioconductor/bioconductor_docker:RELEASE_3_19-R-4.4.0

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
        'Matrix', \
        'Matrix.utils', \
        'motifmatchr', \
        'multtest', \
        'Rsamtools', \
        'S4Vectors', \
        'SingleCellExperiment', \
        'SummarizedExperiment'));" && \
    rm -r /tmp/Rtmp*

RUN Rscript -e "\
        library(devtools); \
        devtools::install_github('satijalab/seurat@v5.1.0');"

RUN wget -P /tmp https://repo.anaconda.com/miniconda/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh && \
    sha256sum /tmp/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh -p /miniconda -b && \
    rm /tmp/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh

ENV PATH=/miniconda/bin:${PATH}

RUN mkdir -p /root/.local/share && \
    echo "/miniconda/bin/conda" > /root/.local/share/r-miniconda

RUN apt-get update && \
    apt-get install -y fonts-dejavu libxkbcommon-x11-0 libatk-bridge2.0-0 libgtk-3-0 && \
    wget -P /tmp/ https://s3.amazonaws.com/rstudio-ide-build/electron/jammy/amd64/rstudio-2023.09.1-494-amd64.deb && \
    dpkg -i /tmp/rstudio-2023.09.1-494-amd64.deb && \
    rm /tmp/rstudio-2023.09.1-494-amd64.deb

RUN pip install scanpy loompy scvelo && \
    pip cache purge

RUN pip install cmake --upgrade

RUN Rscript -e "\
    install.packages('rliger'); \
    install.packages('RcppPlanc', repos = 'https://welch-lab.r-universe.dev');"

RUN mkdir /opt/virtualenvs/ && \
    export WORKON_HOME=/opt/virtualenvs ; Rscript -e "\
    library(reticulate); \
    virtualenv_create('r-reticulate'); \
    virtualenv_install('r-reticulate', 'pandas'); \
    virtualenv_install('r-reticulate', 'leidenalg'); \
    install.packages('harmony');"

ENV WORKON_HOME=/opt/virtualenvs

RUN Rscript -e "\
    BiocManager::install(c('TOAST', 'zellkonverter')); \
    install.packages('devtools'); \
    devtools::install_github('xuranw/MuSiC');"
