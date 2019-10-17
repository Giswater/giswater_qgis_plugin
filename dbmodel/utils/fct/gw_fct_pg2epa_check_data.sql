/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2430

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_check_data(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_pg2epa_check_data($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"parameters":{"resultId":"p1","saveOnDatabase":true}}}$$)
*/

DECLARE
v_data 			json;
valve_rec		record;
v_countglobal		integer;
v_record		record;
setvalue_int		int8;
v_project_type 		text;
v_count			integer;
v_count_2		integer;
infiltration_aux	text;
rgage_rec		record;
scenario_aux		text;
v_min_node2arc		float;
v_arc			text;
v_saveondatabase 	boolean;
v_result 		text;
v_version		text;
v_result_info 		json;
v_result_point		json;
v_result_line 		json;
v_result_polygon	json;
v_querytext		text;
v_nodearc_real 		float;
v_nodearc_user 		float;
v_result_id 		text;
v_min 			numeric (12,4);
v_max			numeric (12,4);
v_headloss		text;
v_message		text;
v_demandtype 		integer;
v_patternmethod		integer;
v_period		text;
v_networkmode		integer;
v_valvemode		integer;
v_demandtypeval 	text;
v_patternmethodval 	text;
v_periodval 		text;
v_valvemodeval 		text;
v_networkmodeval	text;
v_dwfscenario		text;
v_allowponding		text;
v_florouting		text;
v_flowunits		text;
v_hydrologyscenario	text;
v_qualitymode		text;
v_qualmodeval		text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_message:= ((p_data ->>'data')::json->>'parameters')::json->>'message'::text;

	
	-- select config values
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;

	v_data = '{"client":{"device":3, "infoType":100, "lang":"ES"},"data":{"iterative":"off", "resultId":"test1", "useNetworkGeom":"false"}}';


	-- call go2epa function in case of new result
	IF (SELECT result_id FROM rpt_cat_result WHERE result_id=v_result_id) IS NULL THEN	
		IF v_project_type = 'WS' THEN
			PERFORM gw_fct_pg2epa_main(v_data);
		ELSE
			PERFORM gw_fct_pg2epa_main(v_data);
		END IF;
	END IF;
		
	SELECT st_length(a.the_geom), a.arc_id INTO v_min_node2arc, v_arc FROM v_edit_arc a JOIN rpt_inp_arc b ON a.arc_id=b.arc_id WHERE result_id=v_result_id ORDER BY 1 asc LIMIT 1;

	-- init variables
	v_count=0;
	v_countglobal=0;	

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=14 AND user_name=current_user;
	DELETE FROM anl_arc WHERE fprocesscat_id=14 AND result_id=v_result_id AND cur_user=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id=14 AND result_id=v_result_id AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('DATA QUALITY ANALYSIS ACORDING EPA RULES'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, '-----------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 1, '-------');	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, 'NETWORK ANALYSIS');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, '-------------------------');	
		
	-- UTILS
	-- Check orphan nodes
	FOR v_record IN SELECT * FROM rpt_inp_node WHERE result_id=v_result_id AND node_id NOT IN 
	(SELECT node_1 FROM rpt_inp_arc WHERE result_id=v_result_id UNION SELECT node_2 FROM rpt_inp_arc WHERE result_id=v_result_id)
	LOOP
		v_count=v_count+1;
		INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, state, expl_id, the_geom, result_id, descript)
		VALUES (14, v_record.node_id, v_record.nodecat_id,  v_record.state, v_record.expl_id, v_record.the_geom, v_result_id, 'Node orphan');
		v_countglobal=v_countglobal+v_count;		
	END LOOP;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' node(s) orphan. Take a look on temporal table to know details'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (14, v_result_id, 1, 'INFO: There is/are no nodes orphan');
	END IF;

	-- Check arcs without start/end node
	v_querytext = '	SELECT 14, arc_id, arccat_id,  state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arc with node_1 not present in the exportation'' 
			FROM rpt_inp_arc where result_id = '||quote_literal(v_result_id)||' AND node_1 NOT IN (SELECT node_id FROM rpt_inp_node where result_id='||quote_literal(v_result_id)||')
			UNION 
			SELECT 14, arc_id, arccat_id, state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arc with node_2 not present in the exportation'' 
			FROM rpt_inp_arc where result_id = '||quote_literal(v_result_id)||' AND node_2 NOT IN (SELECT node_id FROM rpt_inp_node where result_id='||quote_literal(v_result_id)||')';


	EXECUTE 'SELECT count(*) FROM ('||v_querytext ||')a'
		INTO v_count;

	EXECUTE 'INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, state, expl_id, the_geom, result_id, descript)'||v_querytext;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' arc(s) without start/end nodes. Take a look on temporal table to know details'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (14, v_result_id, 1,'INFO: There is/are no arcs without start/end nodes');
	END IF;
		
	-- only UD projects
	IF 	v_project_type='UD' THEN

		SELECT hydrology_id INTO scenario_aux FROM inp_selector_hydrology WHERE cur_user=current_user;
		SELECT value INTO v_dwfscenario FROM config_param_user WHERE parameter = 'inp_options_dwfscenario' AND cur_user=current_user;
		SELECT value INTO v_allowponding FROM config_param_user WHERE parameter = 'inp_options_allow_ponding' AND cur_user=current_user;
		SELECT value INTO v_florouting FROM config_param_user WHERE parameter = 'inp_options_flow_routing' AND cur_user=current_user;
		SELECT value INTO v_flowunits FROM config_param_user WHERE parameter = 'inp_options_flow_units' AND cur_user=current_user;

		SELECT upper(name) INTO v_hydrologyscenario FROM cat_hydrology WHERE hydrology_id=scenario_aux::integer;

		IF v_dwfscenario IS NULL THEN v_dwfscenario='NONE';
		END IF;

		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Hydrology scenario: ', v_hydrologyscenario));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('DWF scenario: ', v_dwfscenario));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Allow ponding: ', v_allowponding));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Flow routing: ', v_florouting));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Flow units: ', v_flowunits));	

	
		SELECT count(*) into v_count FROM anl_node WHERE fprocesscat_id=13 AND cur_user=current_user;
		
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 2, concat('WARNING: There is/are ',v_count,' junction(s) type sink which means that junction only have entry arcs without any exit arc.'));
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=13 AND cur_user=current_user'));		
	
			-- check nodes sink automaticly swiched to outfall (fuction gw_fct_anl_node_sink have been called on pg2epa_fill_data function)
			SELECT count(*) into v_count_2 FROM anl_node JOIN inp_junction USING (node_id) WHERE outfallparam IS NOT NULL AND fprocesscat_id=13 AND cur_user=current_user;
			
			IF v_count_2 > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 2, concat('WARNING:  ',v_count_2,' from ',v_count, ' junction(s) type sink has/have outfallparam field defined and has/have been switched to OUTFALL using defined parameters.'));
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=13 AND cur_user=current_user JOIN inp_junction USING (node_id) WHERE outfallparam IS NOT NULL'));		
			END IF;
		
			v_countglobal=v_countglobal+v_count+v_count_2; 
			v_count=0;
			v_count_2=0;
		ELSE 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Any junction have been swiched on the fly to OUTFALL. Only junctions node sink with outfallparam values will be transformed on the fly to OUTFALL'));
		END IF;
			
		-- check common mistakes
		SELECT count(*) INTO v_count FROM v_edit_subcatchment WHERE outlet_id is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column outlet_id column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column oulet_id on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where rg_id is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column rg_id column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column rg_id on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where area is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column area column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column area on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where width is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column width column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column width on subcatchment table have been checked without any values missed'));
		END IF;
		
		SELECT count(*) INTO v_count FROM v_edit_subcatchment where slope is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column slope column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column slope on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where clength is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column clength column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column clength on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where nimp is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column nimp column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column nimp on subcatchment table have been checked without any values missed'));
		END IF;
		
		SELECT count(*) INTO v_count FROM v_edit_subcatchment where nperv is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column nperv column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column nperv on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where simp is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column simp column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column simp on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where sperv is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column sperv column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column sperv on subcatchment table have been checked without any values missed'));
		END IF;
		
		SELECT count(*) INTO v_count FROM v_edit_subcatchment where zero is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column zero column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column zero on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where routeto is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column routeto column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column routeto on subcatchment table have been checked without any values missed'));
		END IF;

		
		SELECT count(*) INTO v_count FROM v_edit_subcatchment where rted is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column rted column'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column rted on subcatchment table have been checked without any values missed'));
		END IF;

		SELECT infiltration INTO infiltration_aux FROM cat_hydrology JOIN inp_selector_hydrology
		ON inp_selector_hydrology.hydrology_id=cat_hydrology.hydrology_id WHERE cur_user=current_user;
		
		IF infiltration_aux='CURVE_NUMBER' THEN
		
			SELECT count(*) INTO v_count FROM v_edit_subcatchment where (curveno is null) 
			OR (conduct_2 is null) OR (drytime_2 is null);
			
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,	' subcatchment(s) with null values on mandatory columns of curve number infiltartion method (curveno, conduct_2, drytime_2)'));
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('HINT: Acording EPA SWMM user''s manual, conduct_2 is deprecated, but anywat need to be informed. Any value is valid because always will be ignored by SWMM'));
				
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 	
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory columns for ''CURVE_NUMBER'' infiltration method on subcatchment table (curveno, conduct_2, drytime_2) have been checked without any values missed'));
			END IF;
		
		ELSIF infiltration_aux='GREEN_AMPT' THEN
		
			SELECT count(*) INTO v_count FROM v_edit_subcatchment where (suction is null) 
			OR (conduct_¡ is null) OR (initdef is null);
			
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory columns of Green-Apt infiltartion method (suction, conduct, initdef)'));
				v_countglobal=v_countglobal+v_count;
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory columns for ''GREEN_AMPT'' infiltration method on subcatchment table (suction, conduct, initdef) have been checked without any values missed'));
			END IF;
		
		
		ELSIF infiltration_aux='HORTON' OR infiltration_aux='MODIFIED_HORTON' THEN
		
			SELECT count(*) INTO v_count FROM v_edit_subcatchment where (maxrate is null) 
			OR (minrate is null) OR (decay is null) OR (drytime is null) OR (maxinfil is null);
			
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory columns of Horton/Horton modified infiltartion method (maxrate, minrate, decay, drytime, maxinfil)'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory columns for ''MODIFIED_HORTON'' infiltration method on subcatchment table (maxrate, minrate, decay, drytime, maxinfil) have been checked without any values missed'));
			END IF;
			
		END IF;
		
		
		SELECT count(*) INTO v_count FROM v_edit_raingage 
		where (form_type is null) OR (intvl is null) OR (rgage_type is null);
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' raingage(s) with null values at least on mandatory columns for rain type (form_type, intvl, rgage_type)'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory colums for raingage (form_type, intvl, rgage_type) have been checked without any values missed'));
			END IF;		
			
		SELECT count(*) INTO v_count FROM v_edit_raingage where rgage_type='TIMESERIES' AND timser_id IS NULL;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' raingage(s) with null values on the mandatory column for ''TIMESERIES'' raingage type'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory colums for ''TIMESERIES'' raingage type have been checked without any values missed'));
			END IF;		

		SELECT count(*) INTO v_count FROM v_edit_raingage where rgage_type='FILE' AND (fname IS NULL or sta IS NULL or units IS NULL);
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' raingage(s) with null values at least on mandatory columns for ''FILE'' raingage type (fname, sta, units)'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory colums (fname, sta, units) for ''FILE'' raingage type have been checked without any values missed'));
			END IF;				

	ELSIF v_project_type='WS' THEN

		SELECT value INTO v_demandtype FROM config_param_user WHERE parameter = 'inp_options_demandtype' AND cur_user=current_user;
		SELECT value INTO v_patternmethod FROM config_param_user WHERE parameter = 'inp_options_patternmethod' AND cur_user=current_user;
		SELECT value INTO v_valvemode FROM config_param_user WHERE parameter = 'inp_options_valve_mode' AND cur_user=current_user;
		SELECT value INTO v_networkmode FROM config_param_user WHERE parameter = 'inp_options_networkmode' AND cur_user=current_user;
		SELECT value INTO v_qualitymode FROM config_param_user WHERE parameter = 'inp_options_quality_mode' AND cur_user=current_user;

		SELECT idval INTO v_demandtypeval FROM inp_typevalue WHERE id=v_demandtype::text AND typevalue ='inp_value_demandtype';
		SELECT idval INTO v_valvemodeval FROM inp_typevalue WHERE id=v_valvemode::text AND typevalue ='inp_value_opti_valvemode';
		SELECT idval INTO v_patternmethodval FROM inp_typevalue WHERE id=v_patternmethod::text AND typevalue ='inp_value_patternmethod';
		SELECT idval INTO v_networkmodeval FROM inp_typevalue WHERE id=v_networkmode::text AND typevalue ='inp_options_networkmode';
		SELECT idval INTO v_qualmodeval FROM inp_typevalue WHERE id=v_qualitymode::text AND typevalue ='inp_value_opti_qual';

		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Network export mode: ', v_networkmodeval));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Demand type: ', v_demandtypeval));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Pattern method: ', v_patternmethodval));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Valve mode: ', v_valvemodeval));	
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('Quality mode: ', v_qualmodeval));	

		SELECT dscenario_id INTO scenario_aux FROM inp_selector_dscenario WHERE cur_user=current_user;

		-- nod2arc length control
		v_nodearc_real = (SELECT st_length (the_geom) FROM rpt_inp_arc WHERE  arc_type='NODE2ARC' AND result_id=v_result_id LIMIT 1);
		v_nodearc_user = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_nodarc_length' AND cur_user=current_user);
		IF  v_nodearc_user > (v_nodearc_real+0.01) THEN 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
			VALUES (14, v_result_id, 2, concat('WARNING: The node2arc parameter have been modified from ', 
			v_nodearc_user::numeric(12,3), ' to ', v_nodearc_real::numeric(12,3), ' in order to prevent length conflicts'));
		ELSE 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
			VALUES (14, v_result_id, 1, concat('INFO: The node2arc parameter is ok for the whole analysis. Current value:', v_nodearc_user::numeric(12,3)));
		END IF;

		-- null elevation control
		SELECT count(*) INTO v_count FROM rpt_inp_node WHERE result_id=v_result_id AND elevation IS NULL;
		IF v_count > 0 THEN
			DELETE FROM anl_node WHERE fprocesscat_id=64 and cur_user=current_user;
			INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom) 
			SELECT 64, node_id, nodecat_id, the_geom FROM rpt_inp_node WHERE result_id=v_result_id AND elevation IS NULL;
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' node''s without elevation'));
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=64 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, 'INFO: No nodes with null values on field elevation have been found');
		END IF;

		-- 0 elevation control
		SELECT count(*) INTO v_count FROM rpt_inp_node WHERE result_id=v_result_id AND elevation=0;
		IF v_count > 0 THEN
			DELETE FROM anl_node WHERE fprocesscat_id=65 and cur_user=current_user;
			INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom) 
			SELECT 65, node_id, nodecat_id, the_geom FROM rpt_inp_node WHERE result_id=v_result_id AND elevation=0;
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' node''s with elevation=0'));
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=65 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, 'INFO: No nodes with ''0'' on field elevation have been found');
		END IF;

		-- pg2epa_inlet_flowtrace control
		PERFORM pg2epa_inlet_flowtrace (v_result_id);

		SELECT count(*) FROM anl_arc WHERE fprocesscat_id=39 AND cur_user=current_user;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' arc''s totally disconnected fron any reservoir'));
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('HINT: SELECT * FROM anl_arc WHERE fprocesscat_id=39 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, 'INFO: No results found for pipes and nodes disconected from inlets');
		END IF;


		-- node2arcs with more than two arcs
		DELETE FROM anl_node WHERE fprocesscat_id=66 and cur_user=current_user;
		INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom)
		SELECT 66, count(*) as count, a.node_id FROM (SELECT node_id FROM node JOIN arc a1 ON node_id=a1.node_1
		WHERE node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user)
		UNION ALL
		SELECT node_id FROM node JOIN arc a1 ON node_id=a1.node_2
		WHERE node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user))a
		GROUP by node_id
		HAVING count(*) <> 2;

		SELECT count(*) FROM anl_node WHERE fprocesscat_id=66 AND cur_user=current_user;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' node2arc''s with more than two arcs'));
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=66 AND cur_user=current_user'));
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, 'INFO: No results found looking for node2arc''s with more than mandatory two arcs');
		END IF;

		-- node2arcs with less than two arcs
		DELETE FROM anl_node WHERE fprocesscat_id=67 and cur_user=current_user;
		INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom)
		SELECT 66, count(*) as count, a.node_id FROM (SELECT node_id FROM node JOIN arc a1 ON node_id=a1.node_1
		WHERE node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user)
		UNION ALL
		SELECT node_id FROM node JOIN arc a1 ON node_id=a1.node_2
		WHERE node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user))a
		GROUP by node_id
		HAVING count(*) <> 2;

		SELECT count(*) FROM anl_node WHERE fprocesscat_id=67 AND cur_user=current_user;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 2, concat('WARNING: There is/are ',
			v_count,' node2arc''s with less than mandatory two arcs. Perharps it is a border node2arc. Please review your data'));
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=67 AND cur_user=current_user'));
		ELSE 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, 'INFO: No results founded looking for node2arc''s with less than mandatory two arcs');
		END IF;

	
		-- timestep control (patterns used againsts timesetep simulation)
		--TODO
		
	
		IF v_demandtype > 1 THEN --(2 or 3)

			SELECT value INTO v_period FROM config_param_user WHERE parameter = 'inp_options_rtc_period_id' AND cur_user=current_user;
			SELECT code INTO v_periodval FROM ext_cat_period WHERE id=v_period::text;

			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, concat('CRM Period used: ', v_periodval));

			-- check hydrometers if exists
			SELECT count(*) INTO v_count FROM vi_parent_hydrometer;
						
			-- check hydrometer-period table
			SELECT count (*) INTO v_count_2 FROM ext_rtc_hydrometer_x_data JOIN vi_parent_hydrometer 
			USING (hydrometer_id) WHERE ext_rtc_hydrometer_x_data.cat_period_id = v_period AND sum IS NOT NULL;				
			
			IF  v_count = 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (14, v_result_id, 3, concat(
				'ERROR: There is/are not hydrometers to define the CRM period demand. Please check your hydrometer selector or simply verify if there are hydrometers on the project'));
				v_countglobal=v_countglobal+1; 
				v_count=0;
			ELSIF v_count_2 < v_count THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (14, v_result_id, 2, concat('WARNING: There is/are ', v_count, ' hydrometer(s) on current settings for user (v_rtc_hydrometer) and there are only ',
				v_count_2,' hydrometer(s) with period values from that settings on the hydrometer-period table (ext_rtc_hydrometer_x_data)'));

				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (14, v_result_id, 2, concat('HINT: SELECT hydrometer_id FROM vi_parent_hydrometer EXCEPT SELECT hydrometer_id FROM ext_rtc_hydrometer_x_data'));
				
				v_countglobal=v_countglobal+(v_count-v_count_2); 
				v_count=0;
				
			ELSIF v_count_2 = v_count  THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (14, v_result_id, 1, concat('INFO: There is/are ', v_count, ' hydrometer(s) on this exportation all of them with period flow values on the hydrometer-period table'));
				v_countglobal=v_countglobal;
				v_count=0;
			END IF;

			-- check connec - hydrometer relation
			SELECT count(*) INTO v_count FROM v_edit_connec WHERE connec_id NOT IN (SELECT connec_id FROM v_rtc_hydrometer);

			IF v_count > 0 THEN

				DELETE FROM anl_connec WHERE fprocesscat_id=60 and cur_user=current_user;
				INSERT INTO anl_connec (fprocesscat_id, connec_id, connecat_id, the_geom) 
				SELECT 60, connec_id, connecat_id, the_geom FROM v_edit_connec WHERE connec_id NOT IN (SELECT connec_id FROM v_rtc_hydrometer);

				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 2, concat('WARNING: There is/are ',v_count,' connec(s) without hydrometers. It means that vnode is generated but pattern is null and demand is null for that vnode.'));
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 2, concat('HINT: SELECT * FROM anl_connec WHERE fprocesscat_id=60 AND cur_user=current_user'));
			END IF;
		
								
			-- check dma-period table
			SELECT count(*) INTO v_count FROM vi_parent_dma JOIN v_rtc_period_dma USING (dma_id);
			SELECT count(*) INTO v_count_2 FROM (SELECT dma_id, count(*) FROM vi_parent_arc WHERE dma_id >0 GROUP BY dma_id) a;
		
			IF  v_count = 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (14, v_result_id, 2, concat('WARNING: There is not any dma''s defined on the dma-period table (ext_rtc_scada_dma_period). Please check it before continue'));
				v_countglobal=v_countglobal+1;
				v_count=0;	
			
			ELSIF v_count_2 > v_count THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (14, v_result_id, 2, concat('WARNING: There is/are ', v_count_2, 
				' dma''s on this exportation but there is/are only ',v_count,' dma''s defined on the dma-period table (ext_rtc_scada_dma_period). Please check it before continue'));
				v_countglobal=v_countglobal+v_count_2;
				v_count=0;	
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
				VALUES (14, v_result_id, 1, concat('INFO: There is/are ', v_count, ' dma''s on this exportation. The dma-period table (ext_rtc_scada_dma_period) it''s filled'));
				v_countglobal=v_countglobal;
				v_count=0;
			END IF;

			-- check for dma period, dma interval patterns
			IF v_patternmethod = 23 OR v_patternmethod = 25 THEN 			
				
				-- check if pattern is defined on dma-period table
				SELECT count(*) INTO v_count FROM vi_parent_dma JOIN v_rtc_period_dma USING (dma_id) 
				JOIN ext_rtc_scada_dma_period c ON  c.dma_id::integer=vi_parent_dma.dma_id  WHERE c.pattern_id IS NOT NULL;
				SELECT count(*) INTO v_count_2 FROM (SELECT dma_id, count(*) FROM vi_parent_arc WHERE dma_id >0 GROUP BY dma_id) a;
		
				IF  v_count = 0 THEN
					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
					VALUES (14, v_result_id, 3, concat(
					'ERROR: According with the pattern method used there are not dma''s with pattern defined on the dma-period table (ext_rtc_scada_dma_period). Please check it before continue'));
					v_countglobal=v_countglobal+1;
					v_count=0;
				ELSIF v_count_2 > v_count THEN
					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
					VALUES (14, v_result_id, 2, concat('WARNING: According with the pattern method used, there is/are ', v_count_2, 
					' dma''s on this exportation and there are only ',v_count,
					' dma''s on the dma-period table (ext_rtc_scada_dma_period) with pattern_id identified. Please check it before continue'));
				ELSE
					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
					VALUES (14, v_result_id, 1, concat(
					'INFO: According with the pattern method used, all dma''s on the dma-period table (ext_rtc_scada_dma_period) have defined pattern_id'));			
					v_countglobal=v_countglobal;
					v_count=0;
				END IF;

				-- check for unitary / volume patterns
				IF v_patternmethod = 23 THEN  -- check for unitary patterns
				
					SELECT count(*) INTO v_count FROM (
					SELECT pattern_id FROM v_rtc_period_dma JOIN inp_pattern USING (pattern_id) EXCEPT
					SELECT pattern_id FROM v_rtc_period_dma JOIN inp_pattern USING (pattern_id) WHERE pattern_type='UNITARY')a;

					IF v_count > 0 THEN

						INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
						VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,
						' volume patterns related to dma''s on this exportation. For this pattern method all the dma''s need unitary pattern'));
						INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
						VALUES (14, v_result_id, 3, concat('HINT: SELECT * FROM audit_check_data WHERE fprocesscat_id=61 AND user_name=current_user'));		
	
						DELETE FROM audit_check_data WHERE fprocesscat_id=61 and user_name=current_user;				
						INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
						SELECT 61, v_result_id, concat('Pattern used ', pattern_id, ' on some DMA is not unitary WHEN pattern method choosed requires unitary pattern') 
						FROM (SELECT pattern_id FROM v_rtc_period_hydrometer JOIN inp_pattern USING (pattern_id) EXCEPT
						SELECT pattern_id FROM v_rtc_period_hydrometer JOIN inp_pattern USING (pattern_id) WHERE pattern_type='UNITARY')a;
					ELSE 

						INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
						VALUES (14, v_result_id, 1, concat('INFO: According with the pattern method, all patterns related to dma''s on this exportation are unitary patterns.'));
					
					END IF;
				
				ELSIF v_patternmethod = 25 THEN -- check for volume patterns
				
					SELECT count(*) INTO v_count FROM (
					SELECT pattern_id FROM v_rtc_period_dma JOIN inp_pattern USING (pattern_id) EXCEPT
					SELECT pattern_id FROM v_rtc_period_dma JOIN inp_pattern USING (pattern_id) WHERE pattern_type='VOLUME')a;
					
					IF v_count > 0 THEN

						INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
						VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,
						' unitary patterns related to dma''s on this exportation. For this pattern method all the dma''s need volume pattern'));
						INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
						VALUES (14, v_result_id, 3, concat('HINT: SELECT * FROM audit_check_data WHERE fprocesscat_id=61 AND user_name=current_user'));		
	
						DELETE FROM audit_check_data WHERE fprocesscat_id=61 and user_name=current_user;				
						INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
						SELECT 61, v_result_id, concat('Pattern ',pattern_id,' used on some DMA is unitary WHEN pattern method choosed requires volume pattern') 
						FROM (SELECT pattern_id FROM v_rtc_period_hydrometer JOIN inp_pattern USING (pattern_id) EXCEPT
						SELECT pattern_id FROM v_rtc_period_hydrometer JOIN inp_pattern USING (pattern_id) WHERE pattern_type='VOLUME')a;
					ELSE
						INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
						VALUES (14, v_result_id, 1, concat('INFO: According with the pattern method, all patterns related to dma''s on this exportation are volume patterns.'));					
					END IF;
				END IF;
				
			END IF;

			-- check for node period patterns
			IF v_patternmethod = 24 OR v_patternmethod = 25 OR v_patternmethod = 26 THEN -- node period, dma interval, dma interval-node period

				-- check for unitary patterns
				SELECT count(*) INTO v_count FROM (
				SELECT pattern_id FROM v_rtc_period_hydrometer JOIN inp_pattern USING (pattern_id) EXCEPT
				SELECT pattern_id FROM v_rtc_period_hydrometer JOIN inp_pattern USING (pattern_id) WHERE pattern_type='UNITARY')a;

				IF v_count > 0 THEN

					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
					VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,
					' not unitary patterns for hydrometer on this exportation.'));
					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
					VALUES (14, v_result_id, 2, concat('HINT: SELECT * FROM audit_check_data WHERE fprocesscat_id=62 AND cur_user=current_user'));		

					DELETE FROM audit_check_data WHERE fprocesscat_id=62 and cur_user=current_user;				
					INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
					SELECT 62, v_result_id, pattern_id ,'Patterns used on hydrometer is not unitary WHEN pattern method choosed requires unitary pattern' 
					FROM (SELECT pattern_id FROM v_rtc_period_hydrometer JOIN inp_pattern USING (pattern_id) EXCEPT
					SELECT pattern_id FROM v_rtc_period_hydrometer JOIN inp_pattern USING (pattern_id) WHERE pattern_type='UNITARY')a;
				ELSE
					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
					VALUES (14, v_result_id, 1, concat('INFO: According with the pattern method, all patterns related to hydrometer''s on this exportation are unitary patterns.'));
				END IF;
				

				-- check if pattern is defined on hydrometer-pattern tables
				SELECT count (*) INTO v_count FROM ext_rtc_hydrometer_x_data a JOIN vi_parent_hydrometer USING (hydrometer_id) WHERE a.cat_period_id = v_period AND sum IS NOT NULL;				
				SELECT count (*) INTO v_count_2 FROM ext_rtc_hydrometer_x_data a JOIN vi_parent_hydrometer USING (hydrometer_id) WHERE a.cat_period_id = v_period AND sum IS NOT NULL AND a.pattern_id IS not NULL;	
			
				IF  v_count_2 = 0 THEN
					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
					VALUES (14, v_result_id, 3, concat(
					'ERROR: By using this pattern method, hydrometers''s must be defined with pattern on the hydrometer-period table (ext_rtc_hydrometer_x_data). Please check it before continue'));
					v_countglobal=v_countglobal+1;
					v_count=0;
				ELSIF v_count > v_count_2 THEN
					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
					VALUES (14, v_result_id, 2, concat('WARNING: There is/are ', v_count, ' hydrometers''s with volume but only', v_count_2,
					' with defined pattern on on the hydrometer-period table (ext_rtc_hydrometer_x_data). Please check it before continue'));
				ELSE
					INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
					VALUES (14, v_result_id, 1, concat(
					'INFO: All the hydrometers are well-configured with volume and pattern on the the hydrometer-period table (ext_rtc_hydrometer_x_data)'));			
					v_countglobal=v_countglobal;
					v_count=0;
				END IF;

			END IF;
	
		END IF;
		
		IF v_networkmode = 3 OR v_networkmode = 4 THEN
	
			-- vnode over nodarc for case of use vnode treaming arcs on network model
			SELECT count(vnode_id) INTO v_count FROM rpt_inp_arc , vnode JOIN v_edit_link a ON vnode_id=exit_id::integer
			WHERE st_dwithin ( rpt_inp_arc.the_geom, vnode.the_geom, 0.01) AND vnode.state > 0 AND arc_type = 'NODE2ARC'
			AND result_id=v_result_id;

			IF v_count > 0 THEN

				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 2, concat('WARNING: There is/are ',v_count,
				' vnode(s) over node2arc features. This is an important inconsistency with vnode and treamed arcs. Reduce the nodarc length or check the vnodes affected in order to redraw it.'));
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 2, concat('HINT: SELECT * FROM anl_node WHERE fprocesscat_id=59 AND cur_user=current_user'));		

				DELETE FROM anl_node WHERE fprocesscat_id=59 and cur_user=current_user;				
				INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, state, expl_id, the_geom, result_id, descript)
				SELECT 59, vnode_id, 'VNODE', 1, rpt_inp_arc.expl_id, vnode.the_geom, v_result_id, 'Vnode overlaping nodarcs'  
				FROM rpt_inp_arc , vnode JOIN v_edit_link a ON vnode_id=exit_id::integer
				WHERE st_dwithin ( rpt_inp_arc.the_geom, vnode.the_geom, 0.01) AND vnode.state > 0 AND arc_type = 'NODE2ARC'
				AND result_id=v_result_id;
				
				v_countglobal=v_countglobal+v_count; 
				v_count=0;	
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: Vnodes checked. There is/are not vnodes over nodarcs');
			END IF;
		ELSE
			-- check if demand type for connec is used
			IF v_patternmethod = 14  OR v_patternmethod = 27 THEN 
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: The pattern method used, ',v_patternmethodval,' it is incompatible with the export network mode used, ',v_networkmodeval)); 
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, 'HINT: Change the pattern method using some of the CONNEC method avaliable or change export network USING some of TRIMED ARCS method avaliable');
			END IF;		
		END IF;
				
		--WS check and set value default
				
		-- Check cat_mat_roughness catalog
		SELECT count(*) INTO v_count FROM inp_cat_mat_roughness WHERE init_age IS NULL or end_age IS NULL or roughness IS NULL;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 2, concat('WARNING: There is/are ',v_count,
			' material(s) with null values at least on mandatory columns for Roughness catalog (init_age,end_age,roughness). Perharps are not used but check it before continue'));
			v_countglobal=v_countglobal+v_count; 
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1,  'INFO: Roughness catalog checked. No mandatory values missed');
		END IF;
		
		-- check roughness inconsistency in function of headloss formula used
		v_min = (SELECT min(roughness) FROM inp_cat_mat_roughness);
		v_max = (SELECT max(roughness) FROM inp_cat_mat_roughness);
		v_headloss = (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter='inp_options_headloss');
			
		IF v_headloss = 'D-W' AND (v_min < 0.0025 AND v_max > 0.15) THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 2, concat(
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula D-W (0.0025-0.15) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,')'));
				v_countglobal=v_countglobal+1; 
			
		ELSIF v_headloss = 'H-W' AND (v_min < 110 AND v_max > 150) THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 	
				VALUES (14, v_result_id, 2, concat(
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula h-W (110-150) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,')'));
				v_countglobal=v_countglobal+1; 
			
		ELSIF v_headloss = 'C-M' AND (v_min < 0.011 AND v_max > 0.017) THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 2, concat(
				'WARNING: There is/are at least one value of roughnesss out of range using headloss formula C-M (0.011-0.017) acording EPANET user''s manual. Current values, minimum:(',v_min,'), maximum:(',v_max,')'));
				v_countglobal=v_countglobal+1; 	
		ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, concat(
				'INFO: Roughness values have been checked againts head-loss formula using the minimum and maximum EPANET user''s manual values. Any out-of-range values have been detected'));
				v_countglobal=v_countglobal+1; 	
			
		END IF;
			
		
		-- Check conected nodes but with closed valves -->force to put values of demand on '0'	
		-- TODO
		
		-- tanks
		SELECT count(*) INTO v_count FROM inp_tank JOIN rpt_inp_node ON inp_tank.node_id=rpt_inp_node.node_id 
		WHERE (((initlevel IS NULL) OR (minlevel IS NULL) OR (maxlevel IS NULL) OR (diameter IS NULL) OR (minvol IS NULL)) AND result_id=v_result_id);
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat(
				'ERROR: There is/are ',v_count,' tank(s) with null values at least on mandatory columns for tank (initlevel, minlevel, maxlevel, diameter, minvol)'));
				v_countglobal=v_countglobal+v_count;
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: Tanks checked. No mandatory values missed');
			END IF;	
		
		
		-- valve
		SELECT count(*) INTO v_count FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type IS NULL) OR (inp_valve.status IS NULL) OR (to_arc IS NULL)) AND result_id=v_result_id;

			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat(
				'ERROR: There is/are ',v_count,' valve(s) with null values at least on mandatory columns for valve (valv_type, status, to_arc)'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: Valve status checked. No mandatory values missed');
			END IF;
		

		SELECT count(*) INTO v_count FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='PBV' OR valv_type='PRV' OR valv_type='PSV') AND (pressure IS NULL)) AND result_id=v_result_id;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat(
				'ERROR: There is/are ',v_count,' PBV-PRV-PSV valve(s) with null values at least on mandatory on the mandatory column for Pressure valves'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: PBC-PRV-PSV valves checked. No mandatory values missed');
			END IF;				
	
		SELECT count(*) INTO v_count FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='GPV') AND (curve_id IS NULL)) AND result_id=v_result_id;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat(
				'ERROR: There is/are ',v_count,' GPV valve(s) with null values at least on mandatory on the mandatory column for General purpose valves'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: GPV valves checked. No mandatory values missed');
			END IF;	

		SELECT count(*) INTO v_count FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='TCV')) AND result_id=v_result_id;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' TCV valve(s) with null values at least on mandatory column for Losses Valves'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: TCV valves checked. No mandatory values missed');
			END IF;				

		SELECT count(*) INTO v_count FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='FCV') AND (flow IS NULL)) AND result_id=v_result_id;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' FCV valve(s) with null values at least on mandatory column for Flow Control Valves'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: FCV valves checked. No mandatory values missed');
			END IF;				
					
		-- pumps
		SELECT count(*) INTO v_count FROM inp_pump JOIN rpt_inp_arc ON concat(node_id, '_n2a') = arc_id 
		WHERE ((curve_id IS NULL) OR (inp_pump.status IS NULL) OR (to_arc IS NULL)) AND result_id=v_result_id;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' pump(s) with null values at least on mandatory columns for pump (curve_id, status, to_arc)'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: Pumps checked. No mandatory values missed');
			END IF;	
		
		SELECT count(*) INTO v_count FROM inp_pump_additional JOIN rpt_inp_arc ON concat(node_id, '_n2a') = arc_id 
		WHERE ((curve_id IS NULL) OR (inp_pump_additional.status IS NULL)) AND result_id=v_result_id;
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result_id, 3, concat(
				'ERROR: There is/are ',v_count,' additional pump(s) with null values at least on mandatory columns for additional pump (curve_id, status)'));
				v_countglobal=v_countglobal+v_count; 
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, 'INFO: Additional pumps checked. No mandatory values missed');
			END IF;	
	END IF;
	
	
	-- info data analysis
	IF v_project_type  = 'UD' THEN
		SELECT min(length), max(length) INTO v_min, v_max FROM vi_conduits;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for conduit length. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));

		SELECT min(n), max(n) INTO v_min, v_max FROM vi_conduits;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for conduit manning roughness coeficient. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));

		SELECT min(z1), max(z1) INTO v_min, v_max FROM vi_conduits;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for conduit z1. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));
		
		SELECT min(z2), max(z2) INTO v_min, v_max FROM vi_conduits;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for conduit z2. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));
	
		SELECT min(slope), max(slope) INTO v_min, v_max FROM v_edit_arc WHERE sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user);
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for conduit slope. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));
		
		SELECT min(sys_elev), max(sys_elev) INTO v_min, v_max FROM v_edit_node WHERE sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user);
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));
	
	ELSE
		SELECT min(elevation), max(elevation) INTO v_min, v_max FROM v_edit_node WHERE sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user);
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));
	
		SELECT min(length), max(length) INTO v_min, v_max FROM vi_pipes;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for pipe length. Minimun and maximum values are: (',v_min,' - ',v_max,' )'));
	
		SELECT min(diameter), max(diameter) INTO v_min, v_max FROM vi_pipes;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for pipe diameter. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));
	
		SELECT min(roughness), max(roughness) INTO v_min, v_max FROM vi_pipes;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, concat('Data analysis for pipe roughness. Minimun and maximum values are: ( ',v_min,' - ',v_max,' )'));
	
	END IF;
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 1, '');	
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=14 order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=14 AND result_id=v_result_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');

	--lines
	--frpocesscat_id=39 gets arcs without source of water
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND (fprocesscat_id=39 OR fprocesscat_id=14) AND result_id=v_result_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "values":',v_result, '}');


	--polygons
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, pol_id, pol_type, state, expl_id, descript, the_geom FROM anl_polygon WHERE cur_user="current_user"() AND fprocesscat_id=14 AND result_id=v_result_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_polygon = concat ('{"geometryType":"Polygon", "values":',v_result, '}');


	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=14;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=14 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (14, current_user);
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
