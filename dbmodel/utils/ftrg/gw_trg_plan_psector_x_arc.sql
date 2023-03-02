/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1130

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_plan_psector_x_arc()
  RETURNS trigger AS
$BODY$
DECLARE 

v_stateaux smallint;
num_connec integer;
v_project_type text;

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Get project type
	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	SELECT arc.state INTO v_stateaux FROM arc WHERE arc_id=NEW.arc_id;
	IF v_stateaux=1	THEN 
		NEW.state=0;
		NEW.doable=false;
        
		-- do not allow set arc to obsolete when it has on service connecs
		SELECT count(connec_id) INTO num_connec FROM connec WHERE arc_id=NEW.arc_id AND state=1 AND connec_id NOT IN 
		(SELECT connec_id FROM plan_psector_x_connec WHERE psector_id=NEW.psector_id AND state=0);
		IF num_connec > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3228", "function":"1130","debug_msg":""}}$$);';
		END IF;
        
        -- do not allow set arc to obsolete when it has on service gullys
        IF v_project_type = 'UD' THEN
            SELECT count(gully_id) INTO num_connec FROM gully WHERE arc_id=NEW.arc_id AND state=1 AND gully_id NOT IN 
            (SELECT gully_id FROM plan_psector_x_gully WHERE psector_id=NEW.psector_id AND state=0);
            IF num_connec > 0 THEN
                EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                "data":{"message":"3228", "function":"1130","debug_msg":""}}$$);';
            END IF;
        END IF;
        
	ELSIF v_stateaux=2 THEN
		IF NEW.state = 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3182", "function":"1130","debug_msg":'||OLD.psector_id||'}}$$);';
		END IF;
		NEW.state = 1;
		NEW.doable=true;
	END IF;

	RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;