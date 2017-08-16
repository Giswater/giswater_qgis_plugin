/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_arc_node_rotation_update()
  RETURNS trigger AS
$BODY$
DECLARE 
    rec_arc Record; 
    rec_node Record; 
    hemisphere_rotation_bool boolean;
    hemisphere_rotation_aux float;
    ang_aux float;
    count int2;
    azm_aux float;

        
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    
    IF TG_OP='INSERT' THEN

	FOR rec_node IN SELECT node_id, the_geom FROM node WHERE NEW.node_1 = node_id OR NEW.node_2 = node_id
	LOOP
		SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM node JOIN node_type on id=node_type;
		SELECT hemisphere INTO hemisphere_rotation_aux FROM node;
	
		-- init variables
		ang_aux=0;
		count=0;
	
		FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM arc WHERE arc.node_1 = rec_node.node_id or arc.node_2 = rec_node.node_id
		LOOP
			IF rec_arc.node_1=rec_node.node_id THEN
				azm_aux=st_azimuth(st_startpoint(rec_arc.the_geom), st_line_interpolate_point(rec_arc.the_geom,0.01)); 
				IF azm_aux > 3.14159 THEN
					azm_aux = azm_aux-3.14159;
				END IF;
				ang_aux=ang_aux+azm_aux;
				count=count+1;
				
			END IF;
			IF rec_arc.node_2=rec_node.node_id  THEN
				azm_aux=st_azimuth(st_line_interpolate_point(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom)); 
				IF azm_aux > 3.14159 THEN
					azm_aux = azm_aux-3.14159;
				END IF;
				ang_aux=ang_aux+azm_aux;
				count=count+1;
			END IF;
		END LOOP;
	
		ang_aux=ang_aux/count;	
		
		IF hemisphere_rotation_bool IS true THEN
			IF (hemisphere_rotation_aux-ang_aux) >0 or (hemisphere_rotation_aux-ang_aux) < 3.14159 THEN
				ang_aux=ang_aux+3.1459/2;
			ELSE
				ang_aux=ang_aux+3.14159+3.14159/2;
			END IF;
					
		END IF;
	
		UPDATE node set rotation=ang_aux*(180/3.14159) where node_id=rec_node.node_id;
	
	END LOOP;

	RETURN NEW;


    ELSIF TG_OP='UPDATE' THEN

	FOR rec_node IN SELECT node_id, the_geom FROM node WHERE NEW.node_1 = node_id OR NEW.node_2 = node_id
	LOOP
		SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM node JOIN node_type on id=node_type;
		SELECT hemisphere INTO hemisphere_rotation_aux FROM node;
	
		-- init variables
		ang_aux=0;
		count=0;
	
		FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM arc WHERE arc.node_1 = rec_node.node_id or arc.node_2 = rec_node.node_id
		LOOP
			IF rec_arc.node_1=rec_node.node_id THEN
				azm_aux=st_azimuth(st_startpoint(rec_arc.the_geom), st_line_interpolate_point(rec_arc.the_geom,0.01)); 
				IF azm_aux > 3.14159 THEN
					azm_aux = azm_aux-3.14159;
				END IF;
				ang_aux=ang_aux+azm_aux;
				count=count+1;
				
			END IF;
			IF rec_arc.node_2=rec_node.node_id  THEN
				azm_aux=st_azimuth(st_line_interpolate_point(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom)); 
				IF azm_aux > 3.14159 THEN
					azm_aux = azm_aux-3.14159;
				END IF;
				ang_aux=ang_aux+azm_aux;
				count=count+1;
			END IF;
		END LOOP;
	
		ang_aux=ang_aux/count;	
		
		IF hemisphere_rotation_bool IS true THEN
			IF (hemisphere_rotation_aux-ang_aux) >0 or (hemisphere_rotation_aux-ang_aux) < 3.14159 THEN
				ang_aux=ang_aux+3.1459/2;
			ELSE
				ang_aux=ang_aux+3.14159+3.14159/2;
			END IF;
					
		END IF;
	
		UPDATE node set rotation=ang_aux*(180/3.14159) where node_id=rec_node.node_id;
	
	END LOOP;

	RETURN NEW;

   ELSIF TG_OP='DELETE' THEN
   	
	FOR rec_node IN SELECT node_id, the_geom FROM node WHERE OLD.node_1 = node_id OR OLD.node_2 = node_id
	LOOP
		SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM node JOIN node_type on id=node_type;
		SELECT hemisphere INTO hemisphere_rotation_aux FROM node;
	
		-- init variables
		ang_aux=0;
		count=0;
	
		FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM arc WHERE arc.node_1 = rec_node.node_id or arc.node_2 = rec_node.node_id
		LOOP
			IF rec_arc.node_1=rec_node.node_id THEN
				azm_aux=st_azimuth(st_line_interpolate_point(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom)); 
				IF azm_aux > 3.14159 THEN
					azm_aux = azm_aux-3.14159;
				END IF;
				ang_aux=ang_aux+azm_aux;
				count=count+1;
				
			END IF;
			IF rec_arc.node_2=rec_node.node_id  THEN
				azm_aux=st_azimuth(st_line_interpolate_point(rec_arc.the_geom),st_endpoint(rec_arc.the_geom),0.99); 
				IF azm_aux > 3.14159 THEN
					azm_aux = azm_aux-3.14159;
				END IF;
				ang_aux=ang_aux+azm_aux;
				count=count+1;
			END IF;
		END LOOP;

		IF count=0 THEN
			ang_aux=0;
		ELSE
			ang_aux=ang_aux/count;	
		END IF;
		
		IF hemisphere_rotation_bool IS true THEN
			IF (hemisphere_rotation_aux-ang_aux) >0 or (hemisphere_rotation_aux-ang_aux) < 3.14159 THEN
				ang_aux=ang_aux+3.1459/2;
			ELSE
				ang_aux=ang_aux+3.14159+3.14159/2;
			END IF;
					
		END IF;
	
		UPDATE node set rotation=ang_aux*(180/3.14159) where node_id=rec_node.node_id;
	
	END LOOP;

	RETURN OLD;

    END IF;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_trg_arc_node_rotation_update()
  OWNER TO postgres;
  

  
DROP TRIGGER IF EXISTS gw_trg_arc_node_rotation_update ON "SCHEMA_NAME".arc;
CREATE TRIGGER gw_trg_arc_node_rotation_update  AFTER INSERT OR UPDATE OF the_geom OR DELETE  ON "SCHEMA_NAME".arc  FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_arc_node_rotation_update();
