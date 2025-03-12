/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_om_category_geom(p_category_id integer)
 RETURNS integer AS
 $function$

--FUNCTION CODE: 3153

DECLARE 
    
epsg_val integer;
collect_aux public.geometry;
v_projecttype text;
v_feature_type text;


BEGIN 

    --EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    SET search_path = "SCHEMA_NAME", public;


	SELECT epsg, project_type INTO epsg_val, v_projecttype FROM sys_version LIMIT 1;

	SELECT lower(feature_type) INTO v_feature_type FROM om_category WHERE category_id=p_category_id;
	
		-- Looking for new feature and calculating the aggregated geom
		IF v_projecttype = 'WS' THEN 
		
			IF v_feature_type='arc' THEN
						
				SELECT st_multi(the_geom) INTO collect_aux FROM 
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from arc join om_category_x_arc ON om_category_x_arc.arc_id=arc.arc_id where category_id=p_category_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
				
			ELSIF v_feature_type='node' THEN
						
				SELECT st_multi(the_geom) INTO collect_aux FROM 
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from node join om_category_x_node ON om_category_x_node.node_id=node.node_id where category_id=p_category_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
				
			ELSIF v_feature_type='connec' THEN
						
				SELECT st_multi(the_geom) INTO collect_aux FROM 
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from connec join om_category_x_connec ON om_category_x_connec.connec_id=connec.connec_id where category_id=p_category_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
			END IF;
					
		ELSIF v_projecttype = 'UD' THEN 
			
			IF v_feature_type='arc' THEN
						
				SELECT st_multi(the_geom) INTO collect_aux FROM 
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from arc join om_category_x_arc ON om_category_x_arc.arc_id=arc.arc_id where category_id=p_category_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
				
			ELSIF v_feature_type='node' THEN
						
				SELECT st_multi(the_geom) INTO collect_aux FROM 
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from node join om_category_x_node ON om_category_x_node.node_id=node.node_id where category_id=p_category_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
				
			ELSIF v_feature_type='connec' THEN
						
				SELECT st_multi(the_geom) INTO collect_aux FROM 
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from connec join om_category_x_connec ON om_category_x_connec.connec_id=connec.connec_id where category_id=p_category_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
				
			ELSIF v_feature_type='gully' THEN
						
				SELECT st_multi(the_geom) INTO collect_aux FROM 
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from gully join om_category_x_gully ON om_category_x_gully.gully_id=gully.gully_id where category_id=p_category_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
			END IF;
				
		END IF;

		-- Update geometry field
		UPDATE om_category SET the_geom=collect_aux WHERE category_id=p_category_id;


	RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



