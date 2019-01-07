
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_om_visit_multievent() RETURNS trigger AS $BODY$
DECLARE 
    visit_table varchar;
    v_sql varchar;
    v_parameters record;
    v_new_value_param text;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    visit_table:= TG_ARGV[0];


    IF TG_OP = 'INSERT' THEN

            INSERT INTO om_visit(id, visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, the_geom, descript, is_done, class_id, suspendendcat_id) 
            VALUES (NEW.visit_id, NEW.visitcat_id, NEW.ext_code, NEW.startdate, NEW.enddate, NEW.user_name, NEW.webclient_id, NEW.expl_id, NEW.the_geom, NEW.descript, 
            NEW.is_done, NEW.class_id, NEW.suspendendcat_id);


            FOR v_parameters IN SELECT * FROM om_visit_parameter 
            JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_parameter.id
            JOIN om_visit_class ON om_visit_class.id=om_visit_class_x_parameter.class_id
            WHERE om_visit_parameter.feature_type = upper(visit_table) AND om_visit_class.ismultievent is true
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
            UPDATE om_visit SET  visitcat_id=NEW.visitcat_id, ext_code=NEW.ext_code, startdate=NEW.startdate, enddate=NEW.enddate, user_name=NEW.user_name,
            webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, the_geom=NEW.the_geom, descript=NEW.descript, is_done=NEW.is_done, class_id=NEW.class_id,
            suspendendcat_id=NEW.suspendendcat_id WHERE id=NEW.visit_id;

            FOR v_parameters IN SELECT * FROM om_visit_parameter 
            JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_parameter.id
            JOIN om_visit_class ON om_visit_class.id=om_visit_class_x_parameter.class_id
            WHERE om_visit_parameter.feature_type = upper(visit_table) AND om_visit_class.ismultievent is true
            LOOP
          
                EXECUTE 'SELECT $1.' || v_parameters.id
                    USING NEW
                    INTO v_new_value_param;
            

                  EXECUTE 'UPDATE om_visit_event SET  value=$3 WHERE visit_id=$1 AND parameter_id=$2'
                    USING NEW.visit_id, v_parameters.id, v_new_value_param;
                    

        
        END LOOP;


        IF visit_table = 'arc' THEN
            UPDATE om_visit_x_arc SET visit_id=NEW.visit_id,arc_id=NEW.arc_id where id=NEW.id;

        ELSIF visit_table = 'node' THEN
            UPDATE om_visit_x_node SET visit_id=NEW.visit_id,node_id=NEW.node_id where id=NEW.id;

        ELSIF visit_table = 'connec' THEN      
            UPDATE om_visit_x_connec SET visit_id=NEW.visit_id,connec_id=NEW.connec_id where id=NEW.id;

        ELSIF visit_table = 'gully' THEN
            UPDATE om_visit_x_gully SET visit_id=NEW.visit_id,gully_id=NEW.gully_id where id=NEW.id;

        END IF;  
    RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
            DELETE FROM om_visit CASCADE WHERE id = OLD.visit_id ;

    --  PERFORM audit_function(3); 
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



  

