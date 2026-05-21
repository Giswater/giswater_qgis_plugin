/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_toolbox SET
alias = 'Arcs shorter/bigger than specific length',
inputparams = '[{"label": "Arc length shorter than:", "datatype": "string", "layoutname": "grl_option_parameters", "widgetname": "shorterThan", "widgettype": "text", "layoutorder": 1}, 
{"label": "Arc length bigger than:", "datatype": "string", "layoutname": "grl_option_parameters", "widgetname": "biggerThan", "widgettype": "text", "layoutorder": 2}]'
WHERE id = 3052;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4356, 'Cannot delete system mapzone with id: %id%', NULL, 2, true, 'utils', 'core', 'UI') ON CONFLICT (id) DO NOTHING;

-- 15/09/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) 
VALUES(3514, 'gw_fct_cm_admin_manage_fields', 'utils', 'function', 'json', 'json', 'Funtion to auto-update cm views and tables to match their parent definitions.', 'role_admin', NULL, 'core', NULL);
UPDATE config_form_fields SET layoutorder = 1 WHERE formname ilike 've_%' AND formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'sector_id' AND layoutname = 'lyt_bot_1';
UPDATE config_form_fields SET layoutorder = 2 WHERE formname ilike 've_%' AND formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'omzone_id' AND layoutname = 'lyt_bot_1';

UPDATE config_typevalue
	SET idval='Set To Arc'
	WHERE typevalue='formactions_typevalue' AND id='actionSetToArc';

-- 16/09/2025
UPDATE sys_message SET error_message = 'There are no arcs with outlayers values' WHERE id = 3570;
UPDATE sys_message SET error_message = 'There are %v_count% arcs with outlayers values' WHERE id = 3572;

-- 19/09/2025
UPDATE config_form_fields SET widgettype = 'text', iseditable = true WHERE formname = 've_sector' AND columnname = 'sector_id';

INSERT INTO sys_message (id, error_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4358, 'It is not allowed to deactivate your current psector. Click on the Play button to exit psector mode and then, deactivate the psector.', 0, true, 'utils', 'core', 'UI');


UPDATE sys_fprocess SET query_text = '
SELECT * FROM (WITH 
	rgh as (SELECT min(roughness), max(roughness) FROM cat_mat_roughness),
	hdl as (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter=''inp_options_headloss'')
	SELECT 
		case when value = ''D-W'' and (min < 0.0025 or max > 0.15) then 1 
				when value = ''H-W'' and (min < 110 or max > 150) then 1
				when value = ''C-M'' and (min < 0.011 or max > 0.017) then 1
				else 0 END roughness
		from rgh, hdl) a WHERE roughness = 1' WHERE fid = 377;

UPDATE sys_fprocess SET query_text = '
SELECT a.arc_id FROM ve_arc a 
LEFT JOIN cat_arc b ON a.arccat_id = b.id
LEFT JOIN cat_mat_roughness c USING (matcat_id)
WHERE b.matcat_id IS NOT NULL AND c.roughness IS NULL' WHERE fid = 433;

-- 24/09/2025
UPDATE sys_fprocess 
SET except_msg='pumps with curve defined by 3 points found. Check if this 3-points has thresholds defined (133%) acording SWMM user''s manual'
WHERE fid=172;

-- 24/09/2025
UPDATE sys_param_user SET dv_isnullvalue=true WHERE id='inp_options_selecteddma';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4360, 'There is no dma selected. Please select one in the options', NULL, 0, true, 'utils', 'core', 'UI') ON CONFLICT (id) DO NOTHING;

-- 24/09/2025
INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
VALUES ('ve_link','tab_event','Events','List of events','role_basic',
'[{"actionName":"actionEdit",  "disabled":false},
{"actionName":"actionZoom",  "disabled":false},
{"actionName":"actionCentered",  "disabled":false},
{"actionName":"actionZoomOut" , "disabled":false},
{"actionName":"actionCatalog",  "disabled":false},
{"actionName":"actionWorkcat",  "disabled":false},
{"actionName":"actionCopyPaste",  "disabled":false},
{"actionName":"actionLink",  "disabled":false},
{"actionName":"actionMapZone",  "disabled":false},
{"actionName":"actionSetToArc",  "disabled":false},
{"actionName":"actionGetParentId",  "disabled":false},
{"actionName":"actionGetArcId", "disabled":false},
{"actionName": "actionRotation","disabled": false},
{"actionName":"actionInterpolate", "disabled":false}]'::json,
5,'{4,5}') ON CONFLICT (formname, tabname) DO NOTHING;

INSERT INTO config_form_list (listname,query_text,device,listtype,listclass,vdefault)
VALUES ('tbl_event_x_link','SELECT * FROM v_ui_event_x_link WHERE event_id IS NOT NULL',4,'tab','list','{"orderBy":"1", "orderType": "ASC"}'::json)
ON CONFLICT (listname, device) DO NOTHING;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_event','date_event_from','lyt_event_1',1,'date','datetime','From:','From:',false,false,true,false,true,'{"labelPosition": "top", "filterSign": ">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}'::json,'tbl_event_x_link',false,1)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_event','date_event_to','lyt_event_1',2,'date','datetime','To:','To:',false,false,true,false,true,'{"labelPosition": "top", "filterSign": "<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}'::json,'tbl_event_x_link',false,2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_event','parameter_type','lyt_event_1',3,'string','combo','Parameter type:','Parameter type:',false,false,true,false,true,'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_event_x_link',false,3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_event','parameter_id','lyt_event_1',4,'string','combo','Parameter:','Parameter:',false,false,true,false,true,'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_event_x_link',false,4)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link','form_feature','tab_event','btn_open_visit','lyt_event_2',1,'button','Open visit',false,false,true,false,false,'{"icon":"127"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "tab_event_tbl_event_cf", "sourceview": "event"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link','form_feature','tab_event','btn_new_visit','lyt_event_2',2,'button','New visit',false,false,true,false,false,'{"icon":"119"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "new_visit", "module": "info", "parameters":{}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
VALUES ('ve_link','form_feature','tab_event','hspacer_event_1','lyt_event_2',3,'hspacer',false,false,true,false,false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link','form_feature','tab_event','btn_open_gallery','lyt_event_2',4,'button','Open gallery',false,false,true,false,false,'{"icon":"145"}'::json,'{"onContextMenu":"Open gallery"}'::json,'{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"tab_event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link','form_feature','tab_event','btn_open_visit_doc','lyt_event_2',5,'button','Open visit document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}'::json,'{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind": "visit_id"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link','form_feature','tab_event','btn_open_visit_event','lyt_event_2',6,'button','Open visit event',false,false,true,false,false,'{"icon":"144"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}'::json,'{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_event','tbl_event_cf','lyt_event_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}'::json,'tbl_event_x_link',false,5)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_visit','date_visit_from','lyt_visit_1',1,'date','datetime','From:','From:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}'::json,false,1)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_visit','date_visit_to','lyt_visit_1',2,'date','datetime','To:','To:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}'::json,false,2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_visit','visit_class','lyt_visit_1',3,'string','combo','Visit class:','Visit class:',false,false,true,false,false,'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''LINK'',''ALL'') ',false,'{"labelPosition": "top"}'::json,'{"functionName": "manage_visit_class","parameters": {}}'::json,'tbl_event_x_link',false,3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
VALUES ('ve_link','form_feature','tab_visit','hspacer_lyt_document_1','lyt_visit_2',1,'hspacer',false,false,true,false,false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link','form_feature','tab_visit','open_gallery','lyt_visit_2',2,'button','Open gallery',false,false,true,false,false,'{"icon":"145"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link','form_feature','tab_visit','tbl_visits','lyt_visit_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{"functionName": "open_visit", "parameters": {"columnfind": "visit_id"}}'::json,false,4)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_event','date_event_from','lyt_event_1',1,'date','datetime','From:','From:',false,false,true,false,true,'{"labelPosition": "top", "filterSign": ">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}'::json,'tbl_event_x_link',false,1)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_event','date_event_to','lyt_event_1',2,'date','datetime','To:','To:',false,false,true,false,true,'{"labelPosition": "top", "filterSign": "<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}'::json,'tbl_event_x_link',false,2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_event','parameter_type','lyt_event_1',3,'string','combo','Parameter type:','Parameter type:',false,false,true,false,true,'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_event_x_link',false,3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_event','parameter_id','lyt_event_1',4,'string','combo','Parameter:','Parameter:',false,false,true,false,true,'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_event_x_link',false,4)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_pipelink','form_feature','tab_event','btn_open_visit','lyt_event_2',1,'button','Open visit',false,false,true,false,false,'{"icon":"127"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "tab_event_tbl_event_cf", "sourceview": "event"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_pipelink','form_feature','tab_event','btn_new_visit','lyt_event_2',2,'button','New visit',false,false,true,false,false,'{"icon":"119"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "new_visit", "module": "info", "parameters":{}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
VALUES ('ve_link_pipelink','form_feature','tab_event','hspacer_event_1','lyt_event_2',3,'hspacer',false,false,true,false,false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_pipelink','form_feature','tab_event','btn_open_gallery','lyt_event_2',4,'button','Open gallery',false,false,true,false,false,'{"icon":"145"}'::json,'{"onContextMenu":"Open gallery"}'::json,'{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"tab_event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_pipelink','form_feature','tab_event','btn_open_visit_doc','lyt_event_2',5,'button','Open visit document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}'::json,'{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind": "visit_id"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_pipelink','form_feature','tab_event','btn_open_visit_event','lyt_event_2',6,'button','Open visit event',false,false,true,false,false,'{"icon":"144"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}'::json,'{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_event','tbl_event_cf','lyt_event_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}'::json,'tbl_event_x_link',false,5)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_visit','date_visit_from','lyt_visit_1',1,'date','datetime','From:','From:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}'::json,false,1)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_visit','date_visit_to','lyt_visit_1',2,'date','datetime','To:','To:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}'::json,false,2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_visit','visit_class','lyt_visit_1',3,'string','combo','Visit class:','Visit class:',false,false,true,false,false,'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''LINK'',''ALL'') ',false,'{"labelPosition": "top"}'::json,'{"functionName": "manage_visit_class","parameters": {}}'::json,'tbl_event_x_link',false,3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
VALUES ('ve_link_pipelink','form_feature','tab_visit','hspacer_lyt_document_1','lyt_visit_2',1,'hspacer',false,false,true,false,false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_pipelink','form_feature','tab_visit','open_gallery','lyt_visit_2',2,'button','Open gallery',false,false,true,false,false,'{"icon":"145"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_pipelink','form_feature','tab_visit','tbl_visits','lyt_visit_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{"functionName": "open_visit", "parameters": {"columnfind": "visit_id"}}'::json,false,4)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_event','date_event_from','lyt_event_1',1,'date','datetime','From:','From:',false,false,true,false,true,'{"labelPosition": "top", "filterSign": ">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}'::json,'tbl_event_x_link',false,1)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_event','date_event_to','lyt_event_1',2,'date','datetime','To:','To:',false,false,true,false,true,'{"labelPosition": "top", "filterSign": "<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}'::json,'tbl_event_x_link',false,2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_event','parameter_type','lyt_event_1',3,'string','combo','Parameter type:','Parameter type:',false,false,true,false,true,'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_event_x_link',false,3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_event','parameter_id','lyt_event_1',4,'string','combo','Parameter:','Parameter:',false,false,true,false,true,'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_event_x_link',false,4)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_conduitlink','form_feature','tab_event','btn_open_visit','lyt_event_2',1,'button','Open visit',false,false,true,false,false,'{"icon":"127"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "tab_event_tbl_event_cf", "sourceview": "event"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_conduitlink','form_feature','tab_event','btn_new_visit','lyt_event_2',2,'button','New visit',false,false,true,false,false,'{"icon":"119"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "new_visit", "module": "info", "parameters":{}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
VALUES ('ve_link_conduitlink','form_feature','tab_event','hspacer_event_1','lyt_event_2',3,'hspacer',false,false,true,false,false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_conduitlink','form_feature','tab_event','btn_open_gallery','lyt_event_2',4,'button','Open gallery',false,false,true,false,false,'{"icon":"145"}'::json,'{"onContextMenu":"Open gallery"}'::json,'{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"tab_event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_conduitlink','form_feature','tab_event','btn_open_visit_doc','lyt_event_2',5,'button','Open visit document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}'::json,'{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind": "visit_id"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_conduitlink','form_feature','tab_event','btn_open_visit_event','lyt_event_2',6,'button','Open visit event',false,false,true,false,false,'{"icon":"144"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}'::json,'{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_event','tbl_event_cf','lyt_event_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}'::json,'tbl_event_x_link',false,5)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_visit','date_visit_from','lyt_visit_1',1,'date','datetime','From:','From:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}'::json,false,1)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_visit','date_visit_to','lyt_visit_1',2,'date','datetime','To:','To:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}'::json,false,2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_visit','visit_class','lyt_visit_1',3,'string','combo','Visit class:','Visit class:',false,false,true,false,false,'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''LINK'',''ALL'') ',false,'{"labelPosition": "top"}'::json,'{"functionName": "manage_visit_class","parameters": {}}'::json,'tbl_event_x_link',false,3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
VALUES ('ve_link_conduitlink','form_feature','tab_visit','hspacer_lyt_document_1','lyt_visit_2',1,'hspacer',false,false,true,false,false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_conduitlink','form_feature','tab_visit','open_gallery','lyt_visit_2',2,'button','Open gallery',false,false,true,false,false,'{"icon":"145"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_conduitlink','form_feature','tab_visit','tbl_visits','lyt_visit_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{"functionName": "open_visit", "parameters": {"columnfind": "visit_id"}}'::json,false,4)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_event','date_event_from','lyt_event_1',1,'date','datetime','From:','From:',false,false,true,false,true,'{"labelPosition": "top", "filterSign": ">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}'::json,'tbl_event_x_link',false,1)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_event','date_event_to','lyt_event_1',2,'date','datetime','To:','To:',false,false,true,false,true,'{"labelPosition": "top", "filterSign": "<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}'::json,'tbl_event_x_link',false,2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_event','parameter_type','lyt_event_1',3,'string','combo','Parameter type:','Parameter type:',false,false,true,false,true,'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_event_x_link',false,3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_event','parameter_id','lyt_event_1',4,'string','combo','Parameter:','Parameter:',false,false,true,false,true,'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_event_x_link',false,4)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_vlink','form_feature','tab_event','btn_open_visit','lyt_event_2',1,'button','Open visit',false,false,true,false,false,'{"icon":"127"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "tab_event_tbl_event_cf", "sourceview": "event"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_vlink','form_feature','tab_event','btn_new_visit','lyt_event_2',2,'button','New visit',false,false,true,false,false,'{"icon":"119"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "new_visit", "module": "info", "parameters":{}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
VALUES ('ve_link_vlink','form_feature','tab_event','hspacer_event_1','lyt_event_2',3,'hspacer',false,false,true,false,false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_vlink','form_feature','tab_event','btn_open_gallery','lyt_event_2',4,'button','Open gallery',false,false,true,false,false,'{"icon":"145"}'::json,'{"onContextMenu":"Open gallery"}'::json,'{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"tab_event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_vlink','form_feature','tab_event','btn_open_visit_doc','lyt_event_2',5,'button','Open visit document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}'::json,'{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind": "visit_id"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_vlink','form_feature','tab_event','btn_open_visit_event','lyt_event_2',6,'button','Open visit event',false,false,true,false,false,'{"icon":"144"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}'::json,'{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_event','tbl_event_cf','lyt_event_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}'::json,'tbl_event_x_link',false,5)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_visit','date_visit_from','lyt_visit_1',1,'date','datetime','From:','From:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}'::json,false,1)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_visit','date_visit_to','lyt_visit_1',2,'date','datetime','To:','To:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}'::json,false,2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_visit','visit_class','lyt_visit_1',3,'string','combo','Visit class:','Visit class:',false,false,true,false,false,'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''LINK'',''ALL'') ',false,'{"labelPosition": "top"}'::json,'{"functionName": "manage_visit_class","parameters": {}}'::json,'tbl_event_x_link',false,3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
VALUES ('ve_link_vlink','form_feature','tab_visit','hspacer_lyt_document_1','lyt_visit_2',1,'hspacer',false,false,true,false,false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
VALUES ('ve_link_vlink','form_feature','tab_visit','open_gallery','lyt_visit_2',2,'button','Open gallery',false,false,true,false,false,'{"icon":"145"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json,'tbl_event_x_link',false)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,hidden,web_layoutorder)
VALUES ('ve_link_vlink','form_feature','tab_visit','tbl_visits','lyt_visit_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{"functionName": "open_visit", "parameters": {"columnfind": "visit_id"}}'::json,false,4)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;

UPDATE config_form_fields
SET widgetfunction='{"functionName": "open_url"}'::json
WHERE formname='ve_link' AND formtype='form_feature' AND columnname='link' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetfunction='{"functionName": "open_url"}'::json
WHERE formname='ve_link_pipelink' AND formtype='form_feature' AND columnname='link' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetfunction='{"functionName": "open_url"}'::json
WHERE formname='ve_link_conduitlink' AND formtype='form_feature' AND columnname='link' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetfunction='{"functionName": "open_url"}'::json
WHERE formname='ve_link_vlink' AND formtype='form_feature' AND columnname='link' AND tabname='tab_data';
