# Goal

The purpose of this repository is to provide a template for dockerizing an
existing [shiny application](https://shiny.posit.co/), which handles an input
folder containing (non-obligatory) data and an output folder where any results
and log data exported from the app will be placed.  The shiny app should
include an action button to "save and exit", which cleanly closes the app and
stops the container.


# Overview of the setup

* The shiny app should be available in an R package. A template for such a
  package can be found
  [here](https://github.com/csoneson/templateDockerShinyPkg).

* The docker container is built on top of
  bioconductor/bioconductor_docker:devel and installs the package with the
  shiny app.

* The shiny app is started by running 'app_setup.R' inside the container.


# The template shiny app

The template shiny application in the
[example package](https://github.com/csoneson/templateDockerShinyPkg) uses the
[Old Faithful geyser dataset](https://search.r-project.org/CRAN/refmans/alr4/html/oldfaith.html)
as the basis for creating a simple interactive histogram, for which the user
can change the number of bins. The plot can also be saved to disk. Upon exiting
the app by clicking the "Stop app" button, all the user's actions (i.e.: change
of bin size using the slider, exporting a plot) are returned in a log variable,
which can then be written to a file.


# The 'app_setup.R' script

The `app_setup.R` script takes care of loading the R package holding the shiny
app, reading input data, launching the application and, upon closing the app,
writing the returned output to the output directory.

# Setting up your own app

To start the setup for your own app, first create a local copy of this
repository, either by cloning the repository or by downloading its content as a
zip file.  Next, adapt the `Dockerfile` and the `app_setup.R` script according
to your requirements.

Some examples of applications can be found in the following repositories:

* [https://github.com/federicomarini/docker-GeneTonic](https://github.com/federicomarini/docker-GeneTonic)
* [https://github.com/federicomarini/docker-ideal](https://github.com/federicomarini/docker-ideal)
* [https://github.com/federicomarini/docker-isee](https://github.com/federicomarini/docker-isee)
* [https://github.com/csoneson/docker-exploremodelmatrix](https://github.com/csoneson/docker-exploremodelmatrix)


# Building the image

To build the Docker image locally, run the following code from the directory
where the `Dockerfile` is located (or change the path accordingly), replacing
`templatedockershiny` with a suitable name:

```bash
docker build -t templatedockershiny:latest .
```

# Running the container

To run the container, first (if applicable) create directories for any input
and output files for the app, and mount these as `/shiny_input` and
`/shiny_output` in the container (these names should agree with those used to
define `SHINY_INPUT_DIR` and `SHINY_OUTPUT_DIR` in the `Dockerfile`).

```bash
mkdir -p /full_path/my_host_inputs/
mkdir -p /full_path/my_host_outputs/

docker run -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output templatedockershiny
```

The application can then be used by opening a browser and navigating to
`http://localhost:8080`.

To launch an interactive session, you can execute:

```bash
docker run -it -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output templatedockershiny bash

Rscript /app_setup.R
```

This allows, e.g., browsing the input and output directories before and after
using the app, or running `app_setup.R` interactively.

# Publishing and deploying the image onto GitHub Container Registry (GHCR)

* Push your repository to GitHub on the `devel` branch.

* The GitHub Action defined in the
  [workflows folder](./.github/workflows/buildpush.yml) will trigger
  automatically on pushes to the `devel` branch. It will log in to `ghcr.io`
  automatically using the run credentials, build the image, and push it to the
  registry.

* To make the package public (allowing anyone to pull it without authentication):
  - Go to your GitHub Profile → **Packages**.
  - Select the `templatedockershiny` package.
  - Go to **Package settings**.
  - Scroll down to the bottom, click **Change visibility**, change it to **Public**, and confirm.

# Running the published container

```bash
docker run -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output ghcr.io/<your_github_username>/templatedockershiny:latest
```


