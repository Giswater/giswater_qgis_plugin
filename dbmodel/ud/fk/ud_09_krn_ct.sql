/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



--ALTER TABLE man_addfields_value ADD CONSTRAINT man_addfields_value_gully_fkey FOREIGN KEY (feature_id, feature_type) REFERENCES SCHEMA_NAME.gully (gully_id, feature_type) ON UPDATE CASCADE ON DELETE CASCADE;
