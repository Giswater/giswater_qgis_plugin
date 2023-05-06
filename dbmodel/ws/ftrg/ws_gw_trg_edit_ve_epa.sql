/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NODE: 3212


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_ve_epa() 
RETURNS trigger AS 
$BODY$

DECLARE 
v_epatype varchar;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_epatype:= TG_ARGV[0];

   
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"1030", "function":"3212","debug_msg":null}}$$);';
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

		IF v_epatype = 'junction' THEN
		UPDATE inp_junction SET demand=NEW.demand, pattern_id=NEW.pattern_id, peak_factor=NEW.peak_factor, emitter_coeff=NEW.emitter_coeff,
		init_quality=NEW.init_quality, source_type=NEW.source_type, source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id 
		WHERE node_id=OLD.node_id;

        ELSIF v_epatype = 'reservoir' THEN
		UPDATE inp_reservoir SET pattern_id=NEW.pattern_id, head = NEW.head, init_quality=NEW.init_quality, source_type=NEW.source_type, 
		source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id WHERE node_id=OLD.node_id;  
			
        ELSIF v_epatype = 'tank' THEN
		UPDATE inp_tank SET initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, 
		curve_id=NEW.curve_id, overflow=NEW.overflow, mixing_model=NEW.mixing_model, mixing_fraction=NEW.mixing_fraction,
		reaction_coeff=NEW.reaction_coeff,  init_quality=NEW.init_quality, source_type=NEW.source_type, 
		source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id WHERE node_id=OLD.node_id;

        ELSIF v_epatype = 'pump' THEN          
		UPDATE inp_pump SET power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern_id=NEW.pattern_id, to_arc=NEW.to_arc,
		status=NEW.status , pump_type=NEW.pump_type, energy_price=NEW.energy_price, energy_pattern_id=NEW.energy_pattern_id,
		effic_curve_id=NEW.effic_curve_id
		WHERE node_id=OLD.node_id;

        ELSIF v_epatype = 'pump_additional' THEN          
		UPDATE inp_pump_additional SET order_id=NEW.order_id, power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern_id=NEW.pattern_id, 
		status=NEW.status, effic_curve_id=NEW.effic_curve_id, energy_price=NEW.energy_price, energy_pattern_id=NEW.energy_pattern_id 
		WHERE node_id=OLD.node_id;

        ELSIF v_epatype = 'valve' THEN     
		UPDATE inp_valve SET valv_type=NEW.valv_type, pressure=NEW.pressure, flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id,	
		minorloss=NEW.minorloss, to_arc=NEW.to_arc, status=NEW.status, custom_dint=NEW.custom_dint, add_settings = NEW.add_settings,
		init_quality=NEW.init_quality WHERE node_id=OLD.node_id;
            
        ELSIF v_epatype = 'shortpipe' THEN     
		UPDATE inp_shortpipe SET minorloss=NEW.minorloss, to_arc=NEW.to_arc, status=NEW.status, bulk_coeff=NEW.bulk_coeff,
		wall_coeff=NEW.wall_coeff WHERE node_id=OLD.node_id;  
	
        ELSIF v_epatype = 'inlet' THEN     
		UPDATE inp_inlet SET initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, 
		curve_id=NEW.curve_id, pattern_id=NEW.pattern_id, head = NEW.head, overflow=NEW.overflow, mixing_model=NEW.mixing_model, 
		mixing_fraction=NEW.mixing_fraction, reaction_coeff=NEW.reaction_coeff, init_quality=NEW.init_quality,
		source_type=NEW.source_type, source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id WHERE node_id=OLD.node_id;
		
	ELSIF v_epatype = 'connec' THEN     
		UPDATE inp_connec SET demand=NEW.demand, pattern_id=NEW.pattern_id, peak_factor=NEW.peak_factor, custom_roughness = NEW.custom_roughness, 
		custom_length = NEW.custom_length, custom_dint = NEW.custom_dint, status = NEW.status, minorloss = NEW.minorloss,
		emitter_coeff=NEW.emitter_coeff,init_quality=NEW.init_quality, source_type=NEW.source_type, source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id 
		WHERE connec_id=OLD.connec_id;

	ELSIF v_epatype = 'pipe' THEN  
		UPDATE inp_pipe SET minorloss=NEW.minorloss, status=NEW.status, custom_roughness=NEW.custom_roughness, 
		custom_dint=NEW.custom_dint WHERE arc_id=OLD.arc_id;

	ELSIF v_epatype = 'virtualvalve' THEN  
		UPDATE inp_virtualvalve SET valv_type=NEW.valv_type, pressure=NEW.pressure, diameter=NEW.diameter, flow=NEW.flow, coef_loss=NEW.coef_loss, 
		curve_id=NEW.curve_id, minorloss=NEW.minorloss, status=NEW.status, init_quality=NEW.init_quality WHERE arc_id=OLD.arc_id;
        END IF;

		RETURN NEW;
        
    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1032", "function":"3212","debug_msg":null}}$$);';
        RETURN NEW;
    
    END IF;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


