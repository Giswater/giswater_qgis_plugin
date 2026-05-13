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

-- Check view v_om_mincut_polygon
SELECT has_view('v_om_mincut_polygon'::name, 'View v_om_mincut_polygon should exist');

-- Check view columns
SELECT columns_are(
    'v_om_mincut_polygon',
    ARRAY[
        'id', 'work_order', 'state', 'class', 'mincut_type', 'received_date',
        'expl_id', 'expl_name', 'macroexpl_name', 'macroexpl_id', 'muni_id', 'muni_name',
        'postcode', 'streetaxis_id', 'street_name', 'postnumber', 'anl_cause', 'anl_tstamp',
        'anl_user', 'anl_descript', 'anl_feature_id', 'anl_feature_type', 'anl_the_geom', 'forecast_start',
        'forecast_end', 'assigned_to', 'exec_start', 'exec_end', 'exec_user', 'exec_descript',
        'exec_the_geom', 'exec_from_plot', 'exec_depth', 'exec_appropiate', 'chlorine', 'turbidity',
        'notified', 'output', 'reagent_lot', 'equipment_code', 'polygon_the_geom', 'shutoff_required'
    ],
    'View v_om_mincut_polygon should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_om_mincut_polygon', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_om_mincut_polygon', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('v_om_mincut_polygon', 'state', 'text', 'Column state should be text');
SELECT col_type_is('v_om_mincut_polygon', 'class', 'text', 'Column class should be text');
SELECT col_type_is('v_om_mincut_polygon', 'mincut_type', 'varchar(30)', 'Column mincut_type should be varchar(30)');
SELECT col_type_is('v_om_mincut_polygon', 'received_date', 'date', 'Column received_date should be date');
SELECT col_type_is('v_om_mincut_polygon', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_om_mincut_polygon', 'expl_name', 'varchar(100)', 'Column expl_name should be varchar(100)');
SELECT col_type_is('v_om_mincut_polygon', 'macroexpl_name', 'varchar(100)', 'Column macroexpl_name should be varchar(100)');
SELECT col_type_is('v_om_mincut_polygon', 'macroexpl_id', 'int4', 'Column macroexpl_id should be int4');
SELECT col_type_is('v_om_mincut_polygon', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('v_om_mincut_polygon', 'muni_name', 'text', 'Column muni_name should be text');
SELECT col_type_is('v_om_mincut_polygon', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('v_om_mincut_polygon', 'streetaxis_id', 'varchar(250)', 'Column streetaxis_id should be varchar(250)');
SELECT col_type_is('v_om_mincut_polygon', 'street_name', 'varchar(100)', 'Column street_name should be varchar(100)');
SELECT col_type_is('v_om_mincut_polygon', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('v_om_mincut_polygon', 'anl_cause', 'text', 'Column anl_cause should be text');
SELECT col_type_is('v_om_mincut_polygon', 'anl_tstamp', 'timestamp without time zone', 'Column anl_tstamp should be timestamp without time zone');
SELECT col_type_is('v_om_mincut_polygon', 'anl_user', 'varchar(30)', 'Column anl_user should be varchar(30)');
SELECT col_type_is('v_om_mincut_polygon', 'anl_descript', 'text', 'Column anl_descript should be text');
SELECT col_type_is('v_om_mincut_polygon', 'anl_feature_id', 'int4', 'Column anl_feature_id should be int4');
SELECT col_type_is('v_om_mincut_polygon', 'anl_feature_type', 'varchar(16)', 'Column anl_feature_type should be varchar(16)');
SELECT col_type_is('v_om_mincut_polygon', 'anl_the_geom', 'geometry(point, SRID_VALUE)', 'Column anl_the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('v_om_mincut_polygon', 'forecast_start', 'timestamp without time zone', 'Column forecast_start should be timestamp without time zone');
SELECT col_type_is('v_om_mincut_polygon', 'forecast_end', 'timestamp without time zone', 'Column forecast_end should be timestamp without time zone');
SELECT col_type_is('v_om_mincut_polygon', 'assigned_to', 'varchar(50)', 'Column assigned_to should be varchar(50)');
SELECT col_type_is('v_om_mincut_polygon', 'exec_start', 'timestamp without time zone', 'Column exec_start should be timestamp without time zone');
SELECT col_type_is('v_om_mincut_polygon', 'exec_end', 'timestamp without time zone', 'Column exec_end should be timestamp without time zone');
SELECT col_type_is('v_om_mincut_polygon', 'exec_user', 'varchar(30)', 'Column exec_user should be varchar(30)');
SELECT col_type_is('v_om_mincut_polygon', 'exec_descript', 'text', 'Column exec_descript should be text');
SELECT col_type_is('v_om_mincut_polygon', 'exec_the_geom', 'geometry(point, SRID_VALUE)', 'Column exec_the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('v_om_mincut_polygon', 'exec_from_plot', 'float8', 'Column exec_from_plot should be float8');
SELECT col_type_is('v_om_mincut_polygon', 'exec_depth', 'float8', 'Column exec_depth should be float8');
SELECT col_type_is('v_om_mincut_polygon', 'exec_appropiate', 'bool', 'Column exec_appropiate should be bool');
SELECT col_type_is('v_om_mincut_polygon', 'chlorine', 'varchar(30)', 'Column chlorine should be varchar(30)');
SELECT col_type_is('v_om_mincut_polygon', 'turbidity', 'varchar(30)', 'Column turbidity should be varchar(30)');
SELECT col_type_is('v_om_mincut_polygon', 'notified', 'json', 'Column notified should be json');
SELECT col_type_is('v_om_mincut_polygon', 'output', 'json', 'Column output should be json');
SELECT col_type_is('v_om_mincut_polygon', 'reagent_lot', 'varchar(100)', 'Column reagent_lot should be varchar(100)');
SELECT col_type_is('v_om_mincut_polygon', 'equipment_code', 'varchar(50)', 'Column equipment_code should be varchar(50)');
SELECT col_type_is('v_om_mincut_polygon', 'polygon_the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column polygon_the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('v_om_mincut_polygon', 'shutoff_required', 'bool', 'Column shutoff_required should be bool');

SELECT * FROM finish();

ROLLBACK;
