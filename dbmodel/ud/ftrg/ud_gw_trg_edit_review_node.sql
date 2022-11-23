/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2466


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_node()  RETURNS trigger AS
$BODY$

DECLARE
	v_rev_node_top_elev_tol double precision;
	v_rev_node_ymax_tol double precision;
	v_tol_filter_bool boolean;
	v_review_status smallint;

	rec_node record;
	rec_manhole record;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- getting tolerance parameters
	v_rev_node_top_elev_tol :=(SELECT value::json->'topelev' FROM config_param_system WHERE "parameter"='edit_review_node_tolerance');
	v_rev_node_ymax_tol :=(SELECT value::json->'ymax' FROM config_param_system WHERE "parameter"='edit_review_node_tolerance');		

	--getting original values
	SELECT node_id, top_elev, ymax, node.node_type, nodecat_id, node.matcat_id, annotation, observ, expl_id, the_geom INTO rec_node 
	FROM node JOIN cat_node ON id=node.nodecat_id WHERE node_id=NEW.node_id;
	
	SELECT node_id, step_pp, step_fe,step_replace, cover INTO rec_manhole
	FROM man_manhole WHERE node_id=NEW.node_id;

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
					"data":{"message":"2012", "function":"2466","debug_msg":"'||NEW.node_id::text||'"}}$$);'; 
				END IF;		
			END IF;
		END IF;
				
		-- insert values on review table
		INSERT INTO review_node (node_id, top_elev, ymax, node_type, matcat_id, nodecat_id, annotation, observ, 
		review_obs, expl_id, the_geom, field_checked, step_pp, step_fe, step_replace, cover, field_date)
		VALUES (NEW.node_id, NEW.top_elev, NEW.ymax, NEW.node_type, NEW.matcat_id, NEW.nodecat_id, NEW.annotation, NEW.observ, 
		NEW.review_obs, NEW.expl_id, NEW.the_geom, NEW.field_checked, NEW.step_pp, NEW.step_fe, NEW.step_replace, NEW.cover, NEW.field_date);
		
		
		--looking for insert values on audit table
	  	IF NEW.field_checked=TRUE THEN						
		
				IF NEW.field_date IS NULL THEN 
					NEW.field_date = now();
				END IF;

				INSERT INTO review_audit_node (node_id, new_top_elev, new_ymax, new_node_type, new_matcat_id, new_nodecat_id,
				 new_annotation, new_observ, review_obs, expl_id, the_geom, review_status_id, field_date, field_user, step_pp, step_fe, step_replace, cover)
				VALUES (NEW.node_id, NEW.top_elev, NEW.ymax, NEW.node_type, NEW.matcat_id, NEW.nodecat_id,
			 	NEW.annotation, NEW.observ, NEW.review_obs, NEW.expl_id, NEW.the_geom, 1, NEW.field_date, 
			 	current_user, NEW.step_pp, NEW.step_fe, NEW.step_replace, NEW.cover);

		END IF;
			
		RETURN NEW;
	
    ELSIF TG_OP = 'UPDATE' THEN
		-- update values on review table
		UPDATE review_node SET top_elev=NEW.top_elev, ymax=NEW.ymax, node_type=NEW.node_type, matcat_id=NEW.matcat_id, nodecat_id=NEW.nodecat_id,
		 annotation=NEW.annotation, observ=NEW.observ, review_obs=NEW.review_obs, expl_id=NEW.expl_id, the_geom=NEW.the_geom, field_checked=NEW.field_checked,
		 step_pp=NEW.step_pp, step_fe=NEW.step_fe, step_replace=NEW.step_replace, cover=NEW.cover
		WHERE node_id=NEW.node_id;

		--looking for insert/update/delete values on audit table
		IF rec_manhole IS NOT NULL AND abs(rec_node.top_elev-NEW.top_elev)>v_rev_node_top_elev_tol OR  (rec_node.top_elev IS NULL AND NEW.top_elev IS NOT NULL) OR
			abs(rec_node.ymax-NEW.ymax)>v_rev_node_ymax_tol OR  (rec_node.ymax IS NULL AND NEW.ymax IS NOT NULL) OR
			rec_node.matcat_id!= NEW.matcat_id OR  (rec_node.matcat_id IS NULL AND NEW.matcat_id IS NOT NULL) OR
			rec_node.nodecat_id!= NEW.nodecat_id OR  (rec_node.nodecat_id IS NULL AND NEW.nodecat_id IS NOT NULL) OR
			rec_node.annotation != NEW.annotation	OR  (rec_node.annotation IS NULL AND NEW.annotation IS NOT NULL) OR
			rec_node.observ != NEW.observ	OR  (rec_node.observ IS NULL AND NEW.observ IS NOT NULL) OR
			rec_manhole.step_pp != NEW.step_pp	OR  (rec_manhole.step_pp IS NULL AND NEW.step_pp IS NOT NULL) OR
			rec_manhole.step_fe != NEW.step_fe	OR  (rec_manhole.step_fe IS NULL AND NEW.step_fe IS NOT NULL) OR
			rec_manhole.step_replace != NEW.step_replace	OR  (rec_manhole.step_replace IS NULL AND NEW.step_replace IS NOT NULL) OR
			rec_manhole.cover != NEW.cover	OR  (rec_manhole.cover IS NULL AND NEW.cover IS NOT NULL) OR
			rec_node.the_geom::text<>NEW.the_geom::text THEN
			v_tol_filter_bool=TRUE;
		ELSIF abs(rec_node.top_elev-NEW.top_elev)>v_rev_node_top_elev_tol OR  (rec_node.top_elev IS NULL AND NEW.top_elev IS NOT NULL) OR
			abs(rec_node.ymax-NEW.ymax)>v_rev_node_ymax_tol OR  (rec_node.ymax IS NULL AND NEW.ymax IS NOT NULL) OR
			rec_node.matcat_id!= NEW.matcat_id OR  (rec_node.matcat_id IS NULL AND NEW.matcat_id IS NOT NULL) OR
			rec_node.nodecat_id!= NEW.nodecat_id OR  (rec_node.nodecat_id IS NULL AND NEW.nodecat_id IS NOT NULL) OR
			rec_node.annotation != NEW.annotation	OR  (rec_node.annotation IS NULL AND NEW.annotation IS NOT NULL) OR
			rec_node.observ != NEW.observ	OR  (rec_node.observ IS NULL AND NEW.observ IS NOT NULL) OR
			rec_node.the_geom::text<>NEW.the_geom::text THEN
			v_tol_filter_bool=TRUE;
		ELSE
			v_tol_filter_bool=FALSE;
		END IF;

		IF NEW.field_date IS NULL THEN 
			NEW.field_date = now();
		END IF;

		-- if user finish review visit
		IF (NEW.field_checked is TRUE) THEN
			
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
		
			-- upserting values on review_audit_node node table	
			IF EXISTS (SELECT node_id FROM review_audit_node WHERE node_id=NEW.node_id) AND rec_manhole.node_id IS NOT NULL THEN 					
				UPDATE review_audit_node SET old_top_elev=rec_node.top_elev, new_top_elev=NEW.top_elev, old_ymax=rec_node.ymax, new_ymax=NEW.ymax, 
				old_node_type=rec_node.node_type, new_node_type=NEW.node_type, old_matcat_id=rec_node.matcat_id, new_matcat_id=NEW.matcat_id, 
				old_nodecat_id=rec_node.nodecat_id, new_nodecat_id=NEW.nodecat_id, old_annotation=rec_node.annotation, new_annotation=NEW.annotation, 
				old_observ=rec_node.observ, new_observ=NEW.observ, review_obs=NEW.review_obs, expl_id=NEW.expl_id, the_geom=NEW.the_geom, review_status_id=v_review_status, 
			  field_user=current_user, old_step_pp=rec_manhole.step_pp, new_step_pp=NEW.step_pp, old_step_fe=rec_manhole.step_fe, 
				new_step_fe=NEW.step_fe, old_step_replace=rec_manhole.step_replace, new_step_replace=NEW.step_replace, old_cover=rec_manhole.cover, new_cover=NEW.cover,
				field_date=NEW.field_date
       			WHERE node_id=NEW.node_id;

      ELSIF EXISTS (SELECT node_id FROM review_audit_node WHERE node_id=NEW.node_id) THEN 					
				UPDATE review_audit_node SET old_top_elev=rec_node.top_elev, new_top_elev=NEW.top_elev, old_ymax=rec_node.ymax, new_ymax=NEW.ymax, 
				old_node_type=rec_node.node_type, new_node_type=NEW.node_type, old_matcat_id=rec_node.matcat_id, new_matcat_id=NEW.matcat_id, 
				old_nodecat_id=rec_node.nodecat_id, new_nodecat_id=NEW.nodecat_id, old_annotation=rec_node.annotation, new_annotation=NEW.annotation, 
				old_observ=rec_node.observ, new_observ=NEW.observ, review_obs=NEW.review_obs, expl_id=NEW.expl_id, the_geom=NEW.the_geom, review_status_id=v_review_status, 
			  field_user=current_user, field_date=NEW.field_date
       			WHERE node_id=NEW.node_id;

			ELSE
				INSERT INTO review_audit_node
				(node_id, old_top_elev, new_top_elev, old_ymax, new_ymax, old_node_type, new_node_type, old_matcat_id, new_matcat_id, old_nodecat_id, 
				new_nodecat_id, old_annotation, new_annotation, old_observ, new_observ, review_obs, expl_id, the_geom, review_status_id, field_date, field_user,
				old_step_pp, new_step_pp, old_step_fe, new_step_fe, old_step_replace, new_step_replace, old_cover, new_cover)
				VALUES (NEW.node_id, rec_node.top_elev, NEW.top_elev, rec_node.ymax, NEW.ymax, rec_node.node_type, NEW.node_type, rec_node.matcat_id,
				NEW.matcat_id, rec_node.nodecat_id, NEW.nodecat_id, rec_node.annotation, NEW.annotation, rec_node.observ, NEW.observ, NEW.review_obs, NEW.expl_id, 
				NEW.the_geom, v_review_status, NEW.field_date, current_user, rec_manhole.step_pp, NEW.step_pp, 
				rec_manhole.step_fe, NEW.step_fe, rec_manhole.step_replace, 
				NEW.step_replace, rec_manhole.cover, NEW.cover);

			END IF;
				
		END IF;
		
    END IF;

    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;