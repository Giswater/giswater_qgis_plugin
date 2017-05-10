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
		
		UPDATE node SET top_elev=review_audit_node.top_elev, ymax=review_audit_node.ymax FROM review_audit_node 
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