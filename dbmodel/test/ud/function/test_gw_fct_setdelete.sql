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
INSERT INTO plan_psector (psector_id, "name", psector_type, descript, expl_id, priority, text1, text2, observ, rotation, "scale", atlas_id, gexpenses, vat, other, active,
the_geom, enable_all, status, ext_code, text3, text4, text5, text6, num_value, workcat_id, parent_id, created_at, created_by, updated_at, updated_by)
VALUES(-999, 'ACT_09_F1', 1, 'Psector test -999', 1, '2', NULL, NULL, 'Action caused by the hydraulic insufficiency of the conduit.', 90.0000, 1000.00, '02', 19.00, 21.00, 4.50, true,
'SRID=25831;MULTIPOLYGON (((419057.982 4576702.77, 419057.982 4576647.495195547, 419013.7742227199 4576647.495195547, 419013.7742227199 4576702.77, 419057.982 4576702.77)))'::public.geometry,
false, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-02-21 12:09:27.095', 'postgres', NULL, NULL);

-- Create roles for testing
CREATE USER plan_user;
GRANT role_plan to plan_user;

CREATE USER epa_user;
GRANT role_epa to epa_user;

CREATE USER edit_user;
GRANT role_edit to edit_user;

CREATE USER om_user;
GRANT role_om to om_user;

CREATE USER basic_user;
GRANT role_basic to basic_user;

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setdelete($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"id":["-999"],
    "featureType":"PSECTOR", "tableName":"v_ui_plan_psector", "idName":"psector_id"}, "data":{"filterFields":{}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setcatalog returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
