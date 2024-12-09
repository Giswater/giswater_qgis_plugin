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
rec_config record;

hemisphere_rotation_bool boolean;
hemisphere_rotation_aux float;
ang_aux float;
count int2;
azm_aux float;
--azm_aux float;
connec_id_aux text;
array_agg text[];
v_dist_xlab numeric;
v_dist_ylab numeric;
v_radians_value numeric;
v_srid numeric;
v_sql text;
v_xsign text;
v_ysign text;
v_label_point public.geometry;
v_rot1 numeric;
v_rot2 numeric;
v_geom public.geometry;
v_cur_label_rot numeric;
v_label_dist numeric;
v_cur_rotation numeric;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
   
   	v_srid = (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	
	IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_noderotation_update_dsbl' AND cur_user=current_user) IS NOT TRUE THEN 
    
		IF TG_OP='INSERT' THEN

			FOR rec_node IN SELECT * FROM v_edit_node WHERE NEW.node_1 = node_id OR NEW.node_2 = node_id
			LOOP
				SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM v_edit_node JOIN cat_feature_node ON rec_node.node_type=id;
				SELECT hemisphere INTO hemisphere_rotation_aux FROM v_edit_node WHERE node_id=rec_node.node_id;

				-- init variables
				ang_aux=0;
				count=0;

				FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM arc WHERE arc.node_1 = rec_node.node_id or arc.node_2 = rec_node.node_id
				LOOP
					IF rec_arc.node_1=rec_node.node_id THEN
						azm_aux=st_azimuth(st_startpoint(rec_arc.the_geom), ST_LineInterpolatePoint(rec_arc.the_geom,0.01));
						IF azm_aux > pi() THEN
							azm_aux = azm_aux-pi();
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;
					END IF;
					IF rec_arc.node_2=rec_node.node_id  THEN
						azm_aux=st_azimuth(ST_LineInterpolatePoint(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom));
						IF azm_aux > pi() THEN
							azm_aux = azm_aux-pi();
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;
					END IF;
				END LOOP	;

				ang_aux=ang_aux/count;

				IF hemisphere_rotation_bool IS true THEN

					IF (hemisphere_rotation_aux >180)  THEN
						UPDATE node set rotation=(ang_aux*(180/pi())+90) where node_id=rec_node.node_id;
						UPDATE node set label_rotation=(ang_aux*(180/pi())+90) where node_id=rec_node.node_id;
					ELSE
						UPDATE node set rotation=(ang_aux*(180/pi())-90) where node_id=rec_node.node_id;
						UPDATE node set label_rotation=(ang_aux*(180/pi())-90) where node_id=rec_node.node_id;
					END IF;
				ELSE
					UPDATE node set rotation=(ang_aux*(180/pi())-90) where node_id=rec_node.node_id;
					UPDATE node set label_rotation=(ang_aux*(180/pi())-90) where node_id=rec_node.node_id;
				END IF;

				-- force positive values for rotation
				IF (SELECT rotation FROM node where node_id = rec_node.node_id) < 0 then
					UPDATE node set rotation = rotation + 360 where node_id =  rec_node.node_id;
				ELSIF (SELECT rotation FROM node where node_id = rec_node.node_id) > 360 then
					UPDATE node set rotation = rotation -360 where node_id =  rec_node.node_id;
				END IF;

			END LOOP;

			RETURN NEW;

		ELSIF TG_OP='UPDATE' THEN

			FOR rec_node IN SELECT * FROM v_edit_node WHERE node_id = NEW.node_1 OR node_id = NEW.node_2--NEW.node_1 = node_id OR NEW.node_2 = node_id
			LOOP
				SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM v_edit_node JOIN cat_feature_node ON rec_node.node_type=id;
				SELECT hemisphere INTO hemisphere_rotation_aux FROM v_edit_node WHERE node_id=rec_node.node_id;

				-- init variables
				ang_aux=0;
				count=0;

				FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM arc WHERE arc.node_1 = rec_node.node_id or arc.node_2 = rec_node.node_id
				LOOP
					IF rec_arc.node_1=rec_node.node_id THEN
						azm_aux=st_azimuth(st_startpoint(rec_arc.the_geom), ST_LineInterpolatePoint(rec_arc.the_geom,0.01));
						IF azm_aux > pi() THEN
							azm_aux = azm_aux-pi();
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;
					END IF;

					IF rec_arc.node_2=rec_node.node_id  THEN
						azm_aux=st_azimuth(ST_LineInterpolatePoint(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom));
						IF azm_aux > pi() THEN
							azm_aux = azm_aux-pi();
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;
					END IF;
				END LOOP;

				ang_aux=ang_aux/count;

				IF hemisphere_rotation_bool IS true THEN

					IF (hemisphere_rotation_aux >180)  THEN
						UPDATE node set rotation=(ang_aux*(180/pi())+90) where node_id=rec_node.node_id;
					ELSE
						UPDATE node set rotation=(ang_aux*(180/pi())-90) where node_id=rec_node.node_id;
					END IF;

				ELSE
					UPDATE node set rotation=(ang_aux*(180/pi())-90) where node_id=rec_node.node_id;
				END IF;

			-- force positive values for rotation
				IF (SELECT rotation FROM node where node_id = rec_node.node_id) < 0 then
					UPDATE node set rotation = rotation + 360 where node_id =  rec_node.node_id;
				ELSIF (SELECT rotation FROM node where node_id = rec_node.node_id) > 360 then
					UPDATE node set rotation = rotation -360 where node_id =  rec_node.node_id;
				END IF;

			
			-- set label_quadrant, label_x and label_y according to cat_Feature
			
				EXECUTE '
				SELECT addparam->''labelPosition''->''dist''->>0  from cat_feature WHERE id = '||quote_literal(rec_node.node_type)||'					
				' INTO v_dist_xlab;
			
				EXECUTE '
				SELECT addparam->''labelPosition''->''dist''->>1  from cat_feature WHERE id = '||quote_literal(rec_node.node_type)||'					
				' INTO v_dist_ylab;
				
				if v_dist_ylab is not null and v_dist_xlab is not null and 
				(SELECT value::boolean FROM config_param_user WHERE parameter='edit_noderotation_update_dsbl' AND cur_user=current_user) IS FALSE 
				then --continue only with when having not-null values
				
					-- prev calc: current label position
					select st_setsrid(st_makepoint(label_x::numeric, label_y::numeric), 25831) 
					into v_label_point from node where node_id = rec_node.node_id;
				
					-- prev calc: geom of the rec_node
					execute 'select the_geom from node where node_id = '||quote_literal(rec_node.node_id)||''  
					into v_geom;
					
					--prev calc: angle between rec_node.node and its label
					v_sql = '
					with mec as (
						SELECT 
						n.the_geom as vertex_point,
						n.rotation as rotation_node,
						$1 as point1,
						ST_LineInterpolatePoint(a.the_geom, ST_LineLocatePoint(a.the_geom, n.the_geom)) as point2
						from node n, arc a  where n.node_id = $2 and st_dwithin (a.the_geom, n.the_geom, 0.001) limit 1
					)
					select degrees(ST_Azimuth(vertex_point, point1))
					from mec';
				
					execute v_sql into v_cur_rotation using v_label_point, rec_node.node_id;
				   		
					-- start process: calc intermediate rotations to project the label
				   if (v_dist_xlab > 0 and v_dist_ylab > 0) -- top right
					or (v_dist_xlab < 0 and v_dist_ylab < 0) -- bottom left
					then 
						v_rot1 = 90+rec_node.rotation; 
						v_rot2 = 0+rec_node.rotation; 
					
					elsif (v_dist_xlab > 0 and v_dist_ylab < 0) -- bottom right
					or 	  (v_dist_xlab < 0 and v_dist_ylab > 0) -- top left
					then 
						v_rot1 = 0+rec_node.rotation;
						v_rot2 = 90+rec_node.rotation; 
					
					end if;
				
					
				   	-- new label position
					v_sql = '
					with mec as (
					select the_geom, ST_Project(ST_Transform(the_geom, 4326)::geography, '||v_dist_ylab||', radians('||v_rot1||')) as eee
					FROM node WHERE node_id = '||QUOTE_LITERAL(rec_node.node_id)||'), lab_point as (
					SELECT ST_Project(ST_Transform(eee::geometry, 4326)::geography, '||v_dist_xlab||', radians('||v_rot2||')) as fff
					from mec)
					select st_transform(fff::geometry, 25831) as label_p from lab_point';
								
					execute v_sql into v_label_point;
										
				
					update node set label_rotation = rec_node.rotation where node_id = rec_node.node_id;
				
					update node set label_x = st_x(v_label_point) where node_id = rec_node.node_id;
					update node set label_y = st_y(v_label_point) where node_id = rec_node.node_id;
					
						
				end if;
				
			END LOOP;

			RETURN NEW;

		ELSIF TG_OP='DELETE' THEN

			FOR rec_node IN SELECT node_id, node_type, the_geom FROM v_edit_node WHERE OLD.node_1 = node_id OR OLD.node_2 = node_id
			LOOP
				SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM v_edit_node JOIN cat_feature_node ON rec_node.node_type=id;
				SELECT hemisphere INTO hemisphere_rotation_aux FROM v_edit_node WHERE node_id=rec_node.node_id;

				-- init variables
				ang_aux=0;
				count=0;

				FOR rec_arc IN SELECT arc_id, node_1, node_2, the_geom FROM v_edit_arc WHERE (node_1 = rec_node.node_id OR node_2 = rec_node.node_id) AND old.arc_id!=arc_id
				LOOP
					IF rec_arc.node_1=rec_node.node_id THEN
						azm_aux=st_azimuth(ST_LineInterpolatePoint(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom));
						IF azm_aux > pi() THEN
							azm_aux = azm_aux-pi();
						END IF;
						ang_aux=ang_aux+azm_aux;
						count=count+1;
					END IF;
					IF rec_arc.node_2=rec_node.node_id  THEN
						azm_aux=st_azimuth(ST_LineInterpolatePoint(rec_arc.the_geom,0.99),st_endpoint(rec_arc.the_geom));
						IF azm_aux > pi() THEN
							azm_aux = azm_aux-pi();
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
						UPDATE node set rotation=(ang_aux*(180/pi())+90) where node_id=rec_node.node_id;
					ELSE
						UPDATE node set rotation=(ang_aux*(180/pi())-90) where node_id=rec_node.node_id;
					END IF;

				ELSE
					UPDATE node set rotation=(ang_aux*(180/pi())-90) where node_id=rec_node.node_id;
				END IF;

				-- force positive values for rotation
				IF (SELECT rotation FROM node where node_id = rec_node.node_id) < 0 then
					UPDATE node set rotation = rotation + 360 where node_id =  rec_node.node_id;
				ELSIF (SELECT rotation FROM node where node_id = rec_node.node_id) > 360 then
					UPDATE node set rotation = rotation -360 where node_id =  rec_node.node_id;
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
