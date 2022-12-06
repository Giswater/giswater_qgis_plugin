/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1116

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_link()
  RETURNS trigger AS
$BODY$

/*
There are three diferent workflows to create and manage links:

- gw_fct_setlinktonetwork function that creates link as automatic way, works only with links class 1.

- gw_fct_setarcfusion & gw_fct_setarcdivide functions that updates values of related connect using the spatial intersection of existing link and works with links class 1,3

- trg_edit_link to create custom links (only class-1) and to update automatic links (class-1, 2 or 3).
  In addition, workflow for this function is complex managing with planned network elements. Works with links class 1,2,3 and acts in combination with:

	- trg_plan_psector_link, This trigger CREATES the initial geometry of planned link (always forced for planned connects) creating always as class-3. Also UPDATES the link
      and vnode geometry on the psector tables if link is class-3. In additaionn works in combination with arc_id (to relate arc_id endfeature)
	
	- control for link class, keeping for the rules of links class-2 and class-3
	- trg_plan_psector_x_connec: This trigger controls if connect has link and wich class of link it has
	- trg_plan_psector_x_gully: This trigger controls if connect has link and wich class of link it has
	
	Redraw links when endfeature geometry is updated:
	- trg_connect_update: This trigger updates mapzone connect columns (if endpoint of link is another connec or gully) 
	  and redraws link geometry if also its geometry is updated. Works with 1,2 class links
	- trg_topocontrol_node: It updates geometry links if the geometry of node is updated. It updates arc_id of connect if this changes
	- trg_arc_vnodelink_update: This function redraws links when arc geometry is updated
	
To create new link only with this tool only is possible with operative connects. When a planned connects is created automatic his link is also created.
After that the trg_edit_link can update geometry and enpoint. By updating endpoint maybe link may change class for 3 to 2 or viceversa	

*/

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
v_link_searchbuffer double precision;
v_count integer;
v_node_id integer;
v_arc_id text;
v_userdefined_geom boolean;
v_end_state integer;
v_init_state integer;
v_autoupdate_dma boolean;
v_pjoint_id text;
v_pjoint_type text;
v_dsbl_error boolean;
v_message text;
v_ispresszone boolean;
v_fluidtype text;
v_expl integer;
v_sector integer;
v_presszone text;
v_dma integer;
v_dqa integer;
v_minsector integer;
v_currentpsector integer;
v_state_vdefault integer;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_mantable:= TG_ARGV[0];
	
	v_link_searchbuffer=0.1; 	
	
	-- getting system values
	SELECT value::boolean INTO v_autoupdate_dma FROM config_param_system WHERE parameter='edit_connect_autoupdate_dma';
	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_disable_error' ;
	SELECT project_type INTO v_projectype FROM sys_version LIMIT 1;
	v_ispresszone:= (SELECT value::json->>'PRESSZONE' FROM config_param_system WHERE parameter = 'utils_graphanalytics_status');
	v_currentpsector = (SELECT value::integer from config_param_user WHERE cur_user = current_user AND parameter = 'plan_psector_vdefault');

	-- profilactic control of state
	v_state_vdefault = (SELECT value::integer from config_param_user WHERE cur_user = current_user AND parameter = 'edit_state_vdefault');
	IF NEW.state IS NULL THEN NEW.state = v_state_vdefault; END IF;

	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN
     
		-- link ID
		IF (NEW.link_id IS NULL) THEN
			NEW.link_id:= (SELECT nextval('link_link_id_seq'));
		END IF;	

		-- State control of element
		IF (NEW.state IS NULL) THEN
			NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_state_vdefault' AND "cur_user"="current_user"());
			IF (NEW.state IS NULL) THEN
				NEW.state := 1;
			END IF;
		END IF;
	END IF;	

	NEW.exit_type = NULL;
        
	-- topology control
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

		-- temporary disable linktonetwork
		UPDATE config_param_user SET value='TRUE' WHERE parameter = 'edit_connec_disable_linktonetwork' AND cur_user = current_user;

		-- control of relationship with connec / gully
		SELECT * INTO v_connect FROM connec WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), connec.the_geom, v_link_searchbuffer) 
		ORDER BY CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, st_distance(ST_StartPoint(NEW.the_geom), connec.the_geom) LIMIT 1;
		
		IF v_projectype = 'UD' AND v_connect.connec_id IS NULL THEN
			SELECT * INTO v_connect FROM gully WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), gully.the_geom, v_link_searchbuffer) 
			ORDER BY CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, st_distance(ST_StartPoint(NEW.the_geom), gully.the_geom) LIMIT 1;
		END IF;

		IF v_connect IS NULL THEN

			NEW.the_geom = ST_reverse (NEW.the_geom);

			-- check control again
			SELECT * INTO v_connect FROM connec WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), connec.the_geom, v_link_searchbuffer) 
			ORDER BY CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, st_distance(ST_StartPoint(NEW.the_geom), connec.the_geom) LIMIT 1;
		
			IF v_projectype = 'UD' THEN
				SELECT * INTO v_connect FROM gully WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), gully.the_geom, v_link_searchbuffer) 
				ORDER BY CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, st_distance(ST_StartPoint(NEW.the_geom), gully.the_geom) LIMIT 1;
			END IF;
			
			IF v_connect IS NULL THEN
				IF v_dsbl_error IS NOT TRUE THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3070", "function":"1116","debug_msg":null}}$$);';
				ELSE
					SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3070;
					INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
				END IF;
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
				IF v_dsbl_error IS NOT TRUE THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3072", "function":"1116","debug_msg":null}}$$);';
				ELSE
					SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3072;
					INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
				END IF;		
			END IF;
		END IF;
		
		-- connec as init point
		SELECT * INTO v_connec1 FROM v_edit_connec WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom,v_link_searchbuffer) AND state>0 
		ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;

		-- connec as end point
		SELECT * INTO v_connec2 FROM v_edit_connec WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_connec.the_geom,v_link_searchbuffer) AND state>0 AND connec_id != v_connec1.connec_id
		ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;

			IF v_projectype='UD' then
		
				--gully as init point
				SELECT * INTO v_gully1 FROM v_edit_gully WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom,v_link_searchbuffer) 
				AND state>0 ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;

				--gully as end point
				SELECT * INTO v_gully2 FROM v_edit_gully WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_gully.the_geom,v_link_searchbuffer) 
				AND state>0 AND gully_id != v_gully1.gully_id ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;
	
				IF v_gully1.gully_id IS NOT NULL THEN
					NEW.feature_id=v_gully1.gully_id;
					NEW.feature_type='GULLY';
					v_init_state = v_gully1.state;
				END IF;
			END IF;
				
		IF v_connec1.connec_id IS NOT NULL THEN
			NEW.feature_id=v_connec1.connec_id;
			NEW.feature_type='CONNEC';
			v_init_state = v_connec1.state;
		END IF;

		--look for obsolete features if init point not found
		IF NEW.feature_type IS NULL THEN
			INSERT INTO selector_state VALUES (0, current_user) ON CONFLICT (state_id, cur_user) DO NOTHING;

			SELECT * INTO v_connec1 FROM connec WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), connec.the_geom,v_link_searchbuffer) AND state=0 
			ORDER by st_distance(ST_StartPoint(NEW.the_geom), connec.the_geom) LIMIT 1;

			IF v_projectype='UD' then
				SELECT * INTO v_gully1 FROM v_edit_gully WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom,v_link_searchbuffer) 
				AND state=0 ORDER by st_distance(ST_StartPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;
				IF v_gully1.gully_id IS NOT NULL THEN
					NEW.feature_id=v_gully1.gully_id;
					NEW.feature_type='GULLY';
					NEW.state = 0;
				END IF;
			END IF;
			
			IF v_connec1.connec_id IS NOT NULL THEN
				NEW.feature_id=v_connec1.connec_id;
				NEW.feature_type='CONNEC';
				NEW.state = 0;
			END IF;
		END IF;

		-- feature control
		IF NEW.feature_type IS NULL THEN
			IF v_dsbl_error IS NOT TRUE THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3074", "function":"1116","debug_msg":null}}$$);';
			ELSE
				SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3074;
				INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
			END IF;
		END IF;	
		
		--for links related to state 0  features look again for final feature if its null
		IF NEW.state = 0 THEN
			INSERT INTO selector_state VALUES (0, current_user) ON CONFLICT (state_id, cur_user) DO NOTHING;

			IF v_arc IS NULL THEN 
				-- arc as end point
				SELECT * INTO v_arc FROM v_edit_arc WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_arc.the_geom, v_link_searchbuffer) AND state=0
				ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_arc.the_geom) LIMIT 1;
			END IF;
			
			IF v_node IS NULL THEN 
				-- node as end point
				SELECT * INTO v_node FROM v_edit_node WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_node.the_geom, v_link_searchbuffer) AND state=0
				ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_node.the_geom) LIMIT 1;
			END IF;
			
			IF v_connec2 IS NULL THEN 
				-- connec as end point
				SELECT * INTO v_connec2 FROM v_edit_connec WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_connec.the_geom,v_link_searchbuffer) AND state=0
				ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_connec.the_geom) LIMIT 1;
			END IF;
			
			IF v_gully2 IS NULL THEN
				--gully as end point
				SELECT * INTO v_gully2 FROM v_edit_gully WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), v_edit_gully.the_geom,v_link_searchbuffer) AND state=0 
				ORDER by st_distance(ST_EndPoint(NEW.the_geom), v_edit_gully.the_geom) LIMIT 1;
			END IF;
		END IF;

		-- end control
		IF ( v_arc.arc_id IS NOT NULL AND v_node.node_id IS NULL) THEN
			
			-- generic updates
			IF NEW.state = 1 THEN
				IF v_autoupdate_dma IS FALSE THEN
					UPDATE v_edit_connec SET arc_id=v_arc.arc_id,  
					expl_id=v_arc.expl_id, sector_id=v_arc.sector_id, pjoint_type='ARC', pjoint_id=v_arc.arc_id
					WHERE connec_id=v_connec1.connec_id;
				ELSE
					UPDATE v_edit_connec SET arc_id=v_arc.arc_id, 
					expl_id=v_arc.expl_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, pjoint_type='ARC', pjoint_id=v_arc.arc_id
					WHERE connec_id=v_connec1.connec_id;
				END IF;
			END IF;

			-- specific updates for projectype
			IF v_projectype='UD' THEN
			
				--update gully or plan_psector_x_gully.arc_id
				IF NEW.state = 1 THEN
					IF v_autoupdate_dma IS FALSE THEN
						UPDATE v_edit_gully SET arc_id=v_arc.arc_id, 
						expl_id=v_arc.expl_id, sector_id=v_arc.sector_id, pjoint_type='ARC', pjoint_id=v_arc.arc_id
						WHERE gully_id=v_gully1.gully_id;
					ELSE
						UPDATE v_edit_gully SET arc_id=v_arc.arc_id, 
						expl_id=v_arc.expl_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, pjoint_type='ARC', pjoint_id=v_arc.arc_id
						WHERE gully_id=v_gully1.gully_id;
					END IF;
				END IF;
				
			ELSIF v_projectype='WS' AND NEW.state = 1 THEN
			
				UPDATE connec SET presszone_id = v_arc.presszone_id, dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id WHERE connec_id=v_connec1.connec_id;
				
				IF v_ispresszone THEN
					UPDATE connec SET staticpressure = ((SELECT head from presszone WHERE presszone_id = v_arc.presszone_id)- v_connec1.elevation) WHERE connec_id=v_connec1.connec_id;
				END IF;
			END IF;

			-- exit & pjoint objects (same-same)
			NEW.exit_id = v_arc.arc_id;
			NEW.exit_type = 'ARC';
			v_pjoint_id = NEW.exit_id;
			v_pjoint_type = NEW.exit_type;

			-- mapzones
			v_expl = v_arc.expl_id;
			v_arc_id = v_arc.arc_id;
			v_sector = v_arc.sector_id; 
			v_presszone = v_arc.presszone_id; 
			v_dma = v_arc.dma_id; 
			v_dqa = v_arc.dqa_id; 
			v_minsector = v_arc.minsector_id; 

			-- others
			v_fluidtype = v_arc.fluid_type;
			v_end_state= v_arc.state;			

		ELSIF v_node.node_id IS NOT NULL THEN
	
			-- get arc values
			SELECT * INTO v_arc FROM arc WHERE node_1=v_node.node_id LIMIT 1;
			
			-- in case of null values for arc_id (i.e. node sink where there are only entry arcs)
			IF v_arc.arc_id IS NULL THEN
				SELECT * INTO v_arc FROM arc WHERE node_2=v_node.node_id LIMIT 1;
			END IF;

			--update connec.arc_id
			IF NEW.state = 1 THEN
				IF v_autoupdate_dma IS FALSE THEN
					UPDATE v_edit_connec SET arc_id=v_arc.arc_id,
					expl_id=v_node.expl_id, sector_id=v_node.sector_id, pjoint_type='NODE', pjoint_id=v_node.node_id
					WHERE connec_id=v_connec1.connec_id;
				ELSE
					UPDATE v_edit_connec SET arc_id=v_arc.arc_id, 
					expl_id=v_node.expl_id, dma_id=v_node.dma_id, sector_id=v_node.sector_id, pjoint_type='NODE', pjoint_id=v_node.node_id
					WHERE connec_id=v_connec1.connec_id;
				END IF;
			END IF;
			
			-- specific updates for projectype
			IF v_projectype='UD' THEN
			
				--update gully or plan_psector_x_gully.arc_id
				IF NEW.state = 1 THEN
					IF v_autoupdate_dma IS FALSE THEN
						UPDATE v_edit_gully SET arc_id=v_arc.arc_id, 
						expl_id=v_node.expl_id, sector_id=v_node.sector_id, pjoint_type='NODE', pjoint_id=v_node.node_id
						WHERE gully_id=v_gully1.gully_id;
					ELSE
						UPDATE v_edit_gully SET arc_id=v_arc.arc_id,
						expl_id=v_node.expl_id, dma_id=v_node.dma_id, sector_id=v_node.sector_id, pjoint_type='NODE', pjoint_id=v_node.node_id
						WHERE gully_id=v_gully1.gully_id;

					END IF;
				END IF;
									
			ELSIF v_projectype='WS' AND NEW.state = 1 THEN
				UPDATE connec SET presszone_id = v_arc.presszone_id, dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id
				WHERE connec_id=v_connec1.connec_id;

				IF v_ispresszone THEN
					UPDATE connec SET staticpressure = ((SELECT head from presszone WHERE presszone_id = v_arc.presszone_id)- v_connec1.elevation) WHERE connec_id=v_connec1.connec_id;
				END IF;
			END IF;

			-- exit & pjoint objects (same-same)
			NEW.exit_id = v_node.node_id;
			NEW.exit_type = 'NODE';
			v_pjoint_id = NEW.exit_id;
			v_pjoint_type = NEW.exit_type;

			-- mapzones
			v_expl = v_node.expl_id;
			v_arc_id = v_node.arc_id;
			v_sector = v_node.sector_id; 
			v_presszone = v_node.presszone_id; 
			v_dma = v_node.dma_id; 
			v_dqa = v_node.dqa_id; 
			v_minsector = v_node.minsector_id; 

			-- others
			v_fluidtype = v_node.fluid_type;
			v_end_state= v_node.state;

			-- getting v_arc
			v_arc_id = (SELECT arc_id FROM arc WHERE state > 0 AND node_1 = v_node.node_id LIMIT 1);
			
			IF v_arc_id IS NULL AND NEW.state=0 THEN
				v_arc_id = (SELECT arc_id FROM arc WHERE state = 0 AND node_1 = v_node.node_id LIMIT 1);
			END IF;
			
		
		ELSIF v_connec2.connec_id IS NOT NULL THEN

			IF NEW.state = 1 THEN
				IF v_autoupdate_dma IS FALSE THEN
					UPDATE v_edit_connec SET arc_id=v_connec2.arc_id, expl_id=v_connec2.expl_id,
					sector_id=v_connec2.sector_id, pjoint_type=v_connec2.pjoint_type, pjoint_id=v_connec2.pjoint_id
					WHERE connec_id=v_connec1.connec_id;
				ELSE
					UPDATE v_edit_connec SET arc_id=v_connec2.arc_id, expl_id=v_connec2.expl_id, dma_id=v_connec2.dma_id, 
					sector_id=v_connec2.sector_id, pjoint_type=v_connec2.pjoint_type, pjoint_id=v_connec2.pjoint_id
					WHERE connec_id=v_connec1.connec_id;

				END IF;
			END IF;
				
			-- specific updates for projectype
			IF v_projectype='UD' THEN
			
				--update gully or plan_psector_x_gully.arc_id
				IF NEW.state = 1 THEN
					IF v_autoupdate_dma IS FALSE THEN
						UPDATE v_edit_gully SET arc_id=v_connec2.arc_id, expl_id=v_connec2.expl_id,
						sector_id=v_connec2.sector_id, pjoint_type=v_connec2.pjoint_type, pjoint_id=v_connec2.pjoint_id
						WHERE gully_id=v_gully1.gully_id;
					ELSE
						UPDATE v_edit_gully SET arc_id=v_connec2.arc_id, expl_id=v_connec2.expl_id, dma_id=v_connec2.dma_id, 
						sector_id=v_connec2.sector_id, pjoint_type=v_connec2.pjoint_type, pjoint_id=v_connec2.pjoint_id
						WHERE gully_id=v_gully1.gully_id;

					END IF;
				END IF;
		
			ELSIF v_projectype='WS' AND  NEW.state = 1 THEN
			
				UPDATE connec SET presszone_id = v_connec2.presszone_id, dqa_id=v_connec2.dqa_id, minsector_id=v_connec2.minsector_id
				WHERE connec_id=v_connec1.connec_id;
		
				IF v_ispresszone THEN
					UPDATE connec SET staticpressure = ((SELECT head from presszone WHERE presszone_id = v_connec2.presszone_id)- v_connec1.elevation) WHERE connec_id=v_connec1.connec_id;
				END IF;	
			END IF;

			-- exit & pjoint objects (same-same)
			NEW.exit_id = v_connec2.connec_id;
			NEW.exit_type = 'CONNEC';
			v_pjoint_id = NEW.exit_id;
			v_pjoint_type = NEW.exit_type;

			-- mapzones
			v_expl = v_connec2.expl_id;
			v_arc_id = v_connec2.arc_id;
			v_sector = v_connec2.sector_id; 
			v_presszone = v_connec2.presszone_id; 
			v_dma = v_connec2.dma_id; 
			v_dqa = v_connec2.dqa_id; 
			v_minsector = v_connec2.minsector_id; 

			-- others
			v_fluidtype = v_connec2.fluid_type;
			v_end_state= v_connec2.state;

		END IF;
		
		IF v_projectype='UD' THEN
		
			IF v_gully2.gully_id IS NOT NULL THEN

				--update gully or plan_psector_x_gully.arc_id
				IF NEW.state = 1 THEN
				
					IF v_autoupdate_dma IS FALSE THEN
						UPDATE v_edit_gully SET arc_id=v_gully2.arc_id, expl_id=v_gully2.expl_id, 
						sector_id=v_gully2.sector_id, pjoint_type=v_gully2.pjoint_type, pjoint_id=v_gully2.pjoint_id
						WHERE gully_id=v_gully1.gully_id;
						
						UPDATE v_edit_connec SET arc_id=v_gully2.arc_id, expl_id=v_gully2.expl_id, 
						sector_id=v_gully2.sector_id, pjoint_type=v_gully2.pjoint_type, pjoint_id=v_gully2.pjoint_id
						WHERE connec_id=v_connec1.connec_id;
					ELSE
						UPDATE v_edit_gully SET arc_id=v_gully2.arc_id, expl_id=v_gully2.expl_id,  dma_id=v_gully2.dma_id, 
						sector_id=v_gully2.sector_id, pjoint_type=v_gully2.pjoint_type, pjoint_id=v_gully2.pjoint_id
						WHERE gully_id=v_gully1.gully_id;
						
						UPDATE v_edit_connec SET arc_id=v_gully2.arc_id, expl_id=v_gully2.expl_id,  dma_id=v_gully2.dma_id, 
						sector_id=v_gully2.sector_id, pjoint_type=v_gully2.pjoint_type, pjoint_id=v_gully2.pjoint_id
						WHERE connec_id=v_connec1.connec_id;
					END IF;
				END IF;

				-- exit & pjoint objects (same-same)
				NEW.exit_id = v_gully2.gully_id;
				NEW.exit_type = 'GULLY';
				v_pjoint_id = NEW.exit_id;
				v_pjoint_type = NEW.exit_type;

				-- mapzones
				v_expl = v_gully2.expl_id;
				v_arc_id = v_gully2.arc_id;
				v_sector = v_gully2.sector_id; 
				v_dma = v_gully2.dma_id; 

				-- others
				v_fluidtype = v_gully2.fluid_type;
				v_end_state= v_gully2.state;
			END IF;
		END IF;
		
		-- control of null exit_type
		IF NEW.exit_type IS NULL THEN
		
			IF v_dsbl_error IS NOT TRUE THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"2015", "function":"1116","debug_msg":null}}$$);';
			ELSE
				SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 2015;
				INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
			END IF;
		END IF;

	END IF;

	-- link state control
	IF NEW.state = 1 THEN
	
		-- exception control. It's no possible to create another link when already exists for the connect
		IF (SELECT feature_id FROM link WHERE feature_id=NEW.feature_id AND link_id <> NEW.link_id AND state = 1) IS NOT NULL THEN
		
			IF NEW.feature_type = 'CONNEC' THEN
			
				IF v_dsbl_error IS NOT TRUE THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3076", "function":"1116","debug_msg":""}}$$);';
				ELSE
					SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3076;
					INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
				END IF;
		
			ELSIF NEW.feature_type = 'GULLY' THEN
			
				IF v_dsbl_error IS NOT TRUE THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3078", "function":"1116","debug_msg":""}}$$);';
				ELSE
					SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3078;
					INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
				END IF;
			END IF;		
		END IF;

	ELSIF NEW.state = 2 THEN

		-- looking for same psector
		IF NEW.feature_type =  'CONNEC' THEN
			SELECT count(*) INTO v_count FROM plan_psector_x_connec WHERE connec_id = NEW.feature_id AND psector_id =  v_currentpsector AND link_id <> NEW.link_id; 
		ELSIF NEW.feature_type =  'GULLY' THEN
			SELECT count(*) INTO v_count FROM plan_psector_x_gully WHERE gully_id = NEW.feature_id AND psector_id =  v_currentpsector AND link_id <> NEW.link_id;
		END IF;

		IF v_count > 1 THEN
			IF v_dsbl_error IS NOT TRUE THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3082", "function":"1116","debug_msg":null}}$$);';
			ELSE
				SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3082;
				INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
			END IF;
		END IF;
	END IF;

	-- end state control 
	IF v_init_state=2 THEN

		IF NEW.state = 1 THEN
			RAISE EXCEPTION 'It is impossible to add operative link from planned feature';
			
		ELSIF NEW.state = 2 THEN

			IF v_projectype = 'WS' THEN

				IF v_currentpsector NOT IN (SELECT psector_id FROM plan_psector_x_connec WHERE connec_id = NEW.feature_id) THEN
					IF v_dsbl_error IS NOT TRUE THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3178", "function":"1116","debug_msg":null}}$$);';
					ELSE
						SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3178;
						INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
					END IF;				   
				END IF;	
		
			ELSIF  v_projectype = 'UD' THEN
			
				IF v_currentpsector NOT IN (SELECT psector_id FROM plan_psector_x_connec WHERE connec_id = NEW.feature_id UNION SELECT psector_id FROM plan_psector_x_gully WHERE gully_id = NEW.feature_id) THEN
					IF v_dsbl_error IS NOT TRUE THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3178", "function":"1116","debug_msg":null}}$$);';
					ELSE
						SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3178;
						INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
					END IF;
				END IF;
			END IF;
		END IF;		
	END IF;

	-- end state control 
	IF v_end_state=2 THEN

		IF NEW.state = 1 THEN
			RAISE EXCEPTION 'It is impossible to add operative link to planned feature';

		ELSIF NEW.state = 2 THEN

			IF v_projectype = 'WS' THEN

				IF v_currentpsector NOT IN (SELECT psector_id FROM plan_psector_x_node WHERE node_id = NEW.exit_id
							    UNION
							    SELECT psector_id FROM plan_psector_x_arc WHERE arc_id = NEW.exit_id
							    UNION
							    SELECT psector_id FROM plan_psector_x_connec WHERE connec_id = NEW.exit_id) THEN
					IF v_dsbl_error IS NOT TRUE THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3178", "function":"1116","debug_msg":null}}$$);';
					ELSE
						SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3178;
						INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
					END IF;				   
				END IF;	
		
			ELSIF  v_projectype = 'UD' THEN
			
				IF v_currentpsector NOT IN (SELECT psector_id FROM plan_psector_x_node WHERE node_id = NEW.exit_id
							    UNION
							    SELECT psector_id FROM plan_psector_x_arc WHERE arc_id = NEW.exit_id
							    UNION
							    SELECT psector_id FROM plan_psector_x_connec WHERE connec_id = NEW.exit_id
							    UNION 
							    SELECT psector_id FROM plan_psector_x_gully WHERE gully_id = NEW.exit_id) THEN
					IF v_dsbl_error IS NOT TRUE THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3178", "function":"1116","debug_msg":null}}$$);';
					ELSE
						SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 3178;
						INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (394, NEW.link_id, v_message);
					END IF;
				END IF;
			END IF;
		END IF;		
	END IF;

	-- upsert process	
	IF TG_OP ='INSERT' THEN
		
		-- profilactic control in order to do not crash the mandatory column of expl_id
		IF v_expl is null then v_expl = NEW.expl_id; END IF;

		-- insert into link table
		IF v_projectype = 'WS' THEN
			INSERT INTO link (link_id, feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom, sector_id,
			 fluid_type, dma_id, dqa_id, presszone_id, minsector_id)
			VALUES (NEW.link_id, NEW.feature_type, NEW.feature_id, v_expl, NEW.exit_id, NEW.exit_type, TRUE, NEW.state, NEW.the_geom, v_sector, 
			v_fluidtype, v_dma, v_dqa, v_presszone, v_minsector);
			
		ELSIF  v_projectype = 'UD' THEN
			INSERT INTO link (link_id, feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom, sector_id, fluid_type, dma_id)
			VALUES (NEW.link_id, NEW.feature_type, NEW.feature_id, v_expl, NEW.exit_id, NEW.exit_type, TRUE, NEW.state, NEW.the_geom, v_sector, v_fluidtype, v_dma);
		END IF;

		-- update feature
		IF NEW.state = 1 THEN 
		
			IF NEW.feature_type='CONNEC' THEN
				UPDATE v_edit_connec SET arc_id = v_arc_id, pjoint_id = v_pjoint_id, pjoint_type = v_pjoint_type WHERE connec_id = NEW.feature_id;
			ELSIF NEW.feature_type='GULLY' THEN
				UPDATE v_edit_gully SET arc_id = v_arc_id, pjoint_id = v_pjoint_id, pjoint_type = v_pjoint_type WHERE gully_id = NEW.feature_id;
			END IF;

		ELSIF NEW.state = 2 THEN
		
			IF NEW.feature_type='CONNEC' THEN
				UPDATE plan_psector_x_connec SET link_id = NEW.link_id, arc_id = v_arc_id WHERE psector_id = v_currentpsector AND connec_id = NEW.feature_id;
				
			ELSIF NEW.feature_type='GULLY' THEN
				UPDATE plan_psector_x_gully SET link_id = NEW.link_id, arc_id = v_arc_id WHERE psector_id = v_currentpsector AND gully_id = NEW.feature_id;
			END IF;
		END IF;

		-- enable linktonetwork
		UPDATE config_param_user SET value='FALSE' WHERE parameter = 'edit_connec_disable_linktonetwork' AND cur_user = current_user;
		
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN 
				
		IF NEW.state = 1 AND st_equals (OLD.the_geom, NEW.the_geom) IS FALSE THEN

			-- update link
			UPDATE link SET userdefined_geom='TRUE', exit_id = NEW.exit_id , exit_type = NEW.exit_type, the_geom=NEW.the_geom, expl_id = v_expl, sector_id = v_sector, dma_id = v_dma 
			WHERE link_id=NEW.link_id;
			
			-- update specific colums for ws-link
			IF v_projectype = 'WS' THEN
				UPDATE link SET presszone_id = v_presszone, dqa_id = NEW.dqa_id, minsector_id = NEW.minsector_id WHERE link_id = NEW.link_id;
			END IF;	
		
			-- force reconnection on coonecs
			IF NEW.feature_type = 'CONNEC' THEN
				UPDATE connec SET arc_id = v_arc_id, pjoint_type = NEW.exit_type, pjoint_id = NEW.exit_id WHERE connec_id = NEW.feature_id;
								
			ELSIF NEW.feature_type = 'GULLY' THEN
				UPDATE gully SET arc_id = v_arc_id, pjoint_type = NEW.exit_type, pjoint_id = NEW.exit_id WHERE  gully_id = NEW.feature_id;
			END IF;
	
		ELSIF NEW.state = 2 AND st_equals (OLD.the_geom, NEW.the_geom) IS FALSE THEN

			-- update link
			UPDATE link SET exit_id = NEW.exit_id, exit_type = NEW.exit_type, userdefined_geom = true, the_geom = NEW.the_geom, expl_id = v_expl, sector_id = v_sector, dma_id = v_dma 
			WHERE link_id = NEW.link_id;

			-- update specific colums for ws-link
			IF v_projectype = 'WS' THEN
				UPDATE link SET presszone_id = v_presszone, dqa_id = NEW.dqa_id, minsector_id = NEW.minsector_id  WHERE link_id = NEW.link_id;
			END IF;	

			-- update values on plan_psector tables
			IF NEW.feature_type='CONNEC' THEN

				-- update plan_psector_x_connec
				UPDATE plan_psector_x_connec SET arc_id = v_arc_id WHERE plan_psector_x_connec.link_id=NEW.link_id;

			ELSIF NEW.feature_type='GULLY' THEN
			
				-- update plan_psector_x_gully
				UPDATE plan_psector_x_gully SET arc_id = v_arc_id WHERE plan_psector_x_gully.link_id=NEW.link_id;
			END IF;
		END IF;

		-- update link state
		UPDATE link SET state = NEW.state WHERE link_id=NEW.link_id;
	
		-- Update state_type if edit_connect_update_statetype is TRUE
		IF (SELECT ((value::json->>'connec')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
	
			UPDATE connec SET state_type = (SELECT ((value::json->>'connec')::json->>'state_type')::int2 
			FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE connec_id=v_connec1.connec_id;
	
			IF v_projectype = 'UD' THEN
				UPDATE gully SET state_type = (SELECT ((value::json->>'gully')::json->>'state_type')::int2 
				FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE gully_id=v_gully1.gully_id;
			END IF;
		END IF;

		-- restore linktonetwork
		UPDATE config_param_user SET value='FALSE' WHERE parameter = 'edit_connec_disable_linktonetwork' AND cur_user = current_user;

		RETURN NEW;
						
	ELSIF TG_OP = 'DELETE' THEN

		IF OLD.state = 1 THEN

			UPDATE connec SET arc_id = null, pjoint_id=NULL, pjoint_type = NULL WHERE OLD.feature_id = connec_id;
									
			IF OLD.feature_type='GULLY' THEN
				UPDATE gully SET arc_id = nullpjoint_id=NULL, pjoint_type = NULL where OLD.feature_id = gully_id;
			END IF;

			DELETE FROM link WHERE link_id = OLD.link_id;
			
		ELSIF  OLD.state = 2 THEN 
		
			UPDATE plan_psector_x_connec SET link_id = NULL, arc_id=NULL WHERE link_id = OLD.link_id;
						
			IF OLD.feature_type='GULLY' THEN
				UPDATE plan_psector_x_gully SET link_id = NULL, arc_id = NULL WHERE link_id = OLD.link_id;				
			END IF;
			
			DELETE FROM link WHERE link_id = OLD.link_id;
		END IF;

		RETURN NULL;	   

	END IF;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
