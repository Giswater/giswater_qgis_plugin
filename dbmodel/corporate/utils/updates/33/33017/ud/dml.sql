/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity, qgis_criticity)
VALUES ('ext_district', 'Catalog of districts', 'role_edit', 0, 0) ON CONFLICT (id) DO NOTHING;

INSERT INTO utils.district (district_id, name, muni_id, observ, active, the_geom)
SELECT district_id, name, muni_id, observ, active, the_geom
FROM ext_district_old ON CONFLICT (district_id) DO NOTHING;