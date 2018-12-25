/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2478




CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_gully()  RETURNS trigger AS
$BODY$

DECLARE
	rev_gully_top_elev_tol double precision;
	rev_gully_ymax_tol double precision;
	rev_gully_connec_geom1_tol double precision;
	rev_gully_connec_geom2_tol double precision;
	rev_gully_sandbox_tol double precision;
	rev_gully_units_tol double precision;
	tol_filter_bool boolean;
	review_status_aux smallint;
	rec_gully record;
	status_new integer;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- getting tolerance parameters
	rev_gully_top_elev_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_gully_top_elev_tol');
	rev_gully_ymax_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_gully_ymax_tol');		
	rev_gully_connec_geom1_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_gully_connec_geom1_tol');
	rev_gully_connec_geom2_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_gully_connec_geom2_tol');	
	rev_gully_sandbox_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_gully_sandbox_tol');	
	rev_gully_units_tol :=(SELECT "value" FROM config_param_system WHERE "parameter"='rev_gully_units_tol');	

	--getting original values
	SELECT gully_id, top_elev, ymax, sandbox, gully.matcat_id, gully_type,gratecat_id, units, groove, siphon, cat_arc.matcat_id as connec_matcat_id, shape, geom1, 
		geom2, connec_arccat_id, featurecat_id, feature_id, annotation, observ, expl_id, the_geom INTO rec_gully 
	FROM gully JOIN cat_grate ON cat_grate.id=gully.gratecat_id 
	LEFT JOIN cat_arc ON cat_arc.id=connec_arccat_id
	WHERE gully_id=NEW.gully_id;
	
	-- starting process
    IF TG_OP = 'INSERT' THEN
		
		-- gully_id
		IF NEW.gully_id IS NULL THEN
			NEW.gully_id := (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,2478,NEW.gully_id);
				END IF;		
			END IF;
		END IF;
		
				
		-- insert values on review table
		INSERT INTO review_gully (gully_id, top_elev, ymax, sandbox, matcat_id, gully_type, gratecat_id, units, groove, siphon, connec_matcat_id, connec_shape, 
				connec_geom1, connec_geom2, featurecat_id, feature_id, annotation, observ, expl_id, the_geom, field_checked)
		VALUES (NEW.gully_id, NEW.top_elev, NEW.ymax, NEW.sandbox, NEW.matcat_id, NEW.gully_type, NEW.gratecat_id, NEW.units, NEW.groove, NEW.siphon, NEW.connec_matcat_id,
				NEW.connec_shape, NEW.connec_geom1, NEW.connec_geom2, NEW.featurecat_id, NEW.feature_id,NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom, 
				NEW.field_checked);
		
		
		--looking for insert values on audit table
	  	IF NEW.field_checked=TRUE THEN						
			INSERT INTO review_audit_gully (gully_id, new_top_elev, new_ymax, new_sandbox, new_matcat_id, new_gully_type, new_gratecat_id, new_units, new_groove, new_siphon,
				 new_connec_matcat_id,new_connec_shape, new_connec_geom1, new_connec_geom2, new_featurecat_id, new_feature_id, 
				 annotation, observ, expl_id, the_geom, review_status_id, field_date, field_user)
			VALUES (NEW.gully_id, NEW.top_elev, NEW.ymax, NEW.sandbox, NEW.matcat_id, NEW.gully_type, NEW.gratecat_id, NEW.units, NEW.groove, NEW.siphon, NEW.connec_matcat_id,
				NEW.connec_shape, NEW.connec_geom1, NEW.connec_geom2, NEW.featurecat_id, NEW.feature_id, NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom,
				1, now(), current_user);
		
		END IF;
			
		RETURN NEW;
	
    ELSIF TG_OP = 'UPDATE' THEN
	
		-- update values on review table
		UPDATE review_gully SET top_elev=NEW.top_elev, ymax=NEW.ymax, sandbox=NEW.sandbox, matcat_id=NEW.matcat_id,gully_type=NEW.gully_type, gratecat_id=NEW.gratecat_id,
				units=NEW.units, groove=NEW.groove, siphon=NEW.siphon, connec_matcat_id=NEW.connec_matcat_id, connec_shape=NEW.connec_shape,
				connec_geom1=NEW.connec_geom1, connec_geom2=NEW.connec_geom2, featurecat_id=NEW.featurecat_id, feature_id=NEW.feature_id, annotation=NEW.annotation, 
				observ=NEW.observ, expl_id=NEW.expl_id, the_geom=NEW.the_geom, field_checked=NEW.field_checked
		WHERE gully_id=NEW.gully_id;

		SELECT review_status_id INTO status_new FROM review_audit_gully WHERE gully_id=NEW.gully_id;
		
		--looking for insert/update/delete values on audit table
		IF abs(rec_gully.top_elev-NEW.top_elev)>rev_gully_top_elev_tol OR  (rec_gully.top_elev IS NULL AND NEW.top_elev IS NOT NULL) OR
			abs(rec_gully.ymax-NEW.ymax)>rev_gully_ymax_tol OR  (rec_gully.ymax IS NULL AND NEW.ymax IS NOT NULL) OR
			abs(rec_gully.geom1-NEW.connec_geom1)>rev_gully_connec_geom1_tol OR  (rec_gully.geom1 IS NULL AND NEW.connec_geom1 IS NOT NULL) OR
			abs(rec_gully.geom2-NEW.connec_geom2)>rev_gully_connec_geom2_tol OR  (rec_gully.geom2 IS NULL AND NEW.connec_geom2 IS NOT NULL) OR
			abs(rec_gully.sandbox-NEW.sandbox)>rev_gully_sandbox_tol OR  (rec_gully.sandbox IS NULL AND NEW.sandbox IS NOT NULL) OR
			abs(rec_gully.units-NEW.units)>rev_gully_units_tol OR  (rec_gully.units IS NULL AND NEW.units IS NOT NULL) OR
			rec_gully.matcat_id!= NEW.matcat_id OR  (rec_gully.matcat_id IS NULL AND NEW.matcat_id IS NOT NULL) OR
			rec_gully.annotation != NEW.annotation OR  (rec_gully.annotation IS NULL AND NEW.annotation IS NOT NULL) OR
			rec_gully.observ != NEW.observ	OR  (rec_gully.observ IS NULL AND NEW.observ IS NOT NULL) OR
			rec_gully.shape != NEW.connec_shape	OR  (rec_gully.shape IS NULL AND NEW.connec_shape IS NOT NULL) OR
			rec_gully.gratecat_id != NEW.gratecat_id	OR  (rec_gully.gratecat_id IS NULL AND NEW.gratecat_id IS NOT NULL) OR
			rec_gully.groove != NEW.groove	OR  (rec_gully.groove IS NULL AND NEW.groove IS NOT NULL) OR
			rec_gully.siphon != NEW.siphon	OR  (rec_gully.siphon IS NULL AND NEW.siphon IS NOT NULL) OR
			rec_gully.featurecat_id != NEW.featurecat_id	OR  (rec_gully.featurecat_id IS NULL AND NEW.featurecat_id IS NOT NULL) OR
			rec_gully.feature_id != NEW.feature_id	or  (rec_gully.feature_id IS NULL AND NEW.feature_id IS NOT NULL) OR
			rec_gully.the_geom::text<>NEW.the_geom::text THEN
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
		
			-- upserting values on review_audit_gully gully table	
			IF EXISTS (SELECT gully_id FROM review_audit_gully WHERE gully_id=NEW.gully_id) THEN					
				UPDATE review_audit_gully SET old_top_elev=rec_gully.old_top_elev, new_top_elev=NEW.top_elev, old_ymax=rec_gully.ymax, 
       			new_ymax=NEW.ymax, old_sandbox=rec_gully.sandbox, new_sandbox=NEW.sandbox, old_matcat_id=rec_gully.matcat_id, 
       			new_matcat_id=NEW.matcat_id, old_gully_type=rec_gully.gully_type, new_gully_type=NEW.gully_type, old_gratecat_id=rec_gully.gratecat_id,	
				new_gratecat_id=NEW.gratecat_id, old_units=rec_gully.units, new_units=NEW.units, old_groove=rec_gully.groove,
       			new_groove=NEW.groove, old_siphon=rec_gully.siphon, new_siphon=NEW.siphon, old_connec_matcat_id=rec_gully.connec_matcat_id,
       			new_connec_matcat_id=NEW.connec_matcat_id, old_connec_shape=rec_gully.shape, new_connec_shape=NEW.shape, 
       			old_connec_geom1=rec_gully.geom1, new_connec_geom1=NEW.connec_geom1, old_connec_geom2=rec_gully.geom2, 
       			new_connec_geom2=NEW.connec_geom2, old_connec_arccat_id=rec_gully.connec_arccat_id, old_featurecat_id=rec_gully.featurecat_id, 
       			new_featurecat_id=NEW.featurecat_id, old_feature_id=rec_gully.feature_id, new_feature_id=NEW.feature_id,
       			annotation=NEW.annotation, observ=NEW.observ,expl_id=NEW.expl_id, the_geom=NEW.the_geom, review_status_id=review_status_aux, 
       			field_date=now(), field_user=current_user
       			WHERE gully_id=NEW.gully_id;

			ELSE
			
				INSERT INTO review_audit_gully
				(gully_id, old_top_elev, new_top_elev, old_ymax, new_ymax, old_sandbox, new_sandbox, old_matcat_id, 
				new_matcat_id, new_gully_type, old_gully_type, old_gratecat_id,new_gratecat_id,old_units, new_units, old_groove, new_groove, old_siphon, 
				new_siphon, old_connec_matcat_id, new_connec_matcat_id,old_connec_shape, new_connec_shape, old_connec_geom1, 
				new_connec_geom1, old_connec_geom2, new_connec_geom2, old_featurecat_id, new_featurecat_id, old_feature_id, 
				new_feature_id,annotation, observ, expl_id, the_geom, review_status_id, field_date, field_user)
				VALUES (NEW.gully_id, rec_gully.top_elev, NEW.top_elev, rec_gully.ymax, NEW.ymax, rec_gully.sandbox, NEW.sandbox,
				rec_gully.matcat_id,NEW.matcat_id, rec_gully.gully_type, NEW.gully_type, rec_gully.gratecat_id, NEW.gratecat_id, rec_gully.units, NEW.units, rec_gully.groove, 
				NEW.groove, rec_gully.siphon, NEW.siphon, rec_gully.connec_matcat_id, NEW.connec_matcat_id,
				rec_gully.shape, NEW.connec_shape, rec_gully.geom1, NEW.connec_geom1, rec_gully.geom2, NEW.connec_geom2, 
				rec_gully.featurecat_id, NEW.featurecat_id, rec_gully.feature_id, NEW.feature_id, NEW.annotation, NEW.observ, 
				NEW.expl_id, NEW.the_geom, review_status_aux, now(), current_user);

			END IF;
				
		END IF;
		
    END IF;

    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;