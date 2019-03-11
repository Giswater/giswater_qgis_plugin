/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", public, pg_catalog;



-- ----------------------------
-- CRM FUNCTIONS
-- ----------------------------

CREATE OR REPLACE FUNCTION crm.gw_fct_crm2gis()
  RETURNS integer AS
$BODY$DECLARE


BEGIN

    -- Search path
    SET search_path = "crm", public;
	
	
	IF (SELECT value::boolean FROM config_param_system WHERE parameter='sys_fdw2crm_process') IS TRUE THEN
		PERFORM crm.gw_fct_fdw2crm();
	END IF;
	
	
	-- crm. its mandatory due bug of Postgres only in this case
	PERFORM crm.gw_fct_crm2gis_hydro_catalog();
	PERFORM crm.gw_fct_crm2gis_hydro_data();
	PERFORM crm.gw_fct_crm2gis_hydro_flow();


    RETURN 0;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  