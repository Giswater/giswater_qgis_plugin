/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2790

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_grafanalytics_check_data($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"wholeSystem", "grafClass":"ALL"}}}$$)

SELECT SCHEMA_NAME.gw_fct_grafanalytics_check_data($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"userSelectors","grafClass":"SECTOR"}}}$$)

-- fid: 211,176,179,180,181,192,208,209

*/

DECLARE

v_project_type text;
v_count	integer;
v_saveondatabase boolean;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_result_id text;
v_features text;
v_edit text;
v_config_param text;
v_sector boolean;
v_presszone boolean;
v_dma boolean;
v_dqa boolean;
v_minsector boolean;
v_grafclass text;
v_error_context text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_features := ((p_data ->>'data')::json->>'parameters')::json->>'selectionMode'::text;
	v_grafclass := ((p_data ->>'data')::json->>'parameters')::json->>'grafClass'::text;
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- select config values
	v_sector  := (SELECT (value::json->>'SECTOR')::boolean FROM config_param_system WHERE parameter='utils_grafanalytics_status');
	v_dma  := (SELECT (value::json->>'DMA')::boolean FROM config_param_system WHERE parameter='utils_grafanalytics_status');
	v_dqa  := (SELECT (value::json->>'DQA')::boolean FROM config_param_system WHERE parameter='utils_grafanalytics_status');
	v_presszone  := (SELECT (value::json->>'PRESSZONE')::boolean FROM config_param_system WHERE parameter='utils_grafanalytics_status');
	v_minsector  := (SELECT (value::json->>'MINSECTOR')::boolean FROM config_param_system WHERE parameter='utils_grafanalytics_status');

	-- init variables
	v_count=0;

	-- set v_edit_ variable
	IF v_features='wholeSystem' THEN
		v_edit = '';
	ELSIF v_features='userSelectors' THEN
		v_edit = 'v_edit_';
	END IF;
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=211 AND cur_user=current_user;
	
	-- delete old values on anl table
	DELETE FROM anl_node WHERE cur_user=current_user AND fid IN (176,179,180,181,182,208,209);

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, null, 4, concat('DATA QUALITY ANALYSIS ACORDING GRAF ANALYTICS RULES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, null, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, null, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, null, 1, '-------');

	
	-- Check if there are nodes type 'ischange=1 or 2 (true or maybe)' without changing catalog of acs (208)
	v_querytext = '(SELECT n.node_id, count(*), nodecat_id, the_geom FROM 
			(SELECT node_1 as node_id, arccat_id FROM v_edit_arc WHERE node_1 IN (SELECT node_id FROM vu_node JOIN cat_node ON id=nodecat_id WHERE ischange=1)
			  UNION
			 SELECT node_2, arccat_id FROM v_edit_arc WHERE node_2 IN (SELECT node_id FROM vu_node JOIN cat_node ON id=nodecat_id WHERE ischange=1)
			GROUP BY 1,2) a	JOIN node n USING (node_id) GROUP BY 1,3,4 HAVING count(*) <> 2)';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext,' b') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
			SELECT 208, node_id, nodecat_id, ''Node with ischange=1 without any variation of arcs in terms of diameter, pn or material'', the_geom FROM (', v_querytext,') b');
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (211, 2, concat('WARNING: There is/are ',v_count,' nodes with ischange on 1 (true) without any variation of arcs in terms of diameter, pn or material. Please, check your data before continue.'));

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (211, 2, concat('SELECT * FROM anl_node WHERE fprocescat_id = 208 AND cur_user = current_user.'));

	-- is defined as warning because error (3) will break topologic issues of mapzones
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 1, 'INFO: No nodes ''ischange'' without real change have been found.');
	END IF;
			
	-- Check if there are change of catalog with node_type 'ischange=0 (false)' (209)
	v_querytext = '(SELECT node_id, nodecat_id, array_agg(arccat_id) as arccat_id, the_geom FROM ( SELECT count(*), node_id, arccat_id FROM 
			(SELECT node_1 as node_id, arccat_id FROM '||v_edit||'arc UNION ALL SELECT node_2, arccat_id FROM '||v_edit||'arc)a GROUP BY 2,3 HAVING count(*) <> 2 ORDER BY 2) b
			JOIN node USING (node_id) JOIN cat_node ON id=nodecat_id WHERE ischange=0 GROUP By 1,2,4 HAVING count(*)=2)';	

	EXECUTE concat('SELECT count(*) FROM ',v_querytext,' b') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
		SELECT 209, node_id, nodecat_id, concat(''Nodes with catalog changes without nodecat_id ischange:'',arccat_id), the_geom FROM (', v_querytext,') b');

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (211, 2, concat('WARNING: There is/are ',v_count,' nodes where arc catalog changes without nodecat with ischange on 0 or 2 (false or maybe). Please, check your data before continue.'));
			-- is defined as warning because error (3) will break topologic issues of mapzones
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (211, 2, concat('SELECT * FROM anl_node WHERE fprocescat_id = 209 AND cur_user = current_user.'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 1, 'INFO: No nodes without ''ischange'' where arc changes have been found');
	END IF;

	-- valves closed/broken with null values (176)
	v_querytext = '(SELECT n.node_id, n.nodecat_id, n.the_geom FROM '||v_edit||'man_valve JOIN node n USING (node_id) WHERE n.state > 0 AND (broken IS NULL OR closed IS NULL)) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 176, node_id, nodecat_id, ''valves closed/broken with null values'', the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 3, concat('ERROR: There is/are ',v_count,' valve''s (state=1) with broken or closed with NULL values.'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 3, concat('SELECT * FROM anl_node WHERE fid=176 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 1, 'INFO: No valves''s (state=1) with null values on closed and broken fields.');
	END IF;

	-- inlet_x_exploitation
	SELECT count(*) INTO v_count FROM config_mincut_inlet WHERE expl_id NOT IN (SELECT expl_id FROM exploitation);
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 3, concat('ERROR: There is/are at least ',v_count,' 
		exploitation(s) bad configured on the config_mincut_inlet table. Please check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 1, 'INFO: It seems config_mincut_inlet table is well configured. At least, table is filled with nodes from all exploitations.');
	END IF;
			
	-- nodetype.grafdelimiter values
	SELECT count(*) INTO v_count FROM node_type where graf_delimiter IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 2, concat('WARNING: There is/are ',v_count,' rows on the node_type table with null values on graf_delimiter. Please check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (211, 1, 'INFO: The graf_delimiter column on node_type table has values for all rows.');
	END IF;

	-- grafanalytics sector
	IF v_sector IS TRUE AND (v_grafclass = 'SECTOR' OR v_grafclass = 'ALL') THEN

		-- check sector.grafconfig values
		v_querytext = 	'SELECT * FROM sector WHERE grafconfig IS NULL and sector_id > 0' ;
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (211, 3, concat('ERROR: There is/are ',v_count, ' sectors on sector table with grafconfig not configured.'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (211, 1, 'INFO: All mapzones has grafconfig values not null.');
		END IF;	

		-- check coherence againts nodetype.grafdelimiter and nodeparent defined on sector.grafconfig (fid:  179)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM sector WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''SECTOR'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM sector) AND '||v_edit||'node.state > 0';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 179, node_id, nodecat_id,
			''The node_type.grafdelimiter of this node is SECTOR but it is not configured on sector.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''SECTOR'' not configured on the sector table.'));
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 2, concat('SELECT * FROM anl_node WHERE fid=179 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 1, 'INFO: All nodes with node_type.grafdelimiter=''SECTOR'' are defined as nodeParent on sector.grafconfig');
		END IF;

	END IF;

	-- grafanalytics dma
	IF v_dma IS TRUE AND (v_grafclass = 'DMA' OR v_grafclass = 'ALL') THEN

		-- check dma.grafconfig values
		v_querytext = 	'SELECT * FROM dma WHERE grafconfig IS NULL and dma_id > 0' ;
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (211, 3, concat('ERROR: There is/are ',v_count, ' dma on dma table with grafconfig not configured.'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (211, 1, 'INFO: All mapzones has grafconfig values not null.');
		END IF;	
		
		-- dma : check coherence againts nodetype.grafdelimiter and nodeparent defined on dma.grafconfig (fid:  180)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM dma WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''DMA'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM dma) AND '||v_edit||'node.state > 0';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 180, node_id, nodecat_id, ''Node_type is DMA but node is not configured on dma.grafconfig'', the_geom FROM ('
				, v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''DMA'' not configured on the dma table.'));
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 2, concat('SELECT * FROM anl_node WHERE fid=180 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 1, 'INFO: All nodes with node_type.grafdelimiter=''DMA'' are defined as nodeParent on dma.grafconfig');
		END IF;
		
		-- dma, toArc (fid:  84)
	END IF;

	-- grafanalytics dqa
	IF v_dqa IS TRUE AND (v_grafclass = 'DQA' OR v_grafclass = 'ALL') THEN

		-- check dqa.grafconfig values
		v_querytext = 	'SELECT * FROM dqa WHERE grafconfig IS NULL and dqa_id > 0' ;
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (211, 3, concat('ERROR: There is/are ',v_count, ' dqa on dqa table with grafconfig not configured.'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (211, 1, 'INFO: All mapzones has grafconfig values not null.');
		END IF;	

		-- dqa : check coherence againts nodetype.grafdelimiter and nodeparent defined on dqa.grafconfig (fid:  181)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM dqa WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''DQA'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM dqa)';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 181, node_id, nodecat_id, ''Node_type is DQA but node is not configured on dqa.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''DQA'' not configured on the dqa table.'));
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 2, concat('SELECT * FROM anl_node WHERE fid=181 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 1, 'INFO: All nodes with node_type.grafdelimiter=''DQA'' are defined as nodeParent on dqa.grafconfig');
		END IF;

		-- dqa, toArc (fid:  85)
	END IF;

	-- grafanalytics dqa
	IF v_presszone IS TRUE AND (v_grafclass = 'PRESSZONE' OR v_grafclass = 'ALL') THEN

		-- check presszone.grafconfig values
		v_querytext = 	'SELECT * FROM presszone WHERE grafconfig IS NULL and id > 0::text' ;
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (211, 4, concat('ERROR: There is/are ',v_count, ' presszone on presszone table with grafconfig not configured.'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (211, 1, 'INFO: All mapzones has grafconfig values not null.');
		END IF;	

		-- presszone : check coherence againts nodetype.grafdelimiter and nodeparent defined on presszone.grafconfig (fid:  182)
		v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM presszone WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''PRESSZONE'' AND a.node_id IS NULL
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM presszone)';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 182, node_id, nodecat_id, ''Node_type is PRESSZONE but node is not configured on presszone.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''PRESSZONE'' not configured on the presszone table.'));
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 2, concat('SELECT * FROM anl_node WHERE fid=182 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (211, 1, 'INFO: All nodes with node_type.grafdelimiter=''PRESSZONE'' are defined as nodeParent on presszone.grafconfig');
		END IF;

	END IF;

	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (211, v_result_id, 1, '');
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND 
	fid=211 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, node_id as feature_id, nodecat_id as feature_catalog, state, expl_id, descript,fid, the_geom
  	FROM  anl_node WHERE cur_user="current_user"() AND fid IN (176,179,180,181,182,208,209)) row) features;

	v_result := COALESCE(v_result, '{}'); 


	IF v_result = '{}' THEN 
		v_result_point = '{"geometryType":"", "values":[]}';
	ELSE 
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');
	END IF;
	
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 
	
	-- Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
		     	'"setVisibleLayers":[]'||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
