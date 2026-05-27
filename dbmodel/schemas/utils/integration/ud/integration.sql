/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE IF EXISTS ext_address RENAME TO ext_address_old;
ALTER TABLE IF EXISTS ext_cat_raster RENAME TO ext_cat_raster_old;
ALTER TABLE IF EXISTS ext_district RENAME TO ext_district_old;
ALTER TABLE IF EXISTS ext_region_x_province RENAME TO ext_region_x_province_old;
ALTER TABLE IF EXISTS ext_municipality RENAME TO ext_municipality_old;
ALTER TABLE IF EXISTS ext_plot RENAME TO ext_plot_old;
ALTER TABLE IF EXISTS ext_province RENAME TO ext_province_old;
ALTER TABLE IF EXISTS ext_raster_dem RENAME TO ext_raster_dem_old;
ALTER TABLE IF EXISTS ext_region RENAME TO ext_region_old;
ALTER TABLE IF EXISTS ext_streetaxis RENAME TO ext_streetaxis_old;
ALTER TABLE IF EXISTS ext_type_street RENAME TO ext_type_street_old;

CREATE OR REPLACE VIEW v_municipality AS
SELECT * FROM utils.municipality;

CREATE OR REPLACE VIEW v_streetaxis AS
SELECT * FROM utils.streetaxis;

CREATE OR REPLACE VIEW v_address AS
SELECT * FROM utils.address;

CREATE OR REPLACE VIEW v_plot AS
SELECT * FROM utils.plot;

CREATE OR REPLACE VIEW v_raster_dem AS
SELECT * FROM utils.raster_dem;

CREATE OR REPLACE VIEW v_ext_raster_dem
AS SELECT DISTINCT ON (r.id) r.id,
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
   FROM ve_municipality a,
    v_raster_dem r
     JOIN utils.cat_raster c ON c.id = r.rastercat_id
  WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);

CREATE OR REPLACE VIEW v_district AS
SELECT * FROM utils.district;

CREATE OR REPLACE VIEW v_region AS
SELECT * FROM utils.region;

CREATE OR REPLACE VIEW v_province AS
SELECT * FROM utils.province;

CREATE OR REPLACE VIEW v_type_street AS
SELECT * FROM utils.type_street;

INSERT INTO utils.config_param_system(parameter, value, descript)
VALUES ('ud_current_schema', 'SCHEMA_NAME', 'Indicate the name for the UD schema');

UPDATE config_param_system SET value='TRUE' WHERE parameter='admin_utils_schema';

DELETE FROM sys_table WHERE id = 'ext_address';
DELETE FROM sys_table WHERE id = 'ext_municipality';
DELETE FROM sys_table WHERE id = 'ext_streetaxis';
DELETE FROM sys_table WHERE id = 'ext_plot';
DELETE FROM sys_table WHERE id = 'ext_cat_raster';
DELETE FROM sys_table WHERE id = 'ext_raster_dem';
DELETE FROM sys_table WHERE id = 'ext_district';
DELETE FROM sys_table WHERE id = 'ext_region';
DELETE FROM sys_table WHERE id = 'ext_region_x_province';
DELETE FROM sys_table WHERE id = 'ext_province';
DELETE FROM sys_table WHERE id = 'ext_type_street';


ALTER TABLE node DROP CONSTRAINT node_district_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc DROP CONSTRAINT arc_district_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec DROP CONSTRAINT connec_district_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec DROP CONSTRAINT connec_plot_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_plot_id_fkey FOREIGN KEY (plot_id) REFERENCES utils.plot(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully DROP CONSTRAINT gully_district_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link DROP CONSTRAINT link_muni_id_fkey;
ALTER TABLE link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element DROP CONSTRAINT element_muni_id_fkey;
ALTER TABLE element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE selector_municipality DROP CONSTRAINT selector_municipality_fkey;
ALTER TABLE selector_municipality ADD CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit DROP CONSTRAINT om_visit_muni_id_fkey;
ALTER TABLE om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_muni_id;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_muni_id_fkey;
ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node DROP CONSTRAINT node_muni_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc DROP CONSTRAINT arc_muni_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec DROP CONSTRAINT connec_muni_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully DROP CONSTRAINT gully_muni_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE raingage DROP CONSTRAINT raingage_muni_id_fkey;
ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_subcatchment DROP CONSTRAINT inp_subcatchment_muni_id_fkey;
ALTER TABLE inp_subcatchment ADD CONSTRAINT inp_subcatchment_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node DROP CONSTRAINT node_streetaxis_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node DROP CONSTRAINT node_streetaxis2_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc DROP CONSTRAINT arc_streetaxis_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc DROP CONSTRAINT arc_streetaxis2_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec DROP CONSTRAINT connec_streetaxis_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec DROP CONSTRAINT connec_streetaxis2_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully DROP CONSTRAINT gully_streetaxis_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully DROP CONSTRAINT gully_streetaxis2_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ext_raster_dem_old DROP CONSTRAINT raster_dem_rastercat_id_fkey;
ALTER TABLE ext_streetaxis_old DROP CONSTRAINT ext_streetaxis_muni_id_fkey;
ALTER TABLE ext_streetaxis_old DROP CONSTRAINT ext_streetaxis_type_street_fkey;
ALTER TABLE ext_address_old DROP CONSTRAINT ext_address_muni_id_fkey;
ALTER TABLE ext_address_old DROP CONSTRAINT ext_address_plot_id_fkey;
ALTER TABLE ext_address_old DROP CONSTRAINT ext_address_streetaxis_id_fkey;
ALTER TABLE ext_plot_old DROP CONSTRAINT ext_plot_muni_id_fkey;
ALTER TABLE ext_plot_old DROP CONSTRAINT ext_plot_streetaxis_id_fkey;
ALTER TABLE ext_district_old DROP CONSTRAINT ext_district_muni_id_fkey;
ALTER TABLE ext_municipality_old DROP CONSTRAINT ext_municipality_province_id_fkey;
ALTER TABLE ext_municipality_old DROP CONSTRAINT ext_municipality_region_id_fkey;


DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON dma;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON macroomunit;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON omunit;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON macroomzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON omzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON macrosector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON dwfzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON drainzone;

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dma":"sector_id", "dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "utils.municipality":"sector_id"}');
CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE OF sector_id ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"utils.municipality":"sector_id", "exploitation":"sector_id"}');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
dma FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
macroomunit FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
omunit FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
macroomzone FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
omzone FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
macrosector FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
drainzone FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
