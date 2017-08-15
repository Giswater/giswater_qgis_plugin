/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- Function: SCHEMA_NAME.gw_fct_urn();

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_estimate_result(varchar, double, boolean);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_plan_estimate_result(result_id_var text, coefficient_var double, only_planified boolean) RETURNS integer AS

$BODY$

DECLARE 
urn_id_seq integer;
project_type_aux varchar;

BEGIN 

    SET search_path = "SCHEMA_NAME", public;
	
	-- TO DO
	
	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
