/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2496
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_repair_arc();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_arc_repair() RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_arc_repair()

-- fid: 103, 104

*/

DECLARE
 
arcrec Record;
v_count integer;
v_count_partial integer=0;
v_result text;
v_version text;
v_projecttype text;
v_saveondatabase boolean;

BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- Delete previous log results
	DELETE FROM audit_log_data WHERE fid=103 AND cur_user=current_user;
	DELETE FROM audit_log_data WHERE fid=104 AND cur_user=current_user;

	-- select config values
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version order by 1 desc limit 1;
    
	-- Set config parameter
	UPDATE config_param_system SET value=TRUE WHERE parameter='edit_topocontrol_disable_error' ;
	
	-- init counter
	SELECT COUNT(*) into v_count FROM v_edit_arc ;  

	-- Starting loop process
	FOR arcrec IN SELECT * FROM v_edit_arc
	LOOP
		--counter
		v_count_partial = v_count_partial+1;
		RAISE NOTICE 'Comptador: % / %', v_count_partial,v_count;
		
		-- execute
		--UPDATE v_edit_arc SET the_geom=the_geom WHERE arc_id=arcrec.arc_id;
		
	END LOOP;

	-- Set config parameter
	UPDATE config_param_system SET value=FALSE WHERE parameter='edit_topocontrol_disable_error' ;
	
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM audit_check_data WHERE cur_user="current_user"() AND ( fid=103 OR fid=104)) row;

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=103;
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=104;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fid=103 AND cur_user=current_user;
		DELETE FROM selector_audit WHERE fid=104 AND cur_user=current_user;
  
		INSERT INTO selector_audit (fid,cur_user) VALUES (103, current_user);
		INSERT INTO selector_audit (fid,cur_user) VALUES (104, current_user);
	END IF;

	--    Control nulls
	v_result := COALESCE(v_result, '[]'); 

	--  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"result":' || v_result ||
			     '}'||
		       '}'||
	'}')::json;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;