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

-- Plan for 1 test
SELECT plan(1);

-- initial data is prepared before proceeding with the test
INSERT INTO ve_plan_psector ( "name", descript, priority, text1, text2, observ, rotation, "scale", atlas_id, gexpenses, vat, other, the_geom, expl_id, psector_type, active, ext_code, status, text3, text4, text5, text6, num_value, workcat_id, parent_id)
VALUES('-901', 'Test psector for setfeaturereplaceplan', '2', NULL, NULL, 'Test psector for setfeaturereplaceplan', 0.0000, 750.00, '01', 19.00, 21.00, 0.00, 'SRID=25831;MULTIPOLYGON (((419209.60503196524 4576553.424854076, 419209.60503196524 4576503.357122214, 419089.7020131364 4576503.357122214, 419089.7020131364 4576553.424854076, 419209.60503196524 4576553.424854076)))'::public.geometry, 1, 1, true, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

UPDATE config_param_user SET value = (SELECT psector_id::text FROM ve_plan_psector WHERE name = '-901')
WHERE "parameter" = 'plan_psector_current' AND cur_user = current_user;
INSERT INTO selector_psector (psector_id, cur_user) VALUES ((SELECT psector_id FROM ve_plan_psector WHERE name = '-901'), current_user);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setfeaturereplaceplan($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"featureType":"ARC", "ids":["209"]}, "data":{"filterFields":{}, "pageInfo":{}, "catalog":"CC100", "description":"null"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setfeaturereplaceplan returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;