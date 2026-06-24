FROM bioconductor/bioconductor_docker:devel

ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true
ENV CRAN='https://packagemanager.posit.co/cran/__linux__/noble/latest'
ENV SHINY_INPUT_DIR="/shiny_input"
ENV SHINY_OUTPUT_DIR="/shiny_output"

# Install remotes, and then install templateDockerShinyPkg and dependencies from GitHub
RUN Rscript -e "BiocManager::install(c('remotes'), update = TRUE, ask = FALSE); \
    remotes::install_github('csoneson/templateDockerShinyPkg', dependencies = TRUE)"

USER root

# Create input and output directories and set permissions
RUN mkdir -p /shiny_input /shiny_output && \
    chown -R rstudio:rstudio /shiny_input /shiny_output

# Copy the app setup script
COPY app_setup.R /app_setup.R
RUN chown rstudio:rstudio /app_setup.R

USER rstudio

EXPOSE 3838

CMD ["Rscript", "/app_setup.R"]
