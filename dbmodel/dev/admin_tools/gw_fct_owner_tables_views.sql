/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION gw_fct_admin_owner_tables_views(user_name character varying, schema_name character varying)
  RETURNS boolean AS
$BODY$
DECLARE
    registro  record;
 
BEGIN
    
  FOR registro IN SELECT * FROM pg_tables WHERE schemaname = schema_name LOOP
          EXECUTE 'ALTER TABLE ' ||quote_ident(schema_name)||'.'||quote_ident(registro.tablename) || ' OWNER TO ' || quote_ident(user_name);
  END LOOP;
  FOR registro IN SELECT * FROM pg_views WHERE schemaname = schema_name LOOP
          EXECUTE 'ALTER TABLE ' ||quote_ident(schema_name)||'.'||quote_ident(registro.viewname) || ' OWNER TO ' || quote_ident(user_name);       
  END LOOP;
  RETURN TRUE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;