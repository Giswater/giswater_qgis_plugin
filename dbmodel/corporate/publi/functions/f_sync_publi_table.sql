/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.gw_fct_sync_publi_table();

CREATE OR REPLACE FUNCTION publi.gw_fct_sync_publi_table(
    p_target_table text,
    p_source_schema text
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
    --------------------------------------------------------------------
    -- Source/target metadata
    --------------------------------------------------------------------
    v_source_schema text;
    v_source_table text;
    v_original_source_table text;
    v_pk_column text;

    --------------------------------------------------------------------
    -- Dynamic SQL parts
    --------------------------------------------------------------------
    v_columns text;
    v_select_columns text;
    v_set_clause text;
    v_diff_condition text;
    v_sql text;

    --------------------------------------------------------------------
    -- Update strategy
    --------------------------------------------------------------------
    v_has_updated_at boolean := false;
    v_update_strategy text := 'updated_at';

    --------------------------------------------------------------------
    -- Sync counters
    --------------------------------------------------------------------
    v_inserted integer := 0;
    v_updated integer := 0;
    v_deleted integer := 0;

    --------------------------------------------------------------------
    -- Selector counters
    --------------------------------------------------------------------
    v_selected_expl integer := 0;
    v_selected_sector integer := 0;
    v_selected_state integer := 0;
    v_selected_municipality integer := 0;
BEGIN

    --------------------------------------------------------------------
    -- 1. Detect source table from target table name.
    --
    -- Examples:
    --   publi.ws_ve_arc -> ws.ve_arc
    --   publi.ud_ve_arc -> ud.ve_arc
    --------------------------------------------------------------------
    IF p_target_table LIKE 'ws_%' OR p_target_table LIKE 'ud_%' THEN
        v_source_schema := p_source_schema;
        v_source_table := substring(p_target_table FROM 4);
        v_original_source_table := v_source_table;
    ELSE
        RAISE EXCEPTION 'Target table % does not start with ws_ or ud_', p_target_table;
    END IF;


    --------------------------------------------------------------------
    -- 2. Municipality fallback.
    --
    -- Municipality views/tables do not use updated_at.
    -- If v_ext_municipality exists, use it as the source for:
    --   publi.ws_ve_municipality
    --   publi.ud_ve_municipality
    --------------------------------------------------------------------
    IF v_source_table = 've_municipality'
       AND EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = v_source_schema
              AND table_name = 'v_ext_municipality'
       )
    THEN
        v_source_table := 'v_ext_municipality';
    END IF;


    --------------------------------------------------------------------
    -- 3. Prepare source selectors for current user.
    --
    -- Source ve_* views depend on selectors.
    -- Only positive IDs are selected: >= 1.
    --------------------------------------------------------------------

    -- selector_expl
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = v_source_schema
          AND table_name = 'selector_expl'
    ) THEN

        v_sql := format($SQL$
            DELETE FROM %I.selector_expl
            WHERE cur_user = current_user;

            INSERT INTO %I.selector_expl (expl_id, cur_user)
            SELECT DISTINCT expl_id, current_user
            FROM %I.exploitation
            WHERE expl_id >= 1;
        $SQL$, v_source_schema, v_source_schema, v_source_schema);

        EXECUTE v_sql;
        GET DIAGNOSTICS v_selected_expl = ROW_COUNT;

    END IF;


    -- selector_sector
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = v_source_schema
          AND table_name = 'selector_sector'
    ) THEN

        v_sql := format($SQL$
            DELETE FROM %I.selector_sector
            WHERE cur_user = current_user;

            INSERT INTO %I.selector_sector (sector_id, cur_user)
            SELECT DISTINCT sector_id, current_user
            FROM %I.sector
            WHERE sector_id >= 1;
        $SQL$, v_source_schema, v_source_schema, v_source_schema);

        EXECUTE v_sql;
        GET DIAGNOSTICS v_selected_sector = ROW_COUNT;

    END IF;


    -- selector_state
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = v_source_schema
          AND table_name = 'selector_state'
    ) THEN

        v_sql := format($SQL$
            DELETE FROM %I.selector_state
            WHERE cur_user = current_user;

            INSERT INTO %I.selector_state (state_id, cur_user)
            SELECT DISTINCT id, current_user
            FROM %I.value_state
            WHERE id >= 1;
        $SQL$, v_source_schema, v_source_schema, v_source_schema);

        EXECUTE v_sql;
        GET DIAGNOSTICS v_selected_state = ROW_COUNT;

    END IF;


    -- selector_municipality
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = v_source_schema
          AND table_name = 'selector_municipality'
    ) THEN

        v_sql := format($SQL$
            DELETE FROM %I.selector_municipality
            WHERE cur_user = current_user;

            INSERT INTO %I.selector_municipality (muni_id, cur_user)
            SELECT DISTINCT muni_id, current_user
            FROM %I.ext_municipality
            WHERE muni_id >= 1;
        $SQL$, v_source_schema, v_source_schema, v_source_schema);

        EXECUTE v_sql;
        GET DIAGNOSTICS v_selected_municipality = ROW_COUNT;

    END IF;


    --------------------------------------------------------------------
    -- 4. Detect primary key by convention + exceptions.
    --------------------------------------------------------------------
    v_pk_column := CASE v_source_table
        WHEN 've_exploitation' THEN 'expl_id'
        WHEN 've_macroexploitation' THEN 'macroexpl_id'
        WHEN 've_municipality' THEN 'muni_id'
        WHEN 'v_ext_municipality' THEN 'muni_id'
        ELSE regexp_replace(v_source_table, '^ve_', '') || '_id'
    END;


    --------------------------------------------------------------------
    -- 5. Validate source exists.
    --------------------------------------------------------------------
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = v_source_schema
          AND table_name = v_source_table
    ) THEN
        RAISE EXCEPTION 'Source %.% does not exist',
            v_source_schema, v_source_table;
    END IF;


    --------------------------------------------------------------------
    -- 6. Validate target exists.
    --------------------------------------------------------------------
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'publi'
          AND table_name = p_target_table
    ) THEN
        RAISE EXCEPTION 'Target publi.% does not exist',
            p_target_table;
    END IF;


    --------------------------------------------------------------------
    -- 7. Validate primary key exists in both source and target.
    --------------------------------------------------------------------
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = v_source_schema
          AND table_name = v_source_table
          AND column_name = v_pk_column
    ) THEN
        RAISE EXCEPTION 'Detected PK % does not exist in source %.%',
            v_pk_column, v_source_schema, v_source_table;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'publi'
          AND table_name = p_target_table
          AND column_name = v_pk_column
    ) THEN
        RAISE EXCEPTION 'Detected PK % does not exist in target publi.%',
            v_pk_column, p_target_table;
    END IF;


    --------------------------------------------------------------------
    -- 8. Validate updated_at strategy.
    --
    -- Normal tables:
    --   updated_at must exist in both source and target.
    --
    -- Municipality:
    --   updated_at is not required.
    --   Updates are detected by comparing common columns.
    --------------------------------------------------------------------
    SELECT EXISTS (
        SELECT 1
        FROM information_schema.columns s
        JOIN information_schema.columns t
          ON t.column_name = s.column_name
         AND t.table_schema = 'publi'
         AND t.table_name = p_target_table
        WHERE s.table_schema = v_source_schema
          AND s.table_name = v_source_table
          AND s.column_name = 'updated_at'
    )
    INTO v_has_updated_at;

    IF v_has_updated_at IS FALSE THEN
        IF v_original_source_table = 've_municipality'
           OR v_source_table = 'v_ext_municipality'
        THEN
            v_update_strategy := 'column_diff_without_updated_at';
        ELSE
            RAISE EXCEPTION 'updated_at does not exist in both %.% and publi.%',
                v_source_schema, v_source_table, p_target_table;
        END IF;
    END IF;


    --------------------------------------------------------------------
    -- 9. Get common columns between source and target.
    --------------------------------------------------------------------
    SELECT
        string_agg(format('%I', t.column_name), ', ' ORDER BY t.ordinal_position),
        string_agg(format('s.%I', t.column_name), ', ' ORDER BY t.ordinal_position)
    INTO
        v_columns,
        v_select_columns
    FROM information_schema.columns t
    JOIN information_schema.columns s
      ON s.column_name = t.column_name
     AND s.table_schema = v_source_schema
     AND s.table_name = v_source_table
    WHERE t.table_schema = 'publi'
      AND t.table_name = p_target_table;

    IF v_columns IS NULL OR v_select_columns IS NULL THEN
        RAISE EXCEPTION 'No common columns between %.% and publi.%',
            v_source_schema, v_source_table, p_target_table;
    END IF;


    --------------------------------------------------------------------
    -- 10. Build SET clause for UPDATE.
    --     The primary key is never updated.
    --------------------------------------------------------------------
    SELECT string_agg(
        format('%1$I = s.%1$I', t.column_name),
        ', ' ORDER BY t.ordinal_position
    )
    INTO v_set_clause
    FROM information_schema.columns t
    JOIN information_schema.columns s
      ON s.column_name = t.column_name
     AND s.table_schema = v_source_schema
     AND s.table_name = v_source_table
    WHERE t.table_schema = 'publi'
      AND t.table_name = p_target_table
      AND t.column_name <> v_pk_column;

    IF v_set_clause IS NULL THEN
        RAISE EXCEPTION 'No updatable common columns found for publi.%', p_target_table;
    END IF;


    --------------------------------------------------------------------
    -- 11. Build diff condition.
    --
    -- Used only when updated_at is not available.
    -- json columns are compared as jsonb because json has no equality
    -- operator in PostgreSQL.
    --------------------------------------------------------------------
    SELECT string_agg(
        CASE
            WHEN t.udt_name = 'json' OR s.udt_name = 'json' THEN
                format('t.%1$I::jsonb IS DISTINCT FROM s.%1$I::jsonb', t.column_name)
            ELSE
                format('t.%1$I IS DISTINCT FROM s.%1$I', t.column_name)
        END,
        ' OR ' ORDER BY t.ordinal_position
    )
    INTO v_diff_condition
    FROM information_schema.columns t
    JOIN information_schema.columns s
      ON s.column_name = t.column_name
     AND s.table_schema = v_source_schema
     AND s.table_name = v_source_table
    WHERE t.table_schema = 'publi'
      AND t.table_name = p_target_table
      AND t.column_name <> v_pk_column;

    IF v_diff_condition IS NULL THEN
        RAISE EXCEPTION 'No comparable common columns found for publi.%', p_target_table;
    END IF;


    --------------------------------------------------------------------
    -- 12. INSERT new rows.
    --
    -- Source has the ID, publi does not.
    --------------------------------------------------------------------
    v_sql := format($SQL$
        INSERT INTO publi.%I (%s)
        SELECT %s
        FROM %I.%I s
        WHERE NOT EXISTS (
            SELECT 1
            FROM publi.%I t
            WHERE t.%I = s.%I
        );
    $SQL$,
        p_target_table,
        v_columns,
        v_select_columns,
        v_source_schema,
        v_source_table,
        p_target_table,
        v_pk_column,
        v_pk_column
    );

    EXECUTE v_sql;
    GET DIAGNOSTICS v_inserted = ROW_COUNT;


    --------------------------------------------------------------------
    -- 13. UPDATE existing rows.
    --
    -- Normal mode:
    --   Update only when source.updated_at is newer.
    --
    -- Municipality mode:
    --   Update only when any common column is different.
    --------------------------------------------------------------------
    IF v_has_updated_at IS TRUE THEN

        v_sql := format($SQL$
            UPDATE publi.%I t
            SET %s
            FROM %I.%I s
            WHERE t.%I = s.%I
              AND s.updated_at IS NOT NULL
              AND (
                    t.updated_at IS NULL
                 OR s.updated_at > t.updated_at
              );
        $SQL$,
            p_target_table,
            v_set_clause,
            v_source_schema,
            v_source_table,
            v_pk_column,
            v_pk_column
        );

    ELSE

        v_sql := format($SQL$
            UPDATE publi.%I t
            SET %s
            FROM %I.%I s
            WHERE t.%I = s.%I
              AND (%s);
        $SQL$,
            p_target_table,
            v_set_clause,
            v_source_schema,
            v_source_table,
            v_pk_column,
            v_pk_column,
            v_diff_condition
        );

    END IF;

    EXECUTE v_sql;
    GET DIAGNOSTICS v_updated = ROW_COUNT;


    --------------------------------------------------------------------
    -- 14. DELETE rows that no longer exist in source.
    --
    -- Publi has the ID, source does not.
    --------------------------------------------------------------------
    v_sql := format($SQL$
        DELETE FROM publi.%I t
        WHERE NOT EXISTS (
            SELECT 1
            FROM %I.%I s
            WHERE s.%I = t.%I
        );
    $SQL$,
        p_target_table,
        v_source_schema,
        v_source_table,
        v_pk_column,
        v_pk_column
    );

    EXECUTE v_sql;
    GET DIAGNOSTICS v_deleted = ROW_COUNT;


    --------------------------------------------------------------------
    -- 15. Return summary.
    --------------------------------------------------------------------
    RETURN json_build_object(
        'status', 'Accepted',
        'body', json_build_object(
            'source', v_source_schema || '.' || v_source_table,
            'original_source_table', v_original_source_table,
            'target', 'publi.' || p_target_table,
            'pk_column', v_pk_column,
            'current_user', current_user,
            'selectors', json_build_object(
                'selector_expl', json_build_object(
                    'selected_count', v_selected_expl,
                    'filter', 'expl_id >= 1'
                ),
                'selector_sector', json_build_object(
                    'selected_count', v_selected_sector,
                    'filter', 'sector_id >= 1'
                ),
                'selector_state', json_build_object(
                    'selected_count', v_selected_state,
                    'filter', 'state_id >= 1'
                ),
                'selector_municipality', json_build_object(
                    'selected_count', v_selected_municipality,
                    'filter', 'muni_id >= 1'
                )
            ),
            'sync', json_build_object(
                'update_strategy', v_update_strategy,
                'updated_by', CASE
                    WHEN v_has_updated_at IS TRUE THEN 'updated_at'
                    ELSE 'column_diff'
                END,
                'inserted', v_inserted,
                'updated', v_updated,
                'deleted', v_deleted
            )
        )
    );

END;
$$;