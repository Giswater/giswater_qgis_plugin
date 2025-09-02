/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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
		"data":{"message":"1030", "function":"3212","parameters":null}}$$);';
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
			UPDATE inp_pump SET power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern_id=NEW.pattern_id, status=NEW.status,
			energyparam =NEW.energyparam, energyvalue=NEW.energyvalue, pump_type=NEW.pump_type, effic_curve_id=NEW.effic_curve_id,
			energy_price=NEW.energy_price, energy_pattern_id=NEW.energy_pattern_id
			WHERE node_id=OLD.node_id;

			UPDATE man_pump SET to_arc=NEW.to_arc WHERE node_id=NEW.node_id;

        ELSIF v_epatype = 'valve' THEN
			UPDATE inp_valve SET valve_type=NEW.valve_type, setting=NEW.setting,custom_dint=NEW.custom_dint,
			curve_id=NEW.curve_id, minorloss=NEW.minorloss, add_settings = NEW.add_settings,
			init_quality=NEW.init_quality WHERE node_id=OLD.node_id;

			update man_valve set closed = true where new.status = 'CLOSED' AND node_id = OLD.node_id;
			update man_valve set closed = false where new.status IN ('ACTIVE', 'OPEN') and node_id = OLD.node_id;

        ELSIF v_epatype = 'shortpipe' THEN
			UPDATE inp_shortpipe SET minorloss=NEW.minorloss, bulk_coeff = NEW.bulk_coeff, wall_coeff = NEW.wall_coeff, custom_dint=NEW.custom_dint WHERE node_id=OLD.node_id;
			IF NEW.to_arc IS NOT NULL AND ((NEW.to_arc != OLD.to_arc) OR OLD.to_arc IS NULL) THEN

				INSERT INTO config_graph_checkvalve VALUES (NEW.node_id, NEW.to_arc)
				ON CONFLICT (node_id) DO UPDATE SET to_arc=NEW.to_arc;

			ELSIF NEW.to_arc IS NULL AND OLD.to_arc IS NOT NULL THEN
				DELETE FROM config_graph_checkvalve WHERE node_id = NEW.node_id;

			END IF;

        ELSIF v_epatype = 'inlet' THEN
			UPDATE inp_inlet SET initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol,
			curve_id=NEW.curve_id, pattern_id=NEW.pattern_id, head = NEW.head, overflow=NEW.overflow, mixing_model=NEW.mixing_model,
			mixing_fraction=NEW.mixing_fraction, reaction_coeff=NEW.reaction_coeff, init_quality=NEW.init_quality,
			source_type=NEW.source_type, source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id,
			demand=NEW.demand, demand_pattern_id=NEW.demand_pattern_id, emitter_coeff=NEW.emitter_coeff WHERE node_id=OLD.node_id;

		ELSIF v_epatype = 'connec' THEN
			UPDATE inp_connec SET demand=NEW.demand, pattern_id=NEW.pattern_id, peak_factor=NEW.peak_factor, emitter_coeff=NEW.emitter_coeff,
			init_quality=NEW.init_quality, source_type=NEW.source_type, source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id
			WHERE connec_id=OLD.connec_id;
		
		ELSIF v_epatype = 'link' THEN
			UPDATE inp_connec SET minorloss=NEW.minorloss, status=NEW.status, custom_roughness=NEW.custom_roughness,
			custom_dint=NEW.custom_dint, custom_length=NEW.custom_length WHERE connec_id=(SELECT feature_id FROM link WHERE link_id = OLD.link_id);

		ELSIF v_epatype = 'pipe' THEN
			UPDATE inp_pipe SET minorloss=NEW.minorloss, status=NEW.status, custom_roughness=NEW.custom_roughness,
			custom_dint=NEW.custom_dint, reactionparam = NEW.reactionparam, reactionvalue=NEW.reactionvalue, bulk_coeff=NEW.bulk_coeff, wall_coeff=NEW.wall_coeff WHERE arc_id=OLD.arc_id;

		ELSIF v_epatype = 'virtualvalve' THEN
			UPDATE inp_virtualvalve SET valve_type=NEW.valve_type, setting=NEW.setting, diameter=NEW.diameter,
			curve_id=NEW.curve_id, minorloss=NEW.minorloss, status=NEW.status, init_quality=NEW.init_quality WHERE arc_id=OLD.arc_id;

		ELSIF v_epatype = 'frpump' THEN
			UPDATE inp_frpump SET power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern_id=NEW.pattern_id, status=NEW.status,
			energyparam =NEW.energyparam, energyvalue=NEW.energyvalue, pump_type=NEW.pump_type, effic_curve_id=NEW.effic_curve_id,
			energy_price=NEW.energy_price, energy_pattern_id=NEW.energy_pattern_id
			WHERE element_id=NEW.element_id;
		
		ELSIF v_epatype = 'frvalve' THEN
			UPDATE inp_frvalve SET valve_type=NEW.valve_type, custom_dint=NEW.custom_dint, setting=NEW.setting, curve_id=NEW.curve_id, minorloss=NEW.minorloss, add_settings=NEW.add_settings,
			init_quality=NEW.init_quality, status=NEW.status WHERE element_id=NEW.element_id;

		ELSIF v_epatype = 'frshortpipe' THEN
			UPDATE inp_frshortpipe SET minorloss=NEW.minorloss, status=NEW.status, bulk_coeff=NEW.bulk_coeff, wall_coeff=NEW.wall_coeff,
			custom_dint=NEW.custom_dint WHERE element_id=NEW.element_id;
		
		ELSIF v_epatype = 'virtualpump' THEN
			UPDATE inp_virtualpump SET power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern_id=NEW.pattern_id, status=NEW.status,
			effic_curve_id=NEW.effic_curve_id, energy_price=NEW.energy_price, energy_pattern_id=NEW.energy_pattern_id, pump_type=NEW.pump_type WHERE arc_id=OLD.arc_id;
		END IF;

		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1032", "function":"3212","parameters":null}}$$);';
        RETURN NEW;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


