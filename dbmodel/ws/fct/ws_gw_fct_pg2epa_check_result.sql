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

-- fid: 114, 159, 297. Number 227 is passed by input parameters

*/

DECLARE

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
v_demandtype integer;
v_patternmethod integer;
v_period text;
v_networkmode integer;
v_valvemode integer;
v_demandtypeval text;
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

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';

	-- select system values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version order by 1 desc limit 1 ;
	
	-- get user values
	v_checkresult = (SELECT value::json->>'checkResult' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;

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
	DELETE FROM anl_node WHERE fid IN (159, 297) AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid IN (297) AND cur_user=current_user;

	-- get user parameters
	SELECT row_to_json(row) FROM (SELECT inp_options_interval_from, inp_options_interval_to
			FROM crosstab('SELECT cur_user, parameter, value
			FROM config_param_user WHERE parameter IN (''inp_options_interval_from'',''inp_options_interval_to'') 
			AND cur_user = current_user'::text) as ct(cur_user varchar(50), inp_options_interval_from text, inp_options_interval_to text))row
	INTO v_options;		
			
	SELECT  count(*) INTO v_doublen2a FROM inp_pump JOIN temp_arc ON concat(node_id, '_n2a_4') = arc_id 
	JOIN inp_curve c ON c.id=curve_id
	WHERE temp_arc.result_id = v_result_id;
	
	SELECT value INTO v_demandtype FROM config_param_user WHERE parameter = 'inp_options_demandtype' AND cur_user=current_user;
	SELECT value INTO v_patternmethod FROM config_param_user WHERE parameter = 'inp_options_patternmethod' AND cur_user=current_user;
	SELECT value INTO v_valvemode FROM config_param_user WHERE parameter = 'inp_options_valve_mode' AND cur_user=current_user;
	SELECT value INTO v_networkmode FROM config_param_user WHERE parameter = 'inp_options_networkmode' AND cur_user=current_user;
	SELECT value INTO v_qualitymode FROM config_param_user WHERE parameter = 'inp_options_quality_mode' AND cur_user=current_user;
	SELECT value INTO v_buildupmode FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' AND cur_user=current_user;
	
	SELECT idval INTO v_demandtypeval FROM inp_typevalue WHERE id=v_demandtype::text AND typevalue ='inp_value_demandtype';
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
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Created by: ', current_user, ', on ', to_char(now(),'YYYY-MM-DD HH-MM-SS')));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Network export mode: ', v_networkmodeval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Demand type: ', v_demandtypeval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Pattern method: ', v_patternmethodval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Valve mode: ', v_valvemodeval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Quality mode: ', v_qualmodeval));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Number of pumps as Double-n2a: ', v_doublen2a));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Buildup mode: ', v_buildmodeval, '. Parameters:', v_values));

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
		SELECT count(*) INTO v_count FROM (select curve_id, count(*) as ct from (select * from inp_curve_value join (select distinct curve_id FROM vi_curves JOIN v_edit_inp_pump
				USING (curve_id))a using (curve_id)) b group by curve_id having count(*)=3)c;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR: There is/are ',v_count,' pump(s) with a curve defined by 3 points. Please check your data before continue because a bug of EPANET with 3-point curves, it will not work.'));
		ELSE 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, 'INFO: Pumps with 3-point curves checked. No results founded. Due a EPANET''s bug with 3-point curves, it is forbidden to export curves like this because newer it will work on EPANET.');
		END IF;


		RAISE NOTICE '2 - Check nod2arc length control';	
		v_nodearc_real = (SELECT st_length (the_geom) FROM temp_arc WHERE  arc_type='NODE2ARC' AND result_id =  v_result_id LIMIT 1);
		v_nodearc_user = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_nodarc_length' AND cur_user=current_user);

		IF  v_nodearc_user > (v_nodearc_real+0.01) THEN 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('WARNING: The node2arc parameter have been modified from ',
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
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula D-W (0.0025-0.15) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
			
		ELSIF v_headloss = 'H-W' AND (v_min < 110 AND v_max > 150) THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat(
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula h-W (110-150) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
			
		ELSIF v_headloss = 'C-M' AND (v_min < 0.011 AND v_max > 0.017) THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat(
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula C-M (0.011-0.017) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
		ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat(
				'INFO: Roughness values have been checked againts head-loss formula using the minimum and maximum EPANET user''s manual values. Any out-of-range values have been detected.'));
		END IF;


		RAISE NOTICE '4 - Check curves 3p';
		IF v_buildupmode = 1 THEN

			SELECT count(*) INTO v_count FROM temp_arc WHERE epa_type='PUMP' AND result_id =  v_result_id AND addparam::json->>'curve_id' = '' AND addparam::json->>'pump_type' = '1';
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 4, concat('SUPPLY MODE: There is/are ',v_count,' pump_type = 1 with null values on curve_id column. Default user value for curve of pumptype = 1 ( ',
				_curvedefault,' ) have been chosen.'));					
				v_count=0;
			END IF;	
		ELSE
			SELECT count(*) INTO v_count FROM temp_arc WHERE result_id =  v_result_id AND epa_type='PUMP' AND addparam::json->>'curve_id' = '';

			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat('ERROR: There is/are ',v_count,' pump''s with null values at least on curve_id.'));
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, 'INFO: Pumps checked. No curve_id mandatory values missed.');
			END IF;
		END IF;
			
		RAISE NOTICE '5 - Check for network mode';
		IF v_networkmode = 3 OR v_networkmode = 4 THEN

			-- vnode over nodarc for case of use vnode treaming arcs on network model
			SELECT count(vnode_id) INTO v_count FROM temp_arc , vnode JOIN v_edit_link a ON vnode_id=exit_id::integer
			WHERE st_dwithin ( temp_arc.the_geom, vnode.the_geom, 0.01) AND temp_arc.result_id =  v_result_id  AND vnode.state > 0 AND arc_type = 'NODE2ARC';

			IF v_count > 0 THEN

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: There is/are ',v_count,
				' vnode(s) over node2arc. This is an important inconsistency. You need to reduce the nodarc length or check affected vnodes. For more info you can type'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('SELECT * FROM anl_node WHERE fid = 159 AND cur_user=current_user'));

				INSERT INTO anl_node (fid, node_id, nodecat_id, state, expl_id, the_geom, result_id, descript)
				SELECT 159, vnode_id, 'VNODE', 1, temp_arc.expl_id, vnode.the_geom, v_result_id, 'Vnode overlaping nodarcs'  
				FROM temp_arc , vnode JOIN v_edit_link a ON vnode_id=exit_id::integer
				WHERE st_dwithin ( temp_arc.the_geom, vnode.the_geom, 0.01) AND temp_arc.result_id =  v_result_id AND vnode.state > 0 AND arc_type = 'NODE2ARC';
				v_count=0;	
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, 'INFO: Vnodes checked. There is/are not vnodes over nodarcs.');
			END IF;
		END IF;


		RAISE NOTICE '6 - Check for demand type';	
		IF v_demandtype IN (1,2) THEN

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Demand type estimated is used. No inconsistence have been analyzed.'));

		ELSIF v_demandtype > 2 THEN

			SELECT value INTO v_period FROM config_param_user WHERE parameter = 'inp_options_rtc_period_id' AND cur_user=current_user;
			SELECT code INTO v_periodval FROM ext_cat_period WHERE id=v_period::text;
			SELECT period_type INTO v_periodtype FROM ext_cat_period WHERE id=v_period::text;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('CRM Period used: ', v_periodval));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('CRM Period type: ', v_periodtype));
			
			-- check hydrometers if exists
			SELECT count(*) INTO v_count FROM vi_parent_hydrometer;
						
			-- check hydrometer-period table
			SELECT count (*) INTO v_count_2 FROM ext_rtc_hydrometer_x_data JOIN vi_parent_hydrometer 
			USING (hydrometer_id) WHERE ext_rtc_hydrometer_x_data.cat_period_id = v_period AND sum IS NOT NULL;				
			
			IF  v_count = 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat(
				'ERROR: There is/are not hydrometers to define the CRM period demand. Please check your hydrometer selector or simply verify if there are hydrometers on the project.'));
				v_count=0;
			ELSIF v_count_2 < v_count THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: There is/are ', v_count, ' hydrometer(s) on current settings for user (v_rtc_hydrometer) and there are only ',
				v_count_2,' hydrometer(s) with period values from that settings on the hydrometer-period table (ext_rtc_hydrometer_x_data).'));

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat(' SELECT hydrometer_id FROM vi_parent_hydrometer EXCEPT SELECT hydrometer_id FROM ext_rtc_hydrometer_x_data.'));
				v_count=0;
				
			ELSIF v_count_2 = v_count  THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat('INFO: There is/are ', v_count, ' hydrometer(s) on this exportation all of them with period flow values on the hydrometer-period table.'));
				v_count=0;
			END IF;

			-- check connec - hydrometer relation
			SELECT count(*) INTO v_count FROM v_edit_connec c JOIN vi_parent_arc USING (arc_id) LEFT JOIN v_rtc_hydrometer h USING (connec_id) WHERE h.connec_id is null;

			IF v_count > 0 THEN

				DELETE FROM anl_connec WHERE fid = 160 and cur_user=current_user;
				INSERT INTO anl_connec (fid, connec_id, connecat_id, the_geom)
				SELECT 160, connec_id, connecat_id, the_geom FROM v_edit_connec LEFT JOIN v_rtc_hydrometer h USING (connec_id) WHERE h.connec_id is null;
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: There is/are ',v_count,' connec(s) without hydrometers. It means that vnode is generated but pattern is null and demand is null for that vnode.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('SELECT * FROM anl_connec WHERE fid = 60 AND cur_user=current_user'));
			END IF;

		END IF;

		RAISE NOTICE '7 - Check for dma-period values';
		IF v_demandtype IN (1,2,3) THEN
	
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: No dma period values are need.'));

		ELSIF v_demandtype IN (4,5) THEN -- dma needs rows on ext_rtc_dma_period

			SELECT count(*) INTO v_count FROM vi_parent_dma JOIN v_rtc_period_dma USING (dma_id);
			SELECT count(*) INTO v_count_2 FROM (SELECT dma_id, count(*) FROM vi_parent_connec WHERE dma_id >0 GROUP BY dma_id) a;

			IF  v_count = 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: There aren''t dma''s defined on the dma-period table (ext_rtc_dma_period). Please check it before continue.'));
			
			ELSIF v_count_2 > v_count THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: There is/are ', v_count_2,
				' connec dma''s attribute on this exportation but there is/are only ',v_count,' dma''s defined on dma-period table (ext_rtc_dma_period). Please check it before continue.'));
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat('INFO: There is/are ', v_count, ' dma''s on this exportation. The dma-period table (ext_rtc_dma_period) it''s filled.'));
			END IF;
		END IF;

		RAISE NOTICE '8 - Check for losses strategy values';	
		IF  v_demandtype = 4 THEN -- dma needs effc on ext_rtc_dma_period

			SELECT count(*) INTO v_count FROM ext_rtc_dma_period WHERE effc IS NOT NULL;
			SELECT count(*) INTO v_count2 FROM ext_rtc_dma_period;
			
			IF  v_count2 >  v_count THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: Some mandatory values on ext_rtc_dma_period (eff) are missed. Please check it before continue.'));
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat('INFO: All mandatory values on ext_rtc_dma_period (eff) are filled.'));
			END IF;

		ELSIF  v_demandtype = 5 THEN -- dma needs pattern_volume on ext_rtc_dma_period

			SELECT count(*) INTO v_count FROM ext_rtc_dma_period WHERE pattern_volume IS NOT NULL;
			SELECT count(*) INTO v_count2 FROM ext_rtc_dma_period;
			
			IF  v_count2 >  v_count THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: Some values for pattern_volume on ext_rtc_dma_period are missed. Please check it before continue.'));
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat('INFO: All pattern_volume values on ext_rtc_dma_period are filled.'));
			END IF;
		END IF;

		RAISE NOTICE '9 - Check for NOT DEFINED elements on temp table (297)';
		INSERT INTO anl_node (fid, node_id, nodecat_id, the_geom, descript)
		SELECT 297, node_id, nodecat_id, the_geom, 'epa_type NOT DEFINED' FROM temp_node WHERE  epa_type = 'NOT DEFINED';
		
		SELECT count(*) INTO v_count FROM anl_node WHERE fid = 297 AND cur_user = current_user;
		IF  v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('ERROR-297: There is/are ',v_count,' nodes with epa_type NOT DEFINED on this exportation. If are disconnected, may be have been deleted, but please check it before continue.'));
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All nodes have epa_type defined.'));
		END IF;

		INSERT INTO anl_arc (fid, arc_id, arccat_id, the_geom, descript)
		SELECT 297, arc_id, arccat_id, the_geom, 'epa_type NOT DEFINED' FROM temp_arc WHERE  epa_type = 'NOT DEFINED';
		
		SELECT count(*) INTO v_count FROM temp_arc WHERE epa_type = 'NOT DEFINED';
		IF  v_count > 0 THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('ERROR-297: There is/are ',v_count,' arcs with epa_type NOT DEFINED on this exportation. Please check it before continue.'));
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All arcs have epa_type defined.'));
		END IF;


		RAISE NOTICE '10 - Check for pattern method';
		IF v_patternmethod IN (41,43,51,53) THEN -- dma needs pattern
			
			-- check mandatory values for ext_rtc_dma_period table
			SELECT count(*) INTO v_count FROM ext_rtc_dma_period WHERE pattern_id IS NOT NULL;
			SELECT count(*) INTO v_count2 FROM ext_rtc_dma_period;
			
			IF  v_count2 >  v_count THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: Some values for pattern on ext_rtc_dma_period are missed. Please check it before continue.'));
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat('INFO: All pattern values on ext_rtc_dma_period are filled.'));
			END IF;

		ELSIF v_patternmethod IN (42,44,52,54) THEN -- hydro needs patterns 

			-- check ext_hydrometer_category_x_pattern
			SELECT distinct(category_id) INTO v_count from ext_hydrometer_category_x_pattern WHERE period_type = v_periodtype;
			SELECT distinct(category_id) INTO v_count2 from  v_rtc_hydrometer;
			
			IF v_count = 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat(
				'ERROR: There is not values on ext_hydrometer_category_x_pattern for this period_type. Please check it before continue.'));
			ELSIF v_count2 > v_count THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat(
				'ERROR: There is more category_type hydrometers on network that defined on ext_hydrometer_category_x_pattern. Please check it before continue.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat('HINT: UPDATE ext_rtc_hydrometer_x_data SET pattern_id = pattern_id FROM .'));
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat(
				'INFO: All the hydrometers are well-configured with volume and pattern on the the hydrometer-period table (ext_rtc_hydrometer_x_data).'));			
			END IF;
			
			-- check hydrometer
			SELECT count (*) INTO v_count FROM ext_rtc_hydrometer_x_data a JOIN vi_parent_hydrometer USING (hydrometer_id) 
			WHERE a.cat_period_id = v_period AND sum IS NOT NULL; -- hydrometers with value	
				
			SELECT count (*) INTO v_count_2 FROM ext_rtc_hydrometer_x_data a JOIN vi_parent_hydrometer USING (hydrometer_id) 
			WHERE a.cat_period_id = v_period AND sum IS NOT NULL AND a.pattern_id IS not NULL; -- hydrometers with value and pattern	

			IF  v_count_2 = 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat(
				'ERROR: By using this pattern method, hydrometers''s must be defined with pattern on the hydrometer-period table (ext_rtc_hydrometer_x_data). Please check it before continue.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat(
				'HINT: UPDATE ext_rtc_hydrometer_x_data SET pattern_id = pattern_id FROM .'));
			ELSIF v_count > v_count_2 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: There is/are ', v_count, ' hydrometers''s with volume but only', v_count_2,
				' with defined pattern on on the hydrometer-period table (ext_rtc_hydrometer_x_data). Please check it before continue.'));
			ELSE
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat(
				'INFO: All the hydrometers are well-configured with volume and pattern on the the hydrometer-period table (ext_rtc_hydrometer_x_data).'));			
				v_count=0;
			END IF;
		END IF;
		
		RAISE NOTICE '11 - Check for valve/shortipe diameter control';	

		SELECT count(*) INTO v_count FROM temp_arc WHERE epa_type IN ('SHORTPIPE', 'VALVE') AND diameter IS NULL;
		
		IF  v_count > 0 THEN 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('WARNING: There are ', v_count , 'epanet shortpipe and valves without diameter. Neighbourg value have been setted. Please fill dint column on cat_node table'));
		ELSE 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: There aren''t any shortpipe and valves without diameter defined on dint column in cat_node table'));
		END IF;


		RAISE NOTICE '12 - Info about roughness and diameter for shortpipes';	
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All roughness values used for shortpipes have been taken from neighbourg values'));

	END IF;
	
	RAISE NOTICE '11 - Check if there are features with sector_id = 0';

	v_querytext = 'SELECT a.feature , count(*)  FROM  (
				SELECT arc_id, ''ARC'' as feature FROM v_edit_arc WHERE sector_id = 0 UNION
				SELECT node_id, ''NODE'' FROM v_edit_node WHERE sector_id = 0)a GROUP BY feature ';
	
	EXECUTE 'SELECT count(*) FROM ('||v_querytext||')b'
	INTO v_count; 

		IF v_count > 0 THEN
			EXECUTE 'SELECT count FROM ('||v_querytext||')b WHERE feature = ''ARC'';'
			INTO v_count; 
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat('ERROR: There is/are ', v_count, ' arcs with sector_id = 0 that didn''t take part in the simulation'));
			END IF;
			EXECUTE 'SELECT count FROM ('||v_querytext||')b WHERE feature = ''NODE'';'
			INTO v_count; 
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat('ERROR: There is/are ', v_count, ' nodes with sector_id = 0 that didn''t take part in the simulation'));
			END IF;
		ELSE
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All features have sector_id different than 0.'));			
			v_count=0;
		END IF;

	-- insert spacers for log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, '');
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid
	order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- control nulls
	v_options := COALESCE(v_options, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 

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
	FROM  anl_node WHERE cur_user="current_user"() AND fid = 159) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 

	IF v_fid::text = 127::text THEN
		v_result_point = '{}';
	END IF;
	
	-- Control nulls
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"options":'||v_options||','||
				'"info":'||v_result_info||','||
				'"point":'||v_result_point||'}'||
			'}'||
		'}')::json, 2848);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;