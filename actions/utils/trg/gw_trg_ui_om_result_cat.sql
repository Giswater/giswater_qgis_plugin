/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_om_result_cat() RETURNS trigger AS $BODY$
DECLARE 
v_sql text;

    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    IF TG_OP = 'INSERT' THEN
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_sql:= 'DELETE FROM om_result_cat WHERE id = '||quote_literal(OLD.result_id);
        EXECUTE v_sql;
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
DROP TRIGGER IF EXISTS gw_trg_ui_om_result_cat ON "SCHEMA_NAME".v_ui_om_result_cat;
CREATE TRIGGER gw_trg_ui_om_result_cat INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_om_result_cat
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_om_result_cat();
