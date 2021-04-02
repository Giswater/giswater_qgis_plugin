/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3022

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_plan_psector_delete()
  RETURNS trigger AS
$BODY$
DECLARE 
v_parent text;
v_count integer;
v_state integer;

BEGIN 
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_parent:= TG_ARGV[0];

	-- counting if psector is last psector for that feature
	IF v_parent = 'arc' THEN
		SELECT count(psector_id) INTO v_count FROM plan_psector_x_arc JOIN arc USING (arc_id) WHERE arc.state = 2 AND arc_id = OLD.arc_id;
		v_state:= (SELECT state FROM arc WHERE arc_id = OLD.arc_id);
	ELSIF v_parent = 'node' THEN
		SELECT count(psector_id) INTO v_count FROM plan_psector_x_node JOIN node USING (node_id) WHERE node.state = 2 AND node_id = OLD.node_id;
		v_state:= (SELECT state FROM node WHERE node_id = OLD.node_id);
	ELSIF v_parent = 'connec' THEN
		SELECT count(psector_id) INTO v_count FROM plan_psector_x_connec JOIN connec USING (connec_id) WHERE connec.state = 2 AND connec_id = OLD.connec_id;
		v_state:= (SELECT state FROM connec WHERE connec_id = OLD.connec_id);
	ELSIF v_parent = 'gully' THEN
		SELECT count(psector_id) INTO v_count FROM plan_psector_x_gully JOIN gully USING (gully_id) WHERE gully.state = 2 AND gully_id = OLD.gully_id;
		v_state:= (SELECT state FROM gully WHERE gully_id = OLD.gully_id);
	END IF;

	-- if last psector
	IF  v_count = 0 and v_state=2 THEN

		-- get variable in order to force (or not) delete
		IF (SELECT lower(value) FROM config_param_user WHERE parameter = 'plan_psector_force_delete' AND cur_user= current_user) !='true' THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3160", "function":"1130","debug_msg":'||OLD.psector_id||'}}$$);';
		ELSE
			IF v_parent = 'arc' THEN
				EXECUTE' SELECT gw_fct_setfeaturedelete($${
				"client":{"device":4, "infoType":1, "lang":"ES"},
				"form":{},"feature":{"type":"ARC"},
				"data":{"feature_id":"'||OLD.arc_id||'"}}$$);';
			ELSIF v_parent = 'node' THEN
				EXECUTE' SELECT gw_fct_setfeaturedelete($${
				"client":{"device":4, "infoType":1, "lang":"ES"},
				"form":{},"feature":{"type":"NODE"},
				"data":{"feature_id":"'||OLD.node_id||'"}}$$);';
			ELSIF v_parent = 'connec' THEN
				EXECUTE' SELECT gw_fct_setfeaturedelete($${
				"client":{"device":4, "infoType":1, "lang":"ES"},
				"form":{},"feature":{"type":"CONNEC"},
				"data":{"feature_id":"'||OLD.connec_id||'"}}$$);';	
			ELSIF v_parent = 'gully' THEN
				EXECUTE' SELECT gw_fct_setfeaturedelete($${
				"client":{"device":4, "infoType":1, "lang":"ES"},
				"form":{},"feature":{"type":"GULLY"},
				"data":{"feature_id":"'||OLD.gully_id||'"}}$$);';
			END IF;
		END IF;
	END IF;
	
	RETURN OLD;
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;