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

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_cat_dwf_dscenario', 'Table to manage scenario for dwf', 'role_epa', 'core')
 ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_cat_hydrology', 'Table to manage scenario for hydrology','role_epa', 'core')
 ON CONFLICT (id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','OUTFALL','OUTFALL') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','STORAGE','STORAGE') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','WEIR','WEIR') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','PUMP','PUMP') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','ORIFICE','ORIFICE') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','OUTLET','OUTLET') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','INFLOWS','INFLOWS') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','TREATMENT','TREATMENT') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','UNDEFINED','UNDEFINED') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_value_surface','PAVED','PAVED') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_value_surface','GRAVEL','GRAVEL') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_value_weirs','ROADWAY','ROADWAY') ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE sys_foreignkey SET active=false WHERE typevalue_name ='sys_table_context';

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_outfall', 'Editable view to manage scenario for outfall','role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_storage', 'Editable view to manage scenario for storage','role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_weir', 'Editable view to manage scenario for weir','role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_pump', 'Editable view to manage scenario for pump','role_epa','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_orifice', 'Editable view to manage scenario for orifice','role_epa','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_outlet', 'Editable view to manage scenario for outlet','role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_inflows', 'Editable view to manage scenario for inflows','role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_inflows_pol', 'Editable view to manage scenario for inflows','role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) 
VALUES('v_edit_inp_dscenario_treatment_pol', 'Editable view to manage scenario for treatment','role_epa', 'core')
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
VALUES('inp_dscenario_outfall', 'Table to manage scenario for outfall','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_storage', 'Table to manage scenario for storage','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_weir', 'Table to manage scenario for weir','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_pump', 'Table to manage scenario for pump','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_orifice', 'Table to manage scenario for orifice','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_outlet', 'Table to manage scenario for outlet','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_inflows', 'Table to manage scenario for inflows','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_inflows_pol', 'Table to manage scenario for inflows','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('inp_dscenario_treatment', 'Table to manage scenario for treatment','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('temp_flowregulator', 'Table to use on pg2epa export for flowregulators (outlet, orifice, weir, pump','role_epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) 
VALUES('temp_node_other', 'Table to use on pg2epa export for those processes that uses a relation of cardinility on nodes 1:m (inflows, treatment','role_epa')
ON CONFLICT (id) DO NOTHING;

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

INSERT INTO config_fprocess VALUES (141, 'vi_adjustments', '[ADJUSTMENTS]', null, 44) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess VALUES (239, 'vi_adjustments', '[ADJUSTMENTS]', null, 30) ON CONFLICT (fid, tablename, target) DO NOTHING;

DELETE FROM sys_function WHERE id = 2240;
DELETE FROM sys_function WHERE id = 2238;
DROP FUNCTION IF EXISTS gw_fct_pg2epa_nod2arc_geom (character varying);

UPDATE config_fprocess SET tablename ='vi_junctions' WHERE tablename ='vi_junction';
UPDATE sys_table SET id ='vi_junctions' WHERE id ='vi_junction';

UPDATE config_param_user SET value = '5.1' WHERE  parameter = 'inp_options_epaversion';
UPDATE sys_param_user SET vdefault = '5.1' WHERE  id = 'inp_options_epaversion';

UPDATE config_function SET style = '{"style":{"point":{"style":"qml", "id":"111"}, "line":{"style":"qml", "id":"110"}}}' WHERE function_name = 'gw_fct_pg2epa_check_result';

UPDATE config_function SET style = 
'{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}, "line":{"style":"random","field":"fid","width":2,"transparency":0.5},"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}}'
WHERE function_name = 'gw_fct_pg2epa_check_data';

--2022/01/10
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_conduit', 'flap', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_dscenario_conduit', 'flap', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_dscenario_flwreg_orifice', 'flap', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_typevalue_orifice', 'inp_dscenario_flwreg_orifice', 'ori_type', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_orifice', 'inp_dscenario_flwreg_orifice', 'shape', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_typevalue_outlet', 'inp_dscenario_flwreg_outlet', 'outlet_type', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_dscenario_flwreg_outlet', 'flap', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_flwreg_outlet', 'flap', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_outlet', 'flap', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_status', 'inp_dscenario_flwreg_pump', 'status', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_dscenario_flwreg_weir', 'flap', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_weirs', 'inp_dscenario_flwreg_weir', 'weir_type', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_inflows', 'inp_dscenario_inflows_poll', 'form_type', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_typevalue_outfall', 'inp_dscenario_outfall', 'outfall_type', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

UPDATE sys_foreignkey SET typevalue_name='inp_value_raingage' WHERE target_table='inp_dscenario_raingage' AND target_field='form_type';

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_typevalue_storage', 'inp_dscenario_storage', 'storage_type', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":true, "layer": "cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": ""}}'
WHERE (formname='v_edit_inp_dscenario_raingage' OR formname='v_edit_inp_dscenario_conduit') AND columnname ='dscenario_id';


UPDATE config_form_fields set columnname='offsetval' WHERE (formname ilike 'v_edit_inp_' OR formname ilike 'inp_%') 
AND columnname='offset';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_flwreg_orifice', 'form_feature', 'main', 'close_time', null, null, 
'integer', 'text', 'close_time', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_orifice', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_flwreg_orifice' AND 
columnname IN ('cd','flap','geom1','geom2','geom3','geom4', 'ori_type', 'offsetval','orate','shape', 'close_time')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_orifice', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_orifice', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_flwreg_orifice' AND 
columnname IN ('cd','flap','geom1','geom2','geom3','geom4', 'ori_type', 'offsetval','orate','shape', 'close_time')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_flwreg_orifice', 'form_feature', 'main', 'nodarc_id', null, null, 
'string', 'text', 'nodarc_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_flwreg_orifice', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_flwreg_orifice' AND 
columnname IN ('nodarc_id','flwreg_length','ori_type', 'offsetval','cd','orate','flap','shape', 
'geom1','geom2','geom3','geom4','close_time')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_flwreg_orifice', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_flwreg_orifice' AND 
columnname IN ('node_id','to_arc','flwreg_length')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_flwreg_orifice', 'form_feature', 'main', 'order_id', null, null, 
'integer', 'text', 'order_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_flwreg_orifice', 'form_feature', 'main', 'order_id', null, null, 
'integer', 'text', 'order_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_orifice', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_flwreg_orifice' AND 
columnname IN ('offsetval','close_time')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_outlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_flwreg_outlet', 'form_feature', 'main', 'nodarc_id', null, null, 
'string', 'text', 'nodarc_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_flwreg_outlet', 'form_feature', 'main', 'order_id', null, null, 
'string', 'text', 'order_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_outlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_flwreg_outlet' AND columnname IN ('outlet_type','offsetval','curve_id','cd1','cd2','flap')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_flwreg_outlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_flwreg_outlet' AND columnname IN ('node_id', 'to_arc', 'flwreg_length', 'order_id' )
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_flwreg_outlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_flwreg_outlet' AND columnname IN ('nodarc_id', 'outlet_type','offsetval',
'curve_id','cd1','cd2','flap')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_outlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_flwreg_outlet' AND columnname IN ('offsetval')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_pump', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_flwreg_pump', 'form_feature', 'main', 'order_id', null, null, 
'integer', 'text', 'order_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_flwreg_pump', 'form_feature', 'main', 'nodarc_id', null, null, 
'string', 'text', 'nodarc_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_flwreg_pump', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_flwreg_pump' 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_pump', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_flwreg_pump' AND columnname IN ('status','startup','curve_id','shutoff','nodarc_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_weir', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_flwreg_weir', 'form_feature', 'main', 'order_id', null, null, 
'integer', 'text', 'order_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_flwreg_weir', 'form_feature', 'main', 'road_width', null, null, 
'double', 'text', 'road_width', null, null, false, true, false, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_flwreg_weir', 'form_feature', 'main', 'road_surf', null, null, 
'double', 'text', 'road_surf', null, null, false, true, false, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_flwreg_weir', 'form_feature', 'main', 'coef_curve', null, null, 
'double', 'text', 'coef_curve', null, null, false, true, false, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_weir', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_flwreg_weir'  AND columnname IN ('offsetval', 'road_surf', 'road_width', 'coef_curve')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_flwreg_weir', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_flwreg_weir'
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_flwreg_weir', 'form_feature', 'main', 'nodarc_id', null, null, 
'string', 'text', 'nodarc_id', null, null, false, false, false, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_flwreg_weir', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_flwreg_weir' AND columnname IN ('weir_type','offsetval','cd','ec','cd2', 'flap','geom1','geom2','geom3','geom4',
'surcharge', 'road_width', 'road_surf', 'coef_curve','nodarc_id', 'road_surf', 'road_width', 'coef_curve')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields set iseditable=true WHERE formname='v_edit_inp_dscenario_flwreg_weir' AND columnname='nodarc_id';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_inflows', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_inflows', 'form_feature', 'main', 'order_id', null, null, 
'string', 'text', 'order_id', null, null, false, false, false, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_inflows', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_inflows' AND columnname IN ('node_id','order_id','timser_id','sfactor','base', 'pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_inflows', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_inflows' AND columnname IN ('node_id','order_id','timser_id','sfactor','base', 'pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


UPDATE config_form_fields SET formname='v_edit_inp_inflows_poll' WHERE formname='inp_inflows_pol_x_node';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_inflows_poll', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_inflows_poll', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_inflows_poll' AND columnname IN ('node_id','poll_id','timser_id','form_type','mfactor', 'sfactor','base','pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_outfall', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_outfall', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_outfall' AND columnname IN ('node_id','elev','ymax','outfall_type','stage', 'curve_id','timser_id','gate')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_storage', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_storage', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_storage' AND columnname IN ('node_id','elev','ymax','storage_type', 'curve_id','a1','a2', 'a0', 'fevap', 'sh', 'hc',
'imd','y0', 'ysur', 'apond')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_treatment', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_conduit' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_treatment', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_treatment_node_x_pol'
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_treatment', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_treatment_node_x_pol'
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET dv_isnullvalue= true WHERE widgettype='combo' AND formname ILIKE 'v_edit_inp_dscenario_inp%';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_junction', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_junction' AND columnname in ('elev', 'ymax')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_conduit', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_conduit' AND columnname in ('elev1', 'elev2')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_curve', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_cat_dscenario' AND columnname in ('log', 'descript')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_curve_value', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_cat_dscenario' AND columnname in ( 'descript')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

DELETE FROM config_form_fields WHERE columnname='offset' AND formname in ('v_edit_inp_orifice', 'v_edit_inp_weir', 'v_edit_inp_outlet');
DELETE FROM config_form_fields WHERE columnname='id' AND formname in ('v_edit_inp_dwf', 'v_edit_inp_flwreg_pump', 'v_edit_inp_flwreg_weir');
DELETE FROM config_form_fields WHERE columnname='flwreg_id' AND formname in ('v_edit_inp_flwreg_pump', 'v_edit_inp_flwreg_weir');

--2022/01/17
insert into sys_table (id, descript, sys_role, source) values ('v_edit_inp_flwreg_orifice', 'View with the information of flow regulators type orifice', 'role_epa', 'core');
insert into sys_table (id, descript, sys_role, source) values ('v_edit_inp_flwreg_outlet', 'View with the information of flow regulators type outlet', 'role_epa', 'core');
insert into sys_table (id, descript, sys_role, source) values ('v_edit_inp_flwreg_pump', 'View with the information of flow regulators type pump', 'role_epa', 'core');
insert into sys_table (id, descript, sys_role, source) values ('v_edit_inp_flwreg_weir', 'View with the information of flow regulators type weir', 'role_epa', 'core');

UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Dwf scenario catalog' , orderby=1 WHERE id ='cat_dwf_scenario';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Hydro scenario catalog' , orderby=2 WHERE id ='cat_hydrology';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Pattern catalog' , orderby=3 WHERE id ='inp_pattern';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Pattern values' , orderby=4 WHERE id ='inp_pattern_value';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Curve catalog' , orderby=5 WHERE id ='v_edit_inp_curve';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Curve values' , orderby=6 WHERE id ='v_edit_inp_curve_value';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Timeseries catalog' , orderby=7 WHERE id ='inp_timeseries';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Timeseries values' , orderby=8 WHERE id ='inp_timeseries_value';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Lid catalog' , orderby=9 WHERE id ='inp_lid_control';
UPDATE sys_table SET context = '{"level_1":"EPA","level_2":"CATALOGS"}' , alias = 'Dscenario catalog' , orderby=10 WHERE id ='v_edit_cat_dscenario';

UPDATE sys_table SET context='{"level_1":"EPA","level_2":"HYDROLOGY"}', orderby=1, alias='Inp Raingage' WHERE id='v_edit_raingage';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"HYDROLOGY"}', orderby=2, alias='Inp Subcatchment' WHERE id='v_edit_inp_subcatchment';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"HYDROLOGY"}', orderby=3, alias='Inp LID' WHERE id='v_edit_inp_lid_usage';

update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Junction', orderby=1 where id='v_edit_inp_junction';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Outfall', orderby=2 where id='v_edit_inp_outfall';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Divider', orderby=3 where id='v_edit_inp_divider';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Storage', orderby=4 where id='v_edit_inp_storage';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Conduit', orderby=5 where id='v_edit_inp_conduit';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Virtual', orderby=6 where id='v_edit_inp_virtual';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Pump', orderby=7 where id='v_edit_inp_pump';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Weir', orderby=8 where id='v_edit_inp_weir';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Outlet', orderby=9 where id='v_edit_inp_outlet';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Orifice', orderby=10 where id='v_edit_inp_orifice';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inflows', orderby=11 where id='inp_inflows';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Inp Dwf', orderby=12 where id='v_edit_inp_dwf';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Transects value', orderby=13 where id='inp_transects_value';
update sys_table set context = '{"level_1":"EPA","level_2":"HYDRAULICS"}', alias='Controls', orderby=14 where id='v_edit_inp_controls';

UPDATE sys_table SET context='{"level_1":"EPA","level_2":"FLOWREG"}', alias='Flowreg Orifice', orderby=1 where id='v_edit_inp_flwreg_orifice';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"FLOWREG"}', alias='Flowreg Outlet', orderby=2 where id='v_edit_inp_flwreg_outlet';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"FLOWREG"}', alias='Flowreg Pump', orderby=3 where id='v_edit_inp_flwreg_pump';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"FLOWREG"}', alias='Flowreg Weir', orderby=4 where id='v_edit_inp_flwreg_weir';

UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Conduit Dscenario', orderby=1 where id='v_edit_inp_dscenario_conduit';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Junction Dscenario', orderby=2 where id='v_edit_inp_dscenario_divider';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Raingage Dscenario', orderby=3 where id='v_edit_inp_dscenario_flwreg_orifice';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Conduit Dscenario', orderby=4 where id='v_edit_inp_dscenario_flwreg_outlet';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Junction Dscenario', orderby=5 where id='v_edit_inp_dscenario_flwreg_pump';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Raingage Dscenario', orderby=6 where id='v_edit_inp_dscenario_flwreg_weir';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Conduit Dscenario', orderby=7 where id='v_edit_inp_dscenario_inflows';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Junction Dscenario', orderby=8 where id='v_edit_inp_dscenario_inflows_poll';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Junction Dscenario', orderby=9 where id='v_edit_inp_dscenario_junction';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Raingage Dscenario', orderby=10 where id='v_edit_inp_dscenario_outfall';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Conduit Dscenario', orderby=11 where id='v_edit_inp_dscenario_raingage';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Junction Dscenario', orderby=12 where id='v_edit_inp_dscenario_storage';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"DSCENARIO"}', alias='Raingage Dscenario', orderby=13 where id='v_edit_inp_dscenario_treatment';

UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Node Flooding', orderby=1 where id='v_rpt_nodeflooding_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Node Surcharge', orderby=2 where id='v_rpt_nodesurcharge_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Node Inflow', orderby=3 where id='v_rpt_nodeinflow_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Node Depth', orderby=4 where id='v_rpt_nodedepth_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Arc Flow', orderby=5 where id='v_rpt_arcflow_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Conduit Surcharge', orderby=6 where id='v_rpt_condsurcharge_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Pumping Summary', orderby=7 where id='v_rpt_pumping_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Flow Class', orderby=8 where id='v_rpt_nodeflowclass_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Arc Pollutant Load', orderby=9 where id='v_rpt_arcpolload_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Outfall flow', orderby=10 where id='v_rpt_outfallflow_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Outfall load', orderby=11 where id='v_rpt_outfallload_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Storage Volume', orderby=12 where id='v_rpt_storagevol_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Subcatchment Runoff', orderby=13 where id='v_rpt_subcatchrunoff_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='Subcatchment Washoff', orderby=14 where id='v_rpt_subcatchwasoff_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"RESULTS"}', alias='LID Performance', orderby=15 where id='v_rpt_lidperformance_sum';

UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Node Flooding Compare', orderby=1 where id='v_rpt_comp_nodeflooding_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Node Surcharge Compare', orderby=2 where id='v_rpt_comp_nodesurcharge_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Node Inflow Compare', orderby=3 where id='v_rpt_comp_nodeinflow_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Node Depth Compare', orderby=4 where id='v_rpt_comp_nodedepth_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Arc Flow Compare', orderby=5 where id='v_rpt_comp_arcflow_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Conduit Surcharge Compare', orderby=6 where id='v_rpt_comp_condsurcharge_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Pumping Summary Compare', orderby=7 where id='v_rpt_comp_pumping_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Flow Class Compare', orderby=8 where id='v_rpt_comp_flowclass_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Outfall Flow Compare', orderby=10 where id='v_rpt_comp_outfallflow_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Outfall Load Compare', orderby=11 where id='v_rpt_comp_outfallload_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Storage Volume Compare', orderby=12 where id='v_rpt_comp_storagevol_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Subcatchment Runoff Compare', orderby=13 where id='v_rpt_comp_subcatchrunoff_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='Subcatchment Washoff Compare', orderby=14 where id='v_rpt_comp_subcatchwasoff_sum';
UPDATE sys_table SET context='{"level_1":"EPA","level_2":"COMPARE"}', alias='LID Performance Compare', orderby=15 where id='v_rpt_comp_lidperformance_sum';

DELETE FROM config_toolbox WHERE id = 2680;