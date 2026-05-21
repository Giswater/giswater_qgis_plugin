/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE gully ADD CONSTRAINT gully_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON DELETE SET NULL ON UPDATE CASCADE;
