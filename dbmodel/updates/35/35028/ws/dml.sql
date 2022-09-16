/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/08/31
UPDATE sys_param_user SET vdefault = '{"forceReservoirsOnInlets":true,"setDemand":true,"checkResult":true,"onlyIsOperative":true,"delDisconnNetwork":false,"removeDemandOnDryNodes":false,"breakPipes":{"status":false, "maxLength":10, "removeVnodeBuffer":1},"graphicLog":"true","steps":0,"autoRepair":true}'
WHERE id = 'inp_options_debug';

DELETE FROM sys_function where function_name = 'gw_fct_pg2epa_inlet_flowtrace';

UPDATE config_toolbox SET inputparams = b.inp FROM
(SELECT json_agg(a.inputs::json) AS inp FROM
(SELECT json_array_elements_text(inputparams) as inputs
FROM config_toolbox
WHERE id=2768
union select concat('{"widgetname":"commitChanges", "label":"Commit changes:", "widgettype":"check","datatype":"boolean","tooltip":"If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables" , "layoutname":"grl_option_parameters","layoutorder":',maxord+1,',"value":""}')
from (select max(d.layoutord::integer) as maxord from
(SELECT json_extract_path_text(json_array_elements(inputparams),'layoutorder') as layoutord
FROM config_toolbox
WHERE id=2768)d where layoutord is not null)e)a)b WHERE id=2768;

UPDATE sys_function SET descript='Function to analyze network as a graph. Multiple analysis is avaliable (SECTOR, DQA, PRESSZONE & DMA). Before start you need to configurate:
- Field graph_delimiter on [cat_feature_node] table. 
- Field graphconfig on [dma, sector, cat_presszone and dqa] tables.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
Stop your mouse over labels for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_graphanalytics_automatic_trigger variable on [config_param_system] table.'
WHERE id=2768;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active)
VALUES (3008, 'Arc reverse', '{"featureType":["arc"]}',null, null, TRUE)
ON CONFLICT (id) DO NOTHING;

UPDATE cat_feature_node SET isprofilesurface = false WHERE isprofilesurface IS NULL;


--2022/09/13
UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_demand' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_pipe' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_connec' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_controls' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_inlet' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_junction' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_pump' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_pump_additional' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_reservoir' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_rules' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_shortpipe' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_tank' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_valve' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_virtualvalve' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_demand' AND columnname ='pattern_id';


INSERT INTO om_typevalue VALUES ('waterbalance_method', 'CPW','CRM PERIOD WINDOW');
INSERT INTO om_typevalue VALUES ('waterbalance_method', 'DCW','DMA CENTROID WINDOW');

UPDATE config_toolbox SET inputparams = 
'
[{"widgetname":"executeGraphDma", "label":"Execute Graph for DMA:", "widgettype":"check","datatype":"boolean","tooltip":"If true, graphaanalytics mapzones will be triggered for DMA and expl selected" , "layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"period", "label":"Period:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT id, code as idval FROM ext_cat_period ORDER BY code", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"method", "label":"Method:","widgettype":"combo","datatype":"text","isMandatory":true,"tooltip":"Water balance method", "dvQueryText":"SELECT id, idval FROM om_typevalue WHERE typevalue = ''waterbalance_method''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""}
]'
WHERE id = 3142;

DELETE FROM config_report WHERE id IN (102,106);

UPDATE config_report set id = 102 WHERE id = 105;

UPDATE config_report SET alias = 'Losses & NRW by Exploitation, Dma & Period' , 
query_text = 'SELECT w.exploitation as "Exploitation", w.dma as "Dma", period as "Period", 
n.total_in::numeric(12,2) as "Total inlet",
n.total_out::numeric(12,2) as "Total outlet",
n.total::numeric(12,2) as "Total inyected",
auth_bill as "Auth. Bill", auth_unbill as "Auth. Unbill", auth as "Authorized", 
loss_app as "Losses App", loss_real as "Losses Real",loss as "Losses", 
(case when n.total > 0 then (auth/n.total)::numeric(12,2) else 0 end) as "Losses Efficiency" ,
rw as "Revenue", nrw as "Non Revenue", 
(case when n.total > 0 then (rw/n.total)::numeric(12,2) else 0.00 end) as "Revenue Efficiency",
w.ili::numeric(12,2) as "ILI"
FROM v_om_waterbalance w
JOIN v_om_waterbalance_efficiency n USING (dma, period)',
filterparam = '[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER by name","isNullValue":"true"},
{"columnname":"Dma", "label":"Dma:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select name as id, name as idval FROM dma WHERE dma_id != -1 and dma_id!=0 ORDER BY name","isNullValue":"true"},
{"columnname":"Period", "label":"Period:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select code as id, code as idval FROM ext_cat_period WHERE id IS NOT NULL ORDER BY code","isNullValue":"true"}]'
WHERE id =  102;


UPDATE config_report SET alias = 'Total Losses & NRW by Dma',
query_text = 'SELECT n.exploitation as "Exploitation", n.dma as "Dma", 
(sum(n.total))::numeric(12,2) as "Total input", sum(rw) as "Revenue", sum(nrw) as "Non Revenue", 
(case when sum(n.total) > 0 THEN (sum(rw)/sum(n.total))::numeric(12,2) else 0.00 end) as "Revenue Efficiency",
sum(auth) as "Authorized", sum(loss) as "Losses", 
(case when sum(n.total) > 0 THEN (sum(auth)/sum(n.total))::numeric(12,2) else 0.00 end) as "Losses Efficiency" 
FROM v_om_waterbalance_efficiency n WHERE n.dma IS NOT NULL',
filterparam = '[
{"columnname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER by name","isNullValue":"true"},
{"columnname":"dma", "label":"Dma:", "widgettype":"combo","datatype":"text","layoutorder":2, "dvquerytext":"Select name as id, name as idval FROM dma WHERE dma_id != -1 and dma_id!=0 ORDER BY name","isNullValue":"true"},
{"columnname":"crm_startdate", "label":"From Date:", "widgettype":"combo","datatype":"text","layoutorder":3,
"dvquerytext":"Select start_date::date as id, start_date::date as idval FROM ext_cat_period WHERE id IS NOT NULL ORDER BY start_date","isNullValue":"true", "filterSign":">=", "showOnTableModel":{"status":true, "position":3}},
{"columnname":"crm_enddate", "label":"To Date:", "widgettype":"combo","datatype":"text","layoutorder":4,
"dvquerytext":"Select end_date::date as id, end_date::date as idval FROM ext_cat_period WHERE id IS NOT NULL ORDER BY end_date desc","isNullValue":"true", "filterSign":"<=",  "showOnTableModel":{"status":true, "position":4}}]',
vdefault = '{"orderBy":"1", "orderType":"DESC", "queryAdd":"GROUP BY n.exploitation, n.dma"}'
WHERE id =  104;


UPDATE config_report SET alias = 'Total Losses & NRW by Exploitation',
query_text = 'SELECT n.exploitation as "Exploitation",
(sum(n.total))::numeric(12,2) as "Total input", sum(rw) as "Revenue", sum(nrw) as "Non Revenue", (sum(rw)/sum(n.total))::numeric(12,2) as "Revenue Efficiency",
sum(auth) as "Authorized", sum(loss) as "Losses", (sum(auth)/sum(n.total))::numeric(12,2) as "Losses Efficiency" 
FROM v_om_waterbalance_efficiency n  WHERE n.dma IS NOT NULL',
filterparam = '[
{"columnname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1, "dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER by name","isNullValue":"true"}, 
{"columnname":"crm_startdate", "label":"From Date:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select start_date::date as id, start_date::date as idval FROM ext_cat_period WHERE id IS NOT NULL ORDER BY start_date desc","isNullValue":"true", "filterSign":">=", "showOnTableModel":{"status":true, "position":2}},
{"columnname":"crm_enddate", "label":"To Date:", "widgettype":"combo","datatype":"text","layoutorder":3,
"dvquerytext":"Select end_date::date as id, end_date::date as idval FROM ext_cat_period WHERE id IS NOT NULL ORDER BY end_date desc","isNullValue":"true", "filterSign":"<=", "showOnTableModel":{"status":true, "position":3}}]',
vdefault = '{"orderBy":"1", "orderType":"DESC", "queryAdd":"GROUP BY n.exploitation"}'
WHERE id =  103;

UPDATE sys_function SET descript = 
'Function to calculate water balance according stardards of IWA.
Before that_
1) tables ext_cat_period, ext_rtc_hydrometer_x_data, ext_rtc_scada_x_data need to be filled.
2) DMA graph need to be executed.' 
WHERE id = 3142;

DELETE FROM sys_table WHERE id = 'v_om_waterbalance_nrw';
UPDATE sys_table SET id = 'v_om_waterbalance_efficiency' WHERE id = 'v_om_waterbalance_loss';



