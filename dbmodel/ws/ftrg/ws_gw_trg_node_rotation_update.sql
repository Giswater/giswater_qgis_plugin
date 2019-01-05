/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1346

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_node_rotation_update()
  RETURNS trigger AS
$BODY$
DECLARE 
    rec_arc Record; 
    hemisphere_rotation_bool boolean;
    hemisphere_rotation_aux float;
    v_rotation float;
    arc_id_aux  varchar;
    arc_geom    public.geometry;
    state_aux 	integer;
    intersect_loc	 double precision;
    
        
BEGIN 

-- The goal of this function are two goals:
--1) to update automatic rotation node values using the hemisphere values when the variable edit_noderotation_update_dissbl is TRUE
--2) when node is disconnected from arcs update rotation taking values from nearest arc if exists

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- get parameters;

	SELECT choose_hemisphere INTO hemisphere_rotation_bool FROM node_type JOIN cat_node ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id;
	SELECT hemisphere INTO hemisphere_rotation_aux FROM node WHERE node_id=NEW.node_id;
	
	IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_noderotation_update_dissbl' AND cur_user=current_user) IS TRUE THEN 

    		UPDATE node SET rotation=NEW.hemisphere WHERE node_id=NEW.node_id;
					
	END IF;

	IF (SELECT num_arcs FROM node_type JOIN cat_node ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id LIMIT 1)=0 THEN

		-- Find closest arc inside tolerance
		SELECT arc_id, state, the_geom INTO arc_id_aux, state_aux, arc_geom  FROM v_edit_arc AS a 
		WHERE ST_DWithin(NEW.the_geom, a.the_geom, 0.01) ORDER BY ST_Distance(NEW.the_geom, a.the_geom) LIMIT 1;

		IF arc_id_aux IS NOT NULL THEN 

			--  Locate position of the nearest point
			intersect_loc := ST_LineLocatePoint(arc_geom, NEW.the_geom);

			IF intersect_loc < 1 THEN
				IF intersect_loc > 0.5 THEN
					v_rotation=st_azimuth(ST_LineInterpolatePoint(arc_geom,intersect_loc), ST_LineInterpolatePoint(arc_geom,intersect_loc-0.01)); 
				ELSE
					v_rotation=st_azimuth(ST_LineInterpolatePoint(arc_geom,intersect_loc), ST_LineInterpolatePoint(arc_geom,intersect_loc+0.01)); 
				END IF;
					IF v_rotation> 3.14159 THEN
						v_rotation = v_rotation-3.14159;
					END IF;
			END IF;
					
			IF hemisphere_rotation_bool IS true THEN
		
				IF (hemisphere_rotation_aux >180)  THEN
					UPDATE node set rotation=(v_rotation*(180/3.14159)+90) where node_id=NEW.node_id;
				ELSE		
					UPDATE node set rotation=(v_rotation*(180/3.14159)-90) where node_id=NEW.node_id;
				END IF;
			ELSE
				UPDATE node set rotation=(v_rotation*(180/3.14159)-90) where node_id=NEW.node_id;		
			END IF;				
		END IF;
	END IF;

	RETURN NEW;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 