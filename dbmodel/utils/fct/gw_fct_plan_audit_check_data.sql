/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_audit_check_data(integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_audit_check_data(fprocesscat_id_aux integer)  
RETURNS integer AS
$BODY$

DECLARE 
	project_type_aux text;
	table_count_aux integer;
	result_id_var integer;
	column_count_aux integer;
	return_aux integer;
	

BEGIN 

	-- init function
	SET search_path=SCHEMA_NAME, public;
	result_id_var:=0;
	return_aux:=0;

	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

	IF fprocesscat_id_aux=15 THEN 

		-- delete previous rows
		DELETE FROM audit_check_data WHERE fprocesscat_id=15;


		--arc catalog
		SELECT count(*) INTO table_count_aux FROM cat_arc WHERE active=TRUE;
	
		--active column
		SELECT count(*) INTO column_count_aux FROM cat_arc WHERE active IS NULL;
		IF column_count_aux>0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled, error_message)
			VALUES (15, result_id_var, 'cat_arc', 'active', 3, FALSE, concat('There are ',column_count_aux,' row(s) without values on active column.'));
			return_aux:=1;
		END IF;
	
		--cost column
		SELECT count(*) INTO column_count_aux FROM cat_arc WHERE cost IS NOT NULL and active=TRUE;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_arc', 'cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on cost column'));
			return_aux:=1;
		END IF;
	
		--m2bottom_cost column
		SELECT count(*) INTO column_count_aux FROM cat_arc WHERE m2bottom_cost IS NOT NULL and active=TRUE;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_arc', 'm2bottom_cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on m2bottom_cost column'));
			return_aux:=1;
		END IF;
	
		--m3protec_cost column
		SELECT count(*) INTO column_count_aux FROM cat_arc WHERE m3protec_cost IS NOT NULL and active=TRUE;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_arc', 'm3protec_cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on m3protec_cost column'));
			return_aux:=1;
		END IF;


		
		--node catalog
		SELECT count(*) INTO table_count_aux FROM cat_node WHERE active=TRUE;
	
		--active column
		SELECT count(*) INTO column_count_aux FROM cat_node WHERE active IS NULL;
		IF column_count_aux>0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_node', 'active', 3, FALSE, concat('There are ',column_count_aux,' row(s) without values on active column.'));
			return_aux:=1;
		END IF;
	
		--cost column
		SELECT count(*) INTO column_count_aux FROM cat_node WHERE cost IS NOT NULL and active=TRUE;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_node', 'cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on cost column'));
			return_aux:=1;
		END IF;
	
		--cost_unit column
		SELECT count(*) INTO column_count_aux FROM cat_node WHERE cost_unit IS NOT NULL and active=TRUE;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_node', 'cost_unit', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on cost_unit column'));
			return_aux:=1;
		END IF;
	
		IF project_type_aux='WS' THEN 
			--estimated_depth column
			SELECT count(*) INTO column_count_aux FROM cat_node WHERE estimated_depth IS NOT NULL and active=TRUE;
			IF table_count_aux>column_count_aux THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
				VALUES (15, result_id_var, 'cat_node', 'estimated_depth', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on estimated_depth column'));
				return_aux:=1;
			END IF;
	
		ELSIF project_type_aux='UD' THEN 
			--estimated_y column
			SELECT count(*) INTO column_count_aux FROM cat_node WHERE estimated_y IS NOT NULL and active=TRUE;
			IF table_count_aux>column_count_aux THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
				VALUES (15, result_id_var, 'cat_node', 'estimated_y', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on estimated_y column'));
				return_aux:=1;
			END IF;
		END IF;
	

	
	
		--connec catalog
		SELECT count(*) INTO table_count_aux FROM cat_connec WHERE active=TRUE;
	
		--active column
		SELECT count(*) INTO column_count_aux FROM cat_connec WHERE active IS NULL;
		IF column_count_aux>0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_connec', 'active', 3, FALSE, concat('There are ',column_count_aux,' row(s) without values on active column.'));
			return_aux:=1;
		END IF;
	
		--cost_ut column
		SELECT count(*) INTO column_count_aux FROM cat_connec WHERE cost_ut IS NOT NULL and active=TRUE;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_connec', 'cost_ut', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on cost_ut column'));
			return_aux:=1;
		END IF;
	
		--cost_ml column
		SELECT count(*) INTO column_count_aux FROM cat_connec WHERE cost_ml IS NOT NULL and active=TRUE;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_connec', 'cost_ml', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on cost_ml column'));
			return_aux:=1;
		END IF;
	
		--cost_m3 column
		SELECT count(*) INTO column_count_aux FROM cat_connec WHERE cost_m3 IS NOT NULL and active=TRUE;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_connec', 'cost_m3', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on cost_m3 column'));
			return_aux:=1;
		END IF;
	
	

	
		--pavement catalog
		SELECT count(*) INTO table_count_aux FROM cat_pavement;
	
		--thickness column
		SELECT count(*) INTO column_count_aux FROM cat_pavement WHERE thickness IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_pavement', 'thickness', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on thickness column'));
			return_aux:=1;
		END IF;
	
		--m2cost column
		SELECT count(*) INTO column_count_aux FROM cat_pavement WHERE m2_cost IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_pavement', 'm2_cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on m2_cost column'));
			return_aux:=1;
		END IF;
	
	
	
		--soil catalog
		SELECT count(*) INTO table_count_aux FROM cat_soil ;
	
		--y_param column
		SELECT count(*) INTO column_count_aux FROM cat_soil WHERE y_param IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_soil', 'y_param', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on y_param column'));
			return_aux:=1;
		END IF;
	
		--b column
		SELECT count(*) INTO column_count_aux FROM cat_soil WHERE b IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_soil', 'b', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on b column'));
			return_aux:=1;
		END IF;
	
		--m3exc_cost column
		SELECT count(*) INTO column_count_aux FROM cat_soil WHERE m3exc_cost IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_soil', 'm3exc_cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on m3exc_cost column'));
			return_aux:=1;
		END IF;
	
		--m3fill_cost column
		SELECT count(*) INTO column_count_aux FROM cat_soil WHERE m3fill_cost IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_soil', 'm3fill_cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on m3fill_cost column'));
			return_aux:=1;
		END IF;
	
		--m3excess_cost column
		SELECT count(*) INTO column_count_aux FROM cat_soil WHERE m3excess_cost IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_soil', 'm3excess_cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on m3excess_cost column'));
			return_aux:=1;
		END IF;
	
		--m2trenchl_cost column
		SELECT count(*) INTO column_count_aux FROM cat_soil WHERE m2trenchl_cost IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_soil', 'm2trenchl_cost', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on m2trenchl_cost column'));
			return_aux:=1;
		END IF;
	
		IF project_type_aux='UD' THEN
	
			--grate catalog
			SELECT count(*) INTO table_count_aux FROM cat_grate WHERE active=TRUE;
	
			--active column
			SELECT count(*) INTO column_count_aux FROM cat_grate WHERE active IS NULL;
			IF column_count_aux>0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
				VALUES (15, result_id_var, 'cat_grate', 'active', 3, FALSE, concat('There are ',column_count_aux,' row(s) without values on active column.'));
				return_aux:=1;
			END IF;
	
	
			--cost_ut column
			SELECT count(*) INTO column_count_aux FROM cat_grate WHERE cost_ut IS NOT NULL and active=TRUE;
			IF table_count_aux>column_count_aux THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
				VALUES (15, result_id_var, 'cat_grate', 'cost_ut', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on cost_ut column'));
				return_aux:=1;
			END IF;
		
		END IF;	

		--table plan_arc_x_pavement
		SELECT count(*) INTO table_count_aux FROM arc WHERE state>0;
	
		--rows number
		SELECT count(*) INTO column_count_aux FROM plan_arc_x_pavement;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'plan_arc_x_pavement', 'rows number', 1, FALSE, 'The number of rows of row(s) of the plan_arc_x_pavement table is less than the arc table');
			return_aux:=1;
		END IF;

		--pavcat_id column
		SELECT count(*) INTO table_count_aux FROM plan_arc_x_pavement;
		SELECT count(*) INTO column_count_aux FROM plan_arc_x_pavement WHERE pavcat_id IS NOT NULL;
		IF table_count_aux>column_count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_grate', 'pavcat_id', 2, FALSE, concat('There are ',(table_count_aux-column_count_aux),' row(s) without values on pavcat_id column'));
			return_aux:=1;
		END IF;



	ELSIF fprocesscat_id_aux=16 THEN 

		
			
	END IF;

	RETURN return_aux;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;
