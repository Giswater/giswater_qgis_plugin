/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3514

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_admin_manage_fields(p_data json)
RETURNS json
LANGUAGE plpgsql
AS $function$
/*
EXAMPLE
-- Dry-run: show what would be recreated
SELECT cm.gw_fct_cm_admin_manage_fields($${
  "data": {"action":"DRYRUN"}
}$$);

-- Sync only a subset of views
SELECT cm.gw_fct_cm_admin_manage_fields($${
  "data": {
    "action":"SYNC",
    "objects": [
      {"cm_schema":"cm","cm_name":"ve_arc","parent_schema":"PARENT_SCHEMA","parent_name":"ve_arc","object_type":"VIEW"}
    ]
  }
}$$);
*/
DECLARE
    v_action            text := COALESCE((p_data->'data'->>'action'), 'SYNC');
    v_objects           json := (p_data->'data'->'objects');

    v_prev_search_path  text;
    v_version           text;

    rec                 record;
    v_sql               text;
    v_sql_list          text[] := '{}';
    v_count_processed   integer := 0;
    v_count_failed      integer := 0;
    v_err               text;

BEGIN
    -- set local search_path
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'cm, PARENT_SCHEMA, public', true);

    -- version for return
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    -- temp table of objects to process
    CREATE TEMP TABLE IF NOT EXISTS _cm_mirror_objects (
        cm_schema      text,
        cm_name        text,
        parent_schema  text,
        parent_name    text,
        object_type    text
    ) ON COMMIT DROP;
    TRUNCATE _cm_mirror_objects;

    -- If explicit objects provided, use them; otherwise auto-discover simple mirror views
    IF v_objects IS NOT NULL AND json_typeof(v_objects) = 'array' THEN
        INSERT INTO _cm_mirror_objects (cm_schema, cm_name, parent_schema, parent_name, object_type)
        SELECT 
            COALESCE((obj->>'cm_schema'), 'cm')::text,
            (obj->>'cm_name')::text,
            COALESCE((obj->>'parent_schema'), 'PARENT_SCHEMA')::text,
            (obj->>'parent_name')::text,
            UPPER(COALESCE((obj->>'object_type'), 'VIEW'))::text
        FROM json_array_elements(v_objects) AS obj
        WHERE (obj->>'cm_name') IS NOT NULL AND (obj->>'parent_name') IS NOT NULL;
    ELSE
        -- Auto-discover CM views that depend on exactly ONE object in PARENT_SCHEMA
        -- and whose definition is a simple SELECT * FROM parent
        INSERT INTO _cm_mirror_objects (cm_schema, cm_name, parent_schema, parent_name, object_type)
        SELECT 
            n.nspname        AS cm_schema,
            c.relname        AS cm_name,
            rn.nspname       AS parent_schema,
            referenced.relname AS parent_name,
            'VIEW'           AS object_type
        FROM pg_depend d
        JOIN pg_rewrite r       ON r.oid = d.objid
        JOIN pg_class   c       ON c.oid = r.ev_class
        JOIN pg_namespace n     ON n.oid = c.relnamespace
        JOIN pg_class   referenced ON referenced.oid = d.refobjid
        JOIN pg_namespace rn    ON rn.oid = referenced.relnamespace
        WHERE c.relkind = 'v'
          AND n.nspname = 'cm'
          AND rn.nspname = 'PARENT_SCHEMA'
        GROUP BY n.nspname, c.relname, rn.nspname, referenced.relname
        HAVING COUNT(DISTINCT referenced.oid) = 1
        AND EXISTS (
            SELECT 1
            FROM pg_views v
            WHERE v.schemaname = n.nspname AND v.viewname = c.relname
              AND regexp_replace(v.definition, '\\s+', ' ', 'g') ~* '^\n?\s*select\s+\*\s+from\s+"?PARENT_SCHEMA"?\.'
        );
    END IF;

    -- Process objects
    FOR rec IN (
        SELECT DISTINCT cm_schema, cm_name, parent_schema, parent_name, object_type
        FROM _cm_mirror_objects
        ORDER BY object_type, cm_schema, cm_name
    ) LOOP
        BEGIN
            IF rec.object_type = 'VIEW' THEN
                -- Recreate as SELECT * to pick new columns
                v_sql := format('CREATE OR REPLACE VIEW %I.%I AS SELECT * FROM %I.%I;',
                                rec.cm_schema, rec.cm_name, rec.parent_schema, rec.parent_name);

                IF upper(v_action) = 'DRYRUN' THEN
                    v_sql_list := array_append(v_sql_list, v_sql);
                ELSE
                    EXECUTE v_sql;
                END IF;

                v_count_processed := v_count_processed + 1;

            ELSIF rec.object_type = 'TABLE' THEN
                -- Basic one-way schema sync: add missing columns present in parent, do not drop anything
                -- Build list of columns and types from parent
                FOR v_sql IN (
                    SELECT format('ALTER TABLE %I.%I ADD COLUMN %I %s;', rec.cm_schema, rec.cm_name, a.attname,
                                  pg_catalog.format_type(a.atttypid, a.atttypmod)) AS ddl
                    FROM pg_attribute a
                    WHERE a.attrelid = format('%I.%I', rec.parent_schema, rec.parent_name)::regclass
                      AND a.attnum > 0 AND NOT a.attisdropped
                      AND NOT EXISTS (
                          SELECT 1 FROM pg_attribute b
                          WHERE b.attrelid = format('%I.%I', rec.cm_schema, rec.cm_name)::regclass
                            AND b.attnum > 0 AND NOT b.attisdropped
                            AND b.attname = a.attname
                      )
                ) LOOP
                    IF upper(v_action) = 'DRYRUN' THEN
                        v_sql_list := array_append(v_sql_list, v_sql);
                    ELSE
                        EXECUTE v_sql;
                    END IF;
                    v_count_processed := v_count_processed + 1;
                END LOOP;

            ELSE
                -- unsupported type
                CONTINUE;
            END IF;
        EXCEPTION WHEN OTHERS THEN
            v_err := SQLERRM;
            v_sql_list := array_append(v_sql_list, '-- ERROR: '||coalesce(v_err,'')||' while processing '||rec.cm_schema||'.'||rec.cm_name);
            v_count_failed := v_count_failed + 1;
        END;
    END LOOP;

    -- Restore search_path
    PERFORM set_config('search_path', v_prev_search_path, true);

    -- Return JSON
    RETURN json_build_object(
        'status', 'Accepted',
        'version', v_version,
        'body', json_build_object(
            'processed', v_count_processed,
            'failed', v_count_failed,
            'sql', v_sql_list
        )
    );
END;
$function$;
