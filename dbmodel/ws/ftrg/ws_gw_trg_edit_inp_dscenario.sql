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

v_dscenario_type text;
  
BEGIN

--Get schema name
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

--Get view name
 v_dscenario_type = TG_ARGV[0];

  IF TG_OP = 'INSERT' THEN

		-- force selector
		INSERT INTO selector_inp_dscenario VALUES (NEW.dscenario_id, current_user) ON CONFLICT (dscenario_id, cur_user) DO NOTHING;
  
		IF v_dscenario_type = 'VALVE' THEN

			-- default values
			IF NEW.valv_type IS NULL OR NEW.valv_type='' THEN NEW.valv_type = (SELECT valv_type FROM v_edit_inp_valve WHERE node_id = NEW.node_id);END IF;
			IF NEW.pressure IS NULL THEN NEW.pressure = (SELECT pressure FROM v_edit_inp_valve WHERE node_id = NEW.node_id);END IF;
			IF NEW.flow IS NULL THEN NEW.flow = (SELECT flow FROM v_edit_inp_valve WHERE node_id = NEW.node_id);END IF;
			IF NEW.coef_loss IS NULL THEN NEW.coef_loss = (SELECT coef_loss FROM v_edit_inp_valve WHERE node_id = NEW.node_id);END IF;
			IF NEW.curve_id IS NULL OR NEW.curve_id='' THEN NEW.curve_id = (SELECT curve_id FROM v_edit_inp_valve WHERE node_id = NEW.node_id);END IF;
			IF NEW.minorloss IS NULL THEN NEW.minorloss = (SELECT minorloss FROM v_edit_inp_valve WHERE node_id = NEW.node_id);END IF;
			IF NEW.status IS NULL OR NEW.status='' THEN NEW.status = (SELECT status FROM v_edit_inp_valve WHERE node_id = NEW.node_id);END IF;
			IF NEW.add_settings IS NULL THEN NEW.add_settings = (SELECT add_settings FROM v_edit_inp_valve WHERE node_id = NEW.node_id);END IF;
		
			INSERT INTO inp_dscenario_valve (dscenario_id, node_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.valv_type, NEW.pressure, NEW.flow, NEW.coef_loss, NEW.curve_id, NEW.minorloss, NEW.status, NEW.add_settings);
		  
		ELSIF v_dscenario_type = 'TANK' THEN

			-- default values
			IF NEW.initlevel IS NULL THEN NEW.initlevel = (SELECT initlevel FROM v_edit_inp_tank WHERE node_id = NEW.node_id);END IF;
			IF NEW.minlevel IS NULL THEN NEW.minlevel = (SELECT minlevel FROM v_edit_inp_tank WHERE node_id = NEW.node_id);END IF;
			IF NEW.maxlevel IS NULL THEN NEW.maxlevel = (SELECT maxlevel FROM v_edit_inp_tank WHERE node_id = NEW.node_id);END IF;
			IF NEW.diameter IS NULL THEN NEW.diameter = (SELECT diameter FROM v_edit_inp_tank WHERE node_id = NEW.node_id);END IF;
			IF NEW.minvol IS NULL THEN NEW.minvol = (SELECT minvol FROM v_edit_inp_tank WHERE node_id = NEW.node_id);END IF;
			IF NEW.curve_id IS NULL OR NEW.curve_id='' THEN NEW.curve_id = (SELECT curve_id FROM v_edit_inp_tank WHERE node_id = NEW.node_id);END IF;
			IF NEW.overflow IS NULL OR NEW.overflow='' THEN NEW.overflow = (SELECT overflow FROM v_edit_inp_tank WHERE node_id = NEW.node_id);END IF;

			INSERT INTO inp_dscenario_tank (dscenario_id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.initlevel, NEW.minlevel, NEW.maxlevel, NEW.diameter, NEW.minvol, NEW.curve_id, NEW.overflow);
			
		ELSIF v_dscenario_type = 'SHORTPIPE' THEN

			-- default values
			IF NEW.minorloss IS NULL THEN NEW.minorloss = (SELECT minorloss FROM v_edit_inp_shortpipe WHERE node_id = NEW.node_id);END IF;
			IF NEW.status IS NULL OR NEW.status='' THEN NEW.status = (SELECT status FROM v_edit_inp_shortpipe WHERE node_id = NEW.node_id);END IF;
		
			INSERT INTO inp_dscenario_shortpipe(dscenario_id, node_id, minorloss, status)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.minorloss, NEW.status);

		ELSIF v_dscenario_type = 'RESERVOIR' THEN

			-- default values
			IF NEW.pattern_id IS NULL OR NEW.pattern_id='' THEN NEW.pattern_id = (SELECT pattern_id FROM v_edit_inp_reservoir WHERE node_id = NEW.node_id);END IF;
			IF NEW.head IS NULL THEN NEW.head = (SELECT head FROM v_edit_inp_reservoir WHERE node_id = NEW.node_id);END IF;
		
			INSERT INTO inp_dscenario_reservoir(dscenario_id, node_id, pattern_id, head)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.pattern_id, NEW.head);

		ELSIF v_dscenario_type = 'PUMP' THEN

			-- default values
			IF NEW.power IS NULL THEN NEW.power = (SELECT power FROM v_edit_inp_pump WHERE node_id = NEW.node_id);END IF;
			IF NEW.curve_id IS NULL OR NEW.curve_id='' THEN NEW.curve_id = (SELECT curve_id FROM v_edit_inp_pump WHERE node_id = NEW.node_id);END IF;
			IF NEW.pattern IS NULL OR NEW.pattern_id='' THEN NEW.pattern_id = (SELECT pattern_id FROM v_edit_inp_pump WHERE node_id = NEW.node_id);END IF;
			IF NEW.status IS NULL OR NEW.status='' THEN NEW.status = (SELECT status FROM v_edit_inp_pump WHERE node_id = NEW.node_id);END IF;
	
			INSERT INTO inp_dscenario_pump(dscenario_id, node_id, power, curve_id, speed, pattern_id, status)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.power, NEW.curve_id, NEW.speed, NEW.pattern_id, NEW.status);

		ELSIF v_dscenario_type = 'PIPE' THEN

			-- default values
			IF NEW.minorloss IS NULL THEN NEW.minorloss = (SELECT minorloss FROM v_edit_inp_pipe WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.status IS NULL OR NEW.status='' THEN NEW.status = (SELECT status FROM v_edit_inp_pipe WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.roughness IS NULL THEN NEW.roughness = (SELECT roughness FROM temp_arc WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.dint IS NULL THEN NEW.dint = (SELECT diameter FROM temp_arc WHERE arc_id = NEW.arc_id);END IF;
		
			INSERT INTO inp_dscenario_pipe(dscenario_id, arc_id, minorloss, status, roughness, dint)
			VALUES (NEW.dscenario_id, NEW.arc_id, NEW.minorloss, NEW.status, NEW.roughness, NEW.dint);
	
		ELSIF v_dscenario_type = 'JUNCTION' THEN

			-- default values
			IF NEW.demand IS NULL THEN NEW.demand = (SELECT demand FROM v_edit_inp_junction WHERE node_id = NEW.node_id);END IF;
			IF NEW.pattern_id IS NULL OR NEW.pattern_id='' THEN NEW.pattern_id = (SELECT pattern_id FROM v_edit_inp_junction WHERE node_id = NEW.node_id);END IF;
	
			INSERT INTO inp_dscenario_junction(dscenario_id, node_id, demand, pattern_id)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.demand, NEW.pattern_id);
			
		ELSIF v_dscenario_type = 'CONNEC' THEN

			-- default values
			IF NEW.demand IS NULL THEN NEW.demand = (SELECT demand FROM v_edit_inp_connec WHERE connec_id = NEW.connec_id);END IF;
			IF NEW.pattern_id IS NULL OR NEW.pattern_id='' THEN NEW.pattern_id = (SELECT pattern_id FROM v_edit_inp_connec WHERE connec_id = NEW.connec_id);END IF;
			IF NEW.custom_roughness IS NULL THEN NEW.custom_roughness = (SELECT custom_roughness FROM v_edit_inp_connec WHERE connec_id = NEW.connec_id);END IF;
			IF NEW.custom_length IS NULL THEN NEW.custom_length = (SELECT custom_length FROM v_edit_inp_connec WHERE connec_id = NEW.connec_id);END IF;
			IF NEW.custom_dint IS NULL THEN NEW.custom_dint = (SELECT custom_dint FROM v_edit_inp_connec WHERE connec_id = NEW.connec_id);END IF;
				
			INSERT INTO inp_dscenario_connec(dscenario_id, connec_id, demand, pattern_id, custom_roughness, custom_length, custom_dint)
			VALUES (NEW.dscenario_id, NEW.connec_id, NEW.demand, NEW.pattern_id, NEW.custom_roughness, NEW.custom_length, NEW.custom_dint);
			
		ELSIF v_dscenario_type = 'INLET' THEN

			-- default values
			IF NEW.initlevel IS NULL THEN NEW.initlevel = (SELECT initlevel FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;
			IF NEW.minlevel IS NULL THEN NEW.minlevel = (SELECT minlevel FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;
			IF NEW.maxlevel IS NULL THEN NEW.maxlevel = (SELECT maxlevel FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;
			IF NEW.diameter IS NULL THEN NEW.diameter = (SELECT diameter FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;
			IF NEW.minvol IS NULL THEN NEW.minvol = (SELECT minvol FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;
			IF NEW.curve_id IS NULL OR NEW.curve_id='' THEN NEW.curve_id = (SELECT curve_id FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;
			IF NEW.overflow IS NULL OR NEW.overflow='' THEN NEW.overflow = (SELECT overflow FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;
			IF NEW.pattern_id IS NULL OR NEW.pattern_id='' THEN NEW.pattern_id = (SELECT pattern_id FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;
			IF NEW.head IS NULL THEN NEW.head = (SELECT head FROM v_edit_inp_inlet WHERE node_id = NEW.node_id);END IF;

			INSERT INTO inp_dscenario_inlet (dscenario_id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow, pattern_id, head)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.initlevel, NEW.minlevel, NEW.maxlevel, NEW.diameter, NEW.minvol, NEW.curve_id, NEW.overflow, NEW.pattern_id, NEW.head);
			
		ELSIF v_dscenario_type = 'VIRTUALVALVE' THEN

			-- default values
			IF NEW.valv_type IS NULL OR NEW.valv_type='' THEN NEW.valv_type = (SELECT valv_type FROM v_edit_inp_virtualvalve WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.pressure IS NULL THEN NEW.pressure = (SELECT pressure FROM v_edit_inp_virtualvalve WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.flow IS NULL THEN NEW.flow = (SELECT flow FROM v_edit_inp_virtualvalve WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.coef_loss IS NULL THEN NEW.coef_loss = (SELECT coef_loss FROM v_edit_inp_virtualvalve WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.curve_id IS NULL OR NEW.curve_id='' THEN NEW.curve_id = (SELECT curve_id FROM v_edit_inp_virtualvalve WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.minorloss IS NULL THEN NEW.minorloss = (SELECT minorloss FROM v_edit_inp_virtualvalve WHERE arc_id = NEW.arc_id);END IF;
			IF NEW.status IS NULL OR NEW.status='' THEN NEW.status = (SELECT status FROM v_edit_inp_virtualvalve WHERE arc_id = NEW.arc_id);END IF;
		
			INSERT INTO inp_dscenario_virtualvalve (dscenario_id, arc_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.valv_type, NEW.pressure, NEW.flow, NEW.coef_loss, NEW.curve_id, NEW.minorloss, NEW.status);
	
		ELSIF v_dscenario_type = 'PUMP_ADDITIONAL' THEN

			-- default values
			IF NEW.power IS NULL THEN NEW.power = (SELECT power FROM v_edit_inp_pump WHERE node_id = NEW.node_id);END IF;
			IF NEW.curve_id IS NULL OR NEW.curve_id='' THEN NEW.curve_id = (SELECT curve_id FROM v_edit_inp_pump WHERE node_id = NEW.node_id);END IF;
			IF NEW.pattern IS NULL OR NEW.pattern='' THEN NEW.pattern = (SELECT pattern FROM v_edit_inp_pump WHERE node_id = NEW.node_id);END IF;
			IF NEW.status IS NULL OR NEW.status='' THEN NEW.status = (SELECT status FROM v_edit_inp_pump WHERE node_id = NEW.node_id);END IF;
			
			INSERT INTO inp_dscenario_pump_additional(dscenario_id, node_id, order_id, power, curve_id, speed, pattern, status)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.power, NEW.curve_id, NEW.speed, NEW.pattern, NEW.status);
		END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_dscenario_type = 'VALVE' THEN
			UPDATE inp_dscenario_valve SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, valv_type=NEW.valv_type, pressure=NEW.pressure, 
			flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id, minorloss=NEW.minorloss, status=NEW.status, add_settings=NEW.add_settings 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
		ELSIF v_dscenario_type = 'TANK' THEN
			UPDATE inp_dscenario_tank SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, initlevel=NEW.initlevel, minlevel=NEW.minlevel,
			maxlevel=NEW.maxlevel, 	diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id, overflow=NEW.overflow
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario_type = 'SHORTPIPE' THEN
			UPDATE inp_dscenario_shortpipe SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, minorloss=NEW.minorloss, status=NEW.status 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario_type = 'RESERVOIR' THEN
			UPDATE inp_dscenario_reservoir SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, pattern_id=NEW.pattern_id, head=NEW.head 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
	  
		ELSIF v_dscenario_type = 'PUMP' THEN
			UPDATE inp_dscenario_pump SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, power=NEW.power, curve_id=NEW.curve_id,
			speed=NEW.speed, pattern=NEW.pattern, status=NEW.status WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario_type = 'PIPE' THEN
			UPDATE inp_dscenario_pipe SET dscenario_id=NEW.dscenario_id, arc_id=NEW.arc_id, minorloss=NEW.minorloss, status=NEW.status,
			roughness=NEW.roughness, dint=NEW.dint WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;
		
		ELSIF v_dscenario_type = 'JUNCTION' THEN
			UPDATE inp_dscenario_junction SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, demand=NEW.demand, pattern_id=NEW.pattern_id, 
			demand_type=NEW.demand_type, peak_factor=NEW.peak_factor
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
		ELSIF v_dscenario_type = 'CONNEC' THEN
			UPDATE inp_dscenario_connec SET dscenario_id=NEW.dscenario_id, connec_id=NEW.connec_id, 
			demand=NEW.demand, pattern_id=NEW.pattern_id, demand_type=NEW.demand_type, peak_factor=NEW.peak_factor, 
			custom_roughness=NEW.custom_roughness, custom_length=NEW.custom_length, custom_dint=NEW.custom_dint
			WHERE dscenario_id=OLD.dscenario_id AND connec_id=OLD.connec_id;

		ELSIF v_dscenario_type = 'INLET' THEN
			UPDATE inp_dscenario_inlet SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, initlevel=NEW.initlevel, minlevel=NEW.minlevel,
			maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id, overflow = NEW.overflow, pattern_id = NEW.pattern_id, head = NEW. head
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
		ELSIF v_dscenario_type = 'VIRTUALVALVE' THEN
			UPDATE inp_dscenario_virtualvalve SET dscenario_id=NEW.dscenario_id, arc_id=NEW.arc_id, valv_type=NEW.valv_type, pressure=NEW.pressure, 
			flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id, minorloss=NEW.minorloss, status=NEW.status			
			WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;
	
		ELSIF v_dscenario_type = 'PUMP_ADDITIONAL' THEN
			UPDATE inp_dscenario_pump_additional SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, power=NEW.power, curve_id=NEW.curve_id,
			speed=NEW.speed, pattern=NEW.pattern, status=NEW.status WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
	
		END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN
		IF v_dscenario_type = 'VALVE' THEN
			DELETE FROM inp_dscenario_valve WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
		
		ELSIF v_dscenario_type = 'TANK' THEN
			DELETE FROM inp_dscenario_tank WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
		
		ELSIF v_dscenario_type = 'SHORTPIPE' THEN
			DELETE FROM inp_dscenario_shortpipe WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario_type = 'RESERVOIR' THEN
			DELETE FROM inp_dscenario_reservoir WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario_type = 'PUMP' THEN
			DELETE FROM inp_dscenario_pump WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario_type = 'PIPE' THEN
			DELETE FROM inp_dscenario_pipe WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;
	    
		ELSIF v_dscenario_type = 'JUNCTION' THEN
			DELETE FROM inp_dscenario_junction WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
		ELSIF v_dscenario_type = 'CONNEC' THEN
			DELETE FROM inp_dscenario_connec WHERE dscenario_id=OLD.dscenario_id AND connec_id=OLD.connec_id;
			
		ELSIF v_dscenario_type = 'INLET' THEN
			DELETE FROM inp_dscenario_inlet WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
		ELSIF v_dscenario_type = 'VIRTUALVALVE' THEN
			DELETE FROM inp_dscenario_virtualvalve WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;
		
		ELSIF v_dscenario_type = 'PUMP_ADDITIONAL' THEN
			DELETE FROM inp_dscenario_pump_additional WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;

		END IF;

		RETURN OLD;  
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
