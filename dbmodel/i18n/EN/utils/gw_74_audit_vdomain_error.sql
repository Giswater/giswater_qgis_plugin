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
INSERT INTO audit_cat_error VALUES ('-1', 'Uncatched error','Open PotgreSQL log file to get more details', '2', 't', 'generic');

-- Debug messages (audit_cat_error.id between 0 and 99) 
INSERT INTO audit_cat_error VALUES ('0', 'OK', null, '3', 'f', 'generic');
INSERT INTO audit_cat_error VALUES ('1', 'Trigger INSERT','Inserted', '3', 'f', null);
INSERT INTO audit_cat_error VALUES ('2', 'Trigger UPDATE','Updated', '3', 'f', null);
INSERT INTO audit_cat_error VALUES ('3', 'Trigger DELETE','Deleted', '3', 'f', null);

-- Trigger messages (audit_cat_error.id between 101 and 499) 
INSERT INTO audit_cat_error VALUES ('100', 'Test trigger', 'Trigger test', '0', 't', 'ws_trg');
INSERT INTO audit_cat_error VALUES ('105', 'There are no nodes types defined in the model', 'Define at least one', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('110', 'There are no nodes catalog defined in the model', 'Define at least one', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('115', 'There are no sectors defined in the model', 'Define at least one', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('120', 'Feature is out of sector','Please take a look on your map and use the approach of the sectors!', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('125', 'There are no dma defined in the model', 'Define at least one', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('130', 'Feature is out of dma','Please take a look on your map and use the approach of the dma', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('135', 'Change node catalog is forbidden','The new node catalog is not included on the same type (node_type.type) of the old node catalog', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('140', 'There are no arc types defined in the model','Define at least one','2', 't', null);
INSERT INTO audit_cat_error VALUES ('145', 'There are no arc catalog defined in the model','Define at least one','2', 't', null);
INSERT INTO audit_cat_error VALUES ('150', 'There are no connec catalog defined in the model','Define at least one', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('152', 'There are no grate catalog defined in the model','Define at least one', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('155', 'Insert a new arc in this table is not allowed', 'To insert new arc, please use the GIS FEATURES layer arc', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('157', 'Delete arcs from this table is not allowed', 'To delete arcs, please use the GIS FEATURES layer arc', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('160', 'Insert a new node in this table is not allowed', 'To insert new node, please use the GIS FEATURES layer node', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('163', 'Delete nodes from this table is not allowed', 'To delete nodes, please use the GIS FEATURES layer node', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('165', 'Insert a new valve in this table is not allowed', 'To insert new valve, please use the GIS FEATURES layer node', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('170', 'There are columns in this table not allowed to edit', 'Try to update open, accesibility, broken, mincut_anl or hydraulic_anl', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('175', 'Delete valves from this table is not allowed', 'To delete valves, please use the GIS FEATURES layer node', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('180', 'One or more arcs has the same Node as Node1 and Node2', 'Please, check your project or modify the configuration propierties', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('182', 'One or more arcs was not inserted because it has not start/end node', 'Please, check your project or modify the configuration propierties', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('185', 'Exists one o more connecs closer than minimum configured,', 'Please, check your project or modify the configuration propierties', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('190', 'Exists one o more nodes closer than minimum configured,', 'Please, check your project or modify the configuration propierties', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('200', 'Elev is not an updatable column', 'Please use top_elev or ymax to modify this value', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('205', 'Is not possible to update the state of the node. There are one or more arcs with state incompatible', 'Review your data', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('210', 'One or more arcs was not inserted because it has not start/end node perharps due the diferent state of its', 'Review state of nodes or/and tolerence of arc searching nodes', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('215', 'Is not possible to update the state of the arc. Nodes initial or end have incompatible state', 'Review your data', '2', 't', null);


-- Function messages (audit_cat_error.id between 501 and 998)
INSERT INTO audit_cat_error VALUES ('505', 'Node not found','Please check table node', '1', 't', 'ws');
INSERT INTO audit_cat_error VALUES ('510', 'Pipes has different types', 'It is no possible to delete node', '1', 't', 'ws');
INSERT INTO audit_cat_error VALUES ('515', 'Node has not 2 arcs', 'It is no possible to delete node', '1', 't', 'ws');
INSERT INTO audit_cat_error VALUES ('518', 'Node has one or more arcs', 'It is no possible to move node', '1', 't', 'ws');
INSERT INTO audit_cat_error VALUES ('520', 'Arc not found','Please check table arc', '1', 't', 'ws_fct');

-- Undefined error (audit_cat_error.id = 999)
INSERT INTO audit_cat_error VALUES ('999', 'Undefined error', 'Undefined', '1', 't', 'generic');

