/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- FUNCTION NUMBER : 3074

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_dscenario()
  RETURNS trigger AS
$BODY$
DECLARE 

v_dscenario text;
  
BEGIN

--Get schema name
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

--Get view name
 v_dscenario = TG_ARGV[0];

    
  IF TG_OP = 'INSERT' THEN
		IF v_dscenario = 'VALVE' THEN
			INSERT INTO inp_dscenario_valve (dscenario_id, node_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.valv_type, NEW.pressure, NEW.flow, NEW.coef_loss, NEW.curve_id, NEW.minorloss, NEW.status, NEW.add_settings);
		  
		ELSIF v_dscenario = 'TANK' THEN
			INSERT INTO inp_dscenario_tank (dscenario_id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.initlevel, NEW.minlevel, NEW.maxlevel, NEW.diameter, NEW.minvol, NEW.curve_id);
			
			ELSIF v_dscenario = 'SHORTPIPE' THEN
			INSERT INTO inp_dscenario_shortpipe(dscenario_id, node_id, minorloss, status)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.minorloss, NEW.status);

		ELSIF v_dscenario = 'RESERVOIR' THEN
			INSERT INTO inp_dscenario_reservoir(dscenario_id, node_id, pattern_id, head)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.pattern_id, NEW.head);

		ELSIF v_dscenario = 'PUMP' THEN
			INSERT INTO inp_dscenario_pump(dscenario_id, node_id, power, curve_id, speed, pattern, status)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.power, NEW.curve_id, NEW.speed, NEW.pattern, NEW.status);

		ELSIF v_dscenario = 'PIPE' THEN
			INSERT INTO inp_dscenario_pipe(dscenario_id, arc_id, minorloss, status, roughness, dint)
			VALUES (NEW.dscenario_id, NEW.arc_id, NEW.minorloss, NEW.status, NEW.roughness, NEW.dint);

		END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_dscenario = 'VALVE' THEN
			UPDATE inp_dscenario_valve SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, valv_type=NEW.valv_type, pressure=NEW.pressure, 
			flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id, minorloss=NEW.minorloss, status=NEW.status, add_settings=NEW.add_settings 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
		ELSIF v_dscenario = 'TANK' THEN
			UPDATE inp_dscenario_tank SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, initlevel=NEW.initlevel, minlevel=NEW.minlevel,
			maxlevel=NEW.maxlevel, 	diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'SHORTPIPE' THEN
			UPDATE inp_dscenario_shortpipe SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, minorloss=NEW.minorloss, status=NEW.status 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'RESERVOIR' THEN
			UPDATE inp_dscenario_reservoir SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, pattern_id=NEW.pattern_id, head=NEW.head 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
	  
		ELSIF v_dscenario = 'PUMP' THEN
			UPDATE inp_dscenario_pump SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, power=NEW.power, curve_id=NEW.curve_id,
			speed=NEW.speed, pattern=NEW.pattern, status=NEW.status WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'PIPE' THEN
			UPDATE inp_dscenario_pipe SET dscenario_id=NEW.dscenario_id, arc_id=NEW.arc_id, minorloss=NEW.minorloss, status=NEW.status,
			roughness=NEW.roughness, dint=NEW.dint WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;
		
		END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN
		IF v_dscenario = 'VALVE' THEN
			DELETE FROM inp_dscenario_valve WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
		
		ELSIF v_dscenario = 'TANK' THEN
			DELETE FROM inp_dscenario_tank WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
		
		ELSIF v_dscenario = 'SHORTPIPE' THEN
			DELETE FROM inp_dscenario_shortpipe WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'RESERVOIR' THEN
			DELETE FROM inp_dscenario_reservoir WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'PUMP' THEN
			DELETE FROM inp_dscenario_pump WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'PIPE' THEN
			DELETE FROM inp_dscenario_pipe WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;
	    
		END IF;

		RETURN OLD;
  
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
