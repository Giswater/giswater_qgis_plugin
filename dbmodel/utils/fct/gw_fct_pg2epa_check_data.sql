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
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"parameters":{"resultId":"test1"},"saveOnDatabase":true}}$$)
*/

DECLARE
valve_rec		record;
count_global_aux	integer;
rec_var			record;
setvalue_int		int8;
v_project_type 		text;
count_aux		integer;
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

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_saveondatabase :=  ((p_data ->>'data')::json->>'saveOnDatabase')::boolean;
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;

	-- select config values
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;

	-- call go2epa function in case of new result
	IF (SELECT result_id FROM rpt_cat_result WHERE result_id=v_result_id) IS NULL THEN	
		IF v_project_type = 'WS' THEN
			PERFORM gw_fct_pg2epa(  v_result_id, false, false);
		ELSE
			PERFORM gw_fct_pg2epa(  v_result_id, false, false, false);
		END IF;
	END IF;
		
	SELECT st_length(a.the_geom), a.arc_id INTO v_min_node2arc, v_arc FROM v_edit_arc a JOIN rpt_inp_arc b ON a.arc_id=b.arc_id WHERE result_id=v_result_id ORDER BY 1 asc LIMIT 1;

	-- init variables
	count_aux=0;
	count_global_aux=0;	

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=14 AND result_id=v_result_id AND user_name=current_user;
	DELETE FROM anl_arc WHERE fprocesscat_id=14 AND result_id=v_result_id AND cur_user=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id=14 AND result_id=v_result_id AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (14, v_result_id, concat('NETWORK DATA ANALYSIS ACORDING EPA RULES'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (14, v_result_id, concat('-------------------------------------------------------'));
	
	-- UTILS
	-- Check orphan nodes
	FOR rec_var IN SELECT * FROM rpt_inp_node WHERE result_id=v_result_id AND node_id NOT IN (SELECT node_1 FROM rpt_inp_arc WHERE result_id=v_result_id UNION SELECT node_2 FROM rpt_inp_arc WHERE result_id=v_result_id)
	LOOP
		count_aux=count_aux+1;
		INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, state, expl_id, the_geom, result_id, descript)
		VALUES (14, rec_var.node_id, rec_var.nodecat_id,  rec_var.state, rec_var.expl_id, rec_var.the_geom, v_result_id, 'Node orphan');
		count_global_aux=count_global_aux+count_aux;		
	END LOOP;

	IF count_aux > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' node(s) orphan. Take a look on temporal table to know details'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
		VALUES (14, v_result_id, 'INFO: There are no nodes orphan');
	END IF;

	-- Check arcs without start/end node
	v_querytext = '	SELECT 14, arc_id, arccat_id,  state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arc with node_1 not present in the exportation'' 
			FROM rpt_inp_arc where result_id = '||quote_literal(v_result_id)||' AND node_1 NOT IN (SELECT node_id FROM rpt_inp_node where result_id='||quote_literal(v_result_id)||')
			UNION 
			SELECT 14, arc_id, arccat_id, state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arc with node_2 not present in the exportation'' 
			FROM rpt_inp_arc where result_id = '||quote_literal(v_result_id)||' AND node_2 NOT IN (SELECT node_id FROM rpt_inp_node where result_id='||quote_literal(v_result_id)||')';


	EXECUTE 'SELECT count(*) FROM ('||v_querytext ||')a'
		INTO count_aux;

	EXECUTE 'INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, state, expl_id, the_geom, result_id, descript)'||v_querytext;

	IF count_aux > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' arc(s) without start/end nodes. Take a look on temporal table to know details'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
		VALUES (14, v_result_id, 'INFO: There are no arcs without start/end nodes');
	END IF;
		
	-- only UD projects
	IF 	v_project_type='UD' THEN

		SELECT hydrology_id INTO scenario_aux FROM inp_selector_hydrology WHERE cur_user=current_user;
	
		-- check common mistakes
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment WHERE node_id is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column node_id column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where rg_id is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column rg_id column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where area is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column area column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where width is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column width column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;
		
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where slope is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column slope column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where clength is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column clength column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where nimp is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column nimp column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;
		
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where nperv is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column nperv column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where simp is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column simp column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where sperv is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column sperv column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;
		
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where zero is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column zero column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where routeto is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column routeto column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where rted is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory column rted column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT infiltration INTO infiltration_aux FROM cat_hydrology JOIN inp_selector_hydrology
		ON inp_selector_hydrology.hydrology_id=cat_hydrology.hydrology_id WHERE cur_user=current_user;
		
		IF infiltration_aux='CURVE NUMBER' THEN
		
			SELECT count(*) INTO count_aux FROM v_edit_subcatchment where (curveno is null) 
			OR (conduct_2 is null) OR (drytime_2 is null);
			
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory columns of curve number infiltartion method (curveno, conduct_2, drytime_2)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;
		
		ELSIF infiltration_aux='GREEN_AMPT' THEN
		
			SELECT count(*) INTO count_aux FROM v_edit_subcatchment where (suction is null) 
			OR (conduct_¡ is null) OR (initdef is null);
			
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory columns of Green-Apt infiltartion method (suction....)'));
				count_global_aux=count_global_aux+count_aux;
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;
		
		
		ELSIF infiltration_aux='HORTON' OR infiltration_aux='MODIFIED_HORTON' THEN
		
			SELECT count(*) INTO count_aux FROM v_edit_subcatchment where (maxrate is null) 
			OR (minrate is null) OR (decay is null) OR (drytime is null) OR (maxinfil is null);
			
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' subcatchment(s) with null values on mandatory columns of Horton/Horton modified infiltartion method (maxrate, minrate, decay, drytime, maxinfil)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;
			
		END IF;
		
		
		SELECT count(*) INTO count_aux FROM v_edit_raingage 
		where (form_type is null) OR (intvl is null) OR (rgage_type is null);
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' raingage(s) with null values at least on mandatory columns for rain type (form_type, intvl, rgage_type)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;		
			
		SELECT count(*) INTO count_aux FROM v_edit_raingage where rgage_type='TIMESERIES' AND timser_id IS NULL;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' raingage(s) with null values on the mandatory column for timeseries raingage type'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;		

		SELECT count(*) INTO count_aux FROM v_edit_raingage where rgage_type='FILE' AND (fname IS NULL) or (sta IS NULL) or (units IS NULL);
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' raingage(s) with null values at least on mandatory columns for file raingage type (fname, sta, units)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;				

	ELSIF v_project_type='WS' THEN

		SELECT dscenario_id INTO scenario_aux FROM inp_selector_dscenario WHERE cur_user=current_user;
		
		-- nod2arc control
		v_nodearc_real = (SELECT st_length (the_geom) FROM rpt_inp_arc WHERE  arc_type='NODE2ARC' AND result_id=v_result_id LIMIT 1);
		v_nodearc_user = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_nodarc_length' AND cur_user=current_user);
		
		IF  v_nodearc_user > (v_nodearc_real+0.01) THEN 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message)
			VALUES (14, v_result_id, concat('WARNING: The node2arc parameter have been modified from ', v_nodearc_user::numeric(12,3), ' to ', v_nodearc_real::numeric(12,3), ' in order to prevent length conflicts'));
		ELSE 
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message)
			VALUES (14, v_result_id, concat('INFO: The node2arc parameter is ok for the whole analysis. Current value:', v_nodearc_user::numeric(12,3)));
		END IF;
		
		--WS check and set value default
				
		-- Check cat_mat_roughness catalog
		SELECT count(*) INTO count_aux FROM inp_cat_mat_roughness WHERE init_age IS NULL or end_age IS NULL or roughness IS NULL;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' material(s) with null values at least on mandatory columns for Roughness catalog (init_age,end_age,roughness)'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
			VALUES (14, v_result_id, 'INFO: Materials checked. No mandadoty values missed');
		END IF;	
		
		-- Check conected nodes but with closed valves -->force to put values of demand on '0'	
		-- TODO
		
		-- tanks
		SELECT count(*) INTO count_aux FROM inp_tank JOIN rpt_inp_node ON inp_tank.node_id=rpt_inp_node.node_id 
		WHERE (((initlevel IS NULL) OR (minlevel IS NULL) OR (maxlevel IS NULL) OR (diameter IS NULL) OR (minvol IS NULL)) AND result_id=v_result_id);
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' tank(s) with null values at least on mandatory columns for tank (initlevel, minlevel, maxlevel, diameter, minvol)'));
				count_global_aux=count_global_aux+count_aux;
				count_aux=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, 'INFO: Tanks checked. No mandadoty values missed');
			END IF;	
		
		
		-- valve
		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type IS NULL) OR (inp_valve.status IS NULL) OR (to_arc IS NULL)) AND result_id=v_result_id;

			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' valve(s) with null values at least on mandatory columns for valve (valv_type, status, to_arc)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, 'INFO: Valve status checked. No mandadoty values missed');
			END IF;
		

		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='PBV' OR valv_type='PRV' OR valv_type='PSV') AND (pressure IS NULL)) AND result_id=v_result_id;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' PBV-PRV-PSV valve(s) with null values at least on mandatory on the mandatory column for Pressure valves'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, 'INFO: PBC-PRV-PSV valves checked. No mandadoty values missed');
			END IF;				
	
		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='GPV') AND (curve_id IS NULL)) AND result_id=v_result_id;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' GPV valve(s) with null values at least on mandatory on the mandatory column for General purpose valves'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, 'INFO: GPV valves checked. No mandadoty values missed');
			END IF;	

		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='TCV')) AND result_id=v_result_id;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' TCV valve(s) with null values at least on mandatory column for Losses Valves'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, 'INFO: TCV valves checked. No mandadoty values missed');
			END IF;				

		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='FCV') AND (flow IS NULL)) AND result_id=v_result_id;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' FCV valve(s) with null values at least on mandatory column for Flow Control Valves'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, 'INFO: FCV valves checked. No mandadoty values missed');
			END IF;				
					
		-- pumps
		SELECT count(*) INTO count_aux FROM inp_pump JOIN rpt_inp_arc ON concat(node_id, '_n2a') = arc_id 
		WHERE ((curve_id IS NULL) OR (inp_pump.status IS NULL) OR (to_arc IS NULL)) AND result_id=v_result_id;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' pump(s) with null values at least on mandatory columns for pump (curve_id, status, to_arc)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, 'INFO: Pumps checked. No mandadoty values missed');
			END IF;	
		
		SELECT count(*) INTO count_aux FROM inp_pump_additional JOIN rpt_inp_arc ON concat(node_id, '_n2a') = arc_id 
		WHERE ((curve_id IS NULL) OR (inp_pump_additional.status IS NULL)) AND result_id=v_result_id;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result_id, concat('WARNING: There are ',count_aux,' additional pump(s) with null values at least on mandatory columns for additional pump (curve_id, status)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
				VALUES (14, v_result_id, 'INFO: Additional pumps checked. No mandadoty values missed');
			END IF;	
	END IF;
	
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT * FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=14 AND result_id=v_result_id) row; 
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
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
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
