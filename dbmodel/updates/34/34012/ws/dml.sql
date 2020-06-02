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
 --SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, context,  descript, label, project_type, datatype, isdeprecated) 
VALUES ('basic_selector_hydrometer', '{"table":"ext_rtc_hydrometer_state", "selector":"selector_hydrometer", "table_id":"id",  "selector_id":"state_id",  "label":"id, '' - '', name", 
 "manageAll":true, "query_filter":""}', 'system', 'Select which label to display for selectors', 'Selector labels:', 'ws', 'json', FALSE);
 
  INSERT INTO config_typevalue (typevalue, id, idval) 
VALUES ('tabname_typevalue', 'tabHydrometer', 'tabHydrometer');

 INSERT INTO config_form_tabs (formname,tabname, label, tooltip, sys_role, device) 
VALUES ('hydrometer', 'tabHydrometer', 'Hydrometer', 'Hydrometer Selector', 'role_basic', 4);
