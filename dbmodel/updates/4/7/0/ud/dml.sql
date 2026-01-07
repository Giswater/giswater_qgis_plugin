/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO macroomunit (macroomunit_id) VALUES(0) ON CONFLICT (macroomunit_id) DO NOTHING;
INSERT INTO omunit (omunit_id) VALUES(0) ON CONFLICT (omunit_id) DO NOTHING;