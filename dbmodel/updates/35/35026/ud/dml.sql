/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/08
update  inp_typevalue set addparam = '{"BC": ["SURFACE", "SOIL", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'BC';

update  inp_typevalue set addparam = '{"RG": ["SURFACE", "SOIL", "STORAGE"] }' WHERE inp_typevalue.id  = 'RG';

update  inp_typevalue set addparam = '{"GR": ["SURFACE", "SOIL", "DRAINMAT"] }' WHERE inp_typevalue.id  = 'GR';

update  inp_typevalue set addparam = '{"IT": ["SURFACE", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'IT';

update  inp_typevalue set addparam = '{"PP": ["SURFACE", "PAVEMENT", "SOIL", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'PP';

update  inp_typevalue set addparam = '{"RB": ["STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'RB';

update  inp_typevalue set addparam = '{"RD": ["SURFACE", "DRAIN"] }' WHERE inp_typevalue.id  = 'RD';

update  inp_typevalue set addparam = '{"VS": ["SURFACE"] }' WHERE inp_typevalue.id  = 'VS';

update config_toolbox
set inputparams='[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""},
{"widgetname":"descript", "label":"Descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5,"value":""}]' 
WHERE id=3118;

--2022/06/11
DELETE FROM config_fprocess WHERE tablename in ('vi_grate', 'vi_link',  'vi_lxsections');

UPDATE sys_param_user SET formname  ='epaoptions' WHERE id = 'inp_options_networkmode';

INSERT INTO sys_feature_epa_type VALUES ('GULLY', 'GULLY', 'inp_gully', null, true);
INSERT INTO sys_feature_epa_type VALUES ('NETGULLY', 'NODE', 'inp_netgully', 'Special case: Additional epa_type for those nodes that are netgullys', true);

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''NODE'' AND id != ''NETGULLY'''
WHERE columnname = 'epa_type' AND formname like 've_nod%';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''NODE'' AND id != ''NETGULLY'''
WHERE columnname = 'epa_type' AND formname = 'v_edit_node';

DELETE FROM sys_table WHERE id in(vi_lxsections, vi_link, vi_grate);

INSERT INTO sys_table (id, descript, sys_role, source) VALUES 
('vi_gully2node', 'View to show what is the outlet node of gully', 'role_epa','core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES 
('v_edit_inp_netgully', 'View to manage epa-side of netgully. Special case where netgully has two epa-sides (junction and also gully)', 
'role_epa','core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES 
('inp_netgully', 'Table to manage epa-side of netgully. Special case where netgully has two epa-sides (junction and also gully)', 
'role_epa','core');