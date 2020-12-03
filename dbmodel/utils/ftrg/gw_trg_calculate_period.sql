/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2648



-- DROP FUNCTION "SCHEMA_NAME".gw_trg_calculate_period();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_calculate_period()
  RETURNS trigger AS
$BODY$
DECLARE 
	v_record record;
BEGIN

EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||',public';

 IF TG_OP = 'INSERT' THEN
 
	SELECT * INTO v_record FROM ext_cat_period where id = NEW.id;
 
	IF v_record.start_date IS NOT NULL AND v_record.end_date IS NOT NULL AND v_record.end_date > v_record.start_date THEN
	
		UPDATE ext_cat_period SET period_seconds = (EXTRACT(EPOCH FROM v_record.end_date) - EXTRACT(EPOCH FROM v_record.start_date))::integer WHERE ext_cat_period.id = NEW.id; 
			
	ELSE
		NEW.period_seconds := (SELECT value FROM config_param_system WHERE  parameter = 'admin_crm_periodseconds_vdefault');

		UPDATE ext_cat_period SET period_seconds = NEW.period_seconds WHERE ext_cat_period.id = NEW.id; 

	END IF;
END IF;


RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

