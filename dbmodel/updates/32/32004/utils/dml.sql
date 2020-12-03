/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO sys_fprocess_cat VALUES (40, 'Epa import rpt results', 'EPA', 'Epa import rpt results', 'utils');
INSERT INTO sys_fprocess_cat VALUES (41, 'Epa import inp files', 'EPA', 'Epa import inp files', 'utils');

UPDATE audit_cat_function SET return_type= NULL, context = '', isparametric=FALSE where function_name='gw_fct_plan_audit_check_data';
UPDATE audit_cat_function SET alias ='check data acording EPA rules', return_type = '[{"widgetname":"resultId", "label":"Result Id:","placeholder":"Write here the name (result_id) of the 1st temptative of EPA simulation. Data will be checked","widgettype":"text","datatype":"string","layout_name":"grl_option_parameters","layout_order":1,"value":""}]', 
descript = 'The function allows the possibility to find errors and data inconsistency before first exportation to EPA models. 
It checks on EPA feature tables hydraulic mandatory data to enable the simulation. 
It works not only with one layers but also with all layers need on the go2epa process.
When there is no EPA result_id into database you can create it for first time using this function.  You will delete it using EPA manager toolbar button' WHERE function_name='gw_fct_pg2epa_check_data';



