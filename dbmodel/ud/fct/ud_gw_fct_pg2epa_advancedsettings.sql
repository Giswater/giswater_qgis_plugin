/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2906

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_advancedsettings(p_result text)
RETURNS integer 
AS $BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa_advancedsettings('p1')
*/

DECLARE
v_ysur float;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get user variables
	SELECT ((value::json->>'parameters')::json->>'junction')::json->>'ysur' INTO v_ysur FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user;
	
	-- update ysur for junctions
	IF v_ysur IS NOT NULL THEN
		UPDATE rpt_inp_node SET ysur = v_ysur WHERE result_id = p_result;
	END IF;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;