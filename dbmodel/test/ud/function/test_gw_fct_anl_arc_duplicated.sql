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

-- Plan for 2 test
SELECT plan(14);

-- failed test v_edit_inp_virtual for both geometry and finalnodes.

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_arc and checktype > finalnodes returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_conduit", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_conduit and checktype > finalnodes returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_orifice", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_orifice and checktype > finalnodes returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_outlet", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_outlet and checktype > finalnodes returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_pump and checktype > finalnodes returns status "Accepted"'

);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_virtual", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_virtual and checktype > finalnodes returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_weir", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_weir and checktype > finalnodes returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_arc and checktype > geometry returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_conduit", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_conduit and checktype > geometry returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_orifice", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_orifice and checktype > geometry returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_outlet", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_outlet and checktype > geometry returns status "Accepted"'
);


SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_pump and checktype > geometry returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_virtual", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_virtual and checktype > geometry returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_weir", "featureType":"ARC", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with tablename > v_edit_inp_weir and checktype > geometry returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
