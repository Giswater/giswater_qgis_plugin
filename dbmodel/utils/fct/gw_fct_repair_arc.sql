/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2496
-- TWO FUNCTIONS ARE DEFINED:
-- gw_fct_repair_arc_searchnodes (json)
-- gw_fct_repair_arc_searchnodes (tex, bgint, bint):

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_repair_arc() RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_repair_arc()
*/

DECLARE 
	arcrec 			Record;
	v_count 		integer;
	v_count_partial 	integer=0;
	v_result 		text;
	v_version		text;
	v_projecttype		text;
	v_saveondatabase 	boolean;


BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- Delete previous log results
	DELETE FROM audit_log_data WHERE fprocesscat_id=3 AND user_name=current_user;
	DELETE FROM audit_log_data WHERE fprocesscat_id=4 AND user_name=current_user;

	-- select config values
	SELECT wsoftware, giswater  INTO v_projecttype, v_version FROM version order by 1 desc limit 1;
    
	-- Set config parameter
	UPDATE config_param_system SET value=TRUE WHERE parameter='edit_topocontrol_dsbl_error' ;
	
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
	UPDATE config_param_system SET value=FALSE WHERE parameter='edit_topocontrol_dsbl_error' ;
	
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM audit_check_data WHERE user_name="current_user"() AND ( fprocesscat_id=3 OR fprocesscat_id=4)) row; 

	

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fprocesscat_id=3;
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fprocesscat_id=4;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=3 AND cur_user=current_user;  
		DELETE FROM selector_audit WHERE fprocesscat_id=4 AND cur_user=current_user;    
  
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (3, current_user);
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (4, current_user);
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



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_repair_arc( p_arc_id text, counter bigint default 0, total bigint default 0)
RETURNS character varying AS

$BODY$

/*
EXAMPLE
SELECT SCHEMA_NAME.gw_fct_repair_arc(arc_id, (row_number() over (order by arc_id)), (select count(*) from SCHEMA_NAME.arc)) FROM SCHEMA_NAME.arc

RESULTS:
After process log result are stored on audit_log_data whith fprocesscat_i=3 and 4
*/

DECLARE

BEGIN
	  -- set search_path
	  SET search_path='SCHEMA_NAME';

      -- Set config parameter
      UPDATE config_param_system SET value = TRUE WHERE parameter = 'edit_topocontrol_dsbl_error' ;

      -- execute
      UPDATE arc SET the_geom = the_geom WHERE arc_id = p_arc_id AND state=1;

      -- raise notice
      IF counter>0 AND total>0 THEN
        RAISE NOTICE '[%/%] Arc id: %', counter, total, p_arc_id;
      ELSIF counter>0 THEN
        RAISE NOTICE '[%] Arc id: %', counter, p_arc_id;
      ELSE
        RAISE NOTICE 'Arc id: %', p_arc_id;
      END IF;
             

      -- Set config parameter
      UPDATE config_param_system SET value = FALSE WHERE parameter = 'edit_topocontrol_dsbl_error' ;

    
RETURN p_arc_id;

   

END; 

$BODY$

LANGUAGE plpgsql VOLATILE

COST 100;