/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2944

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_om_visit_multievent()
  RETURNS trigger AS
$BODY$
DECLARE
    visit_class integer;
    v_sql varchar;
    v_parameters record;
    v_new_value_param text;
    v_query_text text;
    visit_table text;
    v_visit_type integer;
    v_pluginlot boolean;
    v_unit_id integer;
    v_num_elem_visit text;
    v_feature_id bigint;
    v_id_field text;
    v_uuid_field text;
    v_link_table text;
    v_uuid uuid;
    v_new_json jsonb;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    visit_class:= TG_ARGV[0];

    visit_table=(SELECT lower(feature_type) FROM config_visit_class WHERE id=visit_class);
	v_id_field   := visit_table || '_id';
    v_uuid_field := visit_table || '_uuid';
    v_link_table := 'om_visit_x_' || visit_table;

    --INFO: v_visit_type=1 (planned) v_visit_type=2(unexpected/incidencia)
    v_visit_type=(SELECT visit_type FROM config_visit_class WHERE id=visit_class);

    select upper(value::json->>'lotManage'::text) INTO v_pluginlot from config_param_system where parameter = 'plugin_lotmanage';

    IF TG_OP = 'INSERT' THEN

	IF NEW.visit_id IS NULL THEN
		PERFORM setval('"SCHEMA_NAME".om_visit_id_seq', (SELECT max(id) FROM om_visit), true);
		NEW.visit_id = (SELECT nextval('om_visit_id_seq'));
	END IF;

	IF NEW.startdate IS NULL THEN
		NEW.startdate = left (date_trunc('second', now())::text, 19);
	END IF;

    IF NEW.status IS NULL THEN
		NEW.status=4;
	END IF;

	-- force enddate for planified visits (unexpected can have enddate NULL to manage it later)
	IF NEW.status=4 AND NEW.enddate IS NULL AND v_visit_type=1 THEN
		NEW.enddate=left (date_trunc('second', now())::text, 19);
	END IF;

	-- only for planified visits insert lot_id
	IF v_pluginlot AND v_visit_type=1 AND (SELECT parent_id FROM config_visit_class WHERE id=NEW.class_id) IS NOT NULL THEN
		INSERT INTO om_visit(id, visitcat_id, ext_code, startdate, enddate, webclient_id, expl_id, the_geom, descript, is_done, class_id, lot_id, status, unit_id)
		VALUES (NEW.visit_id, NEW.visitcat_id, NEW.ext_code, NEW.startdate::timestamp, NEW.enddate, NEW.webclient_id, NEW.expl_id, NEW.the_geom, NEW.descript,
		NEW.is_done, NEW.class_id, NEW.lot_id, NEW.status, NEW.unit_id);
	ELSIF v_pluginlot AND v_visit_type=1 THEN
		INSERT INTO om_visit(id, visitcat_id, ext_code, startdate, enddate, webclient_id, expl_id, the_geom, descript, is_done, class_id, lot_id, status)
		VALUES (NEW.visit_id, NEW.visitcat_id, NEW.ext_code, NEW.startdate::timestamp, NEW.enddate, NEW.webclient_id, NEW.expl_id, NEW.the_geom, NEW.descript,
		NEW.is_done, NEW.class_id, NEW.lot_id, NEW.status);
	ELSE
		INSERT INTO om_visit(id, visitcat_id, ext_code, startdate, enddate, webclient_id, expl_id, the_geom, descript, is_done, class_id, status)
		VALUES (NEW.visit_id, NEW.visitcat_id, NEW.ext_code, NEW.startdate::timestamp, NEW.enddate, NEW.webclient_id, NEW.expl_id, NEW.the_geom, NEW.descript,
		NEW.is_done, NEW.class_id, NEW.status);
	END IF;


	-- Get related parameters(events) from visit_class
	v_query_text='	SELECT * FROM config_visit_parameter
			JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=config_visit_parameter.id
			JOIN config_visit_class ON config_visit_class.id=config_visit_class_x_parameter.class_id
			WHERE config_visit_class.id='||visit_class||' AND config_visit_class.ismultievent is true 
			AND config_visit_parameter.active IS TRUE AND config_visit_class_x_parameter.active IS TRUE';
	FOR v_parameters IN EXECUTE v_query_text
        LOOP
                EXECUTE 'SELECT $1.' || v_parameters.id
                    USING NEW
                    INTO v_new_value_param;
                    --exception to manage parameter 'num_elem_visit' to set who many elements are visited with this unit_id
                    IF v_parameters.id='num_elem_visit' THEN
                        IF visit_table = 'arc' THEN
                            SELECT unit_id INTO v_unit_id FROM om_visit_lot_x_arc WHERE arc_id=NEW.arc_id AND lot_id=NEW.lot_id;
                        ELSIF visit_table = 'node' THEN
                            SELECT unit_id INTO v_unit_id FROM om_visit_lot_x_node WHERE node_id=NEW.node_id AND lot_id=NEW.lot_id;
                        END IF;

                        SELECT string_agg (concat, ' ') INTO v_num_elem_visit FROM (
                        SELECT concat('trams:', array_agg(arc_id)) FROM om_visit_lot_x_arc WHERE unit_id=v_unit_id AND lot_id=NEW.lot_id
                        UNION
                        SELECT concat('nodes:', array_agg(node_id)) FROM om_visit_lot_x_node WHERE unit_id=v_unit_id AND lot_id=NEW.lot_id)b;

                        v_new_value_param=v_num_elem_visit;
                   	END IF;

                    EXECUTE 'INSERT INTO om_visit_event (visit_id, parameter_id, value) VALUES ($1, $2, $3)'
                    USING NEW.visit_id, v_parameters.id, v_new_value_param;
            END LOOP;

			-- insert into om_visit_x_* tables. Exception to manage *_uuid field if exists and we need it to insert coming from Qfield
			-- convert NEW to a jsonb to prove if this field exists
		    v_new_json := to_jsonb(NEW);
		
		    IF v_new_json ? v_uuid_field THEN
		        -- *_uuid exists in the trigger view
		        v_uuid := (v_new_json ->> v_uuid_field)::uuid;
		
		        IF v_uuid IS NOT NULL THEN
		            -- uuid value exists in the parent table
		            EXECUTE format('SELECT %I FROM %I WHERE uuid = $1', v_id_field, visit_table)
		            INTO v_feature_id
		            USING v_uuid;
		        END IF;
		    END IF;
		
		    IF v_feature_id IS NOT NULL THEN
		        -- insert with uuid
		        v_sql := format(
		            'INSERT INTO %I (visit_id, %I, %I) VALUES ($1, $2, $3)',
		            v_link_table, v_id_field, v_uuid_field
		        );
		        EXECUTE v_sql USING NEW.visit_id, v_feature_id, v_uuid;
		    ELSE
		        -- insert withoud uuid
		        v_sql := format(
		            'INSERT INTO %I (visit_id, %I) VALUES ($1, ($2).%I)',
		            v_link_table, v_id_field, v_id_field
		        );
		        EXECUTE v_sql USING NEW.visit_id, NEW, v_id_field;
		    END IF;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN


 	IF visit_table <> 'arc' then

		IF v_pluginlot AND v_visit_type=1 THEN
			UPDATE om_visit SET  visitcat_id=NEW.visitcat_id, ext_code=NEW.ext_code, enddate=NEW.enddate,
			webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, the_geom=NEW.the_geom, descript=NEW.descript, is_done=NEW.is_done, class_id=NEW.class_id,
			lot_id=NEW.lot_id, status=NEW.status WHERE id=NEW.visit_id;
		ELSE

			UPDATE om_visit SET  visitcat_id=NEW.visitcat_id, ext_code=NEW.ext_code, enddate=NEW.enddate,
			webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, the_geom=NEW.the_geom, descript=NEW.descript, is_done=NEW.is_done, class_id=NEW.class_id,
			status=NEW.status WHERE id=NEW.visit_id;
		END IF;

	ELSE

		IF v_pluginlot AND v_visit_type=1 THEN
			UPDATE om_visit SET  visitcat_id=NEW.visitcat_id, ext_code=NEW.ext_code, enddate=NEW.enddate,
			webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, the_geom=ST_CENTROID(NEW.the_geom), descript=NEW.descript, is_done=NEW.is_done, class_id=NEW.class_id,
			lot_id=NEW.lot_id, status=NEW.status WHERE id=NEW.visit_id;
		ELSE

			UPDATE om_visit SET  visitcat_id=NEW.visitcat_id, ext_code=NEW.ext_code, enddate=NEW.enddate,
			webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, the_geom=ST_CENTROID(NEW.the_geom), descript=NEW.descript, is_done=NEW.is_done, class_id=NEW.class_id,
			status=NEW.status WHERE id=NEW.visit_id;
		END IF;

	END IF;

   	-- Get related parameters(events) from visit_class
	v_query_text='	SELECT * FROM config_visit_parameter
			JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=config_visit_parameter.id
			JOIN config_visit_class ON config_visit_class.id=config_visit_class_x_parameter.class_id
			WHERE config_visit_class.id='||visit_class||' AND config_visit_class.ismultievent is true
			AND config_visit_parameter.active IS TRUE AND config_visit_class_x_parameter.active IS TRUE';

	FOR v_parameters IN EXECUTE v_query_text
	LOOP
		EXECUTE 'SELECT $1.' || v_parameters.id
		    USING NEW
                    INTO v_new_value_param;

		EXECUTE 'UPDATE om_visit_event SET  value=$3 WHERE visit_id=$1 AND parameter_id=$2'
                    USING NEW.visit_id, v_parameters.id, v_new_value_param;
        END LOOP;

    -- set enddate when change to closed status (4) from another previous status
	IF NEW.status = 4 AND OLD.status < 4 THEN
		NEW.enddate=left (date_trunc('second', now())::text, 19);
		UPDATE om_visit SET enddate=NEW.enddate WHERE id=NEW.visit_id;
	END IF;

    RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
            DELETE FROM om_visit CASCADE WHERE id = OLD.visit_id ;

     --PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"3", "function":"XXX","parameters":null, "variables":null}}$$)

        RETURN NULL;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

