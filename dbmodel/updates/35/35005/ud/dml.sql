/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/25
DELETE FROM config_function WHERE id = 2524; -- gw_fct_import_swmm_inp

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''', widgettype = 'combo' 
WHERE formname ='cat_feature_node' AND columnname = 'isexitupperintro';

INSERT INTO config_form_fields VALUES ('cat_arc', 'form_feature', 'main', 'geom1');
INSERT INTO config_form_fields VALUES ('cat_arc', 'form_feature', 'main', 'geom2');
INSERT INTO config_form_fields VALUES ('cat_arc', 'form_feature', 'main', 'geom3');
INSERT INTO config_form_fields VALUES ('cat_arc', 'form_feature', 'main', 'geom4');
INSERT INTO config_form_fields VALUES ('cat_arc', 'form_feature', 'main', 'geom5');
INSERT INTO config_form_fields VALUES ('cat_arc', 'form_feature', 'main', 'geom6');
INSERT INTO config_form_fields VALUES ('cat_arc', 'form_feature', 'main', 'geom7');
INSERT INTO config_form_fields VALUES ('cat_arc', 'form_feature', 'main', 'geom8');

UPDATE config_form_fields SET hidden=true WHERE formname = 'cat_arc' AND columnname IN('geom5','geom6','geom7','geom8');
UPDATE config_form_fields SET iseditable=true WHERE formname = 'cat_arc' AND columnname IN('geom1','geom2','geom3','geom4');

UPDATE config_form_fields SET widgettype = 'combo', dv_querytext = 'SELECT id, id as idval FROM cat_feature_arc JOIN cat_feature USING (id) WHERE active is true' WHERE formname = 'cat_arc' AND columnname = 'arc_type';
UPDATE config_form_fields SET widgettype = 'combo', dv_querytext = 'SELECT id, id as idval FROM cat_feature_node JOIN cat_feature USING (id)  WHERE active is true' WHERE formname = 'cat_node' AND columnname = 'node_type';
UPDATE config_form_fields SET widgettype = 'combo', dv_querytext = 'SELECT id, id as idval FROM cat_feature_connec JOIN cat_feature USING (id) WHERE active is true' WHERE formname = 'cat_connec' AND columnname = 'connec_type';
UPDATE config_form_fields SET widgettype = 'combo', dv_querytext = 'SELECT id, id as idval FROM cat_feature_gully JOIN cat_feature USING (id) WHERE active is true' WHERE formname = 'cat_grate' AND columnname = 'gully_type';


UPDATE sys_param_user SET layoutname ='lyt_utils' WHERE  layoutname ='lyt_gully';

INSERT INTO sys_table VALUES ('v_edit_inp_dwf', 'editable view for dry weather flows', 'role_epa', 0, null, null, null, null, null, null, null, null, 'giswater') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3036, 'gw_trg_edit_inp_dwf','ud','trigger function',null,null,'Trigger to make editable v_edit_inp_dwf','role_epa', NULL);

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["v_edit_raingage", "inp_inflows", "inp_inflows_pol_x_node","inp_timeseries_value"]}]'
WHERE id = 'inp_timeseries';

ALTER TABLE inp_subcatchment ALTER COLUMN conduct_2 SET DEFAULT 0;
ALTER TABLE inp_subcatchment ALTER COLUMN drytime_2 SET DEFAULT 10;

UPDATE config_form_fields SET hidden=true WHERE formname = 'v_edit_inp_subcatchment' AND columnname IN('conduct_2');

INSERT INTO sys_fprocess VALUES (381,'Check y0 on storage data', 'ud');
INSERT INTO sys_fprocess VALUES (382,'Check missed values for storage volume', 'ud');


--2021/05/31
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dwf', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields where formname = 'inp_dwf' and columnname!='value' on conflict (formname, formtype, columnname, tabname) do nothing;