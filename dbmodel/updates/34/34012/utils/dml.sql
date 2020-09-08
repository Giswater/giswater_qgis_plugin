/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--DELETE FROM _temp_csv2pg_;

-- sys_param_user
UPDATE sys_param_user SET dv_querytext = replace(dv_querytext, 'fprocesscat_id', 'fid') WHERE id = 'edit_cadtools_baselayer_vdefault';
UPDATE sys_param_user SET dv_querytext = replace(dv_querytext, 'om_visit_parameter', 'config_visit_parameter') WHERE id = 'om_visit_parameter_vdefault';

-- config_csv
UPDATE config_csv SET active = TRUE;
UPDATE config_csv SET readheader = FALSE WHERE readheader IS NULL;

-- config_file
UPDATE config_file SET active = TRUE;

-- config_form_tableview
DELETE FROM config_form_tableview WHERE tablename IN ('om_psector', 'v_ui_scada_x_node', 'v_ui_scada_x_node_values');
UPDATE config_form_tableview SET tablename='config_form_fields' WHERE tablename='config_api_form_fields';
UPDATE config_form_tableview SET tablename='v_om_mincut_hydrometer' WHERE tablename='v_anl_mincut_result_hydrometer';
UPDATE config_form_tableview SET tablename='v_ui_mincut' WHERE tablename='v_ui_anl_mincut_result_cat';
UPDATE config_form_tableview SET tablename='v_ui_mincut' WHERE tablename='v_ui_anl_mincut_result_cat';

-- sys_table
UPDATE sys_table SET id = 'config_visit_class'  where id ='om_visit_class';

UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null where id ='config_csv';
UPDATE sys_table SET id = 'config_fprocess' WHERE id = 'config_csv_param';
UPDATE sys_table SET id = 'temp_csv' WHERE id = 'temp_csv2pg';
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null where id ='sys_foreignkey';
UPDATE sys_table SET sys_sequence = 'sys_addfields_id_seq', sys_sequence_field = 'id' where id ='sys_addfields';
INSERT INTO sys_table VALUES ('sys_typevalue', 'System', 'System typevalues', 'role_admin');
UPDATE sys_table SET isdeprecated = false WHERE id = 'sys_typevalue';
update sys_table set sys_sequence ='temp_csv_id_seq' where id = 'temp_csv';


-- sys_feature_type
ALTER TABLE sys_feature_type RENAME net_category TO classlevel;
UPDATE sys_feature_type SET classlevel = 5 WHERE classlevel  = 4;
UPDATE sys_feature_type SET classlevel = 4 WHERE classlevel  = 3;
UPDATE sys_feature_type SET classlevel = 3 WHERE classlevel  = 2;
UPDATE sys_feature_type SET classlevel = 2 WHERE id IN ('CONNEC' , 'GULLY');

-- sys_feature_cat
UPDATE sys_feature_cat SET epa_default = 'NONE' WHERE epa_default IS NULL;


-- sys_fprocess
UPDATE sys_fprocess set fid = fid+100 WHERE fid > 99;
UPDATE sys_fprocess set fid = fid+100 WHERE fid < 100;
UPDATE config_csv SET fid =234	WHERE fid =1;
UPDATE config_csv SET fid =235	WHERE fid =3;
UPDATE config_csv SET fid =236	WHERE fid =4;
UPDATE config_csv SET fid =237	WHERE fid =8;
UPDATE config_csv SET fid =238	WHERE fid =9;
UPDATE config_csv SET fid =141	WHERE fid =10;
UPDATE config_csv SET fid =140	WHERE fid =11;
UPDATE config_csv SET fid =239	WHERE fid =12;
UPDATE config_csv SET fid =240	WHERE fid =13;
UPDATE config_csv SET fid =241	WHERE fid =14;
UPDATE config_csv SET fid =242	WHERE fid =15;
UPDATE config_csv SET fid =243	WHERE fid =16;
UPDATE config_csv SET fid =244, orderby=6	WHERE fid =17;
UPDATE config_csv SET fid =245, orderby=7	WHERE fid =18;
UPDATE config_csv SET fid =246	WHERE fid =19;
UPDATE config_csv SET fid =247	WHERE fid =20;
UPDATE config_csv SET fid =154, orderby=8	WHERE fid =21;

DELETE FROM config_csv WHERE fid IN(2,5,6,7,140,141,239,240,246,247);
DELETE FROM sys_fprocess WHERE fid = 142;

INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (234,'Import db prices','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (235,'Import elements','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (236,'Import addfields','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (237,'Import dxf blocks','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (238,'Import om visit','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (239,'Import inp','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (240,'Import arc visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (241,'Import node visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (242,'Import connec visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (243,'Import gully visits','ud');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (244,'Import timeseries','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (245,'Import visit file','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (246,'Export ui','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (247,'Import ui','utils');

UPDATE sys_fprocess SET project_type='utils' WHERE fid=225;
UPDATE sys_fprocess SET project_type='utils' WHERE fid=227;
UPDATE sys_fprocess SET project_type='utils' WHERE fid=229;
UPDATE sys_fprocess SET project_type='utils' WHERE fid=230;
UPDATE sys_fprocess SET project_type='utils' WHERE fid=231;
UPDATE sys_fprocess SET project_type='ws' WHERE fid=224;
UPDATE sys_fprocess SET project_type='ws' WHERE fid=226;
UPDATE sys_fprocess SET project_type='ws' WHERE fid=228;
UPDATE sys_fprocess SET project_type='ws' WHERE fid=232;
UPDATE sys_fprocess SET project_type='ws' WHERE fid=233;


-- 
UPDATE config_form_tabs SET device = 4 WHERE device = 9;

--
UPDATE config_info_layer_x_type SET infotype_id = 1 WHERE infotype_id = 100;
UPDATE config_info_layer_x_type SET infotype_id = 2 WHERE infotype_id = 0;

UPDATE config_toolbox SET inputparams = (replace (inputparams::text, 'layout_order', 'layoutorder'))::json;
UPDATE config_toolbox SET active=TRUE;

UPDATE config_fprocess SET fid = 141 WHERE fid = 10;
UPDATE config_fprocess SET fid = 140 WHERE fid = 11;
UPDATE config_fprocess SET fid2 = 239 WHERE fid2 = 11;


DELETE FROM sys_foreignkey WHERE target_field = 'message_type';

UPDATE sys_foreignkey SET target_field = 'layoutname' WHERE target_field = 'layout_name';

DELETE FROM config_typevalue WHERE typevalue = 'datatype_typevalue' AND idval = 'character varying';

UPDATE config_form_fields SET layoutname = concat('lyt_',layoutname) WHERE layoutname  = 'data_1';
UPDATE config_form_fields SET layoutname = concat('lyt_',layoutname) WHERE layoutname  = 'data_2';
UPDATE config_form_fields SET layoutname = concat('lyt_data_3') WHERE layoutname  = 'data_9';


DELETE FROM config_typevalue WHERE typevalue = 'layout_name_typevalue' AND idval = 'data_1';
DELETE FROM config_typevalue WHERE typevalue = 'layout_name_typevalue' AND idval = 'data_2';
DELETE FROM config_typevalue WHERE typevalue = 'layout_name_typevalue' AND idval = 'data_9';

DELETE FROM config_typevalue WHERE typevalue = 'widgetfunction_typevalue' AND idval = 'gw_api_open_node';
DELETE FROM config_typevalue WHERE typevalue = 'widgetfunction_typevalue' AND idval = 'gw_api_open_url';
DELETE FROM config_typevalue WHERE typevalue = 'widgetfunction_typevalue' AND idval = 'gw_api_setprint';

UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'om_visit_class', 'config_visit_class')  WHERE dv_querytext like '%om_visit_class%';


DELETE FROM config_typevalue WHERE id = 'get_catalog_id';

DELETE FROM config_typevalue WHERE typevalue = 'mtype_typevalue';

DELETE FROM config_typevalue WHERE id = 'character varying' AND typevalue = 'datatype_typevalue';

DELETE FROM sys_function WHERE function_name = 'gw_api_getrowinsert';

UPDATE config_typevalue SET typevalue = 'linkedaction_typevalue' WHERE typevalue ='action_function_typevalue';
UPDATE config_typevalue set typevalue = 'listlimit_typevalue' WHERE typevalue ='listlimit';

UPDATE config_typevalue set id = 'info_generic', idval = 'info generic', camelstyle = 'infoGeneric' WHERE id = 'GENERIC';
UPDATE config_typevalue set id = 'info_feature', idval = 'info_feature', camelstyle = 'infoFeature' WHERE id = 'custom feature';

UPDATE config_typevalue SET camelstyle = idval WHERE typevalue = 'datatype_typevalue';

UPDATE config_typevalue set id = 'form_list_header', idval = 'form_list_header', camelstyle = 'formHeader' WHERE id = 'listHeader';
UPDATE config_typevalue set id = 'form_list_footer', idval = 'form_list_footer',camelstyle = 'formHooter' WHERE id = 'listFooter';


UPDATE config_typevalue set id = 'form_visit', idval = 'form_visit',camelstyle = 'formVisit' WHERE id = 'visit';
UPDATE config_typevalue set id = 'form_lot', idval = 'form_lot',camelstyle = 'formLot' WHERE id = 'lot';
UPDATE config_typevalue set id = 'form_generic', idval = 'form_generic',camelstyle = 'formGeneric' WHERE id = 'form';
UPDATE config_typevalue set id = 'form_feature', idval = 'form_feature',camelstyle = 'formFeature' WHERE id = 'feature';
UPDATE config_typevalue set id = 'form_catalog', idval = 'form_catalog',camelstyle = 'formCatalog' WHERE id = 'catalog';

UPDATE config_typevalue set camelstyle = 'actionCatalog' WHERE id = 'action_catalog';
UPDATE config_typevalue set camelstyle = 'actionLink' WHERE id = 'action_link';
UPDATE config_typevalue set camelstyle = 'actionWorkcat' WHERE id = 'action_workcat';
UPDATE config_typevalue SET camelstyle = idval WHERE typevalue ='widgettype_typevalue';

 

INSERT INTO config_typevalue VALUES ('infotype_typevalue','1','Complet info');
INSERT INTO config_typevalue VALUES ('infotype_typevalue','2','Basic info');

INSERT INTO config_typevalue VALUES ('device_typevalue','1','Mobile');
INSERT INTO config_typevalue VALUES ('device_typevalue','2','Tablet');
INSERT INTO config_typevalue VALUES ('device_typevalue','3','Web');
INSERT INTO config_typevalue VALUES ('device_typevalue','4','Desktop');


INSERT INTO config_typevalue VALUES ('widgettype_typevalue','textarea','Text area', 'textArea') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('device_typevalue','vspacer','vspacer','vspacer');
INSERT INTO config_typevalue VALUES ('device_typevalue','hspacer','hspacer','hspacer');
INSERT INTO config_typevalue VALUES ('device_typevalue','tableview','tableview', 'tableView');


UPDATE config_typevalue set camelstyle = 'layoutBottom1' WHERE id = 'lyt_bot_1';
UPDATE config_typevalue set camelstyle = 'layoutBottom2' WHERE id = 'lyt_bot_2';
UPDATE config_typevalue set camelstyle = 'layoutData1' WHERE id = 'lyt_data_1';
UPDATE config_typevalue set camelstyle = 'layoutData2' WHERE id = 'lyt_data_2';
UPDATE config_typevalue set camelstyle = 'layoutData3' WHERE id = 'lyt_data_3';
UPDATE config_typevalue set camelstyle = 'layoutDistance' WHERE id = 'lyt_distance';
UPDATE config_typevalue set camelstyle = 'layoutOther' WHERE id = 'lyt_other';
UPDATE config_typevalue set camelstyle = 'layoutDepth' WHERE id = 'lyt_depth';
UPDATE config_typevalue set camelstyle = 'layoutSymbology' WHERE id = 'lyt_symbology';
UPDATE config_typevalue set camelstyle = 'layoutTop1' WHERE id = 'lyt_top_1';

UPDATE config_typevalue SET id = 'datetime', idval = 'datetime' WHERE id = 'datepickertime';
UPDATE config_typevalue SET id = 'spinbox', idval = 'spinbox' WHERE id = 'doubleSpinbox';
UPDATE config_typevalue SET id = 'divider', idval = 'divider' WHERE id = 'formDivider';

UPDATE sys_param_user SET widgettype = 'divider' WHERE widgettype = 'formDivider';
UPDATE config_param_system SET widgettype = 'divider' WHERE widgettype = 'formDivider';

UPDATE config_typevalue set id = 'set_visit_manager_start', idval = 'set_visit_manager_start' WHERE id = 'gwSetVisitManagerStart';
UPDATE config_typevalue set id = 'set_visit_manager_end', idval = 'set_visit_manager_end' WHERE id = 'gwSetVisitManagerEnd';
UPDATE config_typevalue set id = 'get_visit_manager', idval = 'get_visit_manager' WHERE id = 'gwGetVisitManager';
UPDATE config_typevalue set id = 'get_visit', idval = 'get_visit' WHERE id = 'gwGetVisit';
UPDATE config_typevalue set id = 'set_visit_manager', idval = 'set_visit_manager' WHERE id = 'gwSetVisitManager';
UPDATE config_typevalue set id = 'set_visit', idval = 'set_visit' WHERE id = 'gwSetVisit';
UPDATE config_typevalue set id = 'get_lot', idval = 'get_lot' WHERE id = 'gwGetLot';
UPDATE config_typevalue set id = 'set_previous_form_back', idval = 'set_previous_form_back' WHERE id = 'backButtonClicked';

UPDATE config_typevalue set id = 'tab_user', idval = 'tab_user' WHERE id = 'tabUser';
UPDATE config_typevalue set id = 'tab_network_state', idval = 'tab_network_state' WHERE id = 'tabNetworkState';
UPDATE config_typevalue set id = 'tab_mincut', idval = 'tab_mincut' WHERE id = 'tabMincut';
UPDATE config_typevalue set id = 'tab_lot', idval = 'tab_lot' WHERE id = 'tabLots';
UPDATE config_typevalue set id = 'tab_hdyro_state', idval = 'tab_hdyro_state' WHERE id = 'tabHydroState';
UPDATE config_typevalue set id = 'tab_file', idval = 'tab_file' WHERE id = 'tabFiles';
UPDATE config_typevalue set id = 'tab_exploitation', idval = 'tab_exploitation' WHERE id = 'tabExploitation';
UPDATE config_typevalue set id = 'tab_done', idval = 'tab_done' WHERE id = 'tabDone';
UPDATE config_typevalue set id = 'tab_admin', idval = 'tab_admin' WHERE id = 'tabAdmin';

UPDATE config_typevalue set camelstyle = 'gwGetCatalogId' WHERE id = 'get_catalog_id';
UPDATE config_typevalue set camelstyle = 'tabWorkcat' WHERE id = 'tab_workcat';
UPDATE config_typevalue set camelstyle = 'tabVisit' WHERE id = 'tab_visit';
UPDATE config_typevalue set camelstyle = 'tabSearch' WHERE id = 'tab_search';
UPDATE config_typevalue set camelstyle = 'tabPsector' WHERE id = 'tab_psector';
UPDATE config_typevalue set camelstyle = 'tabRelations' WHERE id = 'tab_relations';
UPDATE config_typevalue set camelstyle = 'tabOm' WHERE id = 'tab_om';
UPDATE config_typevalue set camelstyle = 'tabNetwork' WHERE id = 'tab_network';
UPDATE config_typevalue set id = 'tab_epa', idval = 'tab_epa', camelstyle = 'tabEpa' WHERE id = 'tab_inp';

UPDATE config_typevalue set camelstyle = 'tabAddres' WHERE id = 'tab_address';
UPDATE config_typevalue set camelstyle = 'tabHydro' WHERE id = 'tab_hydro';
UPDATE config_typevalue set camelstyle = 'tabHydrometer' WHERE id = 'tab_hydrometer';
UPDATE config_typevalue set camelstyle = 'tabHydrometerVal' WHERE id = 'tab_hydrometer_val';
UPDATE config_typevalue set camelstyle = 'tabDocuments' WHERE id = 'tab_documents';
UPDATE config_typevalue set camelstyle = 'tabConnections' WHERE id = 'tab_connections';
UPDATE config_typevalue set camelstyle = 'tabData' WHERE id = 'tab_data';
UPDATE config_typevalue set camelstyle = 'tabElements' WHERE id = 'tab_elements';
UPDATE config_typevalue set id = 'get_info_node', idval ='get_info_node', camelstyle = 'gwGetInfoNode' WHERE id = 'info_node';
UPDATE config_typevalue set id = 'set_open_url', idval ='set_open_url', camelstyle = 'gwOpenUrl' WHERE id = 'open_url';

DELETE FROM config_typevalue WHERE id = 'gw_api_open_node';
DELETE FROM config_typevalue WHERE id = 'gw_api_open_url';
DELETE FROM config_typevalue WHERE id = 'gw_api_setprint';

UPDATE sys_foreignkey SET target_field = 'linkedaction', typevalue_name = 'linkedaction_typevalue' WHERE target_field = 'action_function';
UPDATE sys_foreignkey SET active=TRUE;

INSERT INTO config_param_system (parameter, value, context,  descript, label, project_type, datatype, isdeprecated) 
VALUES ('basic_selector_state', '{"table":"value_state", "selector":"selector_state", "table_id":"id",  "selector_id":"state_id",  "label":"id, '' - '', name", 
"manageAll":true, "query_filter":""}', 'system', 'Select which label to display for selectors', 'Selector labels:', 'utils', 'json', FALSE);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle) 
VALUES ('tabname_typevalue', 'tab_state', 'tabState', 'tabState');


--2020/06/03
INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden, layoutname)
VALUES ('v_edit_dma','form_generic', 'stylesheet', 'string', 'text', 'stylesheet',false, false, true, false, false, 'lyt_data_1');

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden, layoutname)
VALUES ('v_edit_sector','form_generic', 'stylesheet', 'string', 'text', 'stylesheet',false, false, true, false, false, 'lyt_data_1');



--2020/06/03 

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('ve_node','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3','district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('ve_arc','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3','district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('ve_connec','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3','district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('v_edit_samplepoint','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3', 'district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;