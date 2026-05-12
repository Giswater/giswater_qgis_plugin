
/*
This SQL script is auto-generated to test the function gw_fct_duplicate_dscenario in the QGIS plugin.
It verifies various combinations of parameter values to check functionality.
*/

BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for multiple tests
SELECT plan(45);

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

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "CONDUIT",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type CONDUIT with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "CONDUIT",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type CONDUIT with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "CONDUIT",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type CONDUIT with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "JOINED",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type JOINED with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "JOINED",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type JOINED with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "JOINED",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type JOINED with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "JUNCTION",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type JUNCTION with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "JUNCTION",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type JUNCTION with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "JUNCTION",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type JUNCTION with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OTHER",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OTHER with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OTHER",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OTHER with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OTHER",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OTHER with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "RAINGAGE",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type RAINGAGE with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "RAINGAGE",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type RAINGAGE with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "RAINGAGE",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type RAINGAGE with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OUTFALL",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OUTFALL with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OUTFALL",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OUTFALL with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OUTFALL",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OUTFALL with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "STORAGE",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type STORAGE with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "STORAGE",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type STORAGE with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "STORAGE",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type STORAGE with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "WEIR",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type WEIR with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "WEIR",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type WEIR with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "WEIR",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type WEIR with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "PUMP",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type PUMP with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "PUMP",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type PUMP with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "PUMP",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type PUMP with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "ORIFICE",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type ORIFICE with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "ORIFICE",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type ORIFICE with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "ORIFICE",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type ORIFICE with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OUTLET",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OUTLET with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OUTLET",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OUTLET with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "OUTLET",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type OUTLET with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "INFLOWS",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type INFLOWS with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "INFLOWS",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type INFLOWS with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "INFLOWS",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type INFLOWS with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "TREATMENT",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type TREATMENT with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "TREATMENT",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type TREATMENT with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "TREATMENT",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type TREATMENT with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "CONTROLS",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type CONTROLS with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "CONTROLS",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type CONTROLS with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "CONTROLS",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type CONTROLS with exploitation 2'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "NETWORK",
                "active": "true",
                "expl": "0"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type NETWORK with exploitation 0'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "NETWORK",
                "active": "true",
                "expl": "1"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type NETWORK with exploitation 1'
);

SELECT is (
    (gw_fct_duplicate_dscenario($$
    {
        "client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
                "copyFrom": "1",
                "name": "test",
                "descript": null,
                "parent": null,
                "type": "NETWORK",
                "active": "true",
                "expl": "2"
            },
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if the function gw_fct_duplicate_dscenario works correctly for type NETWORK with exploitation 2'
);

-- Finish the test script
ROLLBACK;
