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
/*
select crm.gw_fct_fdw2crm_hydro_data();
*/

DECLARE

BEGIN

	-- NOTE: Is not good practice to use the incremental issue because data can change on CRM and with incremental never is showed on gis
	-- As a result, previous delete and insert all

	-- insert into temporal table of hydrometers
	DELETE FROM crm.hydrometer;

	INSERT INTO crm.hydrometer
	SELECT hydrometer_ora.id::int8, code::text, connec_id::integer, municipi_id::integer, plot_code::integer, prority_id::integer, catalog_id::integer, us::integer, state_id::integer, 
	hydro_number::text, hydro_man_date::date, crm_number::text, customer_name::text, address1::text, address2::text, address3::text,  address2_1::text,  address2_2::text, address2_3::text, m3_volume::integer,
	start_date::date, end_date::date, update_date::date, expl_id::integer FROM crm.hydrometer_ora;

    RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;