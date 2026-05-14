/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "utils", public, pg_catalog;

ALTER TABLE raster_dem ADD CONSTRAINT raster_dem_rastercat_id_fkey FOREIGN KEY (rastercat_id) REFERENCES cat_raster(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE streetaxis ADD CONSTRAINT streetaxis_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE streetaxis ADD CONSTRAINT streetaxis_type_street_fkey FOREIGN KEY (type) REFERENCES type_street(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE address ADD CONSTRAINT address_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE address ADD CONSTRAINT address_plot_id_fkey FOREIGN KEY (plot_id) REFERENCES plot(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE address ADD CONSTRAINT address_streetaxis_id_fkey FOREIGN KEY (streetaxis_id) REFERENCES streetaxis(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE plot ADD CONSTRAINT plot_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE plot ADD CONSTRAINT plot_streetaxis_id_fkey FOREIGN KEY (streetaxis_id) REFERENCES streetaxis(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE district ADD CONSTRAINT district_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE municipality ADD CONSTRAINT municipality_province_id_fkey FOREIGN KEY (province_id) REFERENCES province(province_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE municipality ADD CONSTRAINT municipality_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE region_x_province ADD CONSTRAINT region_x_province_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE region_x_province ADD CONSTRAINT region_x_province_province_id_fkey FOREIGN KEY (province_id) REFERENCES province(province_id) ON UPDATE CASCADE ON DELETE RESTRICT;