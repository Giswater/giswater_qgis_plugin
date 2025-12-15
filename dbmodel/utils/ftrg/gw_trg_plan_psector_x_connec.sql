/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 2936

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector_x_connec()
RETURNS trigger AS
$BODY$
DECLARE
    v_connec_state           	smallint;
    v_connec_expl_id            smallint;
	v_connec_expl_visibility    smallint[];
	v_combined_visibility       smallint[];
    v_plan_psector_expl_id      smallint;
    v_link_id_var         		integer;
    v_arc_id_var          		integer;
BEGIN

    EXECUTE 'SET search_path TO ' || quote_literal(TG_TABLE_SCHEMA) || ', public';

    -- Get expl_id for plan_psector and connec
    SELECT expl_id 
		INTO v_plan_psector_expl_id 
	FROM plan_psector 
		WHERE psector_id = NEW.psector_id;

    SELECT state, expl_id, expl_visibility 
		INTO v_connec_state, v_connec_expl_id, v_connec_expl_visibility 
	FROM connec 
		WHERE connec_id = NEW.connec_id;

	v_combined_visibility := array_append(v_connec_expl_visibility, v_connec_expl_id);

    -- Do not allow to insert features with expl different from psector expl
    IF v_plan_psector_expl_id <> ALL(v_combined_visibility) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"3234", "function":"2936","parameters":null}}$$);';
    END IF;

    -- Set NEW.state by default if NULL, based on connec previous state
    IF NEW.state IS NULL THEN
        IF v_connec_state = 1 THEN
            NEW.state := 0;
        ELSIF v_connec_state = 2 THEN
            NEW.state := 1;
        END IF;
    END IF;

    -- Update doable and state logic
    IF NEW.state = 1 AND v_connec_state = 1 THEN
        NEW.doable := false;

    ELSIF NEW.state = 0 AND v_connec_state = 1 THEN
        NEW.doable := false;

    ELSIF v_connec_state = 2 THEN
        IF NEW.state = 0 THEN
            EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"3182", "function":"2936","parameters":null}}$$);';
        END IF;
        NEW.doable := true;
    END IF;

    -- Prophylactic control of doable
    IF NEW.doable IS NULL THEN
        NEW.doable := true;
    END IF;

    -- Get link_id and arc_id only once
    SELECT link_id INTO v_link_id_var FROM ve_link WHERE feature_id = NEW.connec_id LIMIT 1;
    SELECT arc_id INTO v_arc_id_var FROM ve_connec WHERE connec_id = NEW.connec_id LIMIT 1;

    IF TG_OP = 'INSERT' THEN
        IF v_link_id_var IS NOT NULL AND NEW.state = 0 THEN
            NEW.link_id := v_link_id_var;
        END IF;

        IF v_arc_id_var IS NOT NULL AND NEW.state = 0 THEN
            NEW.arc_id := v_arc_id_var;
        END IF;
    END IF;

    RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
