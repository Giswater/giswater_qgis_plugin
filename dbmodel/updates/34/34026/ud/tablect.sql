/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/16
ALTER TABLE inp_outfall DROP CONSTRAINT IF EXISTS inp_outfall_timser_id_fkey;
ALTER TABLE inp_inflows_pol_x_node DROP CONSTRAINT IF EXISTS inp_inflows_pol_x_node_timser_id_fkey;
ALTER TABLE inp_timeseries_value DROP CONSTRAINT IF EXISTS inp_timeseries_pkey;
ALTER TABLE inp_timeseries_value DROP CONSTRAINT IF EXISTS inp_timeseries_timser_id_fkey;
ALTER TABLE inp_timeseries DROP CONSTRAINT IF EXISTS inp_timser_id_pkey CASCADE;

ALTER TABLE cat_arc DROP CONSTRAINT IF EXISTS cat_arc_tsect_id_fkey;
ALTER TABLE cat_arc_shape DROP CONSTRAINT IF EXISTS  cat_arc_shape_tsect_id_fkey;
ALTER TABLE inp_transects_value DROP CONSTRAINT IF EXISTS inp_transects_pkey;
ALTER TABLE inp_transects_value DROP CONSTRAINT IF EXISTS inp_transects_tsect_id_fkey;
ALTER TABLE inp_transects DROP CONSTRAINT IF EXISTS inp_transects_id_pkey;


ALTER TABLE inp_timeseries ADD CONSTRAINT inp_timeseries_pkey PRIMARY KEY(id);

ALTER TABLE inp_timeseries_value ADD CONSTRAINT inp_timeseries_value_pkey PRIMARY KEY(id);

ALTER TABLE inp_timeseries_value ADD CONSTRAINT inp_timeseries_value_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_transects ADD CONSTRAINT inp_transects_pkey PRIMARY KEY(id);

ALTER TABLE inp_transects_value ADD CONSTRAINT inp_transects_value_pkey PRIMARY KEY(id);

ALTER TABLE inp_transects_value ADD CONSTRAINT inp_transects_value_tsect_id_fkey FOREIGN KEY (tsect_id)
REFERENCES inp_transects (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_inflows_pol_x_node ADD CONSTRAINT inp_inflows_pol_x_node_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_outfall ADD CONSTRAINT inp_outfall_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE cat_arc ADD CONSTRAINT cat_arc_tsect_id_fkey FOREIGN KEY (tsect_id)
REFERENCES inp_transects (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

