/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2634

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_refresh_mat_view()
RETURNS integer SECURITY DEFINER AS 
$BODY$

/*EXAMPLE
select SCHEMA_NAME.gw_fct_refresh_mat_view()
*/

DECLARE
	v_viewname text;
	v_schemaname text;

BEGIN
	--  Search path
    SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

    -- Rename process
	FOR v_viewname IN SELECT matviewname from pg_matviews where schemaname = v_schemaname
	LOOP
		EXECUTE 'REFRESH MATERIALIZED VIEW '||v_viewname;
	END LOOP;
	
	RETURN 1;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
