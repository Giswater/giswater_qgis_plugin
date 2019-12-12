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
v_project_type 		text;
v_count			integer;
v_saveondatabase 	boolean;
v_result 		text;
v_version		text;
v_result_info 		json;
v_result_point		json;
v_result_line 		json;
v_result_polygon	json;
v_querytext		text;
v_result_id 		text;
v_features 		text;
v_edit			text;
v_onlygrafanalytics boolean;
v_config_param text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_features := ((p_data ->>'data')::json->>'parameters')::json->>'selectionMode'::text;
	v_onlygrafanalytics := ((p_data ->>'data')::json->>'parameters')::json->>'onlyGrafAnalytics';

	
	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	-- init variables
	v_count=0;


	-- set v_edit_ variable
	IF v_features='wholeSystem' THEN
		v_edit = '';
	ELSIF v_features='userSelectors' THEN
		v_edit = 'v_edit_';
	END IF;
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=25 AND user_name=current_user;
	
	-- delete old values on anl table
	DELETE FROM anl_connec WHERE cur_user=current_user AND fprocesscat_id IN (101,102,104,105,106);
	DELETE FROM anl_arc WHERE cur_user=current_user AND fprocesscat_id IN (4,88,102);
	DELETE FROM anl_node WHERE cur_user=current_user AND fprocesscat_id IN (4,76,79,80,81,82,87,96,97,102,103);

	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 4, concat('DATA QUALITY ANALYSIS ACORDING O&M RULES'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, null, 1, '-------');

		
	-- UTILS

	-- delete config_param_user rows with deprecated variables
	DELETE FROM config_param_user WHERE parameter NOT IN (SELECT id FROM audit_cat_param_user);
	
	-- Check node_1 or node_2 nulls (fprocesscat = 4)
	v_querytext = '(SELECT arc_id,arccat_id,the_geom FROM '||v_edit||'arc WHERE state > 0 AND node_1 IS NULL UNION SELECT arc_id, arccat_id, the_geom FROM '
	||v_edit||'arc WHERE state > 0 AND node_2 IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, descript, the_geom) 
			SELECT 4, arc_id, arccat_id, ''node_1 or node_2 nulls'', the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' arc''s without node_1 or node_2.'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 3, concat('SELECT * FROM anl_arc WHERE fprocesscat_id=4 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No arc''s without node_1 or node_2 nodes found.');
	END IF;

	-- Chec state 1 arcs with state 0 nodes
	v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_1=node_id WHERE a.state =1 AND n.state=0 UNION
			SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_2=node_id WHERE a.state =1 AND n.state=0) a';
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) 
		SELECT 96, node_id, nodecat_id, ''Nodes with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' arcs with state=1 using extremals nodes with state = 0. Please, check your data before continue'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=96 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No arcs with state=1 using nodes with state=0 found.');
	END IF;

	-- Chec state 1 arcs with state 2 nodes
	v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_1=node_id WHERE a.state =1 AND n.state=2 UNION
			SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_2=node_id WHERE a.state =1 AND n.state=2) a';
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) 
		SELECT 97, node_id, nodecat_id, ''Nodes with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' arcs with state=1 using extremals nodes with state = 0. Please, check your data before continue'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=97 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No arcs with state=1 using nodes with state=0 found.');
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
		EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) 
		SELECT 87, node_id, nodecat_id, ''Nodes with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' node(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=87 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No nodes with state > 0 AND state_type.is_operative on FALSE found.');
	END IF;


	-- Check arcs with state_type isoperative = false (fprocesscat = 88)
	v_querytext = 'SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc a JOIN value_state_type ON id=state_type WHERE a.state > 0 AND is_operative IS FALSE';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, descript, the_geom) 
			SELECT 88, arc_id, arccat_id, ''arcs with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' arc(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('SELECT * FROM anl_arc WHERE fprocesscat_id=88 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No arcs with state > 0 AND state_type.is_operative on FALSE found.');
	END IF;

	-- Check unique customer code for connecs with state=1 
	v_querytext = 'SELECT customer_code FROM '||v_edit||'connec WHERE state=1 group by customer_code having count(*) > 1';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,') a ') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, descript, the_geom) 
		SELECT 101, connec_id, connecat_id, ''Connecs with customer code duplicated'', the_geom FROM connec WHERE customer_code IN (', v_querytext,')');
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' connec customer code duplicated. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
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

		EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, descript, the_geom) 
		SELECT 102, feature_id, featurecat, ''Connecs with id which is not an integer'', the_geom FROM ', v_querytext,' 
		WHERE  feature_id=0 AND type = ''CONNEC'' ');

		EXECUTE concat ('INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, descript, the_geom) 
		SELECT 102,  feature_id, featurecat, ''Arcs with id which is not an integer'', the_geom FROM ', v_querytext,' 
		WHERE  feature_id=0 AND type = ''ARC'' ');

		EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) 
		SELECT 102,  feature_id, featurecat, ''Nodes with id which is not an integer'', the_geom FROM ', v_querytext,' 
		WHERE  feature_id=0 AND type = ''NODE'' ');
			
		IF v_project_type = 'UD' THEN
			EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, node_id, nodecat_id, descript, the_geom) 
			SELECT 102, feature_id, featurecat, ''Gullies with id which is not an integer'', the_geom FROM ', v_querytext,' 
			WHERE feature_id=0 AND type = ''GULLY'' ');
		END IF;

		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 3, concat('ERROR: There is/are ',v_count,' which id is not an integer. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: All features with id integer.');
	END IF;

	-- only UD projects
	IF 	v_project_type='UD' THEN

		-- Check state not according with state_type	
		v_querytext =  'SELECT a.state, state_type FROM '||v_edit||'arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
				UNION SELECT a.state, state_type FROM '||v_edit||'element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' features(s) with state without concordance with state_type. Please, check your data before continue'));
			
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: No features without concordance againts state and state_type.');
		END IF;

		-- Check code with null values
		v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE code IS NULL 
					UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE code IS NULL
					UNION SELECT connec_id, connecat_id, the_geom FROM '||v_edit||'connec WHERE code IS NULL
					UNION SELECT gully_id, gratecat_id, the_geom FROM '||v_edit||'gully WHERE code IS NULL
					UNION SELECT element_id, elementcat_id, the_geom FROM '||v_edit||'element WHERE code IS NULL) a';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' with code with NULL values. Please, check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: No features (arc, node, connec, gully, element) with NULL values on code found.');
		END IF;
		
		
		-- Check for missed features on inp tables
		v_querytext = '(SELECT arc_id, ''arc'' as feature_tpe FROM arc WHERE arc_id NOT IN (select arc_id from inp_conduit UNION select arc_id from inp_virtual UNION select arc_id from inp_weir 
						UNION select arc_id from inp_pump UNION select arc_id from inp_outlet UNION select arc_id from inp_orifice) AND state > 0 AND epa_type !=''NOT DEFINED''
						UNION
						SELECT node_id, ''node'' FROM node WHERE node_id NOT IN(
						select node_id from inp_junction UNION select node_id from inp_storage UNION select node_id from inp_outfall UNION select node_id from inp_divider)
						AND state >0 AND epa_type !=''NOT DEFINED'') a';
		
		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN

			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' missed features on inp tables. Please, check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: No features missed on inp_tables found.');
		END IF;
		
	
		-- Check for orphan polygons on polygon table
		v_querytext = '(SELECT pol_id FROM polygon EXCEPT SELECT pol_id FROM (select pol_id from gully UNION select pol_id from man_chamber 
					   UNION select pol_id from man_netgully UNION select pol_id from man_storage UNION select pol_id from man_wwtp) a) b';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' polygons without parent (gully, netgully, chamber, storage or wwtp).  We recommend you to clean data before continue.'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: No polygons without parent feature (gully, netgully, chamber, storage or wwtp) found.');
		END IF;
		
	
		-- Check for orphan rows on man_addfields values table
		v_querytext = 'SELECT * FROM man_addfields_value WHERE feature_id NOT IN (SELECT arc_id FROM arc UNION SELECT node_id FROM node UNION SELECT connec_id FROM connec UNION SELECT gully_id FROM gully)';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
		IF v_count > 0 THEN
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' rows on man_addfields_value without parent feature. We recommend you to clean data before continue.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('SELECT * FROM man_addfields_value WHERE feature_id NOT IN (SELECT arc_id FROM arc UNION SELECT node_id FROM node UNION SELECT connec_id FROM connec UNION SELECT gully_id FROM gully)'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: No rows without feature found on man_addfields_value table.');
		END IF;
	
	
	ELSIF v_project_type='WS' THEN

		--Check if nodes that are final nodes of arc (node_1, node_2) don't have arc_id assigned

		v_querytext ='(SELECT node_id, nodecat_id, '||v_edit||'node.the_geom from '||v_edit||'node 
		join arc n1 on n1.node_1 = '||v_edit||'node.node_id 
		join arc n2 on n2.node_2 = '||v_edit||'node.node_id
		where '||v_edit||'node.arc_id is not null)';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext,' a') INTO v_count;

		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) 
			SELECT 103, node_id, nodecat_id, ''Final nodes with assigned arc_id'', the_geom FROM (', v_querytext,') a');

			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' nodes, which are arc''s finals and have assigned value of arc_id. Please, check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: No final nodes have arc_id assigned.');
		END IF;

		-- Check state not according with state_type	
		v_querytext =  'SELECT a.state, state_type FROM '||v_edit||'arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
				UNION SELECT a.state, state_type FROM '||v_edit||'element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' features(s) with state without concordance with state_type. Please, check your data before continue'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: No features without concordance againts state and state_type.');
		END IF;


		IF v_onlygrafanalytics::boolean IS FALSE THEN

			-- Check code with null values
			v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE code IS NULL 
					UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE code IS NULL
					UNION SELECT connec_id, connecat_id, the_geom FROM '||v_edit||'connec WHERE code IS NULL
					UNION SELECT element_id, elementcat_id, the_geom FROM '||v_edit||'element WHERE code IS NULL) a';

			EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
				VALUES (25, 3, concat('ERROR: There is/are ',v_count,' with code with NULL values. Please, check your data before continue'));
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
				VALUES (25, 1, 'INFO: No features (arc, node, connec, element) with NULL values on code found.');
			END IF;
	
			-- Check for missed features on inp tables
			v_querytext = '(SELECT arc_id FROM arc WHERE arc_id NOT IN (SELECT arc_id from inp_pipe UNION SELECT arc_id FROM inp_virtualvalve) 
					AND state > 0 AND epa_type !=''NOT DEFINED'' UNION SELECT node_id FROM node WHERE node_id 
					NOT IN (select node_id from inp_shortpipe UNION select node_id from inp_valve UNION select node_id from inp_tank 
					UNION select node_id FROM inp_reservoir UNION select node_id FROM inp_pump UNION SELECT node_id from inp_inlet 
					UNION SELECT node_id from inp_junction) AND state >0 AND epa_type !=''NOT DEFINED'') a';
		
			EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
				VALUES (25, 3, concat('ERROR: There is/are ',v_count,' missed features on inp tables. Please, check your data before continue'));
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
				VALUES (25, 1, 'INFO: No features missed on inp_tables found.');
			END IF;
	
	
			-- Check for orphan polygons on polygon table
			v_querytext = '(SELECT pol_id FROM polygon EXCEPT SELECT pol_id FROM (select pol_id from man_register UNION select pol_id from man_tank UNION select pol_id from man_fountain) a) b';

			EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
				VALUES (25, 2, concat('WARNING: There is/are ',v_count,' polygons without parent (register, tank, fountain).  We recommend you to clean data before continue.'));
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
				VALUES (25, 1, 'INFO: No polygons without parent feature (register, tank, fountain) found.');
			END IF;
	
	
			-- Check for orphan rows on man_addfields values table
			v_querytext = 'SELECT * FROM man_addfields_value WHERE feature_id NOT IN (SELECT arc_id FROM arc UNION SELECT node_id FROM node UNION SELECT connec_id FROM connec)';

			EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
			IF v_count > 0 THEN
				VALUES (25, 2, concat('WARNING: There is/are ',v_count,' rows without feature on man_addfields_value table.  We recommend you to clean data before continue.'));
				INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
				VALUES (25, 2, concat('SELECT * FROM man_addfields_value WHERE feature_id NOT IN (SELECT arc_id FROM arc UNION SELECT node_id FROM node UNION SELECT connec_id FROM connec)'));
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
				VALUES (25, 1, 'INFO: No rows without feature found on man_addfields_value table.');
			END IF;

		END IF;
	
		
		-- valves closed/broken with null values (fprocesscat = 76)
		v_querytext = '(SELECT n.node_id, n.nodecat_id, n.the_geom FROM '||v_edit||'man_valve JOIN node n USING (node_id) WHERE n.state > 0 AND (broken IS NULL OR closed IS NULL)) a';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 76, node_id, nodecat_id, ''valves closed/broken with null values'', the_geom FROM ', v_querytext);
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 3, concat('ERROR: There is/are ',v_count,' valve''s (state=1) with broken or closed with NULL values.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 3, concat('SELECT * FROM anl_node WHERE fprocesscat_id=76 AND cur_user=current_user'));
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
		ELSIF v_count=0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: The table anl_mincut_inlet_x_exploitation is not configured.')); 
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: It seems anl_mincut_inlet_x_exploitation table is well configured. At least, table is filled with nodes from all exploitations.');
		END IF;
	
		-- nodetype.grafdelimiter configuration
		SELECT count(*) INTO v_count FROM node_type where graf_delimiter IS NULL;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' rows on the node_type table with null values on graf_delimiter. Please check your data before continue'));
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
			EXECUTE concat 
			('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 79, node_id, nodecat_id, ''Node_type is SECTOR but node is not configured on sector.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''SECTOR'' not configured on the sector table.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=79 AND cur_user=current_user'));
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
			EXECUTE concat 
			('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 80, node_id, nodecat_id, ''Node_type is DMA but node is not configured on dma.grafconfig'', the_geom FROM ('
			, v_querytext,')a');
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''DMA'' not configured on the dma table.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=80 AND cur_user=current_user'));
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
			EXECUTE concat 
			('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 81, node_id, nodecat_id, ''Node_type is DQA but node is not configured on dqa.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''DQA'' not configured on the dqa table.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=81 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: All nodes with node_type.grafdelimiter=''DQA'' are defined as nodeParent on dqa.grafconfig');
		END IF;

		-- presszone : check coherence againts nodetype.grafdelimiter and nodeparent defined on cat_presszone.grafconfig (fprocesscat = 82)
		v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node JOIN cat_node c ON id=nodecat_id JOIN node_type n ON n.id=c.nodetype_id
				LEFT JOIN (SELECT node_id FROM '||v_edit||'node JOIN (SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' as node_id 
				FROM cat_presszone WHERE grafconfig IS NOT NULL)a USING (node_id)) a USING (node_id) WHERE graf_delimiter=''PRESSZONE'' AND a.node_id IS NULL 
				AND node_id NOT IN (SELECT (json_array_elements_text((grafconfig->>''ignore'')::json))::text FROM cat_presszone)';


		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			EXECUTE concat 
			('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 82, node_id, nodecat_id, ''Node_type is PRESSZONE but node is not configured on cat_presszone.grafconfig'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,
			' node(s) with node_type.graf_delimiter=''PRESSZONE'' not configured on the cat_presszone table.'));
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=82 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: All nodes with node_type.grafdelimiter=''PRESSZONE'' are defined as nodeParent on cat_presszone.grafconfig');
		END IF;
		

		-- sector, toArc (fprocesscat = 83)

		-- dma, toArc (fprocesscat = 84)

		-- dqa, toArc (fprocesscat = 85)

		-- presszone, toArc (fprocesscat = 86)
		
	END IF;
	
	-- connec/gully without link
	v_querytext = 'SELECT connec_id,connecat_id,the_geom from '||v_edit||'connec WHERE state= 1 
					AND connec_id NOT IN (select feature_id from link)';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, descript, the_geom) 
		SELECT 104, connec_id, connecat_id, ''Connecs without links'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' connecs without links.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: All connecs have links.');
	END IF;

	IF v_project_type = 'UD' THEN 
		v_querytext = 'SELECT gully_id,gratecat_id,the_geom from '||v_edit||'gully WHERE state= 1 
						AND gully_id NOT IN (select feature_id from link)';
	END IF;

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, descript, the_geom) 
		SELECT 104, gully_id, gratecat_id, ''Gullies without links'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' gullies without links.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: All gullies have links.');
	END IF;

	--connec/gully without arc_id or with arc_id different than the one to which points its link
	v_querytext = 'SELECT  '||v_edit||'connec.connec_id,  '||v_edit||'connec.connecat_id,  '||v_edit||'connec.the_geom
				FROM '||v_edit||'link
				LEFT JOIN '||v_edit||'connec ON '||v_edit||'link.feature_id = '||v_edit||'connec.connec_id 
				INNER JOIN arc ON st_dwithin(arc.the_geom, st_endpoint('||v_edit||'link.the_geom), 0.01)
				WHERE exit_type = ''VNODE'' AND (arc.arc_id <> '||v_edit||'connec.arc_id or '||v_edit||'connec.arc_id is null) 
				AND '||v_edit||'link.feature_type = ''CONNEC'' AND arc.state=1
				and '||v_edit||'link.feature_id NOT IN (SELECT connec_id FROM node,link
				LEFT JOIN '||v_edit||'connec ON '||v_edit||'link.feature_id = '||v_edit||'connec.connec_id 
				LEFT JOIN vnode ON '||v_edit||'link.exit_id=vnode.vnode_id::text
				WHERE exit_type = ''VNODE'' AND st_dwithin(vnode.the_geom, node.the_geom,0.01))
				ORDER BY '||v_edit||'link.feature_type, link_id';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	raise notice 'v_count,%',v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, descript, the_geom) 
		SELECT 106, connec_id, connecat_id, ''Connecs without or with incorrect arc_id'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' connecs without or with incorrect arc_id.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: All connecs have correct arc_id.');
	END IF;

	IF v_project_type = 'UD' THEN
		v_querytext = 'SELECT  '||v_edit||'gully.gully_id,  '||v_edit||'gully.gratecat_id,  '||v_edit||'gully.the_geom
					FROM '||v_edit||'link
					LEFT JOIN '||v_edit||'gully ON '||v_edit||'link.feature_id = '||v_edit||'gully.gully_id 
					INNER JOIN arc ON st_dwithin(arc.the_geom, st_endpoint('||v_edit||'link.the_geom), 0.01)
					WHERE exit_type = ''VNODE'' AND (arc.arc_id <> '||v_edit||'gully.arc_id or '||v_edit||'gully.arc_id is null) 
					AND '||v_edit||'link.feature_type = ''GULLY'' AND arc.state=1
					and '||v_edit||'link.feature_id NOT IN (SELECT gully_id FROM node,link
					LEFT JOIN '||v_edit||'gully ON '||v_edit||'link.feature_id = '||v_edit||'gully.gully_id 
					LEFT JOIN vnode ON '||v_edit||'link.exit_id=vnode.vnode_id::text
					WHERE exit_type = ''VNODE'' AND st_dwithin(vnode.the_geom, node.the_geom,0.01))
					ORDER BY '||v_edit||'link.feature_type, link_id';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, descript, the_geom) 
			SELECT 106, gully_id, gratecat_id, ''Gullies without or with incorrect arc_id'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' gullies without or with incorrect arc_id.'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: All gullies have correct arc_id.');
		END IF;
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
			EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, descript, the_geom) 
			SELECT 105, id, feature_catalog, ''Chained connecs or gullies with different arc_id'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' chained connecs or gullies with different arc_id.'));
		ELSIF v_project_type = 'WS' THEN
			EXECUTE concat ('INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, descript, the_geom) 
			SELECT 105, id, feature_catalog, ''Chained connecs with different arc_id'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 2, concat('WARNING: There is/are ',v_count,' chained connecs with different arc_id.'));
		END IF;
	ELSE
		IF v_project_type = 'UD' THEN	
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
			VALUES (25, 1, 'INFO: All chained connecs and gullies have the same arc_id');
		ELSIF v_project_type = 'WS' THEN
			INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
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
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' features on service with value of end date.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
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
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' features with state 0 without value of end date.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
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
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: There is/are ',v_count,' features with end date earlier than built date.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, 'INFO: No features with end date earlier than built date');
	END IF;

	--config variables 
	--state_topocontrol
	SELECT value INTO v_config_param FROM config_param_system WHERE parameter = 'state_topocontrol';

	IF v_config_param::BOOLEAN IS TRUE THEN
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, concat('INFO: Value of parameter state topocontrol: ',v_config_param,'.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: Value of parameter state topocontrol: ',v_config_param,'. Control is disabled.'));
	END IF;
	
	--edit_enable_arc_nodes_update
	INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
	SELECT 25, 1, concat('INFO: Value of parameter edit enable arc nodes update: ',value,'.') 
	FROM config_param_system WHERE parameter = 'edit_enable_arc_nodes_update';

	--edit_topocontrol_dsbl_error
	SELECT value INTO v_config_param FROM config_param_system WHERE parameter = 'edit_topocontrol_dsbl_error';

	IF v_config_param::BOOLEAN IS FALSE THEN
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 1, concat('INFO: Value of parameter edit topocontrol dbl error: ',v_config_param,'.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (25, 2, concat('WARNING: Value of parameter edit topocontrol dbl error: ',v_config_param,'. Control is disabled.'));
	END IF;

	--sys_raster_dem	
	INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
	SELECT 25, 1, concat('INFO: Value of parameter sys raster dem: ',value,'.') 
	FROM config_param_system WHERE parameter = 'sys_raster_dem';

	--sys_exploitation_x_user
	INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
	SELECT 25, 1, concat('INFO: Value of parameter sys exploitation x user: ',value,'.') 
	FROM config_param_system WHERE parameter = 'sys_exploitation_x_user';

	IF v_project_type = 'UD' THEN
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		SELECT 25, 1, concat('INFO: Value of parameter geom slope direction: ',value,'.') 
		FROM config_param_system WHERE parameter = 'geom_slp_direction';
	END IF;


	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, v_result_id, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, v_result_id, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, v_result_id, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (25, v_result_id, 1, '');
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND 
	fprocesscat_id=25 order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id as feature_id, nodecat_id as feature_catalog, state, expl_id, descript,fprocesscat_id, the_geom FROM anl_node WHERE cur_user="current_user"() 
	AND (fprocesscat_id=4  OR fprocesscat_id=76 OR fprocesscat_id=79 OR fprocesscat_id=80 OR 
		fprocesscat_id=81 OR fprocesscat_id=82 OR fprocesscat_id=87 OR fprocesscat_id=96 OR 
		fprocesscat_id=87 OR fprocesscat_id=102 OR fprocesscat_id=103)
	UNION
	SELECT id, connec_id, connecat_id, state, expl_id, descript,fprocesscat_id, the_geom FROM anl_connec WHERE cur_user="current_user"() 
	AND (fprocesscat_id=101 OR fprocesscat_id=102 OR fprocesscat_id=104 OR fprocesscat_id=105 OR fprocesscat_id=106)) row;  

	v_result := COALESCE(v_result, '{}'); 
	
	IF v_result = '{}' THEN 
		v_result_point = '{"geometryType":"", "values":[]}';
	ELSE 
		v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');
	END IF;

	--lines
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom FROM anl_arc WHERE cur_user="current_user"() 
	AND (fprocesscat_id=4 OR fprocesscat_id=88 OR fprocesscat_id=102)) row; 
	v_result := COALESCE(v_result, '{}'); 

	IF v_result = '{}' THEN 
		v_result_line = '{"geometryType":"", "values":[]}';
	ELSE 
		v_result_line = concat ('{"geometryType":"LineString", "values":',v_result, '}');
	END IF;

	--polygons
	v_result_polygon = '{"geometryType":"", "values":[]}';

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
