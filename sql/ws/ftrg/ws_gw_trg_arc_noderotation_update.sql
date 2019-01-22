/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1346

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_noderotation_update()
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
    rec_config record;
    connec_id_aux text;
    array_agg text[];

        
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_noderotation_update_dissbl' AND cur_user=current_user) IS NOT TRUE THEN 
    
		IF TG_OP='INSERT' THEN
	
			FOR rec_node IN SELECT * FROM v_edit_node WHERE NEW.node_1 = node_id OR NEW.node_2 = node_id
			LOOP
				SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM v_edit_node JOIN node_type ON rec_node.nodetype_id=id;
				SELECT hemisphere INTO hemisphere_rotation_aux FROM v_edit_node WHERE node_id=rec_node.node_id;
			
				-- init variables
				ang_aux=0;
				count=0;
			
				FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM arc WHERE arc.node_1 = rec_node.node_id or arc.node_2 = rec_node.node_id
				LOOP
					IF rec_arc.node_1=rec_node.node_id THEN
						azm_aux=st_azimuth(st_startpoint(rec_arc.the_geom), ST_LineInterpolatePoint(rec_arc.the_geom,0.01)); 
						IF azm_aux > 3.14159 THEN
							azm_aux = azm_aux-3.14159;
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;	
					END IF;
					IF rec_arc.node_2=rec_node.node_id  THEN
						azm_aux=st_azimuth(ST_LineInterpolatePoint(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom)); 
						IF azm_aux > 3.14159 THEN
							azm_aux = azm_aux-3.14159;
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;
					END IF;
				END LOOP	;
			
				ang_aux=ang_aux/count;	
				
				IF hemisphere_rotation_bool IS true THEN
		
					IF (hemisphere_rotation_aux >180)  THEN
						UPDATE node set rotation=(ang_aux*(180/3.14159)+90) where node_id=rec_node.node_id;
					ELSE		
						UPDATE node set rotation=(ang_aux*(180/3.14159)-90) where node_id=rec_node.node_id;
					END IF;
				ELSE
					UPDATE node set rotation=(ang_aux*(180/3.14159)-90) where node_id=rec_node.node_id;		
				END IF;	
				
			END LOOP;

			RETURN NEW;
	
		ELSIF TG_OP='UPDATE' THEN

			FOR rec_node IN SELECT * FROM v_edit_node WHERE NEW.node_1 = node_id OR NEW.node_2 = node_id
			LOOP
				SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM v_edit_node JOIN node_type ON rec_node.nodetype_id=id;
				SELECT hemisphere INTO hemisphere_rotation_aux FROM v_edit_node WHERE node_id=rec_node.node_id;
		
				-- init variables
				ang_aux=0;
				count=0;
			
				FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM arc WHERE arc.node_1 = rec_node.node_id or arc.node_2 = rec_node.node_id
				LOOP
					IF rec_arc.node_1=rec_node.node_id THEN
						azm_aux=st_azimuth(st_startpoint(rec_arc.the_geom), ST_LineInterpolatePoint(rec_arc.the_geom,0.01)); 
						IF azm_aux > 3.14159 THEN
							azm_aux = azm_aux-3.14159;
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;			
					END IF;
			
					IF rec_arc.node_2=rec_node.node_id  THEN
						azm_aux=st_azimuth(ST_LineInterpolatePoint(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom)); 
						IF azm_aux > 3.14159 THEN
							azm_aux = azm_aux-3.14159;
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;
					END IF;
				END LOOP;
			
				ang_aux=ang_aux/count;	
		
				IF hemisphere_rotation_bool IS true THEN
		
					IF (hemisphere_rotation_aux >180)  THEN
						UPDATE node set rotation=(ang_aux*(180/3.14159)+90) where node_id=rec_node.node_id;
					ELSE	
						UPDATE node set rotation=(ang_aux*(180/3.14159)-90) where node_id=rec_node.node_id;
					END IF;
		
				ELSE
					UPDATE node set rotation=(ang_aux*(180/3.14159)-90) where node_id=rec_node.node_id;		
				END IF;
			
			END LOOP;
		
			RETURN NEW;

		ELSIF TG_OP='DELETE' THEN
   	
			FOR rec_node IN SELECT node_id,nodetype_id, the_geom FROM v_edit_node WHERE OLD.node_1 = node_id OR OLD.node_2 = node_id
			LOOP
				SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM v_edit_node JOIN node_type ON rec_node.nodetype_id=id;
				SELECT hemisphere INTO hemisphere_rotation_aux FROM v_edit_node WHERE node_id=rec_node.node_id;
		
				-- init variables
				ang_aux=0;
				count=0;
			
				FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM v_edit_arc WHERE (node_1 = rec_node.node_id OR node_2 = rec_node.node_id) AND old.arc_id!=arc_id
				LOOP
					IF rec_arc.node_1=rec_node.node_id THEN
						azm_aux=st_azimuth(ST_LineInterpolatePoint(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom)); 
						IF azm_aux > 3.14159 THEN
							azm_aux = azm_aux-3.14159;
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;	
					END IF;
					IF rec_arc.node_2=rec_node.node_id  THEN
						azm_aux=st_azimuth(ST_LineInterpolatePoint(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom)); 
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
		
					IF (hemisphere_rotation_aux >180)  THEN
						UPDATE node set rotation=(ang_aux*(180/3.14159)+90) where node_id=rec_node.node_id;
					ELSE	
						UPDATE node set rotation=(ang_aux*(180/3.14159)-90) where node_id=rec_node.node_id;
					END IF;
		
				ELSE
					UPDATE node set rotation=(ang_aux*(180/3.14159)-90) where node_id=rec_node.node_id;		
				END IF;
			
			END LOOP;
	
			RETURN OLD;

		END IF;
		
	ELSE
	
		IF TG_OP='INSERT' OR TG_OP='UPDATE' THEN
			RETURN NEW;
		ELSE	
			RETURN OLD;
		END IF;
    
	END IF;
	
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  