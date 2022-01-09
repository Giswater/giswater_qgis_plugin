/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2848

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_result(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"gw_check_project","fid":227}}}$$) --when is called from go2epa_main from toolbox
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"test_20201016"}}}$$) -- when is called from toolbox

-- fid: 114, 159, 230, 297, 396, 404, 400, 405, 413, 414, 415, 432. Number 227 is passed by input parameters

*/

DECLARE

i integer = 0;
v_fid integer;
v_record record;
v_project_type text;
v_count	integer;
v_count_2 integer;
v_min_node2arc float;
v_saveondatabase boolean;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_nodearc_real float;
v_nodearc_user float;
v_result_id text;
v_min numeric (12,4);
v_max numeric (12,4);
v_headloss text;
v_patternmethod integer;
v_period text;
v_networkmode integer;
v_valvemode integer;
v_patternmethodval text;
v_periodval text;
v_valvemodeval text;
v_networkmodeval text;
v_hydrologyscenario text;
v_qualitymode text;
v_qualmodeval text;
v_buildupmode int2;
v_buildmodeval text;
v_usenetworkgeom boolean;
v_usenetworkdemand boolean;
v_defaultdemand	float;
v_doublen2a integer;
v_curvedefault text;
v_options json;
v_error_context text;

v_default boolean;
v_defaultval text;
v_debug boolean;
v_debugval text;
v_advanced boolean;
v_advancedval text;

v_values text;
v_checkresult boolean;
v_count2 integer;
v_periodtype integer;
object_rec record;
v_graphiclog boolean;
v_outlayer_elevation json;
v_minlength float;


BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';

	-- select system values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT value::json->>'elevation' INTO v_outlayer_elevation FROM config_param_system WHERE parameter = 'epa_outlayer_values';
	v_minlength := (SELECT value FROM config_param_system WHERE parameter = 'epa_arc_minlength');
	
	-- get user values
	v_checkresult = (SELECT value::json->>'checkResult' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_graphiclog = (SELECT (value::json->>'graphicLog') FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;

	-- manage no found results
	IF (SELECT result_id FROM rpt_cat_result WHERE result_id=v_result_id) IS NULL THEN
		v_result  = (SELECT array_to_json(array_agg(row_to_json(row))) FROM (SELECT 1::integer as id, 'No result found whith this name....' as  message)row);
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
		RETURN ('{"status":"Accepted", "message":{"level":1, "text":"No result found"}, "version":"'||v_version||'"'||
			',"body":{"form":{}, "data":{"info":'||v_result_info||'}}}')::json;		
	END IF; 
			
	-- init variables
	v_count=0;
	IF v_fid is null THEN
		v_fid = 114;
	END IF;
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 114 AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE id < 0;
	DELETE FROM anl_node WHERE fid IN (159, 297, 413, 415) AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid IN (297) AND cur_user=current_user;

	-- get user parameters
	SELECT row_to_json(row) FROM (SELECT inp_options_interval_from, inp_options_interval_to
			FROM crosstab('SELECT cur_user, parameter, value
			FROM config_param_user WHERE parameter IN (''inp_options_interval_from'',''inp_options_interval_to'') 
			AND cur_user = current_user'::text) as ct(cur_user varchar(50), inp_options_interval_from text, inp_options_interval_to text))row
	INTO v_options;		
			
	SELECT  count(*) INTO v_doublen2a FROM v_edit_inp_pump 	WHERE pump_type = 'PRESSPUMP';
	
	SELECT value INTO v_patternmethod FROM config_param_user WHERE parameter = 'inp_options_patternmethod' AND cur_user=current_user;
	SELECT value INTO v_valvemode FROM config_param_user WHERE parameter = 'inp_options_valve_mode' AND cur_user=current_user;
	SELECT value INTO v_networkmode FROM config_param_user WHERE parameter = 'inp_options_networkmode' AND cur_user=current_user;
	SELECT value INTO v_qualitymode FROM config_param_user WHERE parameter = 'inp_options_quality_mode' AND cur_user=current_user;
	SELECT value INTO v_buildupmode FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' AND cur_user=current_user;
	
	SELECT idval INTO v_valvemodeval FROM inp_typevalue WHERE id=v_valvemode::text AND typevalue ='inp_value_opti_valvemode';
	SELECT idval INTO v_patternmethodval FROM inp_typevalue WHERE id=v_patternmethod::text AND typevalue ='inp_value_patternmethod';
	SELECT idval INTO v_networkmodeval FROM inp_typevalue WHERE id=v_networkmode::text AND typevalue ='inp_options_networkmode';
	SELECT idval INTO v_qualmodeval FROM inp_typevalue WHERE id=v_qualitymode::text AND typevalue ='inp_value_opti_qual';
	SELECT idval INTO v_buildmodeval FROM inp_typevalue WHERE id=v_buildupmode::text AND typevalue ='inp_options_buildup_mode';

	-- get buildup mode parameters
	IF v_buildupmode = 1 THEN
		v_values = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user);
	ELSIF v_buildupmode = 2 THEN
		v_values = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_transport' AND cur_user=current_user);
	END IF;

	-- get settings values
	v_default = (SELECT value::json->>'status' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user=current_user);
	v_defaultval = (SELECT value::json->>'parameters' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user=current_user);
	
	v_advanced = (SELECT value::json->>'status' FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user);
	v_advancedval = (SELECT value::json->>'parameters' FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user);

	v_debug = (SELECT value::json->>'showLog' FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);
	v_debugval = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);

	-- Header
	INSERT INTO audit_check_data (id, fid, result_id, criticity, error_message)
	VALUES (-10, v_fid, v_result_id, 4, concat('CHECK RESULT WITH CURRENT USER-OPTIONS ACORDING EPA RULES'));
	INSERT INTO audit_check_data (id, fid, result_id, criticity, error_message)
	VALUES (-9, v_fid, v_result_id, 4, '-------------------------------------------------------------------------------------');

	INSERT INTO audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-8, v_fid, v_result_id, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-7, v_fid, v_result_id, 3, '----------------------');

	INSERT INTO audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-6, v_fid, v_result_id, 2, 'WARNINGS');
	INSERT INTO audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-5, v_fid, v_result_id, 2, '--------------');

	INSERT INTO audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-4, v_fid, v_result_id, 1, 'INFO');
	INSERT INTO audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-3, v_fid, v_result_id, 1, '-------');
		
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Result id: ', v_result_id));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Created by: ', current_user, ', on ', to_char(now(),'YYYY/MM/DD - HH:MM:SS')));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Network export mode: ', v_networkmodeval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Pattern method: ', v_patternmethodval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Valve mode: ', v_valvemodeval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Quality mode: ', v_qualmodeval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Number of Presspump (Double-n2a): ', v_doublen2a));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Buildup mode: ', v_buildmodeval, '. Parameters:', v_values));

	UPDATE rpt_cat_result SET 
	export_options = concat('{"Network export mode": "', v_networkmodeval,'", "Pattern method": "', v_patternmethodval, '"}')::json
	WHERE result_id = v_result_id;

	IF v_checkresult THEN
	
		IF v_default::boolean THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Default values: ', v_defaultval));
		ELSE 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Default values: No default values used'));
		END IF;

		IF v_advanced::boolean THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Advanced settings: ', v_advancedval));
		ELSE 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Advanced settings: No advanced settings used'));
		END IF;

		IF v_debug::boolean THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Debug: ', v_defaultval));
		END IF;

		RAISE NOTICE '1 - Check pumps with 3-point curves (because of bug of EPANET this kind of curves are forbidden on the exportation)';
		SELECT count(*) INTO v_count FROM (select curve_id, count(*) as ct from (select * from inp_curve_value join (select distinct curve_id FROM v_edit_inp_pump)a using (curve_id)) b group by curve_id having count(*)=3)c;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-172: There is/are ',v_count,' pump(s) with a curve defined by 3 points. Please check your data before continue because a bug of EPANET with 3-point curves, it will not work.'));
		ELSE 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, 'INFO: Pumps with 3-point curves checked. No results found. Due a EPANET''s bug with 3-point curves, it is forbidden to export curves like this because newer it will work on EPANET.');
		END IF;

		
		RAISE NOTICE '2 - Check nod2arc length control';	
		v_nodearc_real = (SELECT st_length (the_geom) FROM temp_arc WHERE  arc_type='NODE2ARC' AND result_id =  v_result_id LIMIT 1);
		v_nodearc_user = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_nodarc_length' AND cur_user=current_user);

		IF  v_nodearc_user > (v_nodearc_real+0.01) THEN 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('WARNING-375: The node2arc parameter have been modified from ',
			v_nodearc_user::numeric(12,3), ' to ', v_nodearc_real::numeric(12,3), ' in order to prevent length conflicts.'));
		ELSE 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: The node2arc parameter is ok for the whole analysis. Current value is ', v_nodearc_user::numeric(12,3)));
		END IF;


		RAISE NOTICE '3 - Check roughness inconsistency in function of headloss formula used';
		v_min = (SELECT min(roughness) FROM cat_mat_roughness);
		v_max = (SELECT max(roughness) FROM cat_mat_roughness);
		v_headloss = (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter='inp_options_headloss.');
			
		IF v_headloss = 'D-W' AND (v_min < 0.0025 AND v_max > 0.15) THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat(
				'WARNING-377: There is/are at least one value of roughnesss out of range using headloss formula D-W (0.0025-0.15) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
			
		ELSIF v_headloss = 'H-W' AND (v_min < 110 AND v_max > 150) THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat(
				'WARNING-377: There is/are at least one value of roughnesss out of range using headloss formula h-W (110-150) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
			
		ELSIF v_headloss = 'C-M' AND (v_min < 0.011 AND v_max > 0.017) THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat(
				'WARNING-377: There is/are at least one value of roughnesss out of range using headloss formula C-M (0.011-0.017) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
		ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat(
				'INFO: Roughness values have been checked against head-loss formula using the minimum and maximum EPANET user''s manual values. Any out-of-range values have been detected.'));
		END IF;

		RAISE NOTICE '4 - Check for network mode';
		IF v_networkmode = 4 THEN
		

			RAISE NOTICE '4.1- Epa connecs over epa node (413)';
			v_querytext = 'SELECT * FROM (
				SELECT DISTINCT t2.connec_id, t2.connecat_id , t2.state as state1, t1.node_id, t1.nodecat_id, t1.state as state2, t1.expl_id, 413, 
				t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, ''Epa connec over other EPA node'' as descript
				FROM selector_expl e, selector_sector s, node AS t1 JOIN connec AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.1) 
				WHERE s.sector_id = t1.sector_id AND s.cur_user = current_user
				aND e.expl_id = t1.expl_id AND e.cur_user = current_user 
				AND t1.epa_type != ''UNDEFINED'' 
				AND t2.epa_type = ''JUNCTION'') a where a.state1 > 0 AND a.state2 > 0 ORDER BY dist' ;

			EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
				VALUES (v_fid, 3, '413' ,concat('ERROR-413: There is/are ',v_count,' EPA connec(s) over other EPA nodes.'),v_count);

				EXECUTE 'INSERT INTO anl_node (node_id, nodecat_id, state, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, the_geom, arc_distance, descript) SELECT * FROM ('||v_querytext||') a';

			ELSE
				INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
				VALUES (v_fid, 1, '413','INFO: All EPA connecs are not on the same position than other EPA nodes.',v_count);
			END IF;


			RAISE NOTICE '4.2 - Check matcat_id for connec (414)';
			SELECT count(*) INTO v_count FROM (SELECT * FROM cat_connec WHERE matcat_id IS NULL)a1;

			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
				VALUES (v_fid, v_result_id, 3, '414',concat(
				'ERROR-414: There is/are ',v_count,' register(s) with missed matcat_id on cat_connec table. This will crash inp exportations using PJOINT/CONNEC method.'),v_count);
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
				VALUES (v_fid, v_result_id , 1,  '414','INFO: No registers found without material on cat_connec table.');
			END IF;	


			RAISE NOTICE '4.3 - Check pjoint_id/pjoint_type on connecs (415)';
			SELECT count(*) INTO v_count FROM (SELECT DISTINCT ON (connec_id) * FROM v_edit_connec c, selector_sector s 
			WHERE c.sector_id = s.sector_id AND cur_user=current_user AND pjoint_id IS NULL OR pjoint_type IS NULL) a1;

			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
				VALUES (v_fid, v_result_id, 3, '415',concat(
				'ERROR-415: There is/are ',v_count,' connecs with epa_type ''JUNCTION'' and missed information on pjoint_id or pjoint_type.'),v_count);
				INSERT INTO anl_node (fid, node_id, descript, the_geom) 
				SELECT 415, connec_id, 'Connecs with epa_type ''JUNCTION'' and missed information on pjoint_id or pjoint_type', the_geom
				FROM (SELECT DISTINCT ON (connec_id) * FROM v_edit_connec c, selector_sector s WHERE c.sector_id = s.sector_id AND cur_user=current_user 
				AND pjoint_id IS NULL OR pjoint_type IS NULL)a;
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message)
				VALUES (v_fid, v_result_id , 1,  '415','INFO: No connecs found without pjoint_id or pjoint_type values.');
			END IF;
			
			RAISE NOTICE '4.4 check dint for cat_connec (400)';
			SELECT count (*) INTO v_count FROM cat_connec where dint is null;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
				VALUES (v_fid, v_result_id, 3, '400', concat('ERROR-400: There is/are ',v_count,
				' connec catalogs with null values on dint'),v_count);
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
				VALUES (v_fid, v_result_id, 1, '400', concat('INFO: All registers on cat_connec table has dint values.'),v_count);
			END IF;
		END IF;

		RAISE NOTICE '5 - Check for UNDEFINED elements on temp table (297)';
		INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
		SELECT 297, node_id, nodecat_id, the_geom, 'Node with epa_type UNDEFINED' FROM temp_node WHERE  epa_type = 'UNDEFINED';
		
		SELECT count(*) INTO v_count FROM anl_node WHERE fid = 297 AND cur_user = current_user;
		IF  v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('WARNING-297: There is/are ',v_count,' nodes with epa_type UNDEFINED on this exportation. If are disconnected, maybe have been deleted.'));
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All nodes have epa_type defined.'));
		END IF;

		INSERT INTO anl_arc (fid, arc_id, arccat_id, the_geom, descript)
		SELECT 297, arc_id, arccat_id, the_geom, 'Arc with epa_type UNDEFINED' FROM temp_arc WHERE  epa_type = 'UNDEFINED';
		
		SELECT count(*) INTO v_count FROM temp_arc WHERE epa_type = 'UNDEFINED';
		IF  v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('WARNING-297: There is/are ',v_count,' arcs with epa_type UNDEFINED on this exportation.'));
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All arcs have epa_type defined.'));
		END IF;
		
		RAISE NOTICE '6 - Info about roughness and diameter for shortpipes';	
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All roughness values used for shortpipes have been taken from neighbourg values'));

	END IF;
	
	RAISE NOTICE '7 - Check if there are features with sector_id = 0 (373)';
	v_querytext = 'SELECT 373, arc_id, ''Arc with sector_id = 0'', the_geom FROM v_edit_arc WHERE sector_id = 0';
	
	EXECUTE 'SELECT count(*) FROM ('||v_querytext||')b'INTO v_count; 

		IF v_count > 0 THEN
			
			EXECUTE 'INSERT INTO anl_arc (fid, arc_id, descript, the_geom) '||v_querytext;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, 
			concat('WARNING-373 (anl_arc): There is/are ', v_count, ' arc on v_edit_arc with sector_id = 0 that didn''t take part in the simulation. Topological nodes will be exported if they are associated with some other exported arc.'));
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All arcs on v_edit_arc have sector_id different than 0.'));			
			v_count=0;
		END IF;


	RAISE NOTICE '8 - Check if there are conflicts with dscenarios (396)';
	IF (SELECT count(*) FROM selector_inp_dscenario WHERE cur_user = current_user) > 0 THEN
	
		FOR object_rec IN SELECT json_array_elements_text('["tank", "reservoir", "pipe", "pump", "valve", "virtualvalve", "connec", "inlet", "junction"]'::json) as tabname, 
					 json_array_elements_text('["node", "node" , "arc" , "node" , "node", "connec", "node", "node"]'::json) as colname
		LOOP

			EXECUTE 'SELECT count(*) FROM (SELECT count(*) FROM v_edit_inp_dscenario_'||object_rec.tabname||' GROUP BY '||object_rec.colname||'_id HAVING count(*) > 1) a' INTO v_count;
			IF v_count > 0 THEN

				IF object_rec.colname IN ('arc', 'node') THEN
				
					EXECUTE 'INSERT INTO anl_'||object_rec.colname||' ('||object_rec.colname||'_id, fid, descript, the_geom) 
					SELECT '||object_rec.colname||'_id, 396, concat(''Present on '',count(*),'' enabled dscenarios''), the_geom FROM v_edit_inp_dscenario_'||object_rec.tabname||' JOIN '||
					object_rec.colname||' USING ('||object_rec.colname||'_id) GROUP BY '||object_rec.colname||'_id, the_geom  having count(arc_id) > 1';

					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 3, concat('ERROR-396 (anl_',object_rec.colname,'): There is/are ', v_count, ' ',
					object_rec.colname,'(s) for ',upper(object_rec.tabname),' used on more than one enabled dscenarios.'));				
				ELSE
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 3, concat('ERROR-396: There is/are ', v_count, ' ',
					object_rec.colname,'(s) for ',upper(object_rec.tabname),' used on more than one enabled dscenarios.'));				
				END IF;
			END IF;
		END LOOP;
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: There are not dscenarios selected.'));
	END IF;

	RAISE NOTICE '9 - Check if node_id and arc_id defined on CONTROLS and RULES exists (402)';

	-- CONTROLS arcs
	v_querytext = '(SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
		(SELECT substring(split_part(text,''LINK '', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_controls WHERE active is true)a
		LEFT JOIN temp_arc b USING (arc_id)
		WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL 
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a';
	
	EXECUTE concat ('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('SELECT array_agg(id) FROM ',v_querytext) INTO v_querytext;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('ERROR-402: There is/are ', v_count, ' CONTROLS with links (arc o nodarc) not present on this result. Control id''s:',v_querytext));
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All CONTROLS has correct link id (arc or nodarc) values.'));
	END IF;

	-- CONTROLS nodes
	v_querytext = '(SELECT a.id, a.node_id as controls, b.node_id as templayer FROM 
		(SELECT substring(split_part(text,''NODE '', 2) FROM ''[^ ]+''::text) node_id, id, sector_id FROM inp_controls WHERE active is true)a
		LEFT JOIN temp_node b USING (node_id)
		WHERE b.node_id IS NULL AND a.node_id IS NOT NULL 
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a';
	
	EXECUTE concat ('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('SELECT array_agg(id) FROM ',v_querytext) INTO v_querytext;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('ERROR-402: There is/are ', v_count, ' CONTROLS with nodes not present on this result. Control id''s:',v_querytext));
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All CONTROLS has correct node id values.'));
	END IF;

	-- RULES nodes
	FOR object_rec IN SELECT json_array_elements_text('["NODE", "JUNCTION", "RESERVOIR", "TANK"]'::json) as tabname
	LOOP
		v_querytext = '(SELECT a.id, a.node_id as controls, b.node_id as templayer FROM 
		(SELECT substring(split_part(text,'||quote_literal(object_rec.tabname)||', 2) FROM ''[^ ]+''::text) node_id, id, sector_id FROM inp_rules WHERE active is true)a
		LEFT JOIN temp_node b USING (node_id)
		WHERE b.node_id IS NULL AND a.node_id IS NOT NULL 
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a';
	
		EXECUTE concat ('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			i = i+1;
			EXECUTE concat ('SELECT array_agg(id) FROM ',v_querytext) INTO v_querytext;
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-402: There is/are ', v_count, ' RULES with ',lower(object_rec.tabname),' not present on this result. Rule id''s:',v_querytext));
		END IF;
	END LOOP;

	IF v_count = 0 AND i = 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All RULES has correct node id values.'));
	END IF;

	-- RULES arcs
	i = 0;
	FOR object_rec IN SELECT json_array_elements_text('["LINK", "PIPE", "PUMP", "VALVE"]'::json) as tabname
	LOOP
		v_querytext = '(SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
		(SELECT substring(split_part(text,'||quote_literal(object_rec.tabname)||', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_rules WHERE active is true)a
		LEFT JOIN temp_arc b USING (arc_id)
		WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL 
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a';
	
		EXECUTE concat ('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			i = i+1;
			EXECUTE concat ('SELECT array_agg(id) FROM ',v_querytext) INTO v_querytext;
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-402: There is/are ', v_count, ' RULES with ',lower(object_rec.tabname),' not present on this result. Rule id''s:',v_querytext));
		END IF;
	END LOOP;

	IF v_count = 0 AND i = 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All RULES has correct link id values.'));
	END IF;


	RAISE NOTICE '10 - EPA Outlayer values (407)';

	-- elevation
	SELECT count(*) INTO v_count FROM (SELECT case when elev is not null then elev else elevation end as elev FROM temp_node) a 
	WHERE elev < (v_outlayer_elevation->>'min')::float OR elev > (v_outlayer_elevation->>'max')::float;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 3, '407', concat('ERROR-407: There is/are ',v_count,' node(s) with outlayer values on elevation column'),v_count);
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
		VALUES (v_fid, v_result_id, 1, '400', concat('INFO: All nodes has elevation without outlayer values.'),v_count);
	END IF;

	-- insert spacers for log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, '');
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (
	SELECT error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid order by criticity desc, id asc
	) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	IF v_graphiclog THEN

		--points
		v_result = null;
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		 'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom' 
		) AS feature
		FROM (SELECT node_id as id, fid, 'ERROR-228: Orphan node' as descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 228
			UNION
		      SELECT node_id, fid, 'ERROR-223: Dry node with demand', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 233
		        UNION
		      SELECT node_id, fid, 'ERROR-411: Mandatory nodarc close to other EPA node (less than 0.02 mts)', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 411
			UNION
		      SELECT node_id, fid, 'ERROR-412: Shortpipe nodarc close to other EPA node (less than 0.02 mts)', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 412
			UNION
		      SELECT node_id, fid, 'ERROR-290: Duplicated node. Maybe topological jump problem (0-1-2)', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 290
			UNION
		      SELECT node_id, fid, 'ERROR-297: Node UNDEFINED as node_1 or node_2', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 297
		        UNION
		      SELECT node_id, fid, 'ERROR-396: EPA Node used on more than one scenario', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 396
			UNION
		      SELECT node_id, fid, 'ERROR-413: EPA connec over EPA node', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 413
			UNION
		      SELECT node_id, fid, 'ERROR-415: Connec AS JUNCTION without pjoint', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 415
			UNION
		      SELECT node_id, fid, 'ERROR-432: Node ''T candidate'' with wrong topology', the_geom FROM anl_node WHERE cur_user="current_user"() AND fid = 432
		      ) row
		      ) features;

		v_result := COALESCE(v_result, '[]'); 
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 

		-- arcs
		v_result = null;
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		    'type',       'Feature',
		   'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		   'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (
			SELECT arc_id as id, fid, concat('ERROR-230: Length less than min length allowed (',v_minlength,' ).')::text as descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fid=230
			UNION
			SELECT arc_id as id, fid, 'ERROR-404: Link over nodarc'::text as descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fid=404
			UNION
			SELECT a.arc_id as id, a.fid, 'ERROR-139: Disconnected arc'::text as descript, a.the_geom FROM anl_arc a WHERE a.cur_user="current_user"() AND a.fid = 139
			UNION
			SELECT arc_id, fid, 'WARNING-232: Dry arc'::text as descript, the_geom FROM anl_arc JOIN
			(SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid = 232 EXCEPT SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid=404
			EXCEPT SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid=139) a USING (arc_id)
			WHERE cur_user="current_user"() AND fid =232
			UNION
			SELECT arc_id as id, fid, 'ERROR-396: Link over nodarc'::text as descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fid=396
		     ) row) features;

		v_result := COALESCE(v_result, '{}'); 
		v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

	END IF;

	-- control nulls
	v_options := COALESCE(v_options, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"options":'||v_options||','||
				'"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||'}'||
			'}'||
		'}')::json, 2848, null, null, null);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;