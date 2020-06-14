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
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}$$)

SELECT gw_fct_om_check_data($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"wholeSystem"}}}$$)

--fid: 104,187,188,196,197,201,202,203,204,205,206,

*/

DECLARE

v_project_type text;
v_count integer;
v_saveondatabase boolean;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext	text;
v_result_id text;
v_features text;
v_edit text;
v_config_param text;
v_error_context text;
v_feature_id text;
v_arc_array text[];
rec_arc text;
v_node_1 text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_features := ((p_data ->>'data')::json->>'parameters')::json->>'selectionMode'::text;
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- init variables
	v_count=0;


	-- set v_edit_ variable
	IF v_features='wholeSystem' THEN
		v_edit = '';
	ELSIF v_features='userSelectors' THEN
		v_edit = 'v_edit_';
	END IF;
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 25 AND cur_user=current_user;
	
	-- delete old values on anl table
	DELETE FROM anl_connec WHERE cur_user=current_user AND fid IN (201,202,204,205,206);
	DELETE FROM anl_arc WHERE cur_user=current_user AND fid IN (104,188,202);
	DELETE FROM anl_node WHERE cur_user=current_user AND fid IN (104,187,196,197,202,203);

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, null, 4, concat('DATA QUALITY ANALYSIS ACORDING O&M RULES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, null, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, null, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, null, 1, '-------');

		
	-- UTILS

	-- system variables
	v_querytext = 'SELECT parameter FROM config_param_system WHERE lower(value) != lower(standardvalue) AND standardvalue IS NOT NULL';
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	EXECUTE concat('SELECT (array_agg(parameter))::text FROM (',v_querytext,')a') INTO v_result;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' system variables with out-of-standard values ',v_result,'.'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No system variables with values out-of-standars found.');
	END IF;

	
	
	-- Check node_1 or node_2 nulls (fid:  104)
	v_querytext = '(SELECT arc_id,arccat_id,the_geom FROM '||v_edit||'arc WHERE state > 0 AND node_1 IS NULL UNION SELECT arc_id, arccat_id, the_geom FROM '
	||v_edit||'arc WHERE state > 0 AND node_2 IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
			SELECT 104, arc_id, arccat_id, ''node_1 or node_2 nulls'', the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' arc''s without node_1 or node_2.'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 3, concat('SELECT * FROM anl_arc WHERE fid = 104 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No arc''s without node_1 or node_2 nodes found.');
	END IF;

	-- Chec state 1 arcs with state 0 nodes (196)
	v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_1=node_id WHERE a.state =1 AND n.state=0 UNION
			SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_2=node_id WHERE a.state =1 AND n.state=0) a';
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
		SELECT 196, arc_id, arccat_id, ''Arc with state=1 using nodes with state = 0'', the_geom FROM ', v_querytext);

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' arcs with state=1 using extremals nodes with state = 0. Please, check your data before continue'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 3, concat('SELECT * FROM anl_arc WHERE fid = 196 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No arcs with state=1 using nodes with state=0 found.');
	END IF;

	-- check conduits (UD) with negative slope and inverted slope is not checked
	IF v_project_type  ='UD' THEN
		v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a WHERE sys_slope < 0 AND inverted_slope IS FALSE) a';
		
		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' arcs with inverted slope false and slope negative values. Please, check your data before continue'));
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 3, concat('SELECT * FROM arc WHERE state > 0 AND sys_slope < 0 AND inverted_slope IS FALSE'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: No arcs with state=1 using nodes with state=0 found.');
		END IF;	
	END IF;

	-- Chec state 1 arcs with state 2 nodes (197)
	v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_1=node_id WHERE a.state =1 AND n.state=2 UNION
			SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_2=node_id WHERE a.state =1 AND n.state=2) a';
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
		SELECT 197, arc_id, arccat_id, ''Arcs with state=1 using nodes with state = 2'', the_geom FROM ', v_querytext);

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' arcs with state=1 using extremals nodes with state = 2. Please, check your data before continue'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 3, concat('SELECT * FROM anl_arc WHERE fid = 197 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No arcs with state=1 using nodes with state=0 found.');
	END IF;	

	-- Check all state=2 are involved in at least in one psector
	v_querytext = 'SELECT a.arc_id FROM '||v_edit||'arc a RIGHT JOIN plan_psector_x_arc USING (arc_id) WHERE a.state = 2 AND a.arc_id IS NULL
			UNION
			SELECT a.node_id FROM '||v_edit||'node a RIGHT JOIN plan_psector_x_node USING (node_id) WHERE a.state = 2 AND a.node_id IS NULL
			UNION
			SELECT a.connec_id FROM '||v_edit||'connec a RIGHT JOIN plan_psector_x_connec USING (connec_id) WHERE a.state = 2 AND a.connec_id IS NULL';

	IF v_project_type = 'UD' THEN
		v_querytext = concat (v_querytext, ' UNION SELECT a.gully_id FROM '||v_edit||'gully a RIGHT JOIN plan_psector_x_gully USING (gully_id) WHERE a.state = 2 AND a.gully_id IS NULL');
	END IF;
		
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' features with state=2 without psector assigned. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No features with state=2 without psector assigned.');
	END IF;


	-- Check state_type nulls (arc, node)
	v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE state > 0 AND state_type IS NULL 
		        UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE state > 0 AND state_type IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' topologic features (arc, node) with state_type with NULL values. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No topologic features (arc, node) with state_type NULL values found.');
	END IF;


	-- Check nodes with state_type isoperative = false (fid:  187)
	v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node n JOIN value_state_type ON id=state_type WHERE n.state > 0 AND is_operative IS FALSE';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
		SELECT 187, node_id, nodecat_id, ''Nodes with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' node(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('SELECT * FROM anl_node WHERE fid = 187 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No nodes with state > 0 AND state_type.is_operative on FALSE found.');
	END IF;


	-- Check arcs with state_type isoperative = false (fid:  188)
	v_querytext = 'SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc a JOIN value_state_type ON id=state_type WHERE a.state > 0 AND is_operative IS FALSE';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
			SELECT 188, arc_id, arccat_id, ''arcs with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' arc(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('SELECT * FROM anl_arc WHERE fid = 188 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No arcs with state > 0 AND state_type.is_operative on FALSE found.');
	END IF;

	--check if all tanks are defined in config_mincut_inlet  (fid:  77)
	IF v_project_type = 'WS' THEN
		v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node 
		JOIN cat_node ON nodecat_id=cat_node.id
		JOIN cat_feature ON cat_node.nodetype_id = cat_feature.id
		JOIN value_state_type ON state_type = value_state_type.id
		WHERE value_state_type.is_operative IS TRUE AND system_id = ''TANK'' and node_id NOT IN (SELECT node_id FROM config_mincut_inlet)';
		
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,') a ') INTO v_count;
		EXECUTE concat('SELECT string_agg(a.node_id::text,'','') FROM (',v_querytext,') a ') INTO v_feature_id;

		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
			SELECT 77, node_id, nodecat_id, ''Tanks not defined in config_mincut_inlet'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' tanks which are not defined on config_mincut_inlet. Node_id: ',v_feature_id,'. Please, check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: All tanks are defined in config_mincut_inlet.');
		END IF;
	END IF;

	--check if drawn arc direction is the same as defined node_1, node_2
	v_querytext = 'SELECT array_agg(arc_id)  FROM '||v_edit||'arc';

	EXECUTE v_querytext INTO v_arc_array;

	FOREACH rec_arc IN ARRAY(v_arc_array)
	LOOP
		
		EXECUTE 'SELECT node_1 FROM '||v_edit||'arc WHERE arc_id = '||quote_literal(rec_arc)||';'
		INTO v_node_1;

		EXECUTE 'SELECT node_id FROM '||v_edit||'arc, '||v_edit||'node
		WHERE st_dwithin(St_StartPoint('||v_edit||'arc.the_geom), '||v_edit||'node.the_geom, 0.1) 
		AND '||v_edit||'arc.arc_id = '||quote_literal(rec_arc)||' AND '||v_edit||'node.state = 1;'
		INTO v_feature_id;

		IF v_node_1 != v_feature_id THEN
			EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
			SELECT 123, arc_id, arccat_id, ''Drawing direction different than definition of node_1, node_2'', the_geom 
			FROM '||v_edit||'arc WHERE arc_id = '||quote_literal(rec_arc)||';');

			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 2, concat('WARNING: Drawing direction of arc ',rec_arc,' is different than definition of node_1, node_2. Please, check your data before continue.'));
		END IF;
	END LOOP;


	-- Check nulls customer code for connecs (110)
	v_querytext = 'SELECT customer_code FROM '||v_edit||'connec WHERE state=1 and customer_code IS NULL';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,') a ') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 110, connec_id, connecat_id, ''Connecs with null customer code'', the_geom FROM connec WHERE customer_code IN (', v_querytext,')');
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' connec with customer code null. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No connecs with null customer code.');
	END IF;


	-- Check unique customer code for connecs with state=1 
	v_querytext = 'SELECT customer_code FROM '||v_edit||'connec WHERE state=1 and customer_code IS NOT NULL group by customer_code having count(*) > 1';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,') a ') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 201, connec_id, connecat_id, ''Connecs with customer code duplicated'', the_geom FROM connec WHERE customer_code IN (', v_querytext,')');
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' connec customer code duplicated. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No connecs with customer code duplicated.');
	END IF;

	--Check if all id are integers
	IF v_project_type = 'WS' THEN
		v_querytext = '(SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)
						ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id as featurecat, the_geom FROM '||v_edit||'arc
						UNION SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER)
   						ELSE 0 END as feature_id, ''NODE'' as type, nodecat_id as featurecat, the_geom FROM '||v_edit||'node
						UNION SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER)
   						ELSE 0 END as feature_id, ''CONNEC'' as type, connecat_id as featurecat, the_geom FROM '||v_edit||'connec) a';

   		EXECUTE concat('SELECT count(*) FROM ',v_querytext,' WHERE feature_id=0') INTO v_count;
   	ELSIF v_project_type = 'UD' THEN
   		v_querytext = ('(SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)
						ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id as featurecat,the_geom  FROM '||v_edit||'arc
						UNION SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER)
   						ELSE 0 END as feature_id, ''NODE'' as type, nodecat_id as featurecat,the_geom FROM '||v_edit||'node
						UNION SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER)
   						ELSE 0 END as feature_id, ''CONNEC'' as type, connecat_id as featurecat,the_geom FROM '||v_edit||'connec
   						UNION SELECT CASE WHEN gully_id~E''^\\d+$'' THEN CAST (gully_id AS INTEGER)
   						ELSE 0 END as feature_id, ''GULLY'' as type, gratecat_id as featurecat,the_geom FROM '||v_edit||'gully) a');
   	END IF;

   	EXECUTE concat('SELECT count(*) FROM ',v_querytext,' WHERE feature_id=0') INTO v_count;

   	IF v_count > 0 THEN

		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 202, feature_id, featurecat, ''Connecs with id which is not an integer'', the_geom FROM ', v_querytext,' 
		WHERE  feature_id=0 AND type = ''CONNEC'' ');

		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
		SELECT 202,  feature_id, featurecat, ''Arcs with id which is not an integer'', the_geom FROM ', v_querytext,' 
		WHERE  feature_id=0 AND type = ''ARC'' ');

		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
		SELECT 202,  feature_id, featurecat, ''Nodes with id which is not an integer'', the_geom FROM ', v_querytext,' 
		WHERE  feature_id=0 AND type = ''NODE'' ');
			
		IF v_project_type = 'UD' THEN
			EXECUTE concat ('INSERT INTO anl_connec (fid, node_id, nodecat_id, descript, the_geom)
			SELECT 202, feature_id, featurecat, ''Gullies with id which is not an integer'', the_geom FROM ', v_querytext,' 
			WHERE feature_id=0 AND type = ''GULLY'' ');
		END IF;

		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' which id is not an integer. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: All features with id integer.');
	END IF;

	-- Check state not according with state_type	
	IF v_project_type = 'UD' THEN
		v_querytext =  'SELECT a.state, state_type FROM '||v_edit||'arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
				UNION SELECT a.state, state_type FROM '||v_edit||'element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' features(s) with state without concordance with state_type. Please, check your data before continue'));
			
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: No features without concordance againts state and state_type.');
		END IF;
		
	ELSIF v_project_type = 'WS' THEN
	
		v_querytext =  'SELECT a.state, state_type FROM '||v_edit||'arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
				UNION SELECT a.state, state_type FROM '||v_edit||'element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' features(s) with state without concordance with state_type. Please, check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: No features without concordance againts state and state_type.');
		END IF;
	END IF;
	
	-- Check code with null values
	IF v_project_type ='UD' THEN
		v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE code IS NULL 
					UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE code IS NULL
					UNION SELECT connec_id, connecat_id, the_geom FROM '||v_edit||'connec WHERE code IS NULL
					UNION SELECT gully_id, gratecat_id, the_geom FROM '||v_edit||'gully WHERE code IS NULL
					UNION SELECT element_id, elementcat_id, the_geom FROM '||v_edit||'element WHERE code IS NULL) a';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' with code with NULL values. Please, check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: No features (arc, node, connec, gully, element) with NULL values on code found.');
		END IF;

	ELSIF v_project_type ='WS' THEN

		v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE code IS NULL 
				UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE code IS NULL
				UNION SELECT connec_id, connecat_id, the_geom FROM '||v_edit||'connec WHERE code IS NULL
				UNION SELECT element_id, elementcat_id, the_geom FROM '||v_edit||'element WHERE code IS NULL) a';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' with code with NULL values. Please, check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: No features (arc, node, connec, element) with NULL values on code found.');
		END IF;
	END IF;
			
	-- Check for orphan polygons on polygon table
	IF v_project_type ='UD' THEN

		v_querytext = '(SELECT pol_id FROM polygon EXCEPT SELECT pol_id FROM (select pol_id from gully UNION select pol_id from man_chamber 
					   UNION select pol_id from man_netgully UNION select pol_id from man_storage UNION select pol_id from man_wwtp) a) b';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' polygons without parent (gully, netgully, chamber, storage or wwtp).  We recommend you to clean data before continue.'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: No polygons without parent feature (gully, netgully, chamber, storage or wwtp) found.');
		END IF;
	ELSIF v_project_type ='WS' THEN

	END IF;

	-- Check for orphan rows on man_addfields values table
	IF v_project_type ='UD' THEN

		v_querytext = 'SELECT * FROM man_addfields_value WHERE feature_id NOT IN (SELECT arc_id FROM arc UNION SELECT node_id FROM node UNION SELECT connec_id FROM connec UNION SELECT gully_id FROM gully)';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' rows on man_addfields_value without parent feature. We recommend you to clean data before continue.'));
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 2, concat('SELECT * FROM man_addfields_value WHERE feature_id NOT IN (SELECT arc_id FROM arc UNION SELECT node_id FROM node UNION SELECT connec_id FROM connec UNION SELECT gully_id FROM gully)'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: No rows without feature found on man_addfields_value table.');
		END IF;	

	ELSIF v_project_type='WS' THEN
		v_querytext = '(SELECT pol_id FROM polygon EXCEPT SELECT pol_id FROM (select pol_id from man_register UNION select pol_id from man_tank UNION select pol_id from man_fountain) a) b';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' polygons without parent (register, tank, fountain).  We recommend you to clean data before continue.'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: No polygons without parent feature (register, tank, fountain) found.');
		END IF;

	END IF;
	
	-- connec/gully without link
	v_querytext = 'SELECT connec_id,connecat_id,the_geom from '||v_edit||'connec WHERE state= 1 
					AND connec_id NOT IN (select feature_id from link)';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 204, connec_id, connecat_id, ''Connecs without links'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' connecs without links.'));
	ELSE
		INSERT INTO audit_check_data 	(fid, criticity, error_message)
		VALUES (25, 1, 'INFO: All connecs have links.');
	END IF;

	IF v_project_type = 'UD' THEN 
		v_querytext = 'SELECT gully_id,gratecat_id,the_geom from '||v_edit||'gully WHERE state= 1 
						AND gully_id NOT IN (select feature_id from link)';
	

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		
		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
			SELECT 204, gully_id, gratecat_id, ''Gullies without links'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' gullies without links.'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: All gullies have links.');
		END IF;
	
	END IF;

	--connec/gully without arc_id or with arc_id different than the one to which points its link
	v_querytext = 'SELECT  '||v_edit||'connec.connec_id,  '||v_edit||'connec.connecat_id,  '||v_edit||'connec.the_geom
				FROM '||v_edit||'link
				LEFT JOIN '||v_edit||'connec ON '||v_edit||'link.feature_id = '||v_edit||'connec.connec_id 
				INNER JOIN arc ON st_dwithin(arc.the_geom, st_endpoint('||v_edit||'link.the_geom), 0.01)
				WHERE exit_type = ''VNODE'' AND (arc.arc_id <> '||v_edit||'connec.arc_id or '||v_edit||'connec.arc_id is null) 
				AND '||v_edit||'link.feature_type = ''CONNEC'' AND arc.state=1 and '||v_edit||'connec.connec_id IS NOT NULL
				and '||v_edit||'link.feature_id NOT IN (SELECT connec_id FROM node,link
				LEFT JOIN '||v_edit||'connec ON '||v_edit||'link.feature_id = '||v_edit||'connec.connec_id 
				LEFT JOIN vnode ON '||v_edit||'link.exit_id=vnode.vnode_id::text
				WHERE exit_type = ''VNODE'' AND st_dwithin(vnode.the_geom, node.the_geom,0.01))
				ORDER BY '||v_edit||'link.feature_type, link_id';


	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 206, connec_id, connecat_id, ''Connecs without or with incorrect arc_id'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' connecs without or with incorrect arc_id.'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: All connecs have correct arc_id.');
	END IF;

	IF v_project_type = 'UD' THEN
		v_querytext = 'SELECT  '||v_edit||'gully.gully_id,  '||v_edit||'gully.gratecat_id,  '||v_edit||'gully.the_geom
					FROM '||v_edit||'link
					LEFT JOIN '||v_edit||'gully ON '||v_edit||'link.feature_id = '||v_edit||'gully.gully_id 
					INNER JOIN arc ON st_dwithin(arc.the_geom, st_endpoint('||v_edit||'link.the_geom), 0.01)
					WHERE exit_type = ''VNODE'' AND (arc.arc_id <> '||v_edit||'gully.arc_id or '||v_edit||'gully.arc_id is null) 
					AND '||v_edit||'link.feature_type = ''GULLY'' AND arc.state=1 AND '||v_edit||'gully.gully_id IS NOT NULL
					and '||v_edit||'link.feature_id NOT IN (SELECT gully_id FROM node,link
					LEFT JOIN '||v_edit||'gully ON '||v_edit||'link.feature_id = '||v_edit||'gully.gully_id 
					LEFT JOIN vnode ON '||v_edit||'link.exit_id=vnode.vnode_id::text
					WHERE exit_type = ''VNODE'' AND st_dwithin(vnode.the_geom, node.the_geom,0.01))
					ORDER BY '||v_edit||'link.feature_type, link_id';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
			SELECT 206, gully_id, gratecat_id, ''Gullies without or with incorrect arc_id'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' gullies without or with incorrect arc_id.'));
		ELSE
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: All gullies have correct arc_id.');
		END IF;
	END IF;

	-- links without feature_id
	v_querytext = 'SELECT link_id, the_geom FROM link where feature_id is null and state > 0';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' links with state > 0 without feature_id.'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: All links state > 0 have feature_id.');
	END IF;

	-- links without exit_id
	v_querytext = 'SELECT link_id, the_geom FROM link where exit_id is null and state > 0';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' links with state > 0 without exit_id. To repair it you can query:'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 3, 'UPDATE link SET exit_id = a.vnode_id FROM (SELECT link_id, vnode_id FROM link, vnode WHERE st_dwithin(st_endpoint(link.the_geom), vnode.the_geom, 0.01) AND exit_id IS NULL)a WHERE link.link_id = a.link_id');
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: All links state > 0 have exit_id.');
	END IF;

	--Chained connecs/gullies which has different arc_id than the final connec/gully.
	IF v_project_type = 'WS' THEN 
		v_querytext = 'with c as (
					Select '||v_edit||'connec.connec_id as id, arc_id as arc, '||v_edit||'connec.connecat_id as 
					feature_catalog, the_geom 
					from '||v_edit||'connec
					)
					select c1.id, c1.feature_catalog, c1.the_geom
					from link a
					left join c c1 on a.feature_id = c1.id
					left join c c2 on a.exit_id = c2.id
					where (a.exit_type =''CONNEC'')
					and c1.arc <> c2.arc';
	ELSIF v_project_type = 'UD' THEN
		v_querytext = 'with c as (
					Select '||v_edit||'connec.connec_id as id, arc_id as arc,'||v_edit||'connec.connecat_id as 
					feature_catalog, the_geom from '||v_edit||'connec
					UNION select '||v_edit||'gully.gully_id as id, arc_id as arc,'||v_edit||'gully.gratecat_id, 
					the_geom from '||v_edit||'gully
					)
					select c1.id, c1.feature_catalog, c1.the_geom
					from link a
					left join c c1 on a.feature_id = c1.id
					left join c c2 on a.exit_id = c2.id
					where (a.exit_type =''CONNEC'' OR a.exit_type =''GULLY'')
					and c1.arc <> c2.arc';
	END IF;

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		IF v_project_type = 'UD' THEN
			EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
			SELECT 205, id, feature_catalog, ''Chained connecs or gullies with different arc_id'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' chained connecs or gullies with different arc_id.'));
		ELSIF v_project_type = 'WS' THEN
			EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
			SELECT 205, id, feature_catalog, ''Chained connecs with different arc_id'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' chained connecs with different arc_id.'));
		END IF;
	ELSE
		IF v_project_type = 'UD' THEN	
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: All chained connecs and gullies have the same arc_id');
		ELSIF v_project_type = 'WS' THEN
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (25, 1, 'INFO: All chained connecs have the same arc_id');
		END IF;
	END IF;

	--features with state 1 and end date
	IF v_project_type = 'WS' THEN
		v_querytext = 'SELECT arc_id as feature_id  from '||v_edit||'arc where state = 1 and enddate is not null
					UNION SELECT node_id from '||v_edit||'node where state = 1 and enddate is not null
					UNION SELECT connec_id from '||v_edit||'connec where state = 1 and enddate is not null';
	ELSIF v_project_type = 'UD' THEN
		v_querytext = 'SELECT arc_id as feature_id from '||v_edit||'arc where state = 1 and enddate is not null
					UNION SELECT node_id from '||v_edit||'node where state = 1 and enddate is not null
					UNION SELECT connec_id from '||v_edit||'connec where state = 1 and enddate is not null
					UNION SELECT gully_id from '||v_edit||'gully where state = 1 and enddate is not null';
	END IF;

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' features on service with value of end date.'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No features on service have value of end date');
	END IF;

	--features with state 0 and without end date
	IF v_project_type = 'WS' THEN
		v_querytext = 'SELECT arc_id as feature_id  from '||v_edit||'arc where state = 0 and enddate is null
					UNION SELECT node_id from '||v_edit||'node where state = 0 and enddate is null
					UNION SELECT connec_id from '||v_edit||'connec where state = 0 and enddate is null';
	ELSIF v_project_type = 'UD' THEN
		v_querytext = 'SELECT arc_id as feature_id from '||v_edit||'arc where state = 0 and enddate is null
					UNION SELECT node_id from '||v_edit||'node where state = 0 and enddate is null
					UNION SELECT connec_id from '||v_edit||'connec where state = 0 and enddate is null
					UNION SELECT gully_id from '||v_edit||'gully where state = 0 and enddate is null';
	END IF;

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' features with state 0 without value of end date.'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No features with state 0 are missing the end date');
	END IF;

	--features with state 1 and end date
	IF v_project_type = 'WS' THEN
		v_querytext = 'SELECT arc_id as feature_id  from '||v_edit||'arc where enddate < builtdate
					UNION SELECT node_id from '||v_edit||'node where enddate < builtdate
					UNION SELECT connec_id from '||v_edit||'connec where enddate < builtdate';
	ELSIF v_project_type = 'UD' THEN
		v_querytext = 'SELECT arc_id as feature_id from '||v_edit||'arc where enddate < builtdate
					UNION SELECT node_id from '||v_edit||'node where enddate < builtdate
					UNION SELECT connec_id from '||v_edit||'connec where enddate < builtdate
					UNION SELECT gully_id from '||v_edit||'gully where enddate < builtdate';
	END IF;

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' features with end date earlier than built date.'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No features with end date earlier than built date');
	END IF;

	--Automatic links with more than 100 mts (longitude out-of-range)
	EXECUTE 'SELECT count(*) FROM v_edit_link where userdefined_geom  = false AND st_length(the_geom) > 100'
	INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' automatic links with longitude out-of-range found.'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('QUERY: SELECT count(*) FROM v_edit_link where userdefined_geom  = false AND st_length(the_geom) > 100'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 2, concat('HINT: If link is ok, change userdefined_geom from false to true. Does not make sense automatic link with this longitude.'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (25, 1, 'INFO: No automatic links with out-of-range Longitude found.');
	END IF;
		
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (25, v_result_id, 1, '');
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND 
	fid = 25 order by criticity desc, id asc) row;
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
  	FROM (SELECT id, node_id as feature_id, nodecat_id as feature_catalog, state, expl_id, descript,fid, the_geom FROM anl_node WHERE cur_user="current_user"()
	AND fid IN (104,77,187,196,187,202,203)
	UNION
	SELECT id, connec_id, connecat_id, state, expl_id, descript,fid, the_geom FROM anl_connec WHERE cur_user="current_user"()
	AND fid IN (201,202,204,205,206)) row) features;

	v_result := COALESCE(v_result, '{}'); 

	IF v_result = '{}' THEN 
		v_result_point = '{"geometryType":"", "features":[]}';
	ELSE 
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');
	END IF;

	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, fid, the_geom
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid IN (4, 188, 202, 123)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 


	IF v_result = '{}' THEN 
		v_result_line = '{"geometryType":"", "features":[]}';
	ELSE 
		v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}');
	END IF;

	--polygons
	v_result_polygon = '{"geometryType":"", "values":[]}';
		
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 
	
	--  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||','||
				'"setVisibleLayers":[] }'||
		       '}'||
	    '}')::json;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
