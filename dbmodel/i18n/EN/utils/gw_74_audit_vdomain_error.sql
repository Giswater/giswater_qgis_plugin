/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- 
-- Message errors already translated (i18n)
--


-- Uncatched errors (audit_cat_error.id = -1)

INSERT INTO audit_cat_error VALUES (-1, 'Uncatched error', 'Open PotgreSQL log file to get more details', 2, true, 'generic');
INSERT INTO audit_cat_error VALUES (0, 'OK', NULL, 3, false, 'generic');
INSERT INTO audit_cat_error VALUES (1, 'Trigger INSERT', 'Inserted', 3, false, NULL);
INSERT INTO audit_cat_error VALUES (2, 'Trigger UPDATE', 'Updated', 3, false, NULL);
INSERT INTO audit_cat_error VALUES (3, 'Trigger DELETE', 'Deleted', 3, false, NULL);
INSERT INTO audit_cat_error VALUES (999, 'Undefined error', 'Undefined', 1, true, 'generic');
INSERT INTO audit_cat_error VALUES (1002, 'Test trigger', 'Trigger test', 0, true, 'ws_trg');
INSERT INTO audit_cat_error VALUES (1004, 'There are no nodes types defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1006, 'There are no nodes catalog defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1008, 'There are no sectors defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1010, 'Feature is out of sector', 'Please take a look on your map and use the approach of the sectors!', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1012, 'There are no dma defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1014, 'Feature is out of dma', 'Please take a look on your map and use the approach of the dma', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1016, 'Change node catalog is forbidden', 'The new node catalog is not included on the same type (node_type.type) of the old node catalog', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1018, 'There are no arc types defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1020, 'There are no arc catalog defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1022, 'There are no connec catalog defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1024, 'There are no grate catalog defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1026, 'Insert a new arc in this table is not allowed', 'To insert new arc, please use the GIS FEATURES layer arc', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1028, 'Delete arcs from this table is not allowed', 'To delete arcs, please use the GIS FEATURES layer arc', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1030, 'Insert a new node in this table is not allowed', 'To insert new node, please use the GIS FEATURES layer node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1032, 'Delete nodes from this table is not allowed', 'To delete nodes, please use the GIS FEATURES layer node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1034, 'Insert a new valve in this table is not allowed', 'To insert new valve, please use the GIS FEATURES layer node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1036, 'There are columns in this table not allowed to edit', 'Try to update open, accesibility, broken, mincut_anl or hydraulic_anl', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1038, 'Delete valves from this table is not allowed', 'To delete valves, please use the GIS FEATURES layer node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1040, 'One or more arcs has the same Node as Node1 and Node2. Node_id =', 'Please, check your project or modify the configuration propierties', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1042, 'One or more arcs was not inserted because it has not start/end node', 'Please, check your project or modify the configuration propierties', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1044, 'Exists one o more connecs closer than minimum configured,', 'Please, check your project or modify the configuration propierties', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1046, 'Exists one o more nodes closer than minimum configured,', 'Please, check your project or modify the configuration propierties', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1048, 'Elev is not an updatable column', 'Please use top_elev or ymax to modify this value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2002, 'Node not found', 'Please check table node', 1, true, 'ws');
INSERT INTO audit_cat_error VALUES (2004, 'Pipes has different types', 'It is no possible to delete node', 1, true, 'ws');
INSERT INTO audit_cat_error VALUES (2006, 'Node has not 2 arcs', 'It is no possible to delete node', 1, true, 'ws');
INSERT INTO audit_cat_error VALUES (2008, 'Arc not found', 'Please check table arc', 1, true, 'ws_fct');
INSERT INTO audit_cat_error VALUES (1058, 'There are at least one or more element(%) atached to deleted feature (%). Please review it before delete', 'To delete a feature, it coudn''t have been attached to other elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1060, 'There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', 'To delete a feature, it coudn''t have been attached to other elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1064, 'There are at least one or more link (%) atached to deleted feature (%). Please review it before delete', 'To delete a feature, it coudn''t have been attached to other elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1066, 'There are at least one or more conec (%) atached to deleted feature (%). Please review it before delete', 'To delete a feature, it coudn''t have been attached to other elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1070, 'The feature not have state(1) value to be replaced, state = %', 'To replace a feature, it must have state = 1', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1080, 'You are not allowed to manage with state=2 values. Please review your profile parameters', 'Only users with masterplan or admin role can manage planified state', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1088, 'Your catalog is different than connec type', 'You must use a connec type defined in connec catalogues', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1090, 'Please, fill the node catalog value or configure it with the value default parameter', 'Nodecat_id is required. Fill the table cat_connec or use a default value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1072, 'Before downgrade the node to state 0, please disconnect the associated arcs, node_id= %', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1074, 'Before downgrade the arc to state 0, please disconnect the associated connecs, arc_id= %', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1076, 'Before downgrade the node to state 0, please disconnect the associated link, connec_id= %', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1078, 'Before downgrade the node to state 0, please disconnect the associated links, gully_id= %', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1094, 'Your catalog is different than node type', 'You must use a node type defined in node catalogues', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1082, 'Nonexistent Arc ID --> %', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1084, 'Nonexistent Node ID --> %', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1098, 'Node with state(1) or(2) over one existing node with state(1) please use the button replace node!', 'It''s not possible to have more than one nodes with the same state at the same position', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1100, 'Node with state(2) over node with state(2) is not allowed. Please, review your project data!', 'It''s not possible to have more than one nodes with the same state at the same position', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2014, 'You need to connec the link to one connec/gully', 'Links must be connected to ohter elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2018, 'At least one of the extremal nodes of the arc is not present on the alternative updated. The planified network has losed the topology', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2020, 'One or more vnode(s) are closer than minimum distance configured (config.node_proximity)', 'Please review your project', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1102, 'Insert is not allowed. There is not hydrometer_id on ...', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1104, 'Update is not allowed ...', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1106, 'Delete is not allowed. There is hydrometer_id on ...', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1108, 'Delete is not allowed. There is hydrometer_id on ...', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1052, 'It is not possible to divide the arc because the used node has state=(0)', 'To divide an arc, the state of the used node has to be 1', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2022, 'arc_id= %, Geom type= %', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2024, 'You are trying to insert a new element out of any municipality.', 'Please review your data', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2026, 'There are conflicts againts another planified mincut.', 'Please review your data', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1050, 'It is not possible to divide the arc because it has state=(0)', 'To divide an arc, the state of the arc has to be 1', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1054, 'It is not possible to divide the arc because the arc has state=(1) and the node has state=(2)', 'To divide an arc, the state of the used node has to be 1', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1056, 'There are at least one or more arcs (%) atached to deleted feature (%). Please review it before delete', 'To delete a feature, it coudn''t have been attached to other elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1062, 'There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', 'To delete a feature, it coudn''t have been attached to other elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1068, 'There are at least one or more gully (%) atached to deleted feature (%). Please review it before delete', 'To delete a feature, it coudn''t have been attached to other elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1086, 'Please, fill the connec catalog value or configure it with the value default parameter', 'Connecat_id is required. Fill the table cat_connec or use a default value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1092, 'Your default value catalog is not enabled using the node type choosed', 'You must use a node type defined in node catalogues', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1096, 'There are more than one nodes on the same position. Please, review your project data!', 'It''s not possible to have more than one nodes with the same state at the same position', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2010, 'There are not values on the cat_element table. Before continue inserting one element please fill it', 'Elementcat_id is required. Fill the table cat_element or use a default value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2012, 'You are trying to insert a new element out of any exploitation, please review your data!', 'Every feature must be inside an exploitation', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2016, 'Is not enabled to modify the start/end point of link', 'If you are looking to reconnect the features, please delete this link and draw a new one', 2, true, NULL);