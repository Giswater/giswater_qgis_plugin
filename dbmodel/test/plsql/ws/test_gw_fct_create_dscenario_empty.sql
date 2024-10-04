/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(108);

-- Extract and test the "status" field from the function's JSON response

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"DEMAND",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : DEMAND returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VALVE",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : VALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"INLET",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : INLET returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PUMP",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : PUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PIPE",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : PIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JOINED",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : JOINED returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"OTHER",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : OTHER returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JUNCTION",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : JUNCTION returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONNEC",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : CONNEC returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"SHORTPIPE",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : SHORTPIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VIRTUALVALVE",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : VIRTUALVALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VITUALPUMP",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : VITUALPUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"ADDITIONAL",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : ADDITIONAL returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONTROLS",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : CONTROLS returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RULES",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : RULES returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RESERVOIR",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : RESERVOIR returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"TANK",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : TANK returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"NETWORK",
    "active":"true", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 0, type : NETWORK returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"DEMAND",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : DEMAND returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VALVE",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : VALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"INLET",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : INLET returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PUMP",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : PUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PIPE",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : PIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JOINED",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : JOINED returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"OTHER",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : OTHER returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JUNCTION",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : JUNCTION returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONNEC",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : CONNEC returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"SHORTPIPE",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : SHORTPIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VIRTUALVALVE",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : VIRTUALVALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VITUALPUMP",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : VITUALPUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"ADDITIONAL",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : ADDITIONAL returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONTROLS",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : CONTROLS returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RULES",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : RULES returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RESERVOIR",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : RESERVOIR returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"TANK",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : TANK returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"NETWORK",
    "active":"true", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 1, type : NETWORK returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"DEMAND",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : DEMAND returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VALVE",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : VALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"INLET",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : INLET returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PUMP",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : PUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PIPE",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : PIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JOINED",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : JOINED returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"OTHER",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : OTHER returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JUNCTION",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : JUNCTION returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONNEC",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : CONNEC returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"SHORTPIPE",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : SHORTPIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VIRTUALVALVE",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : VIRTUALVALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VITUALPUMP",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : VITUALPUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"ADDITIONAL",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : ADDITIONAL returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONTROLS",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : CONTROLS returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RULES",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : RULES returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RESERVOIR",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : RESERVOIR returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"TANK",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : TANK returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"NETWORK",
    "active":"true", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty  --> active : true, expl : 2, type : NETWORK returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"DEMAND",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : DEMAND returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VALVE",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : VALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"INLET",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : INLET returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PUMP",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : PUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PIPE",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : PIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JOINED",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : JOINED returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"OTHER",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : OTHER returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JUNCTION",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : JUNCTION returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONNEC",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : CONNEC returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"SHORTPIPE",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : SHORTPIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VIRTUALVALVE",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : VIRTUALVALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VITUALPUMP",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : VITUALPUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"ADDITIONAL",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : ADDITIONAL returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONTROLS",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : CONTROLS returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RULES",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : RULES returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RESERVOIR",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : RESERVOIR returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"TANK",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : TANK returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"NETWORK",
    "active":"false", "expl":"0"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 0, type : NETWORK returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"DEMAND",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : DEMAND returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VALVE",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : VALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"INLET",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : INLET returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PUMP",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : PUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PIPE",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : PIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JOINED",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : JOINED returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"OTHER",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : OTHER returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JUNCTION",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : JUNCTION returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONNEC",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : CONNEC returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"SHORTPIPE",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : SHORTPIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VIRTUALVALVE",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : VIRTUALVALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VITUALPUMP",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : VITUALPUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"ADDITIONAL",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : ADDITIONAL returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONTROLS",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : CONTROLS returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RULES",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : RULES returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RESERVOIR",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : RESERVOIR returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"TANK",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : TANK returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"NETWORK",
    "active":"false", "expl":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 1,  type : NETWORK returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"DEMAND",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : DEMAND returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VALVE",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : VALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"INLET",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : INLET returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PUMP",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : PUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"PIPE",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : PIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JOINED",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : JOINED returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"OTHER",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : OTHER returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"JUNCTION",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : JUNCTION returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONNEC",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : CONNEC returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"SHORTPIPE",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : SHORTPIPE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VIRTUALVALVE",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : VIRTUALVALVE returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"VITUALPUMP",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : VITUALPUMP returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"ADDITIONAL",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : ADDITIONAL returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"CONTROLS",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : CONTROLS returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RULES",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : RULES returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"RESERVOIR",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : RESERVOIR returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"TANK",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : TANK returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_empty($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"dscenario", "descript":null, "parent":null, "type":"NETWORK",
    "active":"false", "expl":"2"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_empty --> active : false, expl : 2,  type : NETWORK returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
