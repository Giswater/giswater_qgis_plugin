/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2798

CREATE OR REPLACE FUNCTION ws.gw_fct_pg2epa_advancedsettings(p_result text)
RETURNS integer 
AS $BODY$

/*example
SELECT ws.gw_fct_pg2epa_advancedsettings($${"client":{"device":3, "infoType":100, "lang":"ES"},"data":{"resultId":"t12", "useNetworkGeom":"false"}}$$)
*/

DECLARE

v_reservoir json;
v_tank json;
v_junction json;
v_pipe json;
v_pump json;
v_valve json;
v_headloss text;
v_pumproughness float;


BEGIN

	--  Search path
	SET search_path = "ws", public;

	-- get user variables
	SELECT ((value::json->>'parameters')::json->>'valve')::json INTO v_valve FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'reservoir')::json INTO v_reservoir FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'pipe')::json INTO v_pipe FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'tank')::json INTO v_tank FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'pump')::json INTO v_pump FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'junction')::json INTO v_junction FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT value INTO v_headloss FROM config_param_user WHERE parameter = 'inp_options_headloss' AND cur_user=current_user;	

	UPDATE rpt_inp_arc SET minorloss = (v_valve->>'minorloss')::float WHERE epa_type='VALVE' AND minorloss = 0 AND result_id  = p_result;

	-- update elevation for reservoirs and tanks
	UPDATE rpt_inp_node SET elevation = elevation + (v_reservoir->>'addElevation')::float WHERE epa_type='RESERVOIR' AND result_id  = p_result;
	UPDATE rpt_inp_node SET elevation = elevation + (v_tank->>'addElevation')::float WHERE epa_type='TANK' AND result_id  = p_result;

	-- update values for pumps
	v_pumproughness = (v_pump->>quote_literal(v_headloss))::float;
	UPDATE rpt_inp_arc SET length = (v_pump->>'length')::float, diameter = (v_pump ->>'diameter')::float, roughness = v_pumproughness WHERE epa_type='PUMP' AND result_id  = p_result;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
