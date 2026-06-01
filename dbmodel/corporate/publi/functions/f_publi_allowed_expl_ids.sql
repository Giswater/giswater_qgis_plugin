/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.f_publi_allowed_expl_ids(text);

CREATE OR REPLACE FUNCTION publi.f_publi_allowed_expl_ids(p_source_schema text)
 RETURNS integer[]
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
 SET row_security TO 'off'
AS $function$
DECLARE
    v_sql text;
    v_result integer[];
BEGIN
    v_sql := format($f$
        SELECT COALESCE(
            ARRAY(
                SELECT DISTINCT u
                FROM %I.cat_manager cm,
                LATERAL unnest(cm.expl_id) AS u
                WHERE cm.active IS NOT FALSE
                  AND EXISTS (
                      SELECT 1
                      FROM unnest(cm.rolename) AS r(role_name)
                      WHERE pg_has_role(session_user, r.role_name, 'member')
                  )
            ),
            ARRAY[]::integer[]
        )
    $f$, p_source_schema);

    EXECUTE v_sql INTO v_result;
    RETURN COALESCE(v_result, ARRAY[]::integer[]);
END;
$function$
;
