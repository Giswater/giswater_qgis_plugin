/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_table SET notify_action=
'[{"channel":"user","name":"set_layer_index", "enabled":"true", "trg_fields":"state","featureType":["gully", "v_edit_link"]}]'
WHERE id ='plan_psector_x_gully';

INSERT INTO config_form_fields(formname,  formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('v_edit_gully','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3','district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;

--2021/06/07
UPDATE config_form_tabs SET tabactions='[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]' WHERE formname='v_edit_gully';

UPDATE config_form_fields SET dv_querytext='SELECT DISTINCT (id) AS id, id AS idval FROM cat_grate WHERE id IS NOT NULL' WHERE formname='upsert_catalog_gully' AND columnname='id';
UPDATE config_form_fields SET dv_querytext='SELECT DISTINCT(matcat_id) AS id,  matcat_id  AS idval FROM cat_grate WHERE id IS NOT NULL' WHERE formname='upsert_catalog_gully' AND columnname='matcat_id';
