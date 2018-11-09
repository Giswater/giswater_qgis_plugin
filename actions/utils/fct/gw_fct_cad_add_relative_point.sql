/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2242


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_cad_add_relative_point(geometry,float, float, integer, boolean);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_cad_add_relative_point(
    geom1_aux geometry,
    geom2_aux geometry,
    x_var double precision,
    y_var double precision,
    start_point integer,
    del_previous_bool boolean)
  RETURNS geometry AS

  $BODY$

DECLARE
geom_aux geometry;
percent_aux float;
point_aux geometry;
point1_aux geometry;
point2_aux geometry;
point_result geometry;
angle_aux float;
xcoord float;
ycoord float;
rec record;
coords_arr float[];
angle0_aux float;
x0coord float;
y0coord float;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Initialize variables	
    SELECT * into rec FROM version;

    geom_aux= st_makeline(geom1_aux, geom2_aux);
	
	--Check init node to place the support point
	IF start_point=2 THEN
		x_var=x_var+st_length(geom_aux);
	END IF;
	
	--Check the position of the support point
    IF x_var <= 0 THEN
    	-- azimut calculation
		SELECT ST_LineInterpolatePoint(geom_aux, 0.000) into point1_aux;
		SELECT ST_LineInterpolatePoint(geom_aux, 0.001) into point2_aux;
		angle0_aux:=(st_azimuth(point1_aux,point2_aux));
		angle_aux:=(st_azimuth(point1_aux,point2_aux)-3.14159/2);

		-- point coordinates calculation
		x0coord = ST_x(point1_aux)+(sin(angle0_aux))*x_var::float;
		y0coord = ST_y(point1_aux)+(cos(angle0_aux))*x_var::float;
		xcoord = x0coord+(sin(angle_aux))*y_var::float;
		ycoord = y0coord+(cos(angle_aux))*y_var::float;

    ELSIF (x_var >0 AND x_var < st_length(geom_aux)) THEN
	
		-- percent calculation
		percent_aux= x_var/st_length(geom_aux);

		-- azimut calculation
		SELECT ST_LineInterpolatePoint(geom_aux, (percent_aux-0.001)) into point1_aux;
		SELECT ST_LineInterpolatePoint(geom_aux, (percent_aux+0.001)) into point2_aux;	
		angle_aux:=(st_azimuth(point1_aux,point2_aux)-3.14159/2);

		-- point coordinates calculation
		SELECT ST_LineInterpolatePoint(geom_aux, percent_aux) into point_aux;
		xcoord = ST_x(point_aux)+(sin(angle_aux))*y_var::float;
		ycoord = ST_y(point_aux)+(cos(angle_aux))*y_var::float;

    ELSIF x_var >= st_length(geom_aux) THEN
        
        -- azimut calculation
		SELECT ST_LineInterpolatePoint(geom_aux, 0) into point1_aux;
		SELECT ST_LineInterpolatePoint(geom_aux, 1) into point2_aux;
		angle0_aux:=(st_azimuth(point1_aux,point2_aux));
		angle_aux:=(st_azimuth(point1_aux,point2_aux)-3.14159/2);

		-- point coordinates calculation
		x0coord = ST_x(point1_aux)+(sin(angle0_aux))*x_var::float;
		y0coord = ST_y(point1_aux)+(cos(angle0_aux))*x_var::float;
		xcoord = x0coord+(sin(angle_aux))*y_var::float;
		ycoord = y0coord+(cos(angle_aux))*y_var::float;

    
    END IF;

    point_result = ST_SetSRID(ST_MakePoint(xcoord, ycoord),rec.epsg);

    -- delete previous registers if user selection is enabled
    IF del_previous_bool IS TRUE THEN 
	DELETE FROM temp_table WHERE fprocesscat_id=27 and user_name=current_user;
    END IF;
    
    -- Insert into temporal table the values
    INSERT INTO temp_table (fprocesscat_id, geom_point)  VALUES (27, point_result);


RETURN point_result;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE