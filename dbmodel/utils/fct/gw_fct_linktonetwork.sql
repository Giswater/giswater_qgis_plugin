/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3188

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(character varying[], character varying);
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_linktonetwork(p_data json)
RETURNS json AS
$BODY$

/*
GOAL
----
This function have been refactorized on 2022/12 changing the full strategy of links

DESCRIPTION
-----------
No doubt this is the most important function for links. Lots of procedures and workflows works with this function. See: https://github.com/Giswater/giswater_dbmodel/wiki/Links-Workflows.
Main workflows:
- Create a new link with or without defined target for operative connects
- Create a new link  with or without defined target for operative connects in order to be used on psector strategy
- Create a new link with or without defined target for planned connects 
- Redraw an existing link when target feature have been changed
- Reverse link geom when need in order to repair it


EXAMPLES
--------
SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["3201","3200"]},"data":{"feature_type":"CONNEC", "forcedArcs":["2001","2002"]}}$$);

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["100013"]},"data":{"feature_type":"CONNEC", "forcedArcs":["221"]}}$$);

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["100013"]},"data":{"feature_type":"CONNEC"}}$$);
SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["100014"]},"data":{"feature_type":"GULLY"}}$$);

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1,"lang":"ES"},"feature":
{"id":"SELECT array_to_json(array_agg(connec_id::text)) FROM v_edit_connec WHERE connec_id IS NOT NULL AND state=1"},"data":{"feature_type":"CONNEC"}}$$);


--fid: 217

*/

DECLARE


-- input variables
v_feature_type text;-- Type of features affected
v_feature_ids text; -- List of feature affected
v_forcedarcs text; -- Used to force only some specific arcs
v_ispsector boolean; -- When function is called from psector side (gw_trg_plan_psector_link)
v_isarcdivide boolean;	-- When function is called for arcdivide procedure (gw_fct_setarcdivide)
v_link_id integer; -- Id for link

-- standard variables
v_projecttype text; -- To store project type (UD / WS)
v_version text; -- To store version of system
v_psector_current integer; -- Current psector related to user

-- process variables
v_connect record; -- Record to store the value for the used connect
v_link record; -- Record to store the value for the used link
v_arc record; -- Record to store the value for the used arc
v_connect_id  varchar; -- id for the used connect
v_point_aux public.geometry; -- Variable to store the geometry of the end of the link
v_feature_array text[]; -- Transforming v_feature_ids on real array

v_endfeature_geom public.geometry; -- Variable to store the geometry of the end object, as well as node, connec, gully or arc
v_pjointtype text; -- Type for the destination feature (ARC, NODE, CONNEC, GULLY)
v_pjointid text; -- Id for the destination feature

v_count integer; -- Counter

v_isoperative_psector boolean = false; -- It shows when the worflow comes from psector but for those existing connects which they are involved on psector
v_existing_link integer; -- link_id: In case of psector for operative links, we collect the value of the operative link
v_linkfrompsector integer; -- link_id: It is the id of link stored on psector table
v_dfactor double precision;  -- Distance factor. Value 0-1 used to separate link from the endpoints of arcs. Only applied to ws. For UD it is more understandable to connect with nodes

v_fluidtype_value text;
v_dma_value integer;
v_fluidtype_autoupdate boolean;
v_dma_autoupdate boolean;
v_isveditconnect boolean = false;

-- return variables
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


BEGIN

	
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system variables
	SELECT project_type, giswater INTO v_projecttype, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT value INTO v_dma_autoupdate FROM config_param_system WHERE parameter = 'edit_connect_autoupdate_dma';
	SELECT value INTO v_fluidtype_autoupdate FROM config_param_system WHERE parameter = 'edit_connect_autoupdate_fluid';


	-- get user variables
	v_psector_current = (SELECT value::integer FROM config_param_user WHERE parameter = 'plan_psector_vdefault' AND cur_user = current_user);

	-- get parameters from input json
	v_feature_type =  ((p_data ->>'data')::json->>'feature_type'::text);
	v_feature_ids = ((p_data ->>'feature')::json->>'id'::text);
	v_forcedarcs = (p_data->>'data')::json->>'forcedArcs';
	v_ispsector = (p_data->>'data')::json->>'isPsector';
	v_isveditconnect = (p_data->>'data')::json->>'isVeditConnect';
	v_isarcdivide = (p_data->>'data')::json->>'isArcDivide';
	v_link_id = (p_data->>'data')::json->>'linkId';

	-- create query text for forced arcs
	if v_forcedarcs is null then
		v_forcedarcs= '';
	else
		v_forcedarcs = replace(ARRAY(SELECT json_array_elements_text(((p_data::json->>'data')::json->>'forcedArcs')::json))::text, '{','(');
		v_forcedarcs = concat (' AND arc_id::integer IN ', replace (v_forcedarcs, '}',')'));
	end if;

	-- get values from feature array 
	IF v_feature_ids ILIKE '[%]' THEN
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_ids::json)); 		
	ELSE 
		EXECUTE v_feature_ids INTO v_feature_ids;
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_ids::json)); 
	END IF;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 217 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (217, null, 4, 'CONNECT TO NETWORK');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (217, null, 4, '-------------------------------------------------------------');
	
	-- Main loop
	IF v_feature_array IS NOT NULL THEN

	    PERFORM setval('SCHEMA_NAME.link_link_id_seq', (SELECT max(link_id) FROM link),true);
	
	    FOREACH v_connect_id IN ARRAY v_feature_array
	    LOOP

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (217, null, 4, concat('Trying to connect ', lower(v_feature_type),' with id ',v_connect_id,'.'));
		
		-- get feature information
		IF v_feature_type ='CONNEC' THEN          
			SELECT * INTO v_connect FROM v_edit_connec WHERE connec_id = v_connect_id;

			IF (SELECT connec_id FROM plan_psector_x_connec WHERE connec_id = v_connect.connec_id AND psector_id = v_psector_current AND psector_id
				IN (SELECT psector_id FROM selector_psector WHERE cur_user = current_user) AND state = 1) IS NOT NULL AND v_connect.state = 1 THEN
				v_isoperative_psector = true;
				v_linkfrompsector = (SELECT link_id FROM plan_psector_x_connec WHERE connec_id = v_connect.connec_id AND psector_id IN
						    (SELECT psector_id FROM selector_psector WHERE cur_user = current_user) AND state = 1);
			END IF;
	
		ELSIF v_feature_type ='GULLY' THEN 
			SELECT * INTO v_connect FROM v_edit_gully WHERE gully_id = v_connect_id;
			
			IF (SELECT gully_id FROM plan_psector_x_gully WHERE gully_id = v_connect.gully_id AND psector_id = v_psector_current AND psector_id IN
			   (SELECT psector_id FROM selector_psector WHERE cur_user = current_user) AND state = 1) IS NOT NULL AND v_connect.state = 1 THEN
				v_isoperative_psector = true;
				v_linkfrompsector = (SELECT link_id FROM plan_psector_x_gully WHERE gully_id = v_connect.gully_id AND psector_id IN
						    (SELECT psector_id FROM selector_psector WHERE cur_user = current_user) AND state = 1);
			END IF;
		END IF;

		-- getting link values
		IF v_isoperative_psector THEN -- getting values from the operative one

			IF v_linkfrompsector IS NULL THEN
				SELECT * INTO v_link FROM link WHERE feature_id = v_connect_id and state = 1 limit 1;
				v_link.link_id = null;
			
			ELSIF v_linkfrompsector IS NOT NULL THEN
				SELECT * INTO v_link FROM link WHERE link_id =  v_linkfrompsector;
			END IF;
		ELSE
			SELECT * INTO v_link FROM v_edit_link WHERE feature_id = v_connect_id limit 1;
		END IF;
	
		-- exception control. It is not possible to create a link for connec over arc		
		SELECT * INTO v_arc FROM v_edit_arc WHERE ST_DWithin(v_connect.the_geom, v_edit_arc.the_geom, 0.001);

		IF v_arc.arc_id IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) 
			VALUES (217, null, 4, concat('FAILED: Link not created because connect ',v_connect_id,' is over arc ', v_arc.arc_id));
		ELSE

			IF v_link.the_geom IS NULL THEN -- looking for closest arc from connect
				EXECUTE 'WITH index_query AS(
				SELECT ST_Distance(the_geom, '||quote_literal(v_connect.the_geom::text)||') as distance, arc_id FROM v_edit_arc WHERE state > 0 '||v_forcedarcs||')
				SELECT arc_id FROM index_query ORDER BY distance limit 1'
				INTO v_connect.arc_id;
			
			ELSIF v_link.the_geom IS NOT NULL THEN -- looking for closest arc from link's endpoint
				EXECUTE 'WITH index_query AS(
				SELECT ST_Distance(the_geom, st_endpoint('||quote_literal(v_link.the_geom::text)||')) as distance, arc_id FROM v_edit_arc WHERE state > 0 '||v_forcedarcs||')
				SELECT arc_id FROM index_query ORDER BY distance limit 1'
				INTO v_connect.arc_id;			
			END IF;

			-- get v_edit_arc information
			SELECT * INTO v_arc FROM arc WHERE arc_id = v_connect.arc_id;
			
			-- state control
			IF v_arc.state=2 AND v_connect.state=1 AND v_isarcdivide is false THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3050", "function":"2124","debug_msg":null}}$$);' INTO v_audit_result;
			END IF;

			-- get endfeature attributes
			IF v_link.exit_type='NODE' THEN
				SELECT node_id, the_geom INTO v_pjointid, v_endfeature_geom FROM node WHERE node_id=v_link.exit_id;
				v_pjointtype='NODE';
				v_link.exit_type = 'NODE';
				v_link.exit_id = v_pjointid;
				
			ELSIF v_link.exit_type='CONNEC' THEN
				SELECT pjoint_type, connec_id, the_geom INTO v_pjointtype, v_pjointid, v_endfeature_geom FROM connec WHERE connec_id=v_link.exit_id;
				v_pjointtype='CONNEC';
				v_link.exit_type = 'CONNEC';
				v_link.exit_id = v_pjointid;

			ELSIF v_link.exit_type='GULLY' THEN
				SELECT pjoint_type, gully_id, the_geom INTO v_pjointtype, v_pjointid, v_endfeature_geom FROM gully WHERE gully_id=v_link.exit_id;
				v_pjointtype='GULLY';
				v_link.exit_type = 'GULLY';
				v_link.exit_id = v_pjointid;

			ELSE  -- it means ARC or NOTHING
				v_pjointtype='ARC';
				v_endfeature_geom = v_arc.the_geom;
				v_link.exit_type = 'ARC';
				v_link.exit_id = v_arc.arc_id;
				v_pjointid = v_arc.arc_id;
			END IF;

			-- compute link
			IF v_arc.the_geom IS NOT NULL THEN

				-- setting distance factor
				IF v_projecttype  ='WS' THEN
					v_dfactor = 0.3/(st_length(v_arc.the_geom));
					IF v_dfactor > 0.5 THEN v_dfactor = 0.5; END IF;
				ELSIF  v_projecttype  ='UD' THEN
					v_dfactor = 0;
				END IF;		

				-- setting point aux
				IF st_equals(v_point_aux, st_endpoint(v_arc.the_geom)) THEN
					v_point_aux = (ST_lineinterpolatepoint(v_arc.the_geom, 1-v_dfactor));

				ELSIF st_equals(v_point_aux, st_startpoint(v_arc.the_geom)) THEN
					v_point_aux = (ST_lineinterpolatepoint(v_arc.the_geom, v_dfactor));
				ELSE 
					v_point_aux := St_closestpoint(v_arc.the_geom, St_endpoint(v_link.the_geom));
				END IF;

				-- profilactic control for v_point_aux
				IF v_point_aux IS NULL THEN
					v_point_aux := St_closestpoint(v_arc.the_geom, v_connect.the_geom);
				END IF;
		
				IF v_link.the_geom IS NULL AND v_pjointtype='ARC' THEN

					IF v_link.the_geom IS NULL THEN
						SELECT the_geom INTO v_link.the_geom FROM link WHERE feature_id = v_connect_id AND feature_type=v_feature_type AND state=1 LIMIT 1;
					END IF;

					IF v_link.the_geom IS NULL THEN
						-- create link geom
						v_link.the_geom := st_setsrid(ST_makeline(v_connect.the_geom, v_point_aux), SRID_VALUE);
						
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (217, null, 4, concat('Create new link eature with the closest arc.'));
					ELSE 
						v_link.state = 2; -- because it is copied from existing one but related to psector
		
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (217, null, 4, concat('Creating new link by using geometry of existing one.'));
					END IF;
					
				ELSIF v_link.the_geom IS NOT NULL AND v_pjointtype='ARC' THEN
				
					-- Reverse (if it's need) the existing link geometry
					IF (st_dwithin (st_startpoint(v_link.the_geom), v_connect.the_geom, 0.01)) IS FALSE THEN
						v_point_aux := St_closestpoint(v_endfeature_geom, St_startpoint(v_link.the_geom));
						v_link.the_geom = ST_SetPoint(v_link.the_geom, 0, v_point_aux) ; 

						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (217, null, 4, concat('Reverse the direction of drawn link.'));
					ELSE
						v_link.the_geom = ST_SetPoint(v_link.the_geom, (ST_NumPoints(v_link.the_geom) - 1),v_point_aux); 
					END IF;

				ELSIF v_link.the_geom IS NOT NULL AND v_pjointtype !='ARC' AND (v_forcedarcs IS NOT NULL AND v_forcedarcs !='') AND v_isveditconnect IS TRUE THEN

					-- when we are forcing arc_id for those links coming from connec, guly, node
					v_link.the_geom = ST_SetPoint(v_link.the_geom, (ST_NumPoints(v_link.the_geom) - 1),v_point_aux); 
					v_pjointtype='ARC';
					v_endfeature_geom = v_arc.the_geom;
					v_link.exit_type = 'ARC';
					v_link.exit_id = v_arc.arc_id;
					v_pjointid = v_arc.arc_id;						
				ELSE
					-- do nothing for those links coming from connec, guly, node and they not are forced with some arc_id
				END IF;
			END IF;

			-- control of dma and fluidtype automatic values
			IF  v_dma_autoupdate is true or v_dma_value is null THEN v_dma_value = v_arc.dma_id; ELSE v_dma_value = v_connect.dma_id; END IF;
			IF  v_fluidtype_autoupdate is true or v_fluidtype_value is null THEN v_fluidtype_value = v_arc.fluid_type; ELSE v_fluidtype_value = v_connect.fluid_type; END IF;


			IF v_link.link_id IS NULL THEN

				-- creation of link
				v_link.link_id = (SELECT nextval('link_link_id_seq'));
				
				IF v_projecttype = 'WS' THEN
					INSERT INTO link (link_id, the_geom, feature_id, feature_type, exit_type, exit_id, state, expl_id, sector_id, dma_id, 
					presszone_id, dqa_id, minsector_id, fluid_type) 
					VALUES (v_link.link_id, v_link.the_geom, v_connect_id, v_feature_type, v_link.exit_type, v_link.exit_id, 
					 v_connect.state, v_arc.expl_id, v_arc.sector_id, v_dma_value, v_arc.presszone_id, v_arc.dqa_id, v_arc.minsector_id, v_fluidtype_value);
					
				ELSIF v_projecttype = 'UD' THEN		

					INSERT INTO link (link_id, the_geom, feature_id, feature_type, exit_type, exit_id, state, expl_id, sector_id, dma_id, fluid_type) 
					VALUES (v_link.link_id, v_link.the_geom, v_connect_id, v_feature_type, v_link.exit_type, v_link.exit_id, 
					v_connect.state, v_arc.expl_id, v_arc.sector_id, v_dma_value, v_fluidtype_value);
				END IF;
			ELSE
				UPDATE link SET the_geom=v_link.the_geom, exit_type=v_link.exit_type, exit_id=v_link.exit_id, dma_id = v_dma_value, fluid_type = v_fluidtype_value WHERE link_id = v_link.link_id;

				IF v_projecttype = 'WS' THEN
					UPDATE link SET	presszone_id=v_arc.presszone_id, dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id;
				END IF;
			END IF;

			-- update connect values
			IF v_connect.state=1 then

				IF v_ispsector THEN -- then returning link

					IF v_feature_type ='CONNEC' THEN
						UPDATE plan_psector_x_connec SET link_id = v_link.link_id WHERE psector_id = v_psector_current 
						AND connec_id = v_connect_id AND state = 1;
						
					ELSIF v_feature_type ='GULLY' THEN
						UPDATE plan_psector_x_gully SET link_id = v_link.link_id WHERE psector_id = v_psector_current 
						AND gully_id = v_connect_id  AND state = 1;
					END IF;

					UPDATE link SET state = 2 WHERE link_id  = v_link.link_id;
					
				ELSIF v_isarcdivide or v_isoperative_psector THEN -- then returning to psector link & arc_id

					IF v_feature_type ='CONNEC' THEN
						UPDATE plan_psector_x_connec SET link_id = v_link.link_id, arc_id = v_arc.arc_id  
						WHERE psector_id = v_psector_current AND connec_id = v_connect_id AND state = 1;
						
					ELSIF v_feature_type ='GULLY' THEN
						UPDATE plan_psector_x_gully SET link_id = v_link.link_id, arc_id = v_arc.arc_id 
						WHERE psector_id = v_psector_current AND gully_id = v_connect_id  AND state = 1;
					END IF;

					UPDATE link SET state = 2 WHERE link_id  = v_link.link_id;

					IF v_isoperative_psector THEN

						SELECT link_id INTO v_existing_link FROM link WHERE feature_id = v_connect_id AND state = 1 LIMIT 1;

						IF v_feature_type ='CONNEC' THEN
							INSERT INTO plan_psector_x_connec (psector_id, connec_id, state, link_id) VALUES (v_psector_current, v_connect_id, 0, v_existing_link)
							ON CONFLICT (psector_id, connec_id, state) DO UPDATE set link_id = v_existing_link;
							
						ELSIF v_feature_type ='GULLY' THEN
							INSERT INTO plan_psector_x_gully (psector_id, gully_id, state, link_id) VALUES (v_psector_current, v_connect_id, 0, v_existing_link)
							ON CONFLICT (psector_id, gully_id, state) DO UPDATE set link_id = v_existing_link;
						END IF;
					END IF;					
					
				ELSE -- Update connect attributes
				
					IF v_feature_type ='CONNEC' THEN
						
						UPDATE connec SET arc_id=v_connect.arc_id, expl_id=v_arc.expl_id, dma_id=v_dma_value, sector_id=v_arc.sector_id, 
						pjoint_type=v_pjointtype, pjoint_id=v_pjointid, fluid_type = v_fluidtype_value 
						WHERE connec_id = v_connect_id;
						 
						-- update specific fields for ws projects
						IF v_projecttype = 'WS' THEN
							UPDATE connec SET dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id,presszone_id=v_arc.presszone_id,
							staticpressure = ((SELECT head from presszone WHERE presszone_id = v_arc.presszone_id)- v_connect.elevation) 
							WHERE connec_id = v_connect_id;
						END IF;
					
					ELSIF v_feature_type ='GULLY' THEN 
					
						UPDATE gully SET arc_id=v_connect.arc_id, expl_id=v_arc.expl_id, dma_id=v_dma_value, sector_id=v_arc.sector_id, 
						pjoint_type=v_pjointtype, pjoint_id=v_pjointid, fluid_type = v_fluidtype_value 
						WHERE gully_id = v_connect_id;
					END IF;
				END IF;

			ELSIF v_connect.state=2 THEN
			
				IF v_ispsector IS TRUE THEN -- then returning link

					IF v_feature_type ='CONNEC' THEN
						UPDATE plan_psector_x_connec SET link_id = v_link.link_id WHERE psector_id = v_psector_current 
						AND connec_id = v_connect_id AND state = 1;
					
					ELSIF v_feature_type ='GULLY' THEN
						UPDATE plan_psector_x_gully SET link_id = v_link.link_id WHERE psector_id = v_psector_current
						 AND gully_id = v_connect_id AND state = 1;
					END IF;

				ELSE -- then updating psector with link and arc

					IF v_feature_type ='CONNEC' THEN
						UPDATE plan_psector_x_connec SET link_id = v_link.link_id, arc_id = v_arc.arc_id 
						WHERE psector_id = v_psector_current AND connec_id = v_connect_id AND state = 1;
					
					ELSIF v_feature_type ='GULLY' THEN
						
						UPDATE plan_psector_x_gully SET link_id = v_link.link_id, arc_id = v_arc.arc_id 
						WHERE psector_id = v_psector_current AND gully_id = v_connect_id AND state = 1;
					END IF;
				END IF;
			END IF;
								
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (217, null, 4, concat('Recreate link'));

			-- reset values
			v_connect := null;
			v_link := null;
			v_arc := null;
		END IF;
	    END LOOP;
	END IF;
	   
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
		       '}'||
	    '}')::json, 3188, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
