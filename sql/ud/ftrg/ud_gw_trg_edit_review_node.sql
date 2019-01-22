/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2466


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_node()  RETURNS trigger AS
$BODY$

DECLARE
	rev_node_top_elev_tol double precision;
	rev_node_ymax_tol double precision;
	rev_node_geom1_tol double precision;
	rev_node_geom2_tol double precision;
	tol_filter_bool boolean;
	review_status_aux smallint;
	rec_node record;
	status_new integer;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- getting tolerance parameters
	rev_node_top_elev_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_node_top_elev_tol');
	rev_node_ymax_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_node_ymax_tol');		
	rev_node_geom1_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_node_geom1_tol');
	rev_node_geom2_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_node_geom2_tol');	

	--getting original values
	SELECT node_id, top_elev, ymax, node_type, nodecat_id, matcat_id, shape, geom1, geom2, annotation, observ, expl_id, the_geom INTO rec_node 
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
					PERFORM audit_function(2012,2466,NEW.node_id);
				END IF;		
			END IF;
		END IF;
		
				
		-- insert values on review table
		INSERT INTO review_node (node_id, top_elev, ymax, node_type, matcat_id, shape, geom1, geom2, annotation, observ, 
			expl_id, the_geom, field_checked)
		VALUES (NEW.node_id, NEW.top_elev, NEW.ymax, NEW.node_type, NEW.matcat_id, NEW.shape, NEW.geom1, NEW.geom2, NEW.annotation, NEW.observ, 
			NEW.expl_id, NEW.the_geom, NEW.field_checked);
		
		
		--looking for insert values on audit table
	  	IF NEW.field_checked=TRUE THEN						
			INSERT INTO review_audit_node (node_id, new_top_elev, new_ymax, new_node_type, new_matcat_id, new_shape, 
				new_geom1, new_geom2, annotation, observ, expl_id, the_geom, review_status_id, field_date, field_user)
			VALUES (NEW.node_id, NEW.top_elev, NEW.ymax, NEW.node_type, NEW.matcat_id, NEW.shape, 
				NEW.geom1, NEW.geom2, NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom, 1, now(), current_user);
		
		END IF;
			
		RETURN NEW;
	
    ELSIF TG_OP = 'UPDATE' THEN
	
		-- update values on review table
		UPDATE review_node SET top_elev=NEW.top_elev, ymax=NEW.ymax, node_type=NEW.node_type, matcat_id=NEW.matcat_id, shape=NEW.shape, 
				geom1=NEW.geom1, geom2=NEW.geom2, annotation=NEW.annotation, observ=NEW.observ, expl_id=NEW.expl_id, 
				the_geom=NEW.the_geom, field_checked=NEW.field_checked
		WHERE node_id=NEW.node_id;

		SELECT review_status_id INTO status_new FROM review_audit_node WHERE node_id=NEW.node_id;
		
		--looking for insert/update/delete values on audit table
		IF 	abs(rec_node.top_elev-NEW.top_elev)>rev_node_top_elev_tol OR  (rec_node.top_elev IS NULL AND NEW.top_elev IS NOT NULL) OR
			abs(rec_node.ymax-NEW.ymax)>rev_node_ymax_tol OR  (rec_node.ymax IS NULL AND NEW.ymax IS NOT NULL) OR
			abs(rec_node.geom1-NEW.geom1)>rev_node_geom1_tol OR  (rec_node.geom1 IS NULL AND NEW.geom1 IS NOT NULL) OR
			abs(rec_node.geom2-NEW.geom2)>rev_node_geom2_tol OR  (rec_node.geom2 IS NULL AND NEW.geom2 IS NOT NULL) OR
			rec_node.matcat_id!= NEW.matcat_id OR  (rec_node.matcat_id IS NULL AND NEW.matcat_id IS NOT NULL) OR
			rec_node.annotation != NEW.annotation	OR  (rec_node.annotation IS NULL AND NEW.annotation IS NOT NULL) OR
			rec_node.observ != NEW.observ	OR  (rec_node.observ IS NULL AND NEW.observ IS NOT NULL) OR
			rec_node.shape != NEW.shape	OR  (rec_node.shape IS NULL AND NEW.shape IS NOT NULL) OR
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
				UPDATE review_audit_node SET old_top_elev=rec_node.old_top_elev, new_top_elev=NEW.top_elev, old_ymax=rec_node.ymax, 
       			new_ymax=NEW.ymax, old_node_type=rec_node.node_type, new_node_type=NEW.node_type, old_matcat_id=rec_node.matcat_id, 
       			new_matcat_id=NEW.matcat_id, old_shape=rec_node.shape, new_shape=NEW.shape, old_geom1=rec_node.geom1, new_geom1=NEW.geom1, 
       			old_geom2=rec_node.geom2, new_geom2=NEW.geom2, old_nodecat_id=rec_node.nodecat_id, annotation=NEW.annotation, observ=NEW.observ,
       			expl_id=NEW.expl_id, the_geom=NEW.the_geom, review_status_id=review_status_aux, field_date=now(), field_user=current_user
       			WHERE node_id=NEW.node_id;

			ELSE
			
				INSERT INTO review_audit_node
				(node_id, old_top_elev, new_top_elev, old_ymax, new_ymax, old_node_type, new_node_type, old_matcat_id, new_matcat_id, old_shape, 
       			new_shape, old_geom1, new_geom1, old_geom2, new_geom2, old_nodecat_id, annotation, observ, expl_id, the_geom, 
       			review_status_id, field_date, field_user)
				VALUES (NEW.node_id, rec_node.top_elev, NEW.top_elev, rec_node.ymax, NEW.ymax, rec_node.node_type, NEW.node_type, rec_node.matcat_id,
				NEW.matcat_id, rec_node.shape, NEW.shape, rec_node.geom1, NEW.geom1, rec_node.geom2, NEW.geom2, rec_node.nodecat_id,
				NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom, review_status_aux, now(), current_user);

			END IF;
				
		END IF;
		
    END IF;

    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;