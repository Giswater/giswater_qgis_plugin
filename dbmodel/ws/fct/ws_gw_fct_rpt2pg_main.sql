/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2322

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg(character varying );
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_main(p_data json)  
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_rpt2pg_main($${"data":{"resultId":"test1"}}$$) 
*/

DECLARE
v_result text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get parameters
	v_result  = (p_data ->>'data')::json->>'resultId';

	RAISE NOTICE 'Starting rpt2pg process.';

	-- reordening data
	PERFORM gw_fct_rpt2pg_import_rpt(p_data);
	
	-- Reverse geometries where flow is negative and updating flow values with absolute value
	UPDATE rpt_inp_arc SET the_geom=st_reverse(the_geom) FROM rpt_arc WHERE rpt_arc.arc_id=rpt_inp_arc.arc_id AND flow<0 AND rpt_inp_arc.result_id=v_result;
	UPDATE rpt_arc SET flow=(-1)*flow WHERE flow<0 and result_id=v_result;
	
	-- set result on result selector
	-- NOTE: In spite of there are four selectors tables () only it's setted one
	DELETE FROM selector_rpt_main WHERE cur_user=current_user;
	INSERT INTO selector_rpt_main (result_id, cur_user) VALUES (v_result, current_user);

	-- create log message
	RETURN gw_fct_rpt2pg_log(v_result);
	
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;