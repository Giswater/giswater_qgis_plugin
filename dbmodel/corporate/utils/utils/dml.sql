/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "utils", public, pg_catalog;

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('municipality', 'Table of town cities and villages', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('streetaxis', 'Table of streetaxis', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('address', 'Table of entrance numbers', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('plot', 'Table of urban properties', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('raster_dem', 'Table to store raster DEM', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('cat_raster', 'Catalog for raster layers', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('district', 'Table of districts', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('region_x_province', 'Table with the relations between regions and provinces', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('province', 'Table of provinces', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('region', 'Table of regions', 'role_edit', 'core');

INSERT INTO utils.sys_table (id, descript, sys_role, "source")
VALUES('type_street', 'Table with the values of different streetaxis types', 'role_edit', 'core');