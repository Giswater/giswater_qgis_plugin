/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2430

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_check_data(character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":227}}}$$)-- when is called from go2epa_main
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":101}}}$$)-- when is called from checkproject
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data('{"parameters":{}}')-- when is called from toolbox

-- fid: main: 225
		other: 107,153,164,165,166,167,169,170,171,188,198,227,229,230,292,293,294,295,371,379,433,411,412,430,432,480

*/


DECLARE

v_record record;
v_project_type text;
v_count	integer;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_result json;
v_defaultdemand	float;
v_error_context text;
v_fid integer;
v_nodetolerance float;
v_minlength float;
v_nodeproximity float;

BEGIN
	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid'::text;
	
	-- select config values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	v_nodetolerance :=  (SELECT value::json->>'value' FROM config_param_system WHERE parameter = 'edit_node_proximity');
	v_minlength := (SELECT value FROM config_param_system WHERE parameter = 'epa_arc_minlength');
	v_nodeproximity := (SELECT value::json->>'value' FROM config_param_system WHERE parameter = 'edit_node_proximity');

	-- init variables
	v_count=0;
	IF v_fid is null THEN
		v_fid = 225;
	END IF;

	--create temp tables
	CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
	CREATE TEMP TABLE temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
	CREATE TEMP TABLE temp_anl_connec (LIKE SCHEMA_NAME.anl_connec INCLUDING ALL);
	CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

	-- Header
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  4, 'CHECK GIS DATA QUALITY ACORDING EPA RULES');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  4, '----------------------------------------------------------');

	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, 'CRITICAL ERRORS');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, '----------------------');

	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, 'WARNINGS');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, '--------------');
		
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, 'INFO');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, '-------');
	
	RAISE NOTICE '1 - Check orphan nodes (fid:  107)';
	v_querytext = '(SELECT node_id, nodecat_id, the_geom, expl_id FROM 
			(SELECT node_id FROM v_edit_node EXCEPT (SELECT node_1 as node_id FROM v_edit_arc UNION SELECT node_2 FROM v_edit_arc))a 
			JOIN node USING (node_id)
			JOIN selector_sector USING (sector_id) 
			JOIN value_state_type v ON state_type = v.id
			WHERE epa_type != ''UNDEFINED'' and is_operative = true and cur_user = current_user and arc_id IS NULL) b';		
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO temp_anl_node (fid, node_id, nodecat_id, descript, the_geom, expl_id) SELECT 107, node_id, nodecat_id, ''Orphan node'',
		the_geom, expl_id FROM ', v_querytext);
		INSERT INTO temp_audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 2, '107', 
		concat('WARNING-107 (temp_anl_node): There is/are ',v_count,' node''s orphans ready-to-export (epa_type & state_type). If they are actually orphan, you could change the epa_type to fix it'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, result_id,  error_message, fcount)
		VALUES (v_fid, 1, '107', 'INFO: No node(s) orphan found.',v_count);
	END IF;
		
	
	RAISE NOTICE '4 - Check state_type nulls (arc, node) (175)';
	v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM v_edit_arc JOIN selector_sector USING (sector_id) WHERE state_type IS NULL AND cur_user = current_user
			UNION 
			SELECT node_id, nodecat_id, the_geom FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE state_type IS NULL AND cur_user = current_user) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 3, '175',concat('ERROR-175: There is/are ',v_count,' topologic features (arc, node) with state_type with NULL values. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 1,'175', 'INFO: No topologic features (arc, node) with state_type NULL values found.',v_count);
	END IF;

	RAISE NOTICE '5 - Check for missed features on inp tables (272)';
	v_querytext = '(SELECT arc_id, ''arc'' FROM v_edit_arc LEFT JOIN 
			(SELECT arc_id from inp_pipe UNION SELECT arc_id FROM inp_virtualvalve UNION SELECT arc_id FROM inp_virtualpump) b using (arc_id)
			WHERE b.arc_id IS NULL AND state > 0 AND epa_type !=''UNDEFINED''
			UNION 
		SELECT node_id, ''node'' FROM v_edit_node LEFT JOIN 
			(select node_id from inp_shortpipe UNION select node_id from inp_valve 
			UNION select node_id from inp_tank 
			UNION select node_id FROM inp_reservoir UNION select node_id FROM inp_pump 
			UNION SELECT node_id from inp_inlet 
			UNION SELECT node_id from inp_junction) b USING (node_id)
			WHERE b.node_id IS NULL AND state >0 AND epa_type !=''UNDEFINED'') a';


	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 3, '272',concat('ERROR-272: There is/are ',v_count,' missed features on inp tables. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 1, '272', 'INFO: No features missed on inp_tables found.',v_count);
	END IF;

	
	RAISE NOTICE '6 - Null elevation control (fid: 164)';
	SELECT count(*) INTO v_count FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE elevation IS NULL AND cur_user = current_user;
		
	IF v_count > 0 THEN
		INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, expl_id)
		SELECT 164, node_id, nodecat_id, the_geom, expl_id FROM v_edit_node WHERE elevation IS NULL;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '164', 3, concat('ERROR-164 (temp_anl_node): There is/are ',v_count,' node(s) without elevation. Take a look on temporal table for details.'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '164', 1, 'INFO: No nodes with null values on field elevation have been found.',v_count);
	END IF;
	

	RAISE NOTICE '7 - Elevation control with cero values (fid: 165)';
	SELECT count(*) INTO v_count FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE elevation = 0 AND cur_user = current_user;

	IF v_count > 0 THEN
		INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, expl_id)
		SELECT 165, node_id, nodecat_id, the_geom, 'Elevation with zero', expl_id FROM v_edit_node WHERE elevation=0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '165', 2, concat('WARNING-165 (temp_anl_node): There is/are ',v_count,' node(s) with elevation=0.'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '165', 1, 'INFO: No nodes with ''0'' on field elevation have been found.',v_count);
	END IF;
	

	RAISE NOTICE '8 - Node2arcs with more than two arcs (fid: 166)';
	INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, expl_id)
		SELECT 166, a.node_id, a.nodecat_id, a.the_geom, 'Node2arc with more than two arcs', expl_id FROM (
		SELECT node_id, nodecat_id, node.the_geom, node.expl_id FROM node
		JOIN selector_sector USING (sector_id)
		JOIN v_edit_arc a1 ON node_id=a1.node_1
		AND node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') WHERE current_user=cur_user
		UNION ALL
		SELECT node_id, nodecat_id, node.the_geom, node.expl_id FROM node
		JOIN selector_sector USING (sector_id)
		JOIN v_edit_arc a1 ON node_id=a1.node_2
		AND node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') WHERE current_user=cur_user)a
	GROUP by node_id, nodecat_id, the_geom, expl_id
	HAVING count(*) > 2;
	
	SELECT count(*) INTO v_count FROM temp_anl_node WHERE fid = 166 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '166', 3, concat('ERROR-166 (temp_anl_node): There is/are ',v_count,' node2arcs with more than two arcs. It''s impossible to continue'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '166', 1, 'INFO: No results found looking for node2arc(s) with more than two arcs.',v_count);
	END IF;
	

	RAISE NOTICE '9 - Mandatory node2arcs with less than two arcs (fid: 167)';
	INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, expl_id)
	SELECT 167, a.node_id, a.nodecat_id, a.the_geom, 'Node2arc with less than two arcs', a.expl_id FROM (
		SELECT node_id, nodecat_id, v_edit_node.the_geom, v_edit_node.expl_id FROM v_edit_node
		JOIN selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user)
		UNION ALL
		SELECT node_id, nodecat_id, v_edit_node.the_geom, v_edit_node.expl_id FROM v_edit_node
		JOIN selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user))a
	GROUP by node_id, nodecat_id, the_geom, expl_id
	HAVING count(*) < 2;


	SELECT count(*) INTO v_count FROM temp_anl_node WHERE fid = 167 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '167', 2, concat('WARNING-167 (temp_anl_node): There is/are ',
		v_count,' node2arc(s) with less than two arcs. All of them have been transformed to nodarc using only arc joined. For more info you can type: '),v_count);
	ELSE 
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '167', 1 ,'INFO: No results found looking for node2arc(s) with less than two arcs.', v_count);
	END IF;

	
	RAISE NOTICE '10 - Check sense of cv pipes only to warning to user about the sense of the geometry (169)';
	INSERT INTO temp_anl_arc (fid, arc_id, arccat_id, the_geom, sector_id)
	SELECT 169, arc_id, arccat_id, the_geom, sector_id FROM v_edit_inp_pipe WHERE status='CV';

	SELECT count(*) INTO v_count FROM temp_anl_arc WHERE fid = 169 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '169', 2, concat('WARNING-169 (temp_anl_arc): There is/are ',
		v_count,' CV pipes. Be carefull with the sense of pipe and check that node_1 and node_2 are on the right direction to prevent reverse flow.'),v_count);
	ELSE 
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '169', 1,'INFO: No results found for CV pipes',v_count);
	END IF;

	
	RAISE NOTICE '11 - Check to arc on valves, at least arc_id exists as closest arc (fid: 170)';

	-- to_arc missed values (368)
	IF (SELECT value FROM config_param_system WHERE parameter = 'epa_shutoffvalve') = 'VALVE' THEN
		SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE to_arc IS NULL AND valv_type != 'TCV';
	ELSE 
		SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE to_arc IS NULL;
	END IF;
	
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '368', 3, concat(
		'ERROR-368: There is/are ',v_count,' valve(s) with missed values on mandatory column to_arc.'), v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '368', 1, 'INFO: Valve to_arc missed values checked. No mandatory values missed.', 0);
	END IF;
	
	-- to_arc wrong values (170)
	IF (SELECT value FROM config_param_system WHERE parameter = 'epa_shutoffvalve') = 'VALVE' THEN
		INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, sector_id)
		select 170, node_id, nodecat_id, the_geom, 'To arc is null or does not exists as closest arc for valve', sector_id FROM v_edit_inp_valve JOIN(
		select node_id FROM v_edit_inp_valve JOIN arc on arc_id=to_arc AND node_id=node_1 where valv_type !='TCV'
		union
		select node_id FROM v_edit_inp_valve JOIN arc on arc_id=to_arc AND node_id=node_2 where valv_type !='TCV')a USING (node_id)
		WHERE a.node_id IS NULL;			
	ELSE 
		INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, sector_id)
		select 170, node_id, nodecat_id, the_geom, 'To arc is null or does not exists as closest arc for valve', sector_id FROM v_edit_inp_valve JOIN(
		select node_id FROM v_edit_inp_valve JOIN arc on arc_id=to_arc AND node_id=node_1
		union
		select node_id FROM v_edit_inp_valve JOIN arc on arc_id=to_arc AND node_id=node_2)a USING (node_id)
		WHERE a.node_id IS NULL;	
	END IF;
	
	
	SELECT count(*) INTO v_count FROM temp_anl_node WHERE fid = 170 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '170', 3, concat('ERROR-170 (temp_anl_node): There is/are ', v_count,' valve(s) with wrong to_arc value according with the two closest arcs.'),v_count);
	ELSE 
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '170', 1,
		'INFO: Valve to_arc wrong values checked. No inconsistencies have been detected (values acording closest arcs).', v_count);
	END IF;


	RAISE NOTICE '12 - Valve_type (273)';
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE valv_type IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '273', 3, concat(
		'ERROR-273: There is/are ',v_count,' valve(s) with null values on valv_type column.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '273', 1, 'INFO: Valve valv_type checked. No mandatory values missed.',v_count);
	END IF;

	SELECT count(*) INTO v_count FROM v_edit_inp_virtualvalve WHERE valv_type IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '273', 3, concat(
		'ERROR-273: There is/are ',v_count,' virtualvalve(s) with null values on valv_type column.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '273', 1, 'INFO: Virtualvalve valv_type checked. No mandatory values missed.',v_count);
	END IF;


	RAISE NOTICE '13 - Valve status (274), to_arc (368), pressure (275), curve_id (276), coef_loss (277), flow (278)';

	-- status (274)
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE status IS NULL AND state > 0;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '274', 3, concat(
		'ERROR-274: There is/are ',v_count,' valve(s) with null values on mandatory column status.'), v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '274', 1, 'INFO: Valve status checked. No mandatory values missed.',v_count);
	END IF;

	SELECT count(*) INTO v_count FROM v_edit_inp_virtualvalve WHERE status IS NULL AND state > 0;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '274', 3, concat(
		'ERROR-274: There is/are ',v_count,' virtualvalve(s) with null values on mandatory column status.'), v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '274', 1, 'INFO: Virtualvalve status checked. No mandatory values missed.',v_count);
	END IF;

	-- pressure (275)
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='PBV' OR valv_type='PRV' OR valv_type='PSV') AND (pressure IS NULL));
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '275', 3, concat(
		'ERROR-275: There is/are ',v_count,' PBV-PRV-PSV valve(s) with null values on the mandatory column for Pressure valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '275', 1, 'INFO: PBC-PRV-PSV valves checked. No mandatory values missed.',v_count);
	END IF;	

	SELECT count(*) INTO v_count FROM v_edit_inp_virtualvalve WHERE ((valv_type='PBV' OR valv_type='PRV' OR valv_type='PSV') AND (pressure IS NULL));
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '275', 3, concat(
		'ERROR-275: There is/are ',v_count,' PBV-PRV-PSV virtualvalve(s) with null values on mandatory column for Pressure valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '275', 1, 'INFO: PBC-PRV-PSV virtualvalves checked. No mandatory values missed.',v_count);
	END IF;				

	-- curve_id (276)';
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='GPV') AND (curve_id IS NULL));
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '276', 3, concat(
		'ERROR-276: There is/are ',v_count,' GPV valve(s) with null values on mandatory column for General purpose valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '276', 1, 'INFO: GPV valves checked. No mandatory values missed.',v_count);
	END IF;	

	SELECT count(*) INTO v_count FROM v_edit_inp_virtualvalve WHERE ((valv_type='GPV') AND (curve_id IS NULL));
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '276', 3, concat(
		'ERROR-276: There is/are ',v_count,' GPV virtualvalve(s) with null values on mandatory column for General purpose valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '276', 1, 'INFO: GPV virtualvalves checked. No mandatory values missed.',v_count);
	END IF;	

	-- coef_loss (277)
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE valv_type='TCV' AND coef_loss IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '277', 3, concat('ERROR-277: There is/are ',v_count,' TCV valve(s) with null values on mandatory column for Losses Valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '277', 1, 'INFO: TCV valves checked. No mandatory values missed.',v_count);
	END IF;	

	SELECT count(*) INTO v_count FROM v_edit_inp_virtualvalve WHERE valv_type='TCV' AND coef_loss IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '277', 3, concat('ERROR-277: There is/are ',v_count,' TCV virtualvalve(s) with null values on mandatory column for Losses Valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '277', 1, 'INFO: TCV virtualvalves checked. No mandatory values missed.',v_count);
	END IF;				

	-- flow (278)
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='FCV') AND (flow IS NULL));
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '278', 3, concat('ERROR-278: There is/are ',v_count,' FCV valve(s) with null values on mandatory column for Flow Control Valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '278', 1, 'INFO: FCV valves checked. No mandatory values missed.',v_count);
	END IF;	

	SELECT count(*) INTO v_count FROM v_edit_inp_virtualvalve WHERE ((valv_type='FCV') AND (flow IS NULL));
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '278', 3, concat('ERROR-278: There is/are ',v_count,' FCV virtualvalve(s) with null values on mandatory column for Flow Control Valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '278', 1, 'INFO: FCV virtualvalves checked. No mandatory values missed.',v_count);
	END IF;		
	

	RAISE NOTICE '14 - Check to arc on pumps, at least arc_id exists as closest arc';
	
	-- to_arc missed values(395)
	SELECT count(*) INTO v_count FROM v_edit_inp_pump WHERE to_arc IS NULL;

	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '395', 3, concat(
		'ERROR-395: There is/are ',v_count,' Pump(s) with missed values on mandatory column to_arc.'), v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '395', 1, 'INFO: Pump to_arc missed values checked. No mandatory values missed.', 0);
	END IF;
	
	-- to_arc wrong values (171)
	INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, sector_id)
	select 171, node_id, nodecat_id , the_geom,  'To arc is null or does not exists as closest arc for pump', sector_id FROM v_edit_inp_pump WHERE node_id NOT IN(
		select node_id FROM v_edit_inp_pump JOIN arc on arc_id=to_arc AND node_id=node_1
		union
		select node_id FROM v_edit_inp_pump JOIN arc on arc_id=to_arc AND node_id=node_2);
	
	SELECT count(*) INTO v_count FROM temp_anl_node WHERE fid = 171 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '171', 3, concat('ERROR-171 (temp_anl_node): There is/are ', v_count,' pump(s) with wrong to_arc value according with closest arcs.'),v_count);

	ELSE 
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '171', 1,
		'INFO: Pump to_arc wrong values checked. have been detected (values acording closest arcs).', v_count);
	END IF;
	
	
	RAISE NOTICE '15 - pumps. Pump type and others';	

	-- pump type(279)
	SELECT count(*) INTO v_count FROM v_edit_inp_pump WHERE pump_type IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '279', 3, concat('ERROR-279: There is/are ',v_count,' pump''s with null values on pump_type column.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '279', 1, 'INFO: Pumps checked. No mandatory values for pump_type missed.',v_count);
	END IF;

	SELECT count(*) INTO v_count FROM v_edit_inp_virtualpump WHERE pump_type IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '279', 3, concat('ERROR-279: There is/are ',v_count,' virtualpump''s with null values on pump_type column.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '279', 1, 'INFO: Virtualpumps checked. No mandatory values for pump_type missed.',v_count);
	END IF;
	
	--pump curve(280)
	SELECT count(*) INTO v_count FROM v_edit_inp_pump WHERE curve_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '280', 3, concat(
		'ERROR-280: There is/are ',v_count,' pump(s) with null values at least on mandatory column curve_id.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '280', 1, 'INFO: Pumps checked. No mandatory values for curve_id missed.',v_count);
	END IF;	

	--pump curve(280)
	SELECT count(*) INTO v_count FROM v_edit_inp_virtualpump WHERE curve_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '280', 3, concat(
		'ERROR-280: There is/are ',v_count,' virtualpump(s) with null values at least on mandatory column curve_id.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '280', 1, 'INFO: Virtualpumps checked. No mandatory values for curve_id missed.',v_count);
	END IF;	

	--pump additional(281)
	SELECT count(*) INTO v_count FROM inp_pump_additional JOIN v_edit_inp_pump USING (node_id) WHERE inp_pump_additional.curve_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '281', 3, concat(
		'ERROR-281: There is/are ',v_count,' additional pump(s) with null values at least on mandatory column curve_id.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '281', 1, 'INFO: Additional pumps checked. No mandatory values for curve_id missed.',v_count);
	END IF;	
	
	
	RAISE NOTICE '16 - Check pipes with less than node proximity values (fid: 229)';
	SELECT count(*) INTO v_count FROM (SELECT st_length(the_geom) AS length FROM v_edit_inp_pipe) a WHERE length < v_nodeproximity;

	IF v_count > 0 THEN
		INSERT INTO temp_anl_arc (fid, arc_id, arccat_id, the_geom, descript, sector_id)
		SELECT 229, arc_id, arccat_id , the_geom, concat('Length less than node proximity: ', (st_length(the_geom))::numeric (12,3)), sector_id FROM v_edit_inp_pipe 
		WHERE st_length(the_geom) < v_nodeproximity;
		
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '229', 2, concat('WARNING-229 (temp_anl_arc): There is/are ',v_count,' pipe(s) with length less than node proximity distance (',v_nodeproximity,') configured.'),v_count);
		v_count=0;
		
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '229', 1, concat('INFO: Standard minimun length checked. No values less than node proximity distance (',v_nodeproximity,') configured.'),v_count);
	END IF;
	
	RAISE NOTICE '17 - Check pipes with less than min length configured (fid: 230)';
	SELECT count(*) INTO v_count FROM (SELECT st_length(the_geom) AS length FROM v_edit_inp_pipe) a WHERE length < v_minlength;

	IF v_count > 0 THEN
		INSERT INTO temp_anl_arc (fid, arc_id, arccat_id, the_geom, descript, sector_id)
		SELECT 230, arc_id, arccat_id , the_geom, concat('Length less than minimum distance: ', (st_length(the_geom))::numeric (12,3)), sector_id FROM v_edit_inp_pipe where st_length(the_geom) < v_minlength;

		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '230', 3, concat('ERROR-230 (temp_anl_arc): There is/are ',v_count,' pipe(s) with length less than configured minimum length (',v_minlength,') which are not exported.'),v_count);
		v_count=0;
		
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '230', 1, concat('INFO: Critical minimun length checked. No values less than configured minimum length (',v_minlength,') found.'), v_count);
	END IF;
	
	
	RAISE NOTICE '18 - Check roughness catalog for pipes (282)';
	SELECT count(*) INTO v_count FROM v_edit_inp_pipe JOIN cat_arc ON id = arccat_id JOIN cat_mat_roughness USING  (matcat_id)
	WHERE init_age IS NULL OR end_age IS NULL OR roughness IS NULL;

	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '282', 3, concat('ERROR-282: There is/are ',v_count,
		' pipe(s) with null values for roughness. Check roughness catalog columns (init_age,end_age,roughness) before continue.'),v_count);
		v_count=0;
		
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '282', 1, 'INFO: Roughness catalog checked. No mandatory values missed.',v_count);
	END IF;
	
	
	RAISE NOTICE '19 - Check dint value for catalogs (283)';
	SELECT count(*) INTO v_count FROM cat_arc WHERE dint IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '283', 3, concat(
		'ERROR-283: There is/are ',v_count,' register(s) on arc''s catalog with null values on dint column.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '283', 1, 'INFO: Dint for arc''s catalog checked. No values missed.',v_count);
	END IF;

	RAISE NOTICE '19.2 - Check dint value for cat_node acting as [SHORTPIPE or VALVE or PUMP] (142)';
	SELECT count(*) INTO v_count FROM cat_node WHERE dint IS NULL AND id IN 
	(SELECT DISTINCT(nodecat_id) from v_edit_node WHERE epa_type IN ('SHORTPIPE', 'VALVE'));
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '142', 2, concat(
		'WARNING-142: There is/are ',v_count,
		' register(s) on node''s catalog acting as [SHORTPIPE or VALVE] with dint not defined.'), v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '142', 1, 'INFO: Dint for node''s catalog checked. No values missed for SHORTPIPES OR VALVES',v_count);
	END IF;
	
		
	RAISE NOTICE '20 - Tanks with null mandatory values(fid: 198)';
	INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, sector_id)
	SELECT 198, a.node_id, nodecat_id, the_geom, 'Tank with null mandatory values', sector_id FROM v_edit_inp_tank a
	WHERE (initlevel IS NULL) OR (minlevel IS NULL) OR (maxlevel IS NULL) OR (diameter IS NULL) OR (minvol IS NULL);
	
	SELECT count(*) FROM temp_anl_node INTO v_count WHERE fid=198 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '198', 3, concat(
		'ERROR-198 (temp_anl_node): There is/are ',v_count,' tank(s) with null values at least on mandatory columns for tank (initlevel, minlevel, maxlevel, diameter, minvol).Take a look on temporal table to details'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '198' , 1, 'INFO: Tanks checked. No mandatory values missed.',v_count);
	END IF;	

	RAISE NOTICE '20.2 - Inlets with null mandatory values(fid: 153)';
	INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, sector_id)
	SELECT 153, a.node_id, nodecat_id, the_geom, 'Inlet with null mandatory values', sector_id FROM v_edit_inp_inlet a
	WHERE (initlevel IS NULL) OR (minlevel IS NULL) OR (maxlevel IS NULL) OR (diameter IS NULL) OR (minvol IS NULL);
	
	SELECT count(*) FROM temp_anl_node INTO v_count WHERE fid=153 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '153', 3, concat(
		'ERROR-153 (temp_anl_node): There is/are ',v_count,' inlets(s) with null values at least on mandatory columns for inlets (initlevel, minlevel, maxlevel, diameter, minvol).Take a look on temporal table to details'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '153' , 1, 'INFO: Inlets checked. No mandatory values missed.',v_count);
	END IF;		

	RAISE NOTICE '21 - pumps with more than two arcs (292)';
	INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, expl_id)
	select 292, b.node_id, nodecat_id, the_geom, 'EPA pump with more than two arcs', expl_id
	FROM(
	SELECT node_id, count(*) FROM(
	SELECT node_id FROM arc JOIN v_edit_inp_pump ON node_1 = node_id 
	WHERE arc.state=1
	UNION ALL
	SELECT node_id FROM arc JOIN v_edit_inp_pump ON node_2 = node_id
	WHERE arc.state=1) a
	JOIN node USING (node_id)
	GROUP BY node_id
	HAVING count(*)>2)b
	JOIN node USING (node_id);
	
	SELECT count(*) FROM temp_anl_node INTO v_count WHERE fid=292 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '292', 3, concat(
		'ERROR-292 (temp_anl_node): There is/are ',v_count,' pumps(s) with more than two arcs .Take a look on temporal table to details'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '292' , 1,  'INFO: EPA pumps checked. No pumps with more than two arcs detected.',v_count);
	END IF;		


	RAISE NOTICE '22 - valves with more than two arcs (293)';
	INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, expl_id)
	select 293, b.node_id, nodecat_id, the_geom, 'EPA valve with more than two arcs', expl_id
	FROM(
	SELECT node_id, count(*) FROM(
	SELECT node_id FROM arc JOIN v_edit_inp_valve ON node_1 = node_id and arc.state = 1 
	UNION ALL
	SELECT node_id FROM arc JOIN v_edit_inp_valve ON node_2 = node_id and arc.state = 1) a
	GROUP BY node_id
	HAVING count(*)>2)b
	JOIN node USING (node_id)
	WHERE node.state > 0;
	
	SELECT count(*) FROM temp_anl_node INTO v_count WHERE fid=293 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '293', 3, concat(
		'ERROR-293 (temp_anl_node): There is/are ',v_count,' valve(s) with more than two arcs .Take a look on temporal table to details'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message,fcount)
		VALUES (v_fid, '293' , 1, 'INFO: EPA valves checked. No valves with more than two arcs detected.',v_count);
	END IF;	

	
	RAISE NOTICE '23 - Inconsistency on inp node tables (294)';
	INSERT INTO temp_anl_node (fid, node_id, nodecat_id, descript, the_geom, sector_id)
		SELECT 294, n.node_id, n.nodecat_id, concat(epa_type, ' using inp_junction table') AS epa_table, n.the_geom, n.sector_id FROM v_edit_inp_junction JOIN node n USING (node_id) WHERE epa_type !='JUNCTION'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_tank table') AS epa_table, n.the_geom, n.sector_id FROM v_edit_inp_tank JOIN node n USING (node_id) WHERE epa_type !='TANK'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_reservoir table') AS epa_table, n.the_geom, n.sector_id FROM v_edit_inp_reservoir JOIN node n USING (node_id) WHERE epa_type !='RESERVOIR'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_valve table') AS epa_table, n.the_geom, n.sector_id FROM v_edit_inp_valve JOIN node n USING (node_id) WHERE epa_type !='VALVE'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_pump table') AS epa_table, n.the_geom, n.sector_id FROM v_edit_inp_pump JOIN node n USING (node_id) WHERE epa_type !='PUMP'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_shortpipe table') AS epa_table, n.the_geom, n.sector_id FROM v_edit_inp_shortpipe JOIN node n USING (node_id) WHERE epa_type !='SHORTPIPE';

		
	SELECT count(*) FROM temp_anl_node INTO v_count WHERE fid=294 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '294', 3, concat(
		'ERROR-294 (temp_anl_node): There is/are ',v_count,' node features with epa_type not according with epa table. Check your data before continue'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '294' , 1, 'INFO: Epa type for node features checked. No inconsistencies aganints epa table found.', v_count);
	END IF;	

	RAISE NOTICE '24 - Inconsistency on inp arc tables (295)';
	INSERT INTO temp_anl_arc (fid, arc_id, arccat_id, descript, the_geom, expl_id)
		SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, ' using inp_pipe table') AS epa_table, a.the_geom, a.sector_id FROM v_edit_inp_virtualvalve JOIN arc a USING (arc_id) WHERE epa_type !='VIRTUAL'
		UNION
		SELECT 295, a.arc_id, a.arccat_id,  concat(epa_type, ' using inp_virtualvalve table') AS epa_table, a.the_geom, a.sector_id FROM v_edit_inp_pipe JOIN arc a USING (arc_id) WHERE epa_type !='PIPE';

		
	SELECT count(*) FROM temp_anl_node INTO v_count WHERE fid=295 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '295', 3, concat(
		'ERROR-295 (temp_anl_arc): There is/are ',v_count,' arc features with epa_type not according with epa table. Check your data before continue'), v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '295' , 1, 'INFO: Epa type for arc features checked. No inconsistencies aganints epa table found.',v_count);
	END IF;	

	RAISE NOTICE '24 - check connecs <-> inp_connecs (295)';
	SELECT c1-c2 INTO v_count FROM (SELECT count(*) as c1, null AS c2 FROM connec UNION SELECT null, count(*) FROM inp_connec)a1
	WHERE c1 > c2;

	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '295', 3, concat(
		'WARNING-295: There is/are ',v_count,' missed inp rows on inp_connec. They have been automatic inserted'), v_count);
		INSERT INTO inp_connec SELECT connec_id FROM connec ON CONFLICT (connec_id) DO NOTHING;		
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '295' , 1, 'INFO: Epa type for connec features checked. No inconsistencies aganints epa table found.', v_count);
	END IF;	

	RAISE NOTICE '25 - check matcat_id for arcs (371)';
	SELECT count(*) INTO v_count FROM (SELECT * FROM cat_arc WHERE matcat_id IS NULL)a1;

	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '371', 3, concat(
		'ERROR-371: There is/are ',v_count,' rows with missed matcat_id on cat_arc table. Fix it before continue'), v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '371' , 1, 'INFO: No registers found without material on cat_arc table.', v_count);
	END IF;	


	RAISE NOTICE '26 - Topological nodes with epa_type UNDEFINED (379)';
	v_querytext = 'SELECT n.node_id, nodecat_id, the_geom, n.expl_id FROM (SELECT node_1 node_id, sector_id FROM v_edit_arc WHERE epa_type !=''UNDEFINED'' UNION 
			   SELECT node_2, sector_id FROM v_edit_arc WHERE epa_type !=''UNDEFINED'' )a 
		       LEFT JOIN  (SELECT node_id, nodecat_id, the_geom, expl_id FROM v_edit_node WHERE epa_type = ''UNDEFINED'') n USING (node_id) 
		       JOIN selector_sector USING (sector_id) 
		       WHERE n.node_id IS NOT NULL AND cur_user = current_user';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO temp_anl_node (fid, node_id, nodecat_id, descript, the_geom, expl_id) SELECT 379, node_id, nodecat_id, 
		''Topological node with epa_type UNDEFINED'', the_geom, expl_id FROM (', v_querytext,')a');
		INSERT INTO temp_audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 2, '379' ,concat('WARNING-379 (temp_anl_node): There is/are ',v_count,' node(s) with epa_type UNDEFINED acting as node_1 or node_2 of arcs. Please, check your data before continue.'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, result_id, error_message, fcount)
	VALUES (v_fid, 1, '379','INFO: No nodes with epa_type UNDEFINED acting as node_1 or node_2 of arcs found.',v_count);
	END IF;

	RAISE NOTICE '27 - Arc materials not defined in cat_mat_roughness table (433)';
	v_querytext = 'SELECT id FROM cat_mat_arc WHERE id NOT IN (SELECT matcat_id FROM cat_mat_roughness)';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		
		INSERT INTO temp_audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 3, '433' ,concat('ERROR-433: There is/are ',v_count,' arc materials that are not defined in cat_mat_rougnhess table. Please, check your data before continue.'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, result_id, error_message, fcount)
	VALUES (v_fid, 1, '433','INFO: All arc materials are defined on cat_mat_rougnhess table.',v_count);
	END IF;

	RAISE NOTICE '28- Mandatory nodarc over epa node (411)';

	v_querytext = 'SELECT a.* FROM (
		SELECT DISTINCT t1.node_id as n1, t1.nodecat_id as n1cat, t1.state as state1, t2.node_id as n2, t2.nodecat_id as n2cat, t2.state as state2, t1.expl_id, 411, 
		t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, ''Mandatory nodarc over other EPA node'' as descript, t1.sector_id
		FROM node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
		WHERE t1.node_id != t2.node_id 
		AND ((t1.epa_type IN (''PUMP'', ''VALVE'') AND t2.epa_type !=''UNDEFINED'') OR (t2.epa_type IN (''PUMP'', ''VALVE'') AND t1.epa_type !=''UNDEFINED''))
		ORDER BY t1.node_id) a, selector_expl e, selector_sector s
		WHERE e.expl_id = a.expl_id AND e.cur_user = current_user 
		AND s.sector_id = a.sector_id AND s.cur_user = current_user 
		AND a.state1 > 0 AND a.state2 > 0 ORDER BY dist';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 3, '411' ,concat('ERROR-411 (temp_anl_node): There is/are ',v_count,' mandatory nodarcs (VALVE & PUMP) over other EPA nodes.'),v_count);

		EXECUTE 'INSERT INTO temp_anl_node (node_id, nodecat_id, state, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, the_geom, arc_distance, descript, sector_id) SELECT * FROM ('||v_querytext||') a';
	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 1, '411','INFO: All mandatory nodarc (PUMP & VALVE) are not on the same position than other EPA nodes.',v_count);
	END IF;


	RAISE NOTICE '29- Shortpipe nodarc over epa node (412)';
	v_querytext = 'SELECT * FROM (
		SELECT DISTINCT t1.node_id as n1, t1.nodecat_id as n1cat, t1.state as state1, t2.node_id as n2, t2.nodecat_id as n2cat, t2.state as state2, t1.expl_id, 412, 
		t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, ''Shortpipe nodarc over other EPA node'' as descript
		FROM selector_expl e, selector_sector s, node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
		WHERE t1.node_id != t2.node_id 
		AND s.sector_id = t1.sector_id AND s.cur_user = current_user
		AND e.expl_id = t1.expl_id AND e.cur_user = current_user 
		AND ((t1.epa_type = ''SHORTPIPE'' AND t2.epa_type =''JUNCTION'') OR (t2.epa_type = ''SHORTPIPE'' AND t1.epa_type !=''JUNCTION''))
		AND t1.node_id =''SHORTPIPE''
		ORDER BY t1.node_id) a where a.state1 > 0 AND a.state2 > 0 ORDER BY dist' ;

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 2, '412' ,concat('WARNING-412 (temp_anl_node): There is/are ',v_count,' Shortpipe nodarc(s) over other EPA nodes.'),v_count);

		EXECUTE 'INSERT INTO temp_anl_node (node_id, nodecat_id, state, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, the_geom, arc_distance, descript) SELECT * FROM ('||v_querytext||') a';

	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 1, '412','INFO: All shortpipe nodarcs are not on the same position than other EPA nodes.',v_count);
	END IF;

	RAISE NOTICE '30 - Check minlength less than 0.01 or more than node proximity (fid: 425)';
	IF (v_minlength < 0.01 OR v_minlength >= v_nodeproximity) THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity,  error_message, fcount)
		VALUES (v_fid, '425', 3, concat('ERROR-425: Minlength value (',v_minlength,') is bad configured (more than node proximity or less than 0.01)'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '425', 1, concat('INFO: Minlength value (',v_minlength,') is well configured.'), v_count);
	END IF;

	RAISE NOTICE '31 - Check EPA OBJECTS (curves and patterns have not spaces on names (fid: 429)';
	SELECT count(*) INTO v_count FROM inp_curve WHERE id like'% %';
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '429', 3, concat('ERROR-429: ',v_count,' curve(s) has/have name with spaces. Please fix it!'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '429', 1, concat('INFO: All curves checked have names without spaces.'),v_count);
	END IF;

	SELECT count(*) INTO v_count FROM inp_pattern WHERE pattern_id like'% %';
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '429', 3, concat('ERROR-429: ',v_count,' pattern(s) have name with spaces. Please fix it!'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '429' , 1, concat('INFO: All patterns checked have names without spaces.'),v_count);
	END IF;
	
	RAISE NOTICE '32 - Check nodes ''T candidate'' with wrong topology (fid: 432)';

	v_querytext = 'SELECT b.* FROM (SELECT n1.node_id, n1.sector_id, 432, ''Node ''''T candidate'''' with wrong topology'', n1.nodecat_id, n1.the_geom FROM v_edit_arc a, node n1 
					JOIN v_state_node USING (node_id) JOIN v_expl_node USING (node_id)
		      JOIN (SELECT node_1 node_id FROM arc WHERE state = 1 UNION SELECT node_2 FROM arc WHERE state = 1) b USING (node_id)
		      WHERE st_dwithin(a.the_geom, n1.the_geom,0.01) AND n1.node_id NOT IN (node_1, node_2))b, selector_sector s WHERE s.sector_id = b.sector_id AND cur_user=current_user';

	EXECUTE 'SELECT count(*) FROM ('||v_querytext||')a'
	INTO v_count;
	
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '429', 3, concat('ERROR-432 (temp_anl_node): There is/are ',v_count,' Node(s) ''T candidate'' with wrong topology'),v_count);

		EXECUTE 'INSERT INTO temp_anl_node (node_id, sector_id, fid, descript, nodecat_id, the_geom) '||v_querytext;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '429', 1, concat('INFO: All Nodes T has right topology.'),v_count);
	END IF;
	
	RAISE NOTICE '33 - Check matcat not null on arc (430)';
	SELECT count(*) INTO v_count FROM selector_sector s, v_edit_arc a JOIN cat_arc ON id = matcat_id 
	WHERE a.sector_id = s.sector_id and cur_user=current_user AND matcat_id IS NULL AND sys_type !='VARC';
	
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '427', 3, concat(
		'ERROR-430: There is/are ',v_count,' arcs without matcat_id informed.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '427', 1, 'INFO: All arcs have matcat_id filled.',v_count);
	END IF;	
	
	RAISE NOTICE '34 - Check duplicated connec on visible psectors';
	SELECT count(*) INTO v_count FROM (SELECT feature_id, count(*) from v_edit_link group by feature_id having count(*) > 1)a;


	IF v_count > 0 THEN
		INSERT INTO temp_anl_connec (connec_id, fid, the_geom) select feature_id, 480, connec.the_geom from v_edit_link 
		JOIN connec ON connec_id = feature_id group by feature_id, connec.the_geom having count(*) > 1;
		
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '480', 2, concat(
		'WARNING-480 (temp_anl_connec): There is/are ',v_count,' connecs more than once because related psectors are visible.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '480', 1, 'INFO: All connecs are unique on canvas because there are not psector inconsistencies.',v_count);
	END IF;	

	RAISE NOTICE '35 - Check percentage of arcs with custom_length values';
	WITH cust_len AS (SELECT count(*) FROM v_edit_arc WHERE custom_length IS NOT NULL), arcs AS (SELECT count(*) FROM v_edit_arc)
	SELECT cust_len.count::numeric / arcs.count::numeric *100 INTO v_count FROM arcs, cust_len;

	IF v_count > (SELECT json_extract_path_text(value::json,'customLength','maxPercent')::NUMERIC FROM config_param_system WHERE parameter = 'epa_outlayer_values') THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '482', 2, concat('WARNING-482: Over ',round(v_count::numeric,2),' percent of arcs have value on custom_length.'),round(v_count::numeric,2));
	ELSIF v_count=0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '482', 1, 'INFO: No arcs have value on custom_length.',round(v_count::numeric,2));
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (v_fid, '482', 1, concat('INFO: Less then ',round(v_count::numeric,2),' percent of arcs have value on custom_length.'),round(v_count::numeric,2));
	END IF;
	v_count=0;

	-- Removing isaudit false sys_fprocess
	FOR v_record IN SELECT * FROM sys_fprocess WHERE isaudit is false
	LOOP
		-- remove anl tables
		DELETE FROM temp_anl_node WHERE fid = v_record.fid AND cur_user = current_user;
		DELETE FROM temp_anl_arc WHERE fid = v_record.fid AND cur_user = current_user;
		DELETE FROM temp_anl_connec WHERE fid = v_record.fid AND cur_user = current_user;

		DELETE FROM temp_audit_check_data WHERE result_id::text = v_record.fid::text AND cur_user = current_user AND fid = v_fid;
	END LOOP;

	
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 3, '');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, '');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, ''); 

	IF v_fid = 225 THEN
		
		DELETE FROM anl_arc WHERE fid =225 AND cur_user=current_user;
		DELETE FROM anl_node WHERE fid =225 AND cur_user=current_user;
		DELETE FROM anl_connec WHERE fid =225 AND cur_user=current_user;
		DELETE FROM audit_check_data WHERE fid =225 AND cur_user=current_user;

		INSERT INTO anl_arc SELECT * FROM temp_anl_arc;
		INSERT INTO anl_node SELECT * FROM temp_anl_node;
		INSERT INTO anl_connec SELECT * FROM temp_anl_connec;
		INSERT INTO audit_check_data SELECT * FROM temp_audit_check_data;

	ELSIF  v_fid = 101 THEN 
		UPDATE temp_audit_check_data SET fid = 225;
		UPDATE temp_anl_arc SET fid = 225;
		UPDATE temp_anl_node SET fid = 225;
		UPDATE temp_anl_connec SET fid = 225;

		INSERT INTO project_temp_anl_arc SELECT * FROM temp_anl_arc;
		INSERT INTO project_temp_anl_node SELECT * FROM temp_anl_node;
		INSERT INTO project_temp_anl_connec SELECT * FROM temp_anl_connec;
		INSERT INTO project_temp_audit_check_data SELECT * FROM temp_audit_check_data;

	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (
	SELECT error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc
	) row; 
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
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, the_geom
	FROM temp_anl_node WHERE cur_user="current_user"() AND fid IN (107, 164, 165, 166, 167, 170, 171, 187, 198, 292, 293, 294, 379, 411, 412, 432)) row) features;
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point",  "features":',v_result, '}'); 

	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	SELECT jsonb_build_object(
	'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom, fid
	FROM  temp_anl_arc WHERE cur_user="current_user"() AND fid IN (188, 169, 229, 230, 295)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString",  "features":',v_result,'}'); 

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 

	--drop temporal tables
	DROP TABLE IF EXISTS temp_anl_arc;
	DROP TABLE IF EXISTS temp_anl_node ;
	DROP TABLE IF EXISTS temp_anl_connec;
	DROP TABLE IF EXISTS temp_audit_check_data;

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
			'}'||
		'}')::json, 2430, null, null, null);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  