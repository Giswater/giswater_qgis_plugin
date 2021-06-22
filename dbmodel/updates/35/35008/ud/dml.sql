/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/04
UPDATE sys_feature_cat SET epa_default = 'CONDUIT' WHERE id = 'SIPHON';

UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "cat_arc"]}]'
WHERE id  = 'cat_feature_arc';
UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["connec", "cat_connec"]}]'
WHERE id  = 'cat_feature_connec';
UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["gully", "cat_grate"]}]'
WHERE id  = 'cat_feature_grate';
UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["node", "cat_node"]}]'
WHERE id  = 'cat_feature_node';

UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"pattern_id","featureType":["v_edit_inp_dwf", "inp_aquifer", "inp_inflows", "inp_inflows_pol_x_node",  "inp_dwf_pol_x_node"]}]'
WHERE id  = 'inp_pattern';

UPDATE inp_typevalue SET idval = 'BIO-RETENTION CELL' WHERE id = 'BC';
UPDATE inp_typevalue SET idval = 'GREEN ROOF (5.1)' WHERE id = 'GR';
UPDATE inp_typevalue SET idval = 'INFILTRATION TRENCH' WHERE id = 'IT';
UPDATE inp_typevalue SET idval = 'PERMEABLE PAVEMENT' WHERE id = 'PP';
UPDATE inp_typevalue SET idval = 'RAIN BARREL' WHERE id = 'RB';
UPDATE inp_typevalue SET idval = 'VEGETATIVE SWALE' WHERE id = 'VS';

INSERT INTO inp_typevalue values ('inp_value_lidcontrol', 'RG', 'RAIN GARDEN (5.1)')
ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue values ('inp_value_lidcontrol', 'RD', 'ROOFTOP DISCONNECTION (5.1)')
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_fprocess VALUES (383,'Check missed values for cat_mat.arc n used on real arcs', 'ud') ON CONFLICT (fid) DO NOTHING;

--2021/06/09
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'id',null,null,'integer', 'text','id',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'pattern_id',null,null,'string', 'combo','pattern_id','Pattern identifier', false,
false, true, false, false, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,
null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_1',null,null,'double', 'text','factor_1','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_2',null,null,'double', 'text','factor_2','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_3',null,null,'double', 'text','factor_3','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_4',null,null,'double', 'text','factor_4','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_5',null,null,'double', 'text','factor_5','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_6',null,null,'double', 'text','factor_6','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_7',null,null,'double', 'text','factor_7','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_8',null,null,'double', 'text','factor_8','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_9',null,null,'double', 'text','factor_9','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_10',null,null,'double', 'text','factor_10','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_11',null,null,'double', 'text','factor_11','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_12',null,null,'double', 'text','factor_12','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_13',null,null,'double', 'text','factor_13','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_14',null,null,'double', 'text','factor_14','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_15',null,null,'double', 'text','factor_15','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_16',null,null,'double', 'text','factor_16','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_17',null,null,'double', 'text','factor_17','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_18',null,null,'double', 'text','factor_18','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_19',null,null,'double', 'text','factor_19','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_20',null,null,'double', 'text','factor_20','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_21',null,null,'double', 'text','factor_21','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_22',null,null,'double', 'text','factor_22','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_23',null,null,'double', 'text','factor_23','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern_value','form_feature', 'main', 'factor_24',null,null,'double', 'text','factor_24','Factor value', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dwf_scenario','form_feature', 'main', 'id',null,null,'integer', 'text','id',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dwf_scenario','form_feature', 'main', 'idval',null,null,'integer', 'text','idval','Dwf scenario name', false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dwf_scenario','form_feature', 'main', 'startdate',null,null,'date', 'datetime','startdate','Start date', false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dwf_scenario','form_feature', 'main', 'enddate',null,null,'date', 'datetime','enddate','End date', false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dwf_scenario','form_feature', 'main', 'observ',null,null,'string', 'text','observ',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dwf_scenario','form_feature', 'main', 'active',null,null,'boolean', 'check','active',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--2021/06/10
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'subc_id',null,null,'string', 'combo','subc_id','Subcatchment identifier', false,
false, true, false, false, 'SELECT DISTINCT (subc_id) AS id,  subc_id  AS idval FROM inp_subcatchment WHERE subc_id IS NOT NULL',true,
null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'lidco_id',null,null,'string', 'combo','lidco_id','Lid identifier', false,
false, true, false, false, 'SELECT DISTINCT (lidco_id) AS id,  lidco_id  AS idval FROM inp_lid_control WHERE lidco_id IS NOT NULL',true,
null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'number',null,null,'integer', 'text','number','Number', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'area',null,null,'double', 'text','area','Area', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'width',null,null,'double', 'text','width','Width', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'initsat',null,null,'double', 'text','initsat','Initsat', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'fromimp',null,null,'double', 'text','fromimp','Fromimp', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'toperv',null,null,'double', 'text','toperv','Toperv', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'rptfile',null,null,'string', 'text','rptfile','Rptfile', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'descript',null,null,'string', 'text','descript','Descript', false,
false, true, false, false, null,null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message)
VALUES ('v_edit_inp_inp', 'Shows editable information about lids', 'role_epa', 0, 'role_epa',2, 'Cannot view lids related to EPA tables')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message)
VALUES ('v_edit_inp_dwf', 'Shows editable information about dry weather flow', 'role_epa', 0, 'role_epa',2, 'Cannot view dry weather flows related to EPA tables')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
 VALUES (3038, 'gw_trg_edit_inp_lid_usage', 'ud', 'trigger function', null, null, 'Function to edit inp lids', 'role_epa',null,null) ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET inputparams='[{"widgetname":"insertIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"},
{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layoutorder":2,"value":0.01},
{"widgetname":"exploitation", "label":"Exploitation ids:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},
{"widgetname":"stateType", "label":"State:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":4, 
"dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id", "selectedId":"1","isparent":"true"},
{"widgetname":"workcatId", "label":"Workcat:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5, "isNullValue":true, "dvQueryText":"select id as id, id as idval from cat_work where id is not null order by id", "selectedId":"1"},
{"widgetname":"builtdate", "label":"Builtdate:", "widgettype":"datetime","datatype":"date","layoutname":"grl_option_parameters","layoutorder":6, "value":null },
{"widgetname":"nodeType", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":7, "dvQueryText":"select distinct id as id, id as idval from cat_feature_node where id is not null", "selectedId":"$userNodetype"},
{"widgetname":"nodeCat", "label":"Node catalog:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8, "dvQueryText":"select distinct id as id, id as idval from cat_node where node_type = $userNodetype  OR node_type is null order by id", "selectedId":"$userNodecat"}]'
WHERE id=2118;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3042, 'gw_trg_scenario_management', 'ud', 'trigger function', null, null, 'Function to enhance the management of scenarios (hydrology and dwf)', 'role_epa',null,null)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user (id, formname, descript, sys_role, ismandatory, vdefault) 
VALUES ('inp_scenario_hydrology', 'hidden', 'Variable to control cat_hydrology scenario table', 'role_epa', TRUE, '{"automaticInsert":{"status":false, "sourceScenario":1}}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user (id, formname, descript, sys_role, ismandatory, vdefault) 
VALUES ('inp_scenario_dwf', 'hidden', 'Variable to control the cat_dwf_scenario table', 'role_epa', TRUE, '{"automaticInsert":{"status":false, "sourceScenario":1}}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source)
VALUES (385, 'Import inp timeseries', 'ud',NULL, NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3046, 'gw_fct_import_inp_timeseries', 'ud', 'function', 'json', 'json',
'Function to assist the import of timeseries for inp models',
'role_epa', NULL, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, readheader)
VALUES (385,'Import inp timeseries', 
'Function to assist the import of timeseries for inp models.
The csv file must containts next columns on same position: 
timeseries, type, mode, date, hour, time, value (fill date/hour for ABSOLUTE or time for RELATIVE)', 
'gw_fct_import_inp_timeseries', true, 9, false)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_value_timserid', 'Orifice', 'Orifice')
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_value_timserid', 'Other', 'Other')
ON CONFLICT (typevalue, id) DO NOTHING;

ALTER TABLE cat_node ALTER COLUMN geom1 SET DEFAULT 0;
ALTER TABLE cat_node ALTER COLUMN geom2 SET DEFAULT 0;
ALTER TABLE cat_node ALTER COLUMN geom3 SET DEFAULT 0;
ALTER TABLE cat_connec ALTER COLUMN geom1 SET DEFAULT 0;
ALTER TABLE cat_grate ALTER COLUMN length SET DEFAULT 0;

ALTER TABLE man_wjump ALTER COLUMN length SET DEFAULT 0;
ALTER TABLE man_wjump ALTER COLUMN width SET DEFAULT 0;
ALTER TABLE man_storage ALTER COLUMN length SET DEFAULT 0;
ALTER TABLE man_storage ALTER COLUMN width SET DEFAULT 0;
ALTER TABLE man_netinit ALTER COLUMN length SET DEFAULT 0;
ALTER TABLE man_netinit ALTER COLUMN width SET DEFAULT 0;
ALTER TABLE man_manhole ALTER COLUMN length SET DEFAULT 0;
ALTER TABLE man_manhole ALTER COLUMN width SET DEFAULT 0;
ALTER TABLE man_chamber ALTER COLUMN length SET DEFAULT 0;
ALTER TABLE man_chamber ALTER COLUMN width SET DEFAULT 0;