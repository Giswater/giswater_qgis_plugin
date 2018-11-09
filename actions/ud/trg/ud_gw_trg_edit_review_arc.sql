/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2470




CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_arc()  RETURNS trigger AS
$BODY$

DECLARE
	rev_arc_y1_tol double precision;
	rev_arc_y2_tol double precision;
	rev_arc_geom1_tol double precision;
	rev_arc_geom2_tol double precision;
	tol_filter_bool boolean;
	review_status_aux smallint;
	rec_arc record;
	status_new integer;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- getting tolerance parameters
	rev_arc_y1_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_arc_y1_tol');
	rev_arc_y2_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_arc_y2_tol');		
	rev_arc_geom1_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_arc_geom1_tol');
	rev_arc_geom2_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_arc_geom2_tol');	

	--getting original values
	SELECT arc_id,y1,y2,arc_type, arccat_id, arc.matcat_id, annotation, observ, shape, geom1, geom2, the_geom, expl_id INTO rec_arc FROM arc JOIN cat_arc ON cat_arc.id=arc.arccat_id WHERE arc_id=NEW.arc_id;
	

	-- starting process
    IF TG_OP = 'INSERT' THEN
		
		-- arc_id
		IF NEW.arc_id IS NULL THEN
			NEW.arc_id := (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,2470,NEW.arc_id);
				END IF;		
			END IF;
		END IF;
		
				
		-- insert values on review table
		INSERT INTO review_arc (arc_id, y1, y2, arc_type, matcat_id, shape, geom1, geom2, annotation, observ, expl_id, the_geom, field_checked) 
		VALUES (NEW.arc_id, NEW.y1, NEW.y2, NEW.arc_type, NEW.matcat_id, NEW.shape, NEW.geom1, NEW.geom2, NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom, NEW.field_checked);
		
		
		--looking for insert values on audit table
	  	IF NEW.field_checked=TRUE THEN						
			INSERT INTO review_audit_arc (arc_id, new_y1, new_y2, new_arc_type, new_matcat_id, new_shape, new_geom1, new_geom2, annotation, observ, expl_id, the_geom, 
			review_status_id, field_date, field_user)
			VALUES (NEW.arc_id, NEW.y1, NEW.y2, NEW.arc_type, NEW.matcat_id, NEW.shape, NEW.geom1, NEW.geom2,NEW.annotation, NEW.observ, 
			NEW.expl_id, NEW.the_geom, 1, now(), current_user);
		
		END IF;
			
		RETURN NEW;
	
    ELSIF TG_OP = 'UPDATE' THEN
	
		-- update values on review table
		UPDATE review_arc SET y1=NEW.y1, y2=NEW.y2, arc_type=NEW.arc_type, matcat_id=NEW.matcat_id, shape=NEW.shape, geom1=NEW.geom1, geom2=NEW.geom2, 
		annotation=NEW.annotation, observ=NEW.observ, expl_id=NEW.expl_id, the_geom=NEW.the_geom, field_checked=NEW.field_checked
		WHERE arc_id=NEW.arc_id;

		SELECT review_status_id INTO status_new FROM review_audit_arc WHERE arc_id=NEW.arc_id;
		
		--looking for insert/update/delete values on audit table
		IF 	abs(rec_arc.y1-NEW.y1)>rev_arc_y1_tol OR  (rec_arc.y1 IS NULL AND NEW.y1 IS NOT NULL) OR
			abs(rec_arc.y2-NEW.y2)>rev_arc_y2_tol OR  (rec_arc.y2 IS NULL AND NEW.y2 IS NOT NULL) OR
			abs(rec_arc.geom1-NEW.geom1)>rev_arc_geom1_tol OR  (rec_arc.geom1 IS NULL AND NEW.geom1 IS NOT NULL) OR
			abs(rec_arc.geom2-NEW.geom2)>rev_arc_geom2_tol OR  (rec_arc.geom2 IS NULL AND NEW.geom2 IS NOT NULL) OR
			rec_arc.matcat_id!= NEW.matcat_id OR  (rec_arc.matcat_id IS NULL AND NEW.matcat_id IS NOT NULL) OR
			rec_arc.shape != NEW.shape	OR  (rec_arc.shape IS NULL AND NEW.shape IS NOT NULL) OR
			rec_arc.annotation != NEW.annotation	OR  (rec_arc.annotation IS NULL AND NEW.annotation IS NOT NULL) OR
			rec_arc.observ != NEW.observ	OR  (rec_arc.observ IS NULL AND NEW.observ IS NOT NULL) OR
			rec_arc.the_geom::text<>NEW.the_geom::text THEN
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
		
			-- upserting values on review_audit_arc arc table	
			IF EXISTS (SELECT arc_id FROM review_audit_arc WHERE arc_id=NEW.arc_id) THEN					
				UPDATE review_audit_arc	SET old_y1=rec_arc.y1, new_y1=NEW.y1, old_y2=rec_arc.y2, new_y2=NEW.y2, old_arc_type=rec_arc.arc_type, 
				new_arc_type=NEW.arc_type, old_matcat_id=rec_arc.matcat_id, new_matcat_id=NEW.matcat_id, old_shape=rec_arc.shape, new_shape=NEW.shape, old_geom1=rec_arc.geom1, new_geom1=NEW.geom1, 
				old_geom2=rec_arc.geom2, new_geom2=NEW.geom2, old_arccat_id=rec_arc.arccat_id, annotation=NEW.annotation, observ=NEW.observ, expl_id=NEW.expl_id, the_geom=NEW.the_geom, 
				review_status_id=review_status_aux, field_date=now(), field_user=current_user WHERE arc_id=NEW.arc_id;
			ELSE
			
				INSERT INTO review_audit_arc(arc_id, old_y1, new_y1, old_y2, new_y2, old_arc_type, new_arc_type, old_matcat_id, new_matcat_id, old_shape, new_shape,
				old_geom1 ,new_geom1 ,old_geom2 ,new_geom2 ,old_arccat_id , annotation, observ ,expl_id ,the_geom ,review_status_id, field_date, field_user)
				VALUES (NEW.arc_id, rec_arc.y1,  NEW.y1, rec_arc.y2, NEW.y2, rec_arc.arc_type, NEW.arc_type, rec_arc.matcat_id, NEW.matcat_id, rec_arc.shape,
				NEW.shape, rec_arc.geom1, NEW.geom1, rec_arc.geom2, NEW.geom2, rec_arc.arccat_id, NEW.annotation, NEW.observ, NEW.expl_id,
				NEW.the_geom, review_status_aux, now(), current_user);
			END IF;
				
		END IF;
		
    END IF;

    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_review_arc ON "SCHEMA_NAME".v_edit_review_arc;
CREATE TRIGGER gw_trg_edit_review_arc INSTEAD OF INSERT OR UPDATE ON "SCHEMA_NAME".v_edit_review_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_arc();
