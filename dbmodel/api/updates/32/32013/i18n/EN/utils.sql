
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_api_form_tabs SET tablabel = 'Network', tabtext = 'Network' WHERE formname ='search' AND tabname = 'tab_network';
UPDATE config_api_form_tabs SET tablabel = 'Visit', tabtext = 'Visit' WHERE formname ='search' AND tabname = 'tab_visit';
UPDATE config_api_form_tabs SET tablabel = 'Address', tabtext = 'Address' WHERE formname ='search' AND tabname = 'tab_address';
UPDATE config_api_form_tabs SET tablabel = 'Psector', tabtext = 'Psector' WHERE formname ='search' AND tabname = 'tab_psector';
UPDATE config_api_form_tabs SET tablabel = 'Hydrometer', tabtext = 'Hydro' WHERE formname ='search' AND tabname = 'tab_hydro';
UPDATE config_api_form_tabs SET tablabel = 'Workcat', tabtext = 'Workcat' WHERE formname ='search' AND tabname = 'tab_workcat';

UPDATE config_api_form_tabs SET tablabel = 'Network', tabtext = 'Network' WHERE formname ='filters' AND tabname = 'tabNetworkState';
UPDATE config_api_form_tabs SET tablabel = 'Exploitation', tabtext = 'Active exploitation' WHERE formname ='filters' AND tabname = 'tabExploitation';
UPDATE config_api_form_tabs SET tablabel = 'Hydrometer', tabtext = 'Hydrometer' WHERE formname ='filters' AND tabname = 'tabHydroState';

UPDATE config_api_form_tabs SET tablabel = 'Data', tabtext = 'Data' WHERE formname ='lot' AND tabname = 'tabData';

UPDATE config_api_form_tabs SET tablabel = 'Data', tabtext = 'Data' WHERE formname ='visit' AND tabname = 'tabData';

UPDATE config_api_form_tabs SET tablabel = 'General data', tabtext = 'Data' WHERE formname ='visitManager' AND tabname = 'tabData';
UPDATE config_api_form_tabs SET tablabel = 'Executed visits', tabtext = 'Visit' WHERE formname ='visitManager' AND tabname = 'tabData';
UPDATE config_api_form_tabs SET tablabel = 'Work orders', tabtext = 'Lot' WHERE formname ='visitManager' AND tabname = 'tabData';

UPDATE config_api_form_tabs SET tabtext = 'List of documents' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_documents';
UPDATE config_api_form_tabs SET tabtext = 'List of hydrometers' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_hydrometer';
UPDATE config_api_form_tabs SET tabtext = 'List of events' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_visit';
UPDATE config_api_form_tabs SET tabtext = 'List of events' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_om';
UPDATE config_api_form_tabs SET tabtext = 'List of consumption values' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_hydrometer_val';
UPDATE config_api_form_tabs SET tabtext = 'List of costs' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_plan';
UPDATE config_api_form_tabs SET tabtext = 'List of related elements' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_elements';