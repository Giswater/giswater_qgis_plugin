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
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_table_name:= TG_ARGV[0];

	IF v_table_name = 'connec' THEN
		SELECT the_geom INTO v_feature_geom FROM connec WHERE connec_id=NEW.connec_id;
	ELSIF v_table_name = 'gully' THEN
		SELECT the_geom INTO v_feature_geom FROM gully WHERE gully_id=NEW.gully_id;
	END IF;
	
	-- create link if not exists for connect, because it's mandatory to have links created for connect when it has an arc_id defined on some alternative
	IF NEW.arc_id IS NOT NULL AND v_table_name = 'connec' THEN
			IF (SELECT link FROM link WHERE feature_type='CONNEC' and feature_id=NEW.connec_id) IS NULL THEN
				PERFORM gw_fct_connect_to_network((select array_agg(NEW.connec_id)), 'CONNEC');	
			END IF;
	
	ELSIF NEW.arc_id IS NOT NULL AND v_table_name = 'gully' THEN
			IF (SELECT link FROM link WHERE feature_type='GULLY' and feature_id=NEW.gully_id) IS NULL THEN
				PERFORM gw_fct_connect_to_network((select array_agg(NEW.gully_id)), 'GULLY');
			END IF;
	END IF;

	-- update geometry on plan psector table
	v_link_geom := ST_ShortestLine(v_feature_geom, (SELECT the_geom FROM arc WHERE arc_id=NEW.arc_id));
	v_vnode_geom = ST_EndPoint(v_link_geom);
	
	IF v_table_name = 'connec' THEN
		UPDATE plan_psector_x_connec SET link_geom=v_link_geom, vnode_geom=v_vnode_geom WHERE id=NEW.id;
	ELSIF v_table_name = 'gully' THEN
		UPDATE plan_psector_x_gully SET link_geom=v_link_geom, vnode_geom=v_vnode_geom WHERE id=NEW.id;
	END IF;


RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
