/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/06
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_rules', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_rules';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_rules', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE columnname='dscenario_id' AND formname='v_edit_inp_dscenario_junction';

INSERT INTO sys_table(id, descript, sys_role,  context, orderby, alias, source)
VALUES ('inp_dscenario_rules', '"Table to manage scenario for rules"', 'role_epa', null,null,NULL, 'core');

INSERT INTO sys_table(id, descript, sys_role,  context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_rules', '"Editable view to manage scenario for rules"', 'role_epa',  '{"level_1":"EPA","level_2":"DSCENARIO"}',16, 'Rules Dscenario', 
'core');

INSERT INTO inp_typevalue (typevalue, id, idval)
VALUES ('inp_value_demandtype',3,'HYDRANT');

INSERT INTO sys_table(id, descript, sys_role,  context, orderby, alias, source)
VALUES ('crm_zone', 'Table with polygonal geometry to relate connecs to a map zone about crm', 'role_basic', null,null,NULL, 'core');

--2022/04/17
DELETE FROM sys_table WHERE id = 'rtc_scada_node';

INSERT INTO sys_table (id, descript, sys_role, criticity, source)
VALUES ('ext_rtc_scada', 'Table to manage scada assets', 'role_basic', 0, 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, criticity, source)
VALUES ('ext_rtc_scada_x_data', 'Table to manage scada values (aggregated by period', 'role_basic', 0, 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, criticity, source)
VALUES ('om_waterbalance', 'Table to manage water balance values according IWA standards by period and DMA', 'role_om', 0, 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, criticity, source)
VALUES ('v_om_waterbalance', 'View to show water balance values according IWA standards by period and DMA', 'role_om', 0, 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, criticity, source)
VALUES ('v_om_waterbalance_loss', 'View to show water losses values according IWA standards by period and DMA', 'role_om', 0, 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, criticity, source)
VALUES ('v_om_waterbalance_nrw', 'View to show non-revenue water values according IWA standards by period and DMA', 'role_om', 0, 'core') 
ON CONFLICT (id) DO NOTHING;

UPDATE config_report SET id = 102 WHERE alias  = 'Water consumption by period and dma';

DELETE FROM config_report WHERE id = 100;
INSERT INTO config_report(id, alias, query_text, vdefault, filterparam, sys_role)
VALUES (100, 'Pipe length by Exploitation and Catalog', 
'SELECT name as "Exploitation", arccat_id as "Arc Catalog", sum(gis_length) as "Length" FROM v_edit_arc JOIN exploitation USING (expl_id) GROUP BY arccat_id, name',
'{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL","isNullValue":"true"},
{"columnname":"Arc Catalog", "label":"Arc catalog:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select id as id, id as idval FROM cat_arc WHERE id IS NOT NULL ORDER BY id","isNullValue":"true"}]',
'role_basic');

DELETE FROM config_report WHERE id = 101;
INSERT INTO config_report(id, alias, query_text, vdefault, filterparam, sys_role)
VALUES (101, 'Connecs by Exploitation', 
'SELECT name as "Exploitation", connec_id, code, customer_code FROM v_edit_connec JOIN exploitation USING (expl_id) ',
'{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL","isNullValue":"true"}]',
'role_basic');

DELETE FROM config_report WHERE id = 102;
INSERT INTO config_report(id, alias, query_text, vdefault, filterparam, sys_role)
VALUES (102, 'Water consumption by expl,dma and period', 
'SELECT e.name as "Exploitation", p.code as "Period", dma.name as "Dma", round(SUM(sum)::numeric,2) as "Volume" FROM ext_rtc_hydrometer_x_data
JOIN  ext_cat_period p on p.id=cat_period_id JOIN  rtc_hydrometer_x_connec Using (hydrometer_id)
JOIN connec c using (connec_id) JOIN dma using(dma_id) JOIN exploitation e ON c.expl_id=e.expl_id GROUP BY p.code, dma.name, e.name',
'{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0","isNullValue":"true"},
{"columnname":"Period", "label":"Period:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select code as id, code as idval FROM ext_cat_period WHERE id IS NOT NULL","isNullValue":"true"},
{"columnname":"Dma", "label":"Dma:", "widgettype":"combo","datatype":"text","layoutorder":3,
"dvquerytext":"Select name as id, name as idval FROM dma WHERE dma_id != -1 and dma_id!=0","isNullValue":"true"}]',
'role_om');

DELETE FROM config_report WHERE id = 103;
INSERT INTO config_report(id, alias, query_text, vdefault, filterparam, sys_role)
VALUES (103, 'Water input by expl,dma and period', 
'SELECT expl as "Exploitation", code as "Period", dma as "Dma", (sum(flow_sign*value))::numeric(12,2) as "Volume"
FROM (SELECT node_id, exploitation, exploitation.name as expl, dma.name as dma , code , flow_sign, (CASE WHEN custom_value is null then value else custom_value end) as value 
FROM rtc_scada_x_data JOIN rtc_scada_x_dma USING (node_id) JOIN dma USING (dma_id) JOIN exploitation USING (expl_id) JOIN ext_cat_period p ON p.id = cat_period_id )a
group by expl, code, dma',
'{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0","isNullValue":"true"},
{"columnname":"Period", "label":"Period:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select code as id, code as idval FROM ext_cat_period WHERE id IS NOT NULL","isNullValue":"true"},
{"columnname":"Dma", "label":"Dma:", "widgettype":"combo","datatype":"text","layoutorder":3,
"dvquerytext":"Select name as id, name as idval FROM dma WHERE dma_id != -1 and dma_id!=0","isNullValue":"true"}]',
'role_om');


DELETE FROM config_report WHERE id = 104;
INSERT INTO config_report(id, alias, query_text, vdefault, filterparam, sys_role)
VALUES (104, 'NRW by expl,dma and period', 
'SELECT * FROM v_om_waterbalance_nrw',
'{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0","isNullValue":"true"},
{"columnname":"dma", "label":"Dma:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select name as id, name as idval FROM dma WHERE dma_id != -1 and dma_id!=0","isNullValue":"true"},
{"columnname":"period", "label":"Period:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select code as id, code as idval FROM ext_cat_period WHERE id IS NOT NULL","isNullValue":"true"}]',
'role_om');


DELETE FROM config_report WHERE id = 105;
INSERT INTO config_report(id, alias, query_text, vdefault, filterparam, sys_role)
VALUES (105, 'Losses by expl,dma and period', 
'SELECT * FROM v_om_waterbalance_loss',
'{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0","isNullValue":"true"},
{"columnname":"dma", "label":"Dma:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select name as id, name as idval FROM dma WHERE dma_id != -1 and dma_id!=0","isNullValue":"true"},
{"columnname":"period", "label":"Period:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select code as id, code as idval FROM ext_cat_period WHERE id IS NOT NULL","isNullValue":"true"}]',
'role_om');

DELETE FROM config_param_system where parameter  = 'utils_grafanalytics_vdefault';
INSERT INTO config_param_system VALUES('utils_grafanalytics_vdefault', '{"DMA":{"updateMapZone":2, "geomParamUpdate":30}, "SECTOR":{"updateMapZone":2, "geomParamUpdate":30}, 
"PRESSZONE":{"updateMapZone":2, "geomParamUpdate":30}, "MINSECTOR":{"updateMapZone":2, "geomParamUpdate":30}, "DQA":{"updateMapZone":2, "geomParamUpdate":30}}'::json, 
'Automatic values for geometry trigger mapzone algorithm');

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type)
VALUES (441, 'Water balance calculation','ws',null, 'core', false, 'Function process')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3142, 'gw_fct_waterbalance', 'ws', 'function', NULL, 'json', 'Function to calculate water balance according stardards of IWA.', 'role_master', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

DELETE FROM config_toolbox WHERE id=3142;
INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3142, 'Water balance by expl and period', '{"featureType":[]}', '[
{"widgetname":"executeGrafDma", "label":"Execute Graf for DMA:", "widgettype":"check","datatype":"boolean","tooltip":"If true, grafaanalytics mapzones will be triggered for DMA and expl selected" , "layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"period", "label":"Period:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT id, code as idval FROM ext_cat_period", "layoutname":"grl_option_parameters","layoutorder":3, "value":""}
]', NULL, true) 
ON CONFLICT (id) DO NOTHING;
