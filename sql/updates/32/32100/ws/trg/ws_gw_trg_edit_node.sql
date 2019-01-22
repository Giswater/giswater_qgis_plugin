/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NODE: 1320

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_node() RETURNS trigger AS 
$BODY$
DECLARE 
    inp_table varchar;
    man_table varchar;
	new_man_table varchar;
	man_table_2 varchar;
	old_man_table varchar;
    v_sql varchar;
    old_nodetype varchar;
    new_nodetype varchar;
    node_id_seq int8;
	rec_aux text;
	node_id_aux text;
	tablename_aux varchar;
	pol_id_aux varchar;
	query_text text;
	count_aux integer;
	promixity_buffer_aux double precision;
	code_autofill_bool bool;
	new_node_type_aux text;
	old_node_type_aux text;
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	--Get data from config table
	promixity_buffer_aux = (SELECT "value" FROM config_param_system WHERE "parameter"='proximity_buffer');
    
	-- Control insertions ID
    IF TG_OP = 'INSERT' THEN
    
-- Node ID
		IF (NEW.node_id IS NULL) THEN
			--PERFORM setval('urn_id_seq', gw_fct_urn(),true);
			NEW.node_id:= (SELECT nextval('urn_id_seq'));
		END IF;

	-- code
		IF (NEW.code IS NULL AND code_autofill_bool IS TRUE) THEN 
			NEW.code=NEW.node_id;
		END IF;


	-- Node Catalog ID

		IF (NEW.nodecat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
               RETURN audit_function(1006,1320);  
			END IF;
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='nodecat_vdefault' AND "cur_user"="current_user"() LIMIT 1);

			IF (NEW.nodecat_id IS NULL) THEN
					NEW.nodecat_id:= (SELECT cat_node.id FROM cat_node JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE node_type.man_table=man_table_2 LIMIT 1);
			END IF;
		END IF;

      
         -- Epa type
		IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM cat_node JOIN node_type ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id LIMIT 1)::text;   
		END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1320);  
			END IF;
				SELECT count(*)into count_aux FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001);
			IF count_aux = 1 THEN
				NEW.sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
			ELSIF count_aux > 1 THEN
				NEW.sector_id =(SELECT sector_id FROM ve_node WHERE ST_DWithin(NEW.the_geom, ve_node.the_geom, promixity_buffer_aux) 
				order by ST_Distance (NEW.the_geom, ve_node.the_geom) LIMIT 1);
			END IF;	
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1320,NEW.node_id);          
            END IF;            
        END IF;
        
	-- Dma ID
        IF (NEW.dma_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1320);  
            END IF;
				SELECT count(*)into count_aux FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001);
			IF count_aux = 1 THEN
				NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			ELSIF count_aux > 1 THEN
				NEW.dma_id =(SELECT dma_id FROM ve_node WHERE ST_DWithin(NEW.the_geom, ve_node.the_geom, promixity_buffer_aux) 
				order by ST_Distance (NEW.the_geom, ve_node.the_geom) LIMIT 1);
			END IF;
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF; 
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1320,NEW.node_id);  
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
		
		--Inventory
		IF (NEW.inventory IS NULL) THEN
			NEW.inventory :='TRUE';
		END IF; 
		
		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- State_type
		IF (NEW.state_type IS NULL) THEN
			NEW.state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='statetype_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
        
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1320,NEW.node_id);
				END IF;		
			END IF;
		END IF;

		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			NEW.muni_id := (SELECT "value" FROM config_param_user WHERE "parameter"='municipality_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			IF (NEW.muni_id IS NULL) THEN
				NEW.muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) LIMIT 1);
				IF (NEW.muni_id IS NULL) THEN
					PERFORM audit_function(2024,1320,NEW.node_id);
				END IF;	
			END IF;
		END IF;
		
		-- Builtdate
		IF (NEW.builtdate IS NULL) THEN
			NEW.builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;  
		
		
		-- Parent id
		SELECT substring (tablename from 8 for 30), pol_id INTO tablename_aux, pol_id_aux FROM polygon JOIN sys_feature_cat ON sys_feature_cat.id=polygon.sys_type
		WHERE ST_DWithin(NEW.the_geom, polygon.the_geom, 0.001) LIMIT 1;
	
		IF pol_id_aux IS NOT NULL THEN
			query_text:= 'SELECT node_id FROM '||tablename_aux||' WHERE pol_id::integer='||pol_id_aux||' LIMIT 1';
			EXECUTE query_text INTO node_id_aux;
			NEW.parent_id=node_id_aux;
		END IF;

        
        -- FEATURE INSERT      
		INSERT INTO node (node_id, code, elevation, depth, nodecat_id, epa_type, sector_id, arc_id, parent_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, 
			location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, postcode, streetaxis2_id, postnumber, postnumber2, descript, rotation, verified, the_geom, undelete, 
			postcomplement, postcomplement2, label_x, label_y, label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
			VALUES (NEW.node_id, NEW.code, NEW.elevation, NEW.depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.arc_id, NEW.parent_id, NEW.state, NEW.state_type, NEW.annotation, NEW.observ, NEW.comment, 
			NEW.dma_id, NEW.presszonecat_id, NEW.soilcat_id, NEW.function_type,NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id, NEW.builtdate, NEW.enddate, NEW.ownercat_id,
			NEW.muni_id, NEW.streetaxis_id, NEW.postcode, NEW.streetaxis2_id, NEW.postnumber, NEW.postnumber2, NEW.descript, NEW.rotation, NEW.verified, NEW.the_geom,NEW.undelete,
			NEW.postcomplement, NEW.postcomplement2, NEW.label_x, NEW.label_y,NEW.label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.hemisphere, NEW.num_value);

        -- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN inp_table:= 'inp_junction';
        ELSIF (NEW.epa_type = 'TANK') THEN inp_table:= 'inp_tank';
        ELSIF (NEW.epa_type = 'RESERVOIR') THEN inp_table:= 'inp_reservoir';
        ELSIF (NEW.epa_type = 'PUMP') THEN inp_table:= 'inp_pump';
        ELSIF (NEW.epa_type = 'VALVE') THEN inp_table:= 'inp_valve';
        ELSIF (NEW.epa_type = 'SHORTPIPE') THEN inp_table:= 'inp_shortpipe';
        END IF;
        IF inp_table IS NOT NULL THEN        
            v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;
        END IF;

        -- MANAGEMENT INSERT
         man_table:= (SELECT node_type.man_table FROM node_type JOIN cat_node ON cat_node.id=NEW.nodecat_id WHERE node_type.id = cat_node.nodetype_id LIMIT 1)::text;

         
        IF man_table IS NOT NULL THEN
            v_sql:= 'INSERT INTO '||man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;
        END IF;

        --PERFORM audit_function(1,1320); 
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN


    -- UPDATE EPA values
        IF (NEW.epa_type != OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';                
            ELSIF (OLD.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';    
            ELSIF (OLD.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (OLD.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (OLD.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
                EXECUTE v_sql;
            END IF;
			inp_table := NULL;


            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';     
            ELSIF (NEW.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';  
            ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (NEW.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (NEW.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
                EXECUTE v_sql;
            END IF;
        END IF;



	-- UPDATE values


    	-- Node type
    	IF (NEW.nodecat_id != OLD.nodecat_id) THEN
			new_node_type_aux= (SELECT type FROM node_type JOIN cat_node ON node_type.id=nodetype_id where cat_node.id=NEW.nodecat_id);
			old_node_type_aux= (SELECT type FROM node_type JOIN cat_node ON node_type.id=nodetype_id where cat_node.id=OLD.nodecat_id);
			IF new_node_type_aux != old_node_type_aux THEN
				query_text='INSERT INTO man_'||lower(new_node_type_aux)||' (node_id) VALUES ('||NEW.node_id||')';
				EXECUTE query_text;
				query_text='DELETE FROM man_'||lower(old_node_type_aux)||' WHERE node_id='||quote_literal(OLD.node_id);
				EXECUTE query_text;
			END IF;
		END IF;

	
		-- State
		IF (NEW.state != OLD.state) THEN
			UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
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
		END IF;
	
		-- The geom
		IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom) THEN

			--the_geom
			UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;

			-- Parent id
			SELECT substring (tablename from 8 for 30), pol_id INTO tablename_aux, pol_id_aux FROM polygon JOIN sys_feature_cat ON sys_feature_cat.id=polygon.sys_type
			WHERE ST_DWithin(NEW.the_geom, polygon.the_geom, 0.001) LIMIT 1;
	
			IF pol_id_aux IS NOT NULL THEN
				query_text:= 'SELECT node_id FROM '||tablename_aux||' WHERE pol_id::integer='||pol_id_aux||' LIMIT 1';
				EXECUTE query_text INTO node_id_aux;
				NEW.parent_id=node_id_aux;
			END IF;
						
		END IF;
		
		--Label rotation
		IF (NEW.rotation != OLD.rotation) THEN
			UPDATE node SET rotation=NEW.rotation WHERE node_id = OLD.node_id;
		END IF;
		
		
		UPDATE node 
		SET code=NEW.code, elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, arc_id=NEW.arc_id, parent_id=NEW.parent_id, 		
		state_type=NEW.state_type, annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.soilcat_id, function_type=NEW.function_type,
		category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id,
		builtdate=NEW.builtdate, enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, muni_id=NEW.muni_id, streetaxis_id=NEW.streetaxis_id, postcode=NEW.postcode, streetaxis2_id=NEW.streetaxis2_id, postnumber=NEW.postnumber,
		postcomplement=NEW.postcomplement, postcomplement2=NEW.postcomplement2, postnumber2=NEW.postnumber2,descript=NEW.descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.label_x, label_y=NEW.label_y, label_rotation=NEW.label_rotation, 
		publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.hemisphere,num_value=NEW.num_value
		WHERE node_id = OLD.node_id;
            

        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN

		PERFORM gw_fct_check_delete(OLD.node_id, 'NODE');
    
        DELETE FROM node WHERE node_id = OLD.node_id;
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

