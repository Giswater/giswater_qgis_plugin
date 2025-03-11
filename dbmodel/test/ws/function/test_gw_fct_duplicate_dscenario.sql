/*
This file is part of Giswater
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
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"DEMAND", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : DEMAND and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"DEMAND", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : DEMAND and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"DEMAND", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : DEMAND and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"DEMAND", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : DEMAND and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"DEMAND", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : DEMAND and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"DEMAND", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : DEMAND and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VALVE", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : VALVE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VALVE", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : VALVE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VALVE", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : VALVE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VALVE", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : VALVE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VALVE", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : VALVE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VALVE", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : VALVE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"INLET", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : INLET and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"INLET", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : INLET and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"INLET", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : INLET and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"INLET", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : INLET and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"INLET", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : INLET and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"INLET", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : INLET and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PUMP", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : PUMP and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PUMP", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : PUMP and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PUMP", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : PUMP and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PUMP", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : PUMP and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PUMP", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : PUMP and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PUMP", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : PUMP and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PIPE", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : PIPE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PIPE", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : PIPE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PIPE", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : PIPE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PIPE", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : PIPE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PIPE", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : PIPE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"PIPE", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : PIPE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JOINED", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : JOINED and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JOINED", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : JOINED and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JOINED", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : JOINED and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JOINED", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : JOINED and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JOINED", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : JOINED and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JOINED", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : JOINED and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"OTHER", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : OTHER and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"OTHER", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : OTHER and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"OTHER", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : OTHER and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"OTHER", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : OTHER and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"OTHER", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : OTHER and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"OTHER", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : OTHER and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JUNCTION", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : JUNCTION and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JUNCTION", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : JUNCTION and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JUNCTION", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : JUNCTION and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JUNCTION", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : JUNCTION and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JUNCTION", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : JUNCTION and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"JUNCTION", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : JUNCTION and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONNEC", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : CONNEC and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONNEC", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : CONNEC and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONNEC", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : CONNEC and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONNEC", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : CONNEC and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONNEC", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : CONNEC and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONNEC", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : CONNEC and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"SHORTPIPE", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : SHORTPIPE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"SHORTPIPE", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : SHORTPIPE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"SHORTPIPE", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : SHORTPIPE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"SHORTPIPE", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : SHORTPIPE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"SHORTPIPE", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : SHORTPIPE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"SHORTPIPE", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : SHORTPIPE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALVALVE", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : VIRTUALVALVE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALVALVE", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : VIRTUALVALVE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALVALVE", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : VIRTUALVALVE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALVALVE", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : VIRTUALVALVE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALVALVE", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : VIRTUALVALVE and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALVALVE", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : VIRTUALVALVE and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALPUMP", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : VIRTUALPUMP and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALPUMP", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : VIRTUALPUMP and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALPUMP", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : VIRTUALPUMP and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALPUMP", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : VIRTUALPUMP and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALPUMP", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : VIRTUALPUMP and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"VIRTUALPUMP", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : VIRTUALPUMP and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"ADDITIONAL", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : ADDITIONAL and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"ADDITIONAL", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : ADDITIONAL and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"ADDITIONAL", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : ADDITIONAL and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"ADDITIONAL", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : ADDITIONAL and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"ADDITIONAL", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : ADDITIONAL and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"ADDITIONAL", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : ADDITIONAL and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONTROLS", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : CONTROLS and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONTROLS", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : CONTROLS and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONTROLS", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : CONTROLS and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONTROLS", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : CONTROLS and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONTROLS", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : CONTROLS and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"CONTROLS", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : CONTROLS and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RULES", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : RULES and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RULES", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : RULES and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RULES", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : RULES and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RULES", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : RULES and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RULES", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : RULES and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RULES", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : RULES and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RESERVOIR", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : RESERVOIR and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RESERVOIR", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : RESERVOIR and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RESERVOIR", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : RESERVOIR and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RESERVOIR", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : RESERVOIR and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RESERVOIR", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : RESERVOIR and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"RESERVOIR", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : RESERVOIR and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"TANK", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : TANK and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"TANK", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : TANK and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"TANK", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : TANK and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"TANK", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : TANK and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"TANK", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : TANK and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"TANK", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : TANK and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"NETWORK", "active":"true", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : NETWORK and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"NETWORK", "active":"false", "expl":"0"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 0, type : NETWORK and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"NETWORK", "active":"true", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : NETWORK and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"NETWORK", "active":"false", "expl":"1"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 1, type : NETWORK and active : false returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"NETWORK", "active":"true", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : NETWORK and active : true returns status "Accepted"'
);


SELECT is(
    (gw_fct_duplicate_dscenario($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"copyFrom":"1", "name":"dscenario", "descript":null, "parent":null,
        "type":"NETWORK", "active":"false", "expl":"2"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dscenario with expl : 2, type : NETWORK and active : false returns status "Accepted"'
);




-- Finish the test
SELECT finish();

ROLLBACK;
