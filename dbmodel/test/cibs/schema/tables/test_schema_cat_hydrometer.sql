/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(3);

SELECT has_table('cat_hydrometer'::name, 'Table cibs.cat_hydrometer should exist');
SELECT has_table('hydrometer_period'::name, 'Table cibs.hydrometer_period should exist');
SELECT col_type_is('hydrometer', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');

SELECT finish();

ROLLBACK;
