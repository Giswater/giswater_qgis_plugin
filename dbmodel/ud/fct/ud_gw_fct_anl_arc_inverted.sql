/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2204

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_arc_inverted();
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_inverted() 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_arc_inverted()
*/

DECLARE
	v_version text;
	v_saveondatabase boolean = true;
	v_result json;    
BEGIN

	
	SET search_path = "SCHEMA_NAME", public;

    	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;


	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=10;
	    
	-- Computing process
	 INSERT INTO anl_arc (arc_id, expl_id, fprocesscat_id, the_geom)
	 SELECT arc_id, expl_id, 10, the_geom 
		FROM v_edit_arc
		WHERE slope < 0;
	    
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=10) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=10;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=10 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (10, current_user);
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