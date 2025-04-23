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

SELECT plan(12);

-- Extract and test the "status" field from the function's JSON response

SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"DMA", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : DMA, active : true and expl : 0 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"DMA", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : DMA, active : false and expl : 0 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"DMA", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : DMA, active : true and expl : 1 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"DMA", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : DMA, active : false and expl : 1 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"DMA", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : DMA, active : true and expl : 2 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"DMA", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : DMA, active : false and expl : 2 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"PRESSZONE", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : PRESSZONE, active : true and expl : 0 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"PRESSZONE", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : PRESSZONE, active : false and expl : 0 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"PRESSZONE", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : PRESSZONE, active : true and expl : 1 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"PRESSZONE", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : PRESSZONE, active : false and expl : 1 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"PRESSZONE", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : PRESSZONE, active : true and expl : 2 returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_netscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"name":"netscenario", "descript":null, "type":"PRESSZONE", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_netscenario_from_toc with type : PRESSZONE, active : false and expl : 2 returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
