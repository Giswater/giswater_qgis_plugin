/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- Part of code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: 2680

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_inlet_flowtrace(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_network(p_data json)
RETURNS json AS
$BODY$

/*
--EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_network('{"data":{"parameters":{"resultId":"z1","fid":227}}}')::json; -- when is called from go2epa
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_network('{"data":{"parameters":{"resultId":"test_20201016"}}}')::json; -- when is called from toolbox

--RESULTS
SELECT node_id FROM anl_node WHERE fid = 233 AND cur_user=current_user
SELECT arc_id FROM anl_arc WHERE fid = 232 AND cur_user=current_user
SELECT node_id FROM anl_node WHERE fid = 139 AND cur_user=current_user
SELECT * FROM audit_check_data WHERE fid = 139
SELECT * FROM temp_anlgraf;

-- fid: main:139
	other: 227,231,233,228

*/

DECLARE

v_project_type text;
v_affectedrows numeric;
v_cont integer default 0;
v_buildupmode int2;
v_result_id text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_boundaryelem text;
v_error_context text;
v_fid integer;
v_querytext text;
v_count integer = 0;
v_min float;
v_max float;
v_version text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	--  Get input data
	v_result_id = ((p_data->>'data')::json->>'parameters')::json->>'resultId';
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';
	
	-- get project type
	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);
	v_version = (SELECT giswater FROM sys_version LIMIT 1);
	
	-- manage no found results
	IF (SELECT result_id FROM rpt_cat_result WHERE result_id=v_result_id) IS NULL THEN
		v_result  = (SELECT array_to_json(array_agg(row_to_json(row))) FROM (SELECT 1::integer as id, 'No result found whith this name....' as  message)row);
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
		RETURN ('{"status":"Accepted", "message":{"level":1, "text":"No result found"}, "version":"'||v_version||'"'||
			',"body":{"form":{}, "data":{"info":'||v_result_info||'}}}')::json;		
	END IF; 
	
	-- elements
	IF v_project_type  = 'WS' THEN
		v_boundaryelem = 'tank or reservoir';
	ELSIF v_project_type  = 'UD' THEN
		v_boundaryelem = 'outfall';
	END IF;
	
	TRUNCATE temp_anlgraf;
	DELETE FROM anl_arc where cur_user=current_user AND fid IN (232,231,139);
	DELETE FROM anl_node where cur_user=current_user AND fid IN (233,228,139,290);
	DELETE FROM audit_check_data where cur_user=current_user AND fid = 139;
		
	IF v_fid is null THEN
		v_fid = 139;
	END IF;
	
	-- Header
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 4, 'CHECK RESULT NETWORK ACORDING EPA RULES');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 4, '-------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 1, '-------');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 0, 'NETWORK ANALYTICS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 0, '-------------------------');


	RAISE NOTICE '1 - Check result orphan nodes on rpt tables (fid:  228)';
	v_querytext = '(SELECT node_id, nodecat_id, the_geom FROM (
			SELECT node_id FROM temp_node where result_id = '||quote_literal(v_result_id)||' and sector_id > 0 EXCEPT 
			(SELECT node_1 as node_id FROM temp_arc where result_id = '||quote_literal(v_result_id)||' UNION
			SELECT node_2 FROM temp_arc where result_id = '||quote_literal(v_result_id)||'))a
			JOIN temp_node USING (node_id)) b';
	
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0  THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
		SELECT 228, node_id, nodecat_id, ''Orphan node'', the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, count)
		VALUES (v_fid, 3, concat('ERROR: There is/are ',v_count,
		' node''s orphan on this result. Some inconsistency may have been generated because state_type (228).'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, result_id, error_message, count)
		VALUES (v_fid, v_result_id, 1, 'INFO: No node(s) orphan found on this result.', v_count);
	END IF;

	RAISE NOTICE '2 - Check result duplicated nodes on rpt tables (fid:  290)';
	v_querytext = '(SELECT DISTINCT ON(the_geom) n1.node_id as n1, n2.node_id as n2, n1.the_geom FROM temp_node n1, temp_node n2 
			WHERE st_dwithin(n1.the_geom, n2.the_geom, 0.00001) AND n1.node_id != n2.node_id ) b';

	
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0  THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, descript, the_geom)
		SELECT 290, n1, concat(''Duplicated node with '', n2 ), the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 3, concat('ERROR: There is/are ',v_count,
		' node(s) duplicated on this result. It means that there is a topological jump on that point (state 0-1-2). Please check your network'));
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, 'INFO: No node(s) orphan found on this result.');
	END IF;

	
	RAISE NOTICE '3 - Check result arcs without start/end node (fid:  231)';
	v_querytext = '	SELECT 231, arc_id, arccat_id, state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arcs without node_1 or node_2.'' FROM temp_arc where result_id = '||quote_literal(v_result_id)||'
			EXCEPT ( 
			SELECT 231, arc_id, arccat_id, state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arcs without node_1 or node_2.'' FROM temp_arc JOIN 
			(SELECT node_id FROM temp_node where result_id = '||quote_literal(v_result_id)||' ) a ON node_1=node_id where result_id = '||quote_literal(v_result_id)||'
			UNION 
			SELECT 231, arc_id, arccat_id, state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arcs without node_1 or node_2.'' FROM temp_arc  JOIN
			(SELECT node_id FROM temp_node where result_id = '||quote_literal(v_result_id)||') b ON node_2=node_id where result_id = '||quote_literal(v_result_id)||')';

	EXECUTE 'SELECT count(*) FROM ('||v_querytext ||')a'
		INTO v_count;

	IF v_count > 0 THEN
		EXECUTE 'INSERT INTO anl_arc (fid, arc_id, arccat_id, state, expl_id, the_geom, result_id, descript)'||v_querytext;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, count)
		VALUES (v_fid, v_result_id, 3, concat('ERROR: There is/are ',v_count,
		' arc(s) without start/end nodes on this result. Some inconsistency may have been generated because state_type.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, count)
		VALUES (v_fid, v_result_id, 1,'INFO: There is/are no arcs without start/end nodes on this result.',v_count);
	END IF;
	

	RAISE NOTICE '4 - Check disconnected network';	
	
	-- fill the graf table
	INSERT INTO temp_anlgraf (arc_id, node_1, node_2, water, flag, checkf)
	select  a.arc_id, case when node_1 is null then '00000' else node_1 end, case when node_2 is null then '00000' else node_2 end, 0, 0, 0
	from temp_arc a where result_id = v_result_id
	union all
	select  a.arc_id, case when node_2 is null then '00000' else node_2 end, case when node_1 is null then '00000' else node_1 end, 0, 0, 0
	from temp_arc a where result_id = v_result_id
	ON CONFLICT (arc_id, node_1) DO NOTHING;

	-- set boundary conditions of graf table
	IF v_project_type = 'WS' THEN
		UPDATE temp_anlgraf
			SET flag=1, water=1 
			WHERE node_1 IN (SELECT node_id FROM temp_node WHERE (epa_type='RESERVOIR' OR epa_type='INLET' OR epa_type='TANK'));

		UPDATE temp_anlgraf
			SET flag=1, water=1 
			WHERE node_2 IN (SELECT node_id FROM temp_node WHERE (epa_type='RESERVOIR' OR epa_type='INLET' OR epa_type='TANK'));
		
	ELSIF v_project_type = 'UD' THEN
		UPDATE temp_anlgraf
			SET flag=1, water=1 
			WHERE node_1 IN (SELECT node_id FROM temp_node WHERE epa_type='OUTFALL');
	END IF;
		
	-- inundation process
	LOOP
		v_cont = v_cont+1;
		update temp_anlgraf n set water= 1, flag=n.flag+1 from v_anl_graf a where n.node_1 = a.node_1 and n.arc_id = a.arc_id;
		GET DIAGNOSTICS v_affectedrows =row_count;
		EXIT WHEN v_affectedrows = 0;
		EXIT WHEN v_cont = 2000;
			RAISE NOTICE '% - %', v_cont, v_affectedrows;
	END LOOP;

	-- insert into result table disconnected arcs
	INSERT INTO anl_arc (fid, result_id, arc_id, the_geom, descript)
	SELECT DISTINCT ON (a.arc_id) 139, v_result, a.arc_id, the_geom, concat('Arc disconnected from any', v_boundaryelem)  
		FROM temp_anlgraf a
		JOIN temp_arc b ON a.arc_id=b.arc_id
		GROUP BY a.arc_id,the_geom
		having max(water) = 0;

	INSERT INTO anl_node (fid, result_id, node_id, the_geom, descript)
	SELECT DISTINCT ON (a.node_1) 139, v_result, a.node_1, the_geom, concat('Node disconnected from any', v_boundaryelem)  
		FROM temp_anlgraf a
		JOIN temp_node b ON a.node_1=b.node_id
		GROUP BY a.node_1,the_geom
		having max(water) = 0;

	INSERT INTO anl_node (fid, result_id, node_id, the_geom, descript)
	SELECT DISTINCT ON (a.node_2) 139, v_result, a.node_2, the_geom, concat('Node disconnected from any', v_boundaryelem)  
		FROM temp_anlgraf a
		JOIN temp_node b ON a.node_2=b.node_id
		GROUP BY a.node_2,the_geom
		having max(water) = 0;

	SELECT count(*) FROM anl_arc INTO v_count WHERE fid = 139 AND cur_user=current_user;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, count)
		VALUES (v_fid, v_result_id, 3, concat('ERROR: There is/are ',v_count,' arc(s) because topological disconnected from any ', v_boundaryelem
		,'. Main reasons may be: state_type, epa_type, sector_id or expl_id or some node not connected'), v_count);
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('HINT: Use toolbox function ''Check network topology for specific result'' for more information'));
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, count)
		VALUES (v_fid, v_result_id, 1, concat('INFO: No arcs topological disconnected found on this result from any ', v_boundaryelem),v_count);
	END IF;

	IF v_project_type = 'WS' THEN

		RAISE NOTICE '5 - Check dry network';	

		TRUNCATE temp_anlgraf;
		v_cont = 0;
									
		-- fill the graf table
		INSERT INTO temp_anlgraf (arc_id, node_1, node_2, water, flag, checkf)
		select  a.arc_id, case when node_1 is null then '00000' else node_1 end, case when node_2 is null then '00000' else node_2 end, 0, 0, 0
		from temp_arc a where result_id = v_result_id
		union all
		select  a.arc_id, case when node_2 is null then '00000' else node_2 end, case when node_1 is null then '00000' else node_1 end, 0, 0, 0
		from temp_arc a where result_id = v_result_id
		ON CONFLICT (arc_id, node_1) DO NOTHING;

		-- set boundary conditions of graf table
		UPDATE temp_anlgraf
			SET flag =1 WHERE arc_id IN (SELECT arc_id FROM temp_arc WHERE status = 'CLOSED');
		UPDATE temp_anlgraf
			SET flag=1, water=1 
			WHERE node_1 IN (SELECT node_id FROM temp_node WHERE (epa_type='RESERVOIR' OR epa_type='INLET' OR epa_type='TANK'));
		UPDATE temp_anlgraf
			SET flag=1, water=1 
			WHERE node_2 IN (SELECT node_id FROM temp_node WHERE (epa_type='RESERVOIR' OR epa_type='INLET' OR epa_type='TANK'));

		-- inundation process
		LOOP
			v_cont = v_cont+1;
			update temp_anlgraf n set water= 1, flag=n.flag+1 from v_anl_graf a where n.node_1 = a.node_1 and n.arc_id = a.arc_id;
			GET DIAGNOSTICS v_affectedrows =row_count;
			EXIT WHEN v_affectedrows = 0;
			EXIT WHEN v_cont = 2000;
			RAISE NOTICE '% - %', v_cont, v_affectedrows;
		END LOOP;

		-- insert into result table disconnected arcs
		INSERT INTO anl_arc (fid, result_id, arc_id, the_geom, descript)
		SELECT DISTINCT ON (a.arc_id) 232, v_result, a.arc_id, the_geom, concat('Arc dry from any', v_boundaryelem)  
			FROM temp_anlgraf a
			JOIN temp_arc b ON a.arc_id=b.arc_id
			GROUP BY a.arc_id,the_geom
			having max(water) = 0;

			
		SELECT count(*) FROM anl_arc INTO v_count WHERE fid = 232 AND cur_user=current_user;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, count)
			VALUES (v_fid, v_result_id, 2, concat('WARNING: There is/are ',v_count,' Dry arc(s) because closed elements'), v_count);
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('HINT: Use toolbox function ''Check network for specific result'' for more information'));
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, count)
			VALUES (v_fid, v_result_id, 1, concat('INFO: No dry arcs found'),v_count);
		END IF;

		-- insert into result table dry nodes with demands (error)
		INSERT INTO anl_node (fid, node_id, the_geom, descript)
		SELECT 233, n.node_id, n.the_geom, concat('Dry nodes with demands') FROM node n
		JOIN
		(SELECT node_1 AS node_id FROM arc JOIN (SELECT arc_id FROM anl_arc WHERE fid = 232 AND cur_user=current_user)a USING (arc_id)
		UNION
		SELECT node_2 FROM arc JOIN (SELECT arc_id FROM anl_arc WHERE fid = 232 AND cur_user=current_user)a USING (arc_id))
		a USING (node_id)
		JOIN temp_node ON a.node_id = temp_node.node_id
		WHERE demand > 0;

		SELECT count(*) FROM anl_node INTO v_count WHERE fid = 233 AND cur_user=current_user;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, count)
			VALUES (v_fid, v_result_id, 3, concat('ERROR: There is/are ',v_count,' Dry nodes with demands'), v_count);
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('HINT: Use toolbox function ''Check network for specific result'' for more information'));
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, count)
			VALUES (v_fid, v_result_id, 1, concat('INFO: No dry nodes with demand found'), v_count);
		END IF;
	END IF;


	RAISE NOTICE '6 - Stats';
	
	IF v_project_type =  'WS' THEN
		SELECT min(elevation), max(elevation) INTO v_min, v_max FROM temp_node;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(length), max(length) INTO v_min, v_max FROM temp_arc WHERE epa_type = 'PIPE';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for pipe length. Minimun and maximum values are: (',v_min,' - ',v_max,' ).'));
		
		SELECT min(diameter), max(diameter) INTO v_min, v_max FROM temp_arc WHERE epa_type = 'PIPE';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for pipe diameter. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(roughness), max(roughness) INTO v_min, v_max FROM temp_arc WHERE epa_type = 'PIPE';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for pipe roughness. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
	ELSIF v_project_type  ='UD' THEN
		
		SELECT min(length), max(length) INTO v_min, v_max FROM temp_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit length. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(n), max(n) INTO v_min, v_max FROM temp_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit manning roughness coeficient. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(elevmax1), max(elevmax1) INTO v_min, v_max FROM temp_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit z1. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(elevmax2), max(elevmax2) INTO v_min, v_max FROM temp_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit z2. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
	
		SELECT min(slope), max(slope) INTO v_min, v_max FROM temp_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit slope. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(elev), max(elev) INTO v_min, v_max FROM temp_node;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));	
	END IF;
	

	-- insert spacers on log	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (139, v_result_id, 1, '');

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom_p'
		) AS feature
		FROM (SELECT id, node_id, node_id, state, expl_id, descript, fid, the_geom
			  FROM  anl_node WHERE cur_user="current_user"() AND (fid = 139 OR fid = 227 OR fid = 233 OR fid = 290)
		) row) features;
  	
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');
	
	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript,fid, the_geom
			  FROM  anl_arc WHERE cur_user="current_user"() AND  (fid = 139 OR fid = 227 OR fid = 232)
			 ) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}'); 
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||
		       '}}'||
	    '}')::json, 2680);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
