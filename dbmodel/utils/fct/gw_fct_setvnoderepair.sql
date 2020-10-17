/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2998
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setvnoderepair(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 296

SELECT SCHEMA_NAME.gw_fct_setvnoderepair($${ "client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"parameters":{"tolerance":"0.01", "forceNodes":false}}}$$);

*/

DECLARE
 
v_count integer;
v_result text;
v_version text;
v_projecttype text;
v_saveondatabase boolean;

v_id json;
v_selectionmode text;
v_worklayer text;
v_array text;
v_result_info json;
v_result_point json;
v_result_line json;
v_tolerance double precision;
v_vnodes record;
v_fid integer = 296;
v integer = 0;
v_forcenodes boolean = false;

BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- Delete previous log results
	DELETE FROM anl_node WHERE fid=v_fid AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=v_fid AND cur_user=current_user;

	-- select config values
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version order by 1 desc limit 1;

	-- getting input data 	
	v_tolerance :=  (((p_data ->>'data')::json->>'parameters')::json)->>'tolerance';
	v_forcenodes :=  (((p_data ->>'data')::json->>'parameters')::json)->>'forceNodes';
    
	-- repair vnode's overlaped
	FOR v_vnodes IN SELECT DISTINCT ON(the_geom) n1.vnode_id as n1, n2.vnode_id as n2, n1.the_geom FROM vnode n1, vnode n2 WHERE st_dwithin(n1.the_geom, n2.the_geom, v_tolerance) AND n1.vnode_id != n2.vnode_id 
	LOOP
		RAISE NOTICE ' v_vnodes %', v_vnodes;
		UPDATE link SET exit_id = v_vnodes.n1, the_geom = ST_SetPoint(the_geom,  ST_NumPoints(the_geom) - 1, v_vnodes.the_geom) WHERE exit_id::integer = v_vnodes.n2 AND exit_type = 'VNODE';
		UPDATE connec SET pjoint_id = v_vnodes.n1 WHERE pjoint_id::integer = v_vnodes.n2 AND pjoint_type = 'VNODE';
		IF v_projecttype = 'UD' THEN
			UPDATE gully SET pjoint_id = v_vnodes.n1 WHERE pjoint_id::integer = v_vnodes.n2 AND pjoint_type = 'VNODE';
		END IF;
		DELETE FROM vnode WHERE vnode_id = v_vnodes.n2;
		INSERT INTO anl_node (node_id, fid, the_geom, descript) VALUES (v_vnodes.n2, v_fid, v_vnodes.the_geom, concat(v_vnodes.n1,'+',v_vnodes.n2,'--->',v_vnodes.n1));
	END LOOP;
				
	-- repair vnode's over nodes (it's dangerous becasuse on WS when connec is related to node will lose the capability to be used on psector)
	IF (v_projecttype = 'WS' AND v_forcenodes) OR v_projecttype = 'UD' THEN
		FOR v_vnodes IN 
		SELECT DISTINCT ON(the_geom) n1.node_id as n1, n2.vnode_id as n2, n1.the_geom FROM node n1, vnode n2 WHERE st_dwithin(n1.the_geom, n2.the_geom, v_tolerance)
		LOOP
			v = v+1;
			RAISE NOTICE ' %: vnodes %', v, v_vnodes;
			
			-- check if it is possible to repair because not has psector assigned on ws
			IF (SELECT a.connec_id FROM (SELECT feature_id as connec_id FROM link WHERE exit_id::integer = v_vnodes.n2) a JOIN plan_psector_x_connec USING (connec_id)) IS NOT NULL AND v_projecttype = 'WS' THEN
				RAISE NOTICE 'vnode % not have been repaired. See log for more details', v_vnodes.n2;
				INSERT INTO anl_node (node_id, fid, the_geom, descript) VALUES (v_vnodes.n2, v_fid, v_vnodes.the_geom, concat(v_vnodes.n1,' NOT REPAIRED AGAINTS ',v_vnodes.n2));
			ELSE
				UPDATE link SET exit_id = v_vnodes.n1 , exit_type = 'NODE', the_geom = ST_SetPoint(the_geom, ST_NumPoints(the_geom) - 1, v_vnodes.the_geom) WHERE exit_id::integer = v_vnodes.n2 AND exit_type = 'VNODE';
				UPDATE connec SET pjoint_id = v_vnodes.n1, pjoint_type = 'NODE' WHERE pjoint_id::integer = v_vnodes.n2 AND pjoint_type = 'VNODE';
				IF v_projecttype = 'UD' THEN
					UPDATE gully SET pjoint_id = v_vnodes.n1, pjoint_type = 'NODE' WHERE pjoint_id::integer = v_vnodes.n2 AND pjoint_type = 'VNODE';
				END IF;
				DELETE FROM vnode WHERE vnode_id = v_vnodes.n2;
				INSERT INTO anl_node (node_id, fid, the_geom, descript) VALUES (v_vnodes.n2, v_fid, v_vnodes.the_geom, concat(v_vnodes.n1,'+',v_vnodes.n2,'--->',v_vnodes.n1));
			END IF;
		END LOOP;
	END IF;

	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('VNODE REPAIR'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('-----------------------------'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat (' vnodes: vnode_id --> ', 
	(SELECT array_agg(descript) FROM (SELECT descript FROM anl_node WHERE fid=v_fid AND cur_user=current_user)a )));
	
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND ( fid=296)) row;
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
  	FROM  anl_node WHERE cur_user="current_user"() AND fid = 296) row) features;

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
