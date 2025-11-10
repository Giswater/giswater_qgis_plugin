/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 1106

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_connec_proximity() 
RETURNS trigger AS 
$BODY$
DECLARE 
v_numConnecs numeric;
v_arc_id integer;
v_connec_proximity double precision;
v_connec_proximity_control boolean;
v_dsbl_error boolean;
v_message text;
v_id integer;
v_type text;
    
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Get connec tolerance from config table
	SELECT ((value::json)->>'value') INTO v_connec_proximity FROM config_param_system WHERE parameter='edit_connec_proximity';
	SELECT ((value::json)->>'activated') INTO v_connec_proximity_control FROM config_param_system WHERE parameter='edit_connec_proximity';
	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_disable_error' ;

	IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_disable_topocontrol' AND cur_user=current_user) IS TRUE THEN
  	v_connec_proximity_control = FALSE;
  	v_dsbl_error=TRUE;
  END IF;

	IF TG_OP = 'INSERT' THEN
		-- Existing connecs  
		v_numConnecs:= (SELECT COUNT(*) FROM connec c WHERE ST_DWithin(NEW.the_geom, c.the_geom, v_connec_proximity) 
			AND c.connec_id != NEW.connec_id AND ((c.state=1 AND NEW.state=1) OR (c.state=2 AND NEW.state=2)));

		-- Existing arc
		v_arc_id := (SELECT arc_id FROM ve_arc WHERE ST_DWithin(NEW.the_geom, ve_arc.the_geom, 0.001) LIMIT 1);

		-- If there is an arc
		IF v_arc_id IS NOT NULL THEN
			NEW.pjoint_type = 'CONNEC';
			NEW.pjoint_id = NEW.connec_id;
			NEW.arc_id = v_arc_id;
		END IF;
		
	ELSIF TG_OP = 'UPDATE' THEN
	
		-- Existing connecs  
		v_numConnecs := (SELECT COUNT(*) FROM connec c 
		WHERE ST_DWithin(NEW.the_geom, c.the_geom, v_connec_proximity) AND c.connec_id != NEW.connec_id
		AND ((c.state=1 AND NEW.state=1) OR (c.state=2 AND NEW.state=2)));

		-- Existing arc
		v_arc_id := (SELECT arc_id FROM ve_arc WHERE ST_DWithin(NEW.the_geom, ve_arc.the_geom, 0.001) LIMIT 1);
		IF v_arc_id IS NOT NULL THEN
			UPDATE connec SET pjoint_type = 'CONNEC', pjoint_id = NEW.connec_id, arc_id = v_arc_id WHERE connec_id = OLD.connec_id;
			DELETE FROM link WHERE feature_id = NEW.connec_id AND feature_type ='CONNEC' RETURNING exit_id, exit_type INTO v_id, v_type;
			IF v_type = 'VNODE' THEN
				DELETE FROM vnode WHERE vnode_id = v_id;
			END IF;
		ELSE
			IF OLD.pjoint_type = 'CONNEC' THEN
				UPDATE connec SET pjoint_type = NULL, pjoint_id = NULL, arc_id = NULL WHERE connec_id = OLD.connec_id;
			END IF;	
		END IF;
	END IF;

	-- If there is an existing connec closer than 'rec.connec_tolerance' meters --> error
	IF (v_numConnecs > 0) AND (v_connec_proximity_control IS TRUE) THEN
		IF v_dsbl_error IS NOT TRUE THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1044", "function":"1106","parameters":{"connec_id":"'||NEW.connec_id||'"}}}$$);';

		ELSE
			SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 1044;
			INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (105, NEW.connec_id, v_message);
		END IF;
	END IF;


	RETURN NEW;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
