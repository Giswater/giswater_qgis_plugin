
DROP FUNCTION IF EXISTS ws30.gw_fct_aux_relative_xy(geometry,float, float);
CREATE OR REPLACE FUNCTION ws30.gw_fct_aux_relative_xy(geom_aux geometry, x_var float, y_var float)
  RETURNS geometry AS
$BODY$DECLARE

point_aux geometry;


BEGIN

    -- Search path
    SET search_path = "ws30", public;

    SELECT ST_LineInterpolatePoint(geom_aux, x_var) into point_aux;

    RETURN point_aux;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws30.gw_fct_fill_om_tables()
  OWNER TO postgres;
