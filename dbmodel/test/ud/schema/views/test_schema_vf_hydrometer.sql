/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

SELECT has_view('vf_hydrometer'::name, 'View vf_hydrometer should exist');
SELECT has_view('v_hydrometer'::name, 'View v_hydrometer should exist');

SELECT * FROM finish();

ROLLBACK;
