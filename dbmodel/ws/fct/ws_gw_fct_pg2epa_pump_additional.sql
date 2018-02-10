/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2318

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_pump_additional(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_pump_additional(result_id_var text)  RETURNS integer AS

$BODY$
DECLARE
    
arc_rec record;
pump_rec record;
node_id_aux text;
rec record;
record_new_arc SCHEMA_NAME.arc%ROWTYPE;
n1_geom public.geometry;
n2_geom public.geometry;
p1_geom public.geometry;
p2_geom public.geometry;
angle float;
dist float;
xp1 float;
yp1 float;
xp2 float;
yp2 float;
odd_var float;
pump_order float;


BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public; 

    SELECT * INTO rec FROM version LIMIT 1;
 
--  Start process	
    RAISE NOTICE 'Starting additional pumps process.';
	
--  Loop for pumping stations
    FOR node_id_aux IN (SELECT DISTINCT node_id FROM inp_pump_additional)    
    LOOP

	SELECT * INTO arc_rec FROM rpt_inp_arc WHERE arc_id=concat(node_id_aux,'_n2a') AND result_id=result_id_var;
	
--  	Loop for additional pumps
	FOR pump_rec IN SELECT * FROM inp_pump_additional WHERE node_id=node_id_aux
	LOOP

		-- Id creation from pattern arc 
		record_new_arc.arc_id=concat(arc_rec.arc_id,pump_rec.order_id);

		-- Right or left hand
		odd_var = pump_rec.order_id %2;
		
		if (odd_var)=0 then 
			angle=(ST_Azimuth(ST_startpoint(arc_rec.the_geom), ST_endpoint(arc_rec.the_geom)))+1.57;
		else 
			angle=(ST_Azimuth(ST_startpoint(arc_rec.the_geom), ST_endpoint(arc_rec.the_geom)))-1.57;
			pump_order = (pump_rec.order_id-1);
		end if;

		-- Copiyng values from patter arc
		record_new_arc.node_1 = arc_rec.node_1;
		record_new_arc.node_2 = arc_rec.node_2;
		record_new_arc.epa_type = arc_rec.epa_type;
 		record_new_arc.sector_id = arc_rec.sector_id;
 		record_new_arc.state = arc_rec.state;
 		record_new_arc.arccat_id = arc_rec.arccat_id;
 		
		-- Geometry construction from pattern arc
		-- intermediate variables
		n1_geom = ST_LineInterpolatePoint(arc_rec.the_geom, 0.1);
		n2_geom = ST_LineInterpolatePoint(arc_rec.the_geom, 0.9);
		dist = (ST_Distance(ST_transform(ST_startpoint(arc_rec.the_geom),rec.epsg), ST_LineInterpolatePoint(arc_rec.the_geom, 0.2))); 

		--create point1
		yp1 = ST_y(n1_geom)-(cos(angle))*dist*0.1*(pump_order)::float;
		xp1 = ST_x(n1_geom)-(sin(angle))*dist*0.1*(pump_order)::float;
		p1_geom = ST_SetSRID(ST_MakePoint(xp1, yp1),rec.epsg);	

		--create point2
		yp2 = ST_y(n2_geom)-cos(angle)*dist*0.1*(pump_order)::float;
		xp2 = ST_x(n2_geom)-sin(angle)*dist*0.1*(pump_order)::float;
		p2_geom = ST_SetSRID(ST_MakePoint(xp2, yp2),rec.epsg);	

		--create arc
		record_new_arc.the_geom=ST_makeline(ARRAY[ST_startpoint(arc_rec.the_geom), p2_geom, p1_geom, ST_endpoint(arc_rec.the_geom)]);

		-- Inserting into rpt_inp_arc
		INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, epa_type, sector_id, arccat_id, state, the_geom, expl_id) 
		VALUES (result_id_var, record_new_arc.arc_id, record_new_arc.node_1, record_new_arc.node_2, record_new_arc.epa_type, record_new_arc.sector_id, 
		record_new_arc.arccat_id, record_new_arc.state, record_new_arc.the_geom, record_new_arc.expl_id);
				
	END LOOP;
    
    END LOOP;
     	
    RETURN 1;
		
END;


$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  