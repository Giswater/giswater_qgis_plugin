/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2500

SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE OR REPLACE FUNCTION gw_trg_edit_field_node()
  RETURNS trigger AS
$BODY$
DECLARE 
v_man_table text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_man_table:= TG_ARGV[0];

    IF TG_OP = 'UPDATE' THEN
		
		IF v_man_table ='field_valve' THEN
			UPDATE man_valve SET closed=NEW.closed, broken=NEW.broken
			WHERE node_id=OLD.node_id;
		END IF;
        		
		RETURN NEW;    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_field_valve ON "SCHEMA_NAME".v_edit_field_valve;
CREATE TRIGGER gw_trg_edit_field_valve  INSTEAD OF UPDATE  ON v_edit_field_valve  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_field_node('field_valve');
