/*
This file is part of Giswater 3
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
 id_event_last bigint;



BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


    --Delete previous
    DELETE FROM om_visit_event_photo CASCADE;
    DELETE FROM om_visit_event CASCADE;
    DELETE FROM om_visit CASCADE;
    DELETE FROM om_visit_x_arc;
    DELETE FROM om_visit_x_node;
    DELETE FROM om_visit_x_connec;
    DELETE FROM om_visit_cat CASCADE;


  --Insert Catalog of visit
    INSERT INTO om_visit_cat (id, name, startdate, enddate) VALUES(1, 'Test', now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 5)));
         
 


        --node
        FOR rec_node IN SELECT * FROM node
        LOOP

            --Insert visit
            INSERT INTO om_visit (visitcat_id, startdate, enddate, expl_id, user_name, the_geom) VALUES(1, now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 5)), rec_node.expl_id, 'demo_user', rec_node.the_geom) RETURNING id INTO id_last;
            INSERT INTO om_visit_x_node (visit_id, node_id) VALUES(id_last, rec_node.node_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature_type = 'NODE' or feature_type = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text'
                ,st_x(rec_node.the_geom)::numeric(12,3), st_y(rec_node.the_geom)::numeric(12,3), ROUND(RANDOM()*360)) RETURNING id INTO id_event_last;

                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'https://www.giswater.org/wp-content/uploads/2016/10/GW-logo.png','demo image', ROUND(RANDOM()*360));
                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'http://www.bgeo.es/wp-content/uploads/2015/06/10414886_1538811266370453_9195211735246399786_n.png','demo image', ROUND(RANDOM()*360));
                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'https://i.vimeocdn.com/portrait/6775150_600x600','demo image', ROUND(RANDOM()*360));

            END LOOP;

		
        END LOOP;



	-- arc
	FOR rec_arc IN SELECT * FROM arc
        LOOP

            --Insert visit
            INSERT INTO om_visit (visitcat_id, startdate, enddate, expl_id, user_name) VALUES(1, now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 5)), rec_arc.expl_id, 'demo_user') RETURNING id INTO id_last;
            INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last::int8, rec_arc.arc_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature_type = 'ARC' or feature_type = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text'
                ,st_x(rec_node.the_geom)::numeric(12,3), st_y(rec_node.the_geom)::numeric(12,3), ROUND(RANDOM()*360)) RETURNING id INTO id_event_last;

                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'https://www.giswater.org/wp-content/uploads/2016/10/GW-logo.png','demo image', ROUND(RANDOM()*360));
                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'http://www.bgeo.es/wp-content/uploads/2015/06/10414886_1538811266370453_9195211735246399786_n.png','demo image', ROUND(RANDOM()*360));
                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'https://i.vimeocdn.com/portrait/6775150_600x600','demo image', ROUND(RANDOM()*360));

            END LOOP;

            --Insert event 'rehabit'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='REHABIT' AND (feature_type = 'ARC' or feature_type = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text'
                ,st_x(rec_node.the_geom)::numeric(12,3), st_y(rec_node.the_geom)::numeric(12,3), ROUND(RANDOM()*360)) RETURNING id INTO id_event_last;

                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'https://www.giswater.org/wp-content/uploads/2016/10/GW-logo.png','demo image', ROUND(RANDOM()*360));
                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'http://www.bgeo.es/wp-content/uploads/2015/06/10414886_1538811266370453_9195211735246399786_n.png','demo image', ROUND(RANDOM()*360));
                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'https://i.vimeocdn.com/portrait/6775150_600x600','demo image', ROUND(RANDOM()*360));            END LOOP;

            
        END LOOP;


        --connec
        FOR rec_connec IN SELECT * FROM connec
        LOOP

            --Insert visit
            INSERT INTO om_visit (visitcat_id, startdate, enddate, expl_id, user_name, the_geom) VALUES(1, now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 5)),  rec_connec.expl_id, 'demo_user', rec_connec.the_geom) RETURNING id INTO id_last;
            INSERT INTO om_visit_x_connec (visit_id, connec_id) VALUES(id_last, rec_connec.connec_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature_type = 'CONNEC' or feature_type = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text'
                ,st_x(rec_node.the_geom)::numeric(12,3), st_y(rec_node.the_geom)::numeric(12,3), ROUND(RANDOM()*360)) RETURNING id INTO id_event_last;

                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'https://www.giswater.org/wp-content/uploads/2016/10/GW-logo.png','demo image', ROUND(RANDOM()*360));
                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'http://www.bgeo.es/wp-content/uploads/2015/06/10414886_1538811266370453_9195211735246399786_n.png','demo image', ROUND(RANDOM()*360));
                INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) VALUES(id_last, id_event_last, now(), 'https://i.vimeocdn.com/portrait/6775150_600x600','demo image', ROUND(RANDOM()*360));
            END LOOP;
            
        END LOOP;


    RETURN;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
