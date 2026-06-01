/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2544


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_link_connecrotation_update()
  RETURNS trigger AS
$BODY$
DECLARE 
    rec_link Record; 
    rec_connec Record; 
    rec_gully Record; 
    azm_aux float;
    label_side_aux float;
    label_side varchar;
    label_rotation_aux float;
        
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	-- execute only if user has true the parameter edit_link_update_connecrotation
	IF (SELECT value FROM config_param_system WHERE parameter='edit_link_update_connecrotation')::boolean = TRUE THEN

		IF NEW.feature_type='CONNEC' THEN
			
			SELECT connec_id, the_geom INTO rec_connec FROM ve_connec WHERE NEW.feature_id = connec_id and NEW.feature_type='CONNEC';
			SELECT feature_id, the_geom INTO rec_link FROM link WHERE link.feature_id = rec_connec.connec_id;

			IF rec_link.feature_id=rec_connec.connec_id THEN
				azm_aux=st_azimuth(st_startpoint(rec_link.the_geom), ST_LineInterpolatePoint(rec_link.the_geom,0.01)); 
				IF azm_aux > 3.14159 THEN
					azm_aux = azm_aux-3.14159;
				END IF;
			END IF;

			label_side_aux= degrees(ST_Azimuth(rec_connec.the_geom,ST_EndPoint(link.the_geom)))
						from ve_connec 
						join link on link.feature_id=rec_connec.connec_id
						WHERE NEW.feature_id = connec_id and NEW.feature_type='CONNEC' LIMIT 1;
			label_rotation_aux=(azm_aux*(180/3.14159)-90);

			IF label_side_aux>=0 and label_side_aux<=180 THEN
				-- Left
				label_side='L';
			ELSE
				-- Right
				label_side='R';
			END IF;

			-- Rotation value are set to 'label_rotation' and 'rotation'. The side of the label is set to 'label_x'
			-- Using this trigger to automatically set the label rotation implies to not use 'label_x' for other reasons
			UPDATE connec SET label_rotation=label_rotation_aux, rotation=label_rotation_aux, label_x=label_side WHERE connec_id=rec_connec.connec_id;
				
		ELSIF NEW.feature_type='GULLY' THEN
		
			SELECT gully_id, the_geom INTO rec_gully FROM ve_gully WHERE NEW.feature_id = gully_id and NEW.feature_type='GULLY';
			SELECT feature_id, the_geom INTO rec_link FROM link WHERE link.feature_id = rec_gully.gully_id;
			
			IF rec_link.feature_id=rec_gully.gully_id THEN
				azm_aux=st_azimuth(st_startpoint(rec_link.the_geom), ST_LineInterpolatePoint(rec_link.the_geom,0.01)); 
				IF azm_aux > 3.14159 THEN
					azm_aux = azm_aux-3.14159;
				END IF;
			END IF;

			label_side_aux= degrees(ST_Azimuth(rec_gully.the_geom,ST_EndPoint(link.the_geom)))
						from ve_gully
						join link on link.feature_id=rec_gully.gully_id 
						WHERE NEW.feature_id = gully_id and NEW.feature_type='GULLY' LIMIT 1;
			label_rotation_aux=(azm_aux*(180/3.14159)-90);

			IF label_side_aux>=0 and label_side_aux<=180 THEN
				-- Left
				label_side='L';
			ELSE
				-- Right
				label_side='R';
			END IF;

			-- Rotation value are set to 'label_rotation' and 'rotation'. The side of the label is set to 'label_x'
			-- Using this trigger to automatically set the label rotation implies to not use 'label_x' for other reasons
			UPDATE gully set label_rotation=label_rotation_aux, rotation=label_rotation_aux, label_x=label_side where gully_id=rec_gully.gully_id;	
			
		END IF;

		RETURN NEW;

	END IF;
  
	RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
