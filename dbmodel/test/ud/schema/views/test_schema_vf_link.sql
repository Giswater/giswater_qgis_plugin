/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check view vf_link
SELECT has_view('vf_link'::name, 'View vf_link should exist');

-- Check view columns
SELECT columns_are(
    'vf_link',
    ARRAY[
        'link_id', 'p_state'
    ],
    'View vf_link should have the correct columns'
);

-- Check column types
SELECT col_type_is('vf_link', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('vf_link', 'p_state', 'int2', 'Column p_state should be int2');

SELECT * FROM finish();

ROLLBACK;
