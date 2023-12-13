/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_tabs SET tabactions='[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false},
{"actionName": "actionHelp", "disabled": false}]'::json WHERE formname='v_edit_arc' AND tabname='tab_data';

UPDATE sys_param_user SET layoutorder=26 WHERE id='edit_node_ymax_vdefault';

--5/11/2023
UPDATE inp_curve SET active = true where active is null;
UPDATE inp_typevalue SET descript = 'RECT_OPEN' WHERE typevalue = 'inp_value_weirs' AND id = 'ROADWAY';

ALTER TABLE cat_arc ALTER COLUMN shape SET NOT NULL;

--22/11/2023
UPDATE inp_timeseries SET active = true where active is null;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario', 'CONTROLS', 'CONTROLS');

-- 29/11/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3290, 'gw_fct_create_hydrology_scenario_empty', 'ud', 'function', NULL, NULL, 'Function to create empty hydrology scenario', 'role_epa', NULL, 'core');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) 
VALUES(3290, 'Create empty Hydrology scenario', '{"featureType":[]}'::json, '[
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for hydrology scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"infiltration", "label":"Infiltration:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Infiltration", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"text", "label":"Text:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Text of hydrology scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"hydrology scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"}
]'::json, NULL, true, '{4}');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(523, 'Create hydrology scenario with empty values', 'ud', NULL, 'core', NULL, 'Function process', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3292, 'gw_fct_create_dwf_scenario_empty', 'ud', 'function', NULL, NULL, 'Function to create empty dwf scenario', 'role_epa', NULL, 'core');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) 
VALUES(3292, 'Create empty DWF scenario', '{"featureType":[]}'::json, '[
{"widgetname":"idval", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dwf scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"startdate", "label":"Start date:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"Start date for dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"enddate", "label":"Parent:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"", "placeholder":"End date for dwf scenario", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Observations of dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":"true"}
]'::json, NULL, true, '{4}');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(524, 'Create dwf scenario with empty values', 'ud', NULL, 'core', NULL, 'Function process', NULL);

UPDATE config_toolbox SET inputparams='[
  {"widgetname":"target", "label":"Target Scenario:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf_scenario c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDwf"},
  {"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user UNION SELECT -999,''ALL VISIBLE SECTORS'' ORDER BY 1 DESC", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userSector"},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["INSERT-ONLY", "DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["INSERT ONLY", "DELETE & COPY", "KEEP & COPY", "DELETE ONLY"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"INSERT-ONLY"},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf_scenario c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":4, "selectedId":""}
  ]'::json WHERE id=3102;
  
  
insert into config_toolbox (id,alias,functionparams, inputparams, observ, active, device)
values (3242, 'Set optimum outlet for subcatchments', '{"featureType":[]}', 
'[{"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user UNION SELECT -999,''ALL VISIBLE SECTORS'' ORDER BY 1 DESC ", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userSector"}]',
null, true, '{4}');

update sys_function set descript = 'Function to set optimum outlet for subcatchments according the closest node of network with less elevation that minimum elevation (minelev) of subcatchment' WHERE id = 3242;

-- 12/12/2023
UPDATE config_form_fields SET layoutname='lyt_data_1' WHERE formname='ve_gully_gully' AND formtype='form_feature' AND columnname='connec_y1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1' WHERE formname='ve_gully_pgully' AND formtype='form_feature' AND columnname='connec_y2' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1' WHERE formname='ve_gully_pgully' AND formtype='form_feature' AND columnname='connec_y1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1' WHERE formname='ve_gully_vgully' AND formtype='form_feature' AND columnname='connec_y1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1' WHERE formname='ve_gully_vgully' AND formtype='form_feature' AND columnname='connec_y2' AND tabname='tab_data';

-- gully
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'date_visit_from', 'lyt_visit_1', 1, 'date', 'datetime', 'From:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_gully', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'date_visit_to', 'lyt_visit_1', 2, 'date', 'datetime', 'To:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_gully', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'visit_class', 'lyt_visit_1', 3, 'string', 'combo', 'Visit class:', NULL, NULL, false, false, true, false, true, 'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''GULLY'',''ALL'') ', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_visit_x_gully', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'hspacer_lyt_document_1', 'lyt_visit_2', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'open_gallery', 'lyt_visit_2', 2, NULL, 'button', NULL, 'Open gallery', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"136b", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json, 'tbl_visit_x_gully', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'tbl_visits', 'lyt_visit_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}'::json, 'tbl_visit_x_gully', false, 4);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3294, 'gw_fct_duplicate_hydrology_scenario', 'ud', 'function', NULL, NULL, 'Function to duplicate hydrology scenario', 'role_epa', NULL, 'core');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3294, 'Duplicate Hydrology scenario', '{"featureType":[]}'::json, '[
{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT hydrology_id as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDscenario"},
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for hydrology scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"infiltration", "label":"Infiltration:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Infiltration", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"text", "label":"Text:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Text of hydrology scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"hydrology scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":"true"}
]'::json, NULL, true, '{4}');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(525, 'Duplicate hydrology scenario', 'ud', NULL, 'core', NULL, 'Function process', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3296, 'gw_fct_duplicate_dwf_scenario', 'ud', 'function', NULL, NULL, 'Function to duplicate dwf scenario', 'role_epa', NULL, 'core');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3296, 'Duplicate DWF scenario', '{"featureType":[]}'::json, '[
{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf_scenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDscenario"},
{"widgetname":"idval", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dwf scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"startdate", "label":"Start date:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"Start date for dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"enddate", "label":"Parent:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"", "placeholder":"End date for dwf scenario", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Observations of dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":7, "value":"true"}
]'::json, NULL, true, '{4}');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(526, 'Duplicate dwf scenario', 'ud', NULL, 'core', NULL, 'Function process', NULL);
