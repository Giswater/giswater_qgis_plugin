/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

/*
SELECT ws.gw_fct_cad_add_relative_point('0102000020E76400001900000066666666A49C1841CDCCCC2C93A051419A999999B09C184152B81E2592A0514190C2F528B89C18418FC2F57891A0514133333333D29C1841AE47E10A8FA05141295C8FC2E69C18417B14AEF78CA051411F85EB51F79C18411F85EB318BA051419A999999049D18410AD7A3B089A051415C8FC2F51A9D1841A4703DFA86A051415C8FC2F5249D1841D7A370AD85A0514167666666309D1841CDCCCC1C84A0514100000000389D18413333330383A0514185EB51B83D9D1841E17A141E82A051410AD7A3704D9D184152B81E857FA05141C3F5285C669D1841EC51B8EE7AA051419A9999996F9D184185EB512879A0514190C2F528749D1841EC51B81E78A0514190C2F528789D18411F85EBC176A051415C8FC2F5799D18413E0AD76375A05141B81E85EB799D1841EC51B85E74A0514133333333799D18415C8FC2A573A05141EC51B81E789D18410AD7A32073A0514115AE47E1759D18410AD7A37072A05141A4703D0A729D1841676666C671A05141B81E85EB6D9D1841AE47E13A71A05141A4703D0A6D9D18415C8FC22571A05141',19,4, false);
*/


--FUNCTION CODE: 2242


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_cad_add_relative_point(geometry,float, float, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_cad_add_relative_point(    geom_aux geometry,    x_var double precision,    y_var double precision,    inverted_bool boolean)
RETURNS double precision[] AS
$BODY$

DECLARE
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

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Initialize variables	
    SELECT * into rec FROM version;
    percent_aux= x_var/st_length(geom_aux);

    -- control options
    IF percent_aux>1 THEN
	RAISE EXCEPTION 'The x value is too large. The total length of the line is % ', st_length(geom_aux)::numeric(12,2);
    END IF;

    IF inverted_bool IS TRUE THEN
	geom_aux:= st_reverse(geom_aux);
    END IF;

    -- azimut calculation
    SELECT ST_LineInterpolatePoint(geom_aux, (percent_aux-0.001)) into point1_aux;
    SELECT ST_LineInterpolatePoint(geom_aux, (percent_aux+0.001)) into point2_aux;
    angle_aux:=(st_azimuth(point1_aux,point2_aux)-3.14159/2);

    -- point coordinates calculation
    SELECT ST_LineInterpolatePoint(geom_aux, percent_aux) into point_aux;
    xcoord = ST_x(point_aux)+(sin(angle_aux))*y_var::float;
    ycoord = ST_y(point_aux)+(cos(angle_aux))*y_var::float;
    point_result = ST_SetSRID(ST_MakePoint(xcoord, ycoord),rec.epsg);	
    coords_arr = array_append(coords_arr, xcoord);
    coords_arr= array_append(coords_arr, ycoord);


RETURN coords_arr;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


