/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(1);

SELECT is(
    (SELECT value FROM config_param_system WHERE parameter = 'admin_cibs_schema'),
    'true',
    'admin_cibs_schema flag should be enabled after integration'
);

SELECT finish();

ROLLBACK;
