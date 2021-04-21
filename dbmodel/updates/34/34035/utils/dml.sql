/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/04/15
UPDATE config_form_tabs SET orderby = 1 WHERE formname = 'search' AND tabname = 'tab_network' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby = 2 WHERE formname = 'search' AND tabname = 'tab_add_network' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby = 3 WHERE formname = 'search' AND tabname = 'tab_address' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby = 4 WHERE formname = 'search' AND tabname = 'tab_hydro' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby = 5 WHERE formname = 'search' AND tabname = 'tab_workcat' AND orderby IS NULL;
INSERT INTO config_form_tabs(formname, tabname, label, tooltip, sys_role, tabfunction, tabactions, device, orderby)
VALUES ('search', 'tab_visit', 'Visit', 'Visit', 'role_basic', NULL, NULL, 4, 6) 
ON CONFLICT (formname, tabname, device) DO UPDATE set orderby= 6 where config_form_tabs.orderby is null;
UPDATE config_form_tabs SET orderby = 7  WHERE formname = 'search' AND tabname = 'tab_psector' AND orderby IS NULL;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type) VALUES 
(379, 'Check undefined nodes as topological nodes', 'utils')  ON CONFLICT (fid) DO NOTHING;

UPDATE sys_message SET hint_message = 'If you are looking to unlink from this psector, it is necessary to remove it from ve_* or v_edit_* or using end feature tool.'
WHERE id = 3160;

INSERT INTO sys_message VALUES (3182, 'It is not allowed to downgrade (state=0) on psector tables for planned features (state=2). Planned features only must have state=1 on psector.' ,
'If you are looking for unlink it, please remove it from psector. If feature only belongs to this psector, and you are looking to unlink it, you will need to delete from ve_* or v_edit_* or use end feature tool.',
2, TRUE, 'utils');

UPDATE sys_table SET notify_action=
'[{"channel":"user","name":"set_layer_index", "enabled":"true", "trg_fields":"state","featureType":["connec", "v_edit_link"]}]'
WHERE id ='plan_psector_x_connec';

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('v_edit_node','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3','district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('v_edit_arc','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3','district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;


INSERT INTO config_form_fields(formname,  formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('v_edit_connec','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3','district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;