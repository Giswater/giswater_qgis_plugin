## WELCOME TO GISWATER PROJECT-QGIS PLUGIN

Water management has always been complex and expensive. It has always been difficult to plan new water supply networks or effective control existing ones without making further capital investments. Nonetheless all these situations have come to an end. Since 2014 when GISWATER was born, it have been the first open source software specifically designed for water supply and water management. <br>

This software connects different IT solutions and pre-existent databases allowing you to setup a high performance management system in combination with hydraulic software as well EPANET or SWMM.<br>

GISWATER is the first open source tool for the integral water cycle management. It was especially developed and designed for city councils, municipality administrations, water and sewerage services concessionary companies and hydraulic professionals. Giswater is a driver that connects different hydraulic analysis tools and spatial database through which the user 
has access from any geographic information system (GIS). It is compatible with all the elements that compose a water supply or sewerage management system like EPANET, EPA SWMM, GIS, WMS or SCADA and therefore it can be incorporated to the informatic ecosystem of any entity or company dedicated to water management and multiply its benefits.<br>

It is also possible to integrate business management tools like ERP, CRM or Business Intelligence and also corporate mobile devices.<br>

As well as Giswater is developed in Python (qgis plugin) and PL/SQL(PostgreSQL database) there are three main repositories to manage it (QGIS-PLUGIN, DB-MODEL and DOCS). Right now this is the repository for the QGIS-PLUGIN.


## TABLE OF CONTENTS
Here after you will find all the information you need to getting started with Giswater<br>

	1- Requirements
	2- Install
	3- Test
	4- Deployment
	5- Wiki
	6- FAQ's
	7- Code repositories
	8- Versioning
	9- License
	10- Thanks to
	

## REQUIREMENTS
To work with Giswater you will need at least 2 programs:

PostgreSQL: Installation process must include the selection pgAdmin component (Data Base Manager) and Postgis application (Spatial Extension)<br>
QGIS: Geoprocessing software<br>
<br>
If you didn't install QGIS using the standalone installer, you may need to install the matplotlib python library manually.

## INSTALL
As Giswater is as server-client software you need to install it into two separate environments.

### Backend environment:
Works as well on Windows, MaC or Linux O/S.<br>
Install PostgreSQL (from 9.5 to 14).<br>
Install Postgis, pgrouting, tablefunc and unaccent extensions for PostgreSQL.<br>
	`create extension postgis;`<br>
	`create extension pgrouting;`<br>
	`create extension tablefunc;`<br>
	`create extension unaccent;`<br>

### Frontend environment:
Works as well on Windows, MaC or Linux O/S, but only on Windows to enjoy EPA models.<br>
Install QGIS  (always last LTR)<br>
Install SWMM (5.1) and EPANET (2.2) ->If uses linux on front-end EPANET and SWMM will not work properly.<br>


## TEST
You can use the example projects, ready to test with lots of dataset integrated.<br>
Here below you can find videos to setup your environment and work with sample data:<br>

Install plugin:https://www.youtube.com/watch?v=EwDRoHY2qAk&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=4<br>

Setup connection :https://www.youtube.com/watch?v=LJGCUrqa0es&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=3<br>

Create db schema example:https://www.youtube.com/watch?v=nR3PBtfGi9k&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=2<br>

Create qgis project:https://www.youtube.com/watch?v=RwFumKKTB2k&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=1<br>


## DEPLOYMENT

### Requirements:
You need to have permissions to connect to postgreSQL database (compatible versions) and your user need to be a db superuser in order to be allowed to create project schemas, roles, backups, restores among others db admin operations.

### Mandatory information for the project:
Project works with catalogs and you need to fill at least the mandatory ones [materials, node, arc].<br>
The Inventory Layers are network shape layers, which also includes some mandatory and optional fields that you must know.<br>
Project also uses mapzones and you need to create at least the mandatory ones [macroexplotation, exploitation, municipality, sector, dma].<br>
Finally, you need to know mains about the selectors strategy of Giswater<br>
To start now, take a look on Start from scratch and enjoy it!<br>
Another option is start with Giswater loading inp file. Although this is a beta functionality, you can take a look on Import inp file debug mode for more info!

### Useful tips:
With mapzones and catalogs well-defined (at least the mandatory ones) you can insert your first two nodes. After that arc can be inserted too. <br>
You can get more information for  about config options here:<br>
	https://github.com/Giswater/giswater_dbmodel/wiki/Config

### Start from scratch;
Here you can find more information with the steps to create an empty project<br>
	https://github.com/Giswater/giswater_dbmodel/wiki/Start-from-Scratch:-Installing-Giswater-and-steps-to-create-an-empty-project

## WIKI
You can find more information on https://github.com/Giswater/giswater_dbmodel/wiki

## FAQ's
You can find the Frequent Answers and Questions for project on https://github.com/Giswater/giswater_dbmodel/wiki/FAQs

## CODE REPOSITORY
Use the https://github.com/Giswater/docs repository to find some info about DOCS<br>
Use the https://github.com/Giswater/giswater_qgis_plugin repository to find some info about PYTHON QGIS PLUGIN.<br>
Use the https://github.com/Giswater/giswater_dbmodel repository to find some info about DATABASE MODEL.<br>
Rest of repositories are no significant. Some of them they are deprecated or some of them are not used yet.

## VERSIONING
Giswater works using three degrees of releases wich it means that the number three codes:
	Major. Minor. Built

Major: New architecture with new great functionalities without forward compatibility.<br>
Minor: Bug fix and new great functionalities (including refactors) with forward compatibility.<br>
Built: Bug fix and new little functionalities with forward compatibility.<br>

The time-period for built releases is one-per-month (12 builts / year).<br>
The time-period for minor releases is one-per-year (1 minor / year).<br>
There is no time-period defined for major releases.<br>


## LICENSE
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. See LICENSE file for more information.


## THANKS TO
GITS-BarcelonaTech University<br>
Aigües de Mataró<br>
Aigües de Girona<br>
Aigües de Blanes<br>
Aigües del Prat<br>
Aigües de Vic<br>
Aigües de Castellbisbal<br>
Aigües de Banyoles<br>
Figueres de Serveis, S.A<br>
Prodaisa<br>
Sabemsa<br>
Consorci Aigües de Tarragona<br>

