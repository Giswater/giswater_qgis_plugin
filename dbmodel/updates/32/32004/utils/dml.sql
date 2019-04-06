/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO sys_fprocess_cat VALUES (40, 'Epa import rpt results', 'EPA', 'Epa import rpt results', 'utils');
INSERT INTO sys_fprocess_cat VALUES (41, 'Epa import inp files', 'EPA', 'Epa import inp files', 'utils');

UPDATE audit_cat_function SET return_type= NULL, context = '', isparametric=FALSE where function_name='gw_fct_plan_audit_check_data';
UPDATE audit_cat_function SET alias ='check data acording EPA rules', return_type = '[{"widgetname":"resultId", "label":"Result Id:","ismandatory":"false","widgettype":"text","datatype":"string","layout_name":"grl_option_parameters","layout_order":1,"value":""}]'';


