/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_api_form_tabs SET tablabel = 'Red', tabtext = 'Red' WHERE formname ='search' AND tabname = 'tab_network';
UPDATE config_api_form_tabs SET tablabel = 'Visita', tabtext = 'Visita' WHERE formname ='search' AND tabname = 'tab_visit';
UPDATE config_api_form_tabs SET tablabel = 'Dirección', tabtext = 'Dirección' WHERE formname ='search' AND tabname = 'tab_address';
UPDATE config_api_form_tabs SET tablabel = 'Psector', tabtext = 'Psector' WHERE formname ='search' AND tabname = 'tab_psector';
UPDATE config_api_form_tabs SET tablabel = 'Abonado', tabtext = 'Abonado' WHERE formname ='search' AND tabname = 'tab_hydro';
UPDATE config_api_form_tabs SET tablabel = 'Workcat', tabtext = 'Expediente' WHERE formname ='search' AND tabname = 'tab_workcat';


UPDATE config_api_form_tabs SET tablabel = 'Red', tabtext = 'Elementos de red' WHERE formname ='filters' AND tabname = 'tabNetworkState';
UPDATE config_api_form_tabs SET tablabel = 'Explotación', tabtext = 'Explotaciones activas' WHERE formname ='filters' AND tabname = 'tabExploitation';
UPDATE config_api_form_tabs SET tablabel = 'Abonado', tabtext = 'Abonado' WHERE formname ='filters' AND tabname = 'tabHydroState';

UPDATE config_api_form_tabs SET tablabel = 'Datos', tabtext = 'Datos' WHERE formname ='lot' AND tabname = 'tabData';

UPDATE config_api_form_tabs SET tablabel = 'Datos', tabtext = 'Datos' WHERE formname ='visit' AND tabname = 'tabData';

UPDATE config_api_form_tabs SET tablabel = 'Datos generales', tabtext = 'Datos' WHERE formname ='visitManager' AND tabname = 'tabData';
UPDATE config_api_form_tabs SET tablabel = 'Visitas realizadas', tabtext = 'Visita' WHERE formname ='visitManager' AND tabname = 'tabData';
UPDATE config_api_form_tabs SET tablabel = 'Orden de trabajo', tabtext = 'Lot' WHERE formname ='visitManager' AND tabname = 'tabData';

