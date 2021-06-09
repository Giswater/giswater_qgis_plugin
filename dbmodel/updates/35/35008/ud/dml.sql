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

INSERT INTO inp_typevalue values ('inp_value_lidcontrol', 'RG', 'RAIN GARDEN (5.1)');
INSERT INTO inp_typevalue values ('inp_value_lidcontrol', 'RD', 'ROOFTOP DISCONNECTION (5.1)');

INSERT INTO sys_fprocess VALUES (383,'Check missed values for cat_mat.arc n used on real arcs', 'ud');

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