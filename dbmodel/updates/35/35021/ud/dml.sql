/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/29
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3118, 'gw_fct_create_dscenario_from_toc', 'utils', 'function', 'json', 
'json', 'Function to create dscenario getting values from some layer of ToC, including inp layers of EPA group', 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

DELETE FROM config_toolbox WHERE id = 3118;
INSERT INTO config_toolbox VALUES (3118, 'Create Dscenario with values from ToC','{"featureType":["node", "arc"]}',
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
  {"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""}]' ,
  NULL,TRUE)  ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_cat_dwf_dscenario', 'Table to manage scenario for dwf', 'role_epa', '{"level_1":"EPA", "level_2":"CATALOG"}','Hydrology catalog',1,'core');
INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_cat_hydrology', 'Table to manage scenario for hydrology','role_epa', '{"level_1":"EPA", "level_2":"CATALOG"}','DWF catalog', 2 ,'core');

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','OUTFALL','OUTFALL');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','STORAGE','STORAGE');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','DIVIDER','DIVIDER');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','WEIR','WEIR');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','PUMP','PUMP');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','ORIFICE','ORIFICE');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','OUTLET','OUTLET');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','INFLOWS','INFLOWS');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','TREATMENT','TREATMENT');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','OTHER','OTHER');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','JOINED','JOINED');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','UNDEFINED','UNDEFINED');

INSERT INTO inp_typevalue VALUES ('inp_value_surface','PAVED','PAVED');
INSERT INTO inp_typevalue VALUES ('inp_value_surface','GRAVEL','GRAVEL');

INSERT INTO inp_typevalue VALUES ('inp_value_weirs','ROADWAY','ROADWAY');


INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_outfall', 'Editable view to manage scenario for outfall','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario outfall', 2 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_storage', 'Editable view to manage scenario for storage','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario Storage', 3 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_divider', 'Editable view to manage scenario for divider','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario divider', 4 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_weir', 'Editable view to manage scenario for weir','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario weir', 6 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_pump', 'Editable view to manage scenario for pump','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario pump', 7 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_orifice', 'Editable view to manage scenario for orifice','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario orifice', 8 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_outlet', 'Editable view to manage scenario for outlet','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario outlet', 9 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_inflows', 'Editable view to manage scenario for inflows','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario inflows', 10 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_inflows_pol', 'Editable view to manage scenario for inflows','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario inflows', 10 ,'core');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_treatment_pol', 'Editable view to manage scenario for treatment','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario treatment', 11 ,'core');

UPDATE sys_table SET id = 'inp_hydrograph_value' WHERE id = 'inp_hydrograph';
UPDATE sys_table SET id = 'inp_hydrograph' WHERE id = 'inp_hydrograph_id';

UPDATE sys_table SET id = 'inp_treatment' WHERE id = 'inp_treatment_node_x_pol';
UPDATE sys_table SET id = 'inp_coverage' WHERE id = 'inp_coverage_land_x_subc';
UPDATE sys_table SET id = 'inp_loadings' WHERE id = 'inp_loadings_pol_x_subc';
UPDATE sys_table SET id = 'inp_washoff' WHERE id = 'inp_washoff_land_x_pol';
UPDATE sys_table SET id = 'inp_buildup' WHERE id = 'inp_buildup_land_x_pol';
UPDATE sys_table SET id = 'inp_inflows_pol' WHERE id = 'inp_inflows_pol_x_node';


INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_outfall', 'Table to manage scenario for outfall','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_storage', 'Table to manage scenario for storage','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_divider', 'Table to manage scenario for divider','role_epa';

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_weir', 'Table to manage scenario for weir','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_pump', 'Table to manage scenario for pump','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_orifice', 'Table to manage scenario for orifice','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_outlet', 'Table to manage scenario for outlet','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_inflows', 'Table to manage scenario for inflows','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_inflows_pol', 'Table to manage scenario for inflows','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_treatment', 'Table to manage scenario for treatment','role_epa';

