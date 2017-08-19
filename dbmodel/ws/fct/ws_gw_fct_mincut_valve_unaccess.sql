CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_valve_unaccess(valve_id_var varchar, result_id_var varchar) RETURNS void AS
$BODY$
DECLARE 


BEGIN 
	-- set search_path
    SET search_path= 'SCHEMA_NAME','public';

	/*
	-- Computing process
  	IF (SELECT valve_id FROM anl_mincut_result_valve_unaccess WHERE valve_id=valve_id_var and result_id=result_id_var) IS NOT NULL
		INSERT INTO anl_mincut_result_valve_unaccess (result_id, valve_id) VALUES (result_id_var, valve_id_var)
	ELSE
		DELETE FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_var AND valve_id=valve_id_var
	END IF;
*/
RETURN;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;