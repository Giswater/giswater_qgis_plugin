/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_fill_om_tables() RETURNS void AS $BODY$DECLARE

 rec_node   record;
 rec_arc    record;
 rec_connec  record;
 rec_parameter record;
 id_last   bigint;
 the_geom_last public.geometry;


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
            INSERT INTO om_visit (startdate, enddate, user_name, the_geom) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user', rec_connec.the_geom) RETURNING id INTO id_last;
            INSERT INTO om_visit_x_connec (visit_id, connec_id) VALUES(id_last, rec_connec.connec_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature = 'CONNEC' or feature = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text','bottom'
                ,st_x(rec_connec.the_geom)::numeric(12,3), st_y(rec_connec.the_geom)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;

            --Insert event 'picture'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='PICTURE'
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id, 'demo_picture.png', 'demo_picture_text',null
                ,st_x(rec_connec.the_geom)::numeric(12,3), st_y(rec_connec.the_geom)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;
            
        END LOOP;

  

        --node
        FOR rec_node IN SELECT * FROM node
        LOOP

            --Insert visit
            INSERT INTO om_visit (startdate, enddate, user_name, the_geom) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user', rec_node.the_geom) RETURNING id INTO id_last;
            INSERT INTO om_visit_x_node (visit_id, node_id) VALUES(id_last, rec_node.node_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature = 'NODE' or feature = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text','bottom'
                ,st_x(rec_node.the_geom)::numeric(12,3), st_y(rec_node.the_geom)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;

            --Insert event 'picture'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='PICTURE'
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id, 'demo_picture.png', 'demo_picture_text',null
                ,st_x(rec_node.the_geom)::numeric(12,3), st_y(rec_node.the_geom)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;
            
        END LOOP;



	-- arc
	FOR rec_arc IN SELECT * FROM arc
        LOOP

            --Insert visit
            the_geom_last=ST_LineInterpolatePoint(rec_arc.the_geom, RANDOM());
            INSERT INTO om_visit (startdate, enddate, user_name, the_geom) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user', the_geom_last) RETURNING id INTO id_last;
            INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last::int8, rec_arc.arc_id);

            --Insert event 'inspection'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='INSPECTION' AND (feature = 'ARC' or feature = 'ALL')
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id,'demo value','demo text','bottom'
                ,st_x(the_geom_last)::numeric(12,3), st_y(the_geom_last)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;

	    --Insert event 'picture'
            FOR rec_parameter IN SELECT * FROM om_visit_parameter WHERE parameter_type='PICTURE'
            LOOP
                INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id, 'demo_picture.png', 'demo_picture_text',null
                ,st_x(the_geom_last)::numeric(12,3), st_y(the_geom_last)::numeric(12,3), ROUND(RANDOM()*360));
            END LOOP;
            
        END LOOP;

        
	FOR rec_arc IN SELECT * FROM v_edit_arc join cat_arc on arccat_id=id where dint > 100
        LOOP
            --Insert visit
            the_geom_last=ST_LineInterpolatePoint(rec_arc.the_geom, RANDOM());
            INSERT INTO om_visit (startdate, enddate, user_name, the_geom) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user', the_geom_last) RETURNING id INTO id_last;
            INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last::int8, rec_arc.arc_id);

            --Insert event 'leak'
            SELECT * INTO rec_parameter FROM om_visit_parameter WHERE parameter_type='LEAK' limit 1;
            INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id, null,null,null
            ,st_x(the_geom_last)::numeric(12,3), st_y(the_geom_last)::numeric(12,3), ROUND(RANDOM()*360));     

            
	END LOOP;


	FOR rec_arc IN SELECT * FROM v_edit_arc join cat_arc on arccat_id=id where dint > 140
        LOOP
            --Insert visit
            the_geom_last=ST_LineInterpolatePoint(rec_arc.the_geom, RANDOM());
            INSERT INTO om_visit (startdate, enddate, user_name, the_geom) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user', the_geom_last) RETURNING id INTO id_last;
            INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last::int8, rec_arc.arc_id);      
            
	    SELECT * INTO rec_parameter FROM om_visit_parameter WHERE parameter_type='LEAK' limit 1 offset 1;
            INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id, null,null,null
            ,st_x(the_geom_last)::numeric(12,3), st_y(the_geom_last)::numeric(12,3), ROUND(RANDOM()*360));

	END LOOP;



	FOR rec_arc IN SELECT * FROM v_edit_arc join cat_arc on arccat_id=id where dint > 170
        LOOP
            --Insert visit
            the_geom_last=ST_LineInterpolatePoint(rec_arc.the_geom, RANDOM());
            INSERT INTO om_visit (startdate, enddate, user_name, the_geom) VALUES(now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 100)), 'demo_user', the_geom_last) RETURNING id INTO id_last;
            INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last::int8, rec_arc.arc_id);      
            
	    SELECT * INTO rec_parameter FROM om_visit_parameter WHERE parameter_type='LEAK' limit 1 offset 2;
            INSERT INTO om_visit_event (visit_id, tstamp, parameter_id, value, text, position_id, xcoord, ycoord, compass) VALUES(id_last, now(), rec_parameter.id, null,null,null
            ,st_x(the_geom_last)::numeric(12,3), st_y(the_geom_last)::numeric(12,3), ROUND(RANDOM()*360));

	END LOOP;


    RETURN;


        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;