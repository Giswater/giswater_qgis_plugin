/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1244

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_topocontrol_arc()  RETURNS trigger AS
$BODY$

DECLARE 
nodeRecord1 Record; 
nodeRecord2 Record;
optionsRecord Record;
sys_elev1_aux double precision;
sys_elev2_aux double precision;
custom_elev1_aux double precision;
custom_elev2_aux double precision;
y_aux double precision;
vnoderec Record;
newPoint public.geometry;    
connecPoint public.geometry;
value1 boolean;
value2 boolean;
featurecat_aux text;
v_sys_statetopocontrol boolean;
sys_y1_aux double precision;
sys_y2_aux double precision;
sys_length_aux double precision;
geom_slp_direction_bool boolean;
connec_id_aux varchar;
gully_id_aux varchar;
array_agg varchar [];
v_projecttype text;
v_dsbl_error boolean;
v_samenode_init_end_control boolean;
v_nodeinsert_arcendpoint boolean;
v_node_proximity_control boolean;
v_node_proximity double precision;
v_arc_searchnodes_control boolean;
v_arc_searchnodes double precision;
v_user_dis_statetopocontrol boolean;
v_node2 text;
v_nodecat text;
v_keepdepthvalues boolean;

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
 
	-- Get system variables
 	SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;
	SELECT value::boolean INTO v_sys_statetopocontrol FROM config_param_system WHERE parameter='edit_state_topocontrol' ;
	SELECT value::boolean INTO geom_slp_direction_bool FROM config_param_system WHERE parameter='edit_slope_direction' ;
	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_disable_error' ;
   	SELECT value::boolean INTO v_samenode_init_end_control FROM config_param_system WHERE parameter='edit_arc_samenode_control' ;
	SELECT ((value::json)->>'activated') INTO v_arc_searchnodes_control FROM config_param_system WHERE parameter='edit_arc_searchnodes';
	SELECT ((value::json)->>'value') INTO v_arc_searchnodes FROM config_param_system WHERE parameter='edit_arc_searchnodes';
	
	-- Get user variables
	SELECT value::boolean INTO v_user_dis_statetopocontrol FROM config_param_user WHERE parameter='edit_disable_statetopocontrol' AND cur_user = current_user;
	SELECT value::boolean INTO v_nodeinsert_arcendpoint FROM config_param_user WHERE parameter='edit_arc_insert_automatic_endpoint' AND cur_user = current_user;
	SELECT value::boolean INTO v_keepdepthvalues FROM config_param_user WHERE parameter='edit_arc_keepdepthval_when_reverse_geom' AND cur_user = current_user;

	
	IF v_sys_statetopocontrol IS NOT TRUE OR v_user_dis_statetopocontrol IS TRUE THEN

		SELECT * INTO nodeRecord1 FROM node 
		JOIN cat_feature_node ON cat_feature_node.id = node_type
		WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes)
		ORDER BY (case when isarcdivide is true then 1 else 2 end), 
		ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;


		SELECT * INTO nodeRecord2 FROM node 
		JOIN cat_feature_node ON cat_feature_node.id = node_type 
		WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes)
		ORDER BY (case when isarcdivide is true then 1 else 2 end), 
		ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;
       
	ELSIF v_sys_statetopocontrol IS TRUE THEN
	
		-- Looking for state control
		PERFORM gw_fct_state_control('ARC', NEW.arc_id, NEW.state, TG_OP);
    
		-- Lookig for state=0
		IF NEW.state=0 THEN
			RAISE WARNING 'Topology is not enabled with state=0. The feature will be disconected of the network';
			RETURN NEW;
		END IF;
	
		-- Starting process
		IF TG_OP='INSERT' THEN

			SELECT * INTO nodeRecord1 FROM node 
			JOIN cat_feature_node ON cat_feature_node.id = node_type 
			WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes)
			AND ((NEW.state=1 AND node.state=1)
					-- looking for existing nodes that not belongs on the same alternatives that arc
					OR (NEW.state=2 AND node.state=1 AND node_id NOT IN 
						(SELECT node_id FROM plan_psector_x_node 
						 WHERE plan_psector_x_node.node_id=node.node_id AND state=0 AND psector_id = 
							(SELECT value::integer FROM config_param_user 
							WHERE parameter='plan_psector_vdefault' AND cur_user="current_user"() LIMIT 1 )))
					
					-- looking for planified nodes that belongs on the same alternatives that arc
					OR (NEW.state=2 AND node.state=2 AND node_id IN 
						(SELECT node_id FROM plan_psector_x_node 
						 WHERE plan_psector_x_node.node_id=node.node_id AND state=1 AND psector_id =
							(SELECT value::integer FROM config_param_user 
							WHERE parameter='plan_psector_vdefault' AND cur_user="current_user"() LIMIT 1))))

					ORDER BY (case when isarcdivide is true then 1 else 2 end),ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;
	
			SELECT * INTO nodeRecord2 FROM node 
			JOIN cat_feature_node ON cat_feature_node.id = node_type 
			WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes) 
			AND ((NEW.state=1 AND node.state=1)

					-- looking for existing nodes that not belongs on the same alternatives that arc
					OR (NEW.state=2 AND node.state=1 AND node_id NOT IN 
						(SELECT node_id FROM plan_psector_x_node 
						 WHERE plan_psector_x_node.node_id=node.node_id AND state=0 AND psector_id = 
							(SELECT value::integer FROM config_param_user 
							WHERE parameter='plan_psector_vdefault' AND cur_user="current_user"() LIMIT 1)))
					
					-- looking for planified nodes that belongs on the same alternatives that arc
					OR (NEW.state=2 AND node.state=2 AND node_id IN 
						(SELECT node_id FROM plan_psector_x_node 
						 WHERE plan_psector_x_node.node_id=node.node_id AND state=1 AND psector_id =
							(SELECT value::integer FROM config_param_user 
							WHERE parameter='plan_psector_vdefault' AND cur_user="current_user"() LIMIT 1 ))))

					ORDER BY (case when isarcdivide is true then 1 else 2 end), ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;

		ELSIF TG_OP='UPDATE' THEN

			SELECT * INTO nodeRecord1 FROM node 
			JOIN cat_feature_node ON cat_feature_node.id = node_type 
			WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes)
			AND ((NEW.state=1 AND node.state=1)

					-- looking for existing nodes that not belongs on the same alternatives that arc
					OR (NEW.state=2 AND node.state=1 AND node_id NOT IN 
						(SELECT node_id FROM plan_psector_x_node 
						 WHERE plan_psector_x_node.node_id=node.node_id AND  state=0 AND psector_id IN 
							(SELECT psector_id FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id)))
							

					-- looking for planified nodes that belongs on the same alternatives that arc
					OR (NEW.state=2 AND node.state=2 AND node_id IN 
						(SELECT node_id FROM plan_psector_x_node 
						 WHERE plan_psector_x_node.node_id=node.node_id AND  state=1 AND psector_id IN
							(SELECT psector_id FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id))))

					ORDER BY (case when isarcdivide is true then 1 else 2 end), ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;
	
			SELECT * INTO nodeRecord2 FROM node 
			JOIN cat_feature_node ON cat_feature_node.id = node_type 
			WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes) 
			AND ((NEW.state=1 AND node.state=1)

					-- looking for existing nodes that not belongs on the same alternatives that arc
					OR (NEW.state=2 AND node.state=1 AND node_id NOT IN 
						(SELECT node_id FROM plan_psector_x_node 
						 WHERE plan_psector_x_node.node_id=node.node_id AND  state=0 AND psector_id IN 
							(SELECT psector_id FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id)))					

					-- looking for planified nodes that belongs on the same alternatives that arc
					OR (NEW.state=2 AND node.state=2 AND node_id IN 
						(SELECT node_id FROM plan_psector_x_node 
						 WHERE plan_psector_x_node.node_id=node.node_id AND  state=1 AND psector_id IN
							(SELECT psector_id FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id))))

					ORDER BY (case when isarcdivide is true then 1 else 2 end),  ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;
		END IF;
	
	END IF;
    
    	--  Control of start/end node and depth variables
	IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN	

		-- Control of same node initial and final
		IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (v_samenode_init_end_control IS TRUE) THEN
			IF v_dsbl_error IS NOT TRUE THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1040", "function":"1244","debug_msg":"'||nodeRecord1.node_id||'"}}$$);';
			ELSE
				INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (3, NEW.arc_id, 'Node_1 and Node_2 are the same');
			END IF;
		ELSE

			-- node_1
			SELECT * INTO nodeRecord1 FROM vu_node WHERE node_id = nodeRecord1.node_id;  -- vu_node is used because topology have been ckecked before and sys_* fields are needed
			NEW.node_1 := nodeRecord1.node_id; 

			-- node_2
			SELECT * INTO nodeRecord2 FROM vu_node WHERE node_id = nodeRecord2.node_id;-- vu_node is used because topology have been ckecked before and sys_* fields are needed
			NEW.node_2 := nodeRecord2.node_id;

			-- the_geom
			NEW.the_geom := ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
			NEW.the_geom := ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);

			-- calculate length
			sys_length_aux:= ST_length(NEW.the_geom);
		
			IF NEW.custom_length IS NOT NULL THEN
				sys_length_aux=NEW.custom_length;
			END IF;
			
			IF sys_length_aux < 0.1 THEN 
				sys_length_aux=0.1;
			END IF;

			-- calculate sys_elev_1 & sys_elev_2 when USE top_elevation values from node and depth values from arc
			IF (nodeRecord1.elev IS NOT NULL OR nodeRecord1.custom_elev IS NOT NULL) THEN -- when elev is used on node only elev must be used on arc
				sys_elev1_aux = nodeRecord1.sys_elev;
				sys_y1_aux = null;
			ELSE
				sys_y1_aux:= (CASE WHEN NEW.custom_y1 IS NOT NULL THEN NEW.custom_y1
						   WHEN NEW.y1 IS NOT NULL THEN NEW.y1
						   ELSE nodeRecord1.sys_ymax END);
				sys_elev1_aux := nodeRecord1.sys_top_elev - sys_y1_aux;
			END IF;

			IF (nodeRecord2.elev IS NOT NULL OR nodeRecord2.custom_elev IS NOT NULL) THEN -- when elev is used on node only elev must be used on arc
				sys_elev2_aux = nodeRecord2.sys_elev;
				sys_y2_aux = null;
			ELSE
				sys_y2_aux:= (CASE WHEN NEW.custom_y2 IS NOT NULL THEN NEW.custom_y2
						   WHEN NEW.y2 IS NOT NULL THEN NEW.y2
						   ELSE nodeRecord2.sys_ymax END);
				sys_elev2_aux := nodeRecord2.sys_top_elev - sys_y2_aux;
			END IF;

			-- calculate sys_elev_1 & sys_elev_2 when USE elevation values from arc 
			IF TG_OP  = 'INSERT' THEN

				-- sys elev1
				IF NEW.custom_elev1 IS NOT NULL THEN
					sys_elev1_aux = NEW.custom_elev1;
				ELSIF NEW.elev1 IS NOT NULL THEN
					sys_elev1_aux = NEW.elev1;
				END IF;

				-- sys_elev2
				IF NEW.custom_elev2 IS NOT NULL THEN
					sys_elev2_aux = NEW.custom_elev2;
				ELSIF NEW.elev1 IS NOT NULL THEN
					sys_elev2_aux = NEW.elev2;
				END IF;
		
				NEW.sys_elev1 := sys_elev1_aux;
				NEW.sys_elev2 := sys_elev2_aux;
			
			ELSIF TG_OP = 'UPDATE' THEN

				-- sys elev1
				IF (NEW.custom_elev1 IS NOT NULL AND OLD.custom_elev1 IS NOT NULL)
				OR (NEW.custom_elev1 IS NULL AND OLD.custom_elev1 IS NOT NULL) OR (NEW.custom_elev1 IS NOT NULL AND OLD.custom_elev1 IS NULL) THEN
					sys_elev1_aux = NEW.custom_elev1;
				ELSIF (NEW.elev1 IS NOT NULL AND OLD.elev1 IS NOT NULL)
				OR (NEW.elev1 IS NULL AND OLD.elev1 IS NOT NULL) OR (NEW.elev1 IS NOT NULL AND OLD.elev1 IS NULL) THEN
					sys_elev1_aux = NEW.elev1;
				END IF;

				-- sys elev2
				IF (NEW.custom_elev2 IS NOT NULL AND OLD.custom_elev2 IS NOT NULL)
				OR (NEW.custom_elev2 IS NULL AND OLD.custom_elev2 IS NOT NULL) OR (NEW.custom_elev2 IS NOT NULL AND OLD.custom_elev2 IS NULL) THEN
					sys_elev2_aux = NEW.custom_elev2;
				ELSIF (NEW.elev2 IS NOT NULL AND OLD.elev2 IS NOT NULL)
				OR (NEW.elev2 IS NULL AND OLD.elev2 IS NOT NULL) OR (NEW.elev2 IS NOT NULL AND OLD.elev2 IS NULL) THEN
					sys_elev2_aux = NEW.elev2;
				END IF;

				-- keep depth values when geometry is forced to reverse by custom operation
				IF  geom_slp_direction_bool IS FALSE AND st_orderingequals(NEW.the_geom, OLD.the_geom) IS FALSE 
				AND st_equals(NEW.the_geom, OLD.the_geom) IS TRUE AND v_keepdepthvalues IS NOT FALSE THEN
	
					-- Depth values for arc
					y_aux := NEW.y1;
					NEW.y1 := NEW.y2;
					NEW.y2 := y_aux;
			
					y_aux := NEW.custom_y1;
					NEW.custom_y1 := NEW.custom_y2;
					NEW.custom_y2 := y_aux;
			
					y_aux := NEW.elev1;
					NEW.elev1 := NEW.elev2;
					NEW.elev2 := y_aux;

					y_aux := NEW.custom_elev1;
					NEW.custom_elev1 := NEW.custom_elev2;
					NEW.custom_elev2 := y_aux;

					y_aux := NEW.sys_elev1;
					NEW.sys_elev1 := NEW.sys_elev2;
					NEW.sys_elev2 := y_aux;
				ELSE 

					NEW.sys_elev1 := sys_elev1_aux;
					NEW.sys_elev2 := sys_elev2_aux;
				
				END IF;
			END IF;

			-- update values when geometry is forced to reverse by geom_slp_direction_bool variable on true
			IF geom_slp_direction_bool IS TRUE THEN

				IF (sys_elev1_aux < sys_elev2_aux) AND (NEW.inverted_slope IS NOT TRUE) THEN
					
					-- Update conduit direction
					-- Geometry
					NEW.the_geom := ST_reverse(NEW.the_geom);

					-- Node 1 & Node 2
					NEW.node_1 := nodeRecord2.node_id;
					NEW.node_2 := nodeRecord1.node_id;                             
			
					-- Depth values for arc
					y_aux := NEW.y1;
					NEW.y1 := NEW.y2;
					NEW.y2 := y_aux;
			
					y_aux := NEW.custom_y1;
					NEW.custom_y1 := NEW.custom_y2;
					NEW.custom_y2 := y_aux;
			
					y_aux := NEW.elev1;
					NEW.elev1 := NEW.elev2;
					NEW.elev2 := y_aux;

					y_aux := NEW.custom_elev1;
					NEW.custom_elev1 := NEW.custom_elev2;
					NEW.custom_elev2 := y_aux;

					y_aux := NEW.sys_elev1;	
					NEW.sys_elev1 := NEW.sys_elev2;
					NEW.sys_elev2 := y_aux;
				END IF;
			END IF;

			-- slope
			NEW.sys_slope:= (NEW.sys_elev1-NEW.sys_elev2)/sys_length_aux;
		END IF;
		
	-- Check auto insert end nodes
	ELSIF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NULL) AND v_nodeinsert_arcendpoint THEN
		IF TG_OP = 'INSERT' THEN

			-- getting nodecat user's value
			v_nodecat:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_nodecat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			-- get first value (last chance)
			IF (v_nodecat IS NULL) THEN
				v_nodecat := (SELECT * FROM cat_node WHERE active IS TRUE LIMIT 1);
			END IF;

			-- Inserting new node
			INSERT INTO v_edit_node (node_id, sector_id, state, state_type, dma_id, soilcat_id, workcat_id, buildercat_id, builtdate, nodecat_id, ownercat_id, muni_id,
			postcode, district_id, expl_id, the_geom)
			VALUES ((SELECT nextval('urn_id_seq')), NEW.sector_id, NEW.state, NEW.state_type, NEW.dma_id, NEW.soilcat_id, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, v_nodecat,
			NEW.ownercat_id, NEW.muni_id, NEW.postcode, NEW.district_id, NEW.expl_id, st_endpoint(NEW.the_geom))
			RETURNING node_id INTO v_node2;
					
			-- Update arc
			NEW.node_1:= nodeRecord1.node_id; 
			NEW.node_2:= v_node2;
		END IF;

	-- Error, no existing nodes
	ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (v_arc_searchnodes_control IS TRUE) THEN
		IF v_dsbl_error IS NOT TRUE THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1042", "function":"1244","debug_msg":""}}$$);';
		ELSE
			INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (4, NEW.arc_id, concat('Node_1 ', nodeRecord1.node_id, ' or Node_2 ', nodeRecord2.node_id, ' does not exists or does not has compatible state with arc'));
		END IF;
		
	--Not existing nodes but accepted insertion
	ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (v_arc_searchnodes_control IS FALSE) THEN
		RETURN NEW;

	ELSE
		IF v_dsbl_error IS NOT TRUE THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1042", "function":"1244","debug_msg":""}}$$);';
		ELSE
			INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (4, NEW.arc_id, concat('Node_1 ', nodeRecord1.node_id, ' or Node_2 ', nodeRecord2.node_id, ' does not exists or does not has compatible state with arc'));
		END IF;
		
	END IF;

RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
