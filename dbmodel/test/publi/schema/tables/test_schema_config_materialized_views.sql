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

SELECT has_table('config_materialized_views'::name, 'Table config_materialized_views should exist');

SELECT columns_are(
    'config_materialized_views',
    ARRAY[
        'viewname', 'description', 'selector_config', 'active'
    ],
    'Table config_materialized_views should have the correct columns'
);

SELECT col_type_is('config_materialized_views', 'viewname', 'text', 'Column viewname should be text');
SELECT col_type_is('config_materialized_views', 'description', 'text', 'Column description should be text');
SELECT col_type_is('config_materialized_views', 'selector_config', 'jsonb', 'Column selector_config should be jsonb');
SELECT col_type_is('config_materialized_views', 'active', 'bool', 'Column active should be bool');

SELECT has_pk('config_materialized_views', 'Table config_materialized_views should have a primary key on viewname');

SELECT * FROM finish();

ROLLBACK;
