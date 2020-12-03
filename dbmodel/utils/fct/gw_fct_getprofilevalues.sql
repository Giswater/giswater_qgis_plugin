/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2832

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_getprofilevalues(p_data json)  
RETURNS json AS 
$BODY$

/*example
current petition from client:
SELECT SCHEMA_NAME.gw_fct_getprofilevalues($${"data":{"initNode":"116", "endNode":"111", "linksDistance":1, "scale":{ "eh":1000, "ev":1000}}}$$);
SELECT SCHEMA_NAME.gw_fct_getprofilevalues($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "initNode":"60", "endNode":"61", "linksDistance":5, "scale":{ "eh":1000, "ev":1000}}}$$);

further petitions from client:
SELECT SCHEMA_NAME.gw_fct_getprofilevalues($${"client":{},
	"data":{"initNode":"116", "endNode":"111", "composer":"mincutA4", "legendFactor":1, "linksDistance":1, "scale":{"scaleToFit":false, "eh":2000, "ev":500}, "papersize":{"id":0, "customDim":{"xdim":300, "ydim":200}},
		"ComposerTemplates":[{"ComposerTemplate":"mincutA4", "ComposerMap":[{"width":"179.0","height":"140.826","index":0, "name":"map0"},{"width":"77.729","height":"55.9066","index":1, "name":"map7"}]},
				     {"ComposerTemplate":"mincutA3","ComposerMap":[{"width":"53.44","height":"55.9066","index":0, "name":"map7"},{"width":"337.865","height":"275.914","index":1, "name":"map6"}]}]
				     }}$$);

SELECT SCHEMA_NAME.gw_fct_getprofilevalues($${"client":{},
	"data":{"initNode":"116", "endNode":"111", "composer":"mincutA4", "legendFactor":1, "linksDistance":1, "scale":{"scaleToFit":false, "eh":2000, "ev":500},"papersize":{"id":2, "customDim":{}},
		"ComposerTemplates":[{"ComposerTemplate":"mincutA4", "ComposerMap":[{"width":"179.0","height":"140.826","index":0, "name":"map0"},{"width":"77.729","height":"55.9066","index":1, "name":"map7"}]},
				     {"ComposerTemplate":"mincutA3","ComposerMap":[{"width":"53.44","height":"55.9066","index":0, "name":"map7"},{"width":"337.865","height":"275.914","index":1, "name":"map6"}]}]
				     }}$$); 
				     
-- fid: 222

Mains:
- Profile works with 4 types of nodes
	- TOP-REAL: Normal case, dimensions provided and node has representation on surface
	- TOP-ESTIM: Node has representation on surface but dimensions are not provided (ymax). Interpolation is done
	- BOTTOM: Node has not representation on surface (node_type WHERE isprofilesurface IS FALSE) 
	- LINK: vnodes
- profile works with user-friendly variables
	- legendFactor: Factor on make bigger o smaller llegend and text 
	- linksDistance: Value to prevent on guitar when text is overlaped with another text 

*/

DECLARE

v_init  text;
v_end text;
v_hs float;
v_vs float;
v_arc json;
v_node json;
v_terrain json;
v_llegend json;
v_stylesheet json;
v_version text;
v_status text;
v_level integer;
v_message text;
v_audit_result text; 
v_guitarlegend json;
v_textarc text;
v_vdefault json;
v_leaflet json;
v_composer text;
v_templates json;
v_json json;
v_project_type text;
v_height float;
v_index integer;
v_mapcomposer_name text;
v_scaletofit boolean;
v_array_width float[];
v_scale text;
v_extension json;
v_vstext text;
v_hstext text;
v_legendfactor float;
v_linksdistance float;
v_arc_geom1 float;
v_node_geom1 float;
i integer = 0;
v_dist float[];
v_telev float[];
v_elev float[];
v_nid text[];
v_systype text[];
v_elevation float;
v_distance float;
v_compheight float;
v_compwidth float;
v_profheigtht float;
v_profwidth float;
v_error_context text;
v_initv float;
v_inith float;
v_initpoint json;

-- field variables to work with UD/WS
v_fcatgeom text;
v_ftopelev text;
v_fymax text;
v_fslope text;
v_fsystopelev text;
v_fsyselev text;
v_fsysymax text;
v_querytext text;
v_qnode1 text;
v_qnode2 text;
v_elev1 text;
v_elev2 text;
v_z1 text;
v_z2 text;
v_y1 text;
v_y2 text;
v_papersize integer;

BEGIN

	--  Get input data
	v_init = (p_data->>'data')::json->>'initNode';
	v_end = (p_data->>'data')::json->>'endNode';
	v_hs = ((p_data->>'data')::json->>'scale')::json->>'eh';
	v_vs = ((p_data->>'data')::json->>'scale')::json->>'ev';
	v_scaletofit := ((p_data->>'data')::json->>'scale')::json->>'scaleToFit';
	v_legendfactor = (p_data->>'data')::json->>'legendFactor';
	v_linksdistance = (p_data->>'data')::json->>'linksDistance';
	v_composer := (p_data ->> 'data')::json->> 'composer';
	v_templates := (p_data ->> 'data')::json->> 'ComposerTemplates';
	v_papersize := ((p_data ->> 'data')::json->> 'papersize')::json->>'id';

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get projectytpe
	SELECT project_type, giswater FROM sys_version LIMIT 1 INTO v_project_type, v_version;

	-- get systemvalues
	SELECT value INTO v_guitarlegend FROM config_param_system WHERE parameter = 'om_profile_guitarlegend';
	SELECT value INTO v_stylesheet FROM config_param_user WHERE parameter = 'om_profile_stylesheet' AND cur_user = current_user;
	SELECT value::json->>'arc' INTO v_textarc FROM config_param_system WHERE parameter = 'om_profile_guitartext';
	SELECT value INTO v_vdefault FROM config_param_system WHERE parameter = 'om_profile_vdefault';
	SELECT value::json->>'vs' INTO v_vstext FROM config_param_system WHERE parameter = 'om_profile_guitarlegend';
  	SELECT value::json->>'hs' INTO v_hstext FROM config_param_system WHERE parameter = 'om_profile_guitarlegend';
  	SELECT (value::json->>'arc')::json->>'cat_geom1' INTO v_arc_geom1 FROM config_param_system WHERE parameter = 'om_profile_vdefault';
  	SELECT (value::json->>'node')::json->>'cat_geom1' INTO v_node_geom1 FROM config_param_system WHERE parameter = 'om_profile_vdefault';

  	-- set value to v_linksdistance if null
    IF v_linksdistance IS NULL THEN
        v_linksdistance = 0.5;
    END IF;

	-- define variables in function of the project type
	IF v_project_type = 'UD' THEN
		v_fcatgeom = 'cat_geom1'; 
		v_ftopelev = 'top_elev'; 
		v_fymax = 'ymax'; 
		v_fslope = 'slope'; 
		v_fsystopelev = 'sys_top_elev';	v_fsyselev = 'sys_elev'; v_fsysymax = 'sys_ymax';

		v_querytext = ' UNION SELECT c.arc_id, vnode_id,link_id,''LINK'',gully_id, vnode_topelev, vnode_ymax, vnode_elev, vnode_distfromnode1, total_length
				FROM v_arc_x_vnode 
				JOIN anl_arc USING (arc_id)
				JOIN v_edit_gully c ON c.gully_id = v_arc_x_vnode.feature_id
				WHERE fid=222 AND cur_user = current_user
				AND anl_arc.node_1 = v_arc_x_vnode.';
		v_qnode1 = 'node_1 ';
		v_qnode2 = 'node_2 ';
		v_elev1 = 'sys_elev1';
		v_elev2 = 'sys_elev2';
		v_z1 = 'b.z1';
		v_z2 = 'b.z2';
		v_y1 = 'sys_y1';
		v_y2 = 'sys_y2';

	ELSIF v_project_type = 'WS' THEN
		v_fcatgeom = 'cat_dnom::float*0.01'; v_ftopelev = 'elevation'; v_fymax = 'depth'; v_fslope = '100*(elevation1 - depth1 - elevation2 + depth2)/gis_length';
		v_fsyselev = 'elevation - depth'; v_fsystopelev = v_ftopelev; v_fsysymax = v_fymax; 
		v_querytext = '';
		v_qnode1 = '';
		v_qnode2 = '';
		v_elev1 = 'elevation1';
		v_elev2 = 'elevation2';
		v_z1 = '0::integer';
		v_z2 = '0::integer';
		v_y1 = 'depth1';
		v_y2 = 'depth2';
	END IF;

	-- start process
	DELETE FROM anl_arc WHERE fid=222 AND cur_user = current_user;
	DELETE FROM anl_node WHERE fid=222 AND cur_user = current_user;

	-- insert edge values on anl_arc table
	EXECUTE 'INSERT INTO anl_arc (fid, arc_id, code, node_1, node_2, sys_type, arccat_id, cat_geom1, length, slope, total_length, z1, z2, y1, y2, elev1, elev2)
		SELECT  222, arc_id, code, node_id, case when node_1=node_id then node_2 else node_1 end as node_2, sys_type, arccat_id, '||v_fcatgeom||', gis_length, '||v_fslope||', total_length, '||v_z1||', '||v_z2||', '||v_y1||', '||v_y2||', '
		||v_elev1||', '||v_elev2||' FROM v_edit_arc b JOIN cat_arc ON arccat_id = id JOIN 
		(SELECT edge::text AS arc_id, node::text AS node_id, agg_cost as total_length FROM pgr_dijkstra(''SELECT arc_id::int8 as id, node_1::int8 as source, node_2::int8 as target, gis_length::float as cost, 
		gis_length::float as reverse_cost FROM v_edit_arc'', '||v_init||','||v_end||'))a
		USING (arc_id)';

	-- insert node values on anl_node table
	EXECUTE 'INSERT INTO anl_node (fid, node_id, code, '||v_ftopelev||', '||v_fymax||', elev, sys_type, nodecat_id, cat_geom1, arc_id, arc_distance, total_distance)
		SELECT  222, node_id, n.code, '||v_fsystopelev||', '||v_fsysymax||', '||v_fsyselev||', n.sys_type, nodecat_id, null, a.arc_id, 0, total_length FROM v_edit_node n JOIN cat_node ON nodecat_id = id JOIN
		(SELECT edge::text AS arc_id, node::text AS node_id, agg_cost as total_length FROM pgr_dijkstra(''SELECT arc_id::int8 as id, node_1::int8 as source, node_2::int8 as target, gis_length::float as cost, 
		gis_length::float as reverse_cost FROM v_edit_arc'', '||v_init||','||v_end||'))a
		USING (node_id)';
	
	IF v_linksdistance > 0 THEN
	
		-- get vnode values
		EXECUTE 'INSERT INTO anl_node (fid, sys_type, node_id, code, '||v_ftopelev||', '||v_fymax||', elev, arc_id , arc_distance, total_distance)
			SELECT 222, feature_type, feature_id, link_id, vnode_topelev, vnode_ymax, vnode_elev, arc_id, dist, dist+total_length FROM (SELECT DISTINCT ON (dist) * FROM 
			(
			-- connec on same sense (pg_routing & arc)
			SELECT c.arc_id, vnode_id,link_id,''LINK'' as feature_type, connec_id as feature_id,vnode_topelev, vnode_ymax, vnode_elev, vnode_distfromnode1 as dist, total_length
				FROM v_arc_x_vnode 
				JOIN anl_arc USING (arc_id)
				JOIN v_edit_connec c ON c.connec_id = v_arc_x_vnode.feature_id
				WHERE fid=222 AND cur_user = current_user
				AND anl_arc.node_1 = v_arc_x_vnode.node_1
			'||v_querytext||v_qnode1||'-- gully on same sense (pg_routing & arc)
			UNION
			-- connec on reverse sense (pg_routing & arc)
			SELECT c.arc_id, vnode_id,link_id,''LINK'' as feature_type, connec_id as feature_id,vnode_topelev, vnode_ymax, vnode_elev, vnode_distfromnode2 as dist, total_length
				FROM v_arc_x_vnode 
				JOIN anl_arc USING (arc_id)
				JOIN v_edit_connec c ON c.connec_id = v_arc_x_vnode.feature_id
				WHERE fid=222 AND cur_user = current_user
				AND anl_arc.node_1 = v_arc_x_vnode.node_2
			'||v_querytext||v_qnode2||' -- gully on reverse sense (pg_routing & arc)
			)a
		)b 
		ORDER BY b.arc_id, dist';
			
		-- delete links overlaped with nodes using the user's parameter
		v_dist = (SELECT array_agg(total_distance) FROM (SELECT total_distance FROM anl_node WHERE fid=222 AND cur_user = current_user order by total_distance, arc_id)a);
		v_nid = (SELECT array_agg(node_id) FROM (SELECT node_id FROM anl_node WHERE fid=222 AND cur_user = current_user order by total_distance, arc_id)a);
		v_systype = (SELECT array_agg(sys_type) FROM (SELECT sys_type FROM anl_node WHERE fid=222 AND cur_user = current_user order by total_distance, arc_id)a);
		LOOP	
			i = i+1;
			EXIT WHEN v_nid[i] IS NULL;

			--distance values
			IF ((v_dist[i] < (v_dist[i-1]+ v_linksdistance)) OR (v_dist[i] > (v_dist[i+1]+ v_linksdistance))) AND v_systype[i] = 'LINK' THEN
				DELETE FROM anl_node WHERE fid=222 AND cur_user = current_user AND node_id = v_nid[i];
			END IF;			
		END LOOP;
	END IF;

	-- update descript
	EXECUTE 'UPDATE anl_arc SET descript = a.descript FROM (SELECT arc_id, (row_to_json(row)) AS descript FROM ('||v_textarc||')row)a WHERE a.arc_id = anl_arc.arc_id';
	EXECUTE' UPDATE anl_node SET descript = a.descript FROM (SELECT node_id, (row_to_json(row)) AS descript FROM 
				(SELECT node_id, '||v_ftopelev||' as top_elev, '||v_fymax||' as ymax, elev , code, 
				total_distance FROM anl_node WHERE fid=222 AND cur_user = current_user)row)a
				WHERE fid=222 AND cur_user = current_user AND a.node_id = anl_node.node_id';
	-- delete not used keys
	UPDATE anl_arc SET descript = gw_fct_json_object_delete_keys(descript::json, 'arc_id') WHERE fid=222 AND cur_user = current_user ;
	UPDATE anl_node SET descript = gw_fct_json_object_delete_keys(descript::json, 'node_id') WHERE fid=222 AND cur_user = current_user ;

	-- update node table setting default values
	UPDATE anl_arc SET cat_geom1 = v_arc_geom1 WHERE cat_geom1 IS NULL AND fid=222 AND cur_user = current_user;
	UPDATE anl_node SET cat_geom1 = v_node_geom1 WHERE cat_geom1 IS NULL AND fid=222 AND cur_user = current_user AND sys_type !='LINK';

	-- update node table when node has not values and need to be interpolated
	v_dist = (SELECT array_agg(total_distance) FROM (SELECT total_distance FROM anl_node WHERE fid=222 AND cur_user = current_user order by total_distance, arc_id)a);
	EXECUTE '(SELECT array_agg(top_elev) FROM (SELECT '||v_ftopelev||' as top_elev FROM anl_node WHERE fid=222 AND cur_user = current_user order by total_distance, arc_id)a)' INTO v_telev;
	v_elev = (SELECT array_agg(elev) FROM (SELECT elev FROM anl_node WHERE fid=222 AND cur_user = current_user order by total_distance, arc_id)a);
	v_nid = (SELECT array_agg(node_id) FROM (SELECT node_id FROM anl_node WHERE fid=222 AND cur_user = current_user order by total_distance, arc_id)a);

	i = 0;
	LOOP	
		i = i+1;
		EXIT WHEN v_nid[i] IS NULL;
		
		--topelev values
		IF v_telev[i] IS NULL THEN
			IF v_telev[i+1] IS NOT NULL AND v_telev[i-1] IS NOT NULL THEN
				EXECUTE 'UPDATE anl_node SET '||v_ftopelev||' = (v_telev[i-1]+ ((v_dist[i]-v_dist[i-1])*(v_telev[i+1]-v_telev[i-1])/(v_dist[i+1]-v_dist[i-1])))::numeric(12,3) WHERE node_id = v_nid[i]';
			ELSIF v_telev[i+2] IS NOT NULL AND v_telev[i-2] IS NOT NULL THEN
				EXECUTE 'UPDATE anl_node SET '||v_ftopelev||' = (v_telev[i-2]+ ((v_dist[i]-v_dist[i-2])*(v_telev[i+2]-v_telev[i-2])/(v_dist[i+2]-v_dist[i-2])))::numeric(12,3) WHERE node_id = v_nid[i]';
			END IF;

			UPDATE anl_node SET result_id = 'estimated', descript = gw_fct_json_object_set_key(descript::json, 'top_elev', 'N/I'::text) 
			WHERE fid=222 AND cur_user = current_user AND node_id = v_nid[i];
		END IF;
		
		--elev values
		IF v_elev[i] IS NULL THEN
			IF v_elev[i+1] IS NOT NULL AND v_elev[i-1] IS NOT NULL THEN
				UPDATE anl_node SET elev = (v_elev[i-1]+ ((v_dist[i]-v_dist[i-1])*(v_elev[i+1]-v_elev[i-1])/(v_dist[i+1]-v_dist[i-1])))::numeric(12,3) WHERE node_id = v_nid[i];
			ELSIF v_elev[i+2] IS NOT NULL AND v_elev[i-2] IS NOT NULL THEN
				UPDATE anl_node SET elev = (v_elev[i-2]+ ((v_dist[i]-v_dist[i-2])*(v_elev[i+2]-v_elev[i-2])/(v_dist[i+2]-v_dist[i-2])))::numeric(12,3) WHERE node_id = v_nid[i];
			END IF;
			UPDATE anl_node SET  result_id = 'estimated', descript = gw_fct_json_object_set_key(descript::json, 'elev', 'N/I'::text) 
			WHERE fid=222 AND cur_user = current_user AND node_id = v_nid[i];
		END IF;	

		UPDATE 	anl_node SET nodecat_id = 'VNODE' WHERE fid=222 AND cur_user = current_user AND node_id = v_nid[i] AND nodecat_id IS NULL;
	END LOOP;

	-- update node table those ymax nulls
	EXECUTE 'UPDATE anl_node SET descript = gw_fct_json_object_set_key(descript::json, ''ymax'', ''N/I''::text),  '||v_fymax||' = '||v_ftopelev||' - elev 
		WHERE fid=222 AND cur_user = current_user AND '||v_fymax||' IS NULL';

	-- update node table setting those nodes without manhole on surface (isprofilesurface IS FALSE)
	UPDATE anl_node SET sys_type = 'BOTTOM' FROM cat_feature_node n WHERE n.id = sys_type AND isprofilesurface IS FALSE AND fid=222 AND cur_user = current_user;
	UPDATE anl_node SET sys_type = 'TOP-REAL' WHERE sys_type NOT IN ('BOTTOM', 'LINK') AND fid=222 AND cur_user = current_user;
	UPDATE anl_node SET sys_type = 'TOP-ESTIM' WHERE sys_type ='TOP-REAL' AND result_id = 'estimated' AND fid=222 AND cur_user = current_user;
	
	UPDATE anl_node SET result_id = null where result_id is not null AND fid=222 AND cur_user = current_user;

	-- get profile dimensions
	EXECUTE 'SELECT max('||v_ftopelev||')-min(elev) FROM anl_node WHERE fid=222 AND cur_user = current_user'
	INTO v_elevation;
	v_distance = (SELECT max(total_distance) FROM anl_node WHERE fid=222 AND cur_user = current_user);
	
	-- get leaflet dimensions
	v_profheigtht = 1000*v_elevation/v_vs + v_legendfactor*50 + 10;
	v_profwidth = 1000*v_distance/v_hs + v_legendfactor*20 + 10; -- profile + guitar + margin


	-- get portrait extension
	IF v_composer !='' THEN
		SELECT * INTO v_json FROM json_array_elements(v_templates) AS a WHERE a->>'ComposerTemplate' = v_composer;

		-- select map with maximum width
		SELECT array_agg(a->>'width') INTO v_array_width FROM json_array_elements( v_json ->'ComposerMap') AS a;
		SELECT max (a) INTO v_compwidth FROM unnest(v_array_width) AS a;
		SELECT a->>'name' INTO v_mapcomposer_name FROM json_array_elements( v_json ->'ComposerMap') AS a WHERE (a->>'width')::float = v_compwidth::float;
		SELECT a->>'height' INTO v_compheight FROM json_array_elements( v_json ->'ComposerMap') AS a WHERE a->>'name' = v_mapcomposer_name;  
		SELECT a->>'index' INTO v_index FROM json_array_elements( v_json ->'ComposerMap') AS a WHERE a->>'name' = v_mapcomposer_name; 

		IF v_scaletofit IS FALSE THEN
			IF v_compheight < v_profheigtht THEN
				v_level = 2;
				v_message = 'Profile too large. You need to modify the vertical scale or change the composer';
				RETURN (concat('{"status":"accepted", "message":{"level":',v_level,', "text":"',v_message,'"}}')::json);
			END IF;
			IF v_compwidth < v_profwidth THEN
				v_level = 2;
				v_message = 'Profile too long. You need to modify the horitzontal scale or change the composer';
				RETURN (concat('{"status":"accepted", "message":{"level":',v_level,', "text":"',v_message,'"}}')::json);
			END IF;
		END IF;
	ELSE
		-- set values for v_compheight & v_compwidth
		v_compheight = v_profheigtht;
		v_compwidth = v_profwidth;
	END IF;

	
	-- get portrait extension
	IF v_papersize = 0 THEN
		v_compwidth = (((p_data ->> 'data')::json->> 'papersize')::json->>'customDim')::json->>'xdim';
		v_compheight = (((p_data ->> 'data')::json->> 'papersize')::json->>'customDim')::json->>'ydim';
	ELSE
		v_compwidth = (SELECT addparam->>'xdim' FROM om_typevalue WHERE typevalue = 'profile_papersize' AND id = v_papersize::text);
		v_compheight = (SELECT addparam->>'ydim' FROM om_typevalue WHERE typevalue = 'profile_papersize' AND id = v_papersize::text);
	END IF;

	-- check dimensions againts scale
	IF v_scaletofit IS FALSE THEN
		IF v_compheight < v_profheigtht THEN
			v_level = 2;
			v_message = 'Profile too large. You need to modify the vertical scale or change the composer';
			RETURN (concat('{"status":"accepted", "message":{"level":',v_level,', "text":"',v_message,'"}}')::json);
		END IF;
		IF v_compwidth < v_profwidth THEN
			v_level = 2;
			v_message = 'Profile too long. You need to modify the horitzontal scale or change the composer';
			RETURN (concat('{"status":"accepted", "message":{"level":',v_level,', "text":"',v_message,'"}}')::json);
		END IF;
		-- calculate the init point to start to draw profile
		v_initv = (v_compheight - v_profheigtht)/2;
		v_inith = (v_compwidth - v_profwidth)/2;
	ELSE
		-- calculate scale 
		v_vs = (v_compheight - v_legendfactor*50 - 10)/(1000*v_elevation);
		v_hs = (v_compwidth - v_legendfactor*20 - 10)/(1000*v_distance);

		-- calculate the init point to start to draw profile
		v_initv = v_legendfactor*50;
		v_inith = v_legendfactor*20;
	END IF;

	IF v_compwidth IS NOT NULL  and v_compheight IS NOT NULL AND v_inith IS NOT NULL  and v_initv IS NOT NULL 
		AND v_hs IS NOT NULL  AND v_hstext IS NOT NULL  AND v_vs IS NOT NULL AND v_vstext IS NOT NULL THEN

		-- extension as composer (redundant to fit the image as is)
		v_extension = (concat('{"width":', v_compwidth,', "height":', v_compheight,'}'))::json;	

		-- initpoint to start to draw profile
		v_initpoint = (concat('{"initx":', v_inith,', "inity":', v_initv,'}'))::json;	

		-- scale text
		v_scale = concat('1:',v_hs, '(',v_hstext,') - 1:',v_vs,'(',v_vstext,')');
		
		-- update values using scale factor
		v_hs = 2000/v_hs;
		v_vs = 500/v_vs;
	ELSE
		v_vs = 1;
		v_hs= 1;
	END IF;
	
	UPDATE anl_arc SET cat_geom1 = cat_geom1*v_vs, length = length*v_hs WHERE fid=222 AND cur_user = current_user;
	EXECUTE 'UPDATE anl_node SET cat_geom1 = cat_geom1*'||v_vs||', '||v_ftopelev||' = '||v_ftopelev||'*'||v_vs||', elev = elev*'||v_vs||', '||
	v_fymax||' = '||v_fymax||'*'||v_vs||' WHERE fid=222 AND cur_user = current_user';

	-- recover values form temp table into response (filtering by spacing certain distance of length in order to not collapse profile)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_arc
	FROM (SELECT arc_id, descript, cat_geom1, length, z1, z2, y1, y2, elev1, elev2, node_1, node_2 FROM anl_arc WHERE fid=222 AND cur_user = current_user ORDER BY total_length) row;

	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(row))) FROM (SELECT node_id, descript, sys_type, cat_geom1, '||
			v_ftopelev||' AS top_elev, elev, '||v_fymax||' AS ymax FROM anl_node WHERE fid=222 AND cur_user = current_user AND nodecat_id != ''VNODE'' ORDER BY total_distance) row'
			INTO v_node;


	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(row))) FROM (
			WITH querytext AS (SELECT row_number() over (order by total_distance) as rid, * FROM anl_node where fid = 222 AND cur_user = current_user ORDER by total_distance)
			select row_number() over (order by a.total_distance) as rid, a.'||v_ftopelev||' as top_n1, b.'||v_ftopelev||' as top_n2, (b.'||v_ftopelev||'-a.'||v_ftopelev||')::numeric(12,3) as delta_y, 
			b.total_distance - a.total_distance as delta_x, a.total_distance as total_x, a.descript as label_n1 from querytext a
			join querytext b ON a.rid = b.rid-1 
			join (select * from anl_arc where fid = 222 AND cur_user = current_user) c ON a.arc_id = c.arc_id) row'
			INTO v_terrain;

	-- control null values
	IF v_guitarlegend IS NULL THEN v_guitarlegend='{}'; END IF;
	IF v_stylesheet IS NULL THEN v_stylesheet='{}'; END IF;

	v_scale := COALESCE(v_scale, '{}'); 
	v_extension := COALESCE(v_extension, '{}'); 
	v_initpoint := COALESCE(v_initpoint, '{}'); 	
	v_arc := COALESCE(v_arc, '{}'); 
	v_node := COALESCE(v_node, '{}'); 
	v_terrain := COALESCE(v_terrain, '{}'); 


	-- default values
	v_status = 'Accepted';	
        v_level = 3;
        v_message = 'Profile done successfully';

	--  Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
               ',"data":{"legend":'||v_guitarlegend||','||
			'"scale":"'||v_scale||'",'||
			'"extension":'||v_extension||','||
			'"initpoint":'||v_initpoint||','||
			'"stylesheet":'||v_stylesheet||','||
			'"node":'||v_node||','||
			'"terrain":'||v_terrain||','||
			'"arc":'||v_arc||'}}}')::json;
	
	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;