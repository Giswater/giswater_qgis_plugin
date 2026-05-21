
/*
This SQL script is automatically generated for testing functions in the QGIS plugin.
It checks various combinations of parameter values to verify functionality.
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for multiple test
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
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type CONDUIT with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type CONDUIT with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type CONDUIT with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type JOINED with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type JOINED with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type JOINED with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type JUNCTION with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type JUNCTION with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type JUNCTION with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OTHER with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OTHER with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OTHER with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type RAINGAGE with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type RAINGAGE with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type RAINGAGE with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OUTFALL with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OUTFALL with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OUTFALL with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type STORAGE with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type STORAGE with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type STORAGE with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type WEIR with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type WEIR with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type WEIR with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type PUMP with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type PUMP with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type PUMP with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type ORIFICE with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type ORIFICE with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type ORIFICE with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OUTLET with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OUTLET with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type OUTLET with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type INFLOWS with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type INFLOWS with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type INFLOWS with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type TREATMENT with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type TREATMENT with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type TREATMENT with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type CONTROLS with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type CONTROLS with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type CONTROLS with expl 2'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type NETWORK with expl 0'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type NETWORK with expl 1'
);

SELECT is (
    (gw_fct_create_dscenario_empty($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "parameters": {
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
    'check if the function gw_fct_create_dscenario_empty works correctly for type NETWORK with expl 2'
);

-- Finish the test
SELECT finish();

-- End the test script
ROLLBACK;
