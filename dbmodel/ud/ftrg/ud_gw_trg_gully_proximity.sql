/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2814

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_gully_proximity() 
RETURNS trigger AS 
$BODY$
DECLARE 
v_numConnecs numeric;
v_arc text;
v_gully_proximity double precision;
v_gully_proximity_control boolean;
v_dsbl_error boolean;
v_message text;
v_id integer;
v_type text;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Get gully tolerance from config table
	SELECT ((value::json)->>'value') INTO v_gully_proximity FROM config_param_system WHERE parameter='edit_gully_proximity';
	SELECT ((value::json)->>'activated') INTO v_gully_proximity_control FROM config_param_system WHERE parameter='edit_gully_proximity';
	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_disable_error' ;

	IF TG_OP = 'INSERT' THEN
		-- Existing gullys  
		v_numConnecs:= (SELECT COUNT(*) FROM gully g WHERE ST_DWithin(NEW.the_geom, g.the_geom, v_gully_proximity) 
		AND g.gully_id != NEW.gully_id AND ((g.state=1 AND NEW.state=1) OR (g.state=2 AND NEW.state=2)));
		
		-- Existing arc
		v_arc:= (SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, 0.001));

		-- If there is an arc
		IF v_arc IS NOT NULL THEN
			NEW.pjoint_type = 'GULLY';
			NEW.pjoint_id = NEW.gully_id;
			NEW.arc_id = v_arc;
		END IF;

	ELSIF TG_OP = 'UPDATE' THEN
		-- Existing gullys  
		v_numConnecs :=  (SELECT COUNT(*) FROM gully g WHERE ST_DWithin(NEW.the_geom, g.the_geom, v_gully_proximity) 
		AND g.gully_id != NEW.gully_id AND ((g.state=1 AND NEW.state=1) OR (g.state=2 AND NEW.state=2)));

		-- Existing arc
		v_arc:= (SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, 0.001));
		IF v_arc IS NOT NULL THEN
			UPDATE gully SET pjoint_type = 'GULLY', pjoint_id = NEW.gully_id, arc_id = v_arc WHERE gully_id = OLD.gully_id;
			DELETE FROM link WHERE feature_id = OLD.gully_id AND feature_type ='GULLY' RETURNING exit_id, exit_type INTO v_id, v_type;
			IF v_type = 'VNODE' THEN
				DELETE FROM vnode WHERE vnode_id = v_id;
			END IF;
		ELSE
			IF OLD.pjoint_type = 'GULLY' THEN
				UPDATE gully SET pjoint_type = NULL, pjoint_id = NULL, arc_id = NULL WHERE gully_id = OLD.gully_id;
			END IF;	
		END IF;
		
	END IF;

	-- If there is an existing gully closer than 'rec.gully_tolerance' meters --> error
	IF (v_numConnecs > 0) AND (v_gully_proximity_control IS TRUE) THEN
		IF v_dsbl_error IS NOT TRUE THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1044", "function":"2814","debug_msg":"'||NEW.gully_id||'"}}$$);';
		ELSE 
			SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 1044;
			INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (393, NEW.gully_id, v_message);		
		END IF;
	END IF;

	RETURN NEW;     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
