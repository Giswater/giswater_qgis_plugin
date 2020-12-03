/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



UPDATE gully_type SET active = TRUE WHERE active IS NULL;

-- 08/10/2019
UPDATE  config_api_form_fields SET widgettype='typeahead', dv_querytext = 'SELECT id, id as idval FROM cat_grate WHERE id IS NOT NULL', isreload = false,
typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id = 'gratecat_id';
