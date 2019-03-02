/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2436


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_audit_check_data(integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_audit_check_data(p_data json)  
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_plan_audit_check_data($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},
"data":{"parameters":{"saveOnDatabase":true}}}$$)
*/



DECLARE 
project_type_aux 	text;
table_count_aux 	integer;
result_id_var 		text;
count_aux 			integer;
count_global_aux	integer;
return_aux		integer;
v_version       text;	
v_result	json;
v_saveondatabase boolean;

BEGIN 

	-- init function
	SET search_path=SCHEMA_NAME, public;
	result_id_var:=0;
	return_aux:=0;
    count_global_aux:=0;

	SELECT wsoftware, giswater  INTO project_type_aux, v_version FROM version order by 1 desc limit 1;

	-- getting input data 	
	v_saveondatabase :=  ((p_data ->>'data')::json->>'saveOnDatabase')::boolean;

	
	-- delete previous rows
	DELETE FROM audit_check_data WHERE fprocesscat_id=15 AND user_name=current_user;

	--arc catalog
	SELECT count(*) INTO table_count_aux FROM cat_arc WHERE active=TRUE;

	--active column
	SELECT count(*) INTO count_aux FROM cat_arc WHERE active IS NULL;
	IF count_aux>0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled, error_message)
		VALUES (15, result_id_var, 'cat_arc', 'active', 3, FALSE, concat('There are ',count_aux,' row(s) without values on active column.'));
		count_global_aux=count_global_aux+count_aux;
	END IF;

	--cost column
	SELECT count(*) INTO count_aux FROM cat_arc WHERE cost IS NOT NULL and active=TRUE;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_arc', 'cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--m2bottom_cost column
	SELECT count(*) INTO count_aux FROM cat_arc WHERE m2bottom_cost IS NOT NULL and active=TRUE;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_arc', 'm2bottom_cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on m2bottom_cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--m3protec_cost column
	SELECT count(*) INTO count_aux FROM cat_arc WHERE m3protec_cost IS NOT NULL and active=TRUE;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_arc', 'm3protec_cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on m3protec_cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;


	
	--node catalog
	SELECT count(*) INTO table_count_aux FROM cat_node WHERE active=TRUE;

	--active column
	SELECT count(*) INTO count_aux FROM cat_node WHERE active IS NULL;
	IF count_aux>0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_node', 'active', 3, FALSE, concat('There are ',count_aux,' row(s) without values on active column.'));
		count_global_aux=count_global_aux+count_aux;
	END IF;

	--cost column
	SELECT count(*) INTO count_aux FROM cat_node WHERE cost IS NOT NULL and active=TRUE;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_node', 'cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--cost_unit column
	SELECT count(*) INTO count_aux FROM cat_node WHERE cost_unit IS NOT NULL and active=TRUE;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_node', 'cost_unit', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on cost_unit column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	IF project_type_aux='WS' THEN 
		--estimated_depth column
		SELECT count(*) INTO count_aux FROM cat_node WHERE estimated_depth IS NOT NULL and active=TRUE;
		IF table_count_aux>count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_node', 'estimated_depth', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on estimated_depth column'));
			count_global_aux=count_global_aux+(table_count_aux-count_aux);
		END IF;

	ELSIF project_type_aux='UD' THEN 
		--estimated_y column
		SELECT count(*) INTO count_aux FROM cat_node WHERE estimated_y IS NOT NULL and active=TRUE;
		IF table_count_aux>count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_node', 'estimated_y', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on estimated_y column'));
			count_global_aux=count_global_aux+(table_count_aux-count_aux);
		END IF;
	END IF;




	--connec catalog
	SELECT count(*) INTO table_count_aux FROM cat_connec WHERE active=TRUE;

	--active column
	SELECT count(*) INTO count_aux FROM cat_connec WHERE active IS NULL;
	IF count_aux>0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_connec', 'active', 3, FALSE, concat('There are ',count_aux,' row(s) without values on active column.'));
		count_global_aux=count_global_aux+count_aux;
	END IF;

	--cost_ut column
	SELECT count(*) INTO count_aux FROM cat_connec WHERE cost_ut IS NOT NULL and active=TRUE;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_connec', 'cost_ut', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on cost_ut column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--cost_ml column
	SELECT count(*) INTO count_aux FROM cat_connec WHERE cost_ml IS NOT NULL and active=TRUE;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_connec', 'cost_ml', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on cost_ml column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--cost_m3 column
	SELECT count(*) INTO count_aux FROM cat_connec WHERE cost_m3 IS NOT NULL and active=TRUE;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_connec', 'cost_m3', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on cost_m3 column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;




	--pavement catalog
	SELECT count(*) INTO table_count_aux FROM cat_pavement;

	--thickness column
	SELECT count(*) INTO count_aux FROM cat_pavement WHERE thickness IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_pavement', 'thickness', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on thickness column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--m2cost column
	SELECT count(*) INTO count_aux FROM cat_pavement WHERE m2_cost IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_pavement', 'm2_cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on m2_cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;



	--soil catalog
	SELECT count(*) INTO table_count_aux FROM cat_soil ;

	--y_param column
	SELECT count(*) INTO count_aux FROM cat_soil WHERE y_param IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_soil', 'y_param', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on y_param column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--b column
	SELECT count(*) INTO count_aux FROM cat_soil WHERE b IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_soil', 'b', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on b column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--m3exc_cost column
	SELECT count(*) INTO count_aux FROM cat_soil WHERE m3exc_cost IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_soil', 'm3exc_cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on m3exc_cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--m3fill_cost column
	SELECT count(*) INTO count_aux FROM cat_soil WHERE m3fill_cost IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_soil', 'm3fill_cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on m3fill_cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--m3excess_cost column
	SELECT count(*) INTO count_aux FROM cat_soil WHERE m3excess_cost IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_soil', 'm3excess_cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on m3excess_cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--m2trenchl_cost column
	SELECT count(*) INTO count_aux FROM cat_soil WHERE m2trenchl_cost IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'cat_soil', 'm2trenchl_cost', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on m2trenchl_cost column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	IF project_type_aux='UD' THEN

		--grate catalog
		SELECT count(*) INTO table_count_aux FROM cat_grate WHERE active=TRUE;

		--active column
		SELECT count(*) INTO count_aux FROM cat_grate WHERE active IS NULL;
		IF count_aux>0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_grate', 'active', 3, FALSE, concat('There are ',count_aux,' row(s) without values on active column.'));
			count_global_aux=count_global_aux+count_aux;
		END IF;


		--cost_ut column
		SELECT count(*) INTO count_aux FROM cat_grate WHERE cost_ut IS NOT NULL and active=TRUE;
		IF table_count_aux>count_aux THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
			VALUES (15, result_id_var, 'cat_grate', 'cost_ut', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on cost_ut column'));
			count_global_aux=count_global_aux+(table_count_aux-count_aux);
		END IF;
	
	END IF;	

	--table plan_arc_x_pavement
	SELECT count(*) INTO table_count_aux FROM arc WHERE state>0;

	--rows number
	SELECT count(*) INTO count_aux FROM plan_arc_x_pavement;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'plan_arc_x_pavement', 'rows number', 1, FALSE, 'The number of rows of row(s) of the plan_arc_x_pavement table is less than the arc table');
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	--pavcat_id column
	SELECT count(*) INTO table_count_aux FROM plan_arc_x_pavement;
	SELECT count(*) INTO count_aux FROM plan_arc_x_pavement WHERE pavcat_id IS NOT NULL;
	IF table_count_aux>count_aux THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, criticity, enabled,  error_message)
		VALUES (15, result_id_var, 'plan_arc_x_pavement', 'pavcat_id', 2, FALSE, concat('There are ',(table_count_aux-count_aux),' row(s) without values on pavcat_id column'));
		count_global_aux=count_global_aux+(table_count_aux-count_aux);
	END IF;

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=15) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=15;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=15 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (15, current_user);
	END IF;
		
	raise notice 'cunt % result %', count_global_aux, v_result;
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

 