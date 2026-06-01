/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"streetname2", "dataType":"varchar(100)"}}$$);

CREATE TABLE selector_macroexpl (
macroexpl_id integer,
cur_user text default current_user);

ALTER TABLE selector_macroexpl ADD CONSTRAINT selector_macroexpl_pkey PRIMARY KEY (macroexpl_id,cur_user);

CREATE TABLE selector_macrosector (
macrosector_id integer,
cur_user text default current_user);

ALTER TABLE selector_macrosector ADD CONSTRAINT selector_macrosector_pkey PRIMARY KEY (macrosector_id,cur_user);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"streetname2", "dataType":"varchar(100)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"dimensions", "column":"workcat_id", "dataType":"varchar(255)", "isUtils":"False"}}$$);
ALTER TABLE dimensions ADD CONSTRAINT dimensions_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE element ALTER COLUMN muni_id DROP NOT NULL;
ALTER TABLE element ALTER COLUMN sector_id DROP NOT NULL;


DROP FUNCTION IF EXISTS gw_trg_edit_foreignkey() CASCADE;



update arc set streetname = s.descript from v_ext_streetaxis s where streetaxis_id = id;
update node set streetname = s.descript from v_ext_streetaxis s where streetaxis_id = id;
update connec set streetname = s.descript from v_ext_streetaxis s where streetaxis_id = id;

UPDATE config_form_tabs SET orderby = orderby+1 where formname = 'selector_basic' and orderby > 1;

UPDATE config_form_tabs SET orderby = 2 where formname = 'selector_basic' and tabname = 'tab_municipality';


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
set value = '{"table":"temp_t_mincut","table_id":"id","selector":"selector_mincut_result","selector_id":"result_id","label":"id, ''('', CASE WHEN work_order IS NULL THEN ''N/I'' ELSE work_order END, '') on '', forecast_start::date, '' at '', forecast_start::time, ''H-'', forecast_end::time,''H''","query_filter":"","manageAll":true}'
where parameter = 'basic_selector_tab_mincut';


UPDATE config_form_fields SET dv_querytext = 'SELECT sector_id as id,name as idval FROM v_edit_sector WHERE sector_id > -1',
widgetcontrols = '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id",
"valueColumn": "name", "filterExpression": "sector_id > -1"}}'
WHERE formname = 'v_edit_sector' AND formtype = 'form_feature' AND tabname = 'tab_none' AND columnname = 'parent_id';


UPDATE config_param_system SET isenabled = false where parameter = ' basic_selector_tab_municipality';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_dimensions', 'form_feature', 'tab_none', 'workcat_id', 'lyt_other', 13, 'integer', 'typeahead', 'workcat_id', 'workcat_id', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3282, 'The inserted catalog value does not exist -->', 'Please review and insert it into the related catalog table', 2, true, 'utils', 'core');

DELETE FROM config_form_fields WHERE formname = 've_epa_valve' AND columnname = 'to_arc';


UPDATE sys_function SET function_name='gw_trg_edit_controls', project_type='utils', function_type='trigger', input_params=NULL, return_type=NULL, descript='Trigger to manage controls', sys_role='role_edit', sample_query=NULL, "source"='core' WHERE id=2718;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3284, 'Cannot modify or delete record - undelete flag is set', 'Please review the undelete flag', 2, true, 'utils', 'core');



CREATE INDEX arc_streetname ON arc USING btree (streetname);
CREATE INDEX arc_streetname2 ON arc USING btree (streetname2);

CREATE INDEX node_streetname ON node USING btree (streetname);
CREATE INDEX node_streetname2 ON node USING btree (streetname2);

CREATE INDEX connec_streetname ON connec USING btree (streetname);
CREATE INDEX connec_streetname2 ON connec USING btree (streetname2);

CREATE INDEX link_expl_id2 ON link USING btree (expl_id2);

ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_expl_id_fkey;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_expl_id_fkey 
FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX rpt_arc_arc_id ON rpt_arc USING btree (arc_id);
CREATE INDEX rpt_arc_result_id ON rpt_arc USING btree (result_id);


