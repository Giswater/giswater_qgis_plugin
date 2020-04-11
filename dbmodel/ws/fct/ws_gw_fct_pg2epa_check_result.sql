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
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"gw_check_project","fprocesscatId":127}}}$$) when is called from go2epa_main from toolbox
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"gw_check_project"}}}$$) -- when is called from toolbox

*/

DECLARE
v_fprocesscat_id integer;
v_record record;
v_project_type text;
v_count	integer;
v_count_2 integer;
v_infiltration text;
v_scenario text;
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
v_qmlpointpath text = '';
v_qmllinepath text = '';
v_qmlpolpath text = '';
v_doublen2a integer;
v_advancedsettings text;
v_advancedsettingsval text;
v_curvedefault text;
v_options json;
v_error_context text;
v_defaultvalues text;
v_debug text;
v_values text;
v_debugmode boolean;
v_checkresult boolean;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fprocesscat_id := ((p_data ->>'data')::json->>'parameters')::json->>'fprocesscatId';

	-- select system values
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1 ;
	
	-- get user values
	v_checkresult = (SELECT (value::json->>'debug')::json->>'checkResult' FROM config_param_user 
	WHERE parameter='inp_options_settings' AND cur_user=current_user)::boolean;

	-- manage no results
	IF (SELECT result_id FROM rpt_cat_result WHERE result_id=v_result_id) IS NULL THEN	
		RAISE EXCEPTION 'You need to create a result before';
	END IF;
		
	-- init variables
	v_count=0;
	IF v_fprocesscat_id is null THEN
		v_fprocesscat_id = 14;
	END IF;
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id = 14 AND user_name=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id IN (59) AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fprocesscat_id IN (3) AND cur_user=current_user;

	-- get user parameters
	SELECT row_to_json(row) FROM (SELECT inp_options_interval_from, inp_options_interval_to
			FROM crosstab('SELECT cur_user, parameter, value
			FROM config_param_user WHERE parameter IN (''inp_options_interval_from'',''inp_options_interval_to'') 
			AND cur_user = current_user'::text) as ct(cur_user varchar(50), inp_options_interval_from text, inp_options_interval_to text))row
	INTO v_options;		
			
	SELECT  count(*) INTO v_doublen2a FROM inp_pump JOIN rpt_inp_arc ON concat(node_id, '_n2a_4') = arc_id 
	JOIN inp_curve_id c ON c.id=curve_id WHERE result_id=v_result_id;
	
	SELECT value INTO v_demandtype FROM config_param_user WHERE parameter = 'inp_options_demandtype' AND cur_user=current_user;
	SELECT value INTO v_patternmethod FROM config_param_user WHERE parameter = 'inp_options_patternmethod' AND cur_user=current_user;
	SELECT value INTO v_valvemode FROM config_param_user WHERE parameter = 'inp_options_valve_mode' AND cur_user=current_user;
	SELECT value INTO v_networkmode FROM config_param_user WHERE parameter = 'inp_options_networkmode' AND cur_user=current_user;
	SELECT value INTO v_qualitymode FROM config_param_user WHERE parameter = 'inp_options_quality_mode' AND cur_user=current_user;
	SELECT value INTO v_buildupmode FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' AND cur_user=current_user;
	SELECT value INTO v_advancedsettings FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT value::json->>'debug' INTO v_debug FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;

	
	SELECT idval INTO v_demandtypeval FROM inp_typevalue WHERE id=v_demandtype::text AND typevalue ='inp_value_demandtype';
	SELECT idval INTO v_valvemodeval FROM inp_typevalue WHERE id=v_valvemode::text AND typevalue ='inp_value_opti_valvemode';
	SELECT idval INTO v_patternmethodval FROM inp_typevalue WHERE id=v_patternmethod::text AND typevalue ='inp_value_patternmethod';
	SELECT idval INTO v_networkmodeval FROM inp_typevalue WHERE id=v_networkmode::text AND typevalue ='inp_options_networkmode';
	SELECT idval INTO v_qualmodeval FROM inp_typevalue WHERE id=v_qualitymode::text AND typevalue ='inp_value_opti_qual';
	SELECT idval INTO v_buildmodeval FROM inp_typevalue WHERE id=v_buildupmode::text AND typevalue ='inp_options_buildup_mode';
	
	v_defaultvalues = (SELECT (value::json->>'vdefault') FROM config_param_user WHERE parameter = 'inp_options_settings' AND cur_user=current_user);
	v_advancedsettings = (SELECT (value::json->>'advanced') FROM config_param_user WHERE parameter = 'inp_options_settings' AND cur_user=current_user);
	v_debug = (SELECT (value::json->>'debug')::json->>'status' FROM config_param_user WHERE parameter = 'inp_options_settings' AND cur_user=current_user);
	
	-- Header
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('CHECK RESULT WITH CURRENT USER-OPTIONS ACORDING EPA RULES'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, '---------------------------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 1, '-------');	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 0, 'NETWORK ANALYTICS');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 0, '-------------------------');	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Result id: ', v_result_id));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Created by: ', current_user, ', on ', to_char(now(),'YYYY-MM-DD HH-MM-SS')));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Network export mode: ', v_networkmodeval));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Demand type: ', v_demandtypeval));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Pattern method: ', v_patternmethodval));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Valve mode: ', v_valvemodeval));	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Quality mode: ', v_qualmodeval));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Number of pumps as Double-n2a: ', v_doublen2a));		
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Buildup mode: ', v_buildmodeval));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Default values: ', v_defaultvalues));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Advanced settings: ', v_advancedsettings));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Debug: ', v_debug));	

	IF v_checkresult THEN
	
		IF v_buildupmode = 1 THEN
			v_values = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user);
		END IF;

		IF v_debug::boolean THEN
			v_debugmode = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_settings' AND cur_user=current_user);
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Debug mode: ', v_debugmode));
		END IF;


		RAISE NOTICE '1 - Check pumps with 3-point curves (because of bug of EPANET this kind of curves are forbidden on the exportation)';
		SELECT count(*) INTO v_count FROM (select curve_id, count(*) as ct from (select * from inp_curve join (select distinct curve_id FROM vi_curves JOIN v_edit_inp_pump 
				USING (curve_id))a using (curve_id)) b group by curve_id having count(*)=3)c;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,' pump(s) with a curve defined by 3 points. Please check your data before continue because a bug of EPANET with 3-point curves, it will not work.'));
		ELSE 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Pumps with 3-point curves checked. No results founded. Due a EPANET''s bug with 3-point curves, it is forbidden to export curves like this because newer it will work on EPANET.');
		END IF;


		RAISE NOTICE '2 - Check nod2arc length control';	
		v_nodearc_real = (SELECT st_length (the_geom) FROM rpt_inp_arc WHERE  arc_type='NODE2ARC' AND result_id=v_result_id LIMIT 1);
		v_nodearc_user = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_nodarc_length' AND cur_user=current_user);

		IF  v_nodearc_user > (v_nodearc_real+0.01) THEN 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
			VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: The node2arc parameter have been modified from ', 
			v_nodearc_user::numeric(12,3), ' to ', v_nodearc_real::numeric(12,3), ' in order to prevent length conflicts.'));
		ELSE 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
			VALUES (v_fprocesscat_id, v_result_id, 1, concat('INFO: The node2arc parameter is ok for the whole analysis. Current value is ', v_nodearc_user::numeric(12,3)));
		END IF;


		RAISE NOTICE '3 - Check roughness inconsistency in function of headloss formula used';
		v_min = (SELECT min(roughness) FROM inp_cat_mat_roughness);
		v_max = (SELECT max(roughness) FROM inp_cat_mat_roughness);
		v_headloss = (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter='inp_options_headloss.');
			
		IF v_headloss = 'D-W' AND (v_min < 0.0025 AND v_max > 0.15) THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 2, concat(
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula D-W (0.0025-0.15) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
			
		ELSIF v_headloss = 'H-W' AND (v_min < 110 AND v_max > 150) THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 	
				VALUES (v_fprocesscat_id, v_result_id, 2, concat(
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula h-W (110-150) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
			
		ELSIF v_headloss = 'C-M' AND (v_min < 0.011 AND v_max > 0.017) THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 2, concat(
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula C-M (0.011-0.017) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,').'));
		ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 1, concat(
				'INFO: Roughness values have been checked againts head-loss formula using the minimum and maximum EPANET user''s manual values. Any out-of-range values have been detected.'));
		END IF;


		RAISE NOTICE '4 - Check curves 3p';
		IF v_buildupmode = 1 THEN

			SELECT count(*) INTO v_count FROM rpt_inp_arc WHERE epa_type='PUMP' AND addparam::json->>'curve_id' = '' AND addparam::json->>'pump_type' = '1' AND result_id=v_result_id;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 4, concat('SUPPLY MODE: There is/are ',v_count,' pump_type = 1 with null values on curve_id column. Default user value for curve of pumptype = 1 ( ',
				_curvedefault,' ) have been chosen.'));					
				v_count=0;
			END IF;	
		ELSE
			SELECT count(*) INTO v_count FROM rpt_inp_arc WHERE epa_type='PUMP' AND addparam::json->>'curve_id' = '' AND result_id=v_result_id;

			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,' pump''s with null values at least on curve_id.'));
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Pumps checked. No curve_id mandatory values missed.');
			END IF;
		END IF;
			

		RAISE NOTICE '5 - Advanced network mode (vnodes)';
		IF v_networkmode = 3 OR v_networkmode = 4 THEN

			-- vnode over nodarc for case of use vnode treaming arcs on network model
			SELECT count(vnode_id) INTO v_count FROM rpt_inp_arc , vnode JOIN v_edit_link a ON vnode_id=exit_id::integer
			WHERE st_dwithin ( rpt_inp_arc.the_geom, vnode.the_geom, 0.01) AND vnode.state > 0 AND arc_type = 'NODE2ARC'
			AND result_id=v_result_id;

			IF v_count > 0 THEN

				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ',v_count,
				' vnode(s) over node2arc. This is an important inconsistency. You need to reduce the nodarc length or check affected vnodes. For more info you can type'));
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=59 AND cur_user=current_user'));		

				DELETE FROM anl_node WHERE fprocesscat_id=59 and cur_user=current_user;				
				INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, state, expl_id, the_geom, result_id, descript)
				SELECT 59, vnode_id, 'VNODE', 1, rpt_inp_arc.expl_id, vnode.the_geom, v_result_id, 'Vnode overlaping nodarcs'  
				FROM rpt_inp_arc , vnode JOIN v_edit_link a ON vnode_id=exit_id::integer
				WHERE st_dwithin ( rpt_inp_arc.the_geom, vnode.the_geom, 0.01) AND vnode.state > 0 AND arc_type = 'NODE2ARC'
				AND result_id=v_result_id;
				v_count=0;	
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Vnodes checked. There is/are not vnodes over nodarcs.');
			END IF;
		ELSE
			-- check if demand type for connec is used
			IF v_patternmethod = v_fprocesscat_id  OR v_patternmethod = 27 THEN 
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: The pattern method used, ',v_patternmethodval,' it is incompatible with the export network mode used, ',v_networkmodeval)); 
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 3, ' Change the pattern method using some of the CONNEC method avaliable or change export network USING some of TRIMED ARCS method avaliable.');
			END IF;		
		END IF;


		RAISE NOTICE '6 - Demand type analysis';	
		IF v_demandtype = 1 THEN

			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (v_fprocesscat_id, v_result_id, 1, concat('INFO: Demand type estimated is used. No inconsistence have been analyzed.'));

		ELSIF v_demandtype > 1 THEN --(2 or 3)

			SELECT value INTO v_period FROM config_param_user WHERE parameter = 'inp_options_rtc_period_id' AND cur_user=current_user;
			SELECT code INTO v_periodval FROM ext_cat_period WHERE id=v_period::text;

			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('CRM Period used: ', v_periodval));

			-- check hydrometers if exists
			SELECT count(*) INTO v_count FROM vi_parent_hydrometer;
						
			-- check hydrometer-period table
			SELECT count (*) INTO v_count_2 FROM ext_rtc_hydrometer_x_data JOIN vi_parent_hydrometer 
			USING (hydrometer_id) WHERE ext_rtc_hydrometer_x_data.cat_period_id = v_period AND sum IS NOT NULL;				
			
			IF  v_count = 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 3, concat(
				'ERROR: There is/are not hydrometers to define the CRM period demand. Please check your hydrometer selector or simply verify if there are hydrometers on the project.'));
				v_count=0;
			ELSIF v_count_2 < v_count THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ', v_count, ' hydrometer(s) on current settings for user (v_rtc_hydrometer) and there are only ',
				v_count_2,' hydrometer(s) with period values from that settings on the hydrometer-period table (ext_rtc_hydrometer_x_data).'));

				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 2, concat(' SELECT hydrometer_id FROM vi_parent_hydrometer EXCEPT SELECT hydrometer_id FROM ext_rtc_hydrometer_x_data.'));
				v_count=0;
				
			ELSIF v_count_2 = v_count  THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 1, concat('INFO: There is/are ', v_count, ' hydrometer(s) on this exportation all of them with period flow values on the hydrometer-period table.'));
				v_count=0;
			END IF;

			-- check connec - hydrometer relation
			SELECT count(*) INTO v_count FROM v_edit_connec JOIN vi_parent_arc USING (arc_id) WHERE connec_id NOT IN (SELECT connec_id FROM v_rtc_hydrometer);

			IF v_count > 0 THEN

				DELETE FROM anl_connec WHERE fprocesscat_id=60 and cur_user=current_user;
				INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, the_geom) 
				SELECT 60, connec_id, connecat_id, the_geom FROM v_edit_connec WHERE connec_id NOT IN (SELECT connec_id FROM v_rtc_hydrometer);

				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ',v_count,' connec(s) without hydrometers. It means that vnode is generated but pattern is null and demand is null for that vnode.'));
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('SELECT * FROM anl_connec WHERE fprocesscat_id=60 AND cur_user=current_user'));
			END IF;

			-- check mandatory values for ext_rtc_dma_period table
			SELECT count(*) INTO v_count FROM ext_rtc_dma_period WHERE dma_id IS NOT NULL AND period_id IS NOT NULL AND m3_total_period IS NOT NULL AND eff IS NOT NULL AND pattern_id IS NOT NULL AND pattern_volume IS NOT NULL;
			SELECT count(*) INTO v_count2 FROM ext_rtc_dma_period;
			
			IF  v_count2 >  v_count THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: Some mandatory values on ext_rtc_dma_period (m3_total_period, eff, pattern_id, pattern_volume) are missed. Please check it before continue.'));
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 1, concat('INFO: All mandatory values on ext_rtc_dma_period (m3_total_period, eff, pattern_id, pattern_volume) are filled.'));
			END IF;

			-- check dma-period table
			SELECT count(*) INTO v_count FROM vi_parent_dma JOIN v_rtc_period_dma USING (dma_id);
			SELECT count(*) INTO v_count_2 FROM (SELECT dma_id, count(*) FROM vi_parent_connec WHERE dma_id >0 GROUP BY dma_id) a;

			IF  v_count = 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There aren''t dma''s defined on the dma-period table (ext_rtc_dma_period). Please check it before continue.'));
			
			ELSIF v_count_2 > v_count THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ', v_count_2, 
				' connec dma''s attribute on this exportation but there is/are only ',v_count,' dma''s defined on dma-period table (ext_rtc_dma_period). Please check it before continue.'));
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 1, concat('INFO: There is/are ', v_count, ' dma''s on this exportation. The dma-period table (ext_rtc_dma_period) it''s filled.'));
			END IF;
		END IF;

		RAISE NOTICE '7 - Pattern method analysis';
		-- check for hydrometer period patterns
		IF v_patternmethod IN (23,26,33) THEN --hydro period needs patterns 

			SELECT count (*) FROM ext_rtc_hydrometer_x_data a JOIN vi_parent_hydrometer USING (hydrometer_id) 
			WHERE a.cat_period_id = v_period AND sum IS NOT NULL; -- hydrometers with value		
			SELECT count (*) INTO v_count_2 FROM ext_rtc_hydrometer_x_data a JOIN vi_parent_hydrometer USING (hydrometer_id) 
			WHERE a.cat_period_id = v_period AND sum IS NOT NULL AND a.pattern_id IS not NULL; -- hydrometers with value and pattern	

			IF  v_count_2 = 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 3, concat(
				'ERROR: By using this pattern method, hydrometers''s must be defined with pattern on the hydrometer-period table (ext_rtc_hydrometer_x_data). Please check it before continue.'));
				v_count=0;
			ELSIF v_count > v_count_2 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ', v_count, ' hydrometers''s with volume but only', v_count_2,
				' with defined pattern on on the hydrometer-period table (ext_rtc_hydrometer_x_data). Please check it before continue.'));
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (v_fprocesscat_id, v_result_id, 1, concat(
				'INFO: All the hydrometers are well-configured with volume and pattern on the the hydrometer-period table (ext_rtc_hydrometer_x_data).'));			
				v_count=0;
			END IF;
		END IF;
	END IF;
	
	-- insert spacers for log
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 1, '');	

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=v_fprocesscat_id 
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
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fprocesscat_id, the_geom 
	FROM  anl_node WHERE cur_user="current_user"() AND fprocesscat_id = 59) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "qmlPath":"',v_qmlpointpath,'", "features":',v_result, '}'); 

	IF v_fprocesscat_id::text = 127::text THEN
		v_result_point = '{}';
	END IF;
	
	-- Control nulls
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"options":'||v_options||','||
				'"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
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