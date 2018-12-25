/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION NUMBER: 2484


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_audit_node()
  RETURNS trigger AS
$BODY$

DECLARE
	review_status integer;
	
BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN
	
		SELECT review_status_id INTO review_status FROM review_audit_node WHERE node_id=NEW.node_id;
		
		IF NEW.is_validated = 0 THEN

			DELETE FROM review_node WHERE node_id = NEW.node_id;
			UPDATE review_audit_node SET is_validated=NEW.is_validated WHERE node_id=NEW.node_id;

		ELSIF NEW.is_validated = 1 THEN

			IF NEW.new_nodecat_id IS NULL THEN
				RAISE EXCEPTION 'It is impossible to validate the node % without assigning value of nodecat_id', NEW.node_id;
			END IF;
			
			UPDATE review_audit_node SET new_nodecat_id=NEW.new_nodecat_id, is_validated=NEW.is_validated WHERE node_id=NEW.node_id;
			
			IF review_status=1 AND NEW.node_id NOT IN (SELECT node_id FROM node) THEN 

				INSERT INTO v_edit_node (node_id, elevation, depth,  nodecat_id, annotation, observ, expl_id, the_geom)
				VALUES (NEW.node_id, NEW.new_elevation, NEW.new_depth, NEW.new_nodecat_id, NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom); 
				
		
			ELSIF review_status=2 THEN
				UPDATE v_edit_node SET the_geom=NEW.the_geom, elevation=NEW.new_elevation, depth=NEW.new_depth, nodecat_id=NEW.new_nodecat_id, annotation=NEW.annotation, observ=NEW.observ WHERE node_id=NEW.node_id;
					
			ELSIF review_status=3 THEN

				UPDATE v_edit_node SET elevation=NEW.new_elevation, depth=NEW.new_depth, nodecat_id=NEW.new_nodecat_id,
				annotation=NEW.annotation, observ=NEW.observ WHERE node_id=NEW.node_id;
	
			END IF;	
			
			
			DELETE FROM review_node WHERE node_id = NEW.node_id;
		
		ELSIF NEW.is_validated = 2 THEN
			
			UPDATE review_node SET field_checked=FALSE, is_validated=2 WHERE node_id=NEW.node_id;
			UPDATE review_audit_node SET is_validated=NEW.is_validated WHERE node_id=NEW.node_id;

		END IF;
		
	END IF;	

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;