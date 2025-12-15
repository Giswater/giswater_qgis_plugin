/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 1132

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_plan_psector_x_node()
  RETURNS trigger AS
$BODY$
DECLARE
    v_node_state                smallint;
    v_node_expl_id              smallint;
    v_node_expl_visibility      smallint[];
    v_plan_psector_expl_id      smallint;
    v_combined_visibility       smallint[];
BEGIN

    EXECUTE 'SET search_path TO ' || quote_literal(TG_TABLE_SCHEMA) || ', public';

    SELECT expl_id
        INTO v_plan_psector_expl_id
    FROM plan_psector 
        WHERE psector_id = NEW.psector_id;

    SELECT state, expl_id, expl_visibility 
        INTO v_node_state, v_node_expl_id, v_node_expl_visibility
    FROM node 
        WHERE node_id = NEW.node_id;

    v_combined_visibility := array_append(v_node_expl_visibility, v_node_expl_id);

    -- Do not allow to insert features with expl different from psector expl
    IF v_plan_psector_expl_id <> ALL(v_combined_visibility) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"3234", "function":"1132","parameters":null}}$$);';
    END IF;

    IF v_node_state = 1 THEN
        NEW.state := 0;
        NEW.doable := false;
    ELSIF v_node_state = 2 THEN
        IF NEW.state = 0 THEN
            EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"3182", "function":"1132","parameters":{"psector_id":"'|| OLD.psector_id || '"}}}$$);';
        END IF;
        NEW.state := 1;
        NEW.doable := true;
    END IF;

    RETURN NEW;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;