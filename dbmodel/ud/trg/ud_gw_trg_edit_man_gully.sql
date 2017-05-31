/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_man_gully()  RETURNS trigger AS $BODY$
DECLARE 
    v_sql varchar;
	gully_geometry varchar;
    gully_id_seq int8;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	gully_geometry:= TG_ARGV[0];
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- gully ID
        IF (NEW.gully_id IS NULL) THEN
            SELECT max(gully_id::integer) INTO gully_id_seq FROM gully WHERE gully_id ~ '^\d+$';
            PERFORM setval('gully_seq',gully_id_seq,true);
            NEW.gully_id:= (SELECT nextval('gully_seq'));
        END IF;

        -- grate Catalog ID
        IF (NEW.gratecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_grate) = 0) THEN
                RETURN audit_function(152,850);
			END IF;
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,850); 
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,850); 
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,850); 
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,850); 
            END IF;
        END IF;

  	    -- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT state_vdefault FROM config);
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
		
		-- Workcat_id
        IF (NEW.workcat_id IS NULL) THEN
            NEW.workcat_id := (SELECT workcat_id_vdefault FROM config);
            IF (NEW.workcat_id IS NULL) THEN
                NEW.workcat_id := (SELECT id FROM cat_work limit 1);
            END IF;
        END IF;
		
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT verified_vdefault FROM config);
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;
		
		--Exploitation ID
        IF (NEW.expl_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(125,340);
				RETURN NULL;				
            END IF;
            NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (NEW.expl_id IS NULL) THEN
                --PERFORM audit_function(130,340);
				RETURN NULL; 
            END IF;
        END IF;	
	
		--Builtdate
		IF (NEW.builtdate IS NULL) THEN
			NEW.builtdate := (SELECT builtdate_vdefault FROM config);
		END IF;
		
        -- FEATURE INSERT
        IF gully_geometry = 'gully' THEN
        INSERT INTO gully (gully_id, top_elev, "ymax",sandbox, matcat_id, gratecat_id, units, groove, arccat_id, siphon, arc_id, sector_id, "state",annotation, "observ", "comment", rotation,dma_id, 
					soilcat_id, category_type, fluid_type, location_type, workcat_id, buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, link, verified, the_geom, workcat_id_end,
<<<<<<< Updated upstream
					undelete,featurecat_id, feature_id,label_x, label_y,label_rotation, code, expl_id, publish, inventory, end_date, streetaxis_id, postnumber)
					VALUES (NEW.gully_id, NEW.top_elev, NEW."ymax",NEW.sandbox, NEW.matcat_id, NEW.gratecat_id, NEW.units, NEW.groove, NEW.arccat_id, NEW.siphon, NEW.arc_id, NEW.sector_id, NEW."state", 
					NEW.annotation, NEW."observ", NEW."comment", NEW.rotation,NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                    NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, NEW.link, NEW.verified, NEW.the_geom, NEW.workcat_id_end,NEW.undelete,NEW.featurecat_id,
					NEW.feature_id,NEW.label_x, NEW.label_y,NEW.label_rotation, NEW.code, NEW.expl_id, NEW.publish, NEW.inventory, NEW.end_date, NEW.streetaxis_id, NEW.postnumber);
=======
					undelete,featurecat_id, feature_id,label_x, label_y,label_rotation, code, expl_id, publish, inventory, end_date, streetaxis_id, postnumber,  connec_length, connec_depth)
					VALUES (NEW.gully_id, NEW.top_elev, NEW."ymax",NEW.sandbox, NEW.matcat_id, NEW.gratecat_id, NEW.units, NEW.groove, NEW.arccat_id, NEW.siphon, NEW.arc_id, NEW.sector_id, NEW."state", 
					NEW.annotation, NEW."observ", NEW."comment", NEW.rotation,NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                    NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, NEW.link, NEW.verified, NEW.the_geom, NEW.workcat_id_end,NEW.undelete,NEW.featurecat_id,
					NEW.feature_id,NEW.label_x, NEW.label_y,NEW.label_rotation, NEW.code, NEW.expl_id, NEW.publish, NEW.inventory, NEW.end_date, NEW.streetaxis_id, NEW.postnumber, NEW.connec_length, NEW.connec_depth);
>>>>>>> Stashed changes

        ELSIF gully_geometry = 'pgully' THEN
        INSERT INTO gully (gully_id, top_elev, "ymax",sandbox, matcat_id, gratecat_id, units, groove, arccat_id, siphon, arc_id,sector_id, "state", annotation, "observ", "comment", rotation,
                    dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, link, verified, the_geom_pol, workcat_id_end,undelete,featurecat_id, feature_id,label_x, label_y,label_rotation, code, expl_id, publish, inventory, end_date, streetaxis_id, postnumber)
					VALUES (NEW.gully_id, NEW.top_elev, NEW."ymax",NEW.sandbox, NEW.matcat_id, NEW.gratecat_id, NEW.units, NEW.groove, NEW.arccat_id, NEW.siphon, NEW.arc_id, NEW.sector_id, NEW."state", 
					NEW.annotation, NEW."observ", NEW."comment", NEW.rotation, NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                    NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, NEW.link, NEW.verified, NEW.the_geom, NEW.workcat_id_end,NEW.undelete, NEW.featurecat_id, NEW.feature_id,
					NEW.label_x, NEW.label_y,NEW.label_rotation,  NEW.code, NEW.expl_id, NEW.publish, NEW.inventory, NEW.end_date, NEW.streetaxis_id, NEW.postnumber);
        END IF;    


		PERFORM audit_function (1,850);
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

        -- UPDATE dma/sector
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
        END IF;


        -- UPDATE values
		IF gully_geometry = 'gully' THEN
			UPDATE gully 
			SET gully_id=NEW.gully_id, top_elev=NEW.top_elev, ymax=NEW."ymax", sandbox=NEW.sandbox, matcat_id=NEW.matcat_id, gratecat_id=NEW.gratecat_id, units=NEW.units, groove=NEW.groove, arccat_id=NEW.arccat_id, 
			siphon=NEW.siphon, arc_id=NEW.arc_id, sector_id=NEW.sector_id, "state"=NEW."state",  annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, 
			category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom,workcat_id_end=NEW.workcat_id_end,undelete=NEW.undelete,featurecat_id=NEW.featurecat_id, feature_id=NEW.feature_id,
			label_x=NEW.label_x, label_y=NEW.label_y,label_rotation=NEW.label_rotation,  code=NEW.code, expl_id=NEW.expl_id, publish=NEW.publish, inventory=NEW.inventory, 
<<<<<<< Updated upstream
			end_date=NEW.end_date, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber
=======
			end_date=NEW.end_date, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber,  connec_length=NEW.connec_length, connec_depth=NEW.connec_depth
>>>>>>> Stashed changes
			WHERE gully_id = OLD.gully_id;

        ELSIF gully_geometry = 'pgully' THEN
			UPDATE gully 
			SET gully_id=NEW.gully_id, top_elev=NEW.top_elev, ymax=NEW."ymax", sandbox=NEW.sandbox, matcat_id=NEW.matcat_id, gratecat_id=NEW.gratecat_id, units=NEW.units, groove=NEW.groove, arccat_id=NEW.arccat_id, 
			siphon=NEW.siphon, arc_id=NEW.arc_id, sector_id=NEW.sector_id, "state"=NEW."state",  annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id,
			category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom_pol=NEW.the_geom,workcat_id_end=NEW.workcat_id_end,undelete=NEW.undelete,featurecat_id=NEW.featurecat_id, feature_id=NEW.feature_id,
			label_x=NEW.label_x, label_y=NEW.label_y,label_rotation=NEW.label_rotation, code=NEW.code, expl_id=NEW.expl_id, publish=NEW.publish, inventory=NEW.inventory, 
<<<<<<< Updated upstream
			end_date=NEW.end_date, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber
=======
			end_date=NEW.end_date, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber,  connec_length=NEW.connec_length, connec_depth=NEW.connec_depth

>>>>>>> Stashed changes
			WHERE gully_id = OLD.gully_id;
        END IF;  
                
		PERFORM audit_function (2,850);
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM gully WHERE gully_id = OLD.gully_id;

		PERFORM audit_function (3,850);
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




DROP TRIGGER IF EXISTS gw_trg_edit_man_gully ON "SCHEMA_NAME".v_edit_man_gully;
CREATE TRIGGER gw_trg_edit_man_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_gully(gully);


DROP TRIGGER IF EXISTS gw_trg_edit_man_gully ON "SCHEMA_NAME".v_edit_man_pgully;
CREATE TRIGGER gw_trg_edit_man_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pgully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_gully(pgully);

