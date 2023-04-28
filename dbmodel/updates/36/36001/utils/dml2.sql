/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- element_id filter widgets
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json
	WHERE formname='arc' AND formtype='form_feature' AND columnname='element_id' AND tabname='element';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json
	WHERE formname='connec' AND formtype='form_feature' AND columnname='element_id' AND tabname='element';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json
	WHERE formname='node' AND formtype='form_feature' AND columnname='element_id' AND tabname='element';

UPDATE config_form_tabs SET "label"='Hydro'
	WHERE formname='v_edit_connec' AND tabname='tab_hydrometer' AND device=4;

-- web
-- selector
INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,device,orderby)
	VALUES ('selector_basic','tab_exploitation','Expl','Active exploitation','role_basic',5,1);
INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,device,orderby)
	VALUES ('selector_basic','tab_network_state','State','Network','role_basic',5,3);

-- search
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
    VALUES('basic_search_v2_address', '{"sys_display_name":"concat(s.name, '', '', m.name)","sys_filter_fields":"s.name", "sys_tablename":"v_ext_streetaxis s join ext_municipality m using(muni_id)","sys_tablename_aux":"v_ext_streetaxis", "sys_pk":"s.name", "sys_query_text_add":"SELECT distinct(concat(s.name, '', '', m.name, '', '', a.postnumber)) as display_name FROM v_ext_streetaxis s join ext_municipality m using(muni_id) join v_ext_address a on s.id = a.streetaxis_id WHERE concat(s.name, '', '', m.name, '', '', a.postnumber) ILIKE "}', 'Search configuration parameteres', 'Address:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
    VALUES('basic_search_v2_hydrometer', '{"sys_display_name":"concat(hydrometer_id, '' - '', connec_customer_code, '' - '', state)", "sys_pk":"hydrometer_id", "sys_tablename":"v_ui_hydrometer", "sys_fct":"gw_fct_getinfofromid", "sys_filter":""}', 'Search configuration parameteres', 'Hydrometer:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
    VALUES('basic_search_v2_network_arc', '{"sys_display_name":"concat(arc_id, '' : '', arccat_id)", "sys_tablename":"v_edit_arc", "sys_pk":"arc_id", "sys_fct":"gw_fct_getinfofromid", "sys_filter":""}', 'Search configuration parameteres', 'Arc:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
    VALUES('basic_search_v2_network_connec', '{"sys_display_name":"concat(connec_id, '' : '', connecat_id)", "sys_tablename":"v_edit_connec" ,"sys_pk":"connec_id", "sys_fct":"gw_fct_getinfofromid", "sys_filter":""}', 'Search configuration parameteres', 'Connec:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
    VALUES('basic_search_v2_network_node', '{"sys_display_name":"concat(node_id, '' : '', nodecat_id)", "sys_tablename":"v_edit_node", "sys_pk":"node_id", "sys_fct":"gw_fct_getinfofromid", "sys_filter":""}', 'Search configuration parameteres', 'Node:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
    VALUES('basic_search_v2_workcat', '{"sys_display_name":"id", "sys_tablename":"cat_work", "sys_pk":"id", "sys_filter":""}', 'Search configuration parameteres', 'Workcat:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- epa rpt widgets
UPDATE config_form_fields SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols, 'hiddenWhenNull', true) WHERE layoutname = 'lyt_epa_data_2' AND columnname != 'result_id';

-- manage datatype for epa widgets
UPDATE ws_36.config_form_fields c
SET "datatype" = CASE
                    WHEN format_type(atttypid, atttypmod) IN ('integer') THEN 'integer'
                    WHEN format_type(atttypid, atttypmod) IN ('double precision', 'numeric') THEN 'double'
                    ELSE 'string'
                 END
FROM pg_attribute a
WHERE a.attname = c.columnname
  AND a.attrelid = (SELECT oid FROM pg_class WHERE relname = c.formname LIMIT 1)
  AND formname like 've_epa%' AND widgettype = 'text';
