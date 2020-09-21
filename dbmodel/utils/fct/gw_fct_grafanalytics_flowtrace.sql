/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: 2772

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_flowtrace(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_flowtrace(p_data json)
RETURNS json AS
$BODY$

/*
--EXAMPLE
SELECT SCHEMA_NAME.gw_fct_grafanalytics_flowtrace('{"data":{"parameters":{"grafClass":"DISCONNECTEDARCS", "exploitation": "[1]", "nodeId":"37"}}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_flowtrace('{"data":{"parameters":{"grafClass":"CONNECTEDARCS","exploitation": "[557]",  "nodeId":"5100"}}}');

--RESULTS
SELECT * FROM anl_arc WHERE fid=193 AND cur_user=current_user
SELECT * FROM anl_arc WHERE fid=194 AND cur_user=current_user

-- fid, 193, 194

*/

DECLARE
affected_rows numeric;
v_count integer default 0;
v_nodeid text;
v_sum integer = 0;
v_class text;
v_fid integer;
v_sign varchar(2);
v_expl json;	
v_text text;
v_querytext text;
v_result text;
v_result_info json;
v_result_line json;
v_version text;
v_projectype varchar(2);
v_srid int4;
v_error_context text;
	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get values
   	v_nodeid = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'nodeId');
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'grafClass');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');

	-- select config values
	SELECT giswater, epsg, project_type INTO v_version, v_srid, v_projectype FROM sys_version order by 1 desc limit 1;

	-- set values
	IF v_class = 'DISCONNECTEDARCS' THEN 
		v_fid=193;
		v_sign = '=';
	ELSIF v_class = 'CONNECTEDARCS' THEN 
		v_fid=194;
		v_sign = '>';
	END IF;

	-- reset graf & audit tables
	DELETE FROM anl_arc where cur_user=current_user AND fid=v_fid;
	DELETE FROM audit_check_data WHERE fid=v_fid AND cur_user=current_user;
	TRUNCATE temp_anlgraf;	

	-- reset exploitation
	IF v_expl IS NOT NULL THEN
		DELETE FROM selector_expl WHERE cur_user=current_user;
		INSERT INTO selector_expl (expl_id, cur_user) 
		SELECT expl_id, current_user FROM exploitation WHERE expl_id IN	(SELECT (json_array_elements_text(v_expl))::integer);
	END IF;	

	-- Starting process
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('FLOWTRACE ANALYTICS - ', upper(v_class)));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('----------------------------------------------------------'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');

	-- fill the graf table
	INSERT INTO temp_anlgraf (arc_id, node_1, node_2, water, flag, checkf)
	SELECT  arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
	UNION
	SELECT  arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;

	
	-- set boundary conditions of graf table ONLY FOR WS (flag=1 it means water is disabled to flow)
	IF v_projectype = 'WS' THEN
	
		v_text = 'SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id from sector WHERE grafconfig IS NOT NULL';

		-- close boundary conditions setting flag=1 for all nodes that fits on graf delimiters and closed valves
		v_querytext  = 'UPDATE temp_anlgraf SET flag=1 WHERE 
			node_1 IN('||v_text||' UNION
			SELECT (a.node_id) FROM node a 	JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.nodetype_id 
			LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer JOIN temp_anlgraf e ON a.node_id::integer=e.node_1::integer WHERE (graf_delimiter=''MINSECTOR'' AND closed=TRUE))
			OR node_2 IN ('||v_text||' UNION
			SELECT (a.node_id) FROM node a 	JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.nodetype_id 
			LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer JOIN temp_anlgraf e ON a.node_id::integer=e.node_1::integer WHERE (graf_delimiter=''MINSECTOR'' AND closed=TRUE))';
				
		EXECUTE v_querytext;

		-- open boundary conditions set flag=0 for graf delimiters that have been setted to 1 on query before BUT ONLY ENABLING the right sense (to_arc)
		UPDATE temp_anlgraf SET flag=0 WHERE id IN (
			SELECT id FROM temp_anlgraf JOIN (
			SELECT (json_array_elements_text((grafconfig->>'use')::json))::json->>'nodeParent' as node_id, 
			json_array_elements_text(((json_array_elements_text((grafconfig->>'use')::json))::json->>'toArc')::json) 
			as to_arc from sector 
			where grafconfig is not null order by 1,2) a 
			ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);
	END IF;
		
	-- init inlet
	UPDATE temp_anlgraf	SET flag=1, water=1 WHERE node_1 = v_nodeid; 

	-- inundation process
	LOOP
		v_count = v_count+1;
                update temp_anlgraf n set water= 1, flag=n.flag+1 from v_anl_graf a where n.node_1 = a.node_1  and n.arc_id = a.arc_id;

		GET DIAGNOSTICS affected_rows =row_count;
		exit when affected_rows = 0;
		EXIT when v_count = 400;

		v_sum = v_sum + affected_rows;
		RAISE NOTICE ' % % %', v_count, affected_rows, v_sum;
	END LOOP;
	
	-- insert into result table
	EXECUTE 'INSERT INTO anl_arc (fid, arc_id, the_geom, descript)
		SELECT DISTINCT ON (a.arc_id) '||v_fid||', a.arc_id, the_geom, '''||v_class||'''	FROM temp_anlgraf a
		JOIN arc b ON a.arc_id=b.arc_id GROUP BY a.arc_id, the_geom HAVING max(water) '||v_sign||' 0 ';

	-- count arcs
	EXECUTE 'SELECT count(*) FROM (SELECT DISTINCT ON (arc_id) count(*) FROM temp_anlgraf GROUP BY arc_id HAVING max(water)'||v_sign||' 0 )a'
		INTO v_count;

	INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, '');
	INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, concat('Number of arcs identifed on the process: ', v_count));


	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- arcs
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT arc_id, arccat_id, state, expl_id, descript, the_geom FROM v_edit_arc WHERE arc_id IN 
	(SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 


	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	
	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}, "data":{ "info":'||v_result_info||','||
					  '"line":'||v_result_line||
					  '}}}')::json, 2772);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;