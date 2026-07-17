/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.f_apply_rls(text, text);

CREATE OR REPLACE FUNCTION publi.f_apply_rls(p_source_schema text, p_prefix text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    t text;
    v_table text;
    expr_vis text := format(
        'publi.f_publi_rls_bypass() OR publi.f_publi_match_feature_expl(%L, expl_id, expl_visibility)',
        p_source_schema
    );
    expr_expl text := format(
        'publi.f_publi_rls_bypass() OR publi.f_publi_match_feature_expl(%L, expl_id, NULL)',
        p_source_schema
    );
    expr_mex text := format(
        'publi.f_publi_rls_bypass() OR publi.f_publi_macroexpl_visible(%L, macroexpl_id)',
        p_source_schema
    );
    expr_ms text := format(
        'publi.f_publi_rls_bypass() OR publi.f_publi_macrosector_visible(%L, macrosector_id)',
        p_source_schema
    );
BEGIN
    IF p_prefix NOT IN ('ws', 'ud') THEN
        RAISE EXCEPTION 'Invalid prefix: %, expected ws or ud', p_prefix;
    END IF;

    -- Network
    FOREACH t IN ARRAY ARRAY['ve_arc', 've_node', 've_connec', 've_link']
    LOOP
        v_table := p_prefix || '_' || t;
        EXECUTE format('ALTER TABLE publi.%I ENABLE ROW LEVEL SECURITY', v_table);
        EXECUTE format('ALTER TABLE publi.%I FORCE ROW LEVEL SECURITY', v_table);
        EXECUTE format('DROP POLICY IF EXISTS publi_sel ON publi.%I', v_table);
        EXECUTE format(
            'CREATE POLICY publi_sel ON publi.%I FOR SELECT USING (%s)',
            v_table,
            expr_vis
        );
    END LOOP;

    -- Gully
    v_table := p_prefix || '_ve_gully';
    IF to_regclass('publi.' || v_table) IS NOT NULL THEN
        EXECUTE format('ALTER TABLE publi.%I ENABLE ROW LEVEL SECURITY', v_table);
        EXECUTE format('ALTER TABLE publi.%I FORCE ROW LEVEL SECURITY', v_table);
        EXECUTE format('DROP POLICY IF EXISTS publi_sel ON publi.%I', v_table);
        EXECUTE format(
            'CREATE POLICY publi_sel ON publi.%I FOR SELECT USING (%s)',
            v_table,
            expr_vis
        );
    END IF;

    -- Element
    v_table := p_prefix || '_ve_element';
    EXECUTE format('ALTER TABLE publi.%I ENABLE ROW LEVEL SECURITY', v_table);
    EXECUTE format('ALTER TABLE publi.%I FORCE ROW LEVEL SECURITY', v_table);
    EXECUTE format('DROP POLICY IF EXISTS publi_sel ON publi.%I', v_table);
    EXECUTE format(
        'CREATE POLICY publi_sel ON publi.%I FOR SELECT USING (%s)',
        v_table,
        expr_expl
    );

    -- Direct expl tables
    FOREACH t IN ARRAY ARRAY['ve_exploitation', 've_municipality', 've_sector', 've_dma']
    LOOP
        v_table := p_prefix || '_' || t;
        EXECUTE format('ALTER TABLE publi.%I ENABLE ROW LEVEL SECURITY', v_table);
        EXECUTE format('ALTER TABLE publi.%I FORCE ROW LEVEL SECURITY', v_table);
        EXECUTE format('DROP POLICY IF EXISTS publi_sel ON publi.%I', v_table);
        EXECUTE format(
            'CREATE POLICY publi_sel ON publi.%I FOR SELECT USING (%s)',
            v_table,
            expr_expl
        );
    END LOOP;

    -- Macro tables (only if loader created them)
    v_table := p_prefix || '_ve_macroexploitation';
    IF to_regclass('publi.' || v_table) IS NOT NULL THEN
        EXECUTE format('ALTER TABLE publi.%I ENABLE ROW LEVEL SECURITY', v_table);
        EXECUTE format('ALTER TABLE publi.%I FORCE ROW LEVEL SECURITY', v_table);
        EXECUTE format('DROP POLICY IF EXISTS publi_sel ON publi.%I', v_table);
        EXECUTE format(
            'CREATE POLICY publi_sel ON publi.%I FOR SELECT USING (%s)',
            v_table,
            expr_mex
        );
    END IF;

    v_table := p_prefix || '_ve_macrosector';
    IF to_regclass('publi.' || v_table) IS NOT NULL THEN
        EXECUTE format('ALTER TABLE publi.%I ENABLE ROW LEVEL SECURITY', v_table);
        EXECUTE format('ALTER TABLE publi.%I FORCE ROW LEVEL SECURITY', v_table);
        EXECUTE format('DROP POLICY IF EXISTS publi_sel ON publi.%I', v_table);
        EXECUTE format(
            'CREATE POLICY publi_sel ON publi.%I FOR SELECT USING (%s)',
            v_table,
            expr_ms
        );
    END IF;

    -- Optional zone tables
    FOREACH t IN ARRAY ARRAY['ve_presszone', 've_dqa', 've_supplyzone', 've_dwfzone', 've_drainzone']
    LOOP
        v_table := p_prefix || '_' || t;
        IF to_regclass('publi.' || v_table) IS NOT NULL THEN
            EXECUTE format('ALTER TABLE publi.%I ENABLE ROW LEVEL SECURITY', v_table);
            EXECUTE format('ALTER TABLE publi.%I FORCE ROW LEVEL SECURITY', v_table);
            EXECUTE format('DROP POLICY IF EXISTS publi_sel ON publi.%I', v_table);
            EXECUTE format(
                'CREATE POLICY publi_sel ON publi.%I FOR SELECT USING (%s)',
                v_table,
                expr_expl
            );
        END IF;
    END LOOP;

    -- Read-only hardening
    REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
        ON ALL TABLES IN SCHEMA publi FROM PUBLIC;

	GRANT USAGE ON SCHEMA publi TO PUBLIC;
	GRANT SELECT ON ALL TABLES IN SCHEMA publi TO PUBLIC;

END;
$function$
;
