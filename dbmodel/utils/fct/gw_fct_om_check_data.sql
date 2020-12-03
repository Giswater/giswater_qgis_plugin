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

SELECT * FROM audit_check_data WHERE fid = 125

--fid:  main: 125
	other: 104,187,188,196,197,201,202,203,204,205,257,296

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
	DELETE FROM audit_check_data WHERE fid = 125 AND cur_user=current_user;
	
	-- delete old values on anl table
	DELETE FROM anl_connec WHERE cur_user=current_user AND fid IN (210,201,202,204,205,257, 291);
	DELETE FROM anl_arc WHERE cur_user=current_user AND fid IN (103, 196, 197, 188, 223, 202 );
	DELETE FROM anl_node WHERE cur_user=current_user AND fid IN (177,187, 202, 296);


	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, null, 4, concat('DATA QUALITY ANALYSIS ACORDING O&M RULES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, null, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, null, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, null, 1, '-------');

		
	-- UTILS

	RAISE NOTICE '01 - system variables (302)';
	v_querytext = 'SELECT parameter FROM config_param_system WHERE lower(value) != lower(standardvalue) AND standardvalue IS NOT NULL';
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	EXECUTE concat('SELECT (array_agg(parameter))::text FROM (',v_querytext,')a') INTO v_result;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 2, '302', concat('WARNING-302: There is/are ',v_count,' system variables with out-of-standard values ',v_result,'.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '302', 'INFO: No system variables with values out-of-standars found.',v_count);
	END IF;

	
	RAISE NOTICE '02 - Check node_1 or node_2 nulls (103)';
	v_querytext = '(SELECT arc_id,arccat_id,the_geom FROM '||v_edit||'arc WHERE state > 0 AND node_1 IS NULL UNION SELECT arc_id, arccat_id, the_geom FROM '
	||v_edit||'arc WHERE state > 0 AND node_2 IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
			SELECT 103, arc_id, arccat_id, ''node_1 or node_2 nulls'', the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 3, '103', concat('ERROR-103: There is/are ',v_count,' arc''s without node_1 or node_2.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 1, '103','INFO: No arc''s without node_1 or node_2 nodes found.', v_count);
	END IF;

	RAISE NOTICE '03 - Check state 1 arcs with state 0 nodes (196)';
	v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_1=node_id WHERE a.state =1 AND n.state=0 UNION
			SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_2=node_id WHERE a.state =1 AND n.state=0) a';
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
		SELECT 196, arc_id, arccat_id, ''Arc with state=1 using nodes with state = 0'', the_geom FROM ', v_querytext);

		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 3,'196', concat('ERROR-196: There is/are ',v_count,' arcs with state=1 using extremals nodes with state = 0. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 1,'196', 'INFO: No arcs with state=1 using nodes with state=0 found.',v_count);
	END IF;

	RAISE NOTICE '04 - check conduits (UD) with negative slope and inverted slope is not checked (251)';
	IF v_project_type  ='UD' THEN

		IF v_edit IS NULL THEN 
			v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM arc a WHERE sys_slope < 0 AND state > 0 AND inverted_slope IS FALSE) a';
		ELSE
			v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM v_edit_arc a WHERE slope < 0 AND state > 0 AND inverted_slope IS FALSE) a';
		END IF;
		
		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 3, '251',
			concat('ERROR-251: There is/are ',v_count,' arcs with inverted slope false and slope negative values. Please, check your data before continue'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '251','INFO: No arcs with inverted slope checked found.',v_count);
		END IF;	
	END IF;

	RAISE NOTICE '05 - Check state 1 arcs with state 2 nodes (197)';
	v_querytext = '(SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_1=node_id WHERE a.state =1 AND n.state=2 UNION
			SELECT a.arc_id, arccat_id, a.the_geom FROM '||v_edit||'arc a JOIN '||v_edit||'node n ON node_2=node_id WHERE a.state =1 AND n.state=2) a';
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
		SELECT 197, arc_id, arccat_id, ''Arcs with state=1 using nodes with state = 2'', the_geom FROM ', v_querytext);

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (125, '197', 3, concat('ERROR-197: There is/are ',v_count,' arcs with state=1 using extremals nodes with state = 2. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid,result_id, criticity, error_message, fcount)
		VALUES (125, '197',1, 'INFO: No arcs with state=1 using nodes with state=0 found.',v_count);
	END IF;	

	RAISE NOTICE '06 - Check all state=2 are involved in at least in one psector (252)';
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
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (125, 3, '252', concat('ERROR-252: There is/are ',v_count,' features with state=2 without psector assigned. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '252', 'INFO: No features with state=2 without psector assigned.',v_count);
	END IF;


	RAISE NOTICE '07 - Check state_type nulls (arc, node) (175)';

	v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE state > 0 AND state_type IS NULL 
		        UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE state > 0 AND state_type IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (125, 3, '175',concat('ERROR-175: There is/are ',v_count,' topologic features (arc, node) with state_type with NULL values. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '175', 'INFO: No topologic features (arc, node) with state_type NULL values found.',v_count);
	END IF;


	RAISE NOTICE '08 - Check nodes with state_type isoperative = false (187)';
	v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node n JOIN value_state_type ON id=state_type WHERE n.state > 0 AND is_operative IS FALSE';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
		SELECT 187, node_id, nodecat_id, ''Nodes with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (125,'187', 2, concat('WARNING-187: There is/are ',v_count,' node(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  result_id,criticity, error_message, fcount)
		VALUES (125, '187', 1, 'INFO: No nodes with state > 0 AND state_type.is_operative on FALSE found.',v_count);
	END IF;


	RAISE NOTICE '09 - Check arcs with state_type isoperative = false (188)';
	v_querytext = 'SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc a JOIN value_state_type ON id=state_type WHERE a.state > 0 AND is_operative IS FALSE';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
			SELECT 188, arc_id, arccat_id, ''arcs with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (125, '188', 2, concat('WARNING-188: There is/are ',v_count,' arc(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (125, '188', 1, 'INFO: No arcs with state > 0 AND state_type.is_operative on FALSE found.',v_count);
	END IF;

	RAISE NOTICE '10 - check if all tanks are defined in config_mincut_inlet  (177)';
	IF v_project_type = 'WS' THEN
		v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node 
		JOIN cat_node ON nodecat_id=cat_node.id
		JOIN cat_feature ON cat_node.nodetype_id = cat_feature.id
		JOIN value_state_type ON state_type = value_state_type.id
		WHERE value_state_type.is_operative IS TRUE AND system_id = ''TANK'' and node_id NOT IN 
		(SELECT node_id FROM config_mincut_inlet WHERE active IS TRUE)';
		
		EXECUTE concat('SELECT count(*) FROM (',v_querytext,') a ') INTO v_count;
		EXECUTE concat('SELECT string_agg(a.node_id::text,'','') FROM (',v_querytext,') a ') INTO v_feature_id;

		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
			SELECT 177, node_id, nodecat_id, ''Tanks not defined in config_mincut_inlet'', the_geom FROM (', v_querytext,')a');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (125,'177', 2, concat('WARNING-177: There is/are ',v_count,' tanks which are not defined on config_mincut_inlet. Node_id: ',v_feature_id,'. Please, check your data before continue'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (125, '177', 1, 'INFO: All tanks are defined in config_mincut_inlet.',v_count);
		END IF;
	END IF;

	RAISE NOTICE '11 - check if drawn arc direction is the same as defined node_1, node_2 (223)';

	v_querytext = 'SELECT a.arc_id , arccat_id, a.the_geom FROM arc a, node n WHERE st_dwithin(st_startpoint(a.the_geom), n.the_geom, 0.0001) and node_2 = node_id
			UNION
			SELECT a.arc_id , arccat_id, a.the_geom  FROM arc a, node n WHERE st_dwithin(st_endpoint(a.the_geom), n.the_geom, 0.0001) and node_1 = node_id';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,') a ') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
		SELECT 223, arc_id, arccat_id, ''Drawing direction different than definition of node_1, node_2'', the_geom FROM (',v_querytext,')a');
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 2, '223', concat('WARNING-223: There is/are ',v_count,' arcs with drawing direction different than definition of node_1, node_2'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 1, '223', 'INFO: No arcs with drawing direction different than definition of node_1, node_2',v_count);
	END IF;

	RAISE NOTICE '12 - Check nulls customer code for connecs (210)';
	v_querytext = 'SELECT connec_id FROM '||v_edit||'connec WHERE state=1 and customer_code IS NULL';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,') a ') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 210, connec_id, connecat_id, ''Connecs with null customer code'', the_geom FROM connec WHERE connec_id IN (', v_querytext,')');
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 2, '210', concat('WARNING-210: There is/are ',v_count,' connec with customer code null. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 1, '210','INFO: No connecs with null customer code.',v_count);
	END IF;

	RAISE NOTICE '13 - Check unique customer code for connecs with state=1 (201)';
	v_querytext = 'SELECT customer_code FROM '||v_edit||'connec WHERE state=1 and customer_code IS NOT NULL group by customer_code having count(*) > 1';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,') a ') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 201, connec_id, connecat_id, ''Connecs with customer code duplicated'', the_geom FROM connec WHERE customer_code IN (', v_querytext,')');
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 2, '201', concat('WARNING-201: There is/are ',v_count,' connec customer code duplicated. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '201', 'INFO: No connecs with customer code duplicated.',v_count);
	END IF;


	RAISE NOTICE '14 - Check if all id are integers (202)';
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

		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 3, '202', concat('ERROR-202: There is/are ',v_count,' which id is not an integer. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '202', 'INFO: All features with id integer.',v_count);
	END IF;

	RAISE NOTICE '15 - Check state not according with state_type (253)';
	IF v_project_type = 'UD' THEN
		v_querytext =  'SELECT a.state, state_type FROM '||v_edit||'arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
				UNION SELECT a.state, state_type FROM '||v_edit||'element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
			VALUES (125, 3, '253', concat('ERROR-253: There is/are ',v_count,' features(s) with state without concordance with state_type. Please, check your data before continue'),v_count);
			
		ELSE
			INSERT INTO audit_check_data (fid, criticity,result_id, error_message, fcount)
			VALUES (125, 1, '253','INFO: No features without concordance againts state and state_type.',v_count);
		END IF;
		
	ELSIF v_project_type = 'WS' THEN
	
		v_querytext =  'SELECT a.state, state_type FROM '||v_edit||'arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
				UNION SELECT a.state, state_type FROM '||v_edit||'connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
				UNION SELECT a.state, state_type FROM '||v_edit||'element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 3, '253', concat('ERROR-253: There is/are ',v_count,' features(s) with state without concordance with state_type. Please, check your data before continue'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '253', 'INFO: No features without concordance againts state and state_type.',v_count);
		END IF;
	END IF;


	RAISE NOTICE '16 - Check code with null values (254)';
	IF v_project_type ='UD' THEN
		v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE code IS NULL 
					UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE code IS NULL
					UNION SELECT connec_id, connecat_id, the_geom FROM '||v_edit||'connec WHERE code IS NULL
					UNION SELECT gully_id, gratecat_id, the_geom FROM '||v_edit||'gully WHERE code IS NULL
					UNION SELECT element_id, elementcat_id, the_geom FROM '||v_edit||'element WHERE code IS NULL) a';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (125, 3, '254', concat('ERROR-254: There is/are ',v_count,' with code with NULL values. Please, check your data before continue'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '254', 'INFO: No features (arc, node, connec, gully, element) with NULL values on code found.',v_count);
		END IF;

	ELSIF v_project_type ='WS' THEN

		v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM '||v_edit||'arc WHERE code IS NULL 
				UNION SELECT node_id, nodecat_id, the_geom FROM '||v_edit||'node WHERE code IS NULL
				UNION SELECT connec_id, connecat_id, the_geom FROM '||v_edit||'connec WHERE code IS NULL
				UNION SELECT element_id, elementcat_id, the_geom FROM '||v_edit||'element WHERE code IS NULL) a';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (125, 3, '254', concat('ERROR-254: There is/are ',v_count,' with code with NULL values. Please, check your data before continue'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '254', 'INFO: No features (arc, node, connec, element) with NULL values on code found.',v_count);
		END IF;
	END IF;
			
	RAISE NOTICE '17 - Check for orphan polygons on polygon table (255)';
	IF v_project_type ='UD' THEN

		v_querytext = '(SELECT pol_id FROM polygon EXCEPT SELECT pol_id FROM (select pol_id from gully UNION select pol_id from man_chamber 
					   UNION select pol_id from man_netgully UNION select pol_id from man_storage UNION select pol_id from man_wwtp) a) b';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (125, 2, '255', concat('WARNING-255: There is/are ',v_count,' polygons without parent (gully, netgully, chamber, storage or wwtp).  We recommend you to clean data before continue.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '255','INFO: No polygons without parent feature (gully, netgully, chamber, storage or wwtp) found.',v_count);
		END IF;
	ELSIF v_project_type='WS' THEN
		v_querytext = '(SELECT pol_id FROM polygon EXCEPT SELECT pol_id FROM (select pol_id from man_register UNION select pol_id from man_tank UNION select pol_id from man_fountain) a) b';

		EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (125, 2, '255', concat('WARNING-255: There is/are ',v_count,' polygons without parent (register, tank, fountain).  We recommend you to clean data before continue.'), v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '255', 'INFO: No polygons without parent feature (register, tank, fountain) found.', v_count);
		END IF;
	END IF;

	RAISE NOTICE '18 - Check for orphan rows on man_addfields values table (256)';
	IF v_project_type ='UD' THEN

		v_querytext = 'SELECT * FROM man_addfields_value a LEFT JOIN 
			      (SELECT arc_id as feature_id FROM arc UNION SELECT node_id FROM node UNION SELECT connec_id FROM connec UNION SELECT gully_id FROM gully) b USING (feature_id) WHERE b.feature_id IS NULL';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 2, '256', concat('WARNING-256: There is/are ',v_count,' rows on man_addfields_value without parent feature. We recommend you to clean data before continue.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '256', 'INFO: No rows without feature found on man_addfields_value table.',v_count);
		END IF;	
	ELSIF v_project_type='WS' THEN
		v_querytext = 'SELECT * FROM man_addfields_value a LEFT JOIN 
			      (SELECT arc_id as feature_id FROM arc UNION SELECT node_id FROM node UNION SELECT connec_id FROM connec) b USING (feature_id) WHERE b.feature_id IS NULL';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 2, '256', concat('WARNING-256: There is/are ',v_count,' rows on man_addfields_value without parent feature. We recommend you to clean data before continue.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '256', 'INFO: No rows without feature found on man_addfields_value table.',v_count);
		END IF;	

	END IF;
	
	RAISE NOTICE '19 - connec/gully without link (204)';
	v_querytext = 'SELECT connec_id,connecat_id,the_geom from '||v_edit||'connec WHERE state= 1 
					AND connec_id NOT IN (select feature_id from link)';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 204, connec_id, connecat_id, ''Connecs without links'', the_geom FROM (', v_querytext,')a');

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (125, '204', 2, concat('WARNING-204: There is/are ',v_count,' connecs without links.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (125, '204',1, 'INFO: All connecs have links.',v_count);
	END IF;

	IF v_project_type = 'UD' THEN 
		v_querytext = 'SELECT gully_id,gratecat_id,the_geom from '||v_edit||'gully WHERE state= 1 
						AND gully_id NOT IN (select feature_id from link)';
	

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		
		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
			SELECT 204, gully_id, gratecat_id, ''Gullies without links'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (125, '204',2, concat('WARNING-204: There is/are ',v_count,' gullies without links.'), v_count);
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (125,'204', 1, 'INFO: All gullies have links.', v_count);
		END IF;
	
	END IF;

	RAISE NOTICE '20 - connec/gully without arc_id or with arc_id different than the one to which points its link (257)';
	IF (SELECT count(*) FROM arc ) < 20000 THEN -- too big
	
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
			SELECT 257, connec_id, connecat_id, ''Connecs without or with incorrect arc_id'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
			VALUES (125, 2, '257', concat('WARNING-257: There is/are ',v_count,' connecs without or with incorrect arc_id.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
			VALUES (125, 1, '257', 'INFO: All connecs have correct arc_id.',v_count);
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
				SELECT 257, gully_id, gratecat_id, ''Gullies without or with incorrect arc_id'', the_geom FROM (', v_querytext,')a');

				INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
				VALUES (125, 2, '257', concat('WARNING-257: There is/are ',v_count,' gullies without or with incorrect arc_id.'),v_count);
			ELSE
				INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
				VALUES (125, 1, '257', 'INFO: All gullies have correct arc_id.', v_count);
			END IF;
		END IF;
	END IF;

	
	RAISE NOTICE '21 - Check vnode inconsistency (vnode without link) (259)';
	v_querytext = 'SELECT vnode_id FROM vnode LEFT JOIN link ON vnode_id = exit_id::integer where link_id IS NULL';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	
	IF v_count > 0 THEN
	
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 2, '259',concat('WARNING-259: There is/are ',v_count,' vnodes without link. They will be automatically repaired'),v_count);
		
		EXECUTE 'DELETE FROM vnode WHERE vnode_id IN ('||v_querytext||')';
		
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '259', 'INFO: All vnodes have vnode link.', v_count);

	END IF;
	

	RAISE NOTICE '22 - links without feature_id (260)';
	v_querytext = 'SELECT link_id, the_geom FROM link where feature_id is null and state > 0';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 3, '260', concat('ERROR-260: There is/are ',v_count,' links with state > 0 without feature_id.'), v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '260', 'INFO: All links state > 0 have feature_id.', v_count);
	END IF;

	RAISE NOTICE '23 - links without exit_id (261)';
	v_querytext = 'SELECT link_id, the_geom FROM link where exit_id is null and state > 0';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 3, '261',concat('ERROR-261: There is/are ',v_count,' links with state > 0 without exit_id.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '261', 'INFO: All links state > 0 have exit_id.',v_count);
	END IF;


	RAISE NOTICE '24 - Chained connecs/gullies which has different arc_id than the final connec/gully. (205)';
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

			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 2, '205', concat('WARNING-205: There is/are ',v_count,' chained connecs or gullies with different arc_id.'),v_count);
		ELSIF v_project_type = 'WS' THEN
			EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
			SELECT 205, id, feature_catalog, ''Chained connecs with different arc_id'', the_geom FROM (', v_querytext,')a');

			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 2, '205',concat('WARNING-205: There is/are ',v_count,' chained connecs with different arc_id.'),v_count);
		END IF;
	ELSE
		IF v_project_type = 'UD' THEN	
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '205','INFO: All chained connecs and gullies have the same arc_id',v_count);
		ELSIF v_project_type = 'WS' THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (125, 1, '205','INFO: All chained connecs have the same arc_id', v_count);
		END IF;
	END IF;

	RAISE NOTICE '25 - features with state 1 and end date (262)';
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
		INSERT INTO audit_check_data (fid, criticity,result_id, error_message, fcount)
		VALUES (125, 2, '262',concat('WARNING-262: There is/are ',v_count,' features on service with value of end date.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '262', 'INFO: No features on service have value of end date', v_count);
	END IF;

	RAISE NOTICE 'features with state 0 and without end date (263)';
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
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 2, '263', concat('WARNING-263: There is/are ',v_count,' features with state 0 without value of end date.'), v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 1, '263','INFO: No features with state 0 are missing the end date',v_count);
	END IF;

	RAISE NOTICE '26 - features with state 1 and end date before start date (264)';
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
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 2, '264',concat('WARNING-264: There is/are ',v_count,' features with end date earlier than built date.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '264','INFO: No features with end date earlier than built date',v_count);
	END IF;

	RAISE NOTICE '27 - Automatic links with more than 100 mts (longitude out-of-range) (265)';

	EXECUTE 'SELECT count(*) FROM v_edit_link where userdefined_geom  = false AND st_length(the_geom) > 100'
	INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 2, '265', concat('WARNING-265: There is/are ',v_count,' automatic links with longitude out-of-range found.'),v_count);
		INSERT INTO audit_check_data (fid, criticity, error_message, fcount)
		VALUES (125, 2, concat('HINT: If link is ok, change userdefined_geom from false to true. Does not make sense automatic link with this longitude.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (125, 1,'265', 'INFO: No automatic links with out-of-range Longitude found.',v_count);
	END IF;

    RAISE NOTICE '28 - Duplicated ID values between arc, node, connec, gully(266)';
	IF v_project_type = 'WS' THEN
		v_querytext = 'SELECT node_id AS feature_id FROM node JOIN arc ON arc.arc_id=node.node_id
					UNION SELECT node_id FROM node JOIN connec ON connec.connec_id=node.node_id
					UNION SELECT arc.arc_id FROM arc JOIN connec ON connec.connec_id=arc.arc_id';	
	ELSIF v_project_type = 'UD' THEN
		v_querytext = 'SELECT node_id AS feature_id FROM node JOIN arc ON arc.arc_id=node.node_id
					UNION SELECT node_id FROM node JOIN connec ON connec.connec_id=node.node_id
					UNION SELECT node_id FROM node JOIN gully ON gully.gully_id=node.node_id
					UNION SELECT connec_id FROM connec JOIN gully ON gully.gully_id=connec.connec_id
					UNION SELECT arc.arc_id FROM arc JOIN connec ON connec.connec_id=arc.arc_id	
					UNION SELECT arc.arc_id FROM arc JOIN gully ON gully.gully_id=arc.arc_id';	
	END IF;

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count = 1 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 2, '266', concat('WARNING-266: There is ',v_count,' feature with duplicated ID value between arc, node, connec, gully '), v_count);
	ELSIF v_count > 1 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 2, '266', concat('WARNING-266: There are ',v_count,' features with duplicated ID values between arc, node, connec, gully '), v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '266','INFO: All features have a diferent ID to be correctly identified',v_count);
	END IF;

	RAISE NOTICE '29 - Check planned connects without reference link (356)';

	IF v_project_type = 'WS' THEN
		v_querytext = 'SELECT count(*) FROM plan_psector_x_connec LEFT JOIN link ON feature_id = connec_id WHERE link_id IS NULL';
	ELSIF v_project_type = 'UD' THEN
		v_querytext = 'SELECT count(*) FROM (SELECT * FROM plan_psector_x_connec LEFT JOIN link ON feature_id = connec_id WHERE link_id IS NULL
				UNION SELECT * FROM plan_psector_x_gully LEFT JOIN link ON feature_id = gully_id WHERE link_id IS NULL)a';
	END IF;


	EXECUTE v_querytext INTO v_count;

	IF v_count = 1 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 3, '356', concat('ERROR-356: There is ',v_count,' planned connec or gully without reference link'), v_count);
	ELSIF v_count > 1 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 3, '356', concat('ERROR-356: There are ',v_count,' planned connecs or gullys without reference link'), v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (125, 1, '356', 'INFO: All planned connecs or gullys have a reference link', v_count);
	END IF;


	RAISE NOTICE '30 - Connecs and gullies with different expl_id than arc (291)';

	IF v_project_type = 'WS' THEN
		v_querytext = 'SELECT DISTINCT connec_id, connecat_id, c.the_geom FROM connec c JOIN arc b using (arc_id) WHERE b.expl_id::text != c.expl_id::text';
	ELSIF v_project_type = 'UD' THEN
		v_querytext = 'SELECT * FROM (SELECT DISTINCT connec_id, connecat_id, c.the_geom FROM connec c JOIN arc b using (arc_id) WHERE b.expl_id::text != c.expl_id::text
				UNION SELECT DISTINCT  gully_id, gratecat_id, g.the_geom gully_id FROM gully g JOIN arc d using (arc_id) WHERE d.expl_id::text != g.expl_id::text)a';
	END IF;

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count = 1 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 291, connec_id, connecat_id, ''Connec or gully with different expl_id than related arc'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message)
		VALUES (125, 3, '291', concat('ERROR-291: There is ',v_count,' connec or gully with exploitation different than the exploitation of the related arc'));
	ELSIF v_count > 1 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom)
		SELECT 291, connec_id, connecat_id, ''Connec or gully with different expl_id than related arc'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message)
		VALUES (125, 3, '291', concat('ERROR-291: There are ',v_count,' connecs or gullies with exploitation different than the exploitation of the related arc'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message)
		VALUES (125, 1, '291', 'INFO: All connecs or gullys have the same exploitation as the related arc');
	END IF;


	IF (SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_crm_schema') IS TRUE THEN 

		RAISE NOTICE '31 - Control null values on crm.hydrometer.code(299)';
		v_querytext = 'SELECT id FROM crm.hydrometer WHERE code IS NULL';

		EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity,result_id,error_message, fcount)
			VALUES (125, 3, '299', concat('ERROR-299: There is/are ',v_count,' hydrometers in crm schema without code.'),v_count);
		ELSE
			INSERT INTO audit_check_data (fid, criticity,result_id, error_message,fcount)
			VALUES (125, 1, '299','INFO: All hydrometers on crm schema have code',v_count);
		END IF;
	END IF;
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (125, v_result_id, 1, '');
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND 
	fid = 125 order by criticity desc, id asc) row;
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
	AND fid IN (177,187, 202)
	UNION
	SELECT id, connec_id, connecat_id, state, expl_id, descript,fid, the_geom FROM anl_connec WHERE cur_user="current_user"()
	AND fid IN (110,201,202,204,205,206,291,296)) row) features;

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
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid IN (103, 196, 197, 188, 223, 202)) row) features;

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
	
	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||
		       '}'||
	    '}}')::json, 2670);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
