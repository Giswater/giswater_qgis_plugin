/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2482




CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_node()  RETURNS trigger AS
$BODY$

DECLARE

	v_tol_filter_bool boolean;
	v_review_status smallint;
	rec_node record;
	v_rev_node_elevation_tol double precision;
	v_rev_node_depth_tol double precision;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	-- getting tolerance parameters	
	v_rev_node_elevation_tol :=(SELECT value::json->'elevation' FROM config_param_system WHERE "parameter"='edit_review_node_tolerance');
	v_rev_node_depth_tol :=(SELECT value::json->'depth' FROM config_param_system WHERE "parameter"='edit_review_node_tolerance');
	
	--getting original values
	SELECT node_id, elevation, depth,  nodetype_id, nodecat_id, annotation, observ, expl_id, the_geom INTO rec_node 
	FROM node JOIN cat_node ON cat_node.id=node.nodecat_id WHERE node_id=NEW.node_id;
	
	IF NEW.field_checked=TRUE THEN				
		--looking for insert/update/delete values on audit table
		IF 
			abs(rec_node.elevation-NEW.elevation)>v_rev_node_elevation_tol OR  (rec_node.elevation IS NULL AND NEW.elevation IS NOT NULL) OR
			abs(rec_node.depth-NEW.depth)>v_rev_node_depth_tol OR  (rec_node.depth IS NULL AND NEW.depth IS NOT NULL) OR
			rec_node.nodecat_id!= NEW.nodecat_id OR  (rec_node.nodecat_id IS NULL AND NEW.nodecat_id IS NOT NULL) OR
			rec_node.annotation != NEW.annotation	OR  (rec_node.annotation IS NULL AND NEW.annotation IS NOT NULL) OR
			rec_node.observ != NEW.observ OR  (rec_node.observ IS NULL AND NEW.observ IS NOT NULL) OR
			rec_node.the_geom::text<>NEW.the_geom::text THEN
			v_tol_filter_bool=TRUE;
		ELSE
			v_tol_filter_bool=FALSE;
		END IF;

			-- updating review_status parameter value
			-- new element, re-updated after its insert
			IF (SELECT count(node_id) FROM node WHERE node_id=NEW.node_id)=0 THEN
				v_review_status=1;
			-- only data changes
			ELSIF (v_tol_filter_bool is TRUE) AND ST_OrderingEquals(NEW.the_geom::text, rec_node.the_geom::text) is TRUE THEN
				v_review_status=3;
			-- geometry changes	
			ELSIF (v_tol_filter_bool is TRUE) AND ST_OrderingEquals(NEW.the_geom::text, rec_node.the_geom::text) is FALSE THEN
				v_review_status=2;
			-- changes under tolerance
			ELSIF (v_tol_filter_bool is FALSE) THEN
				v_review_status=0;	
			END IF;
			
			IF NEW.field_date IS NULL THEN 
				NEW.field_date = now();
			END IF;
	END IF;

	-- starting process
    IF TG_OP = 'INSERT' THEN
		
		-- node_id
		IF NEW.node_id IS NULL THEN
			NEW.node_id := (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"2012", "function":"2482","debug_msg":"'||NEW.node_id::text||'"}}$$);';
				END IF;		
			END IF;
		END IF;
		
			
		-- insert values on review table
		INSERT INTO review_node (node_id, elevation, depth, nodecat_id, annotation, observ, review_obs, expl_id, the_geom, field_checked, field_date) 
		VALUES (NEW.node_id, NEW.elevation, NEW.depth, NEW.nodecat_id, NEW.annotation, NEW.observ, NEW.review_obs, NEW.expl_id, NEW.the_geom, NEW.field_checked,NEW.field_date);
		
		
		--looking for insert values on audit table
	  IF NEW.field_checked=TRUE THEN				
	  	
			INSERT INTO review_audit_node(node_id, old_elevation, new_elevation, old_depth, new_depth,
			old_nodecat_id, new_nodecat_id, old_annotation, new_annotation, old_observ, new_observ, review_obs, expl_id ,the_geom ,review_status_id, field_date, field_user)
			VALUES (NEW.node_id, rec_node.elevation, NEW.elevation, rec_node.depth,
			NEW.depth, rec_node.nodecat_id, NEW.nodecat_id, rec_node.annotation, NEW.annotation, rec_node.observ, NEW.observ, NEW.review_obs, NEW.expl_id,
			NEW.the_geom, v_review_status, NEW.field_date, current_user);
		
		END IF;
			
		RETURN NEW;
	
    ELSIF TG_OP = 'UPDATE' THEN
	
		-- update values on review table
		UPDATE review_node SET elevation=NEW.elevation, depth=NEW.depth, nodecat_id=NEW.nodecat_id, annotation=NEW.annotation, 
		observ=NEW.observ, review_obs=NEW.review_obs, expl_id=NEW.expl_id, the_geom=NEW.the_geom, field_checked=NEW.field_checked
		WHERE node_id=NEW.node_id;

		-- if user finish review visit
		IF (NEW.field_checked is TRUE) THEN
			-- upserting values on review_audit_node node table	
			IF EXISTS (SELECT node_id FROM review_audit_node WHERE node_id=NEW.node_id) THEN					
				UPDATE review_audit_node SET old_elevation=rec_node.elevation, new_elevation=NEW.elevation, old_depth=rec_node.depth, new_depth=NEW.depth, 
				old_nodecat_id=rec_node.nodecat_id, new_nodecat_id=NEW.nodecat_id, old_annotation=rec_node.annotation, new_annotation=NEW.annotation,
				old_observ=rec_node.observ, new_observ=NEW.observ, review_obs=NEW.review_obs, expl_id=NEW.expl_id, the_geom=NEW.the_geom, review_status_id=v_review_status, 
				field_date=NEW.field_date, field_user=current_user WHERE node_id=NEW.node_id;
			ELSE
			
				INSERT INTO review_audit_node(node_id, old_elevation, new_elevation, old_depth, new_depth,
				old_nodecat_id, new_nodecat_id, old_annotation, new_annotation, old_observ, new_observ, review_obs, expl_id ,the_geom ,review_status_id, field_date, field_user)
				VALUES (NEW.node_id, rec_node.elevation, NEW.elevation, rec_node.depth,
				NEW.depth, rec_node.nodecat_id, NEW.nodecat_id, rec_node.annotation, NEW.annotation, rec_node.observ, NEW.observ, NEW.review_obs, NEW.expl_id,
				NEW.the_geom, v_review_status, NEW.field_date, current_user);
			END IF;
				
		END IF;
		
    END IF;
 
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
