# OMOP CDM 5.4 PostgreSQL Image (DEV DATABASE)

This repository hosts the files needed to build an OMOP Common Data Model database using version 5.4 and PostgreSQL. This image is a simple build intended to support SmartChartSuite applications but may be used more generally.

This database does not come pre-loaded with Athena Vocabulary.

## Environment Variables and Ports

### Base Postgres Image
This image is built from the base PostgreSQL image and has the same options and requirements. In practice, this typically means you must define a POSTGRES_PASSWORD. The port handling is likewise identical, using an internal port of 5432.


### Constraint SQL Scripts
This project provides for a CONSTRAINTS variable which controls which scripts are ran. The default approach only runs the core OMOP 5.4 tables DDL. Setting CONSTRAINTS to "true" (case sensitive string) will load all 4 scripts. If the environment variable is not present or is set to any other value the default approach is used and constraints will not be loaded.

This allows for more control over your deployment in order to speed up importing vocabulary or working in DEV environments. For example, you may wish to build the database with constraints and keys disabled, load the vocabulary, and then manually run the other SQL files afterwards to speed up the complete process.


## Athena Vocabulary
If you wish to preload vocabulary from Athena, you may mount a volume to the container's `/VOCAB` folder. As of this version, the approach is to this not flexible and expects all 8 CSVs provide by Athena to exist.

Athena can be accessed at [https://athena.ohdsi.org/].


## Example Deployment using Compose
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
    volumes:
      - ./vocab:/VOCAB
```

For this deployment, constraint scripts will be ran and the local environment's `./vocab` folder (from the context of the build directory containing the `docker-compose.yml`) will be mapped to the `/VOCAB` folder inside of the container. If the folder contains Vocabularly CSVs from Athena, they will be loaded on database start.