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

-- Check view v_ui_om_visit
SELECT has_view('v_ui_om_visit'::name, 'View v_ui_om_visit should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_om_visit',
    ARRAY[
        'id', 'visit_catalog', 'ext_code', 'startdate', 'enddate', 'user_name', 
        'webclient_id', 'exploitation', 'the_geom', 'descript', 'is_done', 'visit_type'
    ],
    'View v_ui_om_visit should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;