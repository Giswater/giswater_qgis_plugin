/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "sanejament".gw_trg_edit_om_review_node()
  RETURNS trigger AS
$BODY$
DECLARE 

	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    
    IF TG_OP = 'UPDATE' THEN
		  UPDATE om_visit_review_node SET new_sander=NEW.new_sander, new_ymax=NEW.new_ymax, is_validated=NEW.is_validated WHERE node_id=OLD.node_id;
		  UPDATE node SET sander=NEW.new_sander, ymax=NEW.new_ymax WHERE node_id=OLD.node_id;
    END IF;

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

DROP TRIGGER IF EXISTS gw_trg_edit_om_review_node ON "sanejament".v_edit_om_review_node;
CREATE TRIGGER gw_trg_edit_om_review_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "sanejament".v_edit_om_review_node
FOR EACH ROW EXECUTE PROCEDURE "sanejament".gw_trg_edit_om_review_node();


      