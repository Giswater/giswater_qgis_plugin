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
SELECT gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":227}}}$$)-- when is called from go2epa_main
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data('{"parameters":{}}')-- when is called from toolbox or from checkproject

-- fid: main: 225
		other: 107,164,165,166,167,169,170,171,188,198,227,229,230,292,293,294,295

*/


DECLARE

v_record record;
v_project_type text;
v_count	integer;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_result_id text;
v_defaultdemand	float;
v_error_context text;
v_fid integer;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid'::text;
	
	-- select config values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version order by 1 desc limit 1 ;

	-- init variables
	v_count=0;
	IF v_fid is null THEN
		v_fid = 225;
	END IF;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 225 AND cur_user=current_user;
	DELETE FROM anl_node WHERE fid IN (107, 187, 164, 165, 166, 167, 169, 170, 171, 198, 292, 293, 294) AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid IN (188, 229, 230, 295) AND cur_user=current_user;
	

	-- Header
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 4, 'CHECK GIS DATA QUALITY ACORDING EPA ROLE');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 4, '----------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 1, '-------');


	RAISE NOTICE '1 - Check orphan nodes (fid:  107)';
	v_querytext = '(SELECT node_id, nodecat_id, the_geom FROM (SELECT node_id FROM v_edit_node EXCEPT 
			(SELECT node_1 as node_id FROM v_edit_arc UNION SELECT node_2 FROM v_edit_arc))a JOIN v_edit_node USING (node_id)
			JOIN selector_sector USING (sector_id) 
			JOIN value_state_type v ON state_type = v.id
			WHERE epa_type != ''NOT DEFINED'' and is_operative = true and cur_user = current_user ) b';		
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 107, node_id, nodecat_id, ''Orphan node'',
		the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 2, '107', concat('WARNING-107: ',v_count,' node''s orphans with epa_type and state_type ready to work, will not exported because any arcs are connected. Take a look on temporal for details.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id,  error_message, fcount)
		VALUES (v_fid, 1, '107', 'INFO: No node(s) orphan found.',v_count);
	END IF;

			
	RAISE NOTICE '2 - Check nodes with state_type isoperative = false (fid:  187)';
	v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM v_edit_node n JOIN selector_sector USING (sector_id) JOIN value_state_type ON value_state_type.id=state_type 
			WHERE n.state > 0 AND is_operative IS FALSE AND cur_user = current_user';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 187, node_id, nodecat_id, ''nodes
		with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 2, '187' ,concat('WARNING-187: There is/are ',v_count,' node(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue.'),v_count);
		INSERT INTO audit_check_data (fid, criticity, error_message, fcount)
		VALUES (v_fid, 2, concat('SELECT * FROM anl_node WHERE fid = 187 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
	VALUES (v_fid, 1, '187','INFO: No nodes with state > 0 AND state_type.is_operative on FALSE found.',v_count);
	END IF;
		
		
	RAISE NOTICE '3 - Check arcs with state_type isoperative = false (fid:  188)';
	v_querytext = 'SELECT arc_id, arccat_id, the_geom FROM v_edit_arc a JOIN selector_sector USING (sector_id) 
			JOIN value_state_type ON value_state_type.id=state_type WHERE a.state > 0 AND is_operative IS FALSE AND cur_user = current_user';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom) SELECT 188, arc_id, arccat_id, ''arcs with state_type
		isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 2, '188', concat('WARNING-188: There is/are ',v_count,' arc(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 1, '188','INFO: No arcs with state > 0 AND state_type.is_operative on FALSE found.',v_count);
	END IF;
	
	RAISE NOTICE '4 - Check state_type nulls (arc, node) (175)';
	v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM v_edit_arc JOIN selector_sector USING (sector_id) WHERE state_type IS NULL AND cur_user = current_user
			UNION 
			SELECT node_id, nodecat_id, the_geom FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE state_type IS NULL AND cur_user = current_user) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 3, '175',concat('ERROR-175: There is/are ',v_count,' topologic features (arc, node) with state_type with NULL values. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 1,'175', 'INFO: No topologic features (arc, node) with state_type NULL values found.',v_count);
	END IF;

	RAISE NOTICE '5 - Check for missed features on inp tables';
	v_querytext = '(SELECT arc_id, ''arc'' FROM arc LEFT JOIN 
			(SELECT arc_id from inp_pipe UNION SELECT arc_id FROM inp_virtualvalve) b using (arc_id)
			WHERE b.arc_id IS NULL AND state > 0 AND epa_type !=''NOT DEFINED''
			UNION 
		SELECT node_id, ''node'' FROM node LEFT JOIN 
			(select node_id from inp_shortpipe UNION select node_id from inp_valve 
			UNION select node_id from inp_tank 
			UNION select node_id FROM inp_reservoir UNION select node_id FROM inp_pump 
			UNION SELECT node_id from inp_inlet 
			UNION SELECT node_id from inp_junction) b USING (node_id)
			WHERE b.node_id IS NULL AND state >0 AND epa_type !=''NOT DEFINED'') a';


	EXECUTE concat('SELECT count(*) FROM (',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (v_fid, 3, '272',concat('ERROR-272: There is/are ',v_count,' missed features on inp tables. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (v_fid, 1, '272', 'INFO: No features missed on inp_tables found.',v_count);
	END IF;

	
	RAISE NOTICE '6 - Null elevation control (fid: 164)';
	SELECT count(*) INTO v_count FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE elevation IS NULL AND cur_user = current_user;
		
	IF v_count > 0 THEN
		INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom)
		SELECT 164, node_id, nodecat_id, the_geom FROM v_edit_node WHERE elevation IS NULL;
		INSERT INTO audit_check_data (fid, result_id, criticity,table_id,  error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '164',  concat('ERROR-164: There is/are ',v_count,' node(s) without elevation. Take a look on temporal table for details.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '164', 'INFO: No nodes with null values on field elevation have been found.',v_count);
	END IF;

	

	RAISE NOTICE '7 - Elevation control with cero values (fid: 165)';
	SELECT count(*) INTO v_count FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE elevation = 0 AND cur_user = current_user;

	IF v_count > 0 THEN
		INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
		SELECT 165, node_id, nodecat_id, the_geom, 'Elevation with zero' FROM v_edit_node WHERE elevation=0;
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '165', concat('WARNING-165: There is/are ',v_count,' node(s) with elevation=0. For more info you can type:'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '165','INFO: No nodes with ''0'' on field elevation have been found.',v_count);
	END IF;
	

	RAISE NOTICE '8 - Node2arcs with more than two arcs (fid: 166)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
	SELECT 166, a.node_id, a.nodecat_id, a.the_geom, 'Node2arc with more than two arcs' FROM (
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node
		JOIN selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user)
		UNION ALL
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node
		JOIN selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_2 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user))a
	GROUP by node_id, nodecat_id, the_geom
	HAVING count(*) >2;
	
	SELECT count(*) INTO v_count FROM anl_node WHERE fid = 166 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '166',concat('ERROR-166: There is/are ',v_count,' node2arcs with more than two arcs. It''s impossible to continue. For more info you can type:'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity,table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1,  '166','INFO: No results found looking for node2arc(s) with more than two arcs.',v_count);
	END IF;
	

	RAISE NOTICE '9 - Mandatory node2arcs with less than two arcs (fid: 167)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
	SELECT 167, a.node_id, a.nodecat_id, a.the_geom, 'Node2arc with less than two arcs' FROM (
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node
		JOIN selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user)
		UNION ALL
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node
		JOIN selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user))a
	GROUP by node_id, nodecat_id, the_geom
	HAVING count(*) < 2;


	SELECT count(*) INTO v_count FROM anl_node WHERE fid = 167 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '167', concat('WARNING-167: There is/are ',
		v_count,' node2arc(s) with less than two arcs. All of them have been transformed to nodarc using only arc joined. For more info you can type: '),v_count);
	ELSE 
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '167','INFO: No results found looking for node2arc(s) with less than two arcs.', v_count);
	END IF;

	
	RAISE NOTICE '10 - Check sense of cv pipes only to warning to user about the sense of the geometry (169)';
	INSERT INTO anl_arc (fid, arc_id, arccat_id, the_geom)
	SELECT 169, arc_id, arccat_id, the_geom FROM v_edit_inp_pipe WHERE status='CV';

	SELECT count(*) INTO v_count FROM anl_arc WHERE fid = 169 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '169',concat('WARNING-169: There is/are ',
		v_count,' CV pipes. Be carefull with the sense of pipe and check that node_1 and node_2 are on the right direction to prevent reverse flow.'),v_count);
	ELSE 
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '169','INFO: No results found for CV pipes',v_count);
	END IF;

	
	RAISE NOTICE '11 - Check to arc on valves, at least arc_id exists as closest arc (fid: 170)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
	select 170, node_id, nodecat_id, the_geom, 'To arc is null or does not exists as closest arc for valve' FROM v_edit_inp_valve WHERE node_id NOT IN(
		select node_id FROM v_edit_inp_valve JOIN v_edit_inp_pipe on arc_id=to_arc AND node_id=node_1
		union
		select node_id FROM v_edit_inp_valve JOIN v_edit_inp_pipe on arc_id=to_arc AND node_id=node_2);
	
	SELECT count(*) INTO v_count FROM anl_node WHERE fid = 170 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '170',concat('WARNING-170: There is/are ', v_count,' valve(s) without to_arc value according with the two closest arcs. Take a look on temporal table to know details.'),v_count);
	ELSE 
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '170',
		'INFO: to_arc values checked for valves. It exists and it''s one of  closest arcs.', v_count);
	END IF;


	RAISE NOTICE '12 - Valve_type (273)';
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE valv_type IS NULL;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '273', concat(
		'ERROR-273: There is/are ',v_count,' valve(s) with null values on valv_type column.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '273','INFO: Valve type checked. No mandatory values missed.',v_count);
	END IF;
	
	RAISE NOTICE '13 - Valve status & others (274)';					
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE status IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '274', concat(
		'ERROR-274: There is/are ',v_count,' valve(s) with null values at least on mandatory columns for valve (valv_type, status, to_arc).'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '274', 'INFO: Valve status checked. No mandatory values missed.',v_count);
	END IF;

	-- Valve pressure (275)';
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='PBV' OR valv_type='PRV' OR valv_type='PSV') AND (pressure IS NULL));
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '275',concat(
		'ERROR-275: There is/are ',v_count,' PBV-PRV-PSV valve(s) with null values at least on mandatory on the mandatory column for Pressure valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '275', 'INFO: PBC-PRV-PSV valves checked. No mandatory values missed.',v_count);
	END IF;				

	-- GPV valve check (276)';
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='GPV') AND (curve_id IS NULL));
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id,error_message, fcount)
		VALUES (v_fid, v_result_id, 3,'276', concat(
		'ERROR-276: There is/are ',v_count,' GPV valve(s) with null values at least on mandatory on the mandatory column for General purpose valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '276','INFO: GPV valves checked. No mandatory values missed.',v_count);
	END IF;	

	-- TCV valve check (277)';
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='TCV'));
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '277',concat('ERROR-277: There is/are ',v_count,' TCV valve(s) with null values at least on mandatory column for Losses Valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '277','INFO: TCV valves checked. No mandatory values missed.',v_count);
	END IF;				

	-- FCV valve check (278)';
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='FCV') AND (flow IS NULL));
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3,'278', concat('ERROR-278: There is/are ',v_count,' FCV valve(s) with null values at least on mandatory column for Flow Control Valves.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '278','INFO: FCV valves checked. No mandatory values missed.',v_count);
	END IF;		
	

	RAISE NOTICE '14 - Check to arc on pumps, at least arc_id exists as closest arc (fid: 171)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
	select 171, node_id, nodecat_id , the_geom,  'To arc is null or does not exists as closest arc for pump' FROM v_edit_inp_pump WHERE node_id NOT IN(
		select node_id FROM v_edit_inp_pump JOIN v_edit_inp_pipe on arc_id=to_arc AND node_id=node_1
		union
		select node_id FROM v_edit_inp_pump JOIN v_edit_inp_pipe on arc_id=to_arc AND node_id=node_2);
	
	SELECT count(*) INTO v_count FROM anl_node WHERE fid = 171 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id,error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '171', concat('WARNING-171: There is/are ', v_count,' pump(s) without to_arc value according with closest arcs. Take a look on temporal table to know details.'),v_count);
	ELSE 
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id,error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '171',
		'INFO: to_arc values checked for pumps. It exists and it''s one of the closest arcs.',v_count);
	END IF;
	
	
	RAISE NOTICE '15 - pumps. Pump type and others';	

	-- pump type(279)
	SELECT count(*) INTO v_count FROM v_edit_inp_pump WHERE pump_type IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '279', concat('ERROR-279: There is/are ',v_count,' pump''s with null values on pump_type column.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '279','INFO: Pumps checked. No mandatory values for pump_type missed.',v_count);
	END IF;
	
	--pump curve(280)
	SELECT count(*) INTO v_count FROM v_edit_inp_pump WHERE curve_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '280',concat(
		'ERROR-280: There is/are ',v_count,' pump(s) with null values at least on mandatory column curve_id.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1,'280', 'INFO: Pumps checked. No mandatory values for curve_id missed.',v_count);
	END IF;	


	--pump additional(281)
	SELECT count(*) INTO v_count FROM inp_pump_additional JOIN v_edit_inp_pump USING (node_id) WHERE inp_pump_additional.curve_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id,error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '281',concat(
		'ERROR-281: There is/are ',v_count,' additional pump(s) with null values at least on mandatory column curve_id.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1,'281', 'INFO: Additional pumps checked. No mandatory values for curve_id missed.',v_count);
	END IF;	
	
	
	RAISE NOTICE '16 - Check pipes with less than 0.2 mts (fid: 229)';
	SELECT count(*) INTO v_count FROM (SELECT st_length(the_geom) AS length FROM v_edit_inp_pipe) a WHERE length < 0.20;

	IF v_count > 0 THEN
		INSERT INTO anl_arc (fid, arc_id, arccat_id, the_geom, descript)
		SELECT 229, arc_id, arccat_id , the_geom, concat('Length: ', (st_length(the_geom))::numeric (12,3)) FROM v_edit_inp_pipe 
		WHERE st_length(the_geom) < 0.2;
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '229', concat('WARNING-229: There is/are ',v_count,
		' pipe(s) with length less than 0.2 meters. Check it before continue.'),v_count);
		v_count=0;
		
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '229', 'INFO: Standard minimun length checked. No values less than 0.2 meters missed.',v_count);
	END IF;
	
	
	RAISE NOTICE '17 - Check pipes with less than 0.05 mts (fid: 230)';
	SELECT count(*) INTO v_count FROM (SELECT st_length(the_geom) AS length FROM v_edit_inp_pipe) a WHERE length < 0.05;

	IF v_count > 0 THEN
		INSERT INTO anl_arc (fid, arc_id, arccat_id, the_geom, descript)
		SELECT 230, arc_id, arccat_id , the_geom, concat('Length: ', (st_length(the_geom))::numeric (12,3)) FROM v_edit_inp_pipe where st_length(the_geom) < 0.05;
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '230',concat('WARNING-230: There is/are ',v_count,
		' pipe(s) with length less than 0.05 meters. Check it before continue.'),v_count);
		v_count=0;
		
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity,table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '230', 'INFO: Crítical minimun length checked. No values less than 0.2 meters missed.',v_count);
	END IF;
	
	
	RAISE NOTICE '18 - Check roughness catalog for pipes (282)';
	SELECT count(*) INTO v_count FROM v_edit_inp_pipe JOIN cat_arc ON id = arccat_id JOIN cat_mat_roughness USING  (matcat_id)
	WHERE init_age IS NULL OR end_age IS NULL OR roughness IS NULL;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id,error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '282', concat('ERROR-282: There is/are ',v_count,
		' pipe(s) with null values for roughness. Check roughness catalog columns (init_age,end_age,roughness) before continue.'),v_count);
		v_count=0;
		
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '282', 'INFO: Roughness catalog checked. No mandatory values missed.',v_count);
	END IF;
	
	
	RAISE NOTICE '19 - Check dint value for catalogs';
	SELECT count(*) INTO v_count FROM cat_arc WHERE dint IS NULL AND arctype_id !='VARC';
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '283',concat(
		'ERROR-283: There is/are ',v_count,' register(s) on arc''s catalog not VARC with null values on dint column for the whole system.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '283', 'INFO: Dint for arc''s catalog checked. No values missed.',v_count);
	END IF;
	
	
	SELECT count(*) INTO v_count FROM cat_node WHERE dint IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '283',concat(
		'WARNING: There is/are ',v_count,' register(s) on node''s catalog without dint defined. If this registers acts as shortipe on the epanet exportation dint is needed.'), v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '283', 'INFO: Dint for node''s catalog checked. No values missed.',v_count);
	END IF;
	
		
	RAISE NOTICE '20 - tanks (fid: 198)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
	select 198, a.node_id, nodecat_id, the_geom, 'Tanks with null mandatory values' FROM v_edit_inp_tank a
	WHERE (initlevel IS NULL) OR (minlevel IS NULL) OR (maxlevel IS NULL) OR (diameter IS NULL) OR (minvol IS NULL);
	
	SELECT count(*) FROM anl_node INTO v_count WHERE fid=198 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '198',concat(
		'ERROR-198: There is/are ',v_count,' tank(s) with null values at least on mandatory columns for tank (initlevel, minlevel, maxlevel, diameter, minvol).Take a look on temporal table to details'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id , 1,  '198','INFO: Tanks checked. No mandatory values missed.',v_count);
	END IF;		

	RAISE NOTICE '21 - pumps with more than two arcs (292)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
	select 292, b.node_id, nodecat_id, the_geom, 'EPA pump with more than two arcs'
	FROM(
	SELECT node_id, count(*) FROM(
	SELECT node_id FROM arc JOIN v_edit_inp_pump ON node_1 = node_id 
	UNION ALL
	SELECT node_id FROM arc JOIN v_edit_inp_pump ON node_2 = node_id ) a
	JOIN node USING (node_id)
	GROUP BY node_id
	HAVING count(*)>2)b
	JOIN node USING (node_id);
	
	SELECT count(*) FROM anl_node INTO v_count WHERE fid=292 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
		VALUES (v_fid, v_result_id, 3, '292',concat(
		'ERROR-292: There is/are ',v_count,' pumps(s) with more than two arcs .Take a look on temporal table to details'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
		VALUES (v_fid, v_result_id , 1,  '292','INFO: EPA pumps checked. No pumps with more than two arcs detected.');
	END IF;		


	RAISE NOTICE '22 - valves with more than two arcs (293)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
	select 293, b.node_id, nodecat_id, the_geom, 'EPA valve with more than two arcs'
	FROM(
	SELECT node_id, count(*) FROM(
	SELECT node_id FROM arc JOIN v_edit_inp_valve ON node_1 = node_id 
	UNION ALL
	SELECT node_id FROM arc JOIN v_edit_inp_valve ON node_2 = node_id ) a
	GROUP BY node_id
	HAVING count(*)>2)b
	JOIN node USING (node_id);
	
	SELECT count(*) FROM anl_node INTO v_count WHERE fid=293 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
		VALUES (v_fid, v_result_id, 3, '293',concat(
		'ERROR-293: There is/are ',v_count,' valve(s) with more than two arcs .Take a look on temporal table to details'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
		VALUES (v_fid, v_result_id , 1,  '293','INFO: EPA valves checked. No valves with more than two arcs detected.');
	END IF;	

	
    RAISE NOTICE '23 - Inconsistency on inp node tables (294)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
		SELECT 294, n.node_id, n.nodecat_id, concat(epa_type, ' using inp_junction table') AS epa_table, n.the_geom FROM v_edit_inp_junction JOIN node n USING (node_id) WHERE epa_type !='JUNCTION'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_tank table') AS epa_table, n.the_geom FROM v_edit_inp_tank JOIN node n USING (node_id) WHERE epa_type !='TANK'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_reservoir table') AS epa_table, n.the_geom FROM v_edit_inp_reservoir JOIN node n USING (node_id) WHERE epa_type !='RESERVOIR'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_valve table') AS epa_table, n.the_geom FROM v_edit_inp_valve JOIN node n USING (node_id) WHERE epa_type !='VALVE'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_pump table') AS epa_table, n.the_geom FROM v_edit_inp_pump JOIN node n USING (node_id) WHERE epa_type !='PUMP'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_shortpipe table') AS epa_table, n.the_geom FROM v_edit_inp_shortpipe JOIN node n USING (node_id) WHERE epa_type !='SHORTPIPE';

		
	SELECT count(*) FROM anl_node INTO v_count WHERE fid=294 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
		VALUES (v_fid, v_result_id, 3, '294',concat(
		'ERROR-294: There is/are ',v_count,' node features with epa_type not according with epa table. Check your data before continue'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
		VALUES (v_fid, v_result_id , 1,  '294','INFO: Epa type for node features checked. No inconsistencies aganints epa table found.');
	END IF;	

	RAISE NOTICE '24 - Inconsistency on inp arc tables (295)';
	INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
		SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, ' using inp_pipe table') AS epa_table, a.the_geom FROM v_edit_inp_virtualvalve JOIN arc a USING (arc_id) WHERE epa_type !='VIRTUAL'
		UNION
		SELECT 295, a.arc_id, a.arccat_id,  concat(epa_type, ' using inp_virtualvalve table') AS epa_table, a.the_geom FROM v_edit_inp_pipe JOIN arc a USING (arc_id) WHERE epa_type !='PIPE';

		
	SELECT count(*) FROM anl_node INTO v_count WHERE fid=295 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
		VALUES (v_fid, v_result_id, 3, '295',concat(
		'ERROR-295: There is/are ',v_count,' arc features with epa_type not according with epa table. Check your data before continue'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
		VALUES (v_fid, v_result_id , 1,  '295','INFO: Epa type for arc features checked. No inconsistencies aganints epa table found.');
	END IF;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 1, '');
	
	IF v_result_id IS NULL THEN
		UPDATE audit_check_data SET result_id = table_id WHERE cur_user="current_user"() AND fid=v_fid AND result_id IS NULL;
		UPDATE audit_check_data SET table_id = NULL WHERE cur_user="current_user"() AND fid=v_fid; 
	END IF;
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (
	SELECT error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc
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
	FROM  anl_node WHERE cur_user="current_user"() AND fid IN (107, 164, 165, 166, 167, 170, 171, 187, 198, 292, 293, 294)) row) features;

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
	FROM  anl_arc WHERE cur_user="current_user"() AND fid IN (188, 229, 230, 295)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString",  "features":',v_result,'}'); 

	--polygons
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	SELECT jsonb_build_object(
	'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT id, pol_id, pol_type, state, expl_id, descript, the_geom
	FROM  anl_polygon WHERE cur_user="current_user"() AND fid =14) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
			'}'||
		'}')::json, 2430);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;