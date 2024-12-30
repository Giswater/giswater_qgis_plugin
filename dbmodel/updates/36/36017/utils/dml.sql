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

update config_param_system set value = 
'{"table":"macrosector","selector":"selector_macrosector","table_id":"macrosector_id","selector_id":"macrosector_id","label":"macrosector_id, '' - '', name","orderBy":"macrosector_id","manageAll":true,"query_filter":" AND macrosector_id > 0","typeaheadForced":true,"selectionMode":"keepPreviousUsingShift"}'::text
where parameter='basic_selector_tab_macrosector';

update config_param_system set value = 
'{"table":"macroexploitation","selector":"selector_macroexpl","table_id":"macroexpl_id","selector_id":"macroexpl_id","label":"macroexpl_id, '' - '', name","orderBy":"macroexpl_id","manageAll":true,"query_filter":" AND macroexpl_id > 0","typeaheadForced":true,"selectionMode":"keepPreviousUsingShift","explFromMacroexpl":false}'::text
where parameter='basic_selector_tab_macroexploitation';

update config_param_system set value = 
'{"table":"macroexploitation","selector":"selector_macroexpl","table_id":"macroexpl_id","selector_id":"macroexpl_id","label":"macroexpl_id, '' - '', name","orderBy":"macroexpl_id","manageAll":true,"query_filter":" AND macroexpl_id > 0","typeaheadForced":true,"selectionMode":"keepPreviousUsingShift","explFromMacroexpl":false}'::text
where parameter='basic_selector_tab_macroexploitation_add';

INSERT INTO config_form_tabs VALUES ('selector_basic','tab_exploitation_add', 'Expl Add', 'Active exploitation', 'role_basic',null,null,1,'{4,5}');

INSERT into config_param_system (parameter, value, descript, label, isenabled, project_type, datatype, widgettype)
VALUES ('basic_selector_tab_exploitation_add',	'{"table":"exploitation","selector":"selector_expl","table_id":"expl_id","selector_id":"expl_id","label":"expl_id, '' - '', name","orderBy":"expl_id","manageAll":true,"query_filter":"AND expl_id > 0","typeaheadFilter":" AND lower(concat(expl_id, '' - '', name))","typeaheadForced":true,"selectionMode":"keepPreviousUsingShift","sectorFromExpl":false}', 
'Variable to configura all options related to search for the specificic tab', 'Selector variables',false,'utils','json','text');

delete from config_param_system where parameter = 'basic_selector_mapzone_relation';

delete from config_param_system where parameter = 'basic_selector_explfrommuni';

insert into config_param_system (parameter, value, descript, label, project_type)
values ('basic_selector_options', '{"sectorfromexpl":true}',  'Options variables for selector',  'Selector variables', 'utils');

UPDATE config_param_system set isenabled = false where parameter = 'basic_selector_tab_municipality';