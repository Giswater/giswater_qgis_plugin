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

-- Check view v_ui_workcat_x_feature
SELECT has_view('v_ui_workcat_x_feature'::name, 'View v_ui_workcat_x_feature should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_workcat_x_feature',
    ARRAY[
        'rid', 'feature_type', 'featurecat_id', 'feature_id', 'code', 'expl_name', 'workcat_id', 'expl_id'
    ],
    'View v_ui_workcat_x_feature should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;