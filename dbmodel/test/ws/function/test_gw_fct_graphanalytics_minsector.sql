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

SELECT plan(10);

SELECT has_function('gw_fct_graphanalytics_minsector', ARRAY['json'], 'Check if gw_fct_graphanalytics_minsector function exists');

SELECT is(
    (gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"-902",
                "usePlanPsector":"false",
                "commitChanges":"false",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_minsector with All exploitations and no commitChanges returns status "Accepted"'
);

SELECT ok(
    (SELECT gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"-902",
                "usePlanPsector":"false",
                "commitChanges":"false",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON->'body'->'data'->'polygon' IS NOT NULL),
    'Check if gw_fct_graphanalytics_minsector with All exploitations and no commitChanges returns a valid polygon'
);

SELECT is(
    (gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"-902",
                "usePlanPsector":"false",
                "commitChanges":"true",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_minsector with All exploitations and commitChanges true returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"-902",
                "usePlanPsector":"true",
                "commitChanges":"false",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_minsector with All exploitations and usePlanPsector true returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"-902",
                "usePlanPsector":"true",
                "commitChanges":"true",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_minsector with All exploitations and usePlanPsector true returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"1",
                "usePlanPsector":"false",
                "commitChanges":"false",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_minsector with exploitation 1 and no commitChanges returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"1",
                "usePlanPsector":"false",
                "commitChanges":"true",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_minsector with exploitation 1 and commitChanges true returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"2",
                "usePlanPsector":"false",
                "commitChanges":"false",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_minsector with exploitation 2 and no commitChanges returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_minsector($${
        "data": {
            "parameters":{
                "exploitation":"2",
                "usePlanPsector":"false",
                "commitChanges":"true",
                "updateMapZone":"2",
                "geomParamUpdate":"15"
            }
        }
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_minsector with exploitation 2 and commitChanges true returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
