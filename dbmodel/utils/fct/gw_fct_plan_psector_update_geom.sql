/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2438

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_psector_update_geom(psector_id_aux integer, point_aux geometry, dim_aux double precision) 
RETURNS VOID AS
$BODY$

DECLARE 

v_pol geometry;
x1 double precision;
y1 double precision;
x2 double precision;
y2 double precision;
v_epsg integer;

BEGIN 

    SET search_path = "SCHEMA_NAME", public;

	SELECT epsg INTO v_epsg FROM sys_version LIMIT 1;
    
    -- point coordinates calculation
    x1 = ST_x(point_aux)-0.5*dim_aux::float;
    y1 = ST_y(point_aux)+0.25*dim_aux::float;
    x2 = ST_x(point_aux)+0.5*dim_aux::float;
    y2 = ST_y(point_aux)-0.25*dim_aux::float;
    
	v_pol=st_collect(ST_MakeEnvelope(x1,y1,x2,y2, v_epsg));

	UPDATE plan_psector SET the_geom=v_pol WHERE psector_id=psector_id_aux;
	
	RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

