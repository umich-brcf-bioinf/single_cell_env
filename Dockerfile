FROM bioconductor/bioconductor_docker:RELEASE_3_19-R-4.4.0

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

RUN pip install scanpy loompy scvelo pandas leidenalg macs2 && \
    pip cache purge

ENV WORKON_HOME=/opt/virtualenvs

RUN Rscript -e "\
    BiocManager::install(c(\
        'AnnotationDbi', \
        'AnnotationFilter', \
        'annotatr', \
        'arrow', \
        'batchelor', \
        'BiocGenerics', \
        'bnprks/BPCells/r', \
        'bookdown', \
        'BSgenome.Hsapiens.UCSC.hg38', \
        'BSgenome.Mmusculus.UCSC.mm10', \
        'celda', \
        'celldex', \
        'chris-mcginnis-ucsf/DoubletFinder', \
        'cole-trapnell-lab/monocle3', \
        'ComplexUpset', \
        'cowplot', \
        'decontX', \
        'DelayedArray', \
        'DelayedMatrixStats', \
        'DESeq2', \
        'EnsDb.Mmusculus.v79', \
        'EnsDb.Hsapiens.v75', \
        'GenomeInfoDb', \
        'GenomicFeatures', \
        'GenomicRanges', \
        'ggbio', \
        'ggrastr', \
        'ggrepel', \
        'glmGamPoi', \
        'harmony', \
        'hdf5r', \
        'Hmisc', \
        'HDF5Array', \
        'immunogenomics/presto', \
        'IRanges', \
        'JASPAR2020', \
        'kableExtra', \
        'limma', \
        'lme4', \
        'locfit', \
        'MAST', \
        'Matrix', \
        'Matrix.utils', \
        'metap', \
        'motifmatchr', \
        'multtest', \
        'patchwork', \
        'pcaMethods', \
        'plotly', \
        'RCurl', \
        'reticulate', \
        'Rsamtools', \
        'S4Vectors', \
        'satijalab/seurat@914c0f180bf919898ba573eb28bbeb259aa94cbc', \
        'scran', \
        'SeuratData', \
        'SeuratWrappers', \
        'SingleCellExperiment', \
        'Signac', \
        'SingleR', \
        'SoupX', \
        'SummarizedExperiment', \
        'TFBSTools', \
        'tidyverse', \
        'velocyto-team/velocyto.R', \
        'ZJUFanLab/scCATCH'));" && \
    rm -fr /tmp/Rtmp*

# Pull specific commit to main that includes support for SpaceRangerV4
# https://github.com/satijalab/seurat/commit/914c0f180bf919898ba573eb28bbeb259aa94cbc


