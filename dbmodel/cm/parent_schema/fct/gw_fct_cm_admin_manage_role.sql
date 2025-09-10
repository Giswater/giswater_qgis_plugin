/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3502

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_admin_manage_role(p_data json DEFAULT '{}'::json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT cm.gw_fct_cm_admin_manage_role($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {}}}$$);

*/

DECLARE
    -- system variables
    v_project_type text;
    v_version text;
    v_epsg integer;
    v_schemaname text;
    v_prev_search_path text;

    -- variables
    v_querytext text;
    v_user_count integer := 0;
    v_return json;

BEGIN

    -- Save current search_path and switch to cm (transaction-local)
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'pg_temp,cm,public', true);
    v_schemaname := 'cm';

    SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;

    -- SECTION[epic=sync_users]: Sync users with role_cm to cat_user table
    -- Find all users that have role_cm but are not in cat_user table
    v_querytext := '
        INSERT INTO cm.cat_user (username, team_id, roles)
        SELECT DISTINCT r.rolname AS username,
               NULL::integer AS team_id,
               COALESCE(
                   (
                       SELECT array_agg(rc.rolname ORDER BY rc.rolname)
                       FROM pg_auth_members am2
                       JOIN pg_roles rc ON am2.roleid = rc.oid
                       WHERE am2.member = r.oid
                   ),
                   ARRAY[]::text[]
               ) AS roles
        FROM pg_roles r
        JOIN pg_auth_members am ON r.oid = am.member
        JOIN pg_roles role_cm ON am.roleid = role_cm.oid
        WHERE role_cm.rolname ILIKE ''%role_cm%''
          AND r.rolcanlogin = TRUE
          AND r.rolname NOT IN (SELECT username FROM cm.cat_user)
        ON CONFLICT (username) DO NOTHING
    ';

    EXECUTE v_querytext;
    GET DIAGNOSTICS v_user_count = ROW_COUNT;

    -- ENDSECTION

    -- SECTION[epic=set_edit_param]: Set edit_disable_topocontrol for users with role_edit
    v_querytext := '
        INSERT INTO cm.config_param_user (parameter, value, cur_user)
        SELECT ''edit_disable_topocontrol'', ''true'', r.rolname
        FROM pg_roles r
        JOIN pg_auth_members am ON r.oid = am.member
        JOIN pg_roles role_edit ON am.roleid = role_edit.oid
        WHERE role_edit.rolname ILIKE ''%role_edit%''
          AND r.rolcanlogin = TRUE
        ON CONFLICT (parameter, cur_user) DO UPDATE
        SET value = ''true''
    ';

    EXECUTE v_querytext;
    -- ENDSECTION

    -- SECTION[epic=return]: Build return
    -- Control null
    v_version:=COALESCE(v_version,'');
    v_epsg:=COALESCE(v_epsg,0);

    --return definition
    v_return= ('{"status":"Accepted", "message":{"level":1, "text":"User sync completed successfully"}, "version":"'||v_version||'" '||
        ',"body":{"form":{}'||
            ',"data":{ "epsg":'||v_epsg||
                ',"userCount":'||v_user_count||
            '}'||
        '}}')::json;
    --  Return
    -- Restore previous search_path before returning
    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN v_return;

EXCEPTION WHEN OTHERS THEN
    -- Ensure restoration on error
    PERFORM set_config('search_path', v_prev_search_path, true);
    RAISE;
END;
$function$
; 