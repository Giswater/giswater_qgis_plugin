/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/12/14
UPDATE cat_dwf_scenario SET active = TRUE WHERE active IS NULL;
UPDATE cat_hydrology SET active = TRUE WHERE active IS NULL;
UPDATE cat_mat_grate SET active = TRUE WHERE active IS NULL;
UPDATE cat_mat_gully SET active = TRUE WHERE active IS NULL;


UPDATE config_form_fields SET dv_querytext = concat(dv_querytext, ' AND active IS TRUE ')
WHERE columnname IN ('gratecat_id') AND ( formname ilike 've_gully%' OR formname in ('v_edit_gully'))and dv_querytext is not null;