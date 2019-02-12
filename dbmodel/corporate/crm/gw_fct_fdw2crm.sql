/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", public, pg_catalog;



-- ----------------------------
-- CRM FUNCTIONS
-- ----------------------------


CREATE OR REPLACE FUNCTION crm.gw_fct_fdw2crm()
  RETURNS void AS
$BODY$DECLARE


BEGIN

    -- Search path
    SET search_path = "crm", public;

	RAISE NOTICE ' Executing gw_fct_fdw2crm_hydro_catalog ';
	PERFORM crm.gw_fct_fdw2crm_hydro_catalog();

	RAISE NOTICE ' Executing gw_fct_fdw2crm_hydro_data ';
	PERFORM crm.gw_fct_fdw2crm_hydro_data();

	RAISE NOTICE ' Executing gw_fct_fdw2crm_hydro_flow ';
	PERFORM crm.gw_fct_fdw2crm_hydro_flow();	

    RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  