/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2544


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_link_connecrotation_update()
  RETURNS trigger AS
$BODY$
DECLARE 
    rec_link Record; 
    rec_connec Record; 
    rec_gully Record; 
    hemisphere_rotation_bool boolean;
    hemisphere_rotation_aux float;
    ang_aux float;
    count int2;
    azm_aux float;
    rec_config record;
    label_side_aux float;
    label_side integer;
    label_rotation_aux float;
    link_exit_id_aux integer;
        
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	-- execute only if user has true the parameter edit_link_update_connecrotation
	IF (SELECT value FROM config_param_user WHERE parameter='edit_link_update_connecrotation' AND cur_user=current_user)::boolean = TRUE THEN

    
    IF TG_OP='INSERT' THEN

	IF NEW.feature_type='CONNEC' THEN
		FOR rec_connec IN SELECT * FROM v_edit_connec WHERE NEW.feature_id = connec_id and NEW.feature_type='CONNEC'
		LOOP
		
			-- init variables
			ang_aux=0;
			count=0;
		
			FOR rec_link IN SELECT link_id, feature_type, feature_id, the_geom FROM link WHERE link.feature_id = rec_connec.connec_id
			LOOP
				IF rec_link.feature_id=rec_connec.connec_id THEN
					azm_aux=st_azimuth(st_startpoint(rec_link.the_geom), ST_LineInterpolatePoint(rec_link.the_geom,0.01)); 
					IF azm_aux > 3.14159 THEN
						azm_aux = azm_aux-3.14159;
					END IF;
					ang_aux=ang_aux+azm_aux;
					count=count+1;
				END IF;
			END LOOP;

			label_side_aux= degrees(ST_Azimuth(rec_connec.the_geom,ST_EndPoint(link.the_geom)))
						from v_edit_connec 
						join link on link.feature_id=rec_connec.connec_id 
						--join vnode on vnode.vnode_id=link.exit_id::integer
						 WHERE NEW.feature_id = connec_id and NEW.feature_type='CONNEC';


			ang_aux=ang_aux/count;	

			
			label_rotation_aux=(ang_aux*(180/3.14159)-90);

			IF label_side_aux>=0 and label_side_aux<=180 THEN
				label_side=3;
			ELSE
				label_side=5;

			END IF;

			-- 'label_x' is forced to 'label_rotation_aux' because it's a column which only will be used for labels. Users who use this trigger to automatic label connecs never will use label_x for other reasons
			UPDATE connec SET label_rotation=label_rotation_aux, label_x=label_side WHERE connec_id=rec_connec.connec_id;

			-- update vnode rotation
			link_exit_id_aux=(SELECT exit_id FROM link JOIN vnode ON link.exit_id::integer=vnode.vnode_id WHERE exit_type='VNODE' AND feature_id=rec_connec.connec_id);

			UPDATE vnode SET rotation=label_rotation_aux WHERE vnode_id=link_exit_id_aux;
				
			
		END LOOP;
	
	ELSIF NEW.feature_type='GULLY' THEN
			FOR rec_gully IN SELECT * FROM v_edit_gully WHERE NEW.feature_id = gully_id and NEW.feature_type='GULLY'
		LOOP
		
			-- init variables
			ang_aux=0;
			count=0;
		
			FOR rec_link IN SELECT link_id, feature_type, feature_id, the_geom FROM link WHERE link.feature_id = rec_gully.gully_id
			LOOP
				IF rec_link.feature_id=rec_gully.gully_id THEN
					azm_aux=st_azimuth(st_startpoint(rec_link.the_geom), ST_LineInterpolatePoint(rec_link.the_geom,0.01)); 
					IF azm_aux > 3.14159 THEN
						azm_aux = azm_aux-3.14159;
					END IF;
					ang_aux=ang_aux+azm_aux;
					count=count+1;
				
				END IF;

			END LOOP;

			label_side_aux= degrees(ST_Azimuth(rec_gully.the_geom,ST_EndPoint(link.the_geom)))
						from v_edit_gully
						join link on link.feature_id=rec_gully.gully_id 
						--join vnode on vnode.vnode_id=link.exit_id::integer
						 WHERE NEW.feature_id = gully_id and NEW.feature_type='GULLY';

			ang_aux=ang_aux/count;	

			
			label_rotation_aux=(ang_aux*(180/3.14159)-90);

			If label_side_aux>=0 and label_side_aux<=180 THEN
				label_side=3;
			ELSE
				label_side=5;
			END IF;

			-- 'label_x' is forced to 'label_rotation_aux' because it's a column which only will be used for labels. Users who use this trigger to automatic label connecs never will use label_x for other reasons
			UPDATE gully set label_rotation=label_rotation_aux, label_x=label_side where gully_id=rec_gully.gully_id;

			-- update vnode rotation
			link_exit_id_aux=(SELECT exit_id FROM link JOIN vnode ON link.exit_id::integer=vnode.vnode_id WHERE exit_type='VNODE' AND feature_id=rec_gully.gully_id);

			UPDATE vnode SET rotation=label_rotation_aux WHERE vnode_id=link_exit_id_aux;		
		
			
		END LOOP;
	END IF;

	RETURN NEW;


    ELSIF TG_OP='UPDATE' THEN

    IF NEW.feature_type='CONNEC' THEN

		FOR rec_connec IN SELECT * FROM v_edit_connec WHERE NEW.feature_id = connec_id and NEW.feature_type='CONNEC'
		LOOP
		
			-- init variables
			ang_aux=0;
			count=0;
		
			FOR rec_link IN SELECT link_id, feature_type, feature_id, the_geom FROM link WHERE link.feature_id = rec_connec.connec_id
			LOOP
				IF rec_link.feature_id=rec_connec.connec_id THEN
					azm_aux=st_azimuth(st_startpoint(rec_link.the_geom), ST_LineInterpolatePoint(rec_link.the_geom,0.01)); 
					IF azm_aux > 3.14159 THEN
						azm_aux = azm_aux-3.14159;
					END IF;
					ang_aux=ang_aux+azm_aux;
					count=count+1;
				
				END IF;

			END LOOP;
		
			ang_aux=ang_aux/count;	

			label_side_aux= degrees(ST_Azimuth(rec_connec.the_geom,ST_EndPoint(link.the_geom)))
							from v_edit_connec 
							join link on link.feature_id=rec_connec.connec_id 
							--join vnode on vnode.vnode_id=link.exit_id::integer
							 WHERE NEW.feature_id = connec_id and NEW.feature_type='CONNEC';

			label_rotation_aux=(ang_aux*(180/3.14159)-90);


			IF label_side_aux>=0 and label_side_aux<=180 THEN
				label_side=3;
			ELSE
				label_side=5;

			END IF;
			
			-- 'label_x' is forced to 'label_rotation_aux' because it's a column which only will be used for labels. Users who use this trigger to automatic label connecs never will use label_x for other reasons
			UPDATE connec set label_rotation=label_rotation_aux,label_x=label_side  where connec_id=rec_connec.connec_id;

			-- update vnode rotation
			link_exit_id_aux=(SELECT exit_id FROM link JOIN vnode ON link.exit_id::integer=vnode.vnode_id WHERE exit_type='VNODE' AND feature_id=rec_connec.connec_id);

			UPDATE vnode SET rotation=label_rotation_aux WHERE vnode_id=link_exit_id_aux;		

		
		END LOOP;

	ELSIF NEW.feature_type='GULLY' THEN

		FOR rec_gully IN SELECT * FROM v_edit_gully WHERE NEW.feature_id = gully_id and NEW.feature_type='GULLY'
		LOOP
		
			-- init variables
			ang_aux=0;
			count=0;
		
			FOR rec_link IN SELECT link_id, feature_type, feature_id, the_geom FROM link WHERE link.feature_id = rec_gully.gully_id
			LOOP
				IF rec_link.feature_id=rec_gully.gully_id THEN
					azm_aux=st_azimuth(st_startpoint(rec_link.the_geom), ST_LineInterpolatePoint(rec_link.the_geom,0.01)); 
					IF azm_aux > 3.14159 THEN
						azm_aux = azm_aux-3.14159;
					END IF;
					ang_aux=ang_aux+azm_aux;
					count=count+1;
				
				END IF;

			END LOOP;
		
			ang_aux=ang_aux/count;	

			label_side_aux= degrees(ST_Azimuth(rec_gully.the_geom,ST_EndPoint(link.the_geom)))
							from v_edit_gully 
							join link on link.feature_id=rec_gully.gully_id 
							--join vnode on vnode.vnode_id=link.exit_id::integer
							 WHERE NEW.feature_id = gully_id and NEW.feature_type='GULLY';

			label_rotation_aux=(ang_aux*(180/3.14159)-90);


			If label_side_aux>=0 and label_side_aux<=180 THEN
				label_side=3;
			ELSE
				label_side=5;
			END IF;

			-- 'label_x' is forced to 'label_rotation_aux' because it's a column which only will be used for labels. Users who use this trigger to automatic label connecs never will use label_x for other reasons
			UPDATE GULLY set label_rotation=label_rotation_aux,label_x=label_side  where gully_id=rec_gully.gully_id;

			-- update vnode rotation
			link_exit_id_aux=(SELECT exit_id FROM link JOIN vnode ON link.exit_id::integer=vnode.vnode_id WHERE exit_type='VNODE' AND feature_id=rec_gully.gully_id);

			UPDATE vnode SET rotation=label_rotation_aux WHERE vnode_id=link_exit_id_aux;				

		
		END LOOP;
	END IF;

	RETURN NEW;

    END IF;
	
  END IF;
  
  RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
