/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields
SET dv_querytext='SELECT name as id, name as idval FROM v_cat_hydrometer_state WHERE id IS NOT NULL'
WHERE formname='connec' AND formtype='form_feature' AND columnname='cmb_hydrometer_state' AND tabname='tab_hydrometer';
UPDATE config_form_fields SET linkedobject = REPLACE(linkedobject, 'v_ui_hydrometer', 'vf_hydrometer') WHERE linkedobject ILIKE '%v_ui_hydrometer%';
UPDATE config_form_list SET query_text = REPLACE(query_text, 'v_ui_hydroval', 've_hydrometer_data') WHERE query_text ILIKE '%v_ui_hydroval%';
