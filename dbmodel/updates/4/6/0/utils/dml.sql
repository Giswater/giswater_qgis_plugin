/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4434, 'Trying to connect %feature_type% with id %connect_id% to the closest arc.', NULL, 0, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4436, 'Trying to connect %feature_type% with id %connect_id% to the closest arc at a maximum distance of %max_distance% meters.', NULL, 0, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4438, 'Trying to connect %feature_type% with id %connect_id% to the closest arc with a diameter smaller than %check_arcdnom%.', NULL, 0, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4440, 'Trying to connect %feature_type% with id %connect_id% to the closest arc with a diameter smaller than %check_arcdnom% meters and at a maximum distance of %max_distance% meters.', NULL, 0, true, 'generic', 'core', 'AUDIT');

-- gw_fct_set_hydrometers (3520)
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3520, 'gw_fct_set_hydrometers', 'utils', 'function', 'json', 'json', 'Function to set hydrometers in the database.', NULL, NULL, 'core', NULL);
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4448, 'Invalid action: %action%. Must be INSERT, UPDATE, DELETE or REPLACE.', 'Check the action parameter in your request.', 2, true, 'utils', 'core', 'UI');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4450, 'No hydrometers provided in the request.', 'The hydrometers array cannot be empty. Provide at least one hydrometer.', 2, true, 'utils', 'core', 'UI');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4452, 'Code is required for hydrometer #%hydrometer% when using INSERT or REPLACE action.', 'Provide a valid code for each hydrometer.', 1, true, 'utils', 'core', 'UI');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4454, 'Hydrometer with code %code% not found for UPDATE operation.', 'Verify that the hydrometer exists in the database.', 2, true, 'utils', 'core', 'UI');

-- move there is and there are messages to -2 and -3, TEMPORARY SOLUTION
UPDATE sys_message
SET id=-3
WHERE id=5002;
UPDATE sys_message
SET id=-2
WHERE id=5000;

UPDATE sys_message
SET id=4456
WHERE id=5008;
UPDATE sys_message
SET id=4458
WHERE id=5010;

INSERT INTO sys_message (id,error_message,log_level,show_user,project_type,"source",message_type)
VALUES (4460,'Used plan psectors: %v_psectors%',0,true,'ud','core','UI');

INSERT INTO sys_message (id,error_message,log_level,show_user,project_type,"source",message_type)
VALUES (4462,'Commit changes: %v_commit_changes%',0,true,'ud','core','UI');

UPDATE config_form_fields SET label = 'Sys elev 2:' WHERE label = 'Elevation of the selected node 2:';

-- 06/11/2025
-- When updating y1, custom_y1, elev1, or custom_elev1, also refresh node_2 fields
UPDATE config_form_fields 
SET widgetcontrols = '{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1", "node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2", "slope"]}'::json
WHERE columnname IN ('y1', 'custom_y1', 'elev1', 'custom_elev1')
AND formname LIKE 've_arc_%'
AND formtype = 'form_feature'
AND widgetcontrols::text LIKE '%autoupdateReloadFields%';

-- When updating y2, custom_y2, elev2, or custom_elev2, also refresh node_1 fields
UPDATE config_form_fields 
SET widgetcontrols = '{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1", "node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2", "slope"]}'::json
WHERE columnname IN ('y2', 'custom_y2', 'elev2', 'custom_elev2')
AND formname LIKE 've_arc_%'
AND formtype = 'form_feature'
AND widgetcontrols::text LIKE '%autoupdateReloadFields%';

DO
$$
DECLARE
    v_rec record;
BEGIN
    FOR v_rec IN SELECT fid, except_msg FROM sys_fprocess LOOP
        IF right(v_rec.except_msg, 1) <> '.' AND right(v_rec.except_msg, 1) <> '!' AND right(v_rec.except_msg, 1) <> '?' THEN
            UPDATE sys_fprocess
            SET except_msg = v_rec.except_msg || '.'
            WHERE fid = v_rec.fid;
        END IF;
    END LOOP;
END;
$$;


UPDATE sys_fprocess SET query_text='SELECT a.node_id, a.nodecat_id, a.expl_id, a.the_geom FROM t_node a 
JOIN cat_node b ON a.nodecat_id = b.id
JOIN cat_feature_node c ON c.id = b.node_type
JOIN dma d ON d.dma_id = a.dma_id
WHERE d.active IS FALSE
AND ''DMA'' = ANY(c.graph_delimiter)' WHERE fid=636;

UPDATE sys_fprocess SET query_text='SELECT a.node_id, a.nodecat_id, a.expl_id, a.the_geom FROM node a 
JOIN cat_node b ON a.nodecat_id = b.id
JOIN cat_feature_node c ON c.id = b.node_type
JOIN presszone d ON d.presszone_id = a.presszone_id
WHERE d.active IS FALSE
AND ''PRESSZONE'' = ANY(c.graph_delimiter)' WHERE fid=182;

UPDATE sys_fprocess SET except_msg = 'arcs with length shorter than value set as node proximity. Please, check your data before continue.', 
query_text='SELECT arc_id,arccat_id,st_length(the_geom), the_geom, expl_id
FROM t_arc, config_param_system where parameter = ''edit_node_proximity'' 
and  st_length(the_geom) < json_extract_path_text(value::json,''value'')::numeric ' WHERE fid=391;

UPDATE config_param_system
	SET value='{"id":"EUR", "descript":"EURO", "symbol":"€", "separator":".", "decimals":true}'
	WHERE "parameter"='admin_currency';

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,"source")
	VALUES (3524,'gw_fct_set_currency_config','utils','function','num','num','Function to transform nuemric values of price to user configuration from admin_currency in config_param_system','core');
