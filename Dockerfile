FROM bioconductor/bioconductor_docker:RELEASE_3_10

RUN Rscript -e "\
    BiocManager::install(c(\
        'AnnotationDbi', \
        'AnnotationFilter', \
        'BiocGenerics', \
        'EnsDb.Mmusculus.v79', \
        'EnsDb.Hsapiens.v75', \
        'GenomeInfoDb', \
        'GenomicFeatures', \
        'GenomicRanges', \
        'ggbio', \
        'glmGamPoi', \
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
        'ggplot2',\
        'hdf5r',\
        'patchwork',\
        'reticulate', \
        'Seurat', \
        'Signac', \
        'tidyverse'));"

RUN Rscript -e "\
    BiocManager::install(c( \
        'DelayedArray', \
        'DelayedMatrixStats', \
        'limma', \
        'SingleCellExperiment', \
        'SummarizedExperiment', \
        'batchelor', \
        'Matrix.utils'));"

RUN Rscript -e "install.packages('metap')"

RUN wget -P /tmp https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh && \
    sha256sum /tmp/Miniconda3-py39_4.12.0-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-py39_4.12.0-Linux-x86_64.sh -p /miniconda -b && \
    rm /tmp/Miniconda3-py39_4.12.0-Linux-x86_64.sh

ENV PATH=/miniconda/bin:${PATH}

RUN mkdir -p /root/.local/share && \
    echo "/miniconda/bin/conda" > /root/.local/share/r-miniconda

RUN apt-get update && \
    apt-get install -y libxkbcommon-x11-0 && \
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
        'DESeq2','scran')); \
    install.packages(c(\  
        'bookdown', \
        'ComplexUpset', \
        'ggrepel', \
        'Hmisc', \
        'locfit', \
        'kableExtra', \
        'plotly', \
        'RCurl', \
        'dsb'));"

RUN Rscript -e "\
    BiocManager::install(c(\
        'celda', \
        'AUCell', \
        'RcisTarget', \
        'GENIE3', \
        'zoo', \
        'mixtools', \
        'rbokeh', \
        'DT', \
        'NMF', \
        'ComplexHeatmap', \
        'R2HTML', \
        'Rtsne', \
        'doMC', \
        'doRNG', \
        'destiny')); \
    install.packages(c(\
        'SoupX'));"

RUN Rscript -e "\
    library(devtools); \
    devtools::install_github('aertslab/SCopeLoomR', build_vignettes = TRUE); \
    devtools::install_github(c('aertslab/SCENIC', \
    'velocyto-team/velocyto.R'));"

