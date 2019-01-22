/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2440


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg(csv2pgcat_id_aux integer, label_aux text)
RETURNS integer AS
$BODY$

DECLARE
	project_type_aux varchar;
	v_return integer;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

	-- db prices catalog
	IF csv2pgcat_id_aux=1 THEN
		SELECT gw_fct_utils_csv2pg_import_dbprices(csv2pgcat_id_aux, label_aux) INTO v_return;

	-- om visit tables
	ELSIF csv2pgcat_id_aux=2 THEN
			SELECT gw_fct_utils_csv2pg_import_omvisit(csv2pgcat_id_aux, label_aux) INTO v_return;
	
	-- elements import
	ELSIF csv2pgcat_id_aux=3 THEN
		SELECT gw_fct_utils_csv2pg_import_elements(csv2pgcat_id_aux, label_aux) INTO v_return;

	-- addfields import
	ELSIF csv2pgcat_id_aux=4 THEN
		SELECT gw_fct_utils_csv2pg_import_addfields(csv2pgcat_id_aux, label_aux) INTO v_return;
			
	-- export inp
	ELSIF csv2pgcat_id_aux=10 AND project_type_aux='WS' THEN
		SELECT gw_fct_utils_csv2pg_export_epa_inp(csv2pgcat_id_aux, label_aux) INTO v_return;

	ELSIF csv2pgcat_id_aux=10 AND project_type_aux='UD' THEN
		SELECT gw_fct_utils_csv2pg_export_epa_inp(csv2pgcat_id_aux, label_aux) INTO v_return;

	-- import rpt
	ELSIF csv2pgcat_id_aux=11 AND project_type_aux='WS' THEN
		SELECT gw_fct_utils_csv2pg_import_epa_rpt(csv2pgcat_id_aux, label_aux) INTO v_return;

	ELSIF csv2pgcat_id_aux=11 AND project_type_aux='UD' THEN
		SELECT gw_fct_utils_csv2pg_import_epa_rpt(csv2pgcat_id_aux, label_aux) INTO v_return;
	
	-- import inp
	ELSIF csv2pgcat_id_aux=12 AND project_type_aux='WS' THEN
		SELECT gw_fct_utils_csv2pg_import_epanet_inp(csv2pgcat_id_aux, label_aux) INTO v_return;

	ELSIF csv2pgcat_id_aux=12 AND project_type_aux='UD' THEN
		SELECT gw_fct_utils_csv2pg_import_swmm_inp(csv2pgcat_id_aux, label_aux) INTO v_return;
	
	END IF;
		
RETURN 0;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
 COST 100;
