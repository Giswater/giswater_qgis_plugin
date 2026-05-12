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

--check if table exists
SELECT has_table('anl_polygon'::name, 'Table anl_polygon should exist');

-- check columns names 


SELECT columns_are(
    'anl_polygon',
    ARRAY[
        'id', 'pol_id', 'pol_type','state','expl_id', 'fid','cur_user', 'the_geom','result_id', 'descript'
    ],
    'Table anl_polygon should have the correct columns'
);
-- check columns names
SELECT col_type_is('anl_polygon', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('anl_polygon', 'pol_id', 'varchar(16)', 'Column pol_id should be varchar(16)');
SELECT col_type_is('anl_polygon', 'pol_type', 'varchar(30)', 'Column pol_type should be varchar(30)');
SELECT col_type_is('anl_polygon', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_polygon', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_polygon', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_polygon', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_polygon', 'the_geom', 'geometry(multipolygon,25831)', 'Column the_geom should be geometry(multipolygon,25831)');
SELECT col_type_is('anl_polygon', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_polygon', 'descript', 'text', 'Column descript should be text');



--check default values
SELECT col_has_default('anl_polygon', 'cur_user', 'Column cur_user should have default value');


-- check foreign keys



-- check index
SELECT has_index('anl_polygon', 'anl_polygon_index', ARRAY['the_geom'], 'Table anl_polygon should have index on the_geom');
SELECT has_index('anl_polygon', 'anl_polygon_pkey', ARRAY['id'], 'Table anl_polygon should have index on id');
SELECT has_index('anl_polygon', 'anl_polygon_pol_id', ARRAY['pol_id'], 'Table anl_polygon should have index on pol_id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;