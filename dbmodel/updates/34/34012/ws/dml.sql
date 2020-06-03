/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/31
UPDATE sys_param_user SET dv_querytext = 'SELECT presszone.presszone_id AS id, presszone.name AS idval FROM presszone WHERE presszone_id IS NOT NULL' 
WHERE id = 'presszone_vdefault';

 UPDATE config_form_fields SET  dv_querytext = 'SELECT presszone.presszone_id AS id, presszone.name AS idval FROM presszone WHERE presszone_id IS NOT NULL' 
 WHERE columnname = 'presszone_id';
 
 -- 2020/06/02
INSERT INTO config_param_system (parameter, value, context,  descript, label, project_type, datatype, isdeprecated) 
VALUES ('basic_selector_hydrometer', '{"table":"ext_rtc_hydrometer_state", "selector":"selector_hydrometer", "table_id":"id",  "selector_id":"state_id",  "label":"id, '' - '', name", 
"manageAll":true, "query_filter":""}', 'system', 'Select which label to display for selectors', 'Selector labels:', 'ws', 'json', FALSE);
 

INSERT INTO config_form_tabs (formname,tabname, label, tooltip, sys_role, device) 
VALUES ('hydrometer', 'tab_hydrometer', 'Hydrometer', 'Hydrometer Selector', 'role_basic', 4);


--2020/06/03
INSERT INTO config_form_fields(formname, formtype, columnname,datatype, widgettype, label, ismandatory, isparent,  iseditable, isautoupdate, hidden)
VALUES ('v_edit_presszone','form_generic', 'head','string', 'text', 'Head',false, false, true, false, false);

INSERT INTO config_form_fields(formname, formtype, columnname,datatype, widgettype, label, ismandatory, isparent,  iseditable, isautoupdate, hidden)
VALUES ('v_edit_presszone','form_generic', 'stylesheet','string', 'text', 'Stylesheet',false, false, true, false, false);

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dqa','form_generic', 'stylesheet', 'string', 'text', 'stylesheet',false, false, true, false, false);