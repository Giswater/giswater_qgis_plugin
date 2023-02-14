/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later versio
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_report set query_text = 'SELECT w.exploitation as "Exploitation", w.dma as "Dma", period as "Period", 
total_in::numeric(12,2) as "Total inlet",
total_out::numeric(12,2) as "Total outlet",
total::numeric(12,2) as "Total injected",
auth_bill as "Auth. Bill", auth_unbill as "Auth. Unbill", auth as "Authorized", 
loss_app as "Losses App", loss_real as "Losses Real",loss as "Losses", 
(case when total > 0 then (auth/total)::numeric(12,2) else 0 end) as "Losses Efficiency" ,
rw as "Revenue", nrw as "Non Revenue", 
(case when total > 0 then (rw/total)::numeric(12,2) else 0.00 end) as "Revenue Efficiency",
w.ili::numeric(12,2) as "ILI"
FROM v_om_waterbalance w' WHERE id=102;


UPDATE config_report set query_text = replace (query_text,'v_om_waterbalance_efficiency','v_om_waterbalance') WHERE id=103 or id=104;

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3196, 'gw_fct_getdmabalance', 'ws', 'function', 'Function that returns data related to water balance results for dma for further visualization', 'role_basic', 'core')
ON CONFLICT (id) DO NOTHING;



INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
            datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
 WITH
  t1 AS
(SELECT distinct child_layer, formtype, tabname, 'real_press_max' as columnname, 'lyt_data_2' as layoutname, max(layoutorder)+1 as layoutorder, 
            'numeric' as datatype, 'text' as widgettype, 'real_press_max' as label, 'real_press_max' as tooltip,  false as ismandatory, 
            false as isparent, true as iseditable, false as isautoupdate, true as hidden
FROM config_form_fields, cat_feature 
WHERE system_id='METER' group by child_layer,formtype, tabname),
  t2 AS
(SELECT distinct child_layer, formtype, tabname, 'real_press_min', 'lyt_data_2', max(layoutorder)+2, 
            'numeric', 'text', 'real_press_min', 'real_press_min',  false, false, true, false, true
FROM config_form_fields, cat_feature 
WHERE system_id='METER' group by child_layer,formtype, tabname),
t3 AS
(SELECT distinct child_layer, formtype, tabname, 'real_press_avg', 'lyt_data_2', max(layoutorder)+3, 
            'numeric', 'text', 'real_press_avg', 'real_press_avg',  false, false, true, false, true
FROM config_form_fields, cat_feature 
WHERE system_id='METER' group by child_layer,formtype, tabname)
select * from t1
  union select * from t2
  union select * from t3 
  order by child_layer, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active) VALUES(3198, 'Get address values from closest street number', '{"featureType":["node","connec"]}'::json, 
'[{"widgetname":"catFeature", "label":"Type:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["ALL NODES", "ALL CONNECS", "HYDRANT", "JUNCTION", "METER", "PUMP", "TANK", "VALVE", "WJOIN"], 
"comboNames":["ALL NODES", "ALL CONNECS", "HYDRANT", "JUNCTION", "METER", "PUMP", "TANK", "VALVE", "WJOIN"], "selectedId":"ALL NODES"},
{"widgetname":"fieldToUpdate", "label":"Field to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,
"comboIds":["postnumber", "postcomplement"], "comboNames":["POSTNUMBER", "POSTCOMPLEMENT"], "selectedId":"postnumber"},
{"widgetname":"searchBuffer", "label":"Search buffer (meters):","widgettype":"text","datatype":"float", "layoutname":"grl_option_parameters","layoutorder":3, "isMandatory":true, "value":"50"},
{"widgetname":"updateValues", "label":"Elements to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4,
"comboIds":["allValues", "nullStreet", "nullPostnumber", "nullPostcomplement"], "comboNames":["ALL ELEMENTS", "ELEMENTS WITH NULL STREETAXIS", "ELEMENTS WITH NULL POSTNUMBER", "ELEMENTS WITH NULL POSTCOMPLEMENT"], "selectedId":"nullStreet"}]'::json, NULL, true);
