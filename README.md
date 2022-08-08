# OMOP CDM 5.4 PostgreSQL Image (DEV DATABASE)

This repository hosts the files needed to build an OMOP Common Data Model database using version 5.4 and PostgreSQL. This image is a simple build intended to support SmartChartSuite applications but may be used more generally.

This database does not come pre-loaded with Athena Vocabulary, but a volume containing vocabulary may be mounted into the container and loaded at run time.

## Environment Variables and Ports

### Base Postgres Image
This image is built from the base PostgreSQL image and has the same options and requirements. In practice, this typically means you must define a POSTGRES_PASSWORD. The port handling is likewise identical, using an internal port of 5432.


### Constraint SQL Scripts
This project provides for a CONSTRAINTS variable which controls which scripts are ran. The default approach only runs the core OMOP 5.4 tables DDL. Setting CONSTRAINTS to "true" (case sensitive string) will load all 4 scripts. If the environment variable is not present or is set to any other value the default approach is used and constraints will not be loaded.

This allows for more control over your deployment in order to speed up importing vocabulary or working in DEV environments. For example, you may wish to build the database with constraints and keys disabled, load the vocabulary, and then manually run the other SQL files afterwards to speed up the complete process.


## Athena Vocabulary
If you wish to preload vocabulary from Athena, you may mount a volume to the container's `/VOCAB` folder. As of this version, the approach is to this not flexible and expects all 8 CSVs provide by Athena to exist.

Athena can be accessed at [https://athena.ohdsi.org/].

## OMOP on FHIR
In addition to the core OMOP CDM tables, users may opt to include extended tables and views needed to support an OMOP-on-FHIR server. For more information on OMOP-on-FHIR, please visit https://github.com/omoponfhir/omoponfhir-site-n-docs/wiki.

## Deployment using Compose
The `docker-compose.yml` provides for an example and quick deployment setting the environment variables.

```
version: "3.9"

services:
  omop54:
    build: .
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_PASSWORD=password
      - CONSTRAINTS=true
      - OMOP_ON_FHIR=false
    volumes:
      - ./vocab:/VOCAB
```

For this deployment, constraint scripts will be ran and the local environment's `./vocab` folder (from the context of the build directory containing the `docker-compose.yml`) will be mapped to the `/VOCAB` folder inside of the container. If the folder contains Vocabularly CSVs from Athena, they will be loaded on database start.

## Deployment using Docker Build and Docker Run

To run the image outside of a compose, you will first need to build the image using `docker build` and then run it using `docker run`. As all of the environment variables and mounted vocabulary (if any) should be provided at run time, you will be providing these in the `docker run` step.

To begin, you will need to have this project cloned, and then build from within the project directory using the following command:
```
docker build -t omop54 .
```

This will tag the image (`-t`) as "omop54" and provide `.` (the current directory) as the build context.

From there you may execute the run step, passing in desired arguments. As mentioned previously, the `POSTGRES_PASSWORD` is required to be set by the base Postgres image.

The following version of the `docker run` command will provide everything, using the built image. We will break this down in a moment.
```
docker run -e POSTGRES_PASSWORD=password -e CONSTRAINTS=true -v /path/to/your/vocab:/VOCAB omop54
```
To begin, please note that each environment variable must be set individually. That is, a separate `-e` flag for both `POSTGRES_PASSWORD` and `CONSTRAINTS`. If you do not with to run with constraints enabled, you may omit this variable entirely or set it to any other value (e.g. "false").

The `-v` flag provides volume mounting from your host system into the container to provide your Athena vocabulary files if you wish to use them. If you do not wish to load vocabulary, you may omit this entire argument. Note that this requires the use of the full absolute path to your host system's directory containing your vocabulary. (Hint: The `pwd` command in a linux terminal will give you your current full path.) The directory inside the container is read by the script statically and it **must** be set to `/VOCAB`.

Lastly, the image we previously built, which was tagged "omop54", is specified.