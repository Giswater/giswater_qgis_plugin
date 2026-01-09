/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3510

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_get_expl_id_array(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_expl_id_array(p_expl_id text)
RETURNS text AS
$BODY$

/* NOTE Example usage:

SELECT gw_fct_get_expl_id_array('-901'); -- For all user selected exploitations
SELECT gw_fct_get_expl_id_array('-902'); -- For all exploitations
SELECT gw_fct_get_expl_id_array('0'); -- For exploitation 0
SELECT gw_fct_get_expl_id_array('1,2,3'); -- For specific exploitations

-- Returns a comma-separated list of exploitation IDs (TEXT), or NULL for all or if there is no exploitation selected
*/

DECLARE
    v_expl_id_array text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- For user selected exploitations
    IF p_expl_id = '-901' THEN
        SELECT string_agg(expl_id::text, ',') INTO v_expl_id_array
        FROM selector_expl
        WHERE cur_user = current_user;
    -- For all exploitations
    ELSIF p_expl_id = '-902' THEN
        v_expl_id_array := NULL;
    -- For a specific exploitation/s
    ELSE
        v_expl_id_array := string_agg(p_expl_id, ',');
    END IF;

    RETURN v_expl_id_array;

    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
