## base container
FROM rocker/tidyverse:latest as base_container

USER root
RUN apt-get update \
    && apt-get install --yes rename tini procps curl \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["tini", "--"]
CMD ["/bin/bash"]

FROM base_container
# adding opencontainer labels to link registry to github repository
LABEL org.opencontainers.image.title="bst270-2025-nf"
LABEL org.opencontainers.image.description="example of nextflow with midus project"
LABEL org.opencontainers.image.url="https://github.com/violafanfani/bst270-2025-nf"
LABEL org.opencontainers.image.documentation="https://github.com/violafanfani/bst270-2025-nf"
LABEL org.opencontainers.image.source="https://github.com/violafanfani/bst270-2025-nf"
LABEL org.opencontainers.image.vendor="violafanfani"
LABEL org.opencontainers.image.authors="Viola Fanfani"
LABEL org.opencontainers.image.revision="v0.0.0"


###
RUN apt-get update
## Install cran packages
RUN R -e "install.packages(c('optparse', 'gtsummary'),\
                            dependencies=TRUE, \
                           repos='http://cran.rstudio.com/')"


## Install our own package

#COPY /Users/violafanfani/Documents/uni-harvard/repos/NetSciDataCompanion /opt/NetSciDataCompanion 
#RUN R -e "devtools::install_local('/opt/NetSciDataCompanion', force=TRUE)"
## Install bioconductior packages                           
# RUN R -e 'BiocManager::install(c("recount3", \
#     "edgeR", "GenomicAlignments", "Biostrings", "SummarizedExperiment", "GenomicFiles","recount",\
#     "TCGAbiolinks", "GenomicDataCommons","limma", "org.Hs.eg.db",ask = F))'
