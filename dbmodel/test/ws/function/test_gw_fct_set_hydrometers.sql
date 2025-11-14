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

SELECT plan(16);

-- Test 1: Insert single hydrometer
SELECT is(
    (gw_fct_set_hydrometers($${"client":{"device":5, "infoType":1, "lang":"ES"},
    "data":{"action":"INSERT", "hydrometers":[
        {"code":"TEST_H001", "hydro_number":"12345", "connec_id":3001, "link":"http://test.com",
         "state_id":1, "catalog_id":1, "category_id":1, "priority_id":1, "exploitation":1,
         "start_date":"2025-10-30"}
    ]}}$$)::JSON)->>'status',
    'Accepted',
    'Test single hydrometer INSERT'
);

-- Test 2: Verify hydrometer was inserted
SELECT is(
    (SELECT count(*)::integer FROM ext_rtc_hydrometer WHERE code = 'TEST_H001'),
    1,
    'Verify hydrometer was inserted into ext_rtc_hydrometer'
);

-- Test 4: Verify hydrometer connec relation was inserted
SELECT is(
    (SELECT count(*)::integer FROM rtc_hydrometer_x_connec WHERE hydrometer_id = 'TEST_H001'),
    1,
    'Verify hydrometer connec relation was inserted'
);

-- Test 5: Insert multiple hydrometers
SELECT is(
    (gw_fct_set_hydrometers($${"client":{"device":5, "infoType":1, "lang":"ES"},
    "data":{"action":"INSERT", "hydrometers":[
        {"code":"TEST_H002", "hydro_number":"12346", "connec_id":3002, "state_id":1, "catalog_id":1, "category_id":1, "priority_id":1, "exploitation":1},
        {"code":"TEST_H003", "hydro_number":"12347", "connec_id":3003, "state_id":1, "catalog_id":1, "category_id":1, "priority_id":1, "exploitation":1}
    ]}}$$)::JSON)->>'status',
    'Accepted',
    'Test multiple hydrometers INSERT'
);

-- Test 6: Verify multiple hydrometers were inserted
SELECT is(
    (SELECT count(*)::integer FROM ext_rtc_hydrometer WHERE code IN ('TEST_H002', 'TEST_H003')),
    2,
    'Verify multiple hydrometers were inserted'
);

-- Test 7: Update single hydrometer
SELECT is(
    (gw_fct_set_hydrometers($${"client":{"device":5, "infoType":1, "lang":"ES"},
    "data":{"action":"UPDATE", "hydrometers":[
        {"code":"TEST_H001", "hydro_number":"12345-UPDATED", "state_id":2}
    ]}}$$)::JSON)->>'status',
    'Accepted',
    'Test single hydrometer UPDATE'
);

-- Test 8: Verify hydrometer was updated
SELECT is(
    (SELECT hydro_number FROM ext_rtc_hydrometer WHERE code = 'TEST_H001'),
    '12345-UPDATED',
    'Verify hydrometer hydro_number was updated'
);

-- Test 9: Verify hydrometer state was updated
SELECT is(
    (SELECT state_id FROM ext_rtc_hydrometer WHERE code = 'TEST_H001'),
    2::smallint,
    'Verify hydrometer state_id was updated'
);

-- Test 10: Update multiple hydrometers
SELECT is(
    (gw_fct_set_hydrometers($${"client":{"device":5, "infoType":1, "lang":"ES"},
    "data":{"action":"UPDATE", "hydrometers":[
        {"code":"TEST_H002", "state_id":2},
        {"code":"TEST_H003", "state_id":3}
    ]}}$$)::JSON)->>'status',
    'Accepted',
    'Test multiple hydrometers UPDATE'
);

-- Test 11: Delete single hydrometer
SELECT is(
    (gw_fct_set_hydrometers($${"client":{"device":5, "infoType":1, "lang":"ES"},
    "data":{"action":"DELETE", "hydrometers":[
        {"code":"TEST_H001"}
    ]}}$$)::JSON)->>'status',
    'Accepted',
    'Test single hydrometer DELETE'
);

-- Test 12: Verify hydrometer was deleted
SELECT is(
    (SELECT count(*)::integer FROM ext_rtc_hydrometer WHERE code = 'TEST_H001'),
    0,
    'Verify hydrometer was deleted'
);

-- Test 13: Delete multiple hydrometers
SELECT is(
    (gw_fct_set_hydrometers($${"client":{"device":5, "infoType":1, "lang":"ES"},
    "data":{"action":"DELETE", "hydrometers":[
        {"code":"TEST_H002"},
        {"code":"TEST_H003"}
    ]}}$$)::JSON)->>'status',
    'Accepted',
    'Test multiple hydrometers DELETE'
);

-- Test 14: REPLACE action (delete all and insert new ones)
-- First insert some test data
INSERT INTO ext_rtc_hydrometer (id, code, hydro_number, state_id, expl_id)
VALUES ('TEST_H010', 'TEST_H010', '10001', 1, 1),
       ('TEST_H011', 'TEST_H011', '10002', 1, 1);

-- Execute REPLACE
SELECT is(
    (gw_fct_set_hydrometers($${"client":{"device":5, "infoType":1, "lang":"ES"},
    "data":{"action":"REPLACE", "hydrometers":[
        {"code":"TEST_H020", "hydro_number":"20001", "connec_id":3001, "state_id":1, "catalog_id":1, "category_id":1, "priority_id":1, "exploitation":1},
        {"code":"TEST_H021", "hydro_number":"20002", "connec_id":3002, "state_id":1, "catalog_id":1, "category_id":1, "priority_id":1, "exploitation":1}
    ]}}$$)::JSON)->>'status',
    'Accepted',
    'Test REPLACE action'
);

-- Test 15: Verify old hydrometers were deleted
SELECT is(
    (SELECT count(*)::integer FROM ext_rtc_hydrometer WHERE code IN ('TEST_H010', 'TEST_H011')),
    0,
    'Verify old hydrometers were deleted by REPLACE'
);

-- Test 16: Verify new hydrometers were inserted
SELECT is(
    (SELECT count(*)::integer FROM ext_rtc_hydrometer WHERE code IN ('TEST_H020', 'TEST_H021')),
    2,
    'Verify new hydrometers were inserted by REPLACE'
);

-- Cleanup: ensure test data is removed
DELETE FROM rtc_hydrometer_x_connec WHERE hydrometer_id LIKE 'TEST_H%';
DELETE FROM ext_rtc_hydrometer WHERE code LIKE 'TEST_H%';

-- Finish the test
SELECT finish();

ROLLBACK;

