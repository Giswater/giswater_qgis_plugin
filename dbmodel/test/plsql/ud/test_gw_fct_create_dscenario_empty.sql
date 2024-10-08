
    /*
    Dit SQL-script is automatisch gegenereerd voor het testen van functies in de QGIS-plugin.
    Het controleert verschillende combinaties van parameterwaarden om functionaliteit te verifi�ren.
    */
    BEGIN;

    -- Onderdrukken van NOTICE berichten
    SET client_min_messages TO WARNING;

    SET search_path = "SCHEMA_NAME", public, pg_catalog;

    -- Plan voor meerdere tests
    SELECT plan(45);

    -- Start met testen
    
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type CONDUIT met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type CONDUIT met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type CONDUIT met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type JOINED met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type JOINED met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type JOINED met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type JUNCTION met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type JUNCTION met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type JUNCTION met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OTHER met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OTHER met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OTHER met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type RAINGAGE met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type RAINGAGE met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type RAINGAGE met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OUTFALL met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OUTFALL met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OUTFALL met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type STORAGE met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type STORAGE met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type STORAGE met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type WEIR met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type WEIR met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type WEIR met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type PUMP met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type PUMP met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type PUMP met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type ORIFICE met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type ORIFICE met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type ORIFICE met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OUTLET met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OUTLET met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type OUTLET met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type INFLOWS met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type INFLOWS met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type INFLOWS met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type TREATMENT met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type TREATMENT met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type TREATMENT met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type CONTROLS met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type CONTROLS met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type CONTROLS met exploitatie 2'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type NETWORK met exploitatie 0'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type NETWORK met exploitatie 1'
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
        'Controle of de functie gw_fct_create_dscenario_empty correct werkt voor type NETWORK met exploitatie 2'
    );
    
    -- Be�indig het testscript
    ROLLBACK;
    