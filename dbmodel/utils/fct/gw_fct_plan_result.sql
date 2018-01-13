/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2128



DROP FUNCTION IF EXISTS ud_data.gw_fct_plan_result(text, integer, double precision, text);

CREATE OR REPLACE FUNCTION ud_data.gw_fct_plan_result( result_name_var text, result_type_var integer, coefficient_var double precision, descript_var text)
  RETURNS integer AS
$BODY$

DECLARE 
id_last integer;

BEGIN 

    SET search_path = "ud_data", public;


	IF result_type_var=1 THEN

		-- insert into result_cat table
		INSERT INTO plan_result_cat (name, network_price_coeff, tstamp, cur_user, descript) 
		VALUES ( result_name_var, coefficient_var, now(), current_user, descript_var)  RETURNING result_id INTO id_last;
	
		DELETE FROM plan_selector_result WHERE cur_user=current_user;
		INSERT INTO plan_selector_result (result_id, cur_user) VALUES (id_last, current_user);
	
		PERFORM gw_fct_plan_result_rec(id_last, coefficient_var, descript_var);

		
		
	ELSIF result_type_var=2 THEN

		-- insert into result_cat table
		INSERT INTO plan_result_reh_cat (name, network_price_coeff, tstamp, cur_user, descript) 
		VALUES ( result_name_var, coefficient_var, now(), current_user, descript_var)  RETURNING result_id INTO id_last;
		
		DELETE FROM plan_selector_result WHERE cur_user=current_user;
		INSERT INTO plan_selector_result (result_id, cur_user) VALUES (id_last, current_user);
		
		PERFORM gw_fct_plan_result_reh(id_last, coefficient_var, descript_var);
	
	END IF;
		
	
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

