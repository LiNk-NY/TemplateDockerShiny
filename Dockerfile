FROM bioconductor/bioconductor_docker:devel

ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true
ENV CRAN='https://packagemanager.posit.co/cran/__linux__/noble/latest'

WORKDIR /home/rstudio

COPY DESCRIPTION .

RUN Rscript -e "BiocManager::install(update = TRUE, ask = FALSE); remotes::install_deps(dependencies = TRUE, repos = BiocManager::repositories())"

COPY . .

RUN Rscript -e "remotes::install_local(dependencies=TRUE, repos = BiocManager::repositories())"

RUN chown -R rstudio:rstudio /home/rstudio

USER rstudio

EXPOSE 3838

CMD ["Rscript", "app.R"]

