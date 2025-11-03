/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 1130

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_plan_psector_x_arc()
  RETURNS trigger AS
$BODY$
DECLARE 

v_stateaux smallint;
v_explaux smallint;
v_psector_expl smallint;
num_connec integer;
v_project_type text;
v_user_planordercontrol boolean;
v_auto_insert_connec boolean;

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Get project type
	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;
    
	-- get user variables
	SELECT value::boolean INTO v_user_planordercontrol FROM config_param_user WHERE parameter='edit_plan_order_control' AND cur_user = current_user;
	SELECT value::boolean INTO v_auto_insert_connec FROM config_param_user WHERE parameter='plan_psector_auto_insert_connec' AND cur_user = current_user;

	SELECT expl_id INTO v_psector_expl FROM plan_psector WHERE psector_id=NEW.psector_id;
	SELECT arc.state, arc.expl_id INTO v_stateaux, v_explaux FROM arc WHERE arc_id=NEW.arc_id;

	-- do not allow to insert features with expl diferent from psector expl
	IF v_explaux<>v_psector_expl THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3234", "function":"1130","parameters":null}}$$);';
	END IF;
	
	IF v_stateaux=1	THEN 
		NEW.state=0;
		NEW.doable=false;
        
		IF v_user_planordercontrol IS TRUE THEN
        
	        
	        IF v_project_type = 'UD' THEN
	        	-- do not allow set arc to obsolete when it has on service gullys
	            SELECT count(*) INTO num_connec FROM v_ui_arc_x_relations WHERE arc_id=NEW.arc_id AND feature_state=1 AND sys_type='GULLY' AND proceed_from='ARC' AND feature_id NOT IN 
	            (SELECT gully_id FROM plan_psector_x_gully WHERE psector_id=NEW.psector_id AND state=0);
				IF num_connec > 0 THEN
					IF v_auto_insert_connec IS TRUE THEN
						-- auto insert connecs
						INSERT INTO plan_psector_x_gully (psector_id, gully_id, state)
						SELECT NEW.psector_id, gully_id, null
						FROM v_ui_arc_x_relations WHERE arc_id=NEW.arc_id AND feature_state=1 AND sys_type='GULLY' AND proceed_from='ARC' AND feature_id NOT IN 
						(SELECT gully_id FROM plan_psector_x_gully WHERE psector_id=NEW.psector_id AND state=0)
						UNION
						SELECT NEW.psector_id, gully_id, 1
						FROM v_ui_arc_x_relations WHERE arc_id=NEW.arc_id AND feature_state=1 AND sys_type='GULLY' AND proceed_from='ARC' AND feature_id NOT IN 
						(SELECT gully_id FROM plan_psector_x_gully WHERE psector_id=NEW.psector_id AND state=0);
					ELSE
						-- do not allow set arc to obsolete when it has on service connecs
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	                	"data":{"message":"3228", "function":"1130","parameters":null}}$$);';
					END IF;
	            END IF;
	           
	           	-- do not allow set arc to obsolete when it has on service connecs
	            SELECT count(*) INTO num_connec FROM v_ui_arc_x_relations WHERE arc_id=NEW.arc_id AND feature_state=1 AND sys_type='CONNEC' AND proceed_from='ARC' AND feature_id NOT IN 
	            (SELECT connec_id FROM plan_psector_x_connec WHERE psector_id=NEW.psector_id AND state=0);
	            IF num_connec > 0 THEN
					IF v_auto_insert_connec IS TRUE THEN
						-- auto insert connecs
						INSERT INTO plan_psector_x_connec (psector_id, connec_id, state)
						SELECT NEW.psector_id, connec_id, null
						FROM v_ui_arc_x_relations WHERE arc_id=NEW.arc_id AND feature_state=1 AND sys_type='CONNEC' AND proceed_from='ARC' AND feature_id NOT IN 
						(SELECT connec_id FROM plan_psector_x_connec WHERE psector_id=NEW.psector_id AND state=0)
						UNION
						SELECT NEW.psector_id, connec_id, 1
						FROM v_ui_arc_x_relations WHERE arc_id=NEW.arc_id AND feature_state=1 AND sys_type='CONNEC' AND proceed_from='ARC' AND feature_id NOT IN 
						(SELECT connec_id FROM plan_psector_x_connec WHERE psector_id=NEW.psector_id AND state=0);
					ELSE
						-- do not allow set arc to obsolete when it has on service connecs
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	                	"data":{"message":"3228", "function":"1130","parameters":null}}$$);';
					END IF;
	            END IF;
	        ELSIF v_project_type = 'WS' THEN
				SELECT count(connec_id) INTO num_connec FROM connec WHERE arc_id=NEW.arc_id AND state=1 AND connec_id NOT IN 
				(SELECT connec_id FROM plan_psector_x_connec WHERE psector_id=NEW.psector_id AND state=0);
				IF num_connec > 0 THEN

					IF v_auto_insert_connec IS TRUE THEN
						-- auto insert connecs
						INSERT INTO plan_psector_x_connec (psector_id, connec_id, state)
						SELECT NEW.psector_id, connec_id, null
						FROM connec WHERE arc_id=NEW.arc_id AND state=1 AND connec_id NOT IN 
						(SELECT connec_id FROM plan_psector_x_connec WHERE psector_id=NEW.psector_id AND state=0)
						UNION
						SELECT NEW.psector_id, connec_id, 1
						FROM connec WHERE arc_id=NEW.arc_id AND state=1 AND connec_id NOT IN 
						(SELECT connec_id FROM plan_psector_x_connec WHERE psector_id=NEW.psector_id AND state=0);
					ELSE
						-- do not allow set arc to obsolete when it has on service connecs
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3228", "function":"1130","parameters":null}}$$);';
					END IF;
				END IF;
	        END IF;
	       
		END IF;
        
	ELSIF v_stateaux=2 THEN
		IF NEW.state = 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3182", "function":"1130","parameters":{"psector_id":"'||NEW.psector_id||'"}}}$$);';
		END IF;
		NEW.state = 1;
		NEW.doable=true;
	END IF;

	RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;