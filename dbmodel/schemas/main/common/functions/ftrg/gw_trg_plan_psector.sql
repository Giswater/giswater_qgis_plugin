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
v_partialquery TEXT;
v_query TEXT;
v_count integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
   	v_projectype := (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);
	
	IF TG_OP = 'INSERT' THEN

		-- set current psectoR
		UPDATE config_param_user SET value = NEW.psector_id WHERE cur_user = current_user AND parameter = 'plan_psector_current';

		-- set selected psector
		INSERT INTO selector_psector VALUES (NEW.psector_id, current_user) ON CONFLICT (psector_id, cur_user) DO NOTHING; 

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
	
	   	-- --manage checktopologypsector
		-- IF (SELECT value::boolean FROM config_param_user WHERE parameter = 'plan_psector_disable_checktopology_trigger' AND cur_user = current_user) = false -- triggered from dialog  
		-- AND (NEW.active IS TRUE) AND (NEW.active IS DISTINCT FROM OLD.active) THEN
	   	--    		EXECUTE 'SELECT gw_fct_checktopologypsector($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
		-- 		"feature":{}, "data":{"filterFields":{}, "pageInfo":{},"psectorId":"'||NEW.psector_id||'"}}$$)' INTO v_result;	
			
		-- 		IF ((v_result->>'message')::json->>'level')::integer = 1 AND (SELECT count(*) FROM plan_psector_x_node WHERE psector_id = NEW.psector_id) > 0 THEN
		-- 			 EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		--              "data":{"message":"4336", "function":"2446","parameters":null}}$$)';
		            
		--             RETURN OLD;
		-- 		END IF;  	
	   	-- END IF; 
		
		RETURN NEW;

		 IF NEW.status = 8 THEN
	   
	   		EXECUTE '
			SELECT gw_fct_plan_recover_archived($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"parameters":{"psectorId":"'||NEW.psector_id||'"}}}$$);
			';
	   
	   	END IF;

	END IF;
			
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;