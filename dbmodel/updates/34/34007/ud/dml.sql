/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



DELETE FROM audit_cat_param_user WHERE id = 'inp_options_debug';
INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, label, isenabled, project_type, isparent , isautoupdate, datatype, widgettype,
vdefault,ismandatory, isdeprecated) VALUES 
('inp_options_debug', 'hidden_value', 'Additional settings for go2epa', 'role_epa', 'Additional settings for go2epa', true, 'ws', false, false, 'text', 'linetext', 
'{"showLog":false, "onlyExport":false, "checkData":true, "checkNetwork":true, "checkResult":true, "onlyIsOperative":true, "delDisconnNetwork":true}',
true, false);


INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, label, isenabled, project_type, isparent , isautoupdate, datatype, widgettype,
vdefault,ismandatory, isdeprecated) VALUES 
('inp_options_advancedsettings', 'hidden_value', 'Additional settings for go2epa', 'role_epa', 'Additional settings for go2epa', true, 'ud', false, false, 'text', 'linetext', 
'{"status":false, "parameters":{"junction":{"ysur":999}}}',
true, false);


DELETE FROM audit_cat_param_user WHERE id = 'inp_options_vdefault';
INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, label, isenabled, project_type, isparent , isautoupdate, datatype, widgettype,
vdefault,ismandatory, isdeprecated) VALUES 
('inp_options_vdefault', 'hidden_value', 'Additional settings for go2epa', 'role_epa', 'Additional settings for go2epa', true, 'ws', false, false, 'text', 'linetext', 
'{"status":true, "parameters":{"junction":{"y0":0, "ysur":0}, "outfall":{"outfallType":"NORMAL"}, "conduit":{"barrels":1, "q0":0, "qmax":0}, "raingage":{"scf":1}}}',
true, false);

DELETE FROM audit_cat_param_user WHERE id IN ('epa_outfall_type_vdefault','epa_conduit_q0_vdefault','epa_conduit_barrels_vdefault',
'epa_junction_y0_vdefault','epa_rgage_scf_vdefault');