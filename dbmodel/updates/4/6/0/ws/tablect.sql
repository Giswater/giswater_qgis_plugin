/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_man_type_category_fk;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_man_type_fluid_fk;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_man_type_function_fk;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_man_type_location_fk;

ALTER TABLE node ADD CONSTRAINT node_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node ADD CONSTRAINT node_man_type_fluid_fk FOREIGN KEY (fluid_type) REFERENCES man_type_fluid(fluid_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node ADD CONSTRAINT node_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node ADD CONSTRAINT node_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_man_type_category_fk;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_man_type_fluid_fk;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_man_type_function_fk;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_man_type_location_fk;

ALTER TABLE arc ADD CONSTRAINT arc_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_man_type_fluid_fk FOREIGN KEY (fluid_type) REFERENCES man_type_fluid(fluid_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_man_type_category_fk;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_man_type_fluid_fk;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_man_type_function_fk;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_man_type_location_fk;

ALTER TABLE connec ADD CONSTRAINT connec_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_man_type_fluid_fk FOREIGN KEY (fluid_type) REFERENCES man_type_fluid(fluid_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE element DROP CONSTRAINT IF EXISTS element_man_type_category_fk;
ALTER TABLE element DROP CONSTRAINT IF EXISTS element_man_type_function_fk;
ALTER TABLE element DROP CONSTRAINT IF EXISTS element_man_type_location_fk;

ALTER TABLE element ADD CONSTRAINT element_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element ADD CONSTRAINT element_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element ADD CONSTRAINT element_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE link DROP CONSTRAINT IF EXISTS link_man_type_fluid_fk;
ALTER TABLE link DROP CONSTRAINT IF EXISTS link_man_type_location_fk;

ALTER TABLE link ADD CONSTRAINT link_man_type_fluid_fk FOREIGN KEY (fluid_type) REFERENCES man_type_fluid(fluid_type) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON UPDATE CASCADE ON DELETE RESTRICT;
