/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE node DROP CONSTRAINT node_district_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc DROP CONSTRAINT arc_district_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec DROP CONSTRAINT connec_district_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec DROP CONSTRAINT connec_plot_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_plot_id_fkey FOREIGN KEY (plot_id) REFERENCES utils.plot(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_district_id_fkey;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link DROP CONSTRAINT link_muni_id_fkey;
ALTER TABLE link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element DROP CONSTRAINT element_muni_id_fkey;
ALTER TABLE element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE selector_municipality DROP CONSTRAINT selector_municipality_fkey;
ALTER TABLE selector_municipality ADD CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_streetaxis_muni_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_muni_id;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_muni_id_fkey;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_visit DROP CONSTRAINT om_visit_muni_id_fkey;
ALTER TABLE om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_muni_id;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_muni_id_fkey;
ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_mincut DROP CONSTRAINT om_mincut_muni_id;
ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node DROP CONSTRAINT node_muni_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc DROP CONSTRAINT arc_muni_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec DROP CONSTRAINT connec_muni_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_muni_id_fkey;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_streetaxis DROP CONSTRAINT om_streetaxis_muni_id_fkey;
ALTER TABLE om_streetaxis ADD CONSTRAINT om_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
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
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_streetaxis_id_fkey;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_streetaxis2_id_fkey;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES utils.streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;

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