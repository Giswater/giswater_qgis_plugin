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

--2020/12/18
UPDATE sys_param_user SET dv_querytext = 'SELECT id AS id, id AS idval FROM cat_feature_arc JOIN cat_feature USING (id) WHERE id IS NOT NULL AND cat_feature.active IS TRUE'
WHERE id ='edit_arctype_vdefault';

UPDATE sys_param_user SET dv_querytext = 'SELECT id AS id, id AS idval FROM cat_feature_node JOIN cat_feature USING (id) WHERE id IS NOT NULL AND cat_feature.active IS TRUE'
WHERE id ='edit_nodetype_vdefault';

UPDATE sys_param_user SET dv_querytext = 'SELECT id AS id, id AS idval FROM cat_feature_connec JOIN cat_feature USING (id) WHERE id IS NOT NULL AND cat_feature.active IS TRUE'
WHERE id ='edit_connectype_vdefault';

UPDATE sys_param_user set dv_querytext = concat(dv_querytext, ' AND active IS TRUE ')
WHERE id IN ('edit_connecarccat_vdefault','edit_gratecat_vdefault');

UPDATE sys_param_user set dv_querytext = concat(dv_querytext, ' AND cat_grate.active IS TRUE ')
FROM cat_feature WHERE upper(cat_feature.id) = upper(replace(replace(sys_param_user.id,'feat_'::text,''::text),'_vdefault',''))
AND feature_type = 'GULLY';

--2021/01/05
UPDATE config_toolbox SET inputparams =NULL WHERE id = 2202;

--2021/01/30
UPDATE sys_param_user SET vdefault =
'{"status":true, "parameters":{
"junction":{"y0":0, "ysur":0}, 
"outfall":{"outfallType":"NORMAL"}, 
"conduit":{"barrels":1, "q0":0, "qmax":0},
"orifice":{"oriType":"SIDE", "shape":"CIRCULAR", "cd":0.75, "geom1":1, "flap":"NO"}, 
"weir":{"weirType":"SIDEFLOW", "cd":0.75, "ec":null, "cd2":null, "flap":"NO", "geom1":1, "geom2":1}, 
"outlet":{"outletType":"TABULAR/DEPTH", "cd1":null, "cd2":null, "flap":"NO"}, 
"pump":{}, 
"raingage":{"scf":1}}}'
WHERE id = 'inp_options_vdefault';

UPDATE config_param_user SET value =
'{"status":true, "parameters":{
"junction":{"y0":0, "ysur":0}, 
"outfall":{"outfallType":"NORMAL"}, 
"conduit":{"barrels":1, "q0":0, "qmax":0},
"orifice":{"oriType":"SIDE", "shape":"CIRCULAR", "cd":0.75, "geom1":1, "flap":"NO"}, 
"weir":{"weirType":"SIDEFLOW", "cd":0.75, "ec":null, "cd2":null, "flap":"NO", "geom1":1, "geom2":1}, 
"outlet":{"outletType":"TABULAR/DEPTH", "cd1":null, "cd2":null, "flap":"NO"}, 
"pump":{}, 
"raingage":{"scf":1}}}'
WHERE parameter = 'inp_options_vdefault';



UPDATE inp_arc_type SET epa_table = f.epa_table FROM cat_feature_arc f WHERE inp_arc_type.id=f.epa_default;
UPDATE inp_arc_type SET epa_table = 'inp_outlet' where id = 'OUTLET';
UPDATE inp_arc_type SET epa_table = 'inp_orifice' where id = 'ORIFICE';
UPDATE inp_arc_type SET epa_table = 'inp_pump' where id = 'PUMP';
UPDATE inp_arc_type SET epa_table = 'inp_virtual' where id = 'VIRTUAL';
UPDATE inp_arc_type SET epa_table = 'inp_weir' where id = 'WEIR';

UPDATE inp_node_type SET epa_table = f.epa_table FROM cat_feature_node f WHERE inp_node_type.id=f.epa_default;
UPDATE inp_node_type SET epa_table = 'inp_divider' where id = 'DIVIDER';

INSERT INTO sys_feature_epa_type SELECT id, 'NODE', epa_table FROM inp_node_type;
INSERT INTO sys_feature_epa_type SELECT id, 'ARC', epa_table FROM inp_arc_type;

ALTER TABLE cat_feature_node DROP CONSTRAINT cat_feature_node_epa_default_fkey;
ALTER TABLE cat_feature_arc DROP CONSTRAINT cat_feature_arc_epa_default_fkey;
