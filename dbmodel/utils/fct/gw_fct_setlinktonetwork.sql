/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2124

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(character varying[], character varying);
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setlinktonetwork(p_data json)
RETURNS json AS
$BODY$

/*
GOAL:
This function have been refactorized on 2019/04/24 changing the full strategy of vnode and links (according with the trigger of v_edit_vnode)

	

MAIN CHANGES
- Vnode geometry is only updateable. It's no posible to create a new one using ToC layer
- It's forbidden to connec links on vnode without arcs.
- Connect_to_network works also with node/connec/gully as endpoints (deprecated)

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["3201","3200"]},
"data":{"feature_type":"CONNEC"}}$$);

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1,"lang":"ES"},"feature":{"id":
"SELECT array_to_json(array_agg(connec_id::text)) FROM v_edit_connec WHERE connec_id IS NOT NULL AND state=1"},
"data":{"feature_type":"CONNEC"}}$$);

--fid: 217

*/

DECLARE
	
v_connect record;
v_link record;
v_exit record;
v_arc record;
v_vnode record;
v_connect_id  varchar;
v_exit_id text;
point_aux public.geometry;
aux_geom public.geometry;
v_node_proximity double precision;
v_projecttype text;
v_endfeature_geom public.geometry;
v_pjointtype text;
v_pjointid text;
v_feature_text text;
v_feature_array text[];
v_feature_type text;
	
v_result text;
v_result_info text;
v_result_point text;
v_result_line text;
v_result_polygon text;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;
v_hide_form boolean;
v_version text;

BEGIN
	
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='edit_node_proximity';
    IF v_node_proximity IS NULL THEN v_node_proximity=0.01; END IF;
	SELECT value::boolean INTO v_hide_form FROM config_param_user where parameter='qgis_form_log_hidden' AND cur_user=current_user;

    -- select project type
    SELECT project_type, giswater INTO v_projecttype, v_version FROM sys_version LIMIT 1;

    -- Get parameters from input json
    v_feature_type =  ((p_data ->>'data')::json->>'feature_type'::text);
    v_feature_text = ((p_data ->>'feature')::json->>'id'::text);

    IF v_feature_text ILIKE '[%]' THEN
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_text::json)); 		
    ELSE 
		EXECUTE v_feature_text INTO v_feature_text;
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_text::json)); 
    END IF;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 217 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (217, null, 4, 'CONNECT TO NETWORK');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (217, null, 4, '-------------------------------------------------------------');
	

    -- Main loop
    IF v_feature_array IS NOT NULL THEN
	
	FOREACH v_connect_id IN ARRAY v_feature_array
	LOOP	

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (217, null, 4, concat('Connect ', lower(v_feature_type),' with id ',v_connect_id,'.'));
	
		-- get link information (if exits)
		SELECT * INTO v_link FROM link WHERE feature_id = v_connect_id AND feature_type=v_feature_type;

		-- get feature information
		IF v_feature_type ='CONNEC' THEN          
			SELECT * INTO v_connect FROM connec WHERE connec_id = v_connect_id;
		ELSIF v_feature_type ='GULLY' THEN 
			SELECT * INTO v_connect FROM gully WHERE gully_id = v_connect_id;
		END IF;

		-- exception control. It's no possible to create another link when already exists for the connect
		IF v_connect.state=2 AND v_link.exit_id IS NOT NULL THEN
			IF v_feature_type = 'CONNEC' THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3052", "function":"2124","debug_msg":"'||v_connect_id||'"}}$$);' INTO v_audit_result;

			ELSIF v_feature_type = 'GULLY' THEN
		
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3054", "function":"2124","debug_msg":"'||v_connect_id||'"}}$$);' INTO v_audit_result;
			END IF;
		END IF;
	
		-- get arc_id (if feature does not have) using buffer  
		IF v_connect.arc_id IS NULL THEN

			IF v_link.the_geom IS NULL THEN -- looking for closest arc from connect
				WITH index_query AS(
				SELECT ST_Distance(the_geom, v_connect.the_geom) as distance, arc_id FROM v_edit_arc WHERE state > 0)
				SELECT arc_id INTO v_connect.arc_id FROM index_query ORDER BY distance limit 1;
			
			ELSIF v_link.the_geom IS NOT NULL THEN -- looking for closest arc from link's endpoint
				WITH index_query AS(
				SELECT ST_Distance(the_geom, st_endpoint(v_link.the_geom)) as distance, arc_id FROM v_edit_arc WHERE state > 0)
				SELECT arc_id INTO v_connect.arc_id FROM index_query ORDER BY distance limit 1;			
			END IF;
		END IF;
			
		-- get v_edit_arc information
		SELECT * INTO v_arc FROM arc WHERE arc_id = v_connect.arc_id;
		
		-- get values from old vnode
		SELECT * INTO v_exit FROM vnode WHERE vnode_id::text=v_link.exit_id;

		-- state control
		IF v_arc.state=2 AND v_connect.state=1 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3050", "function":"2124","debug_msg":null}}$$);' INTO v_audit_result;
		END IF;

		-- compute link
		IF v_arc.the_geom IS NOT NULL THEN

			IF v_link.userdefined_geom IS TRUE THEN	
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (217, null, 4, concat('Previous link geometry was created manually by user.'));

				-- get endfeature geometry
				IF v_link.exit_type='NODE' THEN
					SELECT node_id, the_geom INTO v_pjointid, v_endfeature_geom FROM node WHERE node_id=v_link.exit_id;
					v_pjointtype='NODE';
					
				ELSIF v_link.exit_type='CONNEC' THEN
					SELECT pjoint_type, pjoint_id, the_geom INTO v_pjointtype, v_pjointid, v_endfeature_geom FROM connec WHERE connec_id=v_link.exit_id;

				ELSIF v_link.exit_type='GULLY' THEN
					SELECT pjoint_type, pjoint_id, the_geom INTO v_pjointtype, v_pjointid, v_endfeature_geom FROM gully WHERE gully_id=v_link.exit_id;

				ELSIF v_link.exit_type='VNODE' THEN
					-- in this case whe don't use the v_link record variable because perhaps there is not link
					v_endfeature_geom = v_arc.the_geom;
				END IF;

				-- Reverse (if it's need) the existing link geometry
				IF (st_dwithin (st_startpoint(v_link.the_geom), v_connect.the_geom, 0.01)) IS FALSE THEN
					point_aux := St_closestpoint(v_endfeature_geom, St_startpoint(v_link.the_geom));
					v_link.the_geom = ST_SetPoint(v_link.the_geom, 0, point_aux) ; 

					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (217, null, 4, concat('Reverse the direction of drawn link.'));
				ELSE
					point_aux := St_closestpoint(v_endfeature_geom, St_endpoint(v_link.the_geom));
					v_link.the_geom = ST_SetPoint(v_link.the_geom, (ST_NumPoints(v_link.the_geom) - 1),point_aux); 
				END IF;
				
			ELSE -- in this case only arc is posible (vnode)
			
				v_link.the_geom := ST_ShortestLine(v_connect.the_geom, v_arc.the_geom);
				v_link.userdefined_geom = FALSE;
				v_link.exit_type = 'VNODE';

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (217, null, 4, concat('Connect feature with the closest arc.'));
			END IF;

			v_exit.the_geom = ST_EndPoint(v_link.the_geom);
		END IF;

		raise notice 'v_endfeature_geom %',v_endfeature_geom;
		
		IF v_exit.the_geom IS NOT NULL THEN

			-- vnode, only for those links connected to vnode
			IF v_link.exit_type = 'VNODE' THEN
				DELETE FROM vnode WHERE vnode_id=v_exit.vnode_id::integer;			
				INSERT INTO vnode (state,  the_geom) 
				VALUES (v_arc.state, v_exit.the_geom) RETURNING vnode_id INTO v_exit_id;	
				v_link.exit_id = v_exit_id;
				v_pjointtype = v_link.exit_type;
				v_link.exit_type = 'VNODE';
				v_pjointid = v_link.exit_id;

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (217, null, 4, concat('Recreate final vnode'));
			END IF;

			-- link for all links
			DELETE FROM link WHERE link_id=v_link.link_id;
			INSERT INTO link (link_id, the_geom, feature_id, feature_type, exit_type, exit_id, userdefined_geom, state, expl_id) 
			VALUES ((SELECT nextval('link_link_id_seq')), v_link.the_geom, v_connect_id, v_feature_type, v_link.exit_type, v_link.exit_id, 
			v_link.userdefined_geom, v_connect.state, v_arc.expl_id);
				
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (217, null, 4, concat('Recreate link'));

			IF v_pjointtype IS NULL THEN
				v_pjointtype = 'VNODE';
				v_pjointid = v_exit_id;
			END IF;

			-- Update connect attributes
			IF v_feature_type ='CONNEC' THEN       
		   
				UPDATE connec SET arc_id=v_connect.arc_id, expl_id=v_arc.expl_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, 
				pjoint_type=v_pjointtype, pjoint_id=v_pjointid, fluid_type = v_arc.fluid_type 
				WHERE connec_id = v_connect_id;

				-- update specific fields for ws projects
				IF v_projecttype = 'WS' THEN
					UPDATE connec SET dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id,presszone_id=v_arc.presszone_id
					WHERE connec_id = v_connect_id;
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (217, null, 4, concat('Update mapzone values.'));
				END IF;
			
				-- Update state_type if edit_connect_update_statetype is TRUE
				IF (SELECT ((value::json->>'connec')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
					UPDATE connec SET state_type = (SELECT ((value::json->>'connec')::json->>'state_type')::int2 
					FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE connec_id=v_connect_id;
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (217, null, 4, concat('Update state type.'));
				END IF;
			
			ELSIF v_feature_type ='GULLY' THEN 
				UPDATE gully SET arc_id=v_connect.arc_id, expl_id=v_arc.expl_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, 
				pjoint_type=v_pjointtype, pjoint_id=v_pjointid, fluid_type = v_arc.fluid_type 
				WHERE gully_id = v_connect_id;
				
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (217, null, 4, concat('Update mapzone values.'));

				-- Update state_type if edit_connect_update_statetype is TRUE
				IF (SELECT ((value::json->>'gully')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
					UPDATE gully SET state_type = (SELECT ((value::json->>'gully')::json->>'state_type')::int2 
					FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE gully_id=v_connect_id;
				END IF;
			END IF;
			
		END IF;

		-- reset values
		v_connect := null;
		v_link := null;
		v_exit := null;
		v_arc := null;
		v_vnode := null;

	END LOOP;

    END IF;
   
	--  EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	--"data":{"message":"0", "function":"2124","debug_msg":null}}$$);' INTO v_audit_result;
	-- get results
	-- info

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid = 217 ORDER BY criticity desc, id asc) row;
	
	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;

	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	v_result_point = '{"geometryType":"", "features":[]}';
	v_result_line = '{"geometryType":"", "features":[]}';
	v_result_polygon = '{"geometryType":"", "features":[]}';

	--  Return
     RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
				', "actions":{"hideForm":' || v_hide_form || '}'||
		       '}'||
	    '}')::json, 2124);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
