/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_function SET isdeprecated=TRUE where function_name='gw_fct_utils_csv2pg';


UPDATE sys_csv2pg_cat SET formname='importcsv', functionname='gw_fct_utils_csv2pg_import_dbprices' WHERE id=1;

-- csv2pg visit functions
INSERT INTO sys_csv2pg_cat VALUES (9, 'Import om visit', 'Import om visit', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

UPDATE sys_csv2pg_cat SET isdeprecated=true WHERE id=2;
UPDATE sys_csv2pg_cat SET isdeprecated=true WHERE id=5;
UPDATE sys_csv2pg_cat SET isdeprecated=true WHERE id=6;
UPDATE sys_csv2pg_cat SET isdeprecated=true WHERE id=7;

UPDATE sys_csv2pg_cat SET formname='importcsv', functionname='gw_fct_utils_csv2pg_import_elements' WHERE id=3;
UPDATE sys_csv2pg_cat SET formname='importcsv', functionname='gw_fct_utils_csv2pg_import_addfields' WHERE id=4;
UPDATE sys_csv2pg_cat SET formname='importcsv', functionname='gw_fct_utils_csv2pg_import_dxfblock' WHERE id=8;
UPDATE sys_csv2pg_cat SET formname='go2epa', functionname='gw_fct_utils_csv2pg_export_epa_inp' WHERE id=10;
UPDATE sys_csv2pg_cat SET formname='go2epa', functionname='gw_fct_utils_csv2pg_import_epa_rpt' WHERE id=11;
UPDATE sys_csv2pg_cat SET formname='giswater', functionname='gw_fct_utils_csv2pg_import_epa_inp' WHERE id=12;

UPDATE config_param_system SET value='{"isVisitExists":true, "parameters": ["p1", "p2", "p3", "p4", "p5", "p6", "p7"]}' WHERE parameter='utils_csv2pg_om_visit_parameters';

INSERT INTO sys_fprocess_cat VALUES (42, 'import generic csv file', 'Utils','import generic csv file', 'utils');

UPDATE audit_cat_function SET isdeprecated=true where function_name = 'gw_fct_utils_csv2pg_import_epa_inp';
UPDATE audit_cat_function SET isdeprecated=true where function_name = 'gw_fct_utils_csv2pg_import_epa_rpt';
UPDATE audit_cat_function SET isdeprecated=true where function_name = 'gw_fct_utils_csv2pg_export_epa_inp';


UPDATE audit_cat_function SET   
input_params = '{"featureType":""}',
return_type='[{"widgetname":"useNode2arc", "label":"Create node2arc:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":1,"value":"false"}]',
alias='Import inp epanet file'
WHERE function_name='gw_fct_utils_csv2pg_import_epanet_inp';


UPDATE audit_cat_function SET   
input_params = '{"featureType":""}',
return_type='[{"widgetname":"createSubcGeom", "label":"Create subcatchments geometry:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":1,"value":"true"}]',
alias='Import inp swmm file'
WHERE function_name='gw_fct_utils_csv2pg_import_swmm_inp';

-- reparir table
UPDATE audit_cat_function SET function_type='function', input_params='{"featureType":"connec"}'  WHERE function_name='gw_fct_repair_link';

-- TO DO: 
		-- audit_cat_function : insert gw_trg_vi
		-- audit_cat_table: all tables form 3.2.0000

--2019/04/23
UPDATE config_param_system SET value=
(SELECT row_to_json(a) FROM (SELECT node_proximity_control as activated, node_proximity as value FROM config) a),
descript='Enable/disable control of inserting duplicated nodes.Minimum accepted distance between two nodes', data_type='json' 
WHERE parameter='node_proximity';
DELETE FROM config_param_system WHERE parameter='node_proximity_control';

UPDATE config_param_system SET value=
(SELECT row_to_json(a) FROM (SELECT connec_proximity_control as activated, connec_proximity as value FROM config) a),
descript='Enable/disable control of inserting duplicated connec.Minimum accepted distance between two connecs' , data_type='json'
WHERE parameter='connec_proximity';
DELETE FROM config_param_system WHERE parameter='connec_proximity_control';

UPDATE config_param_system SET value=
(SELECT row_to_json(a) FROM (SELECT insert_double_geometry as activated, buffer_value as value FROM config) a),
descript='Enable/disable inserting double geometry features (point & polygon). Set the tadius value of a circle on which a square polygon is built', 
data_type='json'
WHERE parameter='insert_double_geometry';
DELETE FROM config_param_system WHERE parameter='buffer_value';

UPDATE config_param_system SET parameter='gully_proximity', value=
(SELECT row_to_json(a) FROM (SELECT connec_proximity_control as activated, connec_proximity as value FROM config) a),
descript='Enable/disable control of inserting duplicated gullies.Minimum accepted distance between two gullies', data_type='json'
WHERE parameter='gully_proximity_control';


UPDATE config_param_system SET parameter='arc_searchnodes', value=(
SELECT row_to_json(a) FROM (SELECT arc_searchnodes_control as activated, arc_searchnodes as value FROM config) a),
descript='Enable/disable and set the buffer of the ability to look for arcs final nodes', data_type='json' 
WHERE parameter='arc_searchnodes_control';
