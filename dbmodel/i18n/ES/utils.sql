/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of value_state
-- ----------------------------
INSERT INTO "value_state" VALUES (0,'OBSOLETO');
INSERT INTO "value_state" VALUES (1,'EN_SERVICIO');
INSERT INTO "value_state" VALUES (2,'PLANIFICADO');

-- Records of value_state_type
-- ----------------------------
INSERT INTO value_state_type VALUES (1, 0, 'OBSOLETO', false, false);
INSERT INTO value_state_type VALUES (2, 1, 'EN_SERVICIO', true, true);
INSERT INTO value_state_type VALUES (3, 2, 'PLANIFICADO', true, true);
INSERT INTO value_state_type VALUES (4, 2, 'RECONSTRUIDO', true, false);
INSERT INTO value_state_type VALUES (5, 1, 'PROVISIONAL', false, true);

-- Records of value_verified
-- ----------------------------
INSERT INTO "value_verified" VALUES ('PARA REVISAR');
INSERT INTO "value_verified" VALUES ('VERIFICADO');

-- Records of value_yesno
-- ----------------------------
INSERT INTO "value_yesno" VALUES ('NO');
INSERT INTO "value_yesno" VALUES ('SI');

-- Records of event om_visit_parameter_type table
-- ----------------------------
INSERT INTO om_visit_parameter_type VALUES ('INSPECCION');
INSERT INTO om_visit_parameter_type VALUES ('REHABILITACION');
INSERT INTO om_visit_parameter_type VALUES ('RECONSTRUCCION');
INSERT INTO om_visit_parameter_type VALUES ('OTROS');

-- Records of event om_visit_parameter table
-- ----------------------------
INSERT INTO om_visit_parameter VALUES ('RAT1', NULL, 'REHABILITACION', 'ARC', 'TEXT', NULL, 'Reparación del arc parametro 1', 'event_ud_arc_rehabit', 'a');
INSERT INTO om_visit_parameter VALUES ('RAT2', NULL, 'REHABILITACION', 'ARC', 'TEXT', NULL, 'Reparación del arc parametro 2', 'event_ud_arc_rehabit', 'b');
INSERT INTO om_visit_parameter VALUES ('IAT1', NULL, 'INSPECCION', 'ARC', 'TEXT', NULL, 'Inspección del arc parametro 1', 'event_ud_arc_standard', 'c');
INSERT INTO om_visit_parameter VALUES ('IAT2', NULL, 'INSPECCION', 'ARC', 'TEXT', NULL, 'Inspección del arc parametro 2', 'event_ud_arc_standard', 'f');
INSERT INTO om_visit_parameter VALUES ('ICT1', NULL, 'INSPECCION', 'CONNEC', 'TEXT', NULL, 'Inspección del connec parametro 1', 'event_standard', 'd');
INSERT INTO om_visit_parameter VALUES ('ICT2', NULL, 'INSPECCION', 'CONNEC', 'TEXT', NULL, 'Inspección del connec parametro 2', 'event_standard', 'e');
INSERT INTO om_visit_parameter VALUES ('INT1', NULL, 'INSPECCION', 'NODE', 'TEXT', NULL, 'Inspección del node parametro 1', 'event_standard', 'f');
INSERT INTO om_visit_parameter VALUES ('INT2', NULL, 'INSPECCION', 'NODE', 'TEXT', NULL, 'Inspección del node parametro 2', 'event_standard', 'g');
INSERT INTO om_visit_parameter VALUES ('INT3', NULL, 'INSPECCION', 'NODE', 'TEXT', NULL, 'Inspección del node parametro 3', 'event_standard', 'i');

-- Records of doc type table
-- ----------------------------
INSERT INTO doc_type VALUES ('AS_BUILT');
INSERT INTO doc_type VALUES ('INCIDENTE');
INSERT INTO doc_type VALUES ('RELACION DE TRABAJO');
INSERT INTO doc_type VALUES ('OTROS');
INSERT INTO doc_type VALUES ('FOTO');

-- Records of price_value_unit
-- ----------------------------
INSERT INTO price_value_unit VALUES ('m3');
INSERT INTO price_value_unit VALUES ('m2');
INSERT INTO price_value_unit VALUES ('m');
INSERT INTO price_value_unit VALUES ('pa');
INSERT INTO price_value_unit VALUES ('u');
INSERT INTO price_value_unit VALUES ('kg');
INSERT INTO price_value_unit VALUES ('t');

-- Records of value_priority
-- ----------------------------
INSERT INTO value_priority VALUES ('PRIORIDAD ALTA');
INSERT INTO value_priority VALUES ('PRIORIDAD MEDIA');
INSERT INTO value_priority VALUES ('PRIORIDAD BAJA');

-- Records of plan_result_type
-- ----------------------------
INSERT INTO plan_result_type VALUES (1,'Reconstrucción');
INSERT INTO plan_result_type VALUES (2,'Rehabilitación');

-- Records of plan_psector_cat_type
-- ----------------------------
INSERT INTO plan_psector_cat_type VALUES (1,'Planificado');

-- Records of om_psector_cat_type
-- ----------------------------
INSERT INTO om_psector_cat_type VALUES (1,'Reconstrucción');
INSERT INTO om_psector_cat_type VALUES (2,'Rehabilitación');

-- Records of value_review_validation table
-- ----------------------------
INSERT INTO value_review_validation VALUES (0, 'Rechazado');
INSERT INTO value_review_validation VALUES (1, 'Aceptado');
INSERT INTO value_review_validation VALUES (2, 'A revisar');

-- Records of value_review_status table
-- ----------------------------
INSERT INTO value_review_status VALUES (0, 'No hay cambios por encima o debajo de los valores de tolerancia', 'Sin cambios');
INSERT INTO value_review_status VALUES (1, 'Nuevo elemento introducido para revisar', 'Nuevo elemento');
INSERT INTO value_review_status VALUES (2, 'Geometría modificada en la revisión. Otros datos pueden ser modificados', 'Geometría modificada');
INSERT INTO value_review_status VALUES (3, 'Cambios en los datos, no en la geometría', 'Datos modificados');

-- Records of event sys_csv2pg_cat table
-- ----------------------------
INSERT INTO sys_csv2pg_cat VALUES (1, 'Importar precios a la base de datos', 'Importar precios a la base de datos', 
'El fichero csv debe tener estas columnas por orden: id, unit, descript, text, price.
- La columna price deber ser tipo numerico con dos decimales.
- Puedes escoger un catalogo para los precios importados asignandolo a Import label.
- Atencion: el fichero csv debe tener una fila de encabezado', 'role_master');
INSERT INTO sys_csv2pg_cat VALUES (2, 'Importar tabla de visitas a nodos', 'Importar tabla de visitas a nodos', 'El fichero csv debe tener estas columnas por orden: node_id, unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (3, 'Importar elementos', 'Importar elementos', 
'El fichero csv debe tener estas columnas por orden: feature_id, elementcat_id, observ, comment, num_elements. 
- A Import label se debe establecer el tipo de elemento que quieres importar (node, arc, connec, gully).
- Los campos Observ y Comment son opcionales.
- Atencion: el fichero csv debe tener una fila de encabezado', 'role_admin');
INSERT INTO sys_csv2pg_cat VALUES (4, 'Importar campos adicionales', 'Importar campos adicionales', 'El fichero csv debe tener estas columnas por orden: 
feature_id (puede ser arc, node o connec), parameter_id (a escoger de la tabla man_addfields_parameter), value_param. 
- Atencion: el fichero csv debe tener una fila de encabezado', 'role_admin');
INSERT INTO sys_csv2pg_cat VALUES (5, 'Importar tabla de visitas a arco', 'Importar tabla de visitas a arco', 'El fichero csv debe tener estas columnas por orden: arc_id, unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (6, 'Importar tabla de visitas a connec', 'Importar tabla de visitas a connec', 'El fichero csv debe tener estas columnas por orden: connec_id, unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (7, 'Importar tabla de visitas a gully', 'Importar tabla de visitas a gully', 'El fichero csv debe tener estas columnas por orden: gully_id, unit', 'role_om');

-- Error message
-- ----------------------------
INSERT INTO audit_cat_error VALUES (-1, 'Uncatched error', 'Open PotgreSQL log file to get more details', 2, true, 'generic');
INSERT INTO audit_cat_error VALUES (0, 'OK', NULL, 3, false, 'generic');
INSERT INTO audit_cat_error VALUES (1, 'Trigger INSERT', 'Inserted', 3, false, NULL);
INSERT INTO audit_cat_error VALUES (2, 'Trigger UPDATE', 'Updated', 3, false, NULL);
INSERT INTO audit_cat_error VALUES (3, 'Trigger DELETE', 'Deleted', 3, false, NULL);
INSERT INTO audit_cat_error VALUES (999, 'Undefined error', 'Undefined', 1, true, 'generic');
INSERT INTO audit_cat_error VALUES (1002, 'Test trigger', 'Trigger test', 0, true, 'ws_trg');
INSERT INTO audit_cat_error VALUES (1004, 'There are no node types defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1006, 'There are no node catalog values defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1008, 'There are no sectors defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1010, 'Feature is out of sector, feature_id:', 'Take a look on your map and use the approach of the sectors!', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1012, 'There is no dma defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1014, 'Feature is out of dma, feature_id:', 'Take a look on your map and use the approach of the dma', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1016, 'It''s impossible to change node catalog', 'The new node catalog doesn''t belong to the same type as the old node catalog (node_type.type) ', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1018, 'There are no arc types defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1020, 'There are no arc catalog values defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1022, 'There are no connec catalog values defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1024, 'There are no grate catalog values defined in the model', 'Define at least one', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1026, 'Insert new arc in this table is not allowed', 'To insert new arc, use layer arc in INVENTORY', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1028, 'Delete arcs from this table is not allowed', 'To delete arcs, use layer arc in INVENTORY', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1030, 'Insert a new node in this table is not allowed', 'To insert new node, use layer node INVENTORY', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1032, 'Delete nodes from this table is not allowed', 'To delete nodes, use layer node in INVENTORY', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1034, 'Insert a new valve in this table is not allowed', 'To insert a new valve, use layer ndoe in INVENTORY', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1036, 'There are columns in this table not allowed to edit', 'Try to update open, accesibility, broken, mincut_anl or hydraulic_anl', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1038, 'Delete valves from this table is not allowed', 'To delete valves, use layer node in INVENTORY', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1040, 'One or more arcs has the same node as Node1 and Node2. Node_id:', 'Check your project or modify the configuration properties', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1042, 'One or more arcs was not inserted/updated because it has not start/end node. Arc_id:', 'Check your project or modify the configuration properties.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1044, 'Exists one o more connecs closer than configured minimum distance, connec_id:', 'Check your project or modify the configuration properties (config.connec_proximity).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1046, 'Exists one o more nodes closer than configured minimum distance, node_id: ', 'Check your project or modify the configuration properties (config.node_proximity).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1048, 'Elev is not an updatable column', 'Please use top_elev or ymax to modify this value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2002, 'Node not found', 'Please check table node', 2, true, 'ws');
INSERT INTO audit_cat_error VALUES (2004, 'It is impossible to delete the node','Pipes have different types', 2, true, 'ws');
INSERT INTO audit_cat_error VALUES (2006, 'It is impossible to delete the node', 'Node doesn''t have 2 arcs', 2, true, 'ws');
INSERT INTO audit_cat_error VALUES (2008, 'Arc not found', 'Please check table arc', 2, true, 'ws_fct');
INSERT INTO audit_cat_error VALUES (1080, 'You are not allowed to manage the features with state=2. Review your profile parameters', 'Only users with masterplan or admin role can manage planified state', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1088, 'Connec catalog is different than connec type', 'Use a connec type defined in connec catalogs', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1090, 'You must choose a node catalog value for this feature', 'Nodecat_id is required. Fill the table cat_node or use a default value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1094, 'Your catalog is different than node type', 'You must use a node type defined in node catalogs', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2014, 'You need to connec the link to one connec/gully', 'Links must be connected to ohter elements', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2018, 'At least one of the extremal nodes of the arc is not present on the alternative updated. The planified network has losed the topology', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2020, 'One or more vnodes are closer than configured minimum distance', 'Check your project or modify the configuration properties (config.node_proximity).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1102, 'Insert is not allowed. There is no hydrometer_id on ...', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1104, 'Update is not allowed ...', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1106, 'Delete is not allowed. There is hydrometer_id on ...', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1108, 'Delete is not allowed. There is hydrometer_id on ...', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1052, 'It''s impossible to divide an arc using node that has state=(0)', 'To divide an arc, the state of the node has to be 1', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2024, 'Feature is out of any municipality,feature_id:', 'Please review your data', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2026, 'There are conflicts againts another planified mincut.', 'Please review your data', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1050, 'It''s impossible to divide an arc with state=(0)', 'To divide an arc, the state has to be 1', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1084, 'Nonexistent node_id:', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1082, 'Nonexistent arc_id:', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1076, 'Before downgrading the connec to state 0, disconnect the associated features, connec_id: ', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1074, 'Before downgrading the arc to state 0, disconnect the associated features, arc_id: ', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1072, 'Before downgrading the node to state 0, disconnect the associated features, node_id: ', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1078, 'Before downgrading the gully to state 0, disconnect the associated features, gully_id: ', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1070, 'The feature can''t be replaced, because it''s state is different than 1. State = ', 'To replace a feature, it must have state = 1', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1098, 'It''s not allowe to have node with state(1) or(2) over one existing node with state(1).', 'Use the button replace node. It''s not possible to have more than one nodes with the same state at the same position', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1054, 'It''is impossible to divide an arc with state=(1) using a node with state=(2)', 'To divide an arc, the state of the used node has to be 1', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1086, 'You must choose a connec catalog value for this feature', 'Connecat_id is required. Fill the table cat_connec or use a default value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1092, 'Your default value catalog is not enabled using the node type choosed', 'You must use a node type defined in node catalogs', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2010, 'There are no values on the cat_element table.', 'Elementcat_id is required. Insert values into cat_element table or use a default value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2012, 'Feature is out of exploitation, feature_id:', 'Take a look on your map and use the approach of the exploitations!', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2016, 'It''s not enabled to modify the start/end point of link', 'If you want to reconnect the features, delete this link and draw a new one', 2, true, NULL);	
INSERT INTO audit_cat_error VALUES (2028, 'The feature does not have state(1) value to be replaced, state = ', 'The feature must have state 1 to be replaced', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2032, 'Please, fill the node catalog value or configure it with the value default parameter', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2034, 'Your catalog is different than node type', 'Your data must be in the node catalog too', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2066, 'The provided node_id don''t exists as a ''CHAMBER'' (system type)', 'Please look for another node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2030, 'The feature not have state(2) value to be replaced, state = ', 'The feature must have state 2 to be replaced', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2068, 'The provided node_id don''t exists as a ''WWTP'' (system type)', 'Please look for another node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2042, 'Dma is not into the defined exploitation. Please review your data', 'The element must be inside the dma which is related to the defined exploitation', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2044, 'Presszone is not into the defined exploitation. Please review your data', 'The element must be inside the press zone which is related to the defined exploitation', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2046, 'State type is not a value of the defined state. Please review your data', 'State type must be related to states', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2048, 'Polygon not related with any gully', 'Insert gully_id in order to assign the polygon geometry to the feature', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2052, 'Polygon not related with any node', 'Insert node_id in order to assign the polygon geometry to the feature', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2070, 'You need to set a value of to_arc column before continue', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2072, 'You need to set to_arc/node_id values with topologic coherency', 'Node_id must be the node_1 of the exit arc feature', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2074, 'You must define the length of the flow regulator', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2076, 'Flow length is longer than length of exit arc feature', 'Please review your project', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2040, 'Reduced geometry is not a Linestring, (arc_id,geom type)=', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2036, 'It is impossible to validate the arc without assigning value of arccat_id, arc_id:', 'Please assign an arccat_id value', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2078, 'Query text =', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2090, 'There are null [descript] values on the imported csv', 'Please complete it before to continue', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2080, 'The x value is too large. The total length of the line is ', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2060, 'It is not possible to relate this geometry to any node.', 'The node must be type ''WWTP'' (system type).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2058, 'It is not possible to relate this geometry to any node.', 'The node must be type ''CHAMBER'' (system type).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2056, 'It is not possible to relate this geometry to any node.', 'The node must be type ''STORAGE'' (system type).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2054, 'It is not possible to relate this geometry to any node.', 'The node must be type ''NETGULLY'' (system type).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2050, 'The provided gully_id doesn''t exist.', 'Look for another gully_id', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2062, 'The provided node_id doesn''t exist as a ''NETGULLY'' (system type)', 'Look for another node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2064, 'The provided node_id doesn''t exist as a ''STORAGE'' (system type)', 'Look for another node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2082, 'The extension does not exists. Extension =', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2084, 'The module does not exists. Module =', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2086, 'There are null values on the [id] column of csv. Check it', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2106, 'The provided node_id doesn''t exist as a ''TANK'' (system type)', 'Look for another node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2088, 'There are [units] values nulls or not defined on price_value_unit table  =', 'Please fill it before to continue', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2092, 'There are null values on the [price] column of csv', 'Please check it before continue', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2094, 'Please, assign one connec to relate this polygon geometry', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2102, 'It is not possible to relate this geometry to any node.', 'The node must be type ''TANK'' (system type).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2096, 'It is not possible to relate this geometry to any connec.', 'The connec must be type ''FOUNTAIN'' (system type).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2100, 'It is not possible to relate this geometry to any node.', 'The node must be type ''REGISTER'' (system type).', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2098, 'The provided connec_id doesn''t exist as a ''FOUNTAIN'' (system type)', 'Look for another connec', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2104, 'The provided node_id doesn''t exist as a ''REGISTER'' (system type)', 'Look for another node', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2038, 'The exit arc must be reversed. Arc =', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2022, '(arc_id, geom type) =', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1096, 'There are more than one nodes on the same position.', 'Review your project data.It''s not possible to have more than one nodes with the same state at the same position.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1100, 'It''s not allowed to put a node with state(2) over a node with state(2).', 'Review your data. It''s not possible to have more than one node with the same state at the same position.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1056, 'There is at least one arc attached to the deleted feature. (num. arc,feature_id) =', 'Review your data. The deleted feature can''t have any arcs attached.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1058, 'There is at least one element attached to the deleted feature. (num. element,feature_id) =', 'Review your data. The deleted feature can''t have any elements attached.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1060, 'There is at least one document attached to the deleted feature. (num. document,feature_id) =', 'Review your data. The deleted feature can''t have any documents attached.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1062, 'There is at least one visit attached to the deleted feature. (num. visit,feature_id) =', 'Review your data. The deleted feature can''t have any visits attached.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1064, 'There is at least one link attached to the deleted feature. (num. link,feature_id) =', 'Review your data. The deleted feature can''t have any links attached.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1066, 'There is at least one connec attached to the deleted feature. (num. connec,feature_id) =', 'Review your data. The deleted feature can''t have any connecs attached.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1068, 'There is at least one gully attached to the deleted feature. (num. gully,feature_id)=', 'Review your data. The deleted feature can''t have any gullies attached.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2108, 'There is at least one node attached to the deleted feature. (num. node,feature_id)=', 'Review your data. The deleted feature can''t have any nodes attached.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2110, 'Define at least one value of state_type with state=0', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2120, 'There is an inconsistency between node and arc state', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (2122, 'Arc not found on insertion process', NULL, 2, true, NULL);
INSERT INTO audit_cat_error VALUES (1110, 'There are no exploitations defined in the model', 'Define at least one', 2, true, NULL);