/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 1 test
SELECT plan(1);

-- initial data is prepared before proceeding with the test
INSERT INTO plan_psector (psector_id, "name", psector_type, descript, expl_id, priority, text1, text2, observ, rotation, "scale", atlas_id, gexpenses, vat, other, active,
the_geom, enable_all, status, ext_code, text3, text4, text5, text6, num_value, workcat_id, parent_id, tstamp, insert_user, lastupdate, lastupdate_user)
VALUES(9, 'Masterplan 09', 1, 'Psector 9, prepared in test', 1, '3', NULL, NULL, 'Action caused by the headloss of the pipe.', 90.0000, 750.00, '02', 19.00, 21.00, 0.00, true,
'SRID=25831;MULTIPOLYGON (((419077.6619419637 4576838.663100324, 419077.6619419637 4576761.052890681, 419029.32346890226 4576761.052890681, 419029.32346890226 4576838.663100324, 419077.6619419637 4576838.663100324)))'::public.geometry,
false, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-02-21 12:08:16.880', 'postgres', NULL, NULL);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setdelete($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"id":["9"], "featureType":"PSECTOR",
    "tableName":"v_ui_plan_psector", "idName":"psector_id"}, "data":{"filterFields":{}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setdelete returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;