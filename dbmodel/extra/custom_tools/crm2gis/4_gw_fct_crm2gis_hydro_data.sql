/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", public, pg_catalog;



-- ----------------------------
-- CRM FUNCTIONS
-- ----------------------------


CREATE OR REPLACE FUNCTION crm.gw_fct_crm2gis_hydro_data()
  RETURNS void AS
$BODY$DECLARE
rec_hydrometer record;
rec_connec record;



BEGIN

    -- Search path
    SET search_path = "ws", public;

	ALTER TABLE ws.rtc_hydrometer DISABLE TRIGGER gw_trg_rtc_hydrometer;


	-- insert into rtc_hydrometer
	INSERT INTO ws.rtc_hydrometer (hydrometer_id)
	SELECT id FROM crm.hydrometer WHERE id NOT IN (SELECT hydrometer_id::int8 FROM ws.rtc_hydrometer);

	-- insert into rtc_hydrometer_x_connec
	INSERT INTO ws.rtc_hydrometer_x_connec (hydrometer_id, connec_id)
	SELECT id, connec.connec_id FROM crm.hydrometer JOIN ws.connec ON hydrometer.connec_id::text=customer_code
	WHERE id NOT IN (SELECT hydrometer_id::int8 FROM ws.rtc_hydrometer_x_connec) 
	and hydrometer.connec_id is not null
	and hydrometer.connec_id::text in (SELECT customer_code FROM ws.connec);

	ALTER TABLE ws.rtc_hydrometer ENABLE TRIGGER gw_trg_rtc_hydrometer;

    RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;