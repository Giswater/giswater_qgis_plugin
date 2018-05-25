CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getsearch"(device int4, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    formNetwork json;
    formHydro json;
    formWorkCat json;    
    editCode json;
    comboType json;
    formTabs json;
    combo_json json;
    fieldsJson json;
    formSearch json;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


-------------------------
--------NETWORK TAB
-------------------------

--    Init combo json
    comboType := json_build_object('label','Type','name','type','type','combo','dataType','string','placeholder','','diabled',false);
    
--    Get Ids for type combo
    EXECUTE 'SELECT array_to_json(array_agg(value)) FROM (SELECT value FROM config_param_system WHERE context = ''searchplus'' 
                                    AND split_part(parameter, ''_'', 1) = ''network'' 
                                    AND split_part(parameter, ''_'', 2) = ''layer'' 
                                    ORDER BY parameter) a'
        INTO combo_json; 

--    Add to json
    comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);

--    Add default
    IF combo_json IS NOT NULL THEN
        comboType := gw_fct_json_object_set_key(comboType, 'selectedId', combo_json->0);
    ELSE
        comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
    END IF;

--    Get Names for thecombo
    EXECUTE 'SELECT array_to_json(array_agg(split_part)) FROM (SELECT split_part(parameter, ''_'', 3) FROM config_param_system WHERE context = ''searchplus'' 
                                    AND split_part(parameter, ''_'', 1) = ''network'' 
                                    AND split_part(parameter, ''_'', 2) = ''layer'' 
                                    ORDER BY parameter) a'
        INTO combo_json; 
    
--    Add to json
    comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);


--    Add edit box to introduce search text
    editCode := json_build_object('label','Code','name','code','type','typeahead','dataType','string','placeholder','','diabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

--    Create array with network fields
    fieldsJson := '[' || comboType || ',' || editCode || ']';
    fieldsJson := COALESCE(fieldsJson, '[]');

--    Create network tab form
    formNetwork := json_build_object('tabName','network','tabLabel','Network','active',true);
    formNetwork := gw_fct_json_object_set_key(formNetwork, 'fields', fieldsJson);


-------------------------
--------SEARCH TAB
-------------------------

--    Create search field
    editCode := json_build_object('label','Address','name','address','type','typeahead','dataType','string','placeholder','','diabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
    
    fieldsJson := '[' ||  editCode || ']';
    fieldsJson := COALESCE(fieldsJson, '[]');

--    Create search tab form
    formSearch := json_build_object('tabName','search','tabLabel','Search');
    formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);


-------------------------
--------HYDRO TAB             !!!!!!!!!!!FALTA IF PROJECT 'ws'
-------------------------

--    Init combo json
    comboType := json_build_object('label','Exploitation','name','exploitation','type','combo','dataType','string','placeholder','','diabled',false);
    
--    Get Ids for type combo
    EXECUTE 'SELECT array_to_json(array_agg(expl_id)) FROM (SELECT expl_id FROM exploitation ORDER BY name) a'
        INTO combo_json; 

--    Add to json
    comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);

--    Add default
    IF combo_json IS NOT NULL THEN
        comboType := gw_fct_json_object_set_key(comboType, 'selectedId', combo_json->0);
    ELSE
        comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
    END IF;

--    Get Names for thecombo
    EXECUTE 'SELECT array_to_json(array_agg(name)) FROM (SELECT name FROM exploitation ORDER BY name) a'
        INTO combo_json;
    
--    Add to json
    comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);


--    Add edit box to introduce search text
    editCode := json_build_object('label','Hydrometer','name','hydrometer','type','typeahead','dataType','string','placeholder','','diabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

--    Create array with hydro fields
    fieldsJson := '[' || comboType || ',' || editCode || ']';
    fieldsJson := COALESCE(fieldsJson, '[]');

--    Create hydro tab form
    formHydro := json_build_object('tabName','hydro','tabLabel','Hydro');
    formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);


-------------------------
--------WORKCAT TAB             !!!!!!!!!!!FALTA IF PROJECT 'ws'
-------------------------

--    Init combo json
    comboType := json_build_object('label','WorkCat','name','workcat','type','combo','dataType','string','placeholder','','diabled',false);
    
--    Get Ids for type combo
    EXECUTE 'SELECT array_to_json(array_agg(workcat_id)) FROM (SELECT DISTINCT(workcat_id) FROM arc WHERE workcat_id LIKE ''%%''
                        UNION
                        SELECT DISTINCT(workcat_id) FROM connec WHERE workcat_id LIKE ''%%''
                        UNION
                        SELECT DISTINCT(workcat_id) FROM node WHERE workcat_id LIKE ''%%'') a'
        INTO combo_json; 

--    Add to json
    comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);

--    Add default
    IF combo_json IS NOT NULL THEN
        comboType := gw_fct_json_object_set_key(comboType, 'selectedId', combo_json->0);
    ELSE
        comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
    END IF;

--    Get same Id and Names for the combo
    comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);


--    Add edit box to introduce search text
    editCode := json_build_object('label','Code','name','code','type','typeahead','dataType','string','placeholder','','diabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

--    Create array with workcat fields
    fieldsJson := '[' || comboType || ',' || editCode || ']';
    fieldsJson := COALESCE(fieldsJson, '[]');

--    Create workcat tab form
    formWorkCat := json_build_object('tabName','workcat','tabLabel','WorkCat');
    formWorkCat := gw_fct_json_object_set_key(formWorkCat, 'fields', fieldsJson);


-------------------------
--------JOIN TABS
-------------------------

--    Create tabs array
    formTabs := '[' || formNetwork || ',' || formSearch || ',' || formHydro || ',' || formWorkCat || ']';

--    Check null
    formTabs := COALESCE(formTabs, '[]');    


--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "formTabs":' || formTabs ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

