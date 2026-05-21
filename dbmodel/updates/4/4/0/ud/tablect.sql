/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP RULE IF EXISTS omzone_conflict ON omzone;
DROP RULE IF EXISTS omzone_del_conflict ON omzone;
DROP RULE IF EXISTS omzone_del_undefined ON omzone;
DROP RULE IF EXISTS omzone_undefined ON omzone;

DROP RULE IF EXISTS dwfzone_conflict ON dwfzone;
DROP RULE IF EXISTS dwfzone_undefined ON dwfzone;

DROP RULE IF EXISTS macroomzone_del_undefined ON macroomzone;
DROP RULE IF EXISTS macroomzone_undefined ON macroomzone;
