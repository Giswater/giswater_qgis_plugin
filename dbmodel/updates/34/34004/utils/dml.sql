/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/13
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_param_system", "column":"layout_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"audit_cat_param_user", "column":"layout_id"}}$$);

INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, project_type, datatype, widgettype, ismandatory, isdeprecated, standardvalue) 
VALUES ('sys_transaction_db', '{"status":false, "server":""}', 'system', 'Parameteres for use an additional database to scape transtaction logics of PostgreSQL in order to audit processes step by step', 
'Additional transactional database:', TRUE, 'utils', 'json', 'linetext', false, false, 'false') 
ON CONFLICT (parameter) DO NOTHING;


UPDATE audit_cat_param_user SET layoutname = 'lyt_other', formname='config', iseditable = true, layout_order=19 WHERE id ='debug_mode';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=9 WHERE id ='verified_vdefault';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=9 WHERE id ='verified_vdefault';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=10 WHERE id ='cad_tools_base_layer_vdefault';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=11 WHERE id ='edit_gully_doublegeom';
UPDATE audit_cat_param_user SET layoutname = 'lyt_other' , layout_order=17 WHERE id ='edit_upsert_elevation_from_dem';
UPDATE audit_cat_param_user SET formname ='hidden_param' WHERE id IN ('audit_project_epa_result', 'audit_project_plan_result');
UPDATE audit_cat_param_user SET layoutname = 'lyt_other' , layout_order=18 WHERE id ='api_form_show_columname_on_label';

UPDATE audit_cat_param_user SET formname ='hidden_param' , project_type = 'utils' WHERE id IN ('qgis_qml_linelayer_path', 'qgis_qml_pointlayer_path', 'qgis_qml_polygonlayer_path');

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2828, 'gw_api_get_visit', 'utils','api function', 'Get visit', 'role_basic',FALSE, FALSE, FALSE)
ON conflict (id) DO NOTHING;


--2020/02/26
INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, idval, label, dv_querytext, dv_parent_id, isenabled, layoutname, 
layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, 
ismandatory, widgetcontrols, vdefault, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, isdeprecated) 
VALUES ('qgis_form_log_hidden', 'config', 'Hide log form after executing a process', 'role_edit', NULL, 'Hide log form', NULL, NULL, true, 'lyt_other', 
20, 'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', true, NULL, 'true', NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2830, 'gw_fct_debug', 'utils','Function to manage messages', 'Function to manage messages', 'role_basic',FALSE, FALSE, FALSE)
ON conflict (id) DO NOTHING;



SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

--2020/03/13
UPDATE config_api_form_fields SET dv_querytext_filterc = replace(dv_querytext_filterc,'=','') WHERE dv_querytext_filterc is not null;

-- 2020/03/16
UPDATE  config_api_form_fields SET widgettype ='typeahead', dv_parent_id = 'streetname',
dv_querytext = 'SELECT a.postnumber AS id, a.postnumber AS idval FROM ext_address a JOIN ext_streetaxis m ON streetaxis_id=m.id WHERE a.id IS NOT NULL',
dv_querytext_filterc = 'AND m.name' 
WHERE column_id = 'postnumber';

UPDATE  config_api_form_fields SET widgettype ='typeahead', dv_parent_id = 'streetname2',
dv_querytext = 'SELECT a.postnumber AS id, a.postnumber AS idval FROM ext_address a JOIN ext_streetaxis m ON streetaxis_id=m.id WHERE a.id IS NOT NULL', 
dv_querytext_filterc = 'AND m.name' 
WHERE column_id = 'postnumber2';

UPDATE  config_api_form_fields SET column_id = 'streetname', label = 'streetname', widgettype = 'typeahead',
dv_querytext = 'SELECT id AS id, a.name AS idval FROM ext_streetaxis a JOIN ext_municipality m USING (muni_id) WHERE id IS NOT NULL', 
dv_querytext_filterc = 'AND m.name' 
WHERE column_id = 'streetaxis_id';

UPDATE  config_api_form_fields SET column_id = 'streetname2', label = 'streetname2', widgettype = 'typeahead',
dv_querytext = 'SELECT id AS id, a.name AS idval FROM ext_streetaxis a JOIN ext_municipality m USING (muni_id) WHERE id IS NOT NULL', 
dv_querytext_filterc = 'AND m.name' 
WHERE column_id = 'streetaxis2_id';


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_arc', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'macroexploitation - Identificador de la macroexplotacion. Se rellena automáticamente en función de la explotacion', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_arc', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'tstamp - Fecha de inserción del elemento a la base de datos', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_node', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'macroexploitation - Identificador de la macroexplotacion. Se rellena automáticamente en función de la explotacion', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_node', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'tstamp - Fecha de inserción del elemento a la base de datos', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_connec', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'macroexploitation - Identificador de la macroexplotacion. Se rellena automáticamente en función de la explotacion', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_connec', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'tstamp - Fecha de inserción del elemento a la base de datos', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_arc', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'macroexploitation - Identificador de la macroexplotacion. Se rellena automáticamente en función de la explotacion', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_arc', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'tstamp - Fecha de inserción del elemento a la base de datos', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_node', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'macroexploitation - Identificador de la macroexplotacion. Se rellena automáticamente en función de la explotacion', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_node', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'tstamp - Fecha de inserción del elemento a la base de datos', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_connec', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'macroexploitation - Identificador de la macroexplotacion. Se rellena automáticamente en función de la explotacion', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_connec', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'tstamp - Fecha de inserción del elemento a la base de datos', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;

UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'cat_arctype_id' and (formname  like '%ve_arc%' or formname  = 'v_edit_arc');
UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'nodetype_id' and (formname  like '%ve_node%' or formname  = 'v_edit_node');
UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'connectype_id' and (formname  like '%ve_connec%' or formname  = 'v_edit_connec');

UPDATE config_api_form_fields SET widgettype = 'text' where column_id = 'lastupdate';
UPDATE config_api_form_fields SET widgettype = 'combo' where column_id = 'macrosector_id';

--2020/03/31
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_feature_cat", "column":"orderby"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_feature_cat", "column":"shortcut_key"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_feature_cat", "column":"tablename"}}$$);

--2020/04/06
UPDATE config_api_form_fields SET ismandatory=FALSE WHERE ismandatory IS NULL;
UPDATE config_api_form_fields SET isparent=FALSE WHERE isparent IS NULL;
UPDATE config_api_form_fields SET iseditable=FALSE WHERE iseditable IS NULL;
UPDATE config_api_form_fields SET isautoupdate=FALSE WHERE isautoupdate IS NULL;
UPDATE config_api_form_fields SET dv_orderby_id=TRUE WHERE dv_orderby_id IS NULL AND widgettype = 'combo';
UPDATE config_api_form_fields SET dv_isnullvalue=FALSE WHERE dv_isnullvalue IS NULL AND widgettype = 'combo';

UPDATE config_api_form_fields SET dv_querytext = 'SELECT macrosector_id as id, name as idval FROM macrosector where macrosector_id is not null' WHERE column_id='macrosector_id' AND formname='v_edit_macrosector';
UPDATE config_api_form_fields SET widgettype = 'nowidget' WHERE column_id='net_code' AND formname='search';

UPDATE config_api_form_fields SET tooltip = 'pjoint_id - Identificador del punto de unión con la red' WHERE column_id = 'pjoint_id' AND tooltip = 'pjoint_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'pjoint_type - Tipo de punto de unión con la red' WHERE column_id = 'pjoint_type' AND tooltip = 'pjoint_type' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'feature_id - Identificador del elemento al cual se conecta' WHERE column_id = 'feature_id' AND tooltip = 'feature_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'featurecat_id - Catálogo del elemento al cual se conecta' WHERE column_id = 'featurecat_id' AND tooltip = 'featurecat_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'inventory - Para establecer si el elemento pertenece o debe pertenecer a inventario o no' WHERE column_id = 'inventory' AND tooltip = 'inventory' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'publish - Para establecer si el elemento es publicable o no' WHERE column_id = 'publish' AND tooltip = 'publish' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'undelete - Para establecer si el elemento no se puede eliminar' WHERE column_id = 'undelete' AND tooltip = 'undelete' AND formtype='feature';


UPDATE config_api_form_fields SET tooltip = 'pol_id - Identificador del polígono relacionado' WHERE column_id = 'pol_id' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'name - Nombre específico del elemento' WHERE column_id = 'name' AND tooltip IS NULL AND formtype='feature';
