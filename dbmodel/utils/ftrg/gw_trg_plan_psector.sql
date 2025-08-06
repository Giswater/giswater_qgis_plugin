/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3182

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector()
  RETURNS trigger AS
$BODY$

DECLARE
v_projectype text;
v_result JSON;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
   	v_projectype := (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);
	
   
	IF NEW.active IS TRUE THEN
   	
   		EXECUTE 'SELECT gw_fct_checktopologypsector($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
		"feature":{}, "data":{"filterFields":{}, "pageInfo":{},"psectorId":"'||NEW.psector_id||'"}}$$)' INTO v_result;
	
	
		IF ((v_result->>'message')::json->>'level')::integer = 1 THEN
		
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
            "data":{"message":"4336", "function":"2446","parameters":null}}$$);';
            
            RETURN OLD;
		
		END IF;  	
   	
   	END IF;
   

  	-- set active to related layers
	UPDATE plan_psector_x_arc SET active=NEW.active WHERE psector_id=NEW.psector_id;
	UPDATE plan_psector_x_node SET active=NEW.active WHERE psector_id=NEW.psector_id;
	UPDATE plan_psector_x_connec SET active=NEW.active WHERE psector_id=NEW.psector_id;
	IF v_projectype = 'UD' THEN
		UPDATE plan_psector_x_gully SET active=NEW.active WHERE psector_id=NEW.psector_id;
	END IF;
	
RETURN NEW;
			
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;