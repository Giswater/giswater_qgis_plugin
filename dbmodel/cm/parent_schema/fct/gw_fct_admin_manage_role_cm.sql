/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3502

CREATE OR REPLACE FUNCTION cm.gw_fct_admin_manage_role_cm(p_data json DEFAULT '{}'::json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT cm.gw_fct_admin_manage_role_cm($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {}}}$$);

*/

DECLARE
    -- system variables
    v_project_type text;
    v_version text;
    v_epsg integer;
    v_schemaname text;

    -- variables
    v_querytext text;
    v_user_count integer := 0;
    v_return json;

BEGIN

    SET search_path = 'pg_temp', 'cm', 'public';
    v_schemaname := 'cm';

    SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;

    -- SECTION[epic=sync_users]: Sync users with role_cm to cat_user table
    -- Find all users that have role_cm but are not in cat_user table
    v_querytext := '
        INSERT INTO cm.cat_user (loginname, username, team_id)
        SELECT DISTINCT r.rolname, r.rolname, NULL::integer
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
    RETURN v_return;

END;
$function$
; 