/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/09
DROP VIEW v_ext_raster_dem;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_cat_raster", "column":"id", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_raster_dem", "column":"rastercat_id", "dataType":"text"}}$$);

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
FROM v_edit_exploitation a, ext_raster_dem r
JOIN ext_cat_raster c ON c.id::text = r.rastercat_id::text
WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);
