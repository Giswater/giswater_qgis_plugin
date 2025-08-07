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
	
   
   
   	IF NEW.active IS TRUE THEN
   	
   		
   		-- check if trg has been executed via dialog or by editing the table plan_psector
   		IF v_projectype = 'UD' THEN
   		
   			v_partialquery = ' union
			SELECT gully_id, gullycat_id, state, descript, expl_id, fid, the_geom FROM anl_gully WHERE cur_user="current_user"() AND fid IN (354,355)';
	
		ELSE
		
			v_partialquery = '';
		
		END IF;
   		
   		v_query = '
		SELECT node_id, nodecat_id, state, descript, expl_id, fid, the_geom FROM anl_node WHERE cur_user="current_user"() AND fid IN (354,355) UNION
		SELECT arc_id, arccat_id, state, descript, expl_id, fid, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fid IN (354,355) union
		SELECT connec_id, conneccat_id, state, descript, expl_id, fid, the_geom FROM anl_connec WHERE cur_user="current_user"() AND fid IN (354,355) '||v_partialquery||'';
   	
   		EXECUTE 'SELECT count(*) from ('||v_query||')a' INTO v_count;
   	
   		IF v_count = 0 THEN 
   	
   	
	   		EXECUTE 'SELECT gw_fct_checktopologypsector($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
			"feature":{}, "data":{"filterFields":{}, "pageInfo":{},"psectorId":"'||NEW.psector_id||'"}}$$)' INTO v_result;
		
			
		
			IF ((v_result->>'message')::json->>'level')::integer = 1 AND (SELECT count(*) FROM plan_psector_x_node WHERE psector_id = NEW.psector_id) > 0 THEN
			
				 EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	             "data":{"message":"4336", "function":"2446","parameters":null}}$$)';
	            
	            RETURN OLD;
			
			END IF;  	
		
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