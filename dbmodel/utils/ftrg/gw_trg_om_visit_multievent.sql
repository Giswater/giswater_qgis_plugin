/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    visit_class:= TG_ARGV[0];

    visit_table=(SELECT lower(feature_type) FROM config_visit_class WHERE id=visit_class);
    
    --INFO: v_visit_type=1 (planned) v_visit_type=2(unexpected/incidencia)	
    v_visit_type=(SELECT visit_type FROM config_visit_class WHERE id=visit_class);


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
	IF v_visit_type=1 THEN
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
                     
                    EXECUTE 'INSERT INTO om_visit_event (visit_id, parameter_id, value) VALUES ($1, $2, $3)'
                    USING NEW.visit_id, v_parameters.id, v_new_value_param;
            END LOOP;

            IF visit_table = 'arc' THEN
                INSERT INTO  om_visit_x_arc (visit_id,arc_id) VALUES (NEW.visit_id, NEW.arc_id);

            ELSIF visit_table = 'node' THEN
                INSERT INTO  om_visit_x_node (visit_id,node_id) VALUES (NEW.visit_id, NEW.node_id);

            ELSIF visit_table = 'connec' THEN
                INSERT INTO  om_visit_x_connec (visit_id,connec_id) VALUES (NEW.visit_id, NEW.connec_id);

            ELSIF visit_table = 'gully' THEN
                INSERT INTO  om_visit_x_gully (visit_id,gully_id) VALUES (NEW.visit_id, NEW.gully_id);
            END IF;
        RETURN NEW; 

    ELSIF TG_OP = 'UPDATE' THEN
     
 
	IF v_visit_type=1 THEN
		UPDATE om_visit SET  visitcat_id=NEW.visitcat_id, ext_code=NEW.ext_code, enddate=NEW.enddate, 
		webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, the_geom=NEW.the_geom, descript=NEW.descript, is_done=NEW.is_done, class_id=NEW.class_id,
		lot_id=NEW.lot_id, status=NEW.status WHERE id=NEW.visit_id;
	ELSE 
		
		UPDATE om_visit SET  visitcat_id=NEW.visitcat_id, ext_code=NEW.ext_code, enddate=NEW.enddate,
		webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, the_geom=NEW.the_geom, descript=NEW.descript, is_done=NEW.is_done, class_id=NEW.class_id,
		status=NEW.status WHERE id=NEW.visit_id;
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
        
    RETURN NEW;
    
    ELSIF TG_OP = 'DELETE' THEN
            DELETE FROM om_visit CASCADE WHERE id = OLD.visit_id ;

     --PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"3", "function":"XXX","debug_msg":null, "variables":null}}$$)

        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

