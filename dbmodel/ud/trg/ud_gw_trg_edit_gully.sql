/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_gully()
  RETURNS trigger AS
$BODY$
DECLARE 
    v_sql varchar;
	gully_geometry varchar;
    gully_id_seq int8;
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	gully_geometry:= TG_ARGV[0];
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- gully ID
        IF (NEW.gully_id IS NULL) THEN
            --PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.gully_id:= (SELECT nextval('urn_id_seq'));
        END IF;
		
        -- grate Catalog ID
        IF (NEW.gratecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_grate) = 0) THEN
                RETURN audit_function(152,780);
			END IF;
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,780); 
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,780); 
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,780); 
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,780); 
            END IF;
        END IF;
		
	    	-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;

		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
		
		-- Workcat_id
        IF (NEW.workcat_id IS NULL) THEN
            NEW.workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
            IF (NEW.workcat_id IS NULL) THEN
                NEW.workcat_id := (SELECT id FROM cat_work limit 1);
            END IF;
        END IF;
		

		--Builtdate
		IF (NEW.builtdate IS NULL) THEN
			NEW.builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;  
     
	--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(125,340);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                --PERFORM audit_function(130,340);
				RETURN NULL; 
            END IF;
		
		        -- FEATURE INSERT
 IF gully_geometry = 'gully' THEN
        INSERT INTO gully (gully_id, code, top_elev, "ymax",sandbox, matcat_id, gratecat_id, units, groove, connec_arccat_id, connec_length, connec_depth, siphon, arc_id, sector_id, "state",annotation, "observ", "comment", dma_id, 
					soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript,rotation, link, verified, the_geom,
					undelete,featurecat_id, feature_id,label_x, label_y,label_rotation, expl_id, publish, inventory,  streetaxis_id, postnumber,  uncertain,num_value)
					VALUES (NEW.gully_id, NEW.code, NEW.top_elev, NEW."ymax",NEW.sandbox, NEW.matcat_id, NEW.gratecat_id, NEW.units, NEW.groove, NEW.connec_arccat_id,  NEW.connec_length, NEW.connec_depth, NEW.siphon, NEW.arc_id, NEW.sector_id, NEW."state", 
					NEW.annotation, NEW."observ", NEW."comment", NEW.dma_id, NEW.soilcat_id, NEW.function_type, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id, NEW.builtdate, NEW.enddate, 
                    NEW.ownercat_id, NEW.address_01, NEW.address_02, NEW.address_03, NEW.descript, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom, NEW.undelete,NEW.featurecat_id,
					NEW.feature_id,NEW.label_x, NEW.label_y,NEW.label_rotation,  expl_id_int , NEW.publish, NEW.inventory, NEW.streetaxis_id, NEW.postnumber, NEW.uncertain,NEW.num_value);


        ELSIF gully_geometry = 'pgully' THEN
        INSERT INTO gully (gully_id, code,top_elev, "ymax",sandbox, matcat_id, gratecat_id, units, groove, connec_arccat_id, connec_length, connec_depth, siphon, arc_id,sector_id, "state", annotation, "observ", "comment", 
                    dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation, link, verified, the_geom_pol, undelete,featurecat_id, feature_id,label_x, label_y,label_rotation, expl_id, publish, inventory, streetaxis_id, postnumber, uncertain,num_value)
					VALUES (NEW.gully_id, NEW.code, NEW.top_elev, NEW."ymax",NEW.sandbox, NEW.matcat_id, NEW.gratecat_id, NEW.units, NEW.groove, NEW.connec_arccat_id,  NEW.connec_length, NEW.connec_depth, NEW.siphon, NEW.arc_id, NEW.sector_id, NEW."state", 
					NEW.annotation, NEW."observ", NEW."comment", NEW.rotation, NEW.dma_id, NEW.soilcat_id, NEW.function_type, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id, 
					NEW.builtdate, NEW.enddate,NEW.ownercat_id, NEW.address_01, NEW.address_02, NEW.address_03, NEW.descript, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom,NEW.undelete, NEW.featurecat_id, NEW.feature_id,
					NEW.label_x, NEW.label_y,NEW.label_rotation,  expl_id_int, NEW.publish, NEW.inventory, NEW.streetaxis_id, NEW.postnumber, NEW.uncertain, NEW.num_value);
        END IF;     


		--PERFORM audit_function (1,780);
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
			SET gully_id=NEW.gully_id, code=NEW.code, top_elev=NEW.top_elev, ymax=NEW."ymax", sandbox=NEW.sandbox, matcat_id=NEW.matcat_id, gratecat_id=NEW.gratecat_id, units=NEW.units, groove=NEW.groove, connec_arccat_id=NEW.connec_arccat_id, 
			connec_length=NEW.connec_length, connec_depth=NEW.connec_depth, siphon=NEW.siphon, arc_id=NEW.arc_id, sector_id=NEW.sector_id, "state"=NEW."state",  annotation=NEW.annotation, "observ"=NEW."observ", 
			"comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end,buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate,
            ownercat_id=NEW.ownercat_id, address_01=NEW.address_01, address_02=NEW.address_02, address_03=NEW.address_03, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom,undelete=NEW.undelete,featurecat_id=NEW.featurecat_id, feature_id=NEW.feature_id,
			label_x=NEW.label_x, label_y=NEW.label_y,label_rotation=NEW.label_rotation, publish=NEW.publish, inventory=NEW.inventory, 
			streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber,  expl_id=NEW.expl_id, uncertain=NEW.uncertain, num_value=NEW.num_value
			WHERE gully_id = OLD.gully_id;

        ELSIF gully_geometry = 'gully_pol' THEN
			UPDATE gully 
			SET gully_id=NEW.gully_id, code=NEW.code, top_elev=NEW.top_elev, ymax=NEW."ymax", sandbox=NEW.sandbox, matcat_id=NEW.matcat_id, gratecat_id=NEW.gratecat_id, units=NEW.units, groove=NEW.groove, connec_arccat_id=NEW.connec_arccat_id, 
			connec_length=NEW.connec_length, connec_depth=NEW.connec_depth, siphon=NEW.siphon, arc_id=NEW.arc_id, sector_id=NEW.sector_id, "state"=NEW."state",  annotation=NEW.annotation, "observ"=NEW."observ", 
			"comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate,
            ownercat_id=NEW.ownercat_id, address_01=NEW.address_01, address_02=NEW.address_02, address_03=NEW.address_03, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom_pol=NEW.the_geom,undelete=NEW.undelete,featurecat_id=NEW.featurecat_id, feature_id=NEW.feature_id,
			label_x=NEW.label_x, label_y=NEW.label_y,label_rotation=NEW.label_rotation, publish=NEW.publish, inventory=NEW.inventory, 
			 streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber,   expl_id=NEW.expl_id, uncertain=NEW.uncertain,num_value=NEW.num_value


			WHERE gully_id = OLD.gully_id;
        END IF;  
                
		--PERFORM audit_function (2,780);
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM gully WHERE gully_id = OLD.gully_id;

		--PERFORM audit_function (3,780);
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_gully ON "SCHEMA_NAME".v_edit_gully;
CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_gully(gully);


DROP TRIGGER IF EXISTS gw_trg_edit_gully ON "SCHEMA_NAME".v_edit_gully_pol;
CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_gully_pol
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_gully(gully_pol);

