/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2726


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg_main(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_main(p_data json)  
RETURNS json AS $BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_rpt2pg_main($${"data":{"resultId":"test1"}}$$)
SELECT SCHEMA_NAME.gw_fct_rpt2pg_main($${"data":{"resultId":"test1"}}$$) 

*/

DECLARE 
v_result text;


BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get function parameteres
	v_result  = (p_data->>'data')::json->>'resultId';

	RAISE NOTICE 'Starting rpt2pg process.';

	-- call import epa function
	PERFORM gw_fct_rpt2pg_import_rpt();
		
	-- Reverse geometries where flow is negative and updating flow values with absolute value
	UPDATE rpt_inp_arc SET the_geom=st_reverse(the_geom) FROM rpt_arc WHERE rpt_arc.arc_id=rpt_inp_arc.arc_id AND flow<0 AND rpt_inp_arc.result_id=result_id_var;
	UPDATE rpt_arc SET flow=(-1)*flow WHERE flow<0 and result_id=v_result;
	
	-- set result on result selector: In spite of there are four selectors tables (rpt_selector_result, rpt_selector_compare, rpt_selector_hourly, rpt_selector_hourly_compare) only it's setted one
	DELETE FROM rpt_selector_result WHERE cur_user=current_user;
	INSERT INTO rpt_selector_result (result_id, cur_user) VALUES (v_result, current_user);

	-- set log
	RETURN gw_fct_rpt2pg_log(result_id_var);
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;