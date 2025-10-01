/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: xxxx

CREATE OR REPLACE FUNCTION cm.apply_cm_rls(
  role_org_map jsonb,                 -- e.g. '[{"role":"role_acciona","org":3},{"role":"role_miya","org":2},{"role":"role_general","org":null}]'
  p_features text[] DEFAULT ARRAY['arc','node','connec','link']
) RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = cm, public
AS $$
/*
EXAMPLE
SELECT cm.apply_cm_rls(
  '[{"role":"role_acciona","org":3},{"role":"role_miya","org":2},{"role":"role_general","org":null}]'::jsonb,
  ARRAY['arc','node','connec','link']
);

*/
DECLARE
  r jsonb;
  case_sql text := '';
  ft text;
  role_csv text;
  tbls text := '';
  v_return json := '{}'::json;
  v_error_context text;
  v_prev_search_path text;
BEGIN
  -- Save current search_path and switch to cm (transaction-local)
  v_prev_search_path := current_setting('search_path');
  PERFORM set_config('search_path', 'cm,public', true);
  -- parent schema is injected at build time via token PARENT_SCHEMA
  -- Build resolver cm.current_org_id()
  FOR r IN SELECT * FROM jsonb_array_elements(role_org_map) LOOP
    case_sql := case_sql ||
      format(' WHEN pg_has_role(current_user,%L,''member'') THEN %s',
             r->>'role', COALESCE((r->>'org')::text, 'NULL'));
  END LOOP;

  EXECUTE format($f$
    CREATE OR REPLACE FUNCTION cm.current_org_id()
    RETURNS integer
    LANGUAGE plpgsql STABLE AS
    $b$ BEGIN RETURN CASE%s ELSE NULL END; END; $b$;
  $f$, case_sql);

  -- Helper to resolve the caller's team without self-referencing the cm.cat_user RLS policy
  EXECUTE $f$
    CREATE OR REPLACE FUNCTION cm.current_team_id()
    RETURNS integer
    LANGUAGE plpgsql
    STABLE
    SECURITY DEFINER
    SET search_path = cm, public
    AS $b$
    DECLARE
      v_team_id integer;
    BEGIN
      SELECT u.team_id
      INTO v_team_id
      FROM cm.cat_user u
      WHERE u.username = current_user OR u.username = current_user
      LIMIT 1;
      RETURN v_team_id;
    END;
    $b$;
  $f$;

  -- Helper to resolve any user's organization (bypasses RLS for audit purposes)
  EXECUTE $f$
    CREATE OR REPLACE FUNCTION cm.user_org_id(p_username text)
    RETURNS integer
    LANGUAGE plpgsql
    STABLE
    SECURITY DEFINER
    SET search_path = cm, public
    AS $b$
    DECLARE
      v_org_id integer;
    BEGIN
      SELECT t.organization_id
      INTO v_org_id
      FROM cm.cat_user u
      JOIN cm.cat_team t ON t.team_id = u.team_id
      WHERE u.username = p_username
      LIMIT 1;
      RETURN v_org_id;
    END;
    $b$;
  $f$;

  -- Helpful indexes
  EXECUTE 'CREATE INDEX IF NOT EXISTS om_campaign_org_idx            ON cm.om_campaign (organization_id)';
  EXECUTE 'CREATE INDEX IF NOT EXISTS om_campaign_lot_campaign_idx   ON cm.om_campaign_lot (campaign_id)';
  EXECUTE 'CREATE INDEX IF NOT EXISTS selector_campaign_cur_user_idx ON cm.selector_campaign (cur_user)';
  EXECUTE 'CREATE INDEX IF NOT EXISTS selector_lot_cur_user_idx      ON cm.selector_lot (cur_user)';
  EXECUTE 'CREATE INDEX IF NOT EXISTS cat_team_org_idx               ON cm.cat_team (organization_id)';
  EXECUTE 'CREATE INDEX IF NOT EXISTS cat_user_team_idx              ON cm.cat_user (team_id)';

  -- Enable/force RLS on parents
  EXECUTE 'ALTER TABLE cm.om_campaign     ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.om_campaign     FORCE  ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.om_campaign_lot ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.om_campaign_lot FORCE  ROW LEVEL SECURITY';

  -- Enable/force RLS on selectors and catalogs
  EXECUTE 'ALTER TABLE cm.selector_campaign ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.selector_campaign FORCE  ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.selector_lot      ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.selector_lot      FORCE  ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.cat_team          ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.cat_team          FORCE  ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.cat_user          ENABLE ROW LEVEL SECURITY';
  -- Do not FORCE RLS on cm.cat_user to avoid recursion during team resolution
  EXECUTE 'ALTER TABLE cm.cat_organization  ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm.cat_organization  FORCE  ROW LEVEL SECURITY';
  -- Exclude cm.cat_role from RLS

  -- Parent policies (compact)
  EXECUTE 'DROP POLICY IF EXISTS c_all_sel ON cm.om_campaign';
  EXECUTE 'DROP POLICY IF EXISTS c_all_ins ON cm.om_campaign';
  EXECUTE 'DROP POLICY IF EXISTS c_all_upd ON cm.om_campaign';
  EXECUTE 'DROP POLICY IF EXISTS c_all_del ON cm.om_campaign';

  EXECUTE $sql$ CREATE POLICY c_all_sel ON cm.om_campaign
    FOR SELECT USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY c_all_ins ON cm.om_campaign
    FOR INSERT WITH CHECK (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY c_all_upd ON cm.om_campaign
    FOR UPDATE USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id())
             WITH CHECK (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY c_all_del ON cm.om_campaign
    FOR DELETE USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;

  -- selector_campaign policies (per-user visibility)
  EXECUTE 'DROP POLICY IF EXISTS sc_sel ON cm.selector_campaign';
  EXECUTE 'DROP POLICY IF EXISTS sc_ins ON cm.selector_campaign';
  EXECUTE 'DROP POLICY IF EXISTS sc_upd ON cm.selector_campaign';
  EXECUTE 'DROP POLICY IF EXISTS sc_del ON cm.selector_campaign';
  EXECUTE $sql$ CREATE POLICY sc_sel ON cm.selector_campaign
    FOR SELECT USING (cur_user = current_user OR cm.current_org_id() IS NULL); $sql$;
  EXECUTE $sql$ CREATE POLICY sc_ins ON cm.selector_campaign
    FOR INSERT WITH CHECK (cur_user = current_user OR cm.current_org_id() IS NULL); $sql$;
  EXECUTE $sql$ CREATE POLICY sc_upd ON cm.selector_campaign
    FOR UPDATE USING (cur_user = current_user OR cm.current_org_id() IS NULL)
             WITH CHECK (cur_user = current_user OR cm.current_org_id() IS NULL); $sql$;
  EXECUTE $sql$ CREATE POLICY sc_del ON cm.selector_campaign
    FOR DELETE USING (cur_user = current_user OR cm.current_org_id() IS NULL); $sql$;

  -- selector_lot policies (per-user visibility)
  EXECUTE 'DROP POLICY IF EXISTS sl_sel ON cm.selector_lot';
  EXECUTE 'DROP POLICY IF EXISTS sl_ins ON cm.selector_lot';
  EXECUTE 'DROP POLICY IF EXISTS sl_upd ON cm.selector_lot';
  EXECUTE 'DROP POLICY IF EXISTS sl_del ON cm.selector_lot';
  EXECUTE $sql$ CREATE POLICY sl_sel ON cm.selector_lot
    FOR SELECT USING (cur_user = current_user OR cm.current_org_id() IS NULL); $sql$;
  EXECUTE $sql$ CREATE POLICY sl_ins ON cm.selector_lot
    FOR INSERT WITH CHECK (cur_user = current_user OR cm.current_org_id() IS NULL); $sql$;
  EXECUTE $sql$ CREATE POLICY sl_upd ON cm.selector_lot
    FOR UPDATE USING (cur_user = current_user OR cm.current_org_id() IS NULL)
             WITH CHECK (cur_user = current_user OR cm.current_org_id() IS NULL); $sql$;
  EXECUTE $sql$ CREATE POLICY sl_del ON cm.selector_lot
    FOR DELETE USING (cur_user = current_user OR cm.current_org_id() IS NULL); $sql$;

  -- cat_team policies (by organization): only teams in caller's org
  EXECUTE 'DROP POLICY IF EXISTS ct_sel ON cm.cat_team';
  EXECUTE 'DROP POLICY IF EXISTS ct_ins ON cm.cat_team';
  EXECUTE 'DROP POLICY IF EXISTS ct_upd ON cm.cat_team';
  EXECUTE 'DROP POLICY IF EXISTS ct_del ON cm.cat_team';
  EXECUTE $sql$ CREATE POLICY ct_sel ON cm.cat_team
    FOR SELECT USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY ct_ins ON cm.cat_team
    FOR INSERT WITH CHECK (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY ct_upd ON cm.cat_team
    FOR UPDATE USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id())
             WITH CHECK (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY ct_del ON cm.cat_team
    FOR DELETE USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;

  -- cat_user policies (only users in caller's SAME organization)
  EXECUTE 'DROP POLICY IF EXISTS cu_sel ON cm.cat_user';
  EXECUTE 'DROP POLICY IF EXISTS cu_ins ON cm.cat_user';
  EXECUTE 'DROP POLICY IF EXISTS cu_upd ON cm.cat_user';
  EXECUTE 'DROP POLICY IF EXISTS cu_del ON cm.cat_user';
  -- Use helper function to avoid self-reference and recursion
  EXECUTE $sql$ CREATE POLICY cu_sel ON cm.cat_user
    FOR SELECT USING (cm.current_org_id() IS NULL OR EXISTS (
      SELECT 1 FROM cm.cat_team t
      WHERE t.team_id = cm.cat_user.team_id
        AND t.organization_id = cm.current_org_id())); $sql$;
  EXECUTE $sql$ CREATE POLICY cu_ins ON cm.cat_user
    FOR INSERT WITH CHECK (cm.current_org_id() IS NULL OR team_id = cm.current_team_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY cu_upd ON cm.cat_user
    FOR UPDATE USING (cm.current_org_id() IS NULL OR team_id = cm.current_team_id())
             WITH CHECK (cm.current_org_id() IS NULL OR team_id = cm.current_team_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY cu_del ON cm.cat_user
    FOR DELETE USING (cm.current_org_id() IS NULL OR team_id = cm.current_team_id()); $sql$;

  -- cat_organization policies (only the caller's organization)
  EXECUTE 'DROP POLICY IF EXISTS co_sel ON cm.cat_organization';
  EXECUTE 'DROP POLICY IF EXISTS co_ins ON cm.cat_organization';
  EXECUTE 'DROP POLICY IF EXISTS co_upd ON cm.cat_organization';
  EXECUTE 'DROP POLICY IF EXISTS co_del ON cm.cat_organization';
  EXECUTE $sql$ CREATE POLICY co_sel ON cm.cat_organization
    FOR SELECT USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY co_ins ON cm.cat_organization
    FOR INSERT WITH CHECK (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY co_upd ON cm.cat_organization
    FOR UPDATE USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id())
             WITH CHECK (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;
  EXECUTE $sql$ CREATE POLICY co_del ON cm.cat_organization
    FOR DELETE USING (cm.current_org_id() IS NULL OR organization_id = cm.current_org_id()); $sql$;

  -- No RLS policies for cm.cat_role (excluded)

  EXECUTE 'DROP POLICY IF EXISTS cl_all_sel ON cm.om_campaign_lot';
  EXECUTE 'DROP POLICY IF EXISTS cl_all_ins ON cm.om_campaign_lot';
  EXECUTE 'DROP POLICY IF EXISTS cl_all_upd ON cm.om_campaign_lot';
  EXECUTE 'DROP POLICY IF EXISTS cl_all_del ON cm.om_campaign_lot';

  EXECUTE $sql$ CREATE POLICY cl_all_sel ON cm.om_campaign_lot
    FOR SELECT USING (cm.current_org_id() IS NULL OR EXISTS (
      SELECT 1 FROM cm.om_campaign c
      WHERE c.campaign_id = cm.om_campaign_lot.campaign_id
        AND c.organization_id = cm.current_org_id())); $sql$;

  EXECUTE $sql$ CREATE POLICY cl_all_ins ON cm.om_campaign_lot
    FOR INSERT WITH CHECK (cm.current_org_id() IS NULL OR EXISTS (
      SELECT 1 FROM cm.om_campaign c
      WHERE c.campaign_id = cm.om_campaign_lot.campaign_id
        AND c.organization_id = cm.current_org_id())); $sql$;

  EXECUTE $sql$ CREATE POLICY cl_all_upd ON cm.om_campaign_lot
    FOR UPDATE USING (cm.current_org_id() IS NULL OR EXISTS (
      SELECT 1 FROM cm.om_campaign c
      WHERE c.campaign_id = cm.om_campaign_lot.campaign_id
        AND c.organization_id = cm.current_org_id()))
    WITH CHECK (cm.current_org_id() IS NULL OR EXISTS (
      SELECT 1 FROM cm.om_campaign c
      WHERE c.campaign_id = cm.om_campaign_lot.campaign_id
        AND c.organization_id = cm.current_org_id())); $sql$;

  EXECUTE $sql$ CREATE POLICY cl_all_del ON cm.om_campaign_lot
    FOR DELETE USING (cm.current_org_id() IS NULL OR EXISTS (
      SELECT 1 FROM cm.om_campaign c
      WHERE c.campaign_id = cm.om_campaign_lot.campaign_id
        AND c.organization_id = cm.current_org_id())); $sql$;

  -- Children: campaign_x_* and campaign_lot_x_*
  FOREACH ft IN ARRAY p_features LOOP
    EXECUTE format('ALTER TABLE cm.om_campaign_x_%I ENABLE ROW LEVEL SECURITY', ft);
    EXECUTE format('ALTER TABLE cm.om_campaign_x_%I FORCE  ROW LEVEL SECURITY', ft);
    EXECUTE format('ALTER TABLE cm.om_campaign_lot_x_%I ENABLE ROW LEVEL SECURITY', ft);
    EXECUTE format('ALTER TABLE cm.om_campaign_lot_x_%I FORCE  ROW LEVEL SECURITY', ft);

    EXECUTE format('DROP POLICY IF EXISTS x_%1$s_sel ON cm.om_campaign_x_%1$s', ft);
    EXECUTE format('DROP POLICY IF EXISTS x_%1$s_ins ON cm.om_campaign_x_%1$s', ft);
    EXECUTE format('DROP POLICY IF EXISTS x_%1$s_upd ON cm.om_campaign_x_%1$s', ft);
    EXECUTE format('DROP POLICY IF EXISTS x_%1$s_del ON cm.om_campaign_x_%1$s', ft);
    EXECUTE format('DROP POLICY IF EXISTS lx_%1$s_sel ON cm.om_campaign_lot_x_%1$s', ft);
    EXECUTE format('DROP POLICY IF EXISTS lx_%1$s_ins ON cm.om_campaign_lot_x_%1$s', ft);
    EXECUTE format('DROP POLICY IF EXISTS lx_%1$s_upd ON cm.om_campaign_lot_x_%1$s', ft);
    EXECUTE format('DROP POLICY IF EXISTS lx_%1$s_del ON cm.om_campaign_lot_x_%1$s', ft);

    EXECUTE format($p$ CREATE POLICY x_%1$s_sel ON cm.om_campaign_x_%1$s
      FOR SELECT USING (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign c
        WHERE c.campaign_id = cm.om_campaign_x_%1$s.campaign_id
          AND c.organization_id = cm.current_org_id())); $p$, ft);

    EXECUTE format($p$ CREATE POLICY x_%1$s_ins ON cm.om_campaign_x_%1$s
      FOR INSERT WITH CHECK (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign c
        WHERE c.campaign_id = cm.om_campaign_x_%1$s.campaign_id
          AND c.organization_id = cm.current_org_id())); $p$, ft);

    EXECUTE format($p$ CREATE POLICY x_%1$s_upd ON cm.om_campaign_x_%1$s
      FOR UPDATE USING (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign c
        WHERE c.campaign_id = cm.om_campaign_x_%1$s.campaign_id
          AND c.organization_id = cm.current_org_id()))
      WITH CHECK (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign c
        WHERE c.campaign_id = cm.om_campaign_x_%1$s.campaign_id
          AND c.organization_id = cm.current_org_id())); $p$, ft);

    EXECUTE format($p$ CREATE POLICY x_%1$s_del ON cm.om_campaign_x_%1$s
      FOR DELETE USING (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign c
        WHERE c.campaign_id = cm.om_campaign_x_%1$s.campaign_id
          AND c.organization_id = cm.current_org_id())); $p$, ft);

    EXECUTE format($p$ CREATE POLICY lx_%1$s_sel ON cm.om_campaign_lot_x_%1$s
      FOR SELECT USING (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign_lot l
        JOIN cm.om_campaign c ON c.campaign_id = l.campaign_id
        WHERE l.lot_id = cm.om_campaign_lot_x_%1$s.lot_id
          AND c.organization_id = cm.current_org_id())); $p$, ft);

    EXECUTE format($p$ CREATE POLICY lx_%1$s_ins ON cm.om_campaign_lot_x_%1$s
      FOR INSERT WITH CHECK (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign_lot l
        JOIN cm.om_campaign c ON c.campaign_id = l.campaign_id
        WHERE l.lot_id = cm.om_campaign_lot_x_%1$s.lot_id
          AND c.organization_id = cm.current_org_id())); $p$, ft);

    EXECUTE format($p$ CREATE POLICY lx_%1$s_upd ON cm.om_campaign_lot_x_%1$s
      FOR UPDATE USING (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign_lot l
        JOIN cm.om_campaign c ON c.campaign_id = l.campaign_id
        WHERE l.lot_id = cm.om_campaign_lot_x_%1$s.lot_id
          AND c.organization_id = cm.current_org_id()))
      WITH CHECK (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign_lot l
        JOIN cm.om_campaign c ON c.campaign_id = l.campaign_id
        WHERE l.lot_id = cm.om_campaign_lot_x_%1$s.lot_id
          AND c.organization_id = cm.current_org_id())); $p$, ft);

    EXECUTE format($p$ CREATE POLICY lx_%1$s_del ON cm.om_campaign_lot_x_%1$s
      FOR DELETE USING (cm.current_org_id() IS NULL OR EXISTS (
        SELECT 1 FROM cm.om_campaign_lot l
        JOIN cm.om_campaign c ON c.campaign_id = l.campaign_id
        WHERE l.lot_id = cm.om_campaign_lot_x_%1$s.lot_id
          AND c.organization_id = cm.current_org_id())); $p$, ft);

    -- Helpful indexes
    EXECUTE format('CREATE INDEX IF NOT EXISTS om_campaign_x_%1$s_campaign_idx ON cm.om_campaign_x_%1$s (campaign_id)', ft);
    EXECUTE format('CREATE INDEX IF NOT EXISTS om_campaign_lot_x_%1$s_lot_idx  ON cm.om_campaign_lot_x_%1$s (lot_id)', ft);

    -- Collect tables for GRANT list
    tbls := tbls || format(', cm.om_campaign_x_%1$s, cm.om_campaign_lot_x_%1$s', ft);
  END LOOP;

  -- Build role CSV for GRANTs
  SELECT string_agg(quote_ident((e->>'role')), ', ')
  INTO role_csv
  FROM jsonb_array_elements(role_org_map) e;

  -- GRANTs (cm schema, sequences)
  EXECUTE format('GRANT USAGE ON SCHEMA cm TO %s', role_csv);
  EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA cm TO %s', role_csv);

  -- Specific cm tables: campaign, lot, selectors, catalogs (exclude cat_role), x_*, lot_x_*
  tbls := 'cm.om_campaign, cm.om_campaign_lot, cm.selector_campaign, cm.selector_lot, cm.cat_team, cm.cat_user, cm.cat_organization' || tbls;
  EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON %s TO %s', tbls, role_csv);

  -- Configure audit schema visibility (INSERT allowed to all mapped roles, SELECT restricted via per-role MVs)
  PERFORM cm.apply_cm_audit_rls(role_org_map);

  v_return := json_build_object('status','ok','roles',role_org_map,'features',p_features);
  -- Restore previous search_path before returning
  PERFORM set_config('search_path', v_prev_search_path, true);
  RETURN v_return;

EXCEPTION WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
  -- Ensure restoration on error
  PERFORM set_config('search_path', v_prev_search_path, true);
  RETURN json_build_object('status','error','sqlstate',SQLSTATE,'message',SQLERRM,'context',v_error_context);
END;
$$;
