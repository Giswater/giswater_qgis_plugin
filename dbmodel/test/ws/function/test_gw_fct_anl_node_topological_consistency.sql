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

SELECT plan(1);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_anl_node_topological_consistency($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_node", "featureType":"NODE", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_user_check_data --> featureType : NODE returns status "Accepted"'
);

-- Processes --> edit[15] --> Check node topological consistency, faltan las otras opciones del combo.

-- Finish the test
SELECT finish();

ROLLBACK;
