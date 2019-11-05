/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2670

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_om_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_om_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_om_check_data($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}$$)

SELECT gw_fct_om_check_data($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"wholeSystem"}}}$$)

*/


DECLARE
v_data 			json;
valve_rec		record;
v_countglobal		integer;
v_record		record;
setvalue_int		int8;
v_project_type 		text;
v_count			integer;
v_count_2		integer;
infiltration_aux	text;
rgage_rec		record;
scenario_aux		text;
v_min_node2arc		float;
v_arc			text;
v_saveondatabase 	boolean;
v_result 		text;
v_version		text;
v_result_info 		json;
v_result_point		json;
v_result_line 		json;
v_result_polygon	json;
v_querytext		text;
v_nodearc_real 		float;
v_nodearc_user 		float;
v_result_id 		text;
v_min 			numeric (12,4);
v_max			numeric (12,4);
v_headloss		text;
v_message		text;
v_demandtype 		integer;
v_patternmethod		integer;
v_period		text;
v_networkmode		integer;
v_valvemode		integer;
v_demandtypeval 	text;
v_patternmethodval 	text;
v_periodval 		text;
v_valvemodeval 		text;
v_networkmodeval	text;
v_dwfscenario		text;
v_allowponding		text;
v_florouting		text;
v_flowunits		text;
v_hydrologyscenario	text;
v_qualitymode		text;
v_qualmodeval		text;
v_features 		text;
v_edit			text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_features := ((p_data ->>'data')::json->>'parameters')::json->>'selectionMode'::text;
	
	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	-- init variables
	v_count=0;
	v_countglobal=0;	

	-- set v_edit_ variable
	IF v_features='wholeSystem' THEN
		v_edit = '';
	ELSIF v_features='userSelectors' THEN
		v_edit = 'v_edit_';
	END IF;
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=25 AND user_name=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 4, concat('DATA QUALITY ANALYSIS ACORDING O&M RULES'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 4, '-----------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 1, '-------');	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 0, 'NETWORK ANALYSIS');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 0, '-------------------------');	

		
	-- UTILS
	-- Check node_1 or node_2 nulls (fprocesscat = 4)
	v_querytext = '(SELECT arc_id,arccat_id,the_geom FROM '||v_edit||'arc WHERE state > 0 AND node_1 IS NULL UNION SELECT arc_id,arccat_id,the_geom FROM '
	||v_edit||'arc WHERE state > 0 AND node_2 IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		DELETE FROM anl_arc WHERE fprocesscat_id=4 and cur_user=current_user;
		EXECUTE concat ('INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, descript, the_geom) SELECT 4, arc_id, arccat_id, ''node_1 or node_2 nulls'', the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' arc''s without node_1 or node_2.'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 3, concat('HINT: SELECT * FROM anl_arc WHERE fprocesscat_id=4 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No arc''s without node_1 or node_2 nodes found.');
	END IF;

	-- Check state_type nulls (arc, node)
	v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE state > 0 AND state_type IS NULL 
		        UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE state > 0 AND state_type IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' topologic features (arc, node) with state_type with NULL values. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No topologic features (arc, node) with state_type NULL values found.');
	END IF;


	-- Check nodes with state_type isoperative = false (fprocesscat = 87)
	v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node n JOIN value_state_type ON id=state_type WHERE n.state > 0 AND is_operative IS FALSE';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		DELETE FROM anl_node WHERE fprocesscat_id=87 and cur_user=current_user;
		EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 87, node_id, nodecat_id, ''nodes with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' node(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=87 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No nodes with state > 0 AND state_type.is_operative on FALSE found.');
	END IF;


	-- Check arcs with state_type isoperative = false (fprocesscat = 88)
	v_querytext = 'SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc a JOIN value_state_type ON id=state_type WHERE a.state > 0 AND is_operative IS FALSE';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		DELETE FROM anl_arc WHERE fprocesscat_id=88 and cur_user=current_user;
		EXECUTE concat ('INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, descript, the_geom) SELECT 88, arc_id, arccat_id, ''arcs with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' arc(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('HINT: SELECT * FROM anl_arc WHERE fprocesscat_id=88 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No arcs with state > 0 AND state_type.is_operative on FALSE found.');
	END IF;

	-- Check state not according with state_type

	
	-- only UD projects
	IF 	v_project_type='UD' THEN

		
	
	ELSIF v_project_type='WS' THEN

		-- valves closed/broken with null values (fprocesscat = 76)
		v_querytext = '(SELECT n.node_id, n.nodecat_id, n.the_geom FROM '||v_edit||'man_valve JOIN node n USING (node_id) WHERE n.state > 0 AND (broken IS NULL OR closed IS NULL)) a';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			DELETE FROM anl_node WHERE fprocesscat_id=76 and cur_user=current_user;
			EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 76, node_id, nodecat_id, ''valves closed/broken with null values'', the_geom FROM ', v_querytext);
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' valve''s (state=1) with broken or closed with NULL values.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 3, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=76 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: No valves''s (state=1) with null values on closed and broken fields.');
		END IF;

		-- inlet_x_exploitation
		SELECT count(*) INTO v_count FROM anl_mincut_inlet_x_exploitation WHERE expl_id NOT IN (SELECT expl_id FROM exploitation);
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 3, concat('ERROR: There is/are at least ',v_count,' 
			exploitation(s) bad configured on the anl_mincut_inlet_x_exploitation table. Please check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: It seems anl_mincut_inlet_x_exploitation table is well configured. At least, table is filled with nodes from all exploitations.');
		END IF;
	
		-- nodetype.grafdelimiter configuration
		SELECT count(*) INTO v_count FROM node_type where graf_delimiter IS NULL;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('ERROR: There is/are ',v_count,' rows on the node_type table with null values on graf_delimiter. Please check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: The graf_delimiter column on node_type table has values for all rows.');
		END IF;

		-- Sector : check coherence againts nodetype.grafdelimiter and nodeparent defined on sector.grafconfig (fprocesscat = 79)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM sector WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''SECTOR'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM sector)';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			DELETE FROM anl_node WHERE fprocesscat_id=79 and cur_user=current_user;
			EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 79, node_id, nodecat_id, ''The node_type is defined as SECTOR but this node is not configured on the sector.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''SECTOR'' not configured on the sector table.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=79 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: All nodes with node_type.grafdelimiter=''SECTOR'' are defined as nodeParent on sector.grafconfig');
		END IF;
		
		-- dma : check coherence againts nodetype.grafdelimiter and nodeparent defined on dma.grafconfig (fprocesscat = 80)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM dma WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''DMA'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM dma)';


		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			DELETE FROM anl_node WHERE fprocesscat_id=80 and cur_user=current_user;
			EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 80, node_id, nodecat_id, ''The node_type is defined as DMA but this node is not configured on the dma.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''DMA'' not configured on the dma table.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=80 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: All nodes with node_type.grafdelimiter=''DMA'' are defined as nodeParent on dma.grafconfig');
		END IF;

		-- dqa : check coherence againts nodetype.grafdelimiter and nodeparent defined on dqa.grafconfig (fprocesscat = 81)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM dqa WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''DQA'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM dqa)';


		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			DELETE FROM anl_node WHERE fprocesscat_id=81 and cur_user=current_user;
			EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 81, node_id, nodecat_id, ''The node_type is defined as DQA but this node is not configured on the dqa.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''DQA'' not configured on the dqa table.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=81 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: All nodes with node_type.grafdelimiter=''DQA'' are defined as nodeParent on dqa.grafconfig');
		END IF;

		-- presszone : check coherence againts nodetype.grafdelimiter and nodeparent defined on cat_presszone.grafconfig (fprocesscat = 82)
		v_querytext = 	'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM cat_presszone WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''PRESSZONE'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM cat_presszone)';


		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			DELETE FROM anl_node WHERE fprocesscat_id=82 and cur_user=current_user;
			EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 82, node_id, nodecat_id, ''The node_type is defined as PRESSZONE but this node is not configured on the cat_presszone.grafconfig'' the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''PRESSZONE'' not configured on the cat_presszone table.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=82 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: All nodes with node_type.grafdelimiter=''PRESSZONE'' are defined as nodeParent on cat_presszone.grafconfig');
		END IF;
		

		-- sector, toArc (fprocesscat = 83)

		-- dma, toArc (fprocesscat = 84)

		-- dqa, toArc (fprocesscat = 85)

		-- presszone, toArc (fprocesscat = 86)
		
	END IF;

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, v_result_id, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, v_result_id, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, v_result_id, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, v_result_id, 1, '');
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=25 order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() 
	AND (fprocesscat_id=4 OR fprocesscat_id=87 OR fprocesscat_id=76 OR fprocesscat_id=79 OR fprocesscat_id=80 OR fprocesscat_id=81 OR fprocesscat_id=82)) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');

	--lines
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=88) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "values":',v_result, '}');

	--polygons

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=25;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=25 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (25, current_user);
	END IF;
		
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 
	
--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
