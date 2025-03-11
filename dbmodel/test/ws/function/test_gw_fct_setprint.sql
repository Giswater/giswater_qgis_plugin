/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 1 test
SELECT plan(1);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setprint($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
    "data":{"composer": "composer_plan", "scale": 3096, "rotation": 0.0, "title": null,
    "ComposerTemplates": [{"ComposerTemplate": "composer_plan", "ComposerMap": [{"width": 65.4621, "height": 46.5539, "name": "Mapa 1", "index": 0},
    {"width": 177.676, "height": 98.32249999694072, "name": "map", "index": 1}]},
    {"ComposerTemplate": "composer_mincut", "ComposerMap": [{"width": 76.7641, "height": 58.44509490998759, "name": "Mapa 2", "index": 0},
    {"width": 179.414, "height": 140.8259999991146, "name": "Mapa", "index": 1}]}], "extent": {"p1": {"xcoord": 418752.6023731107, "ycoord": 4576398.707608407},
    "p2": {"xcoord": 419775.9112769171, "ycoord": 4576688.740716452}}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getprint returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;