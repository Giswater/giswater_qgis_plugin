/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_om_visit_singlevent()
  RETURNS trigger AS
$BODY$
DECLARE 
    visit_table varchar;
    v_sql varchar;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    visit_table:= TG_ARGV[0];


    IF TG_OP = 'INSERT' THEN

    	IF NEW.visit_id IS NULL THEN
		NEW.visit_id = (SELECT nextval('om_visit_id_seq'));
	END IF;

            INSERT INTO om_visit(id, visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, the_geom, descript, is_done, class_id, suspendendcat_id) 
            VALUES (NEW.visit_id, NEW.visitcat_id, NEW.ext_code, NEW.startdate, NEW.enddate, NEW.user_name, NEW.webclient_id, NEW.expl_id, NEW.the_geom, NEW.descript, 
            NEW.is_done, NEW.class_id, NEW.suspendendcat_id);
            INSERT INTO om_visit_event( event_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, xcoord, ycoord, 
            compass, tstamp, text, index_val, is_last)
            VALUES (NEW.event_code, NEW.visit_id, NEW.position_id, NEW.position_value, NEW.parameter_id, NEW.value, NEW.value1, NEW.value2, NEW.geom1, NEW.geom2, 
            NEW.geom3, NEW.xcoord, NEW.ycoord, NEW.compass, NEW.tstamp, NEW.text, NEW.index_val, NEW.is_last);

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
            UPDATE om_visit SET id=NEW.visit_id, visitcat_id=NEW.visitcat_id, ext_code=NEW.ext_code, startdate=NEW.startdate, enddate=NEW.enddate, user_name=NEW.user_name,
            webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, the_geom=NEW.the_geom, descript=NEW.descript, is_done=NEW.is_done, class_id=NEW.class_id,
            suspendendcat_id=NEW.suspendendcat_id WHERE id=NEW.visit_id;
            UPDATE om_visit_event SET event_code=NEW.event_code, visit_id=NEW.visit_id, position_id=NEW.position_id, position_value=NEW.position_value, 
            parameter_id=NEW.parameter_id, value=NEW.value, value1=NEW.value1, value2=NEW.value2, geom1=NEW.geom1, geom2=NEW.geom2, geom3=NEW.geom3,
            xcoord=NEW.xcoord, ycoord=NEW.ycoord, compass=NEW.compass, tstamp=NEW.tstamp, text=NEW.text , index_val=NEW.index_val, is_last=NEW.is_last WHERE id=NEW.event_id;

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
