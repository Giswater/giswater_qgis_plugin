/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2242


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_aux_relative_xy(geometry,float, float);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_aux_relative_xy(geom_aux geometry, x_var float, y_var float)
  RETURNS geometry AS
$BODY$DECLARE

point_aux geometry;


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT ST_LineInterpolatePoint(geom_aux, x_var) into point_aux;

    RETURN point_aux;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

