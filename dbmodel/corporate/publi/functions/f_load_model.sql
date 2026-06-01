/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.f_load_model(text, text, bool);

CREATE OR REPLACE FUNCTION publi.f_load_model(p_source_schema text, p_prefix text, p_force_drop boolean DEFAULT false)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_dep_objects text;
BEGIN
    IF p_prefix NOT IN ('ws', 'ud') THEN
        RAISE EXCEPTION 'Invalid prefix: %, expected ws or ud', p_prefix;
    END IF;

    /*
     * Safety check:
     * Before dropping/recreating publi tables, check if any views or materialized views
     * depend on the target tables.
     *
     * By default, the function stops if dependencies exist.
     * To allow the old CASCADE behavior, call:
     *
     * SELECT publi.f_load_model('ws', 'ws', true);
     * SELECT publi.f_load_model('ud', 'ud', true);
     */
    IF NOT p_force_drop THEN
        SELECT string_agg(
            format(
                'table publi.%I is used by %I.%I',
                ref.relname,
                n.nspname,
                c.relname
            ),
            E'\n'
            ORDER BY ref.relname, n.nspname, c.relname
        )
        INTO v_dep_objects
        FROM pg_depend d
        JOIN pg_rewrite r
            ON r.oid = d.objid
        JOIN pg_class c
            ON c.oid = r.ev_class
        JOIN pg_namespace n
            ON n.oid = c.relnamespace
        JOIN pg_class ref
            ON ref.oid = d.refobjid
        JOIN pg_namespace refn
            ON refn.oid = ref.relnamespace
        WHERE refn.nspname = 'publi'
          AND c.relkind IN ('v', 'm')
          AND ref.relname = ANY (
              ARRAY[
                  p_prefix || '_ve_exploitation',
                  p_prefix || '_ve_municipality',
                  p_prefix || '_ve_macroexploitation',
                  p_prefix || '_ve_macrosector',
                  p_prefix || '_ve_sector',
                  p_prefix || '_ve_dma',
                  p_prefix || '_ve_arc',
                  p_prefix || '_ve_node',
                  p_prefix || '_ve_connec',
                  p_prefix || '_ve_link',
                  p_prefix || '_ve_element',
                  p_prefix || '_ve_gully',
                  p_prefix || '_ve_presszone',
                  p_prefix || '_ve_dqa',
                  p_prefix || '_ve_supplyzone',
                  p_prefix || '_ve_dwfzone',
                  p_prefix || '_ve_drainzone'
              ]
          );

        IF v_dep_objects IS NOT NULL THEN
            RAISE EXCEPTION
                'f_load_model cancelled because dependent views/materialized views exist:% %Run again with p_force_drop = true if you really want to drop them.',
                E'\n',
                v_dep_objects;
        END IF;
    END IF;

    -- Exploitation
    EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_exploitation');
    EXECUTE format(
        'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_exploitation',
        p_prefix || '_ve_exploitation',
        p_source_schema
    );

    -- Municipality
    EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_municipality');
    EXECUTE format(
        'CREATE TABLE publi.%I AS
         SELECT m.muni_id,
                m.name,
                m.sector_id,
                m.expl_id,
                m.observ,
                m.active,
                m.the_geom
         FROM %I.ext_municipality m',
        p_prefix || '_ve_municipality',
        p_source_schema
    );

    -- Macroexploitation
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables t
        WHERE t.table_schema = p_source_schema
          AND t.table_name = 've_macroexploitation'
    ) THEN
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_macroexploitation');
        EXECUTE format(
            'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_macroexploitation',
            p_prefix || '_ve_macroexploitation',
            p_source_schema
        );
    ELSE
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_macroexploitation');
    END IF;

    -- Macrosector
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables t
        WHERE t.table_schema = p_source_schema
          AND t.table_name = 've_macrosector'
    ) THEN
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_macrosector');
        EXECUTE format(
            'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_macrosector',
            p_prefix || '_ve_macrosector',
            p_source_schema
        );
    ELSE
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_macrosector');
    END IF;

    -- Sector
    EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_sector');
    EXECUTE format(
        'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_sector',
        p_prefix || '_ve_sector',
        p_source_schema
    );

    -- DMA
    EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_dma');
    EXECUTE format(
        'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_dma',
        p_prefix || '_ve_dma',
        p_source_schema
    );

    -- Network: arc
    EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_arc');
    EXECUTE format(
        'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_arc',
        p_prefix || '_ve_arc',
        p_source_schema
    );
    EXECUTE format(
        'ALTER TABLE publi.%I ADD CONSTRAINT %I PRIMARY KEY (arc_id)',
        p_prefix || '_ve_arc',
        p_prefix || '_ve_arc_pkey'
    );

    -- Network: node
    EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_node');
    EXECUTE format(
        'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_node',
        p_prefix || '_ve_node',
        p_source_schema
    );
    EXECUTE format(
        'ALTER TABLE publi.%I ADD CONSTRAINT %I PRIMARY KEY (node_id)',
        p_prefix || '_ve_node',
        p_prefix || '_ve_node_pkey'
    );

    -- Network: connec
    EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_connec');
    EXECUTE format(
        'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_connec',
        p_prefix || '_ve_connec',
        p_source_schema
    );
    EXECUTE format(
        'ALTER TABLE publi.%I ADD CONSTRAINT %I PRIMARY KEY (connec_id)',
        p_prefix || '_ve_connec',
        p_prefix || '_ve_connec_pkey'
    );

    -- Network: link
    EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_link');
    EXECUTE format(
        'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_link',
        p_prefix || '_ve_link',
        p_source_schema
    );
    EXECUTE format(
        'ALTER TABLE publi.%I ADD CONSTRAINT %I PRIMARY KEY (link_id)',
        p_prefix || '_ve_link',
        p_prefix || '_ve_link_pkey'
    );

    -- Element
    IF EXISTS (
        SELECT 1
        FROM information_schema.views v
        WHERE v.table_schema = p_source_schema
          AND v.table_name = 've_element'
    ) THEN
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_element');
        EXECUTE format(
            'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_element',
            p_prefix || '_ve_element',
            p_source_schema
        );
    ELSE
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_element');
        EXECUTE format(
            'CREATE TABLE publi.%I AS SELECT * FROM %I.element',
            p_prefix || '_ve_element',
            p_source_schema
        );
    END IF;

    EXECUTE format(
        'ALTER TABLE publi.%I ADD CONSTRAINT %I PRIMARY KEY (element_id)',
        p_prefix || '_ve_element',
        p_prefix || '_ve_element_pkey'
    );

    -- Optional gully
    IF EXISTS (
        SELECT 1
        FROM information_schema.views v
        WHERE v.table_schema = p_source_schema
          AND v.table_name = 've_gully'
    ) THEN
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_gully');
        EXECUTE format(
            'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_gully',
            p_prefix || '_ve_gully',
            p_source_schema
        );
        EXECUTE format(
            'ALTER TABLE publi.%I ADD CONSTRAINT %I PRIMARY KEY (gully_id)',
            p_prefix || '_ve_gully',
            p_prefix || '_ve_gully_pkey'
        );
    ELSE
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_gully');
    END IF;

    -- WS specific
    IF p_prefix = 'ws' THEN
        IF EXISTS (
            SELECT 1
            FROM information_schema.tables t
            WHERE t.table_schema = p_source_schema
              AND t.table_name = 'presszone'
        ) THEN
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_presszone');
            EXECUTE format(
                'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_presszone',
                p_prefix || '_ve_presszone',
                p_source_schema
            );
        ELSE
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_presszone');
        END IF;

        IF EXISTS (
            SELECT 1
            FROM information_schema.tables t
            WHERE t.table_schema = p_source_schema
              AND t.table_name = 'dqa'
        ) THEN
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_dqa');
            EXECUTE format(
                'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_dqa',
                p_prefix || '_ve_dqa',
                p_source_schema
            );
        ELSE
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_dqa');
        END IF;

        IF EXISTS (
            SELECT 1
            FROM information_schema.tables t
            WHERE t.table_schema = p_source_schema
              AND t.table_name = 'supplyzone'
        ) THEN
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_supplyzone');
            EXECUTE format(
                'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_supplyzone',
                p_prefix || '_ve_supplyzone',
                p_source_schema
            );
        ELSE
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_supplyzone');
        END IF;

        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_dwfzone');
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_drainzone');
    END IF;

    -- UD specific
    IF p_prefix = 'ud' THEN
        IF EXISTS (
            SELECT 1
            FROM information_schema.tables t
            WHERE t.table_schema = p_source_schema
              AND t.table_name = 'dwfzone'
        ) THEN
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_dwfzone');
            EXECUTE format(
                'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_dwfzone',
                p_prefix || '_ve_dwfzone',
                p_source_schema
            );
        ELSE
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_dwfzone');
        END IF;

        IF EXISTS (
            SELECT 1
            FROM information_schema.tables t
            WHERE t.table_schema = p_source_schema
              AND t.table_name = 'drainzone'
        ) THEN
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_drainzone');
            EXECUTE format(
                'CREATE TABLE publi.%I AS SELECT * FROM %I.ve_drainzone',
                p_prefix || '_ve_drainzone',
                p_source_schema
            );
        ELSE
            EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_drainzone');
        END IF;

        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_presszone');
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_dqa');
        EXECUTE format('DROP TABLE IF EXISTS publi.%I CASCADE', p_prefix || '_ve_supplyzone');
    END IF;
END;
$function$
;
