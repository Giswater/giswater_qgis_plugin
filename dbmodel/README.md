<div align="center">
	<h1>Giswater DB Model</h1>
	<a href="https://github.com/Giswater/giswater_dbmodel">
		<img alt="Giswater Dbmodel Badge" src="https://img.shields.io/badge/GISWATER-DBMODEL-blue?style=for-the-badge&logo=postgresql&logoColor=ffffff">
	</a>
	<a href="./LICENSE">
		<img alt="LICENSE" src="https://img.shields.io/github/license/giswater/giswater_dbmodel?style=for-the-badge">
	</a>
	<a href="https://github.com/Giswater/giswater_dbmodel/actions/workflows/ci_test_ud_db.yml">
		<img alt="CI Testing UD" src="https://img.shields.io/github/actions/workflow/status/giswater/giswater_dbmodel/ci_test_ud_db.yml?branch=dev-4.0&style=for-the-badge&label=TEST%20UD">
	</a>
	<a href="https://github.com/Giswater/giswater_dbmodel/actions/workflows/ci_test_ws_db.yml">
		<img alt="CI Testing WS" src="https://img.shields.io/github/actions/workflow/status/giswater/giswater_dbmodel/ci_test_ws_db.yml?branch=dev-4.0&style=for-the-badge&label=TEST%20WS">
	</a>
</div>

**Giswater** revolutionizes water management by simplifying the planning and control of water supply networks without costly investments. Since its launch in 2014, Giswater is the first open-source software designed for integrated water management, connecting IT solutions and databases for high-performance management systems. It integrates seamlessly with hydraulic modeling software like **EPANET** and **SWMM**, making it indispensable for professionals and organizations in water management.

### Features

- Open-source tool for complete water cycle management.
- Works with hydraulic tools (**EPANET**, **EPA SWMM**) and GIS systems.
- Integrates with business management tools (ERP, CRM, BI).
- Compatible with Windows, Mac, and Linux (for most features)

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Testing](#testing)
4. [Deployment](#deployment)
5. [Wiki](#wiki)
6. [FAQ](#faqs)
7. [Repositories](#repositories)
8. [Versioning](#versioning)
9. [License](#license)
10. [Acknowledgements](#acknowledgements)

## Requirements

To use Giswater, you need:

- **PostgreSQL**: Ensure pgAdmin/dbeaver (DB manager) and PostGIS (spatial extension) are installed.
- **QGIS**: Geoprocessing software for frontend use.

## Installation

Giswater is a client-server system requiring installation on both the backend and frontend.

### Backend Environment:

- Compatible with Windows, Mac, and Linux.
- Install **PostgreSQL** (versions 9.5 to 14).
- Enable the following extensions:

```postgres
CREATE EXTENSION postgis;
CREATE EXTENSION pgrouting;
CREATE EXTENSION tablefunc;
CREATE EXTENSION unaccent;
```

### Frontend Environment:

- Compatible with Windows, Mac, and Linux. **EPA models** work best on Windows.
- Install **QGIS** (latest LTR version).
- Install **SWMM** (5.1) and **EPANET** (2.2). Note: EPA models may not work fully on Linux.

## Testing

Example projects with integrated datasets are available to test the system. Check out these tutorial videos to set up your environment:

1. [Install plugin](https://www.youtube.com/watch?v=EwDRoHY2qAk&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=4)
2. [Setup connection](https://www.youtube.com/watch?v=LJGCUrqa0es&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=3)
3. [Create DB schema example](https://www.youtube.com/watch?v=nR3PBtfGi9k&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=2)
4. [Create QGIS project](https://www.youtube.com/watch?v=RwFumKKTB2k&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=1)

## Deployment

### Prerequisites:

- Ensure you have PostgreSQL access with DB superuser permissions for tasks like schema creation, roles, backups, and restoration.

### Mandatory Project Setup:

- Fill required catalogs: **materials**, **node**, and **arc**.
- Define **inventory layers** (network shapes) with required fields.
- Set up **mapzones**: e.g., macroexploitation, municipality, sector.

Start by creating two nodes; then, insert arcs. For configuration options, visit the [Giswater configuration guide](https://github.com/Giswater/giswater_dbmodel/wiki/Config).

### Getting Started:

- [Start from scratch](https://github.com/Giswater/giswater_dbmodel/wiki/Start-from-Scratch:-Installing-Giswater-and-steps-to-create-an-empty-project).
- Optionally, load INP files (in beta). See more about [Import INP debug mode](https://github.com/Giswater/giswater_dbmodel/wiki).

## Wiki

For comprehensive documentation, visit the [Giswater Wiki](https://github.com/Giswater/giswater_dbmodel/wiki).

## FAQs

Check out the [FAQs section](https://github.com/Giswater/giswater_dbmodel/wiki/FAQs) for common questions.

## Repositories

- **Docs**: [Giswater Docs](https://github.com/Giswater/docs)
- **QGIS Plugin**: [Giswater QGIS Plugin](https://github.com/Giswater/giswater_qgis_plugin)
- **Database Model**: [Giswater DB Model](https://github.com/Giswater/giswater_dbmodel)

Other repositories are either deprecated or not in use.

## Versioning

Giswater follows a three-tier release system: **Major**, **Minor**, and **Build** updates.

- **Major**: Architecture updates (not backward compatible).
- **Minor**: Bug fixes, new functionalities (backward compatible).
- **Build**: Small fixes, monthly releases.

## License

This software is licensed under the **GNU General Public License v3.0**. See the [LICENSE](LICENSE) file for more details.

## Acknowledgements

Special thanks to the following partners for their contributions:

- GITS-BarcelonaTech University
- Aigües de Mataró
- Aigües de Girona
- Aigües de Blanes
- Aigües del Prat
- Aigües de Vic
- Aigües de Castellbisbal
- Aigües de Banyoles
- Figueres de Serveis, S.A
- Prodaisa
- Sabemsa
- Consorci Aigües de Tarragona
