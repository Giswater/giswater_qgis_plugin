/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2128



DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_result(text, integer, double precision, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_result( result_name_var text, result_type_var integer, coefficient_var double precision, descript_var text)
  RETURNS integer AS
$BODY$

DECLARE 
id_last integer;

BEGIN 

    SET search_path = "SCHEMA_NAME", public;

	-- insert into result_cat table
	INSERT INTO om_result_cat (name, result_type, network_price_coeff, tstamp, cur_user, descript, pricecat_id) 
	VALUES ( result_name_var, result_type_var, coefficient_var, now(), 
		current_user, descript_var, (SELECT id FROM price_cat_simple ORDER BY tstamp DESC LIMIT 1))  RETURNING result_id INTO id_last;
	
	DELETE FROM plan_result_selector WHERE cur_user=current_user;
	INSERT INTO plan_result_selector (result_id, cur_user) VALUES (id_last, current_user);
	
	IF result_type_var=1 THEN
	
		PERFORM gw_fct_plan_result_rec(id_last, coefficient_var, descript_var);
		
	ELSIF result_type_var=2 THEN
		
		PERFORM gw_fct_plan_result_reh(id_last, coefficient_var, descript_var);
	
	END IF;
		
	
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

