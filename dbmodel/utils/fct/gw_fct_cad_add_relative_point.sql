/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2242

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_cad_add_relative_point(geometry,float, float, integer, boolean);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_cad_add_relative_point(geom1_aux geometry,geom2_aux geometry,x_var double precision,
y_var double precision,start_point integer,del_previous_bool boolean)
RETURNS geometry AS
$BODY$

DECLARE

v_geom geometry;
v_percent float;
v_point geometry;
v_point1 geometry;
v_point2 geometry;
v_point_result geometry;
v_angle float;
v_xcoord float;
v_ycoord float;
rec record;
v_angle0 float;
v_x0coord float;
v_y0coord float;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Initialize variables	
    SELECT * into rec FROM sys_version;

    v_geom= st_makeline(geom1_aux, geom2_aux);
	
	--Check init node to place the support point
	IF start_point=2 THEN
		x_var=x_var+st_length(v_geom);
	END IF;
	
	--Check the position of the support point
    IF x_var <= 0 THEN
    	-- azimut calculation
		SELECT ST_LineInterpolatePoint(v_geom, 0.000) into v_point1;
		SELECT ST_LineInterpolatePoint(v_geom, 0.001) into v_point2;
		v_angle0:=(st_azimuth(v_point1,v_point2));
		v_angle:=(st_azimuth(v_point1,v_point2)-3.14159/2);

		-- point coordinates calculation
		v_x0coord = ST_x(v_point1)+(sin(v_angle0))*x_var::float;
		v_y0coord = ST_y(v_point1)+(cos(v_angle0))*x_var::float;
		v_xcoord = v_x0coord+(sin(v_angle))*y_var::float;
		v_ycoord = v_y0coord+(cos(v_angle))*y_var::float;

    ELSIF (x_var >0 AND x_var < st_length(v_geom)) THEN
	
		-- percent calculation
		v_percent= x_var/st_length(v_geom);

		-- azimut calculation
		SELECT ST_LineInterpolatePoint(v_geom, (v_percent-0.001)) into v_point1;
		SELECT ST_LineInterpolatePoint(v_geom, (v_percent+0.001)) into v_point2;	
		v_angle:=(st_azimuth(v_point1,v_point2)-3.14159/2);

		-- point coordinates calculation
		SELECT ST_LineInterpolatePoint(v_geom, v_percent) into v_point;
		v_xcoord = ST_x(v_point)+(sin(v_angle))*y_var::float;
		v_ycoord = ST_y(v_point)+(cos(v_angle))*y_var::float;

    ELSIF x_var >= st_length(v_geom) THEN
        
        -- azimut calculation
		SELECT ST_LineInterpolatePoint(v_geom, 0) into v_point1;
		SELECT ST_LineInterpolatePoint(v_geom, 1) into v_point2;
		v_angle0:=(st_azimuth(v_point1,v_point2));
		v_angle:=(st_azimuth(v_point1,v_point2)-3.14159/2);

		-- point coordinates calculation
		v_x0coord = ST_x(v_point1)+(sin(v_angle0))*x_var::float;
		v_y0coord = ST_y(v_point1)+(cos(v_angle0))*x_var::float;
		v_xcoord = v_x0coord+(sin(v_angle))*y_var::float;
		v_ycoord = v_y0coord+(cos(v_angle))*y_var::float;

    END IF;

    v_point_result = ST_SetSRID(ST_MakePoint(v_xcoord, v_ycoord),rec.epsg);

    -- delete previous registers if user selection is enabled
    IF del_previous_bool IS TRUE THEN 
	DELETE FROM temp_table WHERE fid=127 and cur_user=current_user;
    END IF;
    
    -- Insert into temporal table the values
    INSERT INTO temp_table (fid, geom_point)  VALUES (127, v_point_result);

	RETURN v_point_result;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE