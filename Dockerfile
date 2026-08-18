# syntax=docker/dockerfile:1
FROM rocker/shiny-verse:4.4
RUN apt-get update && apt-get install -yq \
    libbz2-dev \
    libhdf5-dev \
    libnetcdf-dev \
    build-essential \
    libgd-dev \
    libudunits2-dev \
    libproj-dev \
    libgdal-dev  \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra

RUN Rscript -e 'install.packages(c("devtools", "BiocManager", "tidyverse", "ggrepel", "httr", "rjson", "mvtnorm", "tmvtnorm", \
"imputeLCMD", "plotly", "DT", "testthat", "RColorBrewer", "shiny","shinyalert","shinydashboard", \
"shinyjs", "svglite", "rhandsontable", "shinyBS", "shinyWidgets", "ggVennDiagram", "conflicted", "png", "vegan", "assertthat", "jsonlite", \
"shinycssloaders","data.table", "factoextra", "UpSetR","fastcluster","fdrtool"), dependencies=TRUE)'
### #FROM bioconductor/bioconductor_docker:RELEASE_3_19
RUN Rscript -e 'devtools::install_github("Appsilon/shiny.info")'
RUN Rscript -e 'BiocManager::install(pkgs=c("ensembldb", "EnsDb.Hsapiens.v86", "SummarizedExperiment", "limma", "ComplexHeatmap", "MSnbase", "missForest", "impute", "pcaMethods"), ask=F, dependencies=TRUE)'

### RUN Rscript -e 'install.packages("renv")'
COPY ./ /srv/shiny-server/fragpipe-analyst
COPY shiny-server.conf.prod /etc/shiny-server/shiny-server.conf

WORKDIR /srv/shiny-server/fragpipe-analyst
RUN rm -f .Rprofile && rm -rf renv
RUN rm -f google_analytics.html && touch google_analytics.html
RUN chown -R shiny:shiny /srv/shiny-server/fragpipe-analyst \
 && chmod -R a+rX /srv/shiny-server/fragpipe-analyst
