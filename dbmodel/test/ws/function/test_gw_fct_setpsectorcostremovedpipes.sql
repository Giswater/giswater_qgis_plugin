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

SELECT plan(18);

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
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"0", "material":"N/I", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 0 and material N/I returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"0", "material":"PVC", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 0 and material PVC returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"0", "material":"FD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 0 and material FD returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"0", "material":"FC", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 0 and material FC returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"0", "material":"PE-HD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 0 and material PE-HD returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"0", "material":"PE-LD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 0 and material PE-LD returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"1", "material":"N/I", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 1 and material N/I returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"1", "material":"PVC", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 1 and material PVC returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"1", "material":"FD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 1 and material FD returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"1", "material":"FC", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 1 and material FC returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"1", "material":"PE-HD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 1 and material PE-HD returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"1", "material":"PE-LD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 1 and material PE-LD returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"2", "material":"N/I", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 2 and material N/I returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"2", "material":"PVC", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 2 and material PVC returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"2", "material":"FD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 2 and material FD returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"2", "material":"FC", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 2 and material FC returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"2", "material":"PE-HD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 2 and material PE-HD returns status "Accepted"'
);


SELECT is(
    (gw_fct_setpsectorcostremovedpipes($${
        "client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
        "form":{},
        "feature":{},
        "data":{"filterFields":{}, "pageInfo":{},
        "parameters":{"expl":"2", "material":"PE-LD", "price":"S_REP", "observ":"observ"},
        "aux_params":null}
    }$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setpsectorcostremovedpipes with expl 2 and material PE-LD returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
