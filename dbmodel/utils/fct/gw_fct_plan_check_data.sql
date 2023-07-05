/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2436


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_audit_check_data(integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_check_data(p_data json)  
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_plan_check_data($${}$$)

SELECT * FROM anl_arc WHERE fid=115 AND cur_user=current_user;
SELECT * FROM anl_node WHERE fid=115 AND cur_user=current_user;

-- fid: 115, 252,354,355,452, 467

*/

DECLARE 

v_record record;
v_project_type 	text;
v_table_count integer;
v_count integer;
v_global_count	integer;
v_return integer;
v_version text;	
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_saveondatabase boolean;
v_error_context text;
v_query text;
v_comment text;
v_querytext text;

BEGIN 

	-- init function
	SET search_path="SCHEMA_NAME", public;
	v_return:=0;
	v_global_count:=0;

	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data 	
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=115 AND cur_user=current_user;
	DELETE FROM anl_connec WHERE cur_user=current_user AND fid IN (252);
	DELETE FROM anl_arc WHERE cur_user=current_user AND fid IN (252,452);
	DELETE FROM anl_node WHERE cur_user=current_user AND fid IN (252, 354, 355,467);


	--create temp tables
	CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
	CREATE TEMP TABLE temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
	CREATE TEMP TABLE temp_anl_connec (LIKE SCHEMA_NAME.anl_connec INCLUDING ALL);
	CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

	-- Starting process
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 4, concat('DATA QUALITY ANALYSIS ACORDING PLAN-PRICE RULES'));
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 4, '-------------------------------------------------------------');

	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 3, 'CRITICAL ERRORS');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 3, '----------------------');

	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 2, 'WARNINGS');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 2, '--------------');

	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 1, 'INFO');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 1, '-------');

	--arc catalog
	SELECT count(*) INTO v_table_count FROM cat_arc WHERE active=TRUE;

	--check cat_arc active column (323)
	SELECT count(*) INTO v_count FROM cat_arc WHERE active IS NULL;
	IF v_count>0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled, error_message, fcount)
		VALUES (115, '323', 'cat_arc', 'active', 3, FALSE, concat('ERROR-323: There are ',v_count,' row(s) without values on cat_arc.active column.'), v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '323', 1,'INFO: There is/are no row(s) without values on cat_arc.active column.',v_count);
	END IF;

	--check cat_arc cost column (324)
	SELECT count(*) INTO v_count FROM cat_arc WHERE cost IS NOT NULL and active=TRUE;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '324', 'cat_arc', 'cost', 2, FALSE, concat('WARNING-324: There are ',(v_table_count-v_count),' row(s) without values on cat_arc.cost column.'), (v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '324', 1,'INFO: There is/are no row(s) without values on cat_arc.cost column.', v_count);
	END IF;

	--check cat_arc m2bottom_cost column (325)
	SELECT count(*) INTO v_count FROM cat_arc WHERE m2bottom_cost IS NOT NULL and active=TRUE;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '325', 'cat_arc', 'm2bottom_cost', 2, FALSE, concat('WARNING-325: There are ',(v_table_count-v_count),' row(s) without values on cat_arc.m2bottom_cost column.'),(v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '325', 1,'INFO: There is/are no row(s) without values on cat_arc.m2bottom_cost column.',v_count);
	END IF;

	--check cat_arc m3protec_cost column (326)
	SELECT count(*) INTO v_count FROM cat_arc WHERE m3protec_cost IS NOT NULL and active=TRUE;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '326', 'cat_arc', 'm3protec_cost', 2, FALSE, concat('WARNING-326: There are ',(v_table_count-v_count),' row(s) without values on cat_arc.m3protec_cost column.'), (v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '326', 1,'INFO: There is/are no row(s) without values on cat_arc.m3protec_cost column.',v_count);
	END IF;


	--check cat_arc estimated depth (437)
	SELECT count(*) INTO v_count FROM cat_arc WHERE estimated_depth IS NOT NULL and active=TRUE;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '437', 'cat_arc', 'estimated_depth', 2, FALSE, concat('WARNING-437: There are ',(v_table_count-v_count),' row(s) without values on cat_arc.estimated_depth column.'), (v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '437', 1,'INFO: There is/are no row(s) without values on cat_arc.estimated_depth column.',v_count);
	END IF;

	
	--node catalog
	SELECT count(*) INTO v_table_count FROM cat_node WHERE active=TRUE;

	--check cat_node active column (327)
	SELECT count(*) INTO v_count FROM cat_node WHERE active IS NULL;
	IF v_count>0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '327', 'cat_node', 'active', 3, FALSE, concat('ERROR-327: There are ',v_count,' row(s) without values on cat_node.active column.'), v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '327', 1,'INFO: There is/are no row(s) without values on cat_node.active column.',v_count);
	END IF;

	--check cat_node cost column (328)
	SELECT count(*) INTO v_count FROM cat_node WHERE cost IS NOT NULL and active=TRUE;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '328', 'cat_node', 'cost', 2, FALSE, concat('WARNING-328: There are ',(v_table_count-v_count),' row(s) without values on cat_node.cost column.'), (v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '328', 1,'INFO: There is/are no row(s) row(s) without values on cat_node.cost column.',v_count);
	END IF;

	--check cat_node cost_unit column (329)
	SELECT count(*) INTO v_count FROM cat_node WHERE cost_unit IS NOT NULL and active=TRUE;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '329', 'cat_node', 'cost_unit', 2, FALSE, concat('WARNING-329: There are ',(v_table_count-v_count),' row(s) without values on cat_node.cost_unit column.'), (v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '329', 1,'INFO: There is/are no row(s) without values on cat_node.cost_unit column.',v_count);
	END IF;
	
	
	IF v_project_type='WS' THEN 
	
		--check cat_node estimated_depth column (330)
		SELECT count(*) INTO v_count FROM cat_node WHERE estimated_depth IS NOT NULL and active=TRUE;
		IF v_table_count>v_count THEN
			INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
			VALUES (115, '330', 'cat_node', 'estimated_depth', 2, FALSE, concat('WARNING-330: There are ',(v_table_count-v_count),' row(s) without values on cat_node.estimated_depth column.'), (v_table_count-v_count));
		ELSE
			v_count = 0;
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (115, '330', 1,'INFO: There is/are no row(s) without values on cat_node.estimated_depth column.',v_count);
		END IF;

	ELSIF v_project_type='UD' THEN 
	
		 --check cat_node estimated_y column (331)
		SELECT count(*) INTO v_count FROM cat_node WHERE estimated_y IS NOT NULL and active=TRUE;
		IF v_table_count>v_count THEN
			INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
			VALUES (115, '331', 'cat_node', 'estimated_y', 2, FALSE, concat('WARNING-331: There are ',(v_table_count-v_count),' row(s) without values on cat_node.estimated_y column.'), (v_table_count-v_count));
		ELSE
			v_count = 0;
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (115, '331', 1,'INFO: There is/are no row(s) without values on cat_node.estimated_y column.',v_count);
		END IF;
	END IF;


	--connec catalog
	SELECT count(*) INTO v_table_count FROM cat_connec WHERE active=TRUE;

	--check cat_connec active column (332)
	SELECT count(*) INTO v_count FROM cat_connec WHERE active IS NULL;
	IF v_count>0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '332', 'cat_connec', 'active', 3, FALSE, concat('ERROR-332: There are ',v_count,' row(s) without values on cat_connec.active column.'), v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '332', 1,'INFO: There is/are no row(s) without values on cat_connec.active column column.',v_count);
	END IF;

	--pavement catalog
	SELECT count(*) INTO v_table_count FROM cat_pavement;

	--check cat_pavement thickness column (336)
	SELECT count(*) INTO v_count FROM cat_pavement WHERE thickness IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '336', 'cat_pavement', 'thickness', 2, FALSE, concat('WARNING-336: There are ',(v_table_count-v_count),' row(s) without values on cat_pavement.thickness column.'), (v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '336', 1,'INFO: There is/are no row(s) without values on cat_pavement.thickness column.',v_count);
	END IF;

	--check cat_pavement m2cost column (337)
	SELECT count(*) INTO v_count FROM cat_pavement WHERE m2_cost IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '337', 'cat_pavement', 'm2_cost', 2, FALSE, concat('WARNING-337: There are ',(v_table_count-v_count),' row(s) without values on cat_pavement.m2_cost column.'), (v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '337', 1,'INFO: There is/are no row(s) without values on cat_pavement.m2_cost column.',v_count);
	END IF;

	--soil catalog
	SELECT count(*) INTO v_table_count FROM cat_soil;

	--check cat_soil y_param column (338)
	SELECT count(*) INTO v_count FROM cat_soil WHERE y_param IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '338', 'cat_soil', 'y_param', 2, FALSE, concat('WARNING-338: There are ',(v_table_count-v_count),' row(s) without values on cat_soil.y_param column.'), v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '338', 1,'INFO: There is/are no row(s) without values on cat_soil.y_param column.',v_count);
	END IF;

	--check cat_soil b column (339)
	SELECT count(*) INTO v_count FROM cat_soil WHERE b IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '339', 'cat_soil', 'b', 2, FALSE, concat('WARNING-339: There are ',(v_table_count-v_count),' row(s) without values on cat_soil.b column.'), v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '339', 1,'INFO: There is/are no row(s) without values on cat_soil.b column.',v_count);
	END IF;

	--check cat_soil m3exc_cost column (340)
	SELECT count(*) INTO v_count FROM cat_soil WHERE m3exc_cost IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '340', 'cat_soil', 'm3exc_cost', 2, FALSE, concat('WARNING-340: There are ',(v_table_count-v_count),' row(s) without values on cat_soil.m3exc_cost column.'), v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '340', 1,'INFO: There is/are no row(s) without values on cat_soil.m3exc_cost column.',v_count);
	END IF;

	--check cat_soil m3fill_cost column (341)
	SELECT count(*) INTO v_count FROM cat_soil WHERE m3fill_cost IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '341', 'cat_soil', 'm3fill_cost', 2, FALSE, concat('WARNING-341: There are ',(v_table_count-v_count),' row(s) without values on cat_soil.m3fill_cost column.'), v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '341', 1,'INFO: There is/are no row(s) without values on cat_soil.m3fill_cost column.',v_count);
	END IF;

	--check cat_soil m3excess_cost column (342)
	SELECT count(*) INTO v_count FROM cat_soil WHERE m3excess_cost IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '342', 'cat_soil', 'm3excess_cost', 2, FALSE, concat('WARNING-342: There are ',(v_table_count-v_count),' row(s) without values on cat_soil.m3excess_cost column.'), v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '342', 1,'INFO: There is/are no row(s) without values on cat_soil.m3excess_cost column.',v_count);
	END IF;

	--check cat_soil m2trenchl_cost column (343)
	SELECT count(*) INTO v_count FROM cat_soil WHERE m2trenchl_cost IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '343', 'cat_soil', 'm2trenchl_cost', 2, FALSE, concat('WARNING-343: There are ',(v_table_count-v_count),' row(s) without values on cat_soil.m2trenchl_cost column.'), v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '343', 1,'INFO: There is/are no row(s) without values on cat_soil.m2trenchl_cost column.',v_count);
	END IF;

	IF v_project_type='UD' THEN

		--grate catalog
		SELECT count(*) INTO v_table_count FROM cat_grate WHERE active=TRUE;

		--check cat_grate active column (344)
		SELECT count(*) INTO v_count FROM cat_grate WHERE active IS NULL;
		IF v_count>0 THEN
			INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
			VALUES (115, '344', 'cat_grate', 'active', 3, FALSE, concat('ERROR-344: There are ',v_count,' row(s) without values on cat_grate.active column.'), v_count);
		ELSE
			v_count = 0;
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (115, '344', 1,'INFO: There is/are no row(s) without values on cat_grate.active column.',v_count);
		END IF;
	END IF;	

	--table plan_arc_x_pavement
	SELECT count(*) INTO v_table_count FROM arc WHERE state>0;

	--check plan_arc_x_pavement rows number (346)
	SELECT count(*) INTO v_count FROM plan_arc_x_pavement;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '346', 'plan_arc_x_pavement', 'rows number', 1, FALSE, 'INFO: The number of row(s) of the plan_arc_x_pavement table is lower than the arc table.', v_count);
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '346', 1,'INFO: The number of row(s) of the plan_arc_x_pavement table is same than the arc table.',v_count);
	END IF;

	--check plan_arc_x_pavemen pavcat_id column (347)
	SELECT count(*) INTO v_table_count FROM plan_arc_x_pavement;
	SELECT count(*) INTO v_count FROM plan_arc_x_pavement WHERE pavcat_id IS NOT NULL;
	IF v_table_count>v_count THEN
		INSERT INTO temp_audit_check_data (fid, result_id, table_id, column_id, criticity, enabled,  error_message, fcount)
		VALUES (115, '347', 'plan_arc_x_pavement', 'pavcat_id', 2, FALSE, concat('WARNING-347: There are ',(v_table_count-v_count),' row(s) without values on plan_arc_x_pavement.pavcat_id column.'),(v_table_count-v_count));
	ELSE
		v_count = 0;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '347', 1,'INFO: There is/are no row(s) without values on row(s) without values on plan_arc_x_pavement.pavcat_id column.',v_count);
	END IF;

	--check if features with state = 2 are related to any psector (252)
	IF v_project_type = 'WS' THEN
		v_query = 'SELECT a.feature_id, a.feature, a.catalog, a.the_geom, count(*) FROM (
		SELECT node_id as feature_id, ''NODE'' as feature, nodecat_id as catalog, the_geom FROM v_edit_node WHERE state=2 AND node_id NOT IN (select node_id FROM plan_psector_x_node) UNION
		SELECT arc_id as feature_id, ''ARC'' as feature, arccat_id as catalog, the_geom  FROM v_edit_arc WHERE state=2 AND arc_id NOT IN (select arc_id FROM plan_psector_x_arc) UNION
		SELECT connec_id as feature_id, ''CONNEC'' as feature, connecat_id  as catalog, the_geom  FROM v_edit_connec WHERE state=2 AND connec_id NOT IN (select connec_id FROM plan_psector_x_connec)) a 
		GROUP BY a.feature_id, a.feature , a.catalog, a.the_geom';

	ELSE	
		v_query = 'SELECT a.feature_id, a.feature , a.catalog, a.the_geom, count(*) FROM (
		SELECT node_id as feature_id, ''NODE'' as feature, nodecat_id as catalog, the_geom FROM v_edit_node WHERE state=2 AND node_id NOT IN (select node_id FROM plan_psector_x_node) UNION
		SELECT arc_id as feature_id, ''ARC'' as feature, arccat_id as catalog, the_geom  FROM v_edit_arc WHERE state=2 AND arc_id NOT IN (select arc_id FROM plan_psector_x_arc) UNION
		SELECT connec_id as feature_id, ''CONNEC'' as feature, connecat_id  as catalog, the_geom  FROM v_edit_connec WHERE state=2 AND connec_id NOT IN (select connec_id FROM plan_psector_x_connec) UNION
		SELECT gully_id as feature_id, ''GULLY'' as feature , gratecat_id as catalog, the_geom FROM v_edit_gully WHERE state=2 AND gully_id NOT IN (select gully_id FROM plan_psector_x_gully)) a 
		GROUP BY a.feature_id, a.feature ,a.catalog, a.the_geom';
	END IF;

		EXECUTE 'SELECT count(*) FROM ('||v_query||')b'
		INTO v_count; 

	IF v_count > 0 THEN
		EXECUTE 'SELECT count(*) FROM ('||v_query||')b WHERE feature = ''ARC'';'
		INTO v_count; 
		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO temp_anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
			SELECT 252, b.feature_id, b.catalog, ''Arcs state = 2 without psector'', b.the_geom, 2 FROM (', v_query,')b  WHERE feature = ''ARC''');
			INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (115, '252', 3, FALSE, concat('ERROR-252 (temp_anl_arc): There are ',v_count,' planified arcs without psector.'),v_count);
		END IF;
		EXECUTE 'SELECT count(*) FROM ('||v_query||')b WHERE feature = ''NODE'';'
		INTO v_count; 
		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO temp_anl_node (fid, node_id, nodecat_id, descript, the_geom, state)
			SELECT 252, b.feature_id, b.catalog, ''Nodes state = 2 without psector'', b.the_geom, 2 FROM (', v_query,')b  WHERE feature = ''NODE''');
			INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message,fcount)
			VALUES (115, '252', 3, FALSE, concat('ERROR-252 (temp_anl_node): There are ',v_count,' planified nodes without psector.'),v_count);		END IF;
		EXECUTE 'SELECT count(*) FROM ('||v_query||')b WHERE feature = ''CONNEC'';'
		INTO v_count; 
		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO temp_anl_connec (fid, connec_id, connecat_id, descript, the_geom,state)
			SELECT 252, b.feature_id, b.catalog, ''Connecs state = 2 without psector'', b.the_geom,2 FROM (', v_query,')b  WHERE feature = ''CONNEC''');
			INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message,fcount)
			VALUES (115, '252', 3, FALSE, concat('ERROR-252 (temp_anl_connec): There are ',v_count,' planified connecs without psector.'),v_count);		END IF;
		EXECUTE 'SELECT count(*) FROM ('||v_query||')b WHERE feature = ''GULLY'';'
		INTO v_count; 
		IF v_count > 0 THEN
			EXECUTE concat ('INSERT INTO temp_anl_connec (fid, gully_id, gullycat_id, descript, the_geom, state)
			SELECT 252, b.feature_id, b.catalog, ''Gullies state = 2 without psector'', b.the_geom, 2 FROM (', v_query,')b  WHERE feature = ''GULLY''');
			INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (115, '252', 3, FALSE, concat('ERROR-252 (temp_anl_connec): There are ',v_count,' planified gullys without psector.'),v_count);		END IF;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '252', 1,'INFO: There are no features with state=2 without psector.',v_count);
	END IF;
/*
	--check if arcs with state = 2 have final nodes state = 2 in the psector (354)
	v_query =  'SELECT * FROM
	(SELECT pa.arc_id, a.arccat_id, pa.psector_id , node_1 as node, a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id)
		JOIN v_edit_node n ON node_id = node_1 where n.state = 2 AND a.state=2
	EXCEPT
	SELECT pa.arc_id, a.arccat_id, pa.psector_id , node_1 as node, a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id)
		JOIN plan_psector_x_node pn1 ON pn1.node_id = a.node_1
		WHERE pa.psector_id = pn1.psector_id and pa.state = 1 AND pn1.state = 1)a
	UNION
	SELECT * FROM
	(SELECT pa.arc_id, a.arccat_id, pa.psector_id , node_2 as node,  a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id)
		JOIN v_edit_node n ON node_id = node_2 where n.state = 2 AND a.state=2
	EXCEPT
	SELECT pa.arc_id, a.arccat_id, pa.psector_id , node_2 as node,  a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc USING (arc_id)
		JOIN plan_psector_x_node pn2 ON pn2.node_id = arc.node_2
		WHERE pa.psector_id = pn2.psector_id AND pa.state = 1 AND pn2.state = 1)b';

	EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
	INTO v_count; 

	IF v_count > 0 THEN

		EXECUTE concat ('INSERT INTO temp_anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
		SELECT 354, c.arc_id, c.arccat_id, ''Arcs state = 2 without planned final nodes in psector'', c.the_geom, 2 FROM (', v_query,')c ');
		INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (115, '354', 3, FALSE, concat('ERROR-354 (temp_anl_arc): There are ',v_count,' planified arcs without final planned nodes defined in psector.'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '354', 1,'INFO: There are no arcs with state=2 with planned final nodes not defined psector.',v_count);
	END IF;
	
	SELECT pa.arc_id, pa.psector_id , node_1 as node FROM plan_psector_x_arc pa JOIN arc USING (arc_id)
		JOIN plan_psector_x_node pn1 ON pn1.node_id = arc.node_1
		WHERE pa.psector_id = pn1.psector_id AND pa.state = 1 AND pn1.state = 0 AND pa.psector_id 
		in (select psector_id from selector_psector where cur_user = 'jdelgado') AND arc.state_type<> 24
		UNION
		SELECT pa.arc_id, pa.psector_id, node_2 FROM plan_psector_x_arc pa JOIN arc USING (arc_id)
		JOIN plan_psector_x_node pn2 ON pn2.node_id = arc.node_2
		WHERE pa.psector_id = pn2.psector_id AND pa.state = 1 AND pn2.state = 0 AND pa.psector_id 
		in (select psector_id from selector_psector where cur_user = 'jdelgado')   AND arc.state_type<> 24
		
		*/

	--check if arcs with state = 2 have final nodes state = 1 or 2 enabled in psector (355)
	v_query =  'SELECT * FROM (
	SELECT pa.arc_id, a.arccat_id, pa.psector_id , node_1 as node, a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id)
	JOIN plan_psector_x_node pn1 ON pn1.node_id = a.node_1
	WHERE pa.psector_id = pn1.psector_id AND pa.state = 1 AND pn1.state = 0
	UNION
	SELECT pa.arc_id, a.arccat_id, pa.psector_id, node_2, a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id)
	JOIN plan_psector_x_node pn2 ON pn2.node_id = a.node_2
	WHERE pa.psector_id = pn2.psector_id AND pa.state = 1 AND pn2.state = 0) b';

	EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
	INTO v_count; 
	

	IF v_count > 0 THEN

		EXECUTE concat ('INSERT INTO temp_anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
		SELECT 355, c.arc_id, c.arccat_id, concat(''Arcs state = 2 final nodes obsolete in psector '',c.psector_id), c.the_geom, 2 FROM (', v_query,')c ');
		INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (115, '355', 3, FALSE, concat('ERROR-355 (temp_anl_arc): There are ',v_count,' planified arcs with final nodes defined as obsolete in psector.'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '355', 1,'INFO: There are no arcs with state=2 with final nodes obsolete in psector.',v_count);
	END IF;


	-- Check node_1 or node_2 nulls for planified features (452)
	v_querytext = '(SELECT arc_id,arccat_id,the_geom, expl_id FROM v_edit_arc WHERE state = 2 AND node_1 IS NULL 
	               UNION
 				   SELECT arc_id, arccat_id, the_geom, expl_id FROM v_edit_arc WHERE state = 2 AND node_2 IS NULL) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO temp_anl_arc (fid, arc_id, arccat_id, descript, the_geom, expl_id)
			SELECT 452, arc_id, arccat_id, ''node_1 or node_2 nulls'', the_geom, expl_id FROM ', v_querytext);
		INSERT INTO temp_audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (115, 2, '452', concat('WARNING-452 (temp_anl_arc): There is/are ',v_count,' arc''s with state=1 and without node_1 or node_2.'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, result_id,error_message, fcount)
		VALUES (115, 1, '452','INFO: No arc''s with state=1 and without node_1 or node_2 nodes found.', v_count);
	END IF;

	-- Planified umps with more than two arcs (467);
	IF v_project_type='WS' THEN 
		INSERT INTO temp_anl_node (fid, node_id, nodecat_id, the_geom, descript, expl_id)
		select 467, b.node_id, nodecat_id, the_geom, 'Planified EPA pump with more than two arcs', expl_id
		FROM(
		SELECT node_id, count(*) FROM(
		SELECT node_id FROM arc JOIN inp_pump ON node_1 = node_id 
		WHERE (arc.state=1 OR arc.state=2)
		UNION ALL
		SELECT node_id FROM arc JOIN inp_pump ON node_2 = node_id
		WHERE arc.state=1 OR arc.state=2 ) a
		JOIN node USING (node_id)
		WHERE node.state=2
		GROUP BY node_id
		HAVING count(*)>2)b
		JOIN node USING (node_id);
		
		SELECT count(*) FROM temp_anl_node INTO v_count WHERE fid=467 AND cur_user=current_user;
		IF v_count > 0 THEN
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (115, '467', 3, concat(
			'ERROR-467 (temp_anl_node): There is/are ',v_count,' pumps(s) with more than two arcs .Take a look on temporal table to details'),v_count);
			v_count=0;
		ELSE
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
			VALUES (115, '467' , 1,  'INFO: EPA pumps checked. No pumps with more than two arcs detected.',v_count);
		END IF;		
	END IF;

	--check if number of rows in plan_price
	EXECUTE 'SELECT count(*) FROM plan_price'
	INTO v_count; 

	IF v_count > 700 THEN
		INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (115, '465', 3, FALSE, concat('ERROR-465: There are ',v_count,' rows on plan_price table. Revise the data and remove unnecessary rows.'),v_count);
	ELSIF v_count > 300 THEN
		INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (115, '465', 2, FALSE, concat('WARNING-465: There are ',v_count,' rows on plan_price table. Revise the data and remove unnecessary rows.'),v_count);
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message, fcount)
		VALUES (115, '465', 1,'INFO: The number of rows on plan price is acceptable.',v_count);
	END IF;


	-- Removing isaudit false sys_fprocess
	FOR v_record IN SELECT * FROM sys_fprocess WHERE isaudit is false
	LOOP
		-- remove anl tables
		DELETE FROM temp_anl_node WHERE fid = v_record.fid AND cur_user = current_user;
		DELETE FROM temp_anl_arc WHERE fid = v_record.fid AND cur_user = current_user;
		DELETE FROM temp_anl_connec WHERE fid = v_record.fid AND cur_user = current_user;

		DELETE FROM temp_audit_check_data WHERE result_id::text = v_record.fid::text AND cur_user = current_user AND fid = 115;		
	END LOOP;

	-- insert spacers
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 4, '');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 3, '');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 2, '');
	INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (115, 1, '');

	INSERT INTO anl_arc SELECT * FROM temp_anl_arc;
	INSERT INTO anl_node SELECT * FROM temp_anl_node;
	INSERT INTO anl_connec SELECT * FROM temp_anl_connec;
	INSERT INTO audit_check_data SELECT * FROM temp_audit_check_data;

	DROP TABLE  IF EXISTS temp_anl_arc;
	DROP TABLE IF EXISTS temp_anl_node ;
	DROP TABLE IF EXISTS  temp_anl_connec;
	DROP TABLE  IF EXISTS temp_audit_check_data;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND 
	fid = 115 order by criticity desc, id asc) row;
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
	AND fid IN (252, 354, 355,467)
	UNION
	SELECT id, arc_id, arccat_id, state, expl_id, descript, fid, the_geom FROM anl_arc WHERE cur_user="current_user"()
	AND fid IN (252, 452)
	UNION
	SELECT id, connec_id, connecat_id, state, expl_id, descript,fid, the_geom FROM anl_connec WHERE cur_user="current_user"()
	AND fid IN (252)) row) features;

	v_result := COALESCE(v_result, '{}'); 

	IF v_result::text = '{}' THEN 
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
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid IN (252, 354, 355, 452)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 

		--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2436, null, null, null);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;

 	