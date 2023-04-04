/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"expl_id2", "dataType":"integer"}}$$);

CREATE INDEX IF NOT EXISTS gully_exploitation2 ON gully USING btree (expl_id2 ASC NULLS LAST) TABLESPACE pg_default;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3216, 'gw_fct_calculate_sander', 'ud', 'function', 'json', 'json', 'Function that calculates the depth of sander depending on node sys_ymax and arc sys_y1' , 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3224, 'gw_trg_edit_hydrology', 'ud', 'trigger function', null, null, 'Trigger that allows editing data using v_edit_cat_hydrology view.' , 'role_epa', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3226, 'gw_trg_edit_inp_gully', 'ud', 'trigger function', null, null, 'Trigger that allows editing data using v_edit_inp_gully view.' , 'role_epa', null, 'core') ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('v_state_link_gully', 'View that filters links related to gully by state and exploitation', 'role_basic', 'core') ON CONFLICT(id) DO NOTHING;