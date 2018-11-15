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
v_new_hydrometer integer;
v_new_hydrometer_x_connec integer;


BEGIN

    -- Search path
    SET search_path = "ws", public;

	-- count new hydrometer
	SELECT count(*) INTO v_new_hydrometer FROM crm.hydrometer except (SELECT hydrometer_id::int8 FROM ws.rtc_hydrometer);

	-- insert into rtc_hydrometer
	INSERT INTO ws.rtc_hydrometer (hydrometer_id)
	SELECT id FROM crm.hydrometer except (SELECT hydrometer_id::int8 FROM ws.rtc_hydrometer);

	-- count new hydrometer_x_connec
	SELECT count(*) INTO v_new_hydrometer_x_connec
		FROM crm.hydrometer 
		JOIN ws.connec ON hydrometer.connec_id::text=customer_code
		JOIN (SELECT id FROM crm.hydrometer EXCEPT (SELECT hydrometer_id::int8 FROM ws.rtc_hydrometer_x_connec))a ON a.id=hydrometer.id
		WHERE hydrometer.connec_id is not null
		and hydrometer.connec_id::text in (SELECT customer_code FROM ws.connec);

	-- insert into rtc_hydrometer_x_connec
	INSERT INTO ws.rtc_hydrometer_x_connec (hydrometer_id, connec_id)
	SELECT hydrometer.id, connec.connec_id 
		FROM crm.hydrometer 
		JOIN ws.connec ON hydrometer.connec_id::text=customer_code
		JOIN (SELECT id FROM crm.hydrometer EXCEPT (SELECT hydrometer_id::int8 FROM ws.rtc_hydrometer_x_connec))a ON a.id=hydrometer.id
		WHERE hydrometer.connec_id is not null
		and hydrometer.connec_id::text in (SELECT customer_code FROM ws.connec);


	-- insert into traceability table
	INSERT INTO crm.crm2gis_traceability (new_hydrometer,  new_hydrometer_x_connec) VALUES (v_new_hydrometer, v_new_hydrometer_x_connec);

    RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;