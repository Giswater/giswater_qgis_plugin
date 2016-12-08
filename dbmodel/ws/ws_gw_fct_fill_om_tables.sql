/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_fill_om_tables()
  RETURNS void AS
$BODY$DECLARE

 rec_node   record;
 rec_arc   record;
 rec_connec   record;
 rec_parameter record;
 id_last   bigint;


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


    --Delete previous
    DELETE FROM om_visit;
    DELETE FROM om_visit_event;
    DELETE FROM om_visit_x_arc;
    DELETE FROM om_visit_x_node;
    DELETE FROM om_visit_x_connec;

    
      

        --connec
        FOR rec_connec IN SELECT * FROM connec
        LOOP

            --Insert visit
            INSERT INTO om_visit (startdate, enddate, user_name) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user') RETURNING id INTO id_last;
            INSERT INTO om_visit_x_connec (visit_id, connec_id) VALUES(id_last, rec_connec.connec_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature = 'CONNEC' or feature = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, azimut) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text','bottom'
                ,st_x(rec_connec.the_geom)::numeric(12,3), st_y(rec_connec.the_geom)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;

            --Insert event 'picture'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='PICTURE'
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, azimut) VALUES(id_last, now(), rec_parameter.id, 'demo_picture_text', 'demo_picture.png',null
                ,st_x(rec_connec.the_geom)::numeric(12,3), st_y(rec_connec.the_geom)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;
            
        END LOOP;

  

        --node
        FOR rec_node IN SELECT * FROM node
        LOOP

            --Insert visit
            INSERT INTO om_visit (startdate, enddate, user_name) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user') RETURNING id INTO id_last;
            INSERT INTO om_visit_x_node (visit_id, node_id) VALUES(id_last, rec_node.node_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature = 'NODE' or feature = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, azimut) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text','bottom'
                ,st_x(rec_node.the_geom)::numeric(12,3), st_y(rec_node.the_geom)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;

            --Insert event 'picture'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='PICTURE'
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, azimut) VALUES(id_last, now(), rec_parameter.id, 'demo_picture_text', 'demo_picture.png',null
                ,st_x(rec_node.the_geom)::numeric(12,3), st_y(rec_node.the_geom)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;
            
        END LOOP;



	-- arc
	FOR rec_arc IN SELECT * FROM arc
        LOOP

            --Insert visit
            INSERT INTO om_visit (startdate, enddate, user_name) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user') RETURNING id INTO id_last;
            INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last::int8, rec_arc.arc_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature = 'ARC' or feature = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, azimut) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text','bottom'
                ,st_x(ST_Line_Interpolate_Point(rec_arc.the_geom, ROUND(RANDOM())))::numeric(12,3), st_y(ST_Line_Interpolate_Point(rec_arc.the_geom, ROUND(RANDOM())))::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;

	    --Insert event 'picture'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='PICTURE'
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, azimut) VALUES(id_last, now(), rec_parameter.id, 'demo_picture_text', 'demo_picture.png',null
                ,st_x(ST_Line_Interpolate_Point(rec_arc.the_geom, ROUND(RANDOM())))::numeric(12,3), st_y(ST_Line_Interpolate_Point(rec_arc.the_geom, ROUND(RANDOM())))::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;
            
        END LOOP;


    RETURN;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;