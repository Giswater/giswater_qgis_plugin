
-- Message errors with i18n

-- Generic messages
DELETE * FROM sample_ws_fv_audit.log_code
INSERT INTO sample_ws_fv_audit.log_code (id, message, log_level, show_user) VALUES (-1, 'Uncatched error. Open PotgreSQL log file to get more details', 2, 't');
INSERT INTO sample_ws_fv_audit.log_code (id, message, log_level, show_user) VALUES (0, 'OK', 0, 'f');
INSERT INTO sample_ws_fv_audit.log_code (id, message) VALUES (999, 'Undefined error');


-- Messages related with WS 
INSERT INTO sample_ws_fv_audit.log_code (id, message, context) VALUES (201, 'Node not found. Please check table "node"', 'ws');
INSERT INTO sample_ws_fv_audit.log_code (id, message, context) VALUES (202, 'Pipes has different types', 'ws');
INSERT INTO sample_ws_fv_audit.log_code (id, message, context) VALUES (203, 'Node has not 2 arcs', 'ws');
INSERT INTO sample_ws_fv_audit.log_code (id, message, context) VALUES (204, 'Arc not found. Please check table "arc"', 'ws');


-- Parametrize functions (not used for now)
INSERT INTO sample_ws_fv_audit.log_function (id, name, context, input_params, return_type) 
VALUES (1, 'gw_fct_delete_node', 'utils', '{"node_id_arg": "varchar"}', 'integer');

