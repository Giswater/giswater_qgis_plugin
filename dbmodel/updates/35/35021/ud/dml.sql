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

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','UNDEFINED','UNDEFINED');

INSERT INTO inp_typevalue VALUES ('inp_value_surface','PAVED','PAVED');
INSERT INTO inp_typevalue VALUES ('inp_value_surface','GRAVEL','GRAVEL');

INSERT INTO inp_typevalue VALUES ('inp_value_weirs','ROADWAY','ROADWAY');

UPDATE sys_foreignkey SET active=false WHERE typevalue_name ='sys_table_context';

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_outfall', 'Editable view to manage scenario for outfall','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario outfall', 2 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_storage', 'Editable view to manage scenario for storage','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario Storage', 3 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_divider', 'Editable view to manage scenario for divider','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario divider', 4 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_weir', 'Editable view to manage scenario for weir','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario weir', 6 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_pump', 'Editable view to manage scenario for pump','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario pump', 7 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_orifice', 'Editable view to manage scenario for orifice','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario orifice', 8 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_outlet', 'Editable view to manage scenario for outlet','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario outlet', 9 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_inflows', 'Editable view to manage scenario for inflows','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario inflows', 10 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_inflows_pol', 'Editable view to manage scenario for inflows','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario inflows', 10 ,'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_inp_dscenario_treatment_pol', 'Editable view to manage scenario for treatment','role_epa', '{"level_1":"EPA", "level_2":"DSCENARIO"}','Dscenario treatment', 11 ,'core')
ON CONFLICT (id) DO NOTHING;


UPDATE sys_table SET id = 'inp_hydrograph_value' WHERE id = 'inp_hydrograph';
UPDATE sys_table SET id = 'inp_hydrograph' WHERE id = 'inp_hydrograph_id';

UPDATE sys_table SET id = 'inp_treatment' WHERE id = 'inp_treatment_node_x_pol';
UPDATE sys_table SET id = 'inp_coverage' WHERE id = 'inp_coverage_land_x_subc';
UPDATE sys_table SET id = 'inp_loadings' WHERE id = 'inp_loadings_pol_x_subc';
UPDATE sys_table SET id = 'inp_washoff' WHERE id = 'inp_washoff_land_x_pol';
UPDATE sys_table SET id = 'inp_buildup' WHERE id = 'inp_buildup_land_x_pol';
UPDATE sys_table SET id = 'inp_inflows_poll' WHERE id = 'inp_inflows_pol_x_node';


INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_outfall', 'Table to manage scenario for outfall','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_storage', 'Table to manage scenario for storage','role_epa');

INSERT INTO sys_table (id, descript, sys_role)
VALUES('inp_dscenario_divider', 'Table to manage scenario for divider','role_epa');

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
VALUES('inp_dscenario_treatment', 'Table to manage scenario for treatment','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('temp_flowregulator', 'Table to use on pg2epa export for flowregulators (outlet, orifice, weir, pump','role_epa');

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('temp_node_other', 'Table to use on pg2epa export for those processes that uses a relation of cardinility on nodes 1:m (inflows, treatment','role_epa');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3120, 'gw_trg_edit_inp_flwreg', 'UD', 'function trigger', null, null, null, 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3122, 'gw_trg_edit_inp_inflows', 'UD', 'function trigger', null, null, null, 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3124, 'gw_trg_edit_inp_treatment', 'UD', 'function trigger', null, null, null, 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

UPDATE config_param_system SET value = '{"table":"v_edit_cat_dscenario", "selector":"selector_inp_dscenario", "table_id":"dscenario_id",  "selector_id":"dscenario_id",  "label":"dscenario_id, '' - '', name, '' ('', dscenario_type,'')''", "orderBy":"dscenario_id", "selectionMode":"removePrevious", 
"manageAll":false, "query_filter":" AND dscenario_id > 0 AND active is true", "typeaheadFilter":" AND lower(concat(dscenario_id, '' - '', name,'' ('',  dscenario_type,'')''))"}'
WHERE parameter = 'basic_selector_tab_dscenario';

UPDATE inp_flwreg_orifice SET nodarc_id = concat(node_id,'OR',order_id);
UPDATE inp_flwreg_weir SET nodarc_id = concat(node_id,'WE',order_id);
UPDATE inp_flwreg_outlet SET nodarc_id = concat(node_id,'OT',order_id);
UPDATE inp_flwreg_pump SET nodarc_id = concat(node_id,'PU',order_id);

ALTER TABLE inp_dscenario_flwreg_orifice DROP CONSTRAINT inp_dscenario_flwreg_orifice_check_shape;
ALTER TABLE inp_flwreg_orifice DROP CONSTRAINT inp_flwreg_orifice_check_shape;

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET id = 'RECT_CLOSED' WHERE id = 'RECT-CLOSED';
UPDATE inp_typevalue SET id = 'ADC PERVIOUS' WHERE id = 'ADC PERVIUOS';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE inp_flwreg_orifice SET shape = 'RECT_CLOSED' WHERE shape  ='RECT-CLOSED';
UPDATE inp_dscenario_flwreg_orifice SET shape = 'RECT_CLOSED' WHERE shape  ='RECT-CLOSED';

ALTER TABLE inp_dscenario_flwreg_orifice
ADD CONSTRAINT inp_dscenario_flwreg_orifice_check_shape CHECK (shape::text = ANY (ARRAY['CIRCULAR'::character varying::text, 'RECT_CLOSED'::character varying::text]));

ALTER TABLE inp_flwreg_orifice
ADD CONSTRAINT inp_flwreg_orifice_check_shape CHECK (shape::text = ANY (ARRAY['CIRCULAR'::character varying::text, 'RECT_CLOSED'::character varying::text]));

INSERT INTO config_fprocess VALUES (141, 'vi_adjustments', '[ADJUSTMENTS]', null, 44);
INSERT INTO config_fprocess VALUES (239, 'vi_adjustments', '[ADJUSTMENTS]', null, 30);