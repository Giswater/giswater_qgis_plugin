/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_rename_functions_schema"(p_old_name text, p_new_name text) RETURNS "pg_catalog"."void" AS $BODY$
DECLARE
    rec_function record;
    rec_parameters record;
    v_sql text;
    v_params text;

BEGIN

    -- Functions
    SET check_function_bodies = false;

    FOR rec_function IN
        SELECT routine_name, REPLACE(routine_definition, p_old_name, p_new_name) as definition, type_udt_name, external_language, specific_name 
        FROM information_schema.routines 
        WHERE routine_schema = p_new_name 
        AND external_language in ('SQL', 'PLPGSQL')
        ORDER BY routine_name
    LOOP

        -- Get function parameters
        v_params:= '';
        FOR rec_parameters IN
            SELECT parameter_mode, parameter_name, udt_name 
            FROM information_schema.parameters 
            WHERE specific_name = rec_function.specific_name 
            ORDER BY ordinal_position
        LOOP
            v_params:= v_params||rec_parameters.parameter_mode||' '||rec_parameters.parameter_name||' '||rec_parameters.udt_name||', ';
        END LOOP;

        IF (char_length(v_params) > 0) THEN
            v_params:= substring(v_params from 1 for (char_length(v_params) - 2));
        END IF;

        IF (rec_function.type_udt_name != 'trigger') THEN
            v_sql:= 'CREATE OR REPLACE FUNCTION '||p_new_name||'.'||quote_ident(rec_function.routine_name)||'('||v_params||') '
                'RETURNS '||rec_function.type_udt_name||' AS $BODY'||'$'||rec_function.definition||'$BODY'||'$' 
                || ' LANGUAGE '||rec_function.external_language||' VOLATILE COST 100;';
            --RAISE NOTICE 'v_sql %', v_sql;
            EXECUTE v_sql;
        END IF;

    END LOOP;

END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;

