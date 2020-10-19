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
	v_connect record;
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
	v_arc_id text;
	v_userdefined_geom boolean;
	v_end_state integer;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_mantable:= TG_ARGV[0];
	
	v_link_searchbuffer=0.01; 	

	-- control of project type
	SELECT project_type INTO v_projectype FROM sys_version LIMIT 1;
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
     
        -- link ID
	IF (NEW.link_id IS NULL) THEN
		NEW.link_id:= (SELECT nextval('link_link_id_seq'));
	END IF;			
	
		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := 1;
            END IF;
        END IF;
	END IF;	
        
    -- topology control
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
	
		-- control of relationship with connec / gully
		SELECT * INTO v_connect FROM v_edit_connec WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom, v_link_searchbuffer) AND state>0
		ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;
		
		IF v_projectype = 'UD' AND v_connect.connec_id IS NULL THEN
			SELECT * INTO v_connect FROM v_edit_gully WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom, v_link_searchbuffer) AND state>0
			ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;
		END IF;

		IF v_connect IS NULL THEN

			NEW.the_geom = ST_reverse (NEW.the_geom);

			-- check control again
			SELECT * INTO v_connect FROM v_edit_connec WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom, v_link_searchbuffer) AND state>0
			ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;
		
			IF v_projectype = 'UD' THEN
				SELECT * INTO v_connect FROM v_edit_gully WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom, v_link_searchbuffer) AND state>0
				ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;
			END IF;
			
			IF v_connect IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3070", "function":"1116","debug_msg":null}}$$);';
			END IF;		
		END IF;

		-- arc as end point
		SELECT * INTO v_arc FROM v_edit_arc WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_arc.the_geom, v_link_searchbuffer) AND state>0
		ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_arc.the_geom) LIMIT 1;
		
		-- node as end point
		SELECT * INTO v_node FROM v_edit_node WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_node.the_geom, v_link_searchbuffer) AND state>0
		ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_node.the_geom) LIMIT 1;
		
		
		-- for ws projects control of link related to nodarc
		IF v_projectype = 'WS' AND v_node IS NOT NULL THEN
			IF v_node.node_id IN (SELECT node_id FROM inp_valve UNION SELECT node_id FROM inp_pump) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3072", "function":"1116","debug_msg":null}}$$);';
			END IF;
		END IF;
		
		-- connec as init point
		SELECT * INTO v_connec1 FROM v_edit_connec WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom,v_link_searchbuffer) AND state>0 
		ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;

		-- connec as end point
		SELECT * INTO v_connec2 FROM v_edit_connec WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_connec.the_geom,v_link_searchbuffer) AND state>0
		ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;

			IF v_projectype='UD' then
		
				--gully as init point
				SELECT * INTO v_gully1 FROM v_edit_gully WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom,v_link_searchbuffer) 
				AND state>0 ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;

				--gully as end point
				SELECT * INTO v_gully2 FROM v_edit_gully WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_gully.the_geom,v_link_searchbuffer) 
				AND state>0 ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;
	
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
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3074", "function":"1116","debug_msg":null}}$$);';
		END IF;	

		-- end control
		IF ( v_arc.arc_id IS NOT NULL AND v_node.node_id IS NULL) THEN
		
			-- end point of link geometry
			v_end_point = (ST_ClosestPoint(v_arc.the_geom, ST_EndPoint(NEW.the_geom)));
			v_end_state= v_arc.state;
			
			-- vnode
			SELECT * INTO v_vnode FROM vnode WHERE ST_DWithin(v_end_point, vnode.the_geom, 0.01) LIMIT 1;
				
			IF v_vnode.vnode_id IS NULL THEN -- there is no vnode on the new position

				v_node_id = (select vnode_id FROM vnode WHERE vnode_id::text = NEW.exit_id AND NEW.exit_type='VNODE');

				IF v_node_id IS NULL THEN -- there is no vnode existing linked				
					INSERT INTO vnode (state, the_geom) 
					VALUES (v_arc.state, v_end_point) RETURNING vnode_id INTO v_node_id;			
				END IF;
			ELSE
				v_end_point = v_vnode.the_geom;
				v_node_id = v_vnode.vnode_id;
			END IF;
			
			--update connec or plan_psector_x_connec.arc_id
			IF NEW.ispsectorgeom IS NOT TRUE THEN
				UPDATE connec SET arc_id=v_arc.arc_id, featurecat_id=v_arc.arc_type, feature_id=v_arc.arc_id, 
				expl_id=v_arc.expl_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, pjoint_type='VNODE', pjoint_id=v_node_id
				WHERE connec_id=v_connec1.connec_id;
			ELSIF NEW.ispsectorgeom IS TRUE THEN
				UPDATE plan_psector_x_connec SET arc_id=v_arc.arc_id WHERE plan_psector_x_connec.id=NEW.psector_rowid;
			END IF;

			-- specific updates for projectype
			IF v_projectype='UD' THEN
			
				--update gully or plan_psector_x_gully.arc_id
				IF NEW.ispsectorgeom IS NOT TRUE THEN
					UPDATE gully SET arc_id=v_arc.arc_id, featurecat_id=v_arc.arc_type, feature_id=v_arc.arc_id,
					expl_id=v_arc.expl_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, pjoint_type='VNODE', pjoint_id=v_node_id
					WHERE gully_id=v_gully1.gully_id;
				ELSIF NEW.ispsectorgeom IS TRUE THEN
					UPDATE plan_psector_x_gully SET arc_id=v_arc.arc_id WHERE plan_psector_x_gully.id=NEW.psector_rowid;
				END IF;
				
			ELSIF v_projectype='WS' AND NEW.ispsectorgeom IS NOT TRUE THEN
				UPDATE connec SET presszone_id = v_arc.presszone_id, dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id
				WHERE connec_id=v_connec1.connec_id;
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

			--update connec or plan_psector_x_connec.arc_id
			IF NEW.ispsectorgeom IS NOT TRUE THEN
				UPDATE connec SET arc_id=v_arc.arc_id, featurecat_id=v_node.node_type, feature_id=v_node.node_id,
				expl_id=v_node.expl_id, dma_id=v_node.dma_id, sector_id=v_node.sector_id, pjoint_type='NODE', pjoint_id=v_node.node_id
				WHERE connec_id=v_connec1.connec_id;
			ELSIF NEW.ispsectorgeom IS TRUE THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3082", "function":"1116","debug_msg":"'||NEW.feature_id||'"}}$$);';
			END IF;
			
			-- specific updates for projectype
			IF v_projectype='UD' THEN
			
				--update gully or plan_psector_x_gully.arc_id
				IF NEW.ispsectorgeom IS NOT TRUE THEN
					UPDATE gully SET arc_id=v_arc.arc_id, featurecat_id=v_node.node_type, feature_id=v_node.node_id,
					expl_id=v_node.expl_id, dma_id=v_node.dma_id, sector_id=v_node.sector_id, pjoint_type='NODE', pjoint_id=v_node.node_id
					WHERE gully_id=v_gully1.gully_id;
				ELSIF NEW.ispsectorgeom IS TRUE THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3082", "function":"1116","debug_msg":"'||NEW.feature_id||'"}}$$);';				
				END IF;
				
			ELSIF v_projectype='WS' AND NEW.ispsectorgeom IS NOT TRUE THEN
				UPDATE connec SET presszone_id = v_arc.presszone_id, dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id
				WHERE connec_id=v_connec1.connec_id;
				
			END IF;
				
			NEW.exit_type='NODE';
			NEW.exit_id=v_node.node_id;
			v_end_point = v_node.the_geom;
			v_end_state= v_node.state;
		
		ELSIF v_connec2.connec_id IS NOT NULL THEN

			--update connec or plan_psector_x_connec.arc_id
			IF NEW.ispsectorgeom IS NOT TRUE THEN
				UPDATE connec SET arc_id=v_connec2.arc_id, expl_id=v_connec2.expl_id, feature_id=v_connec2.connec_id, featurecat_id=v_connec2.connec_type, dma_id=v_connec2.dma_id, 
				sector_id=v_connec2.sector_id, pjoint_type=v_connec2.pjoint_type, pjoint_id=v_connec2.pjoint_id
				WHERE connec_id=v_connec1.connec_id;
			ELSIF NEW.ispsectorgeom IS TRUE THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3082", "function":"1116","debug_msg":"'||NEW.feature_id||'"}}$$);';
			END IF;
				
			-- specific updates for projectype
			IF v_projectype='UD' THEN
			
				--update gully or plan_psector_x_gully.arc_id
				IF NEW.ispsectorgeom IS NOT TRUE THEN
					UPDATE gully SET arc_id=v_connec2.arc_id, expl_id=v_connec2.expl_id, feature_id=v_connec2.connec_id, featurecat_id=v_connec2.connec_type, dma_id=v_connec2.dma_id, 
					sector_id=v_connec2.sector_id, pjoint_type=v_connec2.pjoint_type, pjoint_id=v_connec2.pjoint_id
					WHERE gully_id=v_gully1.gully_id;
				ELSIF NEW.ispsectorgeom IS TRUE THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3082", "function":"1116","debug_msg":"'||NEW.feature_id||'"}}$$);';				
				END IF;
		
			ELSIF v_projectype='WS' AND NEW.ispsectorgeom IS NOT TRUE THEN
				UPDATE connec SET presszone_id = v_connec2.presszone_id, dqa_id=v_connec2.dqa_id, minsector_id=v_connec2.minsector_id
				WHERE connec_id=v_connec1.connec_id;	
			END IF;
		
			NEW.exit_type='CONNEC';
			NEW.exit_id=v_connec2.connec_id;
			v_end_point = v_connec2.the_geom;
			v_end_state= v_connec2.state;
		END IF;
		
		IF v_projectype='UD' THEN
			IF v_gully2.gully_id IS NOT NULL THEN

				--update gully or plan_psector_x_gully.arc_id
				IF NEW.ispsectorgeom IS NOT TRUE THEN
					UPDATE gully SET arc_id=v_gully2.arc_id, expl_id=v_gully2.expl_id, feature_id=v_gully2.gully_id, featurecat_id=v_gully2.gully_type, dma_id=v_gully2.dma_id, 
					sector_id=v_gully2.sector_id, pjoint_type=v_gully2.pjoint_type, pjoint_id=v_gully2.pjoint_id
					WHERE gully_id=v_gully1.gully_id;
					
					UPDATE connec SET arc_id=v_gully2.arc_id, expl_id=v_gully2.expl_id, feature_id=v_gully2.gully_id, featurecat_id=v_gully2.gully_type, dma_id=v_gully2.dma_id, 
					sector_id=v_gully2.sector_id, pjoint_type=v_gully2.pjoint_type, pjoint_id=v_gully2.pjoint_id
					WHERE connec_id=v_connec1.connec_id;
				ELSIF NEW.ispsectorgeom IS TRUE THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3082", "function":"1116","debug_msg":"'||NEW.feature_id||'"}}$$);';
				END IF;
							
				NEW.exit_type='GULLY';
				NEW.exit_id=v_gully2.gully_id;
				v_end_point = v_gully2.the_geom;
				v_end_state = v_gully2.state;
			END IF;
		END IF;
		
		-- control of null exit_type
		IF NEW.exit_type IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"2015", "function":"1116","debug_msg":null}}$$);';
		END IF;
		
		-- upsert link
		NEW.the_geom = (ST_SetPoint(NEW.the_geom, (ST_NumPoints(NEW.the_geom)-1), v_end_point));

	END IF;
	
	
	-- upsert process
		
	IF TG_OP ='INSERT' THEN
		-- exception control. It's no possible to create another link when already exists for the connect
		IF (SELECT feature_id FROM link WHERE feature_id=NEW.feature_id) IS NOT NULL THEN
			IF NEW.feature_type = 'CONNEC' THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       			"data":{"message":"3076", "function":"1116","debug_msg":"'||NEW.feature_id||'"}}$$);';
			ELSIF NEW.feature_type = 'GULLY' THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       			"data":{"message":"3078", "function":"1116","debug_msg":"'||NEW.feature_id||'"}}$$);';
			END IF;		
		END IF;

		-- state control
		IF v_connect.state=1 AND v_end_state=2 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       		"data":{"message":"3080", "function":"1116","debug_msg":"'||NEW.feature_id||'"}}$$);';
		END IF;
		

		INSERT INTO link (link_id, feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, 
		state, the_geom, vnode_topelev)	
		VALUES (NEW.link_id, NEW.feature_type, NEW.feature_id, v_arc.expl_id, NEW.exit_id, NEW.exit_type, TRUE,
		NEW.state, NEW.the_geom, NEW.vnode_topelev );
		
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN 
				
		IF NEW.ispsectorgeom IS NOT TRUE THEN -- if geometry comes from link table

			IF st_equals (OLD.the_geom, NEW.the_geom) IS FALSE THEN
				UPDATE link SET userdefined_geom='TRUE', exit_id = NEW.exit_id , exit_type = NEW.exit_type, 
				the_geom=NEW.the_geom, vnode_topelev = NEW.vnode_topelev WHERE link_id=NEW.link_id;
				UPDATE vnode SET the_geom=St_endpoint(NEW.the_geom) WHERE vnode_id=NEW.exit_id::integer;
			END IF;
						
		ELSE -- if geometry comes from psector_plan tables then 
			
			-- if geometry have changed by user 
			IF st_equals (OLD.the_geom, NEW.the_geom) IS FALSE THEN
				v_userdefined_geom  = TRUE;
				v_end_point = ST_EndPoint(NEW.the_geom);
			ELSE 
				v_userdefined_geom  = FALSE;

			END IF;

			IF v_projectype = 'WS' THEN
				UPDATE plan_psector_x_connec SET link_geom = NEW.the_geom, vnode_geom=v_end_point, userdefined_geom = v_userdefined_geom
				WHERE plan_psector_x_connec.id=NEW.psector_rowid;
			
			ELSIF v_projectype = 'UD' THEN
					
				IF NEW.feature_type='CONNEC' THEN
					UPDATE plan_psector_x_connec SET link_geom = NEW.the_geom, vnode_geom=v_end_point, userdefined_geom = v_userdefined_geom
					WHERE plan_psector_x_connec.id=NEW.psector_rowid;
				ELSIF NEW.feature_type='GULLY' THEN
					UPDATE plan_psector_x_gully SET link_geom = NEW.the_geom, vnode_geom=v_end_point, userdefined_geom = v_userdefined_geom
					WHERE plan_psector_x_gully.id=NEW.psector_rowid;
				END IF;
				
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
		
		IF OLD.ispsectorgeom IS FALSE THEN -- if geometry comes from link table
			DELETE FROM link WHERE link_id = OLD.link_id;

			IF OLD.exit_type='VNODE' THEN
				-- delete vnode if no more links are related to vnode
				SELECT count(exit_id) INTO v_count FROM link WHERE exit_id=OLD.exit_id;	
							
				IF v_count < 2 THEN -- only 1 link or cero exists
					DELETE FROM vnode WHERE  vnode_id::text=OLD.exit_id;
				END IF;
			END IF;
			
		ELSE
			IF v_projectype = 'WS' THEN
				UPDATE plan_psector_x_connec SET link_geom = NULL, userdefined_geom = NULL, vnode_geom=NULL, arc_id=NULL
				WHERE plan_psector_x_connec.id=OLD.psector_rowid;
			
			ELSIF v_projectype = 'UD' THEN
				IF OLD.feature_type='CONNEC' THEN
					UPDATE plan_psector_x_connec SET link_geom = NULL, userdefined_geom = NULL, vnode_geom=NULL, arc_id=NULL
					WHERE plan_psector_x_connec.id=OLD.psector_rowid;
				ELSIF OLD.feature_type='GULLY' THEN
					UPDATE plan_psector_x_gully SET link_geom = NULL, userdefined_geom = NULL, vnode_geom=NULL, arc_id=NULL
					WHERE plan_psector_x_gully.id=OLD.psector_rowid;
				END IF;
			END IF;
		END IF;

		-- update arc_id of connect
		IF OLD.feature_type='CONNEC' THEN
			UPDATE connec SET arc_id=NULL WHERE connec_id = OLD.feature_id;
		ELSIF OLD.feature_type='GULLY' THEN
			UPDATE gully SET arc_id=NULL WHERE gully_id = OLD.feature_id;
		END IF;
						
		RETURN NULL;
	   
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
