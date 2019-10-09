/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 08/10/2019
update config_api_form_fields set ismandatory = false where column_id='private_connecat_id';

UPDATE config_api_form_fields SET widgettype='typeahead', dv_querytext = 'SELECT pol_id AS id, pol_id AS idval FROM polygon WHERE pol_id is not null ', 
typeahead='{"fieldToSearch": "pol_id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id = 'pol_id';


UPDATE  config_api_form_fields SET widgettype='typeahead', dv_querytext = 'SELECT id, id as idval FROM cat_grate WHERE id IS NOT NULL', isreload = false,
typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id = 'gratecat_id';
