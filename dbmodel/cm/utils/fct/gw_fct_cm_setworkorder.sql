/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 3456

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_setworkorder(p_data JSON)
  RETURNS json AS
$BODY$

DECLARE
  v_fields     JSONB := (p_data->'data'->'fields')::JSONB;
  v_idcol      TEXT  := (p_data->'feature'->>'idName');
  v_id         INTEGER := (v_fields->>v_idcol)::INT;
  v_existing   INTEGER;
  v_cols       TEXT;
  v_vals       TEXT;
  v_sql        TEXT;
  v_new_id     INTEGER;
  v_version    TEXT;
  v_result     JSON;
  v_schema     CONSTANT TEXT := 'cm';
  v_table      TEXT := (p_data->'feature'->>'tableName');
  v_prev_search_path text;
BEGIN
  v_prev_search_path := current_setting('search_path');
  PERFORM set_config('search_path', 'cm,public', true);

  -- see if we're updating or inserting
  SELECT workorder_id
    INTO v_existing
    FROM workorder
   WHERE workorder_id = v_id;

  IF v_existing IS NULL THEN
    -- INSERT path
    EXECUTE format(
      'INSERT INTO %I.%I
         SELECT *
           FROM jsonb_populate_record(NULL::%I.%I, $1)
       RETURNING %I',
      v_schema, v_table,
      v_schema, v_table,
      v_idcol
    )
    USING v_fields
    INTO v_new_id;
  ELSE
    -- UPDATE path
    SELECT
      string_agg(format('%I', key), ', ')
    INTO v_cols
    FROM jsonb_each(v_fields)
    WHERE key <> v_idcol;

    SELECT
      string_agg(format('j.%I', key), ', ')
    INTO v_vals
    FROM jsonb_each(v_fields)
    WHERE key <> v_idcol;

    -- assemble the UPDATE…FROM… SQL
    v_sql := format(
      $fmt$
      UPDATE %I.%I AS t
         SET (%s) = (%s)
       FROM (
         SELECT *
           FROM jsonb_populate_record(NULL::%I.%I, $1)
       ) AS j
      WHERE t.%I = j.%I
      $fmt$,
      v_schema, v_table,
      v_cols, v_vals,
      v_schema, v_table,
      v_idcol, v_idcol
    );

    -- execute and catch any error
    BEGIN
      EXECUTE v_sql USING v_fields;
      v_new_id := v_existing;
    EXCEPTION WHEN OTHERS THEN
      RAISE EXCEPTION
        'Error updating workorder:
         SQL: %
         ERR: %',
        v_sql,
        SQLERRM;
    END;
  END IF;

  -- fetch new version
  SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

  -- prepare return payload
  v_result := json_build_object(
    'status',  'Accepted',
    'message', format('Workorder %s saved', v_new_id),
    'version', v_version,
    'body',    json_build_object(
                 'feature', json_build_object('id', v_new_id),
                 'data',    json_build_object('info','OK')
               )
  );

  PERFORM set_config('search_path', v_prev_search_path, true);
  RETURN v_result;

EXCEPTION WHEN OTHERS THEN
  PERFORM set_config('search_path', v_prev_search_path, true);
  RETURN json_build_object(
    'status','Failed',
    'message', json_build_object('level', 3, 'text', SQLERRM),
    'SQLSTATE', SQLSTATE
  );
END;

$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
