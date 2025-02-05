/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 23/12/2024
update arc set streetname = s.descript from v_ext_streetaxis s where streetaxis_id = id;
update node set streetname = s.descript from v_ext_streetaxis s where streetaxis_id = id;
update connec set streetname = s.descript from v_ext_streetaxis s where streetaxis_id = id;

UPDATE config_form_tabs SET orderby = orderby+1 where formname = 'selector_basic' and orderby > 1;

UPDATE config_form_tabs SET orderby = 2 where formname = 'selector_basic' and tabname = 'tab_municipality';

-- 30/12/2024
UPDATE sys_table set sys_role='role_edit' where id = 'sector';
UPDATE sys_table set sys_role='role_basic' where id = 'config_user_x_expl';

INSERT INTO config_form_tabs VALUES ('selector_basic','tab_exploitation_add', 'Expl Add', 'Active exploitation', 'role_basic',null,null,1,'{4,5}');

INSERT into config_param_system (parameter, value, descript, label, isenabled, project_type, datatype, widgettype)
VALUES ('basic_selector_tab_exploitation_add',	'{"table":"vu_exploitation","selector":"selector_expl","table_id":"expl_id","selector_id":"expl_id","label":"expl_id, '' - '', name","orderBy":"expl_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(expl_id, '' - '', name))", "selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}',
'Variable to configura all options related to search for the specificic tab', 'Selector variables',false,'utils','json','text');

delete from config_param_system where parameter = 'basic_selector_mapzone_relation';

delete from config_param_system where parameter = 'basic_selector_explfrommuni';

delete from config_param_system where parameter = 'basic_selector_options';
insert into config_param_system (parameter, value, descript, label, project_type)
values ('basic_selector_options', '{"sectorFromExpl":false, "explFromMacro":false, "sectorFromMacro":false, "muniClientFilter":false, "sectorClientFilter":false}',  'Options variables for selector',  'Selector variables', 'utils');

UPDATE config_param_system set isenabled = false where parameter = 'basic_selector_tab_municipality';

INSERT INTO sys_table (id, descript, sys_role, source) VALUES ('selector_macroexpl','Selector for macroexploitations', 'role_basic', 'core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES ('selector_macrosector','Selector for macroexploitations', 'role_basic', 'core');

INSERT INTO sys_table (id, descript, sys_role, source) VALUES ('vu_exploitation','View of all exploitations related to user', 'role_basic', 'core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES ('vu_macroexploitation','View of all macroexploitations related to user', 'role_basic', 'core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES ('vu_macrosector','View of all macrosectors related to user', 'role_basic', 'core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES ('vu_ext_municipality','View of all municipalities related to user', 'role_basic', 'core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES ('vu_om_mincut','View of all mincuts related to user', 'role_basic', 'core');

update config_param_system
set value = '{"table":"temp_sector","selector":"selector_sector","table_id":"sector_id","selector_id":"sector_id","label":"sector_id, '' - '', name","orderBy":"sector_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(sector_id, '' - '', name))", "selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}'
where parameter = 'basic_selector_tab_sector';

update config_param_system
set value = '{"table":"temp_exploitation","selector":"selector_expl","table_id":"expl_id","selector_id":"expl_id","label":"expl_id, '' - '', name","orderBy":"expl_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(expl_id, '' - '', name))","selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}'
where parameter = 'basic_selector_tab_exploitation';

update config_param_system set value =
'{"table":"temp_macrosector","selector":"selector_macrosector","table_id":"macrosector_id","selector_id":"macrosector_id","label":"macrosector_id, '' - '', name","orderBy":"macrosector_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(macrosector_id, '' - '', name))", "selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}'::text
where parameter='basic_selector_tab_macrosector';

update config_param_system set value =
'{"table":"temp_macroexploitation","selector":"selector_macroexpl","table_id":"macroexpl_id","selector_id":"macroexpl_id","label":"macroexpl_id, '' - '', name","orderBy":"macroexpl_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(macroexpl_id, '' - '', name))", "selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}'::text
where parameter='basic_selector_tab_macroexploitation';

update config_param_system
set isenabled = false, value = '{"table":"ext_municipality","selector":"selector_municipality","table_id":"muni_id","selector_id":"muni_id","label":"muni_id, ''- '', name","orderBy":"muni_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(muni_id, '' - '', name))","selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}'
where parameter = 'basic_selector_tab_municipality';

update config_param_system
set value = '{"table":"macroexploitation","selector":"selector_expl","table_id":"macroexpl_id","selector_id":"expl_id","label":"macroexpl_id, '' - '', name","orderBy":"macroexpl_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(macroexpl_id, '' - '', name))", "selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}'
where parameter = 'basic_selector_tab_macroexploitation_add';

update config_param_system
set value = '{"table":"temp_mincut","table_id":"id","selector":"selector_mincut_result","selector_id":"result_id","label":"id, ''('', CASE WHEN work_order IS NULL THEN ''N/I'' ELSE work_order END, '') on '', forecast_start::date, '' at '', forecast_start::time, ''H-'', forecast_end::time,''H''","query_filter":"","manageAll":true}'
where parameter = 'basic_selector_tab_mincut';

-- 13/01/2025
UPDATE config_form_fields SET dv_querytext = 'SELECT sector_id as id,name as idval FROM v_edit_sector WHERE sector_id > -1',
widgetcontrols = '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id",
"valueColumn": "name", "filterExpression": "sector_id > -1"}}'
WHERE formname = 'v_edit_sector' AND formtype = 'form_feature' AND tabname = 'tab_none' AND columnname = 'parent_id';


UPDATE config_param_system SET isenabled = false where parameter = ' basic_selector_tab_municipality';


