/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: xxxx

CREATE OR REPLACE FUNCTION cm.apply_cm_audit_rls(
  role_org_map jsonb  -- e.g. '[{"role":"role_acciona","org":3},{"role":"role_miya","org":2}]'
) RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = cm, public
AS $$
DECLARE
  r jsonb;
  role_name text;
  org_id integer;
  role_csv text;
  v_error_context text;
  predicate_log text;
  predicate_err text;
  v_prev_search_path text;
BEGIN
  -- Save current search_path and switch to cm (transaction-local)
  v_prev_search_path := current_setting('search_path');
  PERFORM set_config('search_path', 'cm,public', true);
  -- Ensure schema exists (idempotent)
  PERFORM 1 FROM pg_namespace WHERE nspname = 'cm_audit';
  IF NOT FOUND THEN
    EXECUTE 'CREATE SCHEMA cm_audit';
  END IF;

  -- Tighten schema privileges and grant usage to mapped roles
  EXECUTE 'REVOKE ALL ON SCHEMA cm_audit FROM PUBLIC';
  SELECT string_agg(quote_ident((e->>'role')), ', ')
    INTO role_csv
    FROM jsonb_array_elements(role_org_map) e;
  IF role_csv IS NOT NULL THEN
    EXECUTE format('GRANT USAGE ON SCHEMA cm_audit TO %s', role_csv);
  END IF;

  -- Base audit tables must exist; enable/force RLS and restrict SELECT
  EXECUTE 'ALTER TABLE cm_audit.log ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm_audit.log FORCE  ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm_audit.error_log ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE cm_audit.error_log FORCE  ROW LEVEL SECURITY';

  EXECUTE 'REVOKE ALL ON cm_audit.log FROM PUBLIC';
  EXECUTE 'REVOKE ALL ON cm_audit.error_log FROM PUBLIC';

  -- Admins can read everything from base audit tables
  EXECUTE 'DROP POLICY IF EXISTS audit_admin_sel_log ON cm_audit.log';
  EXECUTE 'DROP POLICY IF EXISTS audit_admin_sel_err ON cm_audit.error_log';
  EXECUTE 'CREATE POLICY audit_admin_sel_log ON cm_audit.log FOR SELECT TO role_cm_admin USING (true)';
  EXECUTE 'CREATE POLICY audit_admin_sel_err ON cm_audit.error_log FOR SELECT TO role_cm_admin USING (true)';

  -- Grant SELECT on base log table to mapped roles; RLS will limit rows by org
  FOR r IN SELECT * FROM jsonb_array_elements(role_org_map) LOOP
    role_name := r->>'role';
    EXECUTE format('GRANT SELECT ON cm_audit.log TO %I', role_name);
  END LOOP;

  -- Allow INSERTs for mapped roles
  FOR r IN SELECT * FROM jsonb_array_elements(role_org_map) LOOP
    role_name := r->>'role';
    EXECUTE format('GRANT INSERT ON cm_audit.log TO %I', role_name);

    EXECUTE format('DROP POLICY IF EXISTS log_ins_%I ON cm_audit.log', role_name);
    EXECUTE format($p$ CREATE POLICY log_ins_%1$I ON cm_audit.log
                     FOR INSERT TO %1$I
                     WITH CHECK (true) $p$, role_name);
  END LOOP;

  -- RLS: restrict SELECT on cm_audit.log to caller's organization (derived from usernames)
  EXECUTE 'DROP POLICY IF EXISTS log_sel_by_org ON cm_audit.log';
  EXECUTE $sql$ CREATE POLICY log_sel_by_org ON cm_audit.log
    FOR SELECT USING (
      (SELECT t.organization_id
         FROM cm.cat_user u
         JOIN cm.cat_team t ON t.team_id = u.team_id
        WHERE u.username = current_user
        LIMIT 1)
      =
      (SELECT t.organization_id
         FROM cm.cat_user u2
         JOIN cm.cat_team t ON t.team_id = u2.team_id
        WHERE u2.username = cm_audit.log.insert_by
        LIMIT 1)
    ) $sql$;

  -- Restore previous search_path before returning
  PERFORM set_config('search_path', v_prev_search_path, true);
  RETURN json_build_object('status','ok');
EXCEPTION WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
  -- Ensure restoration on error
  PERFORM set_config('search_path', v_prev_search_path, true);
  RETURN json_build_object('status','error','sqlstate',SQLSTATE,'message',SQLERRM,'context',v_error_context);
END;
$$;
