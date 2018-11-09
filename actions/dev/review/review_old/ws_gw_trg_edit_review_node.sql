/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_node()
  RETURNS trigger AS
$BODY$
DECLARE
r RECORD;
BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN
	
		UPDATE review_audit_node
		SET office_checked=NEW.office_checked
		WHERE node_id = OLD.node_id;
		
		UPDATE review_node
		SET office_checked=NEW.office_checked
		WHERE node_id = OLD.node_id;
		
		DELETE FROM review_node WHERE office_checked IS TRUE AND node_id = OLD.node_id;
		
		UPDATE node SET elevation=review_audit_node.elevation, "depth"=review_audit_node."depth" , nodecat_id=review_audit_node.nodecat_id FROM review_audit_node 
		WHERE node.node_id=review_audit_node.node_id AND office_checked is TRUE;
		
	END IF;	
	RETURN NULL;
		

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



DROP TRIGGER IF EXISTS gw_trg_edit_review_node ON "SCHEMA_NAME".v_edit_review_node;
CREATE TRIGGER gw_trg_edit_review_node INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_node(review_audit_node);

DROP TRIGGER IF EXISTS gw_trg_edit_review_node ON "SCHEMA_NAME".v_edit_review_node;
CREATE TRIGGER gw_trg_edit_review_node INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_node(review_node);