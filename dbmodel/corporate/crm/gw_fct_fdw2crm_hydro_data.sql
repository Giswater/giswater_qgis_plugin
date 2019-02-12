/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", public, pg_catalog;



-- ----------------------------
-- CRM FUNCTIONS
-- ----------------------------

CREATE OR REPLACE FUNCTION crm.gw_fct_fdw2crm_hydro_data()
  RETURNS void AS
$BODY$


DECLARE

BEGIN

	-- insert into rtc_hydrometer
	INSERT INTO crm.rtc_hydrometer 
	SELECT  a.* FROM crm.hydrometer_ora a JOIN (SELECT id::int8 FROM crm.hydrometer_ora EXCEPT (SELECT id::int8 FROM crm.hydrometer))b ON a.id::int8=b.id::int8;

    RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;