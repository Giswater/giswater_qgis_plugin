/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2482




CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_node()  RETURNS trigger AS
$BODY$

DECLARE

	tol_filter_bool boolean;
	review_status_aux smallint;
	rec_node record;
	status_new integer;
	rev_node_elevation_tol double precision;
	rev_node_depth_tol double precision;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	-- getting tolerance parameters
	rev_node_elevation_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_node_elevation_tol');
	rev_node_depth_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_node_depth_tol');	
	
	--getting original values
	SELECT node_id, elevation, depth,  nodetype_id, nodecat_id, annotation, observ, expl_id, the_geom INTO rec_node 
	FROM node JOIN cat_node ON cat_node.id=node.nodecat_id WHERE node_id=NEW.node_id;
	

	-- starting process
    IF TG_OP = 'INSERT' THEN
		
		-- node_id
		IF NEW.node_id IS NULL THEN
			NEW.node_id := (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,2482,NEW.node_id);
				END IF;		
			END IF;
		END IF;
		
				
		-- insert values on review table
		INSERT INTO review_node (node_id, elevation, depth, annotation, observ, expl_id, the_geom, field_checked) 
		VALUES (NEW.node_id, NEW.elevation, NEW.depth, NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom, NEW.field_checked);
		
		
		--looking for insert values on audit table
	  	IF NEW.field_checked=TRUE THEN						
			INSERT INTO review_audit_node (node_id, new_elevation, new_depth,  new_nodetype_id, new_nodecat_id,annotation, observ, expl_id, the_geom, 
			review_status_id, field_date, field_user)
			VALUES (NEW.node_id, NEW.elevation, NEW.depth, NEW.nodetype_id, NEW.nodecat_id, NEW.annotation, NEW.observ, 
			NEW.expl_id, NEW.the_geom, 1, now(), current_user);
		
		END IF;
			
		RETURN NEW;
	
    ELSIF TG_OP = 'UPDATE' THEN
	
		-- update values on review table
		UPDATE review_node SET elevation=NEW.elevation, depth=NEW.depth, annotation=NEW.annotation, 
		observ=NEW.observ, expl_id=NEW.expl_id, the_geom=NEW.the_geom, field_checked=NEW.field_checked
		WHERE node_id=NEW.node_id;

		SELECT review_status_id INTO status_new FROM review_audit_node WHERE node_id=NEW.node_id;
		
		--looking for insert/update/delete values on audit table
		IF 
			abs(rec_node.elevation-NEW.elevation)>rev_node_elevation_tol OR  (rec_node.elevation IS NULL AND NEW.elevation IS NOT NULL) OR
			abs(rec_node.depth-NEW.depth)>rev_node_depth_tol OR  (rec_node.depth IS NULL AND NEW.depth IS NOT NULL) OR
			rec_node.annotation != NEW.annotation	OR  (rec_node.elevation IS NULL AND NEW.elevation IS NOT NULL) OR
			rec_node.observ != NEW.observ OR  (rec_node.observ IS NULL AND NEW.observ IS NOT NULL) OR
			rec_node.the_geom::text<>NEW.the_geom::text THEN
			tol_filter_bool=TRUE;
		ELSE
			tol_filter_bool=FALSE;
		END IF;
		-- if user finish review visit
		IF (NEW.field_checked is TRUE) THEN
			
			-- updating review_status parameter value
			IF status_new=1 THEN
				review_status_aux=1;
			ELSIF (tol_filter_bool is TRUE) AND (NEW.the_geom::text<>OLD.the_geom::text) THEN
				review_status_aux=2;
			ELSIF (tol_filter_bool is TRUE) AND (NEW.the_geom::text=OLD.the_geom::text) THEN
				review_status_aux=3;
			ELSIF (tol_filter_bool is FALSE) THEN
				review_status_aux=0;	
			END IF;
		
			-- upserting values on review_audit_node node table	
			IF EXISTS (SELECT node_id FROM review_audit_node WHERE node_id=NEW.node_id) THEN					
				UPDATE review_audit_node SET old_elevation=rec_node.elevation, new_elevation=NEW.elevation, old_depth=rec_node.depth, new_depth=NEW.depth, 
				old_nodecat_id=rec_node.nodecat_id, annotation=NEW.annotation,
				observ=NEW.observ, expl_id=NEW.expl_id, the_geom=NEW.the_geom, review_status_id=review_status_aux, field_date=now(), 
				field_user=current_user WHERE node_id=NEW.node_id;
			ELSE
			
				INSERT INTO review_audit_node(node_id, old_elevation, new_elevation, old_depth, new_depth,
				old_nodecat_id , annotation, observ ,expl_id ,the_geom ,review_status_id, field_date, field_user)
				VALUES (NEW.node_id, rec_node.elevation, NEW.elevation, rec_node.depth,
				NEW.depth, rec_node.nodecat_id, NEW.annotation, NEW.observ, NEW.expl_id,
				NEW.the_geom, review_status_aux, now(), current_user);
			END IF;
				
		END IF;
		
    END IF;
 
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
