/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3468

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_lot_psector_geom(p_lot_id integer)
  RETURNS integer AS
$BODY$

--FUNCTION CODE: 2997

DECLARE 
    
polygon_aux public.geometry;
epsg_val integer;
collect_aux public.geometry;
x1 double precision;
y1 double precision;
x2 double precision;
y2 double precision;
xm double precision;
ym double precision;
xd double precision;
yd double precision;
wfactor_vdefault double precision;
wfactor_real  double precision;
v_projecttype text;


BEGIN 

    --EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    SET search_path = "SCHEMA_NAME", public;


	SELECT epsg, project_type INTO epsg_val, v_projecttype FROM PARENT_SCHEMA.sys_version LIMIT 1;
	
		-- Looking for new feature and calculating the aggregated geom
		IF v_projecttype = 'WS' THEN 
						
				SELECT st_multi(the_geom) INTO collect_aux FROM 
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from PARENT_SCHEMA.arc join om_visit_lot_x_arc ON om_visit_lot_x_arc.arc_id=arc.arc_id where lot_id=p_lot_id
					UNION
					select the_geom from PARENT_SCHEMA.node join om_visit_lot_x_node ON om_visit_lot_x_node.node_id=node.node_id where lot_id=p_lot_id
					UNION
					select the_geom from PARENT_SCHEMA.connec join om_visit_lot_x_connec ON om_visit_lot_x_connec.connec_id=connec.connec_id where lot_id=p_lot_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
					
		ELSIF v_projecttype = 'UD' THEN 
			
				SELECT st_multi(a.the_geom) INTO collect_aux FROM
				(WITH polygon AS (SELECT st_collect(f.the_geom) g
					FROM ( select the_geom from PARENT_SCHEMA.arc join om_visit_lot_x_arc ON om_visit_lot_x_arc.arc_id=arc.arc_id where lot_id=p_lot_id
					UNION
					select the_geom from PARENT_SCHEMA.node join om_visit_lot_x_node ON om_visit_lot_x_node.node_id=node.node_id where lot_id=p_lot_id
					UNION
					select the_geom from PARENT_SCHEMA.connec join om_visit_lot_x_connec ON om_visit_lot_x_connec.connec_id=connec.connec_id where lot_id=p_lot_id
					UNION
					select the_geom from PARENT_SCHEMA.gully join om_visit_lot_x_gully ON om_visit_lot_x_gully.gully_id=gully.gully_id where lot_id=p_lot_id) f)
					SELECT CASE 
					WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,25831)
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,25831) END AS the_geom FROM polygon) a;
		END IF;

		-- Update geometry field
		UPDATE om_visit_lot SET the_geom=collect_aux WHERE id=p_lot_id;


	RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
