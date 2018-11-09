/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2438

--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_psector_update_geom(integer,geometry,double precision);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_psector_update_geom(psector_id_aux integer, point_aux geometry, dim_aux double precision) RETURNS VOID AS
$BODY$

DECLARE 
polygon_aux geometry;
x1 double precision;
y1 double precision;
x2 double precision;
y2 double precision;
epsg_val integer;


BEGIN 

    SET search_path = "SCHEMA_NAME", public;

	SELECT epsg INTO epsg_val FROM version LIMIT 1;
    
    -- point coordinates calculation
    x1 = ST_x(point_aux)-0.5*dim_aux::float;
    y1 = ST_y(point_aux)+0.25*dim_aux::float;
    x2 = ST_x(point_aux)+0.5*dim_aux::float;
    y2 = ST_y(point_aux)-0.25*dim_aux::float;
    
	polygon_aux=st_collect(ST_MakeEnvelope(x1,y1,x2,y2, epsg_val));

	UPDATE plan_psector SET the_geom=polygon_aux WHERE psector_id=psector_id_aux;
	
RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

