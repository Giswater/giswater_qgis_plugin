/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2318

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_pump_additional(result_id_var text)
  RETURNS integer AS
$BODY$

/*
select SCHEMA_NAME.gw_fct_pg2epa_pump_additional('test1')
*/

DECLARE
    
arc_rec record;
pump_rec record;
node_id_aux text;
rec record;
record_new_arc record;
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
v_old_arc_id varchar(16);
v_addparam json;


BEGIN

	--  Search path
    SET search_path = "SCHEMA_NAME", public; 

    SELECT * INTO rec FROM sys_version LIMIT 1;
	
	-- assign value for record_new_arc
	SELECT * INTO record_new_arc FROM arc LIMIT 1;
 
	--  Start process	
    RAISE NOTICE 'Starting additional pumps process.';
	
	--  Loop for pumping stations
    FOR node_id_aux IN (SELECT DISTINCT node_id FROM inp_pump_additional JOIN temp_arc ON concat(node_id,'_n2a')=arc_id)
    LOOP

		SELECT * INTO arc_rec FROM temp_arc WHERE arc_id=concat(node_id_aux,'_n2a');

		-- Loop for additional pumps
		FOR pump_rec IN SELECT * FROM inp_pump_additional WHERE node_id=node_id_aux
		LOOP
				
			-- Id creation from pattern arc
			v_old_arc_id = arc_rec.arc_id;
			record_new_arc.arc_id=concat(arc_rec.arc_id,pump_rec.order_id);

			-- Right or left hand
			odd_var = pump_rec.order_id %2;
			
			if (odd_var)=0 then 
				angle=(ST_Azimuth(ST_startpoint(arc_rec.the_geom), ST_endpoint(arc_rec.the_geom)))+1.57;
			else 
				angle=(ST_Azimuth(ST_startpoint(arc_rec.the_geom), ST_endpoint(arc_rec.the_geom)))-1.57;
			end if;

            pump_order = (pump_rec.order_id);

			-- Copiyng values from patter arc
			record_new_arc.node_1 = arc_rec.node_1;
			record_new_arc.node_2 = arc_rec.node_2;
			record_new_arc.epa_type = arc_rec.epa_type;
			record_new_arc.sector_id = arc_rec.sector_id;
			record_new_arc.state = arc_rec.state;
			record_new_arc.arccat_id = arc_rec.arccat_id;
			
			-- intermediate variables
			n1_geom = ST_LineInterpolatePoint(arc_rec.the_geom, 0.500000);
			dist = (ST_Distance(ST_transform(ST_startpoint(arc_rec.the_geom),rec.epsg), ST_LineInterpolatePoint(arc_rec.the_geom, 0.5000000))); 

			--create point1
			xp1 = ST_x(n1_geom)-(sin(angle))*dist*0.15000*(pump_order::float);
			yp1 = ST_y(n1_geom)-(cos(angle))*dist*0.15000*(pump_order::float);
						
			p1_geom = ST_SetSRID(ST_MakePoint(xp1, yp1),rec.epsg);	
			
			--create arc
			record_new_arc.the_geom=ST_makeline(ARRAY[ST_startpoint(arc_rec.the_geom), p1_geom, ST_endpoint(arc_rec.the_geom)]);

			--addparam
			v_addparam = concat('{"power":"',pump_rec.power,'","curve_id":"',pump_rec.curve_id,'","speed":"',pump_rec.speed,'","pattern":"', pump_rec.pattern,'","to_arc":"',
						 arc_rec.addparam::json->>'to_arc','", "energyparam":"',pump_rec.energyparam,'","energyvalue":"',pump_rec.energyvalue,'","pump_type":"',
						 arc_rec.addparam::json->>'pump_type','"}');	

			-- Inserting into temp_arc
			INSERT INTO temp_arc (arc_id, node_1, node_2, arc_type, epa_type, sector_id, arccat_id, state, state_type, status, the_geom, expl_id, flw_code, addparam, length, diameter, roughness) 
			VALUES (record_new_arc.arc_id, record_new_arc.node_1, record_new_arc.node_2, 'NODE2ARC', record_new_arc.epa_type, record_new_arc.sector_id, 
			record_new_arc.arccat_id, record_new_arc.state, arc_rec.state_type, pump_rec.status, record_new_arc.the_geom, arc_rec.expl_id, v_old_arc_id, v_addparam, arc_rec.length, arc_rec.diameter, arc_rec.roughness);			

		END LOOP;

    END LOOP;
     	
    RETURN 1;
		
END;


$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  