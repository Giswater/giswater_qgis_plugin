/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--04/05/2019
INSERT INTO sys_csv2pg_cat (id, name, name_i18n, csv_structure, sys_role, formname, functionname)
VALUES (13, 'Import arc visits', 'Import om visit for arc', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

INSERT INTO sys_csv2pg_cat (id, name, name_i18n, csv_structure, sys_role, formname, functionname)
VALUES (14, 'Import arc visits', 'Import om visit for arc', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

INSERT INTO sys_csv2pg_cat (id, name, name_i18n, csv_structure, sys_role, formname, functionname)
VALUES (15, 'Import connec visits', 'Import om visit for arc', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

INSERT INTO sys_csv2pg_cat (id, name, name_i18n, csv_structure, sys_role, formname, functionname)
VALUES (16, 'Import gully visits', 'Import om visit for arc', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

INSERT INTO sys_csv2pg_cat (id, name, name_i18n, csv_structure, sys_role, formname, functionname, isdeprecated) 
VALUES (17, 'Import pattern values from dma flowmeter', 'Import pattern values from dma flowmeter', 
'The csv template is defined on the same function. Open pgadmin to more details', 'role_epa', 'importcsv', 'gw_fct_utils_csv2pg_import_patterns',false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_csv2pg_cat (id, name, name_i18n, csv_structure, sys_role, formname, functionname) 
VALUES (18, 'Import om visit', 'Import om visit', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');



UPDATE sys_csv2pg_cat SET csv_structure=replace (csv_structure, '- Be careful, csv file needs a header line', '') WHERE id=1;
UPDATE sys_csv2pg_cat SET csv_structure=replace (csv_structure, '- Be careful, csv file needs a header line', '') WHERE id=3;
UPDATE sys_csv2pg_cat SET csv_structure=replace (csv_structure, '- Be careful, csv file needs a header line', '') WHERE id=4;

INSERT INTO audit_cat_error VALUES (1081,'There are not psectors defined on the project','Define at least one to start to work with', 2, TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_error VALUES (1083,'Please configure your own psector vdefault variable','To work with planified elements it is mandatory to have always defined the work psector using the psector vdefault variable', 2, TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_error VALUES (1097,'It is not allowed to insert/update one node with state(1) over another one with state (1) also. The node is:','Please ckeck it', 2, TRUE) ON CONFLICT (id) DO NOTHING;
UPDATE audit_cat_error SET error_message = 'There are one node with state (1) and one node with state (2) on the same position. It is not allowed to insert/update more nodes with state >(0) node on same position. The node is:' WHERE id=1096;
UPDATE audit_cat_error SET isdeprecated=TRUE WHERE id=1098;
UPDATE audit_cat_error SET error_message = 'It is not allowed to insert/update one node with state (2) over another one with state (2). The node is:' WHERE id=1100;


-- refactor config param system
UPDATE config_param_system SET value='FALSE' , label='Overwrite node1 & node2 topological values:' WHERE parameter='edit_enable_arc_nodes_update';
UPDATE config_param_system SET value='FALSE' WHERE parameter='nodeinsert_arcendpoint';
UPDATE config_param_system SET value='FALSE' WHERE parameter='orphannode_delete';

UPDATE config_param_system SET label='Node proximity:' WHERE parameter='node_proximity';
UPDATE config_param_system SET label='Connec proximity:' WHERE parameter='connec_proximity';
UPDATE config_param_system SET label='Gully proximity:' WHERE parameter='gully_proximity';
UPDATE config_param_system SET label='Node automatic doble geometry:' WHERE parameter='double_geometry_enabled';
UPDATE config_param_system SET isenabled=FALSE where parameter='node2arc';
UPDATE config_param_system SET isenabled=FALSE where parameter='nodetype_change_enabled';
UPDATE config_param_system SET isenabled=FALSE where parameter='edit_arc_divide_automatic_control';
UPDATE config_param_system SET isenabled=FALSE where parameter='audit_function_control';
UPDATE config_param_system SET layout_order=2 where parameter='state_topocontrol';
UPDATE config_param_system SET layout_order=8 where parameter='arc_searchnodes';
UPDATE config_param_system SET isenabled=FALSE where parameter='basic_search_hyd_hydro_layer_name';
UPDATE config_param_system SET isenabled=FALSE where parameter='basic_search_hyd_hydro_field_expl_name';
UPDATE config_param_system SET isenabled=FALSE where parameter='basic_search_hyd_hydro_field_cc';
UPDATE config_param_system SET isenabled=FALSE where parameter='basic_search_hyd_hydro_field_erhc';
UPDATE config_param_system SET isenabled=FALSE where parameter='basic_search_hyd_hydro_field_ccc';
UPDATE config_param_system SET isenabled=FALSE where parameter='basic_search_hyd_hydro_field_1';
UPDATE config_param_system SET isenabled=FALSE where parameter='basic_search_hyd_hydro_field_2';
UPDATE config_param_system SET isenabled=FALSE where parameter='basic_search_hyd_hydro_field_3';
UPDATE config_param_system SET isenabled=FALSE where parameter='inventory_update_date';
UPDATE config_param_system SET layout_id=17, layout_order=1 , label='Mincut use pgrouting' WHERE parameter='om_mincut_use_pgrouting';
UPDATE config_param_system SET isenabled=TRUE, datatype='boolean', widgettype='check', iseditable=true, label='Mincut use valveunaccess button to change valve status:', layout_id=17, layout_order=2 WHERE parameter='om_mincut_valvestat_using_valveunaccess';
UPDATE config_param_system SET isenabled=TRUE, datatype='text', widgettype='text', iseditable=true, label='System currency:', layout_id=17, layout_order=6 WHERE parameter='sys_currency';
UPDATE config_param_system SET isenabled=TRUE, datatype='boolean', widgettype='check', iseditable=true, label='Enable exploitation x user constrains:', layout_id=17, layout_order=3 WHERE parameter='sys_exploitation_x_user';
UPDATE config_param_system SET layout_order=7 WHERE parameter='scale_zoom';
UPDATE config_param_system SET isenabled=TRUE, datatype='boolean', widgettype='check', iseditable=true, label='Publish system value default:', layout_id=14, layout_order=1 WHERE parameter='edit_publish_sysvdefault';
UPDATE config_param_system SET isenabled=TRUE, datatype='boolean', widgettype='check', iseditable=true, label='Inventory system value default:', layout_id=14, layout_order=2 WHERE parameter='edit_inventory_sysvdefault';
UPDATE config_param_system SET isenabled=TRUE, datatype='boolean', widgettype='check', iseditable=true, label='Uncertain system value default:', layout_id=14, layout_order=3 WHERE parameter='edit_uncertain_sysvdefault';
UPDATE config_param_system SET layout_id=14, layout_order=4 WHERE parameter='edit_uncertain_sysvdefault';


UPDATE audit_cat_function SET isdeprecated=TRUE WHERE id=1334;
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE id=1234;


-- bug fix renaming layout_name to layoutname
UPDATE audit_cat_function SET return_type='[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layout_order":1,"value":""}]'
WHERE id=2436;

UPDATE audit_cat_function SET return_type='[{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layout_order":1,"value":0.01}]'
WHERE id=2108;

UPDATE audit_cat_function SET return_type='[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layout_order":1,"value":""}]'
WHERE id=2430;

UPDATE audit_cat_function SET return_type='[{"widgetname":"arcSearchNodes", "label":"Start/end points buffer","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":1, "value":"0.5"}]'
WHERE id=2102;

DELETE FROM audit_cat_function WHERE id=2106;
INSERT INTO audit_cat_function VALUES (2106, 'gw_fct_anl_connec_duplicated', 'utils', 'function', '{"featureType":"connec"}', '[{"widgetname":"connecTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layout_order":1,"value":0.01}]', NULL, 'Check topology assistant. To review how many connecs are duplicated', 'role_edit', false, true, 'Check connecs duplicated', true);

INSERT INTO audit_cat_function VALUES (2688, 'gw_trg_update_link_arc_id', 'utils', 'trigger function', NULL, NULL, NULL, 'Automatic update of parent arc for connec & gully when they are connected not directly to arc', 'role_edit', false, false, null, true);