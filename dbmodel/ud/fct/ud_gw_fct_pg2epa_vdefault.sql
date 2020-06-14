/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2908

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_vdefault(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_vdefault(p_data json)
RETURNS integer 
AS $BODY$


/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}}$$)

*/

DECLARE

v_roughness float = 0;
v_x float;
v_y float;
v_geom_point public.geometry;
v_geom_line public.geometry;
v_srid int2;
v_outfalltype text;
v_barrels integer;
v_q0 float;
v_qmax float;
v_ysur float;
v_y0 float;
v_rgscf int2;
v_result text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get values
	SELECT epsg INTO v_srid FROM sys_version LIMIT 1;
	
	-- get input data
	v_result = ((p_data->>'data')::json->>'parameters')::json->>'resultId';

	-- get user variables
	v_outfalltype = (SELECT ((value::json->>'parameters')::json->>'outfall')::json->>'outfallType' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_barrels = (SELECT ((value::json->>'parameters')::json->>'conduit')::json->>'barrels' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_q0 = (SELECT ((value::json->>'parameters')::json->>'conduit')::json->>'q0' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_qmax = (SELECT ((value::json->>'parameters')::json->>'conduit')::json->>'qmax' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_rgscf = (SELECT ((value::json->>'parameters')::json->>'raingage')::json->>'scf' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_ysur = (SELECT ((value::json->>'parameters')::json->>'conduit')::json->>'ysur' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_y0 = (SELECT ((value::json->>'parameters')::json->>'conduit')::json->>'y0' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);

	RAISE NOTICE '1 - Set system default values';
	UPDATE v_edit_inp_outfall SET outfall_type = v_outfalltype WHERE outfall_type IS NULL;
	UPDATE v_edit_raingage SET scf=(SELECT value FROM config_param_user WHERE parameter='epa_rgage_scf_vdefault' AND cur_user=current_user)::float WHERE scf IS NULL;

	RAISE NOTICE '2 - Set result default values';
	UPDATE temp_arc SET q0 = v_q0 WHERE q0 IS NULL;
	UPDATE temp_arc SET qmax = v_qmax WHERE qmax IS NULL;
	UPDATE temp_arc SET barrels = v_barrels WHERE barrels IS NULL;
	UPDATE temp_node SET y0 = v_y0 WHERE y0 IS NULL;
	UPDATE temp_node SET ysur = v_ysur WHERE ysur IS NULL;
	
    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
