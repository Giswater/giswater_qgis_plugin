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

SELECT plan(972);

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

SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pipe, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_virtualpump, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_connec", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_connec, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_junction", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_junction, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_pump, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_reservoir, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_shortpipe, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_tank", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_tank, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : DEMAND, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : DEMAND, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : DEMAND, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : DEMAND, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : DEMAND, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"DEMAND", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : DEMAND, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : INLET, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : INLET, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : INLET, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : INLET, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : INLET, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"INLET", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : INLET, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"PIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : PIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JOINED, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JOINED, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JOINED, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JOINED, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JOINED, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JOINED", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JOINED, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : OTHER, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : OTHER, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : OTHER, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : OTHER, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : OTHER, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"OTHER", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : OTHER, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JUNCTION, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JUNCTION, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JUNCTION, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JUNCTION, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JUNCTION, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"JUNCTION", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : JUNCTION, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONNEC, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONNEC, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONNEC, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONNEC, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONNEC, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONNEC", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONNEC, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : SHORTPIPE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : SHORTPIPE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : SHORTPIPE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : SHORTPIPE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : SHORTPIPE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"SHORTPIPE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : SHORTPIPE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALVALVE, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALVALVE, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALVALVE, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALVALVE, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALVALVE, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALVALVE", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALVALVE, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALPUMP, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALPUMP, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALPUMP, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALPUMP, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALPUMP, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"VIRTUALPUMP", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : VIRTUALPUMP, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : ADDITIONAL, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : ADDITIONAL, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : ADDITIONAL, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : ADDITIONAL, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : ADDITIONAL, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"ADDITIONAL", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : ADDITIONAL, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONTROLS, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONTROLS, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONTROLS, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONTROLS, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONTROLS, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"CONTROLS", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : CONTROLS, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RULES, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RULES, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RULES, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RULES, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RULES, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RULES", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RULES, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RESERVOIR, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RESERVOIR, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RESERVOIR, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RESERVOIR, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RESERVOIR, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"RESERVOIR", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : RESERVOIR, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : TANK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : TANK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : TANK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : TANK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : TANK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"TANK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : TANK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : NETWORK, exploitation : 0, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"0", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : NETWORK, exploitation : 0, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : NETWORK, exploitation : 1, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"1", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : NETWORK, exploitation : 1, selectionMode : wholeSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"previousSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : NETWORK, exploitation : 2, selectionMode : previousSelection returns status "Accepted"'
);


SELECT is(
    (gw_fct_create_dscenario_from_toc($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{"tableName":"v_edit_inp_valve", "featureType":"ARC", "id":[]},
        "data":{"filterFields":{}, "pageInfo":{},
        "selectionMode":"wholeSelection",
        "parameters":{"name":"test", "descript":null, "type":"NETWORK", "exploitation":"2", "descript":null},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc --> tableName : v_edit_inp_valve, type : NETWORK, exploitation : 2, selectionMode : wholeSelection returns status "Accepted"'
);



-- Finish the test
SELECT finish();

ROLLBACK;
