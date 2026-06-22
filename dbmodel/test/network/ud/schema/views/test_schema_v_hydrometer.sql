/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(2);

SELECT has_view('v_hydrometer'::name, 'View v_hydrometer should exist after cibs integration');
SELECT is(
    (SELECT COUNT(*)::int FROM information_schema.tables
     WHERE table_schema = 'SCHEMA_NAME' AND table_name = 'ext_hydrometer'),
    0,
    'Local ext_hydrometer table should be replaced by cibs integration'
);

SELECT finish();

ROLLBACK;
