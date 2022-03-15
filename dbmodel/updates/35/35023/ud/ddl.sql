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


CREATE TABLE IF NOT EXISTS rpt_arcpollutant_sum (
  id serial,
  result_id character varying(30),
  poll_id character varying(16),
  arc_id character varying(50),
  value numeric(12,4),
  CONSTRAINT rpt_arcpollutant_sum_pkey PRIMARY KEY (id),
CONSTRAINT rpt_arcpollutant_sum_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE );

ALTER TABLE inp_dscenario_inflows DROP CONSTRAINT inp_dscenario_inflows_node_id_fkey;
ALTER TABLE inp_dscenario_inflows
  ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inflows_poll DROP CONSTRAINT inp_dscenario_inflows_pol_node_id_fkey;
ALTER TABLE inp_dscenario_inflows_poll
  ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE temp_node_other ADD CONSTRAINT temp_node_other_unique UNIQUE (node_id, type);

