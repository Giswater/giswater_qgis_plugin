/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2430

drop FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_check_data(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},
"data":{"parameters":{"resultId":"test1"},
	"saveOnDatabase":true}}$$)
*/

DECLARE
valve_rec		record;
count_global_aux	integer;
rec_var			record;
setvalue_int		int8;
project_type_aux 	text;
count_aux		integer;
infiltration_aux	text;
rgage_rec		record;
scenario_aux		text;
v_min_node2arc		float;
v_arc			text;
v_saveondatabase 	boolean;
v_result 		text;
v_version		text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_saveondatabase :=  ((p_data ->>'data')::json->>'saveOnDatabase')::boolean;
	v_result := ((p_data ->>'data')::json->>'parameters')::json->>'resultId';

	-- select config values
	SELECT wsoftware, giswater  INTO project_type_aux, v_version FROM version order by 1 desc limit 1;
	
	SELECT st_length(a.the_geom), a.arc_id INTO v_min_node2arc, v_arc FROM v_edit_arc a JOIN rpt_inp_arc b ON a.arc_id=b.arc_id WHERE result_id=v_result ORDER BY 1 asc LIMIT 1;

	raise notice 'nodearc %, arc %', v_min_node2arc, v_arc;

	-- init variables
	count_aux=0;
	count_global_aux=0;	

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=14 AND result_id=v_result;

	
	-- Starting process
	
	-- UTILS
	-- Check disconnected nodes (14)
	FOR rec_var IN SELECT * FROM rpt_inp_node WHERE result_id=v_result AND node_id NOT IN 
	(SELECT node_1 FROM rpt_inp_arc WHERE result_id=v_result UNION SELECT node_2 FROM rpt_inp_arc WHERE result_id=v_result)
	LOOP
		count_aux=count_aux+1;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
		VALUES (14, v_result, rec_var.node_id, 'node', 'Node is disconnected');
		count_global_aux=count_global_aux+count_aux;
		
	END LOOP;

	-- Check arcs with nodes not in node table
	INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
	
	SELECT 14, v_result, node_1, 'node', 'Arc with node not present in the exportation' 
		FROM rpt_inp_arc where result_id=v_result AND node_1 NOT IN (SELECT node_id FROM rpt_inp_node where result_id=v_result)
	UNION 
	SELECT 14, v_result, node_2, 'node', 'Arc with node not present in the exportation' 
		FROM rpt_inp_arc where result_id=v_result AND node_2 NOT IN (SELECT node_id FROM rpt_inp_node where result_id=v_result);

			
	-- only UD projects
	IF 	project_type_aux='UD' THEN

		SELECT hydrology_id INTO scenario_aux FROM inp_selector_hydrology WHERE cur_user=current_user;
	
		--Set value default
		UPDATE inp_outfall SET outfall_type=(SELECT value FROM config_param_user WHERE parameter='epa_outfall_type_vdefault' AND cur_user=current_user) WHERE outfall_type IS NULL;
		UPDATE inp_conduit SET q0=(SELECT value FROM config_param_user WHERE parameter='epa_conduit_q0_vdefault' AND cur_user=current_user)::float WHERE q0 IS NULL;
		UPDATE inp_conduit SET barrels=(SELECT value FROM config_param_user WHERE parameter='epa_conduit_barrels_vdefault' AND cur_user=current_user)::integer WHERE barrels IS NULL;
		UPDATE inp_junction SET y0=(SELECT value FROM config_param_user WHERE parameter='epa_junction_y0_vdefault' AND cur_user=current_user)::float WHERE y0 IS NULL;
		UPDATE raingage SET scf=(SELECT value FROM config_param_user WHERE parameter='epa_rgage_scf_vdefault' AND cur_user=current_user)::float WHERE scf IS NULL;
				

		-- check common mistakes
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment WHERE node_id is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','node_id', concat('There are ',count_aux,' with null values on node_id column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where rg_id is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','rg_id', concat('There are ',count_aux,' with null values on rg_id column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where area is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','area', concat('There are ',count_aux,' with null values on area column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where width is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','width', concat('There are ',count_aux,' with null values on width column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;
		
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where slope is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','slope', concat('There are ',count_aux,' with null values on slope column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where clength is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','clength', concat('There are ',count_aux,' with null values on clength column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where nimp is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','nimp', concat('There are ',count_aux,' with null values on nimp column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;
		
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where nperv is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','nperv', concat('There are ',count_aux,' with null values on nperv column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where simp is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','simp', concat('There are ',count_aux,' with null values on simp column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where sperv is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','sperv', concat('There are ',count_aux,' with null values on sperv column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;
		
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where zero is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','zero', concat('There are ',count_aux,' with null values on zero column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where routeto is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','routeto', concat('There are ',count_aux,' with null values on routeto column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		
		SELECT count(*) INTO count_aux FROM v_edit_subcatchment where rted is null;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Subcatchments','rted', concat('There are ',count_aux,' with null values on rted column'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;

		SELECT infiltration INTO infiltration_aux FROM cat_hydrology JOIN inp_selector_hydrology
		ON inp_selector_hydrology.hydrology_id=cat_hydrology.hydrology_id WHERE cur_user=current_user;
		
		IF infiltration_aux='CURVE NUMBER' THEN
		
			SELECT count(*) INTO count_aux FROM v_edit_subcatchment where (curveno is null) 
			OR (conduct_2 is null) OR (drytime_2 is null);
			
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Subcatchments','Various', concat('There are ',count_aux,' with null values on curve number infiltartion method columns (curveno, conduct_2, drytime_2)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;
		
		ELSIF infiltration_aux='GREEN_AMPT' THEN
		
			SELECT count(*) INTO count_aux FROM v_edit_subcatchment where (suction is null) 
			OR (conduct_¡ is null) OR (initdef is null);
			
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Subcatchments','Various', concat('There are ',count_aux,' with null values on curve number infiltartion method columns (curveno, conduct_2, drytime_2)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;
		
		
		ELSIF infiltration_aux='HORTON' OR infiltration_aux='MODIFIED_HORTON' THEN
		
			SELECT count(*) INTO count_aux FROM v_edit_subcatchment where (maxrate is null) 
			OR (minrate is null) OR (decay is null) OR (drytime is null) OR (maxinfil is null);
			
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Subcatchments','Various', concat('There are ',count_aux,' with null values on Horton/Horton modified infiltartion method columns (maxrate, minrate, decay, drytime, maxinfil)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;
			
		END IF;
		
		
		SELECT count(*) INTO count_aux FROM v_edit_raingage 
		where (form_type is null) OR (intvl is null) OR (rgage_type is null);
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Raingage','Various', concat('There are ',count_aux,' with null values on mandatory columns (form_type, intvl, rgage_type)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;		
			
		SELECT count(*) INTO count_aux FROM v_edit_raingage where rgage_type='TIMESERIES' AND timser_id IS NULL;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Raingage','timser_id', concat('There are ',count_aux,' with null values on the mandatory column for timeseries raingage type'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;		

		SELECT count(*) INTO count_aux FROM v_edit_raingage where rgage_type='FILE' AND (fname IS NULL) or (sta IS NULL) or (units IS NULL);
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Raingage','Various', concat('There are ',count_aux,' with null values on mandatory columns for file raingage type (fname, sta, units)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;				

	ELSIF project_type_aux='WS' THEN

		SELECT dscenario_id INTO scenario_aux FROM inp_selector_dscenario WHERE cur_user=current_user;
		
		-- nod2arc control
		IF (SELECT node2arc FROM config LIMIT 1) >  v_min_node2arc THEN 
			PERFORM audit_function(3010,2430,v_min_node2arc::numeric(12,3)::text) ;
		END IF;
		
		--WS check and set value default
		-- nothing
		
		-- Check cat_mat_roughness catalog
		SELECT count(*) INTO count_aux FROM inp_cat_mat_roughness WHERE init_age IS NULL or end_age IS NULL or roughness IS NULL;
		IF count_aux > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
			VALUES (14, v_result,'Roughness Catalog','Various', concat('There are ',count_aux,' with null values on mandatory columns for Roughness catalog (init_age,end_age,roughness)'));
			count_global_aux=count_global_aux+count_aux; 
			count_aux=0;
		END IF;	
		
		-- Check conected nodes but with closed valves -->force to put values of demand on '0'	
		-- TODO
		
				
		-- tanks
		SELECT count(*) INTO count_aux FROM inp_tank JOIN rpt_inp_node ON inp_tank.node_id=rpt_inp_node.node_id 
		WHERE (((initlevel IS NULL) OR (minlevel IS NULL) OR (maxlevel IS NULL) OR (diameter IS NULL) OR (minvol IS NULL)) AND result_id=v_result);
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result, 'Various', 'Tank', concat('There are ',count_aux,' with null values on mandatory columns for tank (initlevel, minlevel, maxlevel, diameter, minvol)'));
				count_global_aux=count_global_aux+count_aux;
				count_aux=0;
			END IF;	
		
		
		-- valve
		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type IS NULL) OR (inp_valve.status IS NULL) OR (to_arc IS NULL)) AND result_id=v_result;

			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result, 'Various', 'Valve', concat('There are ',count_aux,' with null values on mandatory columns for valve (valv_type, status, to_arc)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;
		

		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='PBV' OR valv_type='PRV' OR valv_type='PSV') AND (pressure IS NULL)) AND result_id=v_result;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Various','PBV-PRV-PSV Valves', concat('There are ',count_aux,' with null values on the mandatory column for Pressure valves'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;				
	
		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='GPV') AND (curve_id IS NULL)) AND result_id=v_result;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Various','GPV Valves', concat('There are ',count_aux,' with null values on the mandatory column for General purpose valves'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;	

		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='TCV')) AND result_id=v_result;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Various','TCV Valves', concat('There are ',count_aux,' with null values on the mandatory column for Losses Valves'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;				

		SELECT count(*) INTO count_aux FROM inp_valve JOIN rpt_inp_arc ON concat(node_id, '_n2a')=arc_id 
		WHERE ((valv_type='FCV') AND (flow IS NULL)) AND result_id=v_result;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Various','FCV Valves', concat('There are ',count_aux,' with null values on the mandatory column for Flow Control Valves'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;				
					
		-- pumps
		SELECT count(*) INTO count_aux FROM inp_pump JOIN rpt_inp_arc ON concat(node_id, '_n2a') = arc_id 
		WHERE ((curve_id IS NULL) OR (inp_pump.status IS NULL) OR (to_arc IS NULL)) AND result_id=v_result;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Various','Pump', concat('There are ',count_aux,' with null values on mandatory columns for pump (curve_id, status, to_arc)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;	
		
		SELECT count(*) INTO count_aux FROM inp_pump_additional JOIN rpt_inp_arc ON concat(node_id, '_n2a') = arc_id 
		WHERE ((curve_id IS NULL) OR (inp_pump_additional.status IS NULL)) AND result_id=v_result;
			IF count_aux > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
				VALUES (14, v_result,'Various','Additional pumps', concat('There are ',count_aux,' with null values on mandatory columns for additional pump (curve_id, status)'));
				count_global_aux=count_global_aux+count_aux; 
				count_aux=0;
			END IF;	
	END IF;
	
	
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=14) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=14;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=14 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (14, current_user);
	END IF;
		
	--    Control nulls
	v_result := COALESCE(v_result, '[]'); 
	
--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"result":' || v_result ||
			     '}'||
		       '}'||
	    '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
