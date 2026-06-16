/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.gw_fct_sync_publi_all();

CREATE OR REPLACE FUNCTION publi.gw_fct_sync_publi_all()
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
    v_rec record;
    v_source_schema text;
    v_result json;
    v_results jsonb := '[]'::jsonb;
    v_errors jsonb := '[]'::jsonb;
BEGIN

    FOR v_rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'publi'
          AND table_type = 'BASE TABLE'
          AND (
                table_name LIKE 'ws_%'
             OR table_name LIKE 'ud_%'
          )
        ORDER BY table_name
    LOOP

        BEGIN
            IF v_rec.table_name LIKE 'ws_%' THEN
                v_source_schema := 'ws';
            ELSIF v_rec.table_name LIKE 'ud_%' THEN
                v_source_schema := 'ud';
            ELSE
                CONTINUE;
            END IF;

            v_result := publi.gw_fct_sync_publi_table(
                v_rec.table_name,
                v_source_schema
            );

            v_results := v_results || to_jsonb(v_result);

        EXCEPTION WHEN OTHERS THEN
            v_errors := v_errors || jsonb_build_object(
                'table', 'publi.' || v_rec.table_name,
                'source_schema', COALESCE(v_source_schema, 'unknown'),
                'error', SQLERRM
            );
        END;

    END LOOP;

    RETURN json_build_object(
        'status', 'Accepted',
        'body', json_build_object(
            'default_source_schemas', json_build_object(
                'ws_prefix', 'ws',
                'ud_prefix', 'ud'
            ),
            'results', v_results,
            'errors', v_errors
        )
    );

END;
$$;