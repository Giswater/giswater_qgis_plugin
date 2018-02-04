/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2238

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_nod2arc_data(text);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_nod2arc_data(result_id_var text)
  RETURNS integer AS
$BODY$
DECLARE
    
arc_rec record;
pump_rec record;
node_id_aux text;
rec record;
record_new_arc "SCHEMA_NAME".arc%ROWTYPE;
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
flw_order float;
nodarc_rec record;
rec_flowreg record;
counter integer;
old_node_id text;
old_to_arc text;
epa_type_aux text;


BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public; 
 
--  Start process	
    RAISE NOTICE 'Starting flowregulators process.';

    SELECT * INTO rec FROM version LIMIT 1;
    
    FOR rec_flowreg IN
	SELECT rpt_inp_node.node_id, flwreg_id, to_arc, flwreg_length, 'ori'::text as flw_type FROM inp_flwreg_orifice JOIN rpt_inp_node ON rpt_inp_node.node_id=inp_flwreg_orifice.node_id  
	JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_node.sector_id WHERE result_id=result_id_var 
		UNION 
	SELECT rpt_inp_node.node_id, flwreg_id,  to_arc, flwreg_length, 'out'::text as flw_type FROM inp_flwreg_outlet JOIN rpt_inp_node ON rpt_inp_node.node_id=inp_flwreg_outlet.node_id 
	JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_node.sector_id WHERE result_id=result_id_var 		
		UNION 
	SELECT rpt_inp_node.node_id, flwreg_id,  to_arc, flwreg_length, 'pump'::text as flw_type FROM inp_flwreg_pump JOIN rpt_inp_node ON rpt_inp_node.node_id=inp_flwreg_pump.node_id 
	JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_node.sector_id WHERE result_id=result_id_var
		UNION 
	SELECT rpt_inp_node.node_id, flwreg_id, to_arc, flwreg_length, 'weir'::text as flw_type FROM inp_flwreg_weir 
	JOIN rpt_inp_node ON rpt_inp_node.node_id=inp_flwreg_weir.node_id JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_node.sector_id WHERE result_id=result_id_var
	ORDER BY node_id, to_arc DESC, flwreg_id ASC

	LOOP

		RAISE NOTICE 'Etry loop....%, % ', rec_flowreg.node_id, rec_flowreg.to_arc;

		IF rec_flowreg.flw_type='ori' THEN epa_type_aux='ORIFICE';
		ELSIF rec_flowreg.flw_type='pump' THEN epa_type_aux='PUMP';
		ELSIF rec_flowreg.flw_type='out' THEN epa_type_aux='OUTLET';
		ELSIF rec_flowreg.flw_type='weir' THEN epa_type_aux='WEIR';
		END IF;

		RAISE NOTICE 'epa_type_aux...% ', epa_type_aux;

		IF old_node_id= rec_flowreg.node_id AND old_to_arc =rec_flowreg.to_arc THEN

			counter:=counter+1;
			
			-- Right or left hand
			odd_var = counter %2;
	
			IF (odd_var)=0 then 
				angle=(ST_Azimuth(ST_startpoint(nodarc_rec.the_geom), ST_endpoint(nodarc_rec.the_geom)))+1.57;
				record_new_arc.arc_id=concat(rec_flowreg.node_id,'_',9+counter,'_a');
				
			ELSE 
				angle=(ST_Azimuth(ST_startpoint(nodarc_rec.the_geom), ST_endpoint(nodarc_rec.the_geom)))-1.57;
				counter=counter -1;
				record_new_arc.arc_id=concat(rec_flowreg.node_id,'_',10+counter,'_a');
				
			END IF;
			
			-- Id creation from pattern arc 
			record_new_arc.code=concat(rec_flowreg.node_id,'_',rec_flowreg.to_arc,'_',rec_flowreg.flw_type,'_',rec_flowreg.flwreg_id);

			-- Copiyng values from patter arc
			record_new_arc.node_1 = nodarc_rec.node_1;
			record_new_arc.node_2 = nodarc_rec.node_2;
			record_new_arc.epa_type = epa_type_aux;
			record_new_arc.sector_id = nodarc_rec.sector_id;
			record_new_arc.state = nodarc_rec.state;
			record_new_arc.arccat_id = nodarc_rec.arccat_id;


			-- Geometry construction from pattern arc
			-- intermediate variables
			n1_geom = ST_LineInterpolatePoint(nodarc_rec.the_geom, 0.1);
			n2_geom = ST_LineInterpolatePoint(nodarc_rec.the_geom, 0.9);
			dist = (ST_Distance(ST_transform(ST_startpoint(nodarc_rec.the_geom),rec.epsg), ST_LineInterpolatePoint(nodarc_rec.the_geom, 0.2))); 

			--create point1
			yp1 = ST_y(n1_geom)-(cos(angle))*dist*0.1*(counter)::float;
			xp1 = ST_x(n1_geom)-(sin(angle))*dist*0.1*(counter)::float;
			p1_geom = ST_SetSRID(ST_MakePoint(xp1, yp1),rec.epsg);	

			--create point2
			yp2 = ST_y(n2_geom)-cos(angle)*dist*0.15*(counter)::float;
			xp2 = ST_x(n2_geom)-sin(angle)*dist*0.15*(counter)::float;
			p2_geom = ST_SetSRID(ST_MakePoint(xp2, yp2),rec.epsg);	

			--restablish counter
			IF (odd_var)>0 then 
				counter=counter +1;			
			END IF;

			--create arc
			record_new_arc.the_geom=ST_makeline(ARRAY[ST_startpoint(nodarc_rec.the_geom), p1_geom, p2_geom, ST_endpoint(nodarc_rec.the_geom)]);
			raise notice ' angle %, cos %, p1%, p2 % ' , angle, cos(angle), p1_geom, p2_geom;
	
			-- Inserting into inp_rpt_arc
			INSERT INTO rpt_inp_arc (result_id, arc_id, flw_code, node_1, node_2, epa_type, sector_id, arccat_id, state, the_geom)
			VALUES (result_id_var, record_new_arc.arc_id, record_new_arc.code,record_new_arc.node_1, record_new_arc.node_2, record_new_arc.epa_type, 
			record_new_arc.sector_id, record_new_arc.arccat_id, record_new_arc.state, record_new_arc.the_geom);

			RAISE NOTICE 'epa_type_aux.1..% ', epa_type_aux;

		ELSE

			SELECT * INTO nodarc_rec FROM rpt_inp_arc WHERE flw_code=concat(rec_flowreg.node_id,'_',rec_flowreg.to_arc) AND result_id=result_id_var;
			record_new_arc.code=concat(rec_flowreg.node_id,'_',rec_flowreg.to_arc,'_',rec_flowreg.flw_type,'_',rec_flowreg.flwreg_id);
			UPDATE rpt_inp_arc SET flw_code=record_new_arc.code, epa_type=epa_type_aux WHERE arc_id=nodarc_rec.arc_id;
			counter :=1;

			RAISE NOTICE 'nodarc_rec.arc_id..% ', nodarc_rec.arc_id;
	
		END IF;
		old_node_id= rec_flowreg.node_id;
		old_to_arc= rec_flowreg.to_arc;

		-- update values on node_2 when flow regulator it's a pump, fixing ysur as maximum as possible
		IF rec_flowreg.flw_type='pump' THEN
			UPDATE rpt_inp_node SET ysur=9999 WHERE node_id=record_new_arc.node_2;
		END IF;

		
    END LOOP;
     	
    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_nod2arc_data(text)
  OWNER TO postgres;

  