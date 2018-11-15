/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1304


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_connec() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_sql varchar;
    connec_id_seq int8;
	count_aux integer;
	promixity_buffer_aux double precision;
	new_connec_type_aux text;
	old_connec_type_aux text;
	query_text text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	promixity_buffer_aux = (SELECT "value" FROM config_param_system WHERE "parameter"='proximity_buffer');
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- connec ID
        IF (NEW.connec_id IS NULL) THEN
           -- PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.connec_id:= (SELECT nextval('urn_id_seq'));
        END IF;

        -- connec Catalog ID
        IF (NEW.connecat_id IS NULL) THEN
            PERFORM audit_function(1022,1304); 
            RETURN NULL;                   
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1304);  
			END IF;
				SELECT count(*)into count_aux FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001);
			IF count_aux = 1 THEN
				NEW.sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
			ELSIF count_aux > 1 THEN
				NEW.sector_id =(SELECT sector_id FROM v_edit_node WHERE ST_DWithin(NEW.the_geom, v_edit_node.the_geom, promixity_buffer_aux) 
				order by ST_Distance (NEW.the_geom, v_edit_node.the_geom) LIMIT 1);
			END IF;	
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1304,NEW.connec_id);          
            END IF;            
        END IF;
        
	-- Dma ID
        IF (NEW.dma_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1304);  
            END IF;
				SELECT count(*)into count_aux FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001);
			IF count_aux = 1 THEN
				NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			ELSIF count_aux > 1 THEN
				NEW.dma_id =(SELECT dma_id FROM v_edit_node WHERE ST_DWithin(NEW.the_geom, v_edit_node.the_geom, promixity_buffer_aux) 
				order by ST_Distance (NEW.the_geom, v_edit_node.the_geom) LIMIT 1);
			END IF;
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF; 
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1304,NEW.connec_id);  
            END IF;            
        END IF;
		
		-- Workcat_id
        IF (NEW.workcat_id IS NULL) THEN
            NEW.workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- Ownercat_id
        IF (NEW.ownercat_id IS NULL) THEN
            NEW.ownercat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='ownercat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- Soilcat_id
        IF (NEW.soilcat_id IS NULL) THEN
            NEW.soilcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='soilcat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- Presszone
        IF (NEW.presszonecat_id IS NULL) THEN
            NEW.presszonecat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='presszone_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;

		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
	-- State_type
	IF (NEW.state_type IS NULL) THEN
	   NEW.state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='statetype_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;

		--Inventory
		IF (NEW.inventory IS NULL) THEN
			NEW.inventory :='TRUE';
		END IF; 
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1304,NEW.connec_id);
				END IF;		
			END IF;
		END IF;

		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			NEW.muni_id := (SELECT "value" FROM config_param_user WHERE "parameter"='municipality_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			IF (NEW.muni_id IS NULL) THEN
				NEW.muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) LIMIT 1);
				IF (NEW.muni_id IS NULL) THEN
					PERFORM audit_function(2024,1304,NEW.connec_id);
				END IF;	
			END IF;
		END IF;
  
		-- Builtdate
			IF (NEW.builtdate IS NULL) THEN
				NEW.builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;  
			
			
	    -- LINK
	    IF (SELECT "value" FROM config_param_system WHERE "parameter"='edit_automatic_insert_link')::boolean=TRUE THEN
	       NEW.link=NEW.connec_id;
	    END IF;

		
        -- FEATURE INSERT
		INSERT INTO connec (connec_id, code, elevation, depth,connecat_id,  sector_id, customer_code,  state, state_type, annotation, observ, comment,dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, 
		workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, muni_id, streetaxis_id, postcode, postcomplement, postcomplement2, descript, link, verified, rotation, the_geom, undelete, label_x,label_y,label_rotation,
		expl_id, publish, inventory,num_value, connec_length, arc_id) 
		VALUES (NEW.connec_id, NEW.code, NEW.elevation, NEW.depth, NEW.connecat_id, NEW.sector_id, NEW.customer_code,  NEW.state, NEW.state_type, NEW.annotation,   NEW.observ, NEW.comment, NEW.dma_id, NEW.presszonecat_id, NEW.soilcat_id, 
		NEW.function_type, NEW.category_type, NEW.fluid_type,  NEW.location_type, NEW.workcat_id, NEW.workcat_id_end,  NEW.buildercat_id, NEW.builtdate, NEW.enddate, NEW.ownercat_id, NEW.streetaxis2_id, NEW.postnumber, NEW.postnumber2, 
		NEW.muni_id, NEW.streetaxis_id, NEW.postcode, NEW.postcomplement, NEW.postcomplement2, NEW.descript, NEW.link, NEW.verified, NEW.rotation, NEW.the_geom,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,  NEW.expl_id, NEW.publish, NEW.inventory, NEW.num_value, NEW.connec_length, NEW.arc_id);
		 
		
		-- Control of automatic insert of link and vnode
		IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_connect_force_automatic_connect2network' 
		AND cur_user=current_user LIMIT 1) IS TRUE THEN
			PERFORM gw_fct_connect_to_network((select array_agg(NEW.connec_id)), 'CONNEC');
		END IF;
			 
		RETURN NEW;
	

    ELSIF TG_OP = 'UPDATE' THEN

        -- Connec type
    	IF (NEW.connecat_id != OLD.connecat_id) THEN
			new_connec_type_aux= (SELECT type FROM connec_type JOIN cat_connec ON connec_type.id=connectype_id where cat_connec.id=NEW.connecat_id);
			old_connec_type_aux= (SELECT type FROM connec_type JOIN cat_connec ON connec_type.id=connectype_id where cat_connec.id=OLD.connecat_id);
			IF new_connec_type_aux != old_connec_type_aux THEN
				query_text='INSERT INTO man_'||lower(new_connec_type_aux)||' (connec_id) VALUES ('||NEW.connec_id||')';
				EXECUTE query_text;
				query_text='DELETE FROM man_'||lower(old_connec_type_aux)||' WHERE connec_id='||quote_literal(OLD.connec_id);
				EXECUTE query_text;
			END IF;
		END IF;

       -- UPDATE geom/dma/sector/expl_id
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
		UPDATE connec SET the_geom=NEW.the_geom WHERE connec_id=NEW.connec_id;
		NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
		NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
		NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);         			
        END IF;
		
		
		-- Reconnect arc_id
		IF NEW.arc_id != OLD.arc_id OR OLD.arc_id IS NULL THEN
			UPDATE connec SET arc_id=NEW.arc_id where connec_id=NEW.connec_id;
			IF (SELECT link_id FROM link WHERE feature_id=NEW.connec_id AND feature_type='CONNEC' LIMIT 1) IS NOT NULL THEN
				UPDATE vnode SET vnode_type='AUTO' WHERE vnode_id=(SELECT exit_id FROM link WHERE feature_id=NEW.connec_id AND exit_type='VNODE' LIMIT 1)::int8;
				PERFORM gw_fct_connect_to_network((select array_agg(NEW.connec_id)), 'CONNEC');
			ELSIF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_connect_force_automatic_connect2network' AND cur_user=current_user LIMIT 1) IS TRUE THEN
				PERFORM gw_fct_connect_to_network((select array_agg(NEW.connec_id)), 'CONNEC');
			END IF;
		END IF;
		
		-- State_type
		IF NEW.state=0 AND OLD.state=1 THEN
			IF (SELECT state FROM value_state_type WHERE id=NEW.state_type) != NEW.state THEN
			NEW.state_type=(SELECT "value" FROM config_param_user WHERE parameter='statetype_end_vdefault' AND "cur_user"="current_user"() LIMIT 1);
				IF NEW.state_type IS NULL THEN
				NEW.state_type=(SELECT id from value_state_type WHERE state=0 LIMIT 1);
					IF NEW.state_type IS NULL THEN
					RETURN audit_function(2110,1318);
					END IF;
				END IF;
			END IF;
			
			-- Control of automatic downgrade of associated link/vnode
			IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_connect_force_downgrade_linkvnode' 
			AND cur_user=current_user LIMIT 1) IS TRUE THEN	
				UPDATE link SET state=0 WHERE feature_id=OLD.connec_id;
				UPDATE vnode SET state=0 WHERE vnode_id=(SELECT exit_id FROM link WHERE feature_id=OLD.connec_id LIMIT 1)::integer;
			END IF;
			
		END IF;

         -- Looking for state control
        IF (NEW.state != OLD.state) THEN   
			PERFORM gw_fct_state_control('CONNEC', NEW.connec_id, NEW.state, TG_OP);	
		END IF;

				
		UPDATE connec 
			SET code=NEW.code, elevation=NEW.elevation, "depth"=NEW.depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.customer_code,
			connec_length=NEW.connec_length, "state"=NEW.state, state_type=NEW.state_type, annotation=NEW.annotation, observ=NEW.observ, "comment"=NEW.comment, dma_id=NEW.dma_id, 
			presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, 
			workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, streetaxis2_id=NEW.streetaxis2_id, 
			postnumber2=NEW.postnumber2, muni_id=NEW.muni_id, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber, descript=NEW.descript,  rotation=NEW.rotation, verified=NEW.verified, 
			postcomplement=NEW.postcomplement, postcomplement2=NEW.postcomplement2,undelete=NEW.undelete, label_x=NEW.label_x,label_y=NEW.label_y, label_rotation=NEW.label_rotation,
			publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.num_value
			WHERE connec_id=OLD.connec_id;
      
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
	
		PERFORM gw_fct_check_delete(OLD.connec_id, 'CONNEC');

        DELETE FROM connec WHERE connec_id = OLD.connec_id;

        RETURN NULL;
   
    END IF;

END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".v_edit_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec();

      