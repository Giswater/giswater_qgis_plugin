/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2106

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_connec_duplicated();
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_connec_duplicated() 
RETURNS json AS 
$BODY$ 

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_connec_duplicated()
*/

DECLARE
	rec_connec record;
	rec record;
	v_version text;
	v_saveondatabase boolean = true;
	v_result json;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- Get data from config table
	SELECT * INTO rec FROM config; 

	-- Reset values
	DELETE FROM anl_connec WHERE cur_user="current_user"() AND fprocesscat_id=5;
			
	-- Computing process
	INSERT INTO anl_connec (connec_id, connecat_id,state, connec_id_aux, connecat_id_aux, state_aux, expl_id, fprocesscat_id, the_geom)
	SELECT * FROM 
	(SELECT DISTINCT t1.connec_id as c1, t1.connecat_id as cc1,  t1.state as state1, t2.connec_id as c2, t2.connecat_id as cc2, t2.state as state2, t1.expl_id, 5, t1.the_geom
	FROM connec AS t1 JOIN connec AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,(30)) 
	WHERE t1.connec_id != t2.connec_id  ORDER BY t1.connec_id) a 
	WHERE a.state1 > 0 AND a.state2 > 0 ;
	
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM anl_connec WHERE cur_user="current_user"() AND fprocesscat_id=5) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_connec WHERE cur_user="current_user"() AND fprocesscat_id=5;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=5 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (5, current_user);
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
