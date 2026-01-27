/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 2968

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector_x_gully()
  RETURNS trigger AS
$BODY$

/*
This trigger controls if gully has link and which class of link it has as well as sets some values for states.
*/

DECLARE
    v_gully_state            smallint;
    v_gully_expl_id          smallint;
    v_gully_expl_visibility  smallint[];
    v_plan_psector_expl_id   smallint;
    v_combined_visibility    smallint[];
    v_link_id                integer;

BEGIN

    EXECUTE 'SET search_path TO ' || quote_literal(TG_TABLE_SCHEMA) || ', public';

    -- Get expl_id from plan_psector
    SELECT expl_id INTO v_plan_psector_expl_id
    FROM plan_psector
    WHERE psector_id = NEW.psector_id;

    -- Get state, expl_id, and expl_visibility from gully
    SELECT state, expl_id, expl_visibility
        INTO v_gully_state, v_gully_expl_id, v_gully_expl_visibility
    FROM gully
    WHERE gully_id = NEW.gully_id;

    -- Combine expl and visibility for check
    v_combined_visibility := array_append(COALESCE(v_gully_expl_visibility, ARRAY[]::int[]), v_gully_expl_id);

    -- Do not allow to insert features with expl different from psector expl
    IF v_plan_psector_expl_id <> ALL(v_combined_visibility) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"3234", "function":"2968","parameters":null}}$$);';
    END IF;

    -- Set state defaults based on gully state
    IF NEW.state IS NULL AND v_gully_state = 1 THEN
        NEW.state := 0;
    ELSIF NEW.state IS NULL AND v_gully_state = 2 THEN
        NEW.state := 1;
    END IF;

    -- Set doable and manage state transitions
    IF NEW.state = 1 AND v_gully_state = 1 THEN
        NEW.doable := false;
        -- (optionally: looking for arc_id state=2 closest)
    ELSIF NEW.state = 0 AND v_gully_state = 1 THEN
        NEW.doable := false;
    ELSIF v_gully_state = 2 THEN
        IF NEW.state = 0 THEN
            EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"3182", "function":"2968","parameters":null}}$$);';
        END IF;
        NEW.doable := true;
    END IF;

    -- Prophylactic control of doable
    IF NEW.doable IS NULL THEN
        NEW.doable := true;
    END IF;

    -- Get link_id from ve_link if exists
    SELECT link_id INTO v_link_id
    FROM ve_link
    WHERE feature_id = NEW.gully_id
    LIMIT 1;

    IF TG_OP = 'INSERT' THEN
        IF v_link_id IS NOT NULL THEN
            NEW.link_id := v_link_id;
        END IF;
    END IF;

    RETURN NEW;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
