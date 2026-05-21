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
SELECT plan(3);

-- Previous inserts before test
INSERT INTO om_mincut
(id, work_order, mincut_state, mincut_class, mincut_type, received_date, expl_id, macroexpl_id, muni_id, postcode, streetaxis_id, postnumber, anl_cause, anl_tstamp, anl_user, anl_descript, anl_feature_id, anl_feature_type, anl_the_geom, forecast_start, forecast_end, assigned_to, exec_start, exec_end, exec_user, exec_descript, exec_the_geom, exec_from_plot, exec_depth, exec_appropiate, notified, "output", modification_date, chlorine, turbidity, minsector_id)
VALUES(-901, NULL, 0, 1, NULL, NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '2024-08-26 12:54:48.514', 'postgres', NULL, 2108, 'ARC', 'SRID=25831;POINT (419337.2864432267 4576622.70708354)'::public.geometry, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minsector_id":"2108","psectors":{"used":"f", "unselected":2}, "arcs":{"number":"31", "length":"1713.3", "volume":"16.51"}, "connecs":{"number":"90","hydrometers":{"total":"416","classified":[{"category":"business","number":"11"},{"category":"Domestic","number":"85"},{"category":"Industry","number":"123"},{"category":"Other","number":"126"},{"category":"Shops","number":"67"}]}}, "valve":{"proposed":"5","closed":"0"}}'::json, NULL, NULL, NULL, NULL);


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
    (gw_fct_setmincut($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{},
    "pageInfo":{}, "action":"mincutAccept", "mincutClass":1, "status":"check", "mincutId":"-901", "usePsectors":"False"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setmincut --> "status":"check" returns status "Accepted"'
);

SELECT is (
    (gw_fct_setmincut($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{},
    "pageInfo":{}, "action":"mincutAccept", "mincutClass":1, "status":"continue", "mincutId":"-901", "usePsectors":"False"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setmincut --> "status":"continue" returns status "Accepted"'
);

SELECT is (
    (gw_fct_setmincut($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{},
    "pageInfo":{}, "action":"mincutValveUnaccess", "nodeId":1096, "mincutId":"-901", "usePsectors":"False"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setmincut --> "action":"mincutValveUnaccess" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;