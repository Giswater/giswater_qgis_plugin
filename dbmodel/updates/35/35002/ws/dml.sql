/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/09/30
UPDATE sys_table SET sys_sequence = 'cat_mat_roughness_id_seq' where id = 'cat_mat_roughness';

--2020/12/14
UPDATE cat_mat_roughness SET active = TRUE WHERE active IS NULL;

--2020/12/15
UPDATE dqa SET active = TRUE WHERE active IS NULL;
UPDATE macrodqa SET active = TRUE WHERE active IS NULL;
UPDATE presszone SET active = TRUE WHERE active IS NULL;


UPDATE config_form_fields SET dv_querytext = concat(dv_querytext, ' AND active IS TRUE ')
WHERE columnname IN ('dqa_id', 'presszone_id','macrodqa_id') AND
(formname ilike 've_arc%' OR formname ilike 've_node%' OR formname ilike 've_connec%' OR formname ilike 've_gully%' 
OR formname in ('v_edit_element','v_edit_node','v_edit_arc','v_edit_connec','v_edit_gully') and dv_querytext is not null;