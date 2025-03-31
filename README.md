<div align="center">
	<a href="https://www.giswater.org/">
		<picture>
		<img alt="Giswater logo" src="./icons/dialogs/136.png" height="128">
		</picture>
	</a>
	<h1>Giswater</h1>
	<a href="https://qgis.org/"><img src="https://img.shields.io/badge/qgis-3.34%20(LTR)%20-blue.svg?style=for-the-badge&logo=qgis&logoColor=white"></a>
  	<a href="https://www.python.org/"><img src="https://img.shields.io/badge/python-3.9-blue.svg?style=for-the-badge&logo=python&logoColor=white"></a>
	<a href="https://www.postgresql.org/"><img src="https://img.shields.io/badge/postgresql-9.5|16-blue.svg?style=for-the-badge&logo=postgresql&logoColor=white"></a>
	<a href="./LICENSE"><img alt="LICENSE" src="https://img.shields.io/github/license/giswater/giswater_qgis_plugin?style=for-the-badge"></a>
</div>

## Welcome to the Giswater Project - QGIS Plugin

Water management has traditionally been complex and costly, making it difficult to efficiently plan or control water supply networks without further investments. However, with the inception of Giswater in 2014, the first open-source software specifically designed for water supply and water management, this complexity is now manageable.

Giswater integrates various IT solutions and pre-existing databases, enabling high-performance management systems combined with hydraulic software such as EPANET and SWMM.

Giswater is the first open-source tool for integral water cycle management, created for city councils, municipal administrations, water and sewerage service providers, and hydraulic professionals. As a driver, it connects hydraulic analysis tools and spatial databases, allowing user access from any GIS. Compatible with EPANET, EPA SWMM, GIS, WMS, SCADA, and more, Giswater integrates seamlessly into water management entities’ ecosystems, amplifying their operational capabilities.

Additionally, Giswater can be connected with business management tools like ERP, CRM, Business Intelligence software, and corporate mobile devices.

Developed in Python (QGIS plugin) and PL/SQL (PostgreSQL database), the project is organized across three main repositories: `QGIS-PLUGIN`, `DB-MODEL`, and `DOCS`.

---

## Table of Contents

1. [Requirements](#requirements)
2. [Install](#install)
3. [Test](#test)
4. [Deployment](#deployment)
5. [Wiki](#wiki)
6. [FAQ](#faqs)
7. [Code Repositories](#code-repositories)
8. [Versioning](#versioning)
9. [Third-Party Libraries](#third-party-libraries)
10. [License](#license)
11. [Acknowledgments](#acknowledgments)

---

## Requirements

To work with Giswater, you will need:

- **PostgreSQL**: Ensure to select the pgAdmin component (Database Manager) and PostGIS (Spatial Extension) during installation.
- **QGIS**: Required geoprocessing software.

## Install

Since Giswater functions as server-client software, installation is done across two environments.

### Backend Environment

Compatible with Windows, Mac, and Linux OS.

- Install PostgreSQL (versions 9.5 to 17).
- Install PostGIS, pgRouting, and other required PostgreSQL extensions:

  ```postgresql
  CREATE EXTENSION postgis;
  CREATE EXTENSION pgrouting;
  CREATE EXTENSION tablefunc;
  CREATE EXTENSION unaccent;
  CREATE EXTENSION postgis_raster;
  CREATE EXTENSION fuzzystrmatch;
  ```

### Frontend environment:

Compatible with Windows, Mac, and Linux, but EPA models are only supported on Windows.

- Install the latest Long-Term Release (LTR) of QGIS.
- Install SWMM (5.1) and EPANET (2.2). _Note_: EPA SWMM and EPANET may not work on Linux front-end environments.

## Test

Use the provided example projects, pre-loaded with datasets for testing. Find setup videos below:

- [Install the plugin](https://www.youtube.com/watch?v=EwDRoHY2qAk&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=4)
- [Setup connection](https://www.youtube.com/watch?v=LJGCUrqa0es&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=3)
- [Create DB schema example](https://www.youtube.com/watch?v=nR3PBtfGi9k&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=2)
- [Create QGIS project](https://www.youtube.com/watch?v=RwFumKKTB2k&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=1)

## Deployment

### Requirements

Ensure you have the permissions to connect to PostgreSQL and that your user has superuser rights for database administration tasks (e.g., creating schemas, roles, backups).

### Project Setup

- Define catalogs with at least the mandatory categories ([materials, node, arc]) and create map zones ([macroexploitation, exploitation, municipality, sector, dma]).
- To get started, refer to [Start from Scratch](https://github.com/Giswater/giswater_dbmodel/wiki/Start-from-Scratch:-Installing-Giswater-and-steps-to-create-an-empty-project) for guidance.
- **Tip**: Once map zones and catalogs are defined, you can begin adding network nodes and arcs.

For more configuration options, see the [Giswater configuration guide](https://github.com/Giswater/giswater_dbmodel/wiki/Config).

## Wiki

Explore additional documentation on the [Giswater Wiki](https://github.com/Giswater/giswater_dbmodel/wiki).

## FAQs

Find answers to common questions in the [Giswater FAQs](https://github.com/Giswater/giswater_dbmodel/wiki/FAQs).

## Code Repositories

- **Docs**: [Documentation repository](https://github.com/Giswater/docs)
- **QGIS Plugin**: [QGIS Plugin repository](https://github.com/Giswater/giswater_qgis_plugin)
- **Database Model**: [Database Model repository](https://github.com/Giswater/giswater_dbmodel)

Other repositories may exist but are either deprecated or inactive.

## Versioning

Giswater follows a three-level release system:

- **Major**: New architecture with significant updates (no forward compatibility).
- **Minor**: Bug fixes and new features (forward compatible).
- **Build**: Minor fixes and updates (forward compatible).

Release frequency:

- **Build**: Monthly (12 builds/year)
- **Minor**: Annually
- **Major**: No fixed schedule

## Third-Party Libraries

Giswater uses the following third-party libraries:

- **WNTR**: [WNTR GitHub](https://github.com/USEPA/WNTR)
  WNTR is an open-source Python package for analyzing water distribution systems using hydraulic and water quality models.
  The WNTR license can be found in the [LICENSE](./packages/wntr/LICENSE.md) file or in their [repository](https://github.com/USEPA/WNTR/blob/main/LICENSE.md).

- **swmm-api**: [swmm-api GitLab](https://gitlab.com/markuspichler/swmm_api)
  swmm-api provides a Pythonic interface to the EPA SWMM5 software, enabling advanced scripting, simulation control, and access to simulation results.
  The license and further details can be found in the [LICENSE](./packages/swmm_api/LICENSE) or in their [repository](https://gitlab.com/markuspichler/swmm_api/-/blob/master/LICENSE).

- **tqdm**: [tqdm GitHub](https://github.com/tqdm/tqdm)
  tqdm is a fast, extensible progress bar library for Python, supporting console, GUI, and notebook environments.
  The tqdm license can be viewed in the [LICENSE](./packages/tqdm/LICENCE) or in their [repository](https://github.com/tqdm/tqdm/blob/master/LICENCE).

- **PyPDF2**: [PyPDF2 GitHub](https://github.com/py-pdf/pypdf)
  PyPDF2 is a Python library for working with PDF files, offering functionalities such as splitting, merging, and text extraction.
  The PyPDF2 license is available in the [LICENSE](./packages/PyPDF2/LICENSE) or in their [repository](https://github.com/py-pdf/pypdf/blob/main/LICENSE).

- **osmnx**: [OSMnx GitHub](https://github.com/gboeing/osmnx)
  OSMnx is a Python package to easily download, model, analyze, and visualize street networks and other geospatial features from OpenStreetMap. You can download and model walking, driving, or biking networks with a single line of code then analyze and visualize them. You can just as easily work with urban amenities/points of interest, building footprints, transit stops, elevation data, street orientations, speed/travel time, and routing.
  The OSMnx license can be viewed in the [LICENSE](./packages/osmnx/LICENSE.txt) or in their [repository](https://github.com/gboeing/osmnx/blob/main/LICENSE.txt)

## License

This program is free software, licensed under the GNU General Public License (GPL) version 3 or later. Refer to the [LICENSE](./LICENSE) file for details.

## Acknowledgments

Special thanks to our founding contributors:

- GITS-BarcelonaTech University
- Aigües de Mataró
- Cicle de l'Aigua del Ter S.A
- Aigües de Blanes
- Aigües del Prat
- Aigües de Vic
- Aigües de Castellbisbal
- Aigües de Banyoles
- Figueres de Serveis, S.A
- Prodaisa
- Sabemsa
- Consorci Aigües de Tarragona
- BGEO OPEN GIS S.L.
