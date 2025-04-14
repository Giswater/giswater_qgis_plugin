/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

-- Extract and test the "status" field from the function's JSON response


SELECT is(
    (gw_fct_waterbalance($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"exploitation":"1", "period":"5", "method":"DCW"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 1, period 5 and method DCW returns status "Accepted"'
);


SELECT is(
    (gw_fct_waterbalance($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"exploitation":"2", "period":"5", "method":"DCW"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 2, period 5 and method DCW returns status "Accepted"'
);


SELECT is(
    (gw_fct_waterbalance($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"exploitation":"1", "period":"6", "method":"DCW"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 1, period 6 and method DCW returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"exploitation":"2", "period":"6", "method":"DCW"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 2, period 6 and method DCW returns status "Accepted"'
);


SELECT is(
    (gw_fct_waterbalance($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"exploitation":"1", "period":"7", "method":"DCW"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 1, period 7 and method DCW returns status "Accepted"'
);


SELECT is(
    (gw_fct_waterbalance($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"exploitation":"2", "period":"7", "method":"DCW"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 2, period 7 and method DCW returns status "Accepted"'
);



-- Finish the test
SELECT finish();

ROLLBACK;
