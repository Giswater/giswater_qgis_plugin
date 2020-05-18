/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 09/10/2019 (due this bug was fixed on 3.3.002 delta files after release, it's mantadoty to be fixed again)
UPDATE config_api_form_fields SET widgettype='typeahead', dv_querytext = 'SELECT pol_id AS id, pol_id AS idval FROM polygon WHERE pol_id is not null ', 
typeahead='{"fieldToSearch": "pol_id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id = 'pol_id';

UPDATE config_api_form_fields set dv_querytext='SELECT connec_id, connec_id as idval FROM connec WHERE connec_id IS NOT NULL',
typeahead = '{"fieldToSearch": "connec_id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' where  column_id = 'linked_connec';

-- 09/10/2019
UPDATE config_api_form_fields SET datatype='double' WHERE datatype ='numeric';