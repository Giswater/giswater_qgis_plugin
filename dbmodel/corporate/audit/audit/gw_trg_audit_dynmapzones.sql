/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_audit()
  RETURNS trigger AS
$BODY$

/*
The goal of this trigger is to disable it when mapzones are enabled in order to enhance performance
*/


DECLARE
v_old_data json;
v_new_data json;
v_sector boolean = true;
v_minsector boolean = true;
v_presszone boolean = true;
v_dqa boolean = true;
v_dma boolean = true;

BEGIN

--	Set search path to local schema
	SET search_path = SCHEMA_NAME, public;

	v_sector := (SELECT value::json->>'SECTOR' FROM config_param_system WHERE parameter = 'utils_grafanalytics_status');
	v_presszone := (SELECT value::json->>'PRESSZONE' FROM config_param_system WHERE parameter = 'utils_grafanalytics_status');
	v_dqa := (SELECT value::json->>'DQA' FROM config_param_system WHERE parameter = 'utils_grafanalytics_status');
	v_dma := (SELECT value::json->>'DMA' FROM config_param_system WHERE parameter = 'utils_grafanalytics_status');
	v_minsector := (SELECT value::json->>'MINSECTOR' FROM config_param_system WHERE parameter = 'utils_grafanalytics_status');

	IF (TG_OP = 'INSERT') THEN
		v_new_data := row_to_json(NEW.*);
		INSERT INTO audit.log (schema,table_name,user_name,action,newdata,query)
		VALUES (TG_TABLE_SCHEMA::TEXT, TG_TABLE_NAME::TEXT ,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query());
		RETURN NEW;
	ELSIF (TG_OP = 'UPDATE') THEN
    
		IF TG_TABLE_NAME IN ('arc','node','connec') THEN
		
			IF (v_sector AND NEW.sector_id != OLD.sector_id) OR
				(v_presszone AND NEW.presszone_id != OLD.presszone_id) OR
				(v_dma AND NEW.dma_id != OLD.dma_id) OR
				(v_dqa AND NEW.dqa_id != OLD.dqa_id) OR
				(v_minsector AND NEW.minsector_id != OLD.minsector_id) THEN
			ELSE
				v_old_data := row_to_json(OLD.*);
				v_new_data := row_to_json(NEW.*);
				INSERT INTO audit.log (schema,table_name,user_name,action,olddata,newdata,query) 
				VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query());
			END IF;
		ELSE
			v_old_data := row_to_json(OLD.*);
			v_new_data := row_to_json(NEW.*);
			INSERT INTO audit.log (schema,table_name,user_name,action,olddata,newdata,query) 
			VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query());
		END IF;

	
		RETURN NEW;
	
	ELSIF (TG_OP = 'DELETE') THEN
		v_old_data := row_to_json(OLD.*);
		INSERT INTO audit.log (schema,table_name,user_name,action,olddata,query)
		VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query());
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;