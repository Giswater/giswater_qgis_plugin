/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "sanejament".gw_trg_edit_om_review_arc()
  RETURNS trigger AS
$BODY$
DECLARE 

	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    
    IF TG_OP = 'UPDATE' THEN
		  UPDATE om_visit_review_arc SET arccat_id=NEW.arccat_id, new_y1=NEW.new_y1, new_y2=NEW.new_y2, is_validated=NEW.is_validated WHERE arc_id=OLD.arc_id;
		  UPDATE arc SET arccat_id=NEW.arccat_id, y1=NEW.new_y1, y2=NEW.new_y2 WHERE arc_id=OLD.arc_id;
    END IF;

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

DROP TRIGGER IF EXISTS gw_trg_edit_om_review_arc ON "sanejament".v_edit_om_review_arc;
CREATE TRIGGER gw_trg_edit_om_review_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "sanejament".v_edit_om_review_arc
FOR EACH ROW EXECUTE PROCEDURE "sanejament".gw_trg_edit_om_review_arc();


      