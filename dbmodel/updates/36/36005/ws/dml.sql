/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_report SET query_text = 
'SELECT w.exploitation as "Exploitation", w.dma as "Dma", period as "Period", 
total_in::numeric(20,2) as "Total inlet",
total_out::numeric(20,2) as "Total outlet",
total::numeric(20,2) as "Total injected",
auth_bill as "Auth. Bill", auth_unbill as "Auth. Unbill", auth as "Authorized", 
loss_app as "Losses App", loss_real as "Losses Real",loss as "Losses", 
(case when total > 0 then (auth/total)::numeric(20,2) else 0 end) as "Losses Efficiency" ,
rw as "Revenue", nrw as "Non Revenue", 
(case when total > 0 then (rw/total)::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
w.ili::numeric(20,2) as "ILI"
FROM v_om_waterbalance w' where id = 102;

UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation",
(sum(n.total))::numeric(20,2) as "Total input", sum(rw) as "Revenue", sum(nrw) as "Non Revenue", 
(case when sum(n.total) > 0 THEN (sum(rw)/sum(n.total))::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
sum(auth) as "Authorized", sum(loss) as "Losses", 
(case when sum(n.total) > 0 THEN (sum(auth)/sum(n.total))::numeric(20,2) else 0.00 end) as "Losses Efficiency"
FROM v_om_waterbalance n  WHERE n.dma IS NOT NULL' where id = 103;

UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation", n.dma as "Dma", 
(sum(n.total))::numeric(20,2) as "Total input", sum(rw) as "Revenue", sum(nrw) as "Non Revenue", 
(case when sum(n.total) > 0 THEN (sum(rw)/sum(n.total))::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
sum(auth) as "Authorized", sum(loss) as "Losses", 
(case when sum(n.total) > 0 THEN (sum(auth)/sum(n.total))::numeric(20,2) else 0.00 end) as "Losses Efficiency",
(avg(n.ili))::numeric(20,2) as "ILI"
FROM v_om_waterbalance n WHERE n.dma IS NOT NULL' where id = 104;

DELETE FROM sys_function WHERE id = 3106;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_dma','form_feature', 'tab_none', 'active', 'lyt_data_1', 7, 'boolean', 'check', 'active', null, null, false, false, 
true, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('v_edit_plan_netscenario_dma','form_feature', 'tab_none', 'active', 'lyt_data_1', 7, 'boolean', 'check', 'active', null, null, false, false, 
true, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_presszone','form_feature', 'tab_none', 'active', 'lyt_data_1', 7, 'boolean', 'check', 'active', null, null, false, false, 
true, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('v_edit_plan_netscenario_presszone','form_feature', 'tab_none', 'active', 'lyt_data_1', 7, 'boolean', 'check', 'active', null, null, false, false, 
true, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_dma','form_feature', 'tab_none', 'lastupdate', 'lyt_data_1', 7, 'string', 'text', 'lastupdate', null, null, false, false, 
false, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_dma','form_feature', 'tab_none', 'lastupdate_user', 'lyt_data_1', 7, 'string', 'text', 'lastupdate_user', null, null, false, false, 
false, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_presszone','form_feature', 'tab_none', 'lastupdate', 'lyt_data_1', 7, 'string', 'text', 'lastupdate', null, null, false, false, 
false, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_presszone','form_feature', 'tab_none', 'lastupdate_user', 'lyt_data_1', 7, 'string', 'text', 'lastupdate_user', null, null, false, false, 
false, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


UPDATE config_form_fields SET iseditable=false where formname='plan_netscenario' and columnname='netscenario_id';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 where formname='plan_netscenario' and columnname='descript';
UPDATE config_form_fields SET layoutorder=4 where formname='plan_netscenario' and columnname='netscenario_type';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 where formname='plan_netscenario' and columnname='expl_id';
UPDATE config_form_fields SET layoutorder=6 where formname='plan_netscenario' and columnname='parent_id';
UPDATE config_form_fields SET layoutorder=7 where formname='plan_netscenario' and columnname='active';
UPDATE config_form_fields SET iseditable=false and layoutorder=8 where formname='plan_netscenario' and columnname='log';


UPDATE config_form_fields SET dv_querytext = 
'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_valve'' '
WHERE formname in ('v_edit_inp_dscenario_valve', 've_epa_valve', 've_epa_shortpipe') and columnname = 'status';

UPDATE config_form_fields SET dv_querytext = 
'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_pipe'' '
WHERE formname in ('ve_epa_shortpipe', 'v_edit_inp_shortpipe', 'v_edit_inp_dscenario_shortpipe') and columnname = 'status';

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, "source") 
VALUES(3248, 'There is no street data available', 'Please draw tramified streets on om_streetaxis table', 2, false, 'ws', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_edit_plan_netscenario_valve' , 'Editable view to visualize valve related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 6, 'Netscenario valve', '{"pkey":"netscenario_id, node_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, addparam)
VALUES ('plan_netscenario_valve' , 'Table of valve related to selected netscenario', 'role_master', 'core', '{"pkey":"netscenario_id, node_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (514, 'Import valve closed into netscenario', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;
	
INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (514, 'Import netscenario closed valves ','The csv file must have the following fields:
netscenario_id, node_id, closed', 'gw_fct_import_netscenario_valve_closed', true, 23,null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3278, 'gw_fct_import_netscenario_valve_closed', 'ws', 'function', 'json', 'json', 'Function to import closed valve into netscenario', 'role_epa', null, 'core') ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET inputparams = b.inp FROM (SELECT json_agg(a.inputs) AS inp FROM
(SELECT json_array_elements(inputparams)as inputs, json_extract_path_text(json_array_elements(inputparams),'widgetname') as widget
FROM   config_toolbox 
WHERE id=2768)a WHERE widget!='usePlanPsector')b WHERE  id=2768;

UPDATE config_toolbox SET inputparams = b.inp FROM (SELECT json_agg(a.inputs) AS inp FROM
(SELECT json_array_elements(inputparams)as inputs, json_extract_path_text(json_array_elements(inputparams),'widgetname') as widget
FROM   config_toolbox 
WHERE id=3256)a WHERE widget!='dscenario_valve')b WHERE  id=3256;

UPDATE sys_function SET descript='Function to calculate water balance according stardards of IWA.
Before that: 
1) tables ext_cat_period, ext_rtc_hydrometer_x_data, ext_rtc_scada_x_data need to be filled.
2) DMA graph need to be executed.' WHERE id=3142;


-- 3/10/2023
update config_toolbox set device = '{4}' WHERE id in (2768,2110);

INSERT INTO config_report (id, alias, query_text, addparam, filterparam, sys_role, active, device) VALUES
(105, 'Nodes by exploitation and type', 'SELECT name as "Exploitation", node_type as "Node type", count(*) as "Units" FROM v_edit_node JOIN exploitation USING (expl_id) GROUP BY node_type, name',
 '{"orderBy":"1", "orderType": "DESC"}',
 '[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER BY name","isNullValue":"true"},
{"columnname":"Node type", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select id as id, id as idval FROM cat_feature_node join cat_feature USING (id) WHERE id IS NOT NULL AND active ORDER BY id","isNullValue":"true"}]',
'role_basic', true, '{4,5}')
ON CONFLICT (id) DO NOTHING;

UPDATE config_form_fields set columnname ='bulk_coeff' where columnname ='buk_coeff';

UPDATE config_form_fields set columnname ='init_quality' where columnname ='initial_quality';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_status_pipe''', 
dv_orderby_id=true, dv_isnullvalue = true, widgettype='combo' WHERE  columnname 
ilike 'status' and formname = 've_epa_connec';

UPDATE config_form_fields set columnname ='energy_pattern_id' where columnname ='price_pattern' and formname = 've_epa_pump';