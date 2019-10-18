/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector_link()
  RETURNS trigger AS
$BODY$
DECLARE 
    
	v_link_geom public.geometry;
	v_vnode_geom public.geometry;
	v_table_name text;
	v_feature_geom public.geometry;
	v_point_aux public.geometry;
	v_arc_geom public.geometry;
	v_userdefined_geom boolean;
	
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_table_name:= TG_ARGV[0];

	IF v_table_name = 'connec' THEN
		SELECT the_geom INTO v_feature_geom FROM connec WHERE connec_id=NEW.connec_id;
	ELSIF v_table_name = 'gully' THEN
		SELECT the_geom INTO v_feature_geom FROM gully WHERE gully_id=NEW.gully_id;
	END IF;
	
	-- update values on plan psector table
	IF NEW.userdefined_geom IS NOT TRUE THEN -- in case of true this value must be updated on the trg_edit_vnode
		v_link_geom := ST_ShortestLine(v_feature_geom, (SELECT the_geom FROM arc WHERE arc_id=NEW.arc_id));
		v_vnode_geom = ST_EndPoint(v_link_geom);
		
		IF NEW.arc_id IS NULL THEN 
			v_userdefined_geom=NULL;
		ELSE
			v_userdefined_geom=FALSE;
		END IF;
	ELSE	
		v_arc_geom = (SELECT the_geom FROM arc WHERE arc_id=NEW.arc_id);
		v_point_aux := St_closestpoint(v_arc_geom, St_endpoint(v_link_geom));
		v_link_geom  := ST_SetPoint(v_link_geom, ST_NumPoints(v_link_geom) - 1, v_point_aux);
		v_vnode_geom = ST_EndPoint(v_link_geom);
		v_userdefined_geom = TRUE;
	END IF;


	-- update plan_psector tables
	IF v_table_name = 'connec' THEN
		UPDATE plan_psector_x_connec SET link_geom=v_link_geom, vnode_geom=v_vnode_geom, userdefined_geom=v_userdefined_geom WHERE id=NEW.id;
	ELSIF v_table_name = 'gully' THEN
		UPDATE plan_psector_x_gully SET link_geom=v_link_geom, vnode_geom=v_vnode_geom, userdefined_geom=v_userdefined_geom WHERE id=NEW.id;
	END IF;		

	RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

select * from plan_psector_x_connec WHERE id=12