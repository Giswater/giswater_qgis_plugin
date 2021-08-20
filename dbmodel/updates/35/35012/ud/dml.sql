/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/08/19
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '1', '1D SWMM');
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '2', '1D/2D SWMM-IBER');

INSERT INTO sys_param_user(id, formname, descript, sys_role,  label, isenabled, layoutorder, project_type, isparent, vdefault, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, epaversion)
VALUES ('inp_options_networkmode', 'epaoptions', 'Export geometry mode (1-standard, 2-trim arcs with gullies)', 'role_epa', 'Network geometry generator:', TRUE, 0, 'ud', FALSE, '1', 
FALSE, 'text','combo', TRUE, 'lyt_general_1',TRUE, '{"from":"5.0.022", "to":null,"language":"english"}') 
ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_function VALUES (3070, 'gw_fct_pg2epa_vnodetrimarcs', 'ud', 'function', 'text', 'json' 'Function to trim arcs using gullies', 'role_epa')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (3072, 'gw_trg_edit_inp_gully', 'ud', 'trigger function', null, null, 'role_epa')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (inp_gully)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (temp_gully);
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (v_edit_inp_gully);
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (vi_gully);
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_fprocess (141,'vi_gully', '[GULLY]', NULL, 99);
ON CONFLICT (fid, tablename) DO NOTHING;