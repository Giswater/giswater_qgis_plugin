/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/31
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_curve' AND columnname='expl_id' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_cat_dscenario' AND columnname IN ('log')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_curve' AND columnname='expl_id' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern', 'form_feature', 'main', 'tsparameters', NULL, NULL, 
'string', 'text', 'tsparameters', NULL, NULL, false, false, true, false, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, false) 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_pattern' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_pattern_value', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_pattern' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_pattern_value', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_pattern' AND columnname ilike 'factor%' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'inp_timeseries', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_curve' AND columnname IN ('descript', 'log','expl_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_timeseries', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_timeseries' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_timeseries_value', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_timeseries' AND columnname IN ('timser_type','times_type','idval','expl_id')  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_timeseries_value', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_timeseries_value'  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET widgettype='combo', 
dv_querytext='SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',
widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": ""}}'
WHERE formname='v_edit_inp_pattern_value' AND columnname='pattern_id';

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_pattern', 'View to edit patterns, filtered by expl_id','role_epa', '{"level_1":"EPA","level_2":"CATALOGS"}', 3, 'Pattern catalog', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_pattern_value', 'View to edit curve values, filtered by expl_id','role_epa','{"level_1":"EPA","level_2":"CATALOGS"}', 4,
'Pattern values', 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET alias=NULL, orderby=NULL, context=NULL WHERE id IN ('inp_pattern', 'inp_pattern_value');

UPDATE config_form_fields SET widgetcontrols='{"valueRelation":{"nullValue":true, "layer": "cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": ""}}'
WHERE columnname='dscenario_id' AND formname='v_edit_inp_dscenario_junction';

UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":true, "layer": "v_edit_inp_timeseries", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": ""}}'
WHERE columnname='timser_id';

UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": ""}}'
WHERE columnname='pattern_id';

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_timeseries', 'View to edit timeseries, filtered by expl_id','role_epa', '{"level_1":"EPA","level_2":"CATALOGS"}', 7, 
'Timeseries catalog', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_timeseries_value', 'View to edit timeseries values, filtered by expl_id','role_epa','{"level_1":"EPA","level_2":"CATALOGS"}', 8,
'Timeseries values', 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET alias=NULL, orderby=NULL, context=NULL WHERE id IN ('inp_timeseries', 'inp_timeseries_value');

UPDATE sys_foreignkey SET target_table='inp_washoff' WHERE target_table='inp_washoff_land_x_pol';
UPDATE sys_foreignkey SET target_table='inp_buildup' WHERE target_table='inp_buildup_land_x_pol';
UPDATE sys_foreignkey SET target_table='inp_coverage' WHERE target_table='inp_coverage_land_x_subc';
UPDATE sys_foreignkey SET target_table='inp_loadings' WHERE target_table='inp_loadings_pol_x_subc';
UPDATE sys_foreignkey SET target_table='inp_inflows_poll' WHERE target_table='inp_inflows_pol_x_node';

UPDATE sys_table SET id=replace(id,'inp_dscenario_','inp_dscenario_flwreg_') WHERE id in ('inp_dscenario_weir','inp_dscenario_pump','inp_dscenario_orifice',
'inp_dscenario_outlet');
UPDATE sys_table SET id='temp_arc_flowregulator' WHERE id='temp_flowregulator';
UPDATE sys_table SET id='inp_dscenario_inflows_poll' WHERE id='inp_dscenario_inflows_pol';


INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_lid_usage', 'View to edit dscenario for lids','role_epa', '{"level_1":"EPA","level_2":"DSCENARIO"}', 13, 
'Lid Dscenario', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, alias, source)
VALUES ('inp_dscenario_lid_usage', 'Table to manage dscenario for lids','role_epa', 'Lid Dscenario', 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET alias = 'Inflow Dscenario' WHERE id = 'v_edit_inp_dscenario_inflows';
UPDATE sys_table SET alias = 'Raingage Dscenario' WHERE id = 'v_edit_inp_dscenario_raingage';
UPDATE sys_table SET alias = 'Storage Dscenario' WHERE id = 'v_edit_inp_dscenario_storage';
UPDATE sys_table SET alias = 'Outfall Dscenario' WHERE id = 'v_edit_inp_dscenario_outfall';

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_flwreg_weir', 'Editable view to manage scenario for weir', 'role_epa', '{"level_1":"EPA","level_2":"DSCENARIO"}', 6 ,'Weir Dscenario', 'core')
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_flwreg_pump', 'Editable view to manage scenario for pump', 'role_epa', '{"level_1":"EPA","level_2":"DSCENARIO"}', 5 ,'Pump Dscenario', 'core') 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_flwreg_orifice', 'Editable view to manage scenario for orifice', 'role_epa', '{"level_1":"EPA","level_2":"DSCENARIO"}', 3 ,'Orifice Dscenario', 'core') 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_flwreg_outlet', 'Editable view to manage scenario for outlet', 'role_epa', '{"level_1":"EPA","level_2":"DSCENARIO"}', 4 ,'Outlet Dscenario', 'core')
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_inflows_poll', 'Editable view to manage scenario for inflow pollutants', 'role_epa', '{"level_1":"EPA","level_2":"DSCENARIO"}', 8 ,'Inflow pollutants Dscenario', 'core')
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_treatment', 'Editable view to manage scenario for treatment', 'role_epa', '{"level_1":"EPA","level_2":"DSCENARIO"}', 13 ,'Treatment Dscenario', 'core')
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_inflows', 'Editable view to manage inflows', 'role_epa', '{"level_1":"EPA","level_2":"HYDRAULICS"}', 11 ,'Inp Inflows', 'core')
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_inflows_poll', 'Editable view to manage inflow pollutants', 'role_epa', '{"level_1":"EPA","level_2":"HYDRAULICS"}', 12 ,'Inflow Pollutants', 'core')
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_treatment', 'Editable view to manage treatments', 'role_epa', '{"level_1":"EPA","level_2":"HYDRAULICS"}', 16 ,'Treatment', 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET context=NULL, orderby=NULL, alias=NULL WHERE id='inp_inflows';

update sys_table set orderby=13 where id='v_edit_inp_dwf';
update sys_table set orderby=14 where id='inp_transects_value';
update sys_table set orderby=15 where id='v_edit_inp_controls';

UPDATE sys_table SET addparam='{"pkey":"dscenario_id, node_id"}' WHERE id IN ('v_edit_inp_dscenario_inflows','v_edit_inp_dscenario_junction', 'v_edit_inp_dscenario_outfall',
'v_edit_inp_dscenario_storage', 'v_edit_inp_dwf');
UPDATE sys_table SET addparam='{"pkey":"dscenario_id, nodarc_id"}' WHERE id IN ('v_edit_inp_dscenario_flwreg_orifice', 'v_edit_inp_dscenario_flwreg_outlet', 'v_edit_inp_dscenario_flwreg_pump',
'v_edit_inp_dscenario_flwreg_weir');
UPDATE sys_table SET addparam='{"pkey":"dscenario_id, arc_id"}' WHERE id IN ('v_edit_inp_dscenario_conduit','');
UPDATE sys_table SET addparam='{"pkey":"dscenario_id, rg_id"}' WHERE id IN ('v_edit_inp_dscenario_raingage');
UPDATE sys_table SET addparam='{"pkey":"hydrology_id, subc_id"}' WHERE id IN ('v_edit_inp_subcatchment');
UPDATE sys_table SET addparam='{"pkey":"node_id, poll_id"}' WHERE id IN ('v_edit_inp_inflows_poll','v_edit_inp_treatment');

UPDATE sys_table SET addparam='{"pkey":"dscenario_id, node_id, poll_id"}' WHERE id IN ('v_edit_inp_dscenario_treatment', 'v_edit_inp_dscenario_inflows_poll');
UPDATE sys_table SET addparam='{"pkey":"dscenario_id, subc_id, lidco_id"}' WHERE id IN ('v_edit_inp_dscenario_lid_usage');

UPDATE config_form_fields SET columnname='numelem', label='numelem' WHERE columnname='number' AND formname='v_edit_inp_lid_usage';

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_lid_usage', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_lid_usage'  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_lid_usage', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_dscenario_inflows' AND columnname='dscenario_id' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE inp_timeseries SET expl_id = a.expl_id FROM arc a WHERE inp_timeseries.expl_id=a.sector_id;

ALTER TABLE inp_timeseries ADD CONSTRAINT inp_timeseries_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

--2022/02/08
INSERT INTO inp_typevalue(typevalue, id, idval)
VALUES ('inp_value_catarc', 'VERT_ELLIPSE', 'VERT_ELLIPSE');

ALTER TABLE cat_arc_shape DROP CONSTRAINT cat_arc_shape_check;
ALTER TABLE cat_arc_shape
ADD CONSTRAINT cat_arc_shape_check CHECK (epa::text = ANY (ARRAY['VERT_ELLIPSE'::character varying,'ARCH'::character varying, 'BASKETHANDLE'::character varying, 'CIRCULAR'::character varying, 'CUSTOM'::character varying, 'DUMMY'::character varying, 'EGG'::character varying, 'FILLED_CIRCULAR'::character varying, 'FORCE_MAIN'::character varying, 'HORIZ_ELLIPSE'::character varying, 'HORSESHOE'::character varying, 'IRREGULAR'::character varying, 'MODBASKETHANDLE'::character varying, 'PARABOLIC'::character varying, 'POWER'::character varying, 'RECT_CLOSED'::character varying, 'RECT_OPEN'::character varying, 'RECT_ROUND'::character varying, 'RECT_TRIANGULAR'::character varying, 'SEMICIRCULAR'::character varying, 'SEMIELLIPTICAL'::character varying, 'TRAPEZOIDAL'::character varying, 'TRIANGULAR'::character varying, 'VIRTUAL'::character varying]::text[]));

INSERT INTO cat_arc_shape
VALUES ('VERT_ELLIPSE', 'VERT_ELLIPSE') ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET functionparams = '{"featureType":["node", "arc", "subcatchment", "raingage"]}' WHERE id = 3118;

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario', 'LIDS', 'LIDS');

UPDATE config_toolbox SET inputparams = 
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
 {"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
 {"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""}]'
WHERE id = 3118;

-- 19/02/2022
DELETE FROM sys_function WHERE function_name = 'gw_trg_edit_inp_lid_usage';

INSERT INTO sys_param_user(id, formname, descript, sys_role, isenabled, project_type, isautoupdate, datatype, widgettype, ismandatory, dv_querytext, source, layoutname, layoutorder, label)
VALUES ('epa_lidco_vdefault', 'config', 'Default value for lids when automatic creation for ToC (Subcatchments)', 'role_epa', true, 'ud', false, 'text', 'combo', true, 
'SELECT DISTINCT lidco_id as id,lidco_id as idval FROM inp_lidcontrol', 'core', 'lyt_epa', 1, 'LID Dscenario vdefault')
ON CONFLICT (id) DO NOTHING;

-- 25/02/2022

DELETE FROM sys_foreignkey WHERE typevalue_name ='inp_value_lidcontrol';

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE inp_typevalue SET typevalue='inp_value_lidtype'
WHERE typevalue = 'inp_value_lidcontrol' AND id IN ('BC','GR','IT','PP','RP','RD','RG','VS');

UPDATE inp_typevalue SET typevalue='inp_value_lidlayer'
WHERE typevalue = 'inp_value_lidcontrol';

UPDATE sys_typevalue SET typevalue_name='inp_value_lidtype' WHERE typevalue_name ='inp_value_lidcontrol';
INSERT INTO sys_typevalue VALUES ('inp_typevalue', 'inp_value_lidlayer');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,active)
VALUES ('inp_typevalue', 'inp_value_lidtype','inp_lidcontrol','lidco_type', true);

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,active)
VALUES ('inp_typevalue', 'inp_value_lidlayer','inp_lidcontrol_value','lidlayer', true);

ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE sys_table SET id='inp_lidcontrol' WHERE id='inp_lid_control';

INSERT INTO sys_table(id, descript, sys_role, criticity, context, orderby, alias, source)
VALUES ('inp_lidcontrol_value', 'Defines values of scale-independent LID controls that can be deployed within subcatchments.', 'role_epa', null, 
'{"level_1":"EPA","level_2":"CATALOGS"}', 10, 'Lid values', 'core');

UPDATE sys_table SET orderby=11 WHERE id='v_edit_cat_dscenario';

UPDATE config_form_fields SET dv_querytext='SELECT  lidco_id as id, lidco_id as idval FROM inp_lidcontrol WHERE lidco_id IS NOT NULL ' 
WHERE formname='v_edit_inp_dscenario_lid_usage' and columnname='lidco_id';

DELETE FROM config_form_fields WHERE formname='inp_lidusage_subc_x_lidco';

INSERT INTO config_form_fields 
SELECT 'inp_lidcontrol', formtype, tabname, columnname, layoutname, layoutorder, 
       datatype, widgettype, label, tooltip, placeholder, ismandatory, 
       isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
       dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
       widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='inp_lid_control' and columnname IN ('lidco_type', 'lidco_id');

UPDATE config_form_fields SET dv_querytext='SELECT  lidco_id as id, lidco_id as idval FROM inp_lidcontrol WHERE lidco_id IS NOT NULL ' 
WHERE formname='inp_lidcontrol_value' and columnname='lidco_id';

UPDATE config_form_fields SET formname='inp_lidcontrol_value' WHERE formname='inp_lid_control';

UPDATE config_form_fields 
SET columnname='lidlayer', label='lidlayer', dv_querytext='SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_lidlayer''' 
WHERE formname='inp_lidcontrol_value' AND columnname='lidco_type';

UPDATE config_form_fields SET dv_querytext='SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_lidtype''' 
WHERE formname='inp_lidcontrol' AND columnname='lidco_type';

UPDATE config_form_fields 
SET  widgettype='combo', dv_querytext='SELECT lidco_id as  id, lidco_id as idval FROM inp_lidcontrol'  
WHERE formname='inp_lidcontrol_value' AND columnname='lidco_id';

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;
