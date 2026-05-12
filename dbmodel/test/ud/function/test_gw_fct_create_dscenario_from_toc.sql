
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

-- Plan for multiple tests
SELECT plan(630);

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
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_arc", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_arc and featureType > ARC and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Conduit", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Conduit and featureType > ARC and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Orifice", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Orifice and featureType > ARC and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outlet", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outlet and featureType > ARC and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Pump", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Pump and featureType > ARC and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Virtual", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Virtual and featureType > ARC and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Weir", "featureType": "ARC", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Weir and featureType > ARC and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_node", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_node and featureType > NODE and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Junction", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Junction and featureType > NODE and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Netgully", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Netgully and featureType > NODE and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Outfall", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Outfall and featureType > NODE and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Storage", "featureType": "NODE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Storage and featureType > NODE and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Raingage", "featureType": "RAINGAGE", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Raingage and featureType > RAINGAGE and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > CONDUIT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > CONDUIT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONDUIT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > CONDUIT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > JOINED and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > JOINED and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JOINED", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > JOINED and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > JUNCTION and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > JUNCTION and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "JUNCTION", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > JUNCTION and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > OTHER and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > OTHER and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OTHER", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > OTHER and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > RAINGAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > RAINGAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "RAINGAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > RAINGAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > OUTFALL and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > OUTFALL and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "OUTFALL", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > OUTFALL and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > STORAGE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > STORAGE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "STORAGE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > STORAGE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRWEIR and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRWEIR and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRWEIR", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRWEIR and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRPUMP and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRPUMP and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRPUMP", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRPUMP and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRORIFICE and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRORIFICE and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FRORIFICE", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FRORIFICE and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FROUTLET and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FROUTLET and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "FROUTLET", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > FROUTLET and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > INFLOWS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > INFLOWS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "INFLOWS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > INFLOWS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > TREATMENT and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > TREATMENT and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "TREATMENT", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > TREATMENT and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > CONTROLS and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > CONTROLS and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "CONTROLS", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > CONTROLS and exploitation > 2 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 0,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > NETWORK and exploitation > 0 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 1,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > NETWORK and exploitation > 1 returns status "Accepted"'
);
    
SELECT is (
    (gw_fct_create_dscenario_from_toc($$
    {
        "client": {"device": 4, "lang": "nl_NL", "infoType": 1, "epsg": 25831},
        "form": {},
        "feature": {"tableName": "ve_Inp_Subcatchment", "featureType": "SUBCATCHMENT", "id": []},
        "data": {
            "filterFields": {}, 
            "pageInfo": {}, 
            "selectionMode": "wholeSelection",
            "parameters": {
                "name": "null",
                "type": "NETWORK", 
                "exploitation": 2,
                "descript": "null"
            }, 
            "aux_params": null
        }
    }
    $$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_toc with tablename > ve_Inp_Subcatchment and featureType > SUBCATCHMENT and type > NETWORK and exploitation > 2 returns status "Accepted"'
);
    
-- Finish the test
SELECT finish();

ROLLBACK;
