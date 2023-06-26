/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE ext_rtc_hydrometer_state SET is_operative=TRUE;


UPDATE config_form_list set query_text = replace(query_text, 'v_ui_hydroval_x_connec', 'v_ui_hydroval') where listname = 'tbl_hydrometer_value';

UPDATE config_form_fields
	SET dv_querytext_filterc=NULL
	WHERE formtype='form_feature' AND columnname='cat_period_id' AND tabname='tab_hydrometer_val';
UPDATE config_form_fields
	SET dv_querytext_filterc='WHERE feature_id '
	WHERE formtype='form_feature' AND columnname='hydrometer_customer_code' AND tabname='tab_hydrometer_val';

UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters": {"field_id": "feature_id"}}'::json
	WHERE formtype='form_feature' AND columnname IN ('cat_period_id', 'hydrometer_customer_code') AND tabname='tab_hydrometer_val';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters": {"columnfind": "hydrometer_customer_code", "field_id": "feature_id"}}'::json
	WHERE formtype='form_feature' AND columnname='hydrometer_id' AND tabname='tab_hydrometer';
	

insert into sys_param_user (id,formname, descript, sys_role, idval, label, isenabled, layoutorder, project_type, "datatype", 
widgettype, ismandatory , layoutname,iseditable, placeholder, source)
select 'inp_report_nodes_2', formname, descript, sys_role, idval, label, isenabled, layoutorder+1, project_type, "datatype", 
widgettype, ismandatory , layoutname, iseditable, placeholder, source from sys_param_user spu where id = 'inp_report_nodes'

update sys_param_user set label = concat(label,'I-(max.40):') where id = 'inp_report_nodes';
update sys_param_user set label = concat(label,'II-(max.40):') where id = 'inp_report_nodes_2';

update sys_param_user set layoutorder = 10 where id = 'inp_report_links';

