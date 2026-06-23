/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION publi.gw_fct_refresh_materialized_views()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    rec record;
BEGIN
    SET search_path = publi, public;

    FOR rec IN
        SELECT viewname, selector_config
        FROM publi.config_materialized_views
        WHERE active
    LOOP
        BEGIN
            -- Todo: set selectors

            EXECUTE format(
                'REFRESH MATERIALIZED VIEW publi.%I',
                rec.viewname
            );

            RAISE NOTICE 'OK: %', rec.viewname;

        EXCEPTION WHEN OTHERS THEN

            RAISE WARNING
                'ERROR refreshing %: %',
                rec.viewname,
                SQLERRM;

        END;
    END LOOP;

END;
$function$
;
