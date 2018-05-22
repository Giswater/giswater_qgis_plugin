/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: XXXX



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_update_link_arc_id() RETURNS trigger AS $BODY$
DECLARE 

	exit_type_var text;
	v_link record;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    exit_type_var:= TG_ARGV[0];

	
	IF exit_type_var='connec' THEN
	FOR v_link IN SELECT * FROM link WHERE (exit_type='CONNEC' AND exit_id=OLD.connec_id)
		LOOP
			IF v_link.feature_type='CONNEC' THEN
			
				UPDATE v_edit_connec SET arc_id=NEW.arc_id WHERE connec_id=v_link.feature_id;
			ELSE 
		
				UPDATE v_edit_gully SET arc_id=NEW.arc_id WHERE gully_id=v_link.feature_id;
			END IF;
		END LOOP;
	
	ELSIF exit_type_var='gully' THEN
	FOR v_link IN SELECT * FROM link WHERE (exit_type='GULLY' AND exit_id=OLD.gully_id)
		LOOP
			IF v_link.feature_type='CONNEC' THEN
			
				UPDATE v_edit_connec SET arc_id=NEW.arc_id WHERE connec_id=v_link.feature_id;
			ELSE 
		
				UPDATE v_edit_gully SET arc_id=NEW.arc_id WHERE gully_id=v_link.feature_id;
			END IF;
		END LOOP;
		
	END IF;
	
	RETURN NEW;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON "SCHEMA_NAME".connec;
CREATE TRIGGER gw_trg_update_link_arc_id AFTER UPDATE OF arc_id ON "SCHEMA_NAME".connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_update_link_arc_id(connec);


DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON "SCHEMA_NAME".gully;
CREATE TRIGGER gw_trg_update_link_arc_id AFTER UPDATE OF arc_id ON "SCHEMA_NAME".gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_update_link_arc_id(gully);
