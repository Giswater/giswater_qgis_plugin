/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2798

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_advancedsettings(p_result text)
RETURNS integer
AS $BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa_advancedsettings('r1')
*/

DECLARE
v_reservoir json;
v_tank json;
v_pump json;
v_valve json;
v_headloss text;
v_basedemand float;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get user variables
	SELECT ((value::json->>'parameters')::json->>'valve')::json INTO v_valve FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'reservoir')::json INTO v_reservoir FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'tank')::json INTO v_tank FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT ((value::json->>'parameters')::json->>'pump')::json INTO v_pump FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	SELECT value INTO v_headloss FROM config_param_user WHERE parameter = 'inp_options_headloss' AND cur_user=current_user;
	SELECT ((value::json->>'junction')::json)->>'baseDemand' INTO v_basedemand FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;

	-- update values for valves
	UPDATE temp_arc SET minorloss = (v_valve->>'minorloss')::float WHERE epa_type='VALVE' AND (minorloss = 0 OR minorloss is null);
	UPDATE temp_arc SET roughness = ((v_valve->>'roughness')::json->>v_headloss)::float	WHERE epa_type='VALVE' AND (roughness = 0 OR roughness is null);
	UPDATE temp_arc SET length = (v_valve->>'length')::float WHERE epa_type='VALVE';
	UPDATE temp_arc SET diameter = (v_valve->>'diameter')::float WHERE epa_type='VALVE' AND (diameter = 0 OR diameter is null);

	-- update values for reservoirs
	UPDATE temp_node SET top_elev = top_elev + (v_reservoir->>'addElevation')::float WHERE epa_type='RESERVOIR';

	-- update values for tanks
	UPDATE temp_node SET top_elev = top_elev + (v_tank->>'addElevation')::float WHERE epa_type='TANK';

	-- update values for pumps
	UPDATE temp_arc SET length = (v_pump->>'length')::float, diameter = (v_pump ->>'diameter')::float, roughness = ((v_pump->>'roughness')::json->>v_headloss)::float
	WHERE epa_type='PUMP';

	IF v_basedemand IS NOT NULL THEN
		UPDATE temp_node SET demand = demand + v_basedemand WHERE epa_type  = 'JUNCTION';
	END IF;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
