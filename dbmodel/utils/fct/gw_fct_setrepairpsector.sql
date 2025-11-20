/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3288

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setrepairpsector(p_data json)
  RETURNS json AS
$BODY$

/*
descrption
This function:
- fill link_id for connects with state 0 where link_id is null
- find and repair operative/planned arcs without operative nodes in this psector
- find and repair planned arcs without planned nodes in this psector

example
SELECT gw_fct_setrepairpsector($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},"psectorId":"1"}}$$);

fid 521;

*/

DECLARE

v_device integer;
v_infotype integer;
v_tablename text;
v_projecttype text;
v_fid integer = 521;
v_psector integer;
v_query text;
v_count integer = 0;
v_message text;
v_version text;
v_result json;
v_result_info json;
v_result_line json;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get project type
	v_projecttype = (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);
	v_version = (SELECT giswater FROM sys_version ORDER BY id DESC LIMIT 1);

	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_psector := ((p_data ->> 'data')::json->> 'psectorId');

	DELETE FROM anl_arc WHERE fid = v_fid AND cur_user= current_user;
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user= current_user;

	-- init process
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('REPAIR PSECTOR'));
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '---------------------------------------------');

	-- fill links for connects state 0 and link null
	UPDATE plan_psector_x_connec p SET link_id = l.link_id FROM link l WHERE feature_id = connec_id AND l.state = 1
	AND p.state = 0 AND p.link_id is null AND psector_id = v_psector;

	GET DIAGNOSTICS v_count = row_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (v_fid, v_fid, 3, FALSE, concat(v_count,' Downgraded connecs in this psector without link_id have been repaired.'),v_count);
	END IF;

	IF v_projecttype = 'UD' THEN
		UPDATE plan_psector_x_gully p SET link_id = l.link_id FROM link l WHERE feature_id = gully_id AND l.state = 1
		AND p.state = 0 AND p.link_id is null AND psector_id = v_psector;

		GET DIAGNOSTICS v_count = row_count;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (v_fid, v_fid, 3, FALSE, concat(v_count,' Downgraded gullies in this psector without link_id have been repaired.'),v_count);
		END IF;
	END IF;

	-- find operative/planned arcs without operative nodes in this psector
	v_query = '
	select a.arc_id, a.arccat_id, node_id, '|| v_psector ||' as psector_id, a.the_geom FROM arc a
	join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0)n on node_1= node_id
	left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
	where p.arc_id is null and a.state>0
	union
	select a.arc_id, a.arccat_id, node_id, '|| v_psector ||' as psector_id, a.the_geom FROM arc a
	join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0 )n on node_2 = node_id
	left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
	where p.arc_id is null and a.state>0';

	raise notice 'v_query :>> %', v_query;

	EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
	INTO v_count;

	IF v_count > 0 THEN

		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
		SELECT ',v_fid,', c.arc_id, c.arccat_id, concat(''Arc '', arc_id ,'' without some start/end operative nodes in this psector '',c.psector_id), c.the_geom, 1 FROM (', v_query,')c ');

		INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (v_fid, v_fid, 3, FALSE, concat(v_count,' arcs without some start/end operative nodes in this psector have been repaired.'),v_count);

		DELETE FROM plan_psector_x_node WHERE node_id IN (SELECT a.node_1 FROM arc a JOIN node n ON node_id = node_1 JOIN anl_arc l ON l.arc_id  = a.arc_id WHERE fid = v_fid) AND psector_id = v_psector;
		DELETE FROM plan_psector_x_node WHERE node_id IN (SELECT a.node_2 FROM arc a JOIN node n ON node_id = node_2 JOIN anl_arc l ON l.arc_id  = a.arc_id WHERE fid = v_fid) AND psector_id = v_psector;
	END IF;

	--find planned arcs without planned nodes in this psector
	v_query = '
	select a.arc_id, arccat_id, a.the_geom FROM arc a
	join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') pa ON pa.arc_id = a.arc_id
	join node ON node_id = a.node_1
	left join (select * from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 1) pn ON pn.node_id = a.node_1
	where pn.node_id is null and a.state=2 and node.state = 2
	union
	select a.arc_id, arccat_id, a.the_geom FROM arc a
	join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') pa ON pa.arc_id = a.arc_id
	join node ON node_id = a.node_2
	left join (select * from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 1) pn ON pn.node_id = a.node_2
	where pn.node_id is null and a.state=2  and node.state = 2';

	raise notice 'v_query :>> %', v_query;

	EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
	INTO v_count;

	IF v_count > 0 THEN

		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
		SELECT ',v_fid,', c.arc_id, c.arccat_id, concat(''Planned arc  '', arc_id ,'' without some planned start/end node in this psector''), c.the_geom, 2 FROM (', v_query,')c ');

		INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (v_fid, v_fid, 3, FALSE, concat(v_count,' planned arcs without some start/end planned node in this psector have been repaired.'),v_count);

		-- recover planned nodes
		INSERT INTO plan_psector_x_node (node_id, psector_id)
		SELECT node_1, v_psector FROM arc WHERE node_1 IN (SELECT arc.node_1 FROM arc JOIN anl_arc a USING (arc_id) JOIN node ON node_id = arc.node_1
		WHERE node.state = 2 AND fid = v_fid)
		ON CONFLICT (node_id, psector_id) DO NOTHING;

		INSERT INTO plan_psector_x_node (node_id, psector_id)
		SELECT node_2, v_psector FROM arc WHERE node_2 IN (SELECT arc.node_2 FROM arc JOIN anl_arc a USING (arc_id) JOIN node ON node_id = arc.node_2
		WHERE node.state = 2 AND fid = v_fid)
		ON CONFLICT (node_id, psector_id) DO NOTHING;
	END IF;


	SELECT count(*) INTO v_count FROM audit_check_data WHERE fid = v_fid AND cur_user = current_user;


	-- count of total repaired features
	INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
	VALUES (v_fid, v_fid, 3, FALSE, concat(v_count, ' features have been repaired in psector_id ', v_psector) ,v_count);


	v_message = '{"level": 3, "text": "Feature have been succesfully updated."}';

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--lines
	v_result = null;
	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (SELECT id, arc_id, arccat_id, state, descript, node_1, node_2, expl_id, fid, st_length(the_geom) as length, ST_Transform(the_geom, 4326) as the_geom
	  	FROM  anl_arc WHERE cur_user="current_user"() AND fid = v_fid) row) features;

	v_result_line = v_result;
	v_message := 'Process done succesfully';

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":3, "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"info":'||v_result_info||', "line":'||v_result_line||
			'}}'||
	    '}')::json, 3288, null, null, null);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM),  'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;