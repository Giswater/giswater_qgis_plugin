/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2128


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_result(text, integer, double precision, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_result( p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_plan_result($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"parameters":{"coefficient":1.67, "description":"test descript", "resultType":1, "resultId":"test1","saveOnDatabase":true}}}$$)
*/

DECLARE 
project_type_aux 	text;
v_project_type		text;
v_version		text;
id_last 		integer;
v_saveondatabase	boolean;
v_result_id		text;
v_result_type		integer;
v_coefficient		float;
v_descript		text;
v_return		json;
BEGIN 

    SET search_path = "SCHEMA_NAME", public;


	-- getting input data 	
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;
	v_result_id := (((p_data ->>'data')::json->>'parameters')::json->>'resultId')::text;
	v_result_type := (((p_data ->>'data')::json->>'parameters')::json->>'resultType')::text;
	v_coefficient := (((p_data ->>'data')::json->>'parameters')::json->>'coefficient')::float;
	v_descript := (((p_data ->>'data')::json->>'parameters')::json->>'description')::text;

	-- select config values
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;

	SELECT gw_fct_plan_check_data (p_data) INTO v_return;

	-- insert into result_cat table
	INSERT INTO om_result_cat (name, result_type, network_price_coeff, tstamp, cur_user, descript, pricecat_id) 
	VALUES ( v_result_id, v_result_type, v_coefficient, now(), 
		current_user, v_descript, (SELECT id FROM price_cat_simple ORDER BY tstamp DESC LIMIT 1))  RETURNING result_id INTO id_last;
	
	DELETE FROM plan_result_selector WHERE cur_user=current_user;
	INSERT INTO plan_result_selector (result_id, cur_user) VALUES (id_last, current_user);
	
	IF v_result_type=1 THEN
	
		PERFORM gw_fct_plan_result_rec(id_last, v_coefficient, v_descript);
		
	ELSIF v_result_type=2 THEN
		
		PERFORM gw_fct_plan_result_reh(id_last, v_coefficient, v_descript);
	
	END IF;
		

	
--  Return
    RETURN v_return;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

