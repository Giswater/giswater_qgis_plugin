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

-- fid: main:211,
	other: 176,179,180,181,192,208,209

select * FROM audit_check_data WHERE fid=211 AND cur_user=current_user; 

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
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (211, 2, '208', concat('WARNING-208: There is/are ',v_count,' nodes with ischange on 1 (true) without any variation of arcs in terms of diameter, pn or material. Please, check your data before continue.'),v_count);

	-- is defined as warning because error (3) will break topologic issues of mapzones
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (211, 1, '208','INFO: No nodes ''ischange'' without real change have been found.',v_count);
	END IF;
			
	-- Check if there are change of catalog with cat_feature_node 'ischange=0 (false)' (209)
	v_querytext = '(SELECT node_id, nodecat_id, array_agg(arccat_id) as arccat_id, the_geom FROM ( SELECT count(*), node_id, arccat_id FROM 
			(SELECT node_1 as node_id, arccat_id FROM '||v_edit||'arc UNION ALL SELECT node_2, arccat_id FROM '||v_edit||'arc)a GROUP BY 2,3 HAVING count(*) <> 2 ORDER BY 2) b
			JOIN node USING (node_id) JOIN cat_node ON id=nodecat_id WHERE ischange=0 GROUP By 1,2,4 HAVING count(*)=2)';	

	EXECUTE concat('SELECT count(*) FROM ',v_querytext,' b') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
		SELECT 209, node_id, nodecat_id, concat(''Nodes with catalog changes without nodecat_id ischange:'',arccat_id), the_geom FROM (', v_querytext,') b');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (211, 2, '209', concat('WARNING-209: There is/are ',v_count,' nodes where arc catalog changes without nodecat with ischange on 0 or 2 (false or maybe). Please, check your data before continue.'),v_count);
			-- is defined as warning because error (3) will break topologic issues of mapzones
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (211, 1, '209','INFO: No nodes without ''ischange'' where arc changes have been found',v_count);
	END IF;

	-- valves closed/broken with null values (176)
	v_querytext = '(SELECT n.node_id, n.nodecat_id, n.the_geom FROM man_valve JOIN '||v_edit||'node n USING (node_id) WHERE n.state > 0 AND (broken IS NULL OR closed IS NULL)) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 176, node_id, nodecat_id, ''valves closed/broken with null values'', the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fid, criticity, result_id,  error_message, fcount)
		VALUES (211, 3, '176', concat('ERROR-176: There is/are ',v_count,' valve''s (state=1) with broken or closed with NULL values.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (211, 1, '176', 'INFO: No valves''s (state=1) with null values on closed and broken fields.',v_count);
	END IF;

	-- inlet_x_exploitation (177)
	SELECT count(*) INTO v_count FROM config_mincut_inlet WHERE expl_id NOT IN (SELECT expl_id FROM exploitation);
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (211, 3, '177', concat('ERROR-177: There is/are at least ',v_count,' 
		exploitation(s) bad configured on the config_mincut_inlet table. Please check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (211, 1, '177', 'INFO: It seems config_mincut_inlet table is well configured. At least, table is filled with nodes from all exploitations.',v_count);
	END IF;
			
	-- nodetype.graf_delimiter values (267)
	SELECT count(*) INTO v_count FROM cat_feature_node where graf_delimiter IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (211, 2, '267',concat('WARNING-267: There is/are ',v_count,' rows on the cat_feature_node table with null values on graf_delimiter. Please check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (211, 1, '267','INFO: The graf_delimiter column on cat_feature_node table has values for all rows.',v_count);
	END IF;

	-- grafanalytics sector (268)
	IF v_sector IS TRUE AND (v_grafclass = 'SECTOR' OR v_grafclass = 'ALL') THEN

		-- check sector.grafconfig values
		v_querytext = 	'SELECT * FROM sector WHERE grafconfig IS NULL and sector_id > 0' ;
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount) 
			VALUES (211, 3, '268', concat('ERRO-268: There is/are ',v_count, ' sectors on sector table with grafconfig not configured.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount) 
			VALUES (211, 1, '268', 'INFO: All mapzones has grafconfig values not null.',v_count);
		END IF;	

		-- check coherence againts nodetype.grafdelimiter and nodeparent defined on sector.grafconfig (fid:  179)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM sector WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''SECTOR'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM sector) AND '||v_edit||'node.state > 0';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 179, node_id, nodecat_id,
			''The cat_feature_node.grafdelimiter of this node is SECTOR but it is not configured on sector.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (211, 2, '179', concat('WARNING-179: There is/are ',v_count,
			' node(s) with cat_feature_node.graf_delimiter=''SECTOR'' not configured on the sector table.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (211, 1, '179', 'INFO: All nodes with cat_feature_node.grafdelimiter=''SECTOR'' are defined as nodeParent on sector.grafconfig',v_count);
		END IF;

	END IF;

	-- grafanalytics dma(269)
	IF v_dma IS TRUE AND (v_grafclass = 'DMA' OR v_grafclass = 'ALL') THEN

		-- check dma.grafconfig values
		v_querytext = 	'SELECT * FROM dma WHERE grafconfig IS NULL and dma_id > 0' ;
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount) 
			VALUES (211, 3, '269', concat('ERROR-269: There is/are ',v_count, ' dma on dma table with grafconfig not configured.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount) 
			VALUES (211, 1, '269','INFO: All mapzones has grafconfig values not null.',v_count);
		END IF;	
		
		-- dma : check coherence againts nodetype.grafdelimiter and nodeparent defined on dma.grafconfig (fid:  180)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM dma WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''DMA'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM dma) AND '||v_edit||'node.state > 0';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 180, node_id, nodecat_id, ''cat_feature_node is DMA but node is not configured on dma.grafconfig'', the_geom FROM ('
				, v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (211, 2, '180', concat('WARNING-180: There is/are ',v_count,
			' node(s) with cat_feature_node.graf_delimiter=''DMA'' not configured on the dma table.'),v_count);
			
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (211, 1, '180','INFO: All nodes with cat_feature_node.grafdelimiter=''DMA'' are defined as nodeParent on dma.grafconfig',v_count);
		END IF;
		
		-- dma, toArc (fid:  84)
	END IF;

	-- grafanalytics dqa (270)
	IF v_dqa IS TRUE AND (v_grafclass = 'DQA' OR v_grafclass = 'ALL') THEN

		-- check dqa.grafconfig values
		v_querytext = 	'SELECT * FROM dqa WHERE grafconfig IS NULL and dqa_id > 0' ;
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount) 
			VALUES (211, 3, '270', concat('ERROR-270: There is/are ',v_count, ' dqa on dqa table with grafconfig not configured.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount) 
			VALUES (211, 1, '270','INFO: All mapzones has grafconfig values not null.',v_count);
		END IF;	

		-- dqa : check coherence againts nodetype.grafdelimiter and nodeparent defined on dqa.grafconfig (fid:  181)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM dqa WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''DQA'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM dqa)';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 181, node_id, nodecat_id, ''cat_feature_node is DQA but node is not configured on dqa.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (211, 2, '181',concat('WARNING-181: There is/are ',v_count,
			' node(s) with cat_feature_node.graf_delimiter=''DQA'' not configured on the dqa table.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (211, 1, '181', 'INFO: All nodes with cat_feature_node.grafdelimiter=''DQA'' are defined as nodeParent on dqa.grafconfig',v_count);
		END IF;

		-- dqa, toArc (fid:  85)
	END IF;

	-- grafanalytics presszone (271)
	IF v_presszone IS TRUE AND (v_grafclass = 'PRESSZONE' OR v_grafclass = 'ALL') THEN

		-- check presszone.grafconfig values
		v_querytext = 	'SELECT * FROM presszone WHERE grafconfig IS NULL and presszone_id > 0::text' ;
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount) 
			VALUES (211, 4, '271', concat('ERROR-271: There is/are ',v_count, ' presszone on presszone table with grafconfig not configured.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount) 
			VALUES (211, 1, '271','INFO: All mapzones has grafconfig values not null.',v_count);
		END IF;	

		-- presszone : check coherence againts nodetype.grafdelimiter and nodeparent defined on presszone.grafconfig (fid:  182)
		v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM presszone WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''PRESSZONE'' AND a.node_id IS NULL
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM presszone)';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 182, node_id, nodecat_id, ''cat_feature_node is PRESSZONE but node is not configured on presszone.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (211, 2, '182',concat('WARNING-182: There is/are ',v_count,
			' node(s) with cat_feature_node.graf_delimiter=''PRESSZONE'' not configured on the presszone table.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (211, 1, '182','INFO: All nodes with cat_feature_node.grafdelimiter=''PRESSZONE'' are defined as nodeParent on presszone.grafconfig',v_count);
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
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2790);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
