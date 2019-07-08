/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1116

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_link()
  RETURNS trigger AS
$BODY$

DECLARE 
	v_mantable varchar;
	v_projectype varchar;
	v_arc record;
	v_node record;
	v_connec1 record;
	v_gully1 record;
	v_connec2 record;
	v_gully2 record;
	v_vnode record;
	v_end_point public.geometry;
	v_link_searchbuffer double precision;
	v_count integer;
	v_node_id integer;
	
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_mantable:= TG_ARGV[0];

	v_link_searchbuffer=0.05;

	-- control of project type
	SELECT wsoftware INTO v_projectype FROM version LIMIT 1;
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
     
        -- link ID
		IF (NEW.link_id IS NULL) THEN
			NEW.link_id:= (SELECT nextval('link_link_id_seq'));
		END IF;			
		
        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1116); 
            END IF;
			NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"());
			END IF;
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1116,NEW.link_id::text); 
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1116); 
            END IF;
			NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"());
			END IF; 
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1116,NEW.link_id::text); 
            END IF;
        END IF;

		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := 1;
            END IF;
        END IF;
	
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1116,NEW.link_id::text);
				END IF;		
			END IF;
		END IF;		
    END IF;
    
    -- topology control
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
	
		-- arc as end point
		SELECT * INTO v_arc FROM v_edit_arc WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_arc.the_geom, v_link_searchbuffer) AND state=1
		ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_arc.the_geom) LIMIT 1;
		
		-- node as end point
		SELECT * INTO v_node FROM v_edit_node WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_node.the_geom, v_link_searchbuffer) AND state=1
		ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_node.the_geom) LIMIT 1;
		
		-- connec as init point
		SELECT * INTO v_connec1 FROM v_edit_connec WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom,v_link_searchbuffer) AND state=1 
		ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;

		-- connec as end point
		SELECT * INTO v_connec2 FROM v_edit_connec WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_connec.the_geom,v_link_searchbuffer) AND state=1
		ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;

		IF v_projectype='UD' then
	
			--gully as init point
			SELECT * INTO v_gully1 FROM v_edit_gully WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom,v_link_searchbuffer) 
			AND state=1 ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;

			--gully as end point
			SELECT * INTO v_gully2 FROM v_edit_gully WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_gully.the_geom,v_link_searchbuffer) 
			AND state=1 ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;
	
			IF v_gully1.gully_id IS NOT NULL THEN
				NEW.feature_id=v_gully1.gully_id;
				NEW.feature_type='GULLY';
			END IF;
		END IF;
				
		IF v_connec1.connec_id IS NOT NULL THEN
			NEW.feature_id=v_connec1.connec_id;
			NEW.feature_type='CONNEC';
		END IF;
	
		-- feature control
		IF NEW.feature_type IS NULL THEN
			RAISE EXCEPTION 'It is mandatory to connect as init point one connec or gully with link';
		END IF;	
	
		-- end control
		IF ( v_arc.arc_id IS NOT NULL AND v_node.node_id IS NULL) THEN
	
			-- end point of link geometry
			v_end_point = (ST_ClosestPoint(v_arc.the_geom, ST_EndPoint(NEW.the_geom)));
				
			-- vnode
			SELECT * INTO v_vnode FROM vnode WHERE ST_DWithin(v_end_point, vnode.the_geom, 0.01) LIMIT 1;
	
			IF v_vnode.vnode_id IS NULL THEN
				INSERT INTO vnode (vnode_id, state, expl_id, sector_id, dma_id, vnode_type, the_geom) 
				VALUES ((SELECT nextval('vnode_vnode_id_seq')), v_arc.state, v_arc.expl_id, v_arc.sector_id, v_arc.dma_id, 'AUTO', v_end_point) RETURNING vnode_id INTO v_node_id;
			ELSE
				v_end_point = v_vnode.the_geom;
			END IF;
	
			IF v_projectype='UD' then
				-- Update connec or gully arc_id
				IF v_gully1.gully_id IS NOT NULL  THEN
					UPDATE gully SET arc_id=v_arc.arc_id , feature_id=v_arc.arc_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id
					WHERE gully_id=v_gully1.gully_id;
					
				ELSIF v_connec1.connec_id IS NOT NULL THEN
					UPDATE connec SET arc_id=v_arc.arc_id , feature_id=v_arc.arc_id, featurecat_id=v_arc.arc_type, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id
					WHERE connec_id=v_connec1.connec_id;
				END IF;	
			ELSE 
				UPDATE connec SET arc_id=v_arc.arc_id WHERE connec_id=v_connec1.connec_id;
				UPDATE connec SET feature_id=v_arc.arc_id, featurecat_id=v_arc.cat_arctype_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, presszonecat_id = v_arc.presszonecat_id,
				dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id WHERE connec_id=v_connec1.connec_id;
			END IF;
	
			NEW.exit_type='VNODE';
			NEW.exit_id=v_node_id;
			
	
		ELSIF v_node.node_id IS NOT NULL THEN
	
			-- get arc values
			SELECT * INTO v_arc FROM arc WHERE node_1=v_node.node_id LIMIT 1;
			
			-- in case of null values for arc_id (i.e. node sink where there are only entry arcs)
			IF v_arc.arc_id IS NULL THEN
				SELECT * INTO v_arc FROM arc WHERE node_2=v_node.node_id LIMIT 1;
			END IF;
			
			IF v_projectype='UD' then
				-- Update connec or gully arc_id
				IF v_gully1.gully_id IS NOT NULL  THEN
					UPDATE gully SET arc_id=v_arc.arc_id , feature_id=v_node.node_id, featurecat_id=v_node.node_type
					WHERE gully_id=v_gully1.gully_id;
	
				ELSIF v_connec1.connec_id IS NOT NULL AND v_projectype='UD' THEN
					UPDATE connec SET arc_id=v_arc.arc_id , feature_id=v_node.node_id, featurecat_id=v_node.node_type, dma_id=v_node.dma_id, sector_id=v_node.sector_id
					WHERE connec_id=v_connec1.connec_id;				
				END IF;
			ELSE
				UPDATE connec SET arc_id=v_arc.arc_id WHERE connec_id=v_connec1.connec_id;
				UPDATE connec SET feature_id=v_node.node_id, featurecat_id=v_node.nodetype_id, dma_id=v_node.dma_id, sector_id=v_node.sector_id, presszonecat_id = v_node.presszonecat_id,
				dqa_id=v_node.dqa_id, minsector_id=v_node.minsector_id WHERE connec_id=v_connec1.connec_id;
			END IF;
			
			NEW.exit_type='NODE';
			NEW.exit_id=v_node.node_id;
			v_end_point = v_node.the_geom;
	
		ELSIF v_connec2.connec_id IS NOT NULL THEN
	
			-- update arc values
			SELECT arc_id INTO v_arc.arc_id FROM connec WHERE connec_id=v_connec2.connec_id;
	
			IF v_projectype='UD' then
				UPDATE gully SET arc_id=v_arc.arc_id , feature_id=v_connec2.connec_id, featurecat_id=v_connec2.connec_type, dma_id=v_connec2.dma_id, sector_id=v_connec2.sector_id
				WHERE gully_id=v_gully1.gully_id;
	
				UPDATE connec SET arc_id=v_arc.arc_id, feature_id=v_connec2.connec_id, featurecat_id=v_connec2.connec_type, dma_id=v_connec2.dma_id, sector_id=v_connec2.sector_id
				WHERE connec_id=v_connec1.connec_id;
			ELSE 
				UPDATE connec SET arc_id=v_arc.arc_id WHERE connec_id=v_connec1.connec_id;
				UPDATE connec SET feature_id=v_connec2.connec_id, featurecat_id=v_connec2.connectype_id, dma_id=v_connec2.dma_id, sector_id=v_connec2.sector_id, 
				presszonecat_id = v_connec2.presszonecat_id, dqa_id=v_connec2.dqa_id, minsector_id=v_connec2.minsector_id WHERE connec_id=v_connec1.connec_id;
			END IF;
	
			NEW.exit_type='CONNEC';
			NEW.exit_id=v_connec2.connec_id;
			v_end_point = v_connec2.the_geom;
		END IF;
	
		IF v_projectype='UD' THEN
			IF v_gully2.gully_id IS NOT NULL THEN
						
				-- update arc values
				SELECT arc_id INTO v_arc.arc_id FROM gully WHERE gully_id=v_gully2.gully_id;
	
				UPDATE connec SET arc_id=v_arc.arc_id, feature_id=v_gully2.gully_id, featurecat_id=v_gully2.gully_type, dma_id=v_gully2.dma_id, sector_id=v_gully2.sector_id
				WHERE connec_id=v_connec1.connec_id;
	
				UPDATE gully SET arc_id=v_arc.arc_id, feature_id=v_gully2.gully_id, featurecat_id=v_gully2.gully_type, dma_id=v_gully2.dma_id, sector_id=v_gully2.sector_id
				WHERE gully_id=v_gully1.gully_id;
					
				NEW.exit_type='GULLY';
				NEW.exit_id=v_gully2.gully_id;
				v_end_point = v_gully2.the_geom;
			END IF;
		END IF;
	
		-- control of null exit_type
		IF NEW.exit_type IS NULL THEN
			PERFORM audit_function(2015,1116);
		END IF;
	
		-- upsert link
		NEW.the_geom = (ST_SetPoint(NEW.the_geom, (ST_NumPoints(NEW.the_geom)-1), v_end_point));
	
		IF TG_OP ='INSERT' THEN
			INSERT INTO link (link_id, feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom)
			VALUES (NEW.link_id, NEW.feature_type, NEW.feature_id, NEW.expl_id, NEW.exit_id, NEW.exit_type, TRUE, NEW.state, NEW.the_geom);
		
		ELSIF TG_OP = 'UPDATE' THEN 
				
			IF st_equals (NEW.the_geom, (SELECT the_geom FROM link WHERE link_id=NEW.link_id)) THEN -- if geometry comes from link table
				
				UPDATE link SET userdefined_geom='TRUE', state=NEW.state, exit_id=NEW.exit_id, exit_type=NEW.exit_type, the_geom=NEW.the_geom 
				WHERE link_id=NEW.link_id;				
				
			ELSE -- if geometry comes from psector_plan tables then 
				-- update link
				UPDATE link SET userdefined_geom='TRUE', state=NEW.state, exit_id=NEW.exit_id, exit_type=NEW.exit_type 
				WHERE link_id=NEW.link_id;
				
				-- update psector tables
				IF v_projectype = 'UD' THEN
					UPDATE plan_psector_x_gully SET link_geom = NEW.the_geom FROM v_edit_gully 
					WHERE plan_psector_x_gully.gully_id=NEW.feature_id AND plan_psector_x_gully.arc_id=v_edit_gully.arc_id;
				END IF;
	
				UPDATE plan_psector_x_connec SET link_geom = NEW.the_geom FROM v_edit_connec 
				WHERE plan_psector_x_connec.connec_id=NEW.feature_id AND plan_psector_x_connec.arc_id=v_edit_connec.arc_id;
			END IF;
		
		END IF;
					
		-- Update state_type if edit_connect_update_statetype is TRUE
		IF (SELECT ((value::json->>'connec')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
		
			UPDATE connec SET state_type = (SELECT ((value::json->>'connec')::json->>'state_type')::int2 
			FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE connec_id=v_connec1.connec_id;

			IF v_projectype = 'UD' THEN
				UPDATE gully SET state_type = (SELECT ((value::json->>'gully')::json->>'state_type')::int2 
				FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE gully_id=v_gully1.gully_id;
			END IF;
		END IF;
	
		RETURN NEW;
						
	ELSIF TG_OP = 'DELETE' THEN
	
		IF OLD.exit_type='VNODE' THEN

			-- delete vnode if no more links are related to vnode
			SELECT count(exit_id) INTO v_count FROM link WHERE exit_id=OLD.exit_id;
						
			IF v_count < 2 THEN -- only 1 link or cero exists
				DELETE FROM vnode WHERE  vnode_id::text=OLD.exit_id;
			END IF;
		END IF;
		
        DELETE FROM link WHERE link_id = OLD.link_id;
					
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

