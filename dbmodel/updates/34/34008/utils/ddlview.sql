/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_anl_mincut_flowtrace;

CREATE OR REPLACE VIEW v_anl_graf AS 
 SELECT anl_graf.arc_id,
    anl_graf.node_1,
    anl_graf.node_2,
    anl_graf.flag,
    a.flag AS flagi,
    a.value
   FROM temp_anlgraf anl_graf
     JOIN ( SELECT anl_graf_1.arc_id,
            anl_graf_1.node_1,
            anl_graf_1.node_2,
            anl_graf_1.water,
            anl_graf_1.flag,
            anl_graf_1.checkf,
            anl_graf_1.value
           FROM temp_anlgraf anl_graf_1
          WHERE anl_graf_1.water = 1) a ON anl_graf.node_1 = a.node_2
  WHERE anl_graf.flag < 2 AND anl_graf.water = 0 AND a.flag < 2;
  
 
 
CREATE OR REPLACE VIEW v_ext_raster_dem AS 
SELECT DISTINCT ON (r.id) r.id,
c.code,
c.alias,
c.raster_type, 
c.descript,
c.source,
c.provider,
c.year,
r.rast,
r.rastercat_id,
r.envelope
FROM 
v_edit_exploitation a, ext_raster_dem r
JOIN ext_cat_raster c ON c.id=rastercat_id
WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);