/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- ----------------------------
-- CRM FUNCTIONS
-- ----------------------------

CREATE OR REPLACE FUNCTION crm.gw_fct_fdw2crm_hydro_catalog()
  RETURNS void AS
$BODY$

/*
SELECT crm.gw_fct_fdw2crm_hydro_catalog()
*/


DECLARE


BEGIN

    -- Search path
 
	-- catalog period
	RAISE NOTICE ' Executing hydro_cat_catalog ';
	DELETE FROM crm.hydro_cat_catalog;
	INSERT INTO crm.hydro_cat_catalog (id, code, hydro_type, madeby, class, flow, dnom, observ)
	SELECT a.id, code, a.hydro_type::text, a.madeby, a.class, a.flow, a.dnom::text, a.observ FROM crm.hydro_cat_catalog_ora a WHERE a.id IS NOT NULL;

	-- category values
	RAISE NOTICE ' Executing hydro_cat_category_ora ';
	DELETE FROM crm.hydro_cat_category;
	INSERT INTO crm.hydro_cat_category (id, code, observ)
	SELECT a.id::int8, a.code, a.observ FROM crm.hydro_cat_category_ora a WHERE a.id IS NOT NULL;

	-- state values
	RAISE NOTICE ' Executing hydro_val_state ';
	DELETE FROM crm.hydro_val_state;
	INSERT INTO crm.hydro_val_state (id, code)
	SELECT  distinct (a.state_id), (case WHEN a.state_id=1 THEN 'ALTA' WHEN a.state_id=2 THEN 'BAIXA' WHEN a.state_id=3 THEN '3-EN TRAMIT' WHEN a.state_id=4 
	THEN '4-EN TRAMIT' ELSE 'ESTAT N/I' END) as code FROM crm.hydrometer_ora a WHERE a.state_id IS NOT NULL;

	-- period values
	RAISE NOTICE ' Executing hydro_cat_period ';
	DELETE FROM crm.hydro_cat_period;
	INSERT INTO crm.hydro_cat_period (id, code, start_date, end_date)
	SELECT distinct on (a.id) a.id::int8, a.observ, a.start_date, a.end_date FROM crm.hydro_cat_period_ora a WHERE a.id IS NOT NULL;

	-- type values
	--RAISE NOTICE ' Executing hydro_cat_type ';
	--DELETE FROM crm.hydro_cat_type;
	--INSERT INTO crm.hydro_cat_type (id, code, observ)
	--SELECT a.id::int8, a.code, a.observ FROM crm.hydro_cat_type_ora a WHERE a.id IS NOT NULL;

    RETURN;
        
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION crm.gw_fct_fdw2crm_hydro_catalog()
  OWNER TO adria;
GRANT EXECUTE ON FUNCTION crm.gw_fct_fdw2crm_hydro_catalog() TO public;
GRANT EXECUTE ON FUNCTION crm.gw_fct_fdw2crm_hydro_catalog() TO adria;


  