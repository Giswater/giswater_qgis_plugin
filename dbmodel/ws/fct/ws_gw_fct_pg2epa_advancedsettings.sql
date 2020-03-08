/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2798

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_advancedsettings(p_result text)
RETURNS integer 
AS $BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa_advancedsettings('t1')
*/

DECLARE

v_reservoir json;
v_tank json;
v_junction json;
v_pipe json;
v_pump json;
v_valve json;
v_headloss text;


BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get user variables
	SELECT ((value::json->>'parameters')::json->>'valve')::json INTO v_valve FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'reservoir')::json INTO v_reservoir FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'pipe')::json INTO v_pipe FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'tank')::json INTO v_tank FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'pump')::json INTO v_pump FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'junction')::json INTO v_junction FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT value INTO v_headloss FROM config_param_user WHERE parameter = 'inp_options_headloss' AND cur_user=current_user;	

	RAISE NOTICE '% % % % %', v_valve, v_reservoir, v_pipe, v_tank, v_pump;

	-- update values for valves
	UPDATE rpt_inp_arc SET minorloss = (v_valve->>'minorloss')::float WHERE epa_type='VALVE' AND (minorloss = 0 OR minorloss is null) AND result_id  = p_result;
	UPDATE rpt_inp_arc SET roughness = ((v_valve->>'roughness')::json->>v_headloss)::float	WHERE epa_type='VALVE' AND (roughness = 0 OR roughness is null) AND result_id  = p_result;
	UPDATE rpt_inp_arc SET length = (v_valve->>'length')::float WHERE epa_type='VALVE' WHERE result_id  = p_result;
	UPDATE rpt_inp_arc SET diameter = (v_valve->>'diameter')::float WHERE epa_type='VALVE' AND (diameter = 0 OR diameter is null) AND result_id  = p_result;

	
	-- update values for reservoirs
	UPDATE rpt_inp_node SET elevation = elevation + (v_reservoir->>'addElevation')::float WHERE epa_type='RESERVOIR' AND result_id  = p_result;

	-- update values for reservoirs
	UPDATE rpt_inp_node SET elevation = elevation + (v_tank->>'addElevation')::float WHERE epa_type='TANK' AND result_id  = p_result;

	-- update values for pumps
	UPDATE rpt_inp_arc SET length = (v_pump->>'length')::float, diameter = (v_pump ->>'diameter')::float, roughness = ((v_pump->>'roughness')::json->>v_headloss)::float 
	WHERE epa_type='PUMP' AND result_id = p_result;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
