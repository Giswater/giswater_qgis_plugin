/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.f_publi_macroexpl_visible(text, int4);

CREATE OR REPLACE FUNCTION publi.f_publi_macroexpl_visible(p_source_schema text, p_macroexpl_id integer)
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
 SET row_security TO 'off'
AS $function$
DECLARE
    v_sql text;
    v_result boolean;
BEGIN
    v_sql := format($f$
        SELECT EXISTS (
            SELECT 1
            FROM %I.exploitation e
            WHERE e.macroexpl_id = %L
              AND e.active IS NOT FALSE
              AND publi.f_publi_allowed_expl_ids(%L) && publi.f_publi_expl_ids_as_array(e.expl_id)
        )
    $f$, p_source_schema, p_macroexpl_id, p_source_schema);

    EXECUTE v_sql INTO v_result;
    RETURN COALESCE(v_result, false);
END;
$function$
;
