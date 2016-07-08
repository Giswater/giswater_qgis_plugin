
-- 
-- Message errors already translated (i18n)
--

-- Uncatched errors (log_code.id = -1)
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('-1', 'Uncatched error. Open PotgreSQL log file to get more details', '2', 't', 'generic');

-- Debug messages (log_code.id between 0 and 99) 
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('0', 'OK', '3', 'f', 'generic');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('1', 'Trigger INSERT', '3', 'f', 'generic');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('2', 'Trigger UPDATE', '3', 'f', 'generic');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('3', 'Trigger DELETE', '3', 'f', 'generic');

-- Trigger messages (log_code.id between 100 and 199) 
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('100', 'Test trigger', '1', 't', 'ws_trg');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('101', 'There are no nodes types defined in the model, define at least one', '1', 't', 'ws_trg');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('102', 'There are no nodes catalog defined in the model, define at least one', '1', 't', 'ws_trg');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('103', 'There are no sectors defined in the model, define at least one', '1', 't', 'ws_trg');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('104', 'Please take a look on your map and use the approach of the sectors!', '1', 't', 'ws_trg');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('105', 'There are no dma defined in the model, define at least one', '1', 't', 'ws_trg');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('106', ' Please take a look on your map and use the approach of the dma', '1', 't', 'ws_trg');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('107', 'Change node catalog is forbidden. The new node catalog is not included on the same type (node_type.type) of the old node catalog', '1', 't', 'ws_trg');

-- Water supply messages (log_code.id between 200 and 299)
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('201', 'Node not found. Please check table "node"', '1', 't', 'ws');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('202', 'Pipes has different types', '1', 't', 'ws');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('203', 'Node has not 2 arcs', '1', 't', 'ws');
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('204', 'Arc not found. Please check table "arc"', '1', 't', 'ws_fct');

-- Undefined error (log_code.id = 999)
INSERT INTO "SCHEMA_NAME_audit"."log_code" VALUES ('999', 'Undefined error', '1', 't', 'generic');


-- Parametrize functions (not used for now)
INSERT INTO SCHEMA_NAME_audit.log_function (id, name, context, input_params, return_type) 
VALUES (1, 'gw_fct_delete_node', 'utils', '{"node_id_arg": "varchar"}', 'integer');

