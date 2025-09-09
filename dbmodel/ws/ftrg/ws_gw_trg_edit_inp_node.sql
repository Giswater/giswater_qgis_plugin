/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION NODE: 1310


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_node()
RETURNS trigger AS
$BODY$

DECLARE
v_node_table varchar;
v_man_table varchar;
v_sql varchar;
v_old_nodetype varchar;
v_new_nodetype varchar;
v_tablename varchar;
v_pol_id varchar;
v_node_id varchar;
v_input json;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_node_table:= TG_ARGV[0];


    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
        IF v_node_table = 'inp_pump_additional' THEN
            INSERT INTO inp_pump_additional (node_id, order_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id)
            VALUES (NEW.node_id, NEW.order_id, NEW.power, NEW.curve_id, NEW.speed, NEW.pattern_id, NEW.status, NEW.effic_curve_id, NEW.energy_price, NEW.energy_pattern_id);
        ELSE
            EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
            "data":{"message":"1030", "function":"1310","parameters":null}}$$);';
        END IF;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

		-- top_elev
		IF (NEW.top_elev <> OLD.top_elev) OR (NEW.custom_top_elev <> OLD.custom_top_elev) THEN
			UPDATE node SET top_elev=NEW.top_elev, custom_top_elev=NEW.custom_top_elev WHERE node_id = OLD.node_id;
		END IF;

		-- depth
		IF (NEW.depth != OLD.depth) OR (NEW.depth IS NULL AND OLD.depth IS NOT NULL) OR (NEW.depth IS NOT NULL AND OLD.depth IS NULL) THEN
			UPDATE node SET depth=NEW.depth WHERE node_id = OLD.node_id;
		END IF;

		-- State
		IF (NEW.state::text != OLD.state::text) THEN
			UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
		END IF;

		-- The geom
		IF st_equals( NEW.the_geom, OLD.the_geom) IS FALSE THEN

			--the_geom
			UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;

			-- Parent id
			SELECT concat('man_',lower(feature_class)), pol_id INTO v_tablename, v_pol_id FROM polygon JOIN cat_feature ON cat_feature.id=polygon.sys_type
			WHERE ST_DWithin(NEW.the_geom, polygon.the_geom, 0.001) LIMIT 1;

			IF v_pol_id IS NOT NULL THEN
				v_sql:= 'SELECT node_id FROM '||v_tablename||' WHERE pol_id::integer='||v_pol_id||' LIMIT 1';
				EXECUTE v_sql INTO v_node_id;
				NEW.parent_id=v_node_id;
			END IF;

			--update top_elev from raster
			IF (SELECT json_extract_path_text(value::json,'activated')::boolean FROM config_param_system WHERE parameter='admin_raster_dem') IS TRUE
			AND (NEW.top_elev IS NULL) AND
			(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_update_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
					NEW.top_elev = (SELECT ST_Value(rast,1,NEW.the_geom,true) FROM ext_raster_dem WHERE id =
					(SELECT id FROM ext_raster_dem WHERE st_dwithin (envelope, NEW.the_geom, 1) LIMIT 1));
			END IF;

		END IF;

		-- catalog
		IF (NEW.nodecat_id <> OLD.nodecat_id) THEN
			v_old_nodetype:= (SELECT cat_feature.feature_class FROM cat_feature JOIN cat_node ON (((cat_feature.id)::text = (cat_node.node_type)::text)) WHERE cat_node.id=OLD.nodecat_id)::text;
			v_new_nodetype:= (SELECT cat_feature.feature_class FROM cat_feature JOIN cat_node ON (((cat_feature.id)::text = (cat_node.node_type)::text)) WHERE cat_node.id=NEW.nodecat_id)::text;
			IF (quote_literal(v_old_nodetype)::text <> quote_literal(v_new_nodetype)::text) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				 "data":{"message":"1016", "function":"1310","parameters":null}}$$);';
				RETURN NULL;
			END IF;
		END IF;

        IF v_node_table = 'inp_junction' THEN
             UPDATE inp_junction SET demand=NEW.demand, pattern_id=NEW.pattern_id, peak_factor=NEW.peak_factor,
             emitter_coeff=NEW.emitter_coeff, init_quality=NEW.init_quality, source_type=NEW.source_type, source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id
             WHERE node_id=OLD.node_id;

        ELSIF v_node_table = 'inp_reservoir' THEN
             UPDATE inp_reservoir SET pattern_id=NEW.pattern_id, head = NEW.head,
             init_quality=NEW.init_quality, source_type=NEW.source_type, source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id
             WHERE node_id=OLD.node_id;

        ELSIF v_node_table = 'inp_tank' THEN
            UPDATE inp_tank SET initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id, overflow=NEW.overflow,
	    mixing_model=NEW.mixing_model, mixing_fraction=NEW.mixing_fraction, reaction_coeff=NEW.reaction_coeff,  init_quality=NEW.init_quality, source_type=NEW.source_type,
	    source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id
            WHERE node_id=OLD.node_id;

        ELSIF v_node_table = 'inp_pump' THEN
            UPDATE inp_pump SET power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern_id=NEW.pattern_id, status=NEW.status , pump_type=NEW.pump_type,
            effic_curve_id = NEW.effic_curve_id, energy_price = NEW.energy_price, energy_pattern_id = NEW.energy_pattern_id
            WHERE node_id=OLD.node_id;

			UPDATE man_pump SET to_arc=NEW.to_arc where node_id=NEW.node_id;

        ELSIF v_node_table = 'inp_pump_additional' THEN
            UPDATE inp_pump_additional SET order_id=NEW.order_id, power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern_id=NEW.pattern_id, status=NEW.status,
            effic_curve_id = NEW.effic_curve_id, energy_price = NEW.energy_price, energy_pattern_id = NEW.energy_pattern_id
            WHERE node_id=OLD.node_id AND order_id=OLD.order_id;

        ELSIF v_node_table = 'inp_valve' THEN
            UPDATE inp_valve SET valve_type=NEW.valve_type, setting=NEW.setting, curve_id=NEW.curve_id,
            minorloss=NEW.minorloss, custom_dint=NEW.custom_dint, add_settings = NEW.add_settings,
            init_quality=NEW.init_quality
            WHERE node_id=OLD.node_id;

			update man_valve set closed = true where new.status = 'CLOSED' AND node_id = OLD.node_id;
			update man_valve set closed = false where new.status IN ('ACTIVE', 'OPEN') and node_id = OLD.node_id;

        ELSIF v_node_table = 'inp_shortpipe' THEN
             UPDATE inp_shortpipe SET minorloss=NEW.minorloss, bulk_coeff = NEW.bulk_coeff, wall_coeff = NEW.wall_coeff WHERE node_id=OLD.node_id;

			IF NEW.to_arc IS NOT NULL AND ((NEW.to_arc != OLD.to_arc) OR OLD.to_arc IS NULL) THEN
				INSERT INTO config_graph_checkvalve VALUES (NEW.node_id, NEW.to_arc)
				ON CONFLICT (node_id) DO UPDATE SET to_arc=NEW.to_arc;
		    ELSIF NEW.to_arc IS NULL AND OLD.to_arc IS NOT NULL THEN
				DELETE FROM config_graph_checkvalve WHERE node_id = NEW.node_id;
			END IF;

        ELSIF v_node_table = 'inp_inlet' THEN
            UPDATE inp_inlet SET initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id,
            pattern_id=NEW.pattern_id, head = NEW.head, overflow=NEW.overflow,
       	    mixing_model=NEW.mixing_model, mixing_fraction=NEW.mixing_fraction, reaction_coeff=NEW.reaction_coeff,  init_quality=NEW.init_quality, source_type=NEW.source_type,
    	    source_quality=NEW.source_quality, source_pattern_id=NEW.source_pattern_id, demand = NEW.demand, demand_pattern_id = NEW.demand_pattern_id, emitter_coeff = NEW.emitter_coeff
            WHERE node_id=OLD.node_id;

        END IF;

        UPDATE node
		SET sector_id=NEW.sector_id, annotation=NEW.annotation, state_type=NEW.state_type
        WHERE node_id=OLD.node_id;

        v_input = concat('{"feature":{"type":"node", "childLayer":"',v_node_table,'", "id":"',NEW.node_id,'"}}');
        -- inp2man_values
		PERFORM gw_fct_man2inp_values(v_input);

		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1032", "function":"1310","parameters":null}}$$);';
        RETURN NEW;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;