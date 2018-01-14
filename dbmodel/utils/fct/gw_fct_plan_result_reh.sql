/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2128



DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_result_reh(integer, double precision, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_result_reh( result_id_var integer, coefficient_var double precision, descript_var text)
  RETURNS integer AS
$BODY$

DECLARE 
rec_parameter record;
rec_work record;
work_id_aux text;
measurement_aux float;
price_aux float;
section_type_aux smallint;
ymax_aux float;
loc_condition_aux text;
arc_id_var text;

BEGIN 

	SET search_path = "SCHEMA_NAME", public;
 
	FOR rec_parameter IN SELECT * FROM om_visit_event JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id 
	JOIN om_visit_parameter_type ON parameter_type=om_visit_parameter_type.id where go2plan IS TRUE and is_last IS TRUE
	LOOP
				
		--get arc/node parameters

		--get arc parameters
		arc_id_var='11212';
		section_type_aux=1;

		--get node parameters
		ymax_aux=2;

		--get localit
		loc_condition_aux='VOLTA';

		--set work code
		work_id_aux='work1';
		
		-- set compost price
		FOR rec_work IN SELECT * FROM om_reh_works_x_pcompost WHERE work_id=work_id_aux
		LOOP
			-- calculate measurement
			measurement_aux:=100;
			
			--get price using SQL condition
			SELECT price INTO price_aux FROM v_price_compost WHERE id=rec_work.pcompost_id;
			
			INSERT INTO plan_result_reh_arc (result_id, arc_id, parameter_id, work_id, init_condition, end_condition, 
			loc_condition, pcompost_id, pcompost_price, ymax, length, measurement, cost) 
			
			VALUES (result_id_var, arc_id_var, rec_parameter.parameter_id, rec_work.work_id, rec_parameter.value1, rec_parameter.value2, 
			loc_condition_aux, rec_work.pcompost_id, price_aux, ymax_aux, rec_parameter.position_value, measurement_aux, measurement_aux*price_aux);

		END LOOP;

	END LOOP;
		
	
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

