/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE:2431

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_check_data(text);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_epa_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_data(p_data json)
 RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":127}}}$$)-- when is called from go2epa_main
SELECT gw_fct_pg2epa_check_data($${"parameters":{}}$$)-- when is called from toolbox or from checkproject

-- fid: main: 225,
	other: 188,107,111,113,187,294,295

SELECT * FROM audit_check_data WHERE fid = 225

*/

DECLARE
v_record record;
v_project_type text;
v_count	integer;
v_count_2 integer;
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
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';

	-- select config values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version order by 1 desc limit 1 ;

	-- init variables
	v_count=0;
	IF v_fid is null THEN
		v_fid = 225;
	END IF;	

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=225 AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid IN (188, 295) AND cur_user=current_user;
	DELETE FROM anl_node WHERE fid IN (107, 111, 113, 187, 294) AND cur_user=current_user;

	-- Header
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 4, concat('DATA QUALITY ANALYSIS ACORDING EPA RULES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (225, v_result_id, 4, '-----------------------------------------------------------');

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
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '107',concat('ERROR-107: There is/are ',v_count,' node''s orphan. Take a look on temporal for details.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1,'107', 'INFO: No node(s) orphan found.',v_count);
	END IF;


	RAISE NOTICE '2 - Check nodes with state_type isoperative = false (fid:  187)';
	v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM v_edit_node n JOIN selector_sector USING (sector_id) JOIN value_state_type ON value_state_type.id=state_type 
	WHERE n.state > 0 AND is_operative IS FALSE AND cur_user = current_user';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom) SELECT 187, node_id, nodecat_id, ''nodes
		with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid, result_id,  criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '187', concat('WARNING-187: There is/are ',v_count,' node(s) with state > 0 and state_type.is_operative on FALSE. Please, check your
		data before continue. ()'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '187', 'INFO: No nodes with state > 0 AND state_type.is_operative on FALSE found.',v_count);
	END IF;
		
	RAISE NOTICE '3 - Check arcs with state_type isoperative = false (fid:  188)';
	v_querytext = 'SELECT arc_id, arccat_id, the_geom FROM v_edit_arc a JOIN selector_sector USING (sector_id) JOIN value_state_type ON value_state_type.id=state_type WHERE a.state > 0 
	AND is_operative IS FALSE AND cur_user = current_user';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom) SELECT 188, arc_id, arccat_id, ''arcs with state_type
		isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '188', concat('WARNING-188: There is/are ',v_count,' arc(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before
		continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '188', 'INFO: No arcs with state > 0 AND state_type.is_operative on FALSE found.',v_count);
	END IF;
	
	
	RAISE NOTICE '4 - Check state_type nulls (arc, node) (175)';
	v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM v_edit_arc JOIN selector_sector USING (sector_id) WHERE state_type IS NULL AND cur_user = current_user
			UNION 
			SELECT node_id, nodecat_id, the_geom FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE state_type IS NULL AND cur_user = current_user) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '175',concat('ERROR-175: There is/are ',v_count,' topologic features (arc, node) with state_type with NULL values. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '175','INFO: No topologic features (arc, node) with state_type NULL values found.',v_count);
	END IF;
	
	
	RAISE NOTICE '5- Check for missed features on inp tables';
		v_querytext = '(SELECT arc_id, ''arc'' as feature_tpe FROM arc JOIN
				(select arc_id from inp_conduit UNION select arc_id from inp_virtual UNION select arc_id from inp_weir UNION select arc_id from inp_pump UNION select arc_id from inp_outlet UNION select arc_id from inp_orifice) a
				USING (arc_id) 
				WHERE state > 0 AND epa_type !=''NOT DEFINED'' AND a.arc_id IS NULL
				UNION
				SELECT node_id, ''node'' FROM node JOIN
				(select node_id from inp_junction UNION select node_id from inp_storage UNION select node_id from inp_outfall UNION select node_id from inp_divider) a
				USING (node_id) 
				WHERE state > 0 AND epa_type !=''NOT DEFINED'' AND a.node_id IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id,  criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '272', concat('ERROR-272: There is/are ',v_count,' missed features on inp tables. Please, check your data before continue'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '272', 'INFO: No features missed on inp_tables found.',v_count);
	END IF;

	RAISE NOTICE '6- Nodes sink (113)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
	
	SELECT 113, node_id, nodecat_id, v_edit_node.the_geom, 'Node sink' FROM v_edit_node WHERE node_id IN

	-- those nodes as node_1 on arc no pump with negative slope except arcs with this node as node_1 and positive slope
	(SELECT node_1 FROM (SELECT arc_id, node_1, node_2 FROM v_edit_arc JOIN cat_arc c ON c.id = arccat_id 
	JOIN selector_sector USING (sector_id) JOIN cat_arc_shape s ON c.shape = s.id WHERE slope < 0 AND s.epa != 'FORCE_MAIN')a
	EXCEPT 
	SELECT node_1 FROM (SELECT arc_id, node_1, node_2 FROM v_edit_arc JOIN cat_arc c ON c.id = arccat_id 
	JOIN selector_sector USING (sector_id) JOIN cat_arc_shape s ON c.shape = s.id WHERE slope > 0)a);
	
	SELECT count(*) into v_count FROM anl_node WHERE fid=113 AND cur_user=current_user;
	
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '113', concat('WARNING-113: There is/are ',v_count,
		' junction(s) type sink which means that junction only have entry arcs without any exit arc (FORCE_MAIN is not valid).'),v_count);

		-- check nodes sink automaticly swiched to outfall (fuction gw_fct_anl_node_sink have been called on pg2epa_fill_data function)
		SELECT count(*) into v_count_2 FROM anl_node JOIN inp_junction USING (node_id) 
		WHERE outfallparam IS NOT NULL AND fid=113 AND cur_user=current_user;
		
		IF v_count_2 > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id, 2, '113', concat('WARNING-113:  ',v_count_2,' from ',v_count,
			' junction(s) type sink has/have outfallparam field defined and has/have been switched to OUTFALL using defined parameters.'),v_count);
		END IF;
		v_count=0;
		v_count_2=0;
	ELSE 
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '113', 
		concat('INFO: Any junction have been swiched on the fly to OUTFALL. Only junctions node sink with outfallparam values will be transformed on the fly to OUTFALL.', 0),v_count);
	END IF;
	
	RAISE NOTICE '107- Node exit upper intro (111)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, sector_id, the_geom, descript)
	SELECT 111, node_id, nodecat_id, sector_id, a.the_geom, concat('Node exit upper intro with: Max. entry: ', max_entry , ', Max. exit:',max_exit) 
	FROM ( SELECT node_id, max(sys_elev1) AS max_exit, nodecat_id, node.sector_id, node.the_geom FROM v_edit_arc JOIN node ON node_1 = node_id JOIN cat_feature_node ON node_type = id
	WHERE isexitupperintro = 0 GROUP BY node_id, node.sector_id )a
	JOIN ( SELECT node_id, max(sys_elev2) AS max_entry FROM v_edit_arc JOIN node ON node_2 = node_id JOIN cat_feature_node ON node_type = id WHERE isexitupperintro = 0 GROUP BY node_id )b USING (node_id)
	JOIN selector_sector USING (sector_id) 
	WHERE max_entry < max_exit AND cur_user = current_user;

	SELECT count(*) into v_count FROM anl_node WHERE fid=111 AND cur_user=current_user;
	
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 2, '111', concat('WARNING-111: There is/are ',v_count,' junction(s) with exits upper intro'),v_count);
	ELSE 
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '111', concat('INFO: Any junction have been detected with exits upper intro.'),v_count);
	END IF;


	RAISE NOTICE '8 - Null elevation control (fid: 164)';
	SELECT count(*) INTO v_count FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE sys_elev IS NULL AND cur_user = current_user;
	
	IF v_count > 0 THEN
		INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom)
		SELECT 164, node_id, nodecat_id, the_geom FROM v_edit_node WHERE top_elev IS NULL;
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '164', concat('ERROR-164: There is/are ',v_count,' node(s) without elevation. Take a look on temporal table for details.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '164', 'INFO: No nodes with null values on field elevation have been found.',v_count);
	END IF;
	--arcs without elevation (284)
	SELECT count(*) INTO v_count FROM v_edit_arc JOIN selector_sector USING (sector_id) WHERE cur_user = current_user AND sys_elev1 = NULL OR sys_elev2 = NULL;
	IF v_count > 0 THEN
		INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom)
		SELECT 64, node_id, nodecat_id, the_geom FROM v_edit_node WHERE result_id=v_result_id AND elevation IS NULL;
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '284', concat('ERROR-284: There is/are ',v_count,' arc(s) without elevation. Take a look on temporal table for details.'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '284', 'INFO: No arcs with null values on field elevation have been found.',v_count);
	END IF;

		
	RAISE NOTICE '9- Raingage data (285)';
	SELECT count(*) INTO v_count FROM v_edit_raingage where (form_type is null) OR (intvl is null) OR (rgage_type is null);
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '285', concat('ERROR-285: There is/are ',v_count,
		' raingage(s) with null values at least on mandatory columns for rain type (form_type, intvl, rgage_type).'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '285', concat('INFO: All mandatory colums for raingage (form_type, intvl, rgage_type) have been checked without any values missed.'),v_count);
	END IF;		
	
	SELECT count(*) INTO v_count FROM v_edit_raingage where rgage_type='TIMESERIES' AND timser_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '286', concat('ERROR-286: There is/are ',v_count,' raingage(s) with null values on the mandatory column for ''TIMESERIES'' raingage type.'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '286', concat('INFO: All mandatory colums for ''TIMESERIES'' raingage type have been checked without any values missed.'),v_count);
	END IF;		

	SELECT count(*) INTO v_count FROM v_edit_raingage where rgage_type='FILE' AND (fname IS NULL or sta IS NULL or units IS NULL);
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '287', concat('ERROR-287: There is/are ',v_count,
		' raingage(s) with null values at least on mandatory columns for ''FILE'' raingage type (fname, sta, units).'),v_count);
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '287', concat('INFO: All mandatory colums (fname, sta, units) for ''FILE'' raingage type have been checked without any values missed.'),v_count);
	END IF;	

	RAISE NOTICE '10 - Inconsistency on inp node tables (294)';
	INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom)
		SELECT 294, n.node_id, n.nodecat_id, concat(epa_type, ' using inp_junction table') AS epa_table, n.the_geom FROM v_edit_inp_junction JOIN node n USING (node_id) WHERE epa_type !='JUNCTION'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_storage table') AS epa_table, n.the_geom FROM v_edit_inp_storage JOIN node n USING (node_id) WHERE epa_type !='STORAGE'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_outfall table') AS epa_table, n.the_geom FROM v_edit_inp_outfall JOIN node n USING (node_id) WHERE epa_type !='OUTFALL'
		UNION
		SELECT 294, n.node_id, n.nodecat_id,  concat(epa_type, ' using inp_divider table') AS epa_table, n.the_geom FROM v_edit_inp_divider JOIN node n USING (node_id) WHERE epa_type !='DIVIDER';

		
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

	RAISE NOTICE '11 - Inconsistency on inp arc tables (295)';
	INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom)
		SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, ' using inp_pump table') AS epa_table, a.the_geom FROM v_edit_inp_pump JOIN arc a USING (arc_id) WHERE epa_type !='PUMP'
		UNION
		SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, ' using inp_conduit table') AS epa_table, a.the_geom FROM v_edit_inp_conduit JOIN arc a USING (arc_id) WHERE epa_type !='CONDUIT'
		UNION
		SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, ' using inp_outlet table') AS epa_table, a.the_geom FROM v_edit_inp_outlet JOIN arc a USING (arc_id) WHERE epa_type !='OUTLET'
		UNION
		SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, ' using inp_orifice table') AS epa_table, a.the_geom FROM v_edit_inp_orifice JOIN arc a USING (arc_id) WHERE epa_type !='ORIFICE'
		UNION
		SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, ' using inp_weir table') AS epa_table, a.the_geom FROM v_edit_inp_weir JOIN arc a USING (arc_id) WHERE epa_type !='WEIR'
		UNION
		SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, ' using inp_virtual table') AS epa_table, a.the_geom FROM v_edit_inp_virtual JOIN arc a USING (arc_id) WHERE epa_type !='VIRTUAL';

		
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

	
	-- insert spacers for log
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
	FROM (SELECT error_message as message FROM audit_check_data WHERE cur_user="current_user"() 
	AND fid=v_fid order by criticity desc, id asc) row;
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
	FROM  anl_node WHERE cur_user="current_user"() AND fid IN (107, 111, 113, 187, 294)) row) features;

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
	FROM  anl_arc WHERE cur_user="current_user"() AND fid IN (188, 295)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

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
				'"polygon":'||v_result_polygon||
				'}'||
			'}'||
		'}')::json, 2431);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;