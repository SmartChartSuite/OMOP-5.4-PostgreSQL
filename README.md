# OMOP CDM 5.4 PostgreSQL Image (DEV DATABASE)

This repository hosts the files needed to build an OMOP Common Data Model database using version 5.4 and PostgreSQL. This image is a simple build intended to support SmartChartSuite applications but may be used more generally.

This database does not come pre-loaded with Athena Vocabulary.

## Environment Variables and Ports

### Base Postgres Image
This image is built from the base PostgreSQL image and has the same options and requirements. In practice, this typically means you must define a POSTGRES_PASSWORD. The port handling is likewise identical, using an internal port of 5432.

### Constraint SQL Scripts
This project provides for a CONSTRAINTS variable which controls which scripts are ran. The default approach only runs the core OMOP 5.4 tables DDL. Setting CONSTRAINTS to "true" (case sensitive string) will load all 4 scripts. If the environment variable is not present or is set to any other value the default approach is used and constraints will not be loaded.

This allows for more control over your deployment in order to speed up importing vocabulary or working in DEV environments. For example, you may wish to build the database with constraints and keys disabled, load the vocabulary, and then manually run the other SQL files afterwards to speed up the complete process.

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
```