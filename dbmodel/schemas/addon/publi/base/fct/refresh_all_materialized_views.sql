/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION publi.refresh_all_materialized_views()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    r record;
BEGIN

    FOR r IN
        SELECT mv_name
        FROM publi.vm_refresh_list
        ORDER BY id
    LOOP

        RAISE NOTICE 'Refreshing %', r.mv_name;

        EXECUTE format(
            'REFRESH MATERIALIZED VIEW publi.%I',
            r.mv_name
        );

    END LOOP;

END;
$function$
;