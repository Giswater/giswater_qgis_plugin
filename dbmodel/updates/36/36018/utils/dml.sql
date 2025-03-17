/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system SET 
value = '{"table":"temp_municipality","selector":"selector_municipality","table_id":"muni_id","selector_id":"muni_id","label":"muni_id, ''-'', name","orderBy":"muni_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(muni_id, ' - ', name))","selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}'
WHERE parameter = 'basic_selector_tab_municipality';


