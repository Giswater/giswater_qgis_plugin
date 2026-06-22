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

SELECT has_table('sys_version'::name, 'Table cibs.sys_version should exist');
SELECT has_table('hydrometer'::name, 'Table cibs.hydrometer should exist');

SELECT finish();

ROLLBACK;
