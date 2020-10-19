/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2994
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_vnode_repair();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setvnoderepair(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 296
	,298,299,300,301

SELECT  gw_fct_setvnoderepair($${ "client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},"feature":{}, "data":{"parameters":{}}}$$);  -- when is called from checkproject
SELECT  gw_fct_setvnoderepair($${ "client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},"feature":{}, "data":{"parameters":{"fid":227}}}$$);  -- when is called from go2epa

SELECT * FROM anl_node WHERE fid IN (298,299,300,301);
SELECT * FROM audit_check_data WHERE fid = 296

*/

DECLARE

v_link record;
v_id integer;
 
v_count integer;
v_result text;
v_version text;
v_projecttype text;
v_saveondatabase boolean;

v_result_info json;
v_result_point json;
v_result_line json;
v_tolerance double precision;
v_vnodes record;
v integer = 0;
v_fid integer;
v_geom geometry;
v_loop record;
v_node record;
v_end_point geometry;

BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- select config values
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version order by 1 desc limit 1;

	-- getting input data 	
	v_tolerance :=  (((p_data ->>'data')::json->>'parameters')::json)->>'tolerance';
	IF v_tolerance IS NULL THEN v_tolerance = 0.1; END IF;

	v_fid :=  (((p_data ->>'data')::json->>'parameters')::json)->>'fid';
	IF v_fid IS NULL THEN v_fid = 296; END IF;
		
	-- Delete previous log results
	DELETE FROM anl_node WHERE fid IN (298,299,300,301) AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=296 AND cur_user=current_user;

	-- harmonize state of vnodes according link
	UPDATE vnode set state=0 FROM link WHERE link.exit_type ='VNODE' and exit_id = vnode_id::text AND link.state=0;
	UPDATE vnode set state=1 FROM link WHERE link.exit_type ='VNODE' and exit_id = vnode_id::text AND link.state=1;

	-- create vnode when is missed at the end of link and exit type is vnode
	FOR v_link IN SELECT l.*, vnode.* FROM v_edit_link l LEFT JOIN vnode ON vnode_id = exit_id::integer WHERE l.exit_type ='VNODE' AND (exit_id IS NULL or vnode_id IS NULL)
	LOOP 
		INSERT INTO vnode (state, the_geom) VALUES (v_link.state, st_endpoint(v_link.the_geom)) RETURNING vnode_id INTO v_id;
		INSERT INTO anl_node (node_id, fid, the_geom, descript) VALUES (v_id, 298, st_endpoint(v_link.the_geom), 'VNODE created using endpoint of orphan link');
		UPDATE link SET exit_id = v_id WHERE link_id = v_link.link_id;
		SELECT the_geom INTO v_geom FROM vnode WHERE vnode_id = v_id;
		UPDATE connec SET pjoint_id = v_id, pjoint_type = 'VNODE' WHERE connec_id = v_link.feature_id AND feature_type = 'CONNEC';
		IF v_projecttype = 'UD' THEN
			UPDATE gully SET pjoint_id = v_id, pjoint_type = 'VNODE' WHERE gully_id = v_link.feature_id AND feature_type = 'GULLY';
		END IF;		
	END LOOP;
	--log
	SELECT count(*) INTO v_count FROM anl_node WHERE fid = 298 AND cur_user = current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat ('INFO: There were ', v_count, ' orphan vnode links that have been automatic created. See log N-298 for more details'));
	END IF;

	-- create vnode when is missed at the end of link and exit type is vnode
	FOR v_link IN SELECT l.* FROM v_edit_link l WHERE l.exit_type ='NODE' AND exit_id IS NULL
	LOOP 
		-- getting node with infinity buffer
		WITH index_query AS(
			SELECT ST_Distance(the_geom, v_link.the_geom) as d, node.* FROM node WHERE state=1 ORDER BY the_geom <-> v_link.the_geom LIMIT 5)
			SELECT * INTO v_node FROM index_query ORDER BY d limit 1;
			
		-- Update link
		v_end_point = (ST_ClosestPoint(v_node.the_geom, (ST_endpoint(v_link.the_geom))));
		v_link.the_geom = (ST_SetPoint(v_link.the_geom, -1, v_end_point));
		UPDATE link SET the_geom = v_link.the_geom, exit_id = v_node.node_id WHERE link_id = v_link.link_id;
		UPDATE connec SET pjoint_id = v_link.link_id, pjoint_type = 'NODE' WHERE connec_id = v_link.feature_id AND feature_type = 'CONNEC';
		IF v_projecttype = 'UD' THEN
			UPDATE gully SET pjoint_id = v_link.link_id, pjoint_type = 'NODE' WHERE gully_id = v_link.feature_id AND feature_type = 'GULLY';
		END IF;		

		-- log message
		INSERT INTO anl_node (node_id, fid, the_geom, descript) VALUES (v_node.node_id, 301, st_endpoint(v_link.the_geom), 'LINK reconnected to existing node and connects updated');
	
	END LOOP;
	--log
	SELECT count(*) INTO v_count FROM anl_node WHERE fid = 301 AND cur_user = current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat ('INFO: There were ', v_count, ' orphan links with node and have been automatic created. See log N-301 for more details'));
	END IF;


	-- delete vnode when no link's is related to
	SELECT count(*) INTO v_count FROM vnode LEFT JOIN link ON exit_id::integer = vnode_id WHERE link_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO anl_node (node_id, fid, the_geom, descript) SELECT vnode_id, 299, v.the_geom, 'VNODE deleted because no link related' FROM vnode v LEFT JOIN link ON exit_id::integer = vnode_id WHERE link_id IS NULL;
		DELETE FROM vnode WHERE vnode_id IN (SELECT vnode_id FROM vnode LEFT JOIN link ON exit_id::integer = vnode_id WHERE link_id IS NULL);
		INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat('INFO: There were ', v_count, ' orphan vnodes that have been automatic removed. See log N-299 for more details'));
	END IF;
	
	-- repair vnode's overlaped	
	LOOP 	
		-- count
		SELECT COUNT (*) INTO v_count FROM vnode n1, vnode n2 WHERE st_dwithin(n1.the_geom, n2.the_geom, v_tolerance) AND n1.vnode_id != n2.vnode_id;
		EXIT WHEN v_count = 0;
		FOR v_vnodes IN SELECT DISTINCT ON(the_geom) n1.vnode_id as n1, n2.vnode_id as n2, n1.the_geom FROM vnode n1, vnode n2 WHERE st_dwithin(n1.the_geom, n2.the_geom, v_tolerance) AND n1.vnode_id != n2.vnode_id 
		LOOP
			RAISE NOTICE ' v_vnodes %', v_vnodes;
			UPDATE link SET exit_id = v_vnodes.n1, the_geom = ST_SetPoint(the_geom,  ST_NumPoints(the_geom) - 1, v_vnodes.the_geom) WHERE exit_id::integer = v_vnodes.n2 AND exit_type = 'VNODE';
			UPDATE connec SET pjoint_id = v_vnodes.n1 WHERE pjoint_id::integer = v_vnodes.n2 AND pjoint_type = 'VNODE';
			IF v_projecttype = 'UD' THEN
				UPDATE gully SET pjoint_id = v_vnodes.n1 WHERE pjoint_id::integer = v_vnodes.n2 AND pjoint_type = 'VNODE';
			END IF;
			DELETE FROM vnode WHERE vnode_id = v_vnodes.n2;
			INSERT INTO anl_node (node_id, fid, the_geom, descript) VALUES (v_vnodes.n2, 300, v_vnodes.the_geom, concat('VNODE fusioned ',v_vnodes.n1,'+',v_vnodes.n2,'--->',v_vnodes.n1));
		END LOOP;
	END LOOP;
	
	--log
	SELECT count(*) INTO v_count FROM anl_node WHERE fid = 300 AND cur_user = current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat('INFO: There were ', v_count, ' overlaped vnode(s) that have been automatic fusioned. See log N-300 for more details'));
	END IF;
	
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND ( fid=v_fid)) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--lines
	v_result = null;

	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, node_id, descript, fid, the_geom
  	FROM  anl_node WHERE cur_user="current_user"() AND fid IN(298,299,300,301)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}'); 

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	
	--  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"setVisibleLayers":[]'||
		       '}}'||
	    '}')::json;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
