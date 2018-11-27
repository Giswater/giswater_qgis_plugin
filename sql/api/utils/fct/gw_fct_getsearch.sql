/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getsearch"(device int4, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    formNetwork json;
    formHydro json;
    formWorkcat json;    
    editCode json;
    editCode1 json;
    editCode2 json;
    comboType json;
    comboType1 json;
    comboType2 json;
    comboType3 json;
    formTabs text;
    combo_json json;
    fieldsJson json;
    formSearch json;
    formPsector json;
    api_version json;
    formAddress json;
    formVisit json;
    rec_tab record;
    v_firsttab boolean := FALSE;
    v_active boolean;
    rec_fields record;
    threshold integer;
    threshold_postnumber integer;

    --Address
    v_search_vdef text;
    v_search_muni_table text;
    v_search_muni_id_field text;
    v_search_muni_search_field text;
    v_search_muni_geom_field text;
    


BEGIN


-- Set search path to local schema
   SET search_path = "SCHEMA_NAME", public;

--  get api values
   EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

-- get numbers of character to search (to all searcher box in exception postnumber)
   EXECUTE 'SELECT value::integer FROM config_param_system WHERE parameter=''api_search_character_number'' LIMIT 1'
        INTO threshold;

-- get numbers of character to search on postnumber
    EXECUTE 'SELECT value::integer FROM config_param_system WHERE parameter=''api_search_minimsearch'' LIMIT 1'
        INTO threshold_postnumber;

-- Create tabs array
    formTabs := '[';

-- Network Tab
-------------------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F31' AND formtab='tabNetwork' ;
    IF rec_tab IS NOT NULL THEN

        -- Init combo json
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='net_type';
        comboType := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','combo','dataType','string','placeholder','','disabled',false);
        
        -- Get Ids for type combo
        SELECT array_to_json(array_agg(id)) INTO combo_json FROM (SELECT ((value)::json->'sys_table_id') AS id FROM config_param_system WHERE context='api_search_network' ORDER BY ((value)::json->>'orderby'))a;
        comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);

        -- Add default
        IF combo_json IS NOT NULL THEN
            comboType := gw_fct_json_object_set_key(comboType, 'selectedId', 0);
        ELSE
            comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
        END IF;
    
        -- Get Names for type combo
        SELECT array_to_json(array_agg(id))  INTO combo_json FROM (SELECT ((value)::json->'alias') AS id FROM config_param_system WHERE context='api_search_network' ORDER BY ((value)::json->>'orderby'))a;    
        comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);

        -- Add edit box to introduce search text
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='net_code';
        editCode := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','typeahead','dataType','string',
        'threshold', threshold, 'placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
        
        -- Create array with network fields
        fieldsJson := '[' || comboType || ',' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');
        
        -- Create network tab form
        IF v_firsttab THEN
        formNetwork := json_build_object('tabName','network','tabLabel',rec_tab.tablabel, 'active' , v_active);
        ELSE
            formNetwork := json_build_object('tabName','network','tabLabel',rec_tab.tablabel, 'active' , true);
        formNetwork := gw_fct_json_object_set_key(formNetwork, 'fields', fieldsJson);
    END IF;
        -- Create tabs array
        formTabs := formTabs || formNetwork::text;

        v_firsttab := TRUE;
        v_active :=FALSE;


    END IF;


-- Search tab
-------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F31' AND formtab='tabSearch' ;
    IF rec_tab IS NOT NULL THEN
    
        -- Create search field
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='generic_search';
        editCode := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','typeahead', 'searchService', 'dataType','string',
        'threshold', threshold, 'placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
        
        fieldsJson := '[' ||  editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');

        -- Create search tab form
    
        IF v_firsttab THEN 
            formSearch := json_build_object('tabName','search','tabLabel',rec_tab.tablabel, 'active', v_active );
            formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);
            formTabs := formTabs || ',' || formSearch::text;
        ELSE 
            formSearch := json_build_object('tabName','search','tabLabel',rec_tab.tablabel, 'active', true );
            formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);
            formTabs := formTabs || formSearch::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;

    END IF;


-- Address tab
-------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F31' AND formtab='tabAddress' ;
    IF rec_tab IS NOT NULL THEN

        -- Parameters of the municipality layer
        SELECT ((value::json)->>'sys_table_id') INTO v_search_muni_table FROM config_param_system WHERE parameter='api_search_muni';
        SELECT ((value::json)->>'sys_id_field') INTO v_search_muni_id_field FROM config_param_system WHERE parameter='api_search_muni';
        SELECT ((value::json)->>'sys_search_field') INTO v_search_muni_search_field FROM config_param_system WHERE parameter='api_search_muni';
        SELECT ((value::json)->>'sys_geom_field') INTO v_search_muni_geom_field FROM config_param_system WHERE parameter='api_search_muni';
        
        -- Get municipality vdefault
        SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='search_municipality_vdefault' AND cur_user=current_user;
        
        -- Init combo json
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='add_muni';
        comboType := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','combo','dataType','string','placeholder','','disabled',false);

        -- Get Ids for type combo
        EXECUTE 'SELECT array_to_json(array_agg(id)) FROM (SELECT '||v_search_muni_id_field||' AS id FROM '||v_search_muni_table ||' ORDER BY '||v_search_muni_search_field||') a' INTO combo_json;
        comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);

        -- Add default
        IF combo_json IS NOT NULL THEN
            comboType := gw_fct_json_object_set_key(comboType, 'selectedId', v_search_vdef);
        ELSE
            comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
        END IF;

        -- Get name for type combo
        EXECUTE 'SELECT array_to_json(array_agg(idval)) FROM (SELECT '||v_search_muni_search_field||' AS idval FROM '||v_search_muni_table ||' ORDER BY '||v_search_muni_search_field||') a' INTO combo_json;
        comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);


        -- Get geom for combo
        EXECUTE 'SELECT array_to_json(array_agg(st_astext(st_envelope(geom)))) FROM (SELECT '||v_search_muni_geom_field||' AS geom FROM '||v_search_muni_table ||' ORDER BY '||v_search_muni_search_field||') a' INTO combo_json;
        comboType := gw_fct_json_object_set_key(comboType, 'comboGeometry', combo_json);


        -- Create street search field
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='add_street';
        editCode1 := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','typeahead','dataType', 'string',
        'threshold', threshold, 'placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
                

        -- Create postnumber search field
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='add_postnumber';
        editCode2 := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','typeahead','dataType','string',
        'threshold', threshold_postnumber, 'placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

    
        -- Create array with network fields
        fieldsJson := '[' || comboType || ',' || editCode1 || ',' || editCode2 || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');
        
        -- Create tabs array
        IF v_firsttab THEN 
            formAddress := json_build_object('tabName','address','tabLabel',rec_tab.tablabel, 'active', v_active );
            formAddress := gw_fct_json_object_set_key(formAddress, 'fields', fieldsJson);

            formTabs := formTabs || ',' || formAddress::text;
        ELSE 
            formAddress := json_build_object('tabName','address','tabLabel',rec_tab.tablabel, 'active', true );
            formAddress := gw_fct_json_object_set_key(formAddress, 'fields', fieldsJson);

            formTabs := formTabs || formAddress::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;

    END IF;


-- Hydro tab
------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F31' AND formtab='tabHydro' ;
    IF rec_tab IS NOT NULL THEN

        -- Init combo json
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='hydro_expl';
        comboType := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','combo','dataType','string','placeholder','','disabled',false);

        -- Get exploitation vdefault
        SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='search_exploitation_vdefault' AND cur_user=current_user 
        AND value::integer IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user);
        IF v_search_vdef IS NULL THEN v_search_vdef=(SELECT expl_id FROM selector_expl WHERE cur_user=current_user LIMIT 1); END IF;
        
        -- Get exploitation id's for type combo
        EXECUTE 'SELECT array_to_json(array_agg(expl_id)) FROM (SELECT expl_id FROM exploitation WHERE expl_id 
            IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ORDER BY name) a'
            INTO combo_json; 

        -- Add to json
        comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);
        
        -- Add vdefault
        IF combo_json IS NOT NULL THEN
            comboType := gw_fct_json_object_set_key(comboType, 'selectedId', v_search_vdef);
        ELSE
            comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
        END IF;
        
        -- Get Names for the combo
        EXECUTE 'SELECT array_to_json(array_agg(name)) FROM (SELECT name FROM exploitation WHERE expl_id 
            IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ORDER BY name) a'
            INTO combo_json;
            
        -- Add to json
        comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);
    
    
        -- Add edit box to introduce search text
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='hydro_search';
        editCode := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','typeahead','dataType','string',
        'threshold', threshold, 'placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
    
        -- Create array with hydro fields
        fieldsJson := '[' || comboType || ',' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');
        
        -- Create tabs array
        IF v_firsttab THEN 
            formHydro := json_build_object('tabName','hydro','tabLabel',rec_tab.tablabel, 'active', v_active );
            formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);
            formTabs := formTabs || ',' || formHydro::text;
        ELSE 
            formHydro := json_build_object('tabName','hydro','tabLabel',rec_tab.tablabel, 'active', true );
            formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);
            formTabs := formTabs || formHydro::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;
                
    END IF;
    

-- Workcat tab
--------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F31' AND formtab='tabWorkcat' ;
    IF rec_tab IS NOT NULL THEN

        -- Add edit box to introduce search text
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='workcat_search';
        editCode := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','typeahead','dataType','string',
        'threshold', threshold, 'placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

        -- Create array with workcat fields
        fieldsJson := '[' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');    

        -- Create tabs array
        IF v_firsttab THEN 
            formWorkcat := json_build_object('tabName','workcat','tabLabel',rec_tab.tablabel, 'active', v_active );
            formWorkcat := gw_fct_json_object_set_key(formWorkcat, 'fields', fieldsJson);
            formTabs := formTabs || ',' || formWorkcat::text;
        ELSE 
            formWorkcat := json_build_object('tabName','workcat','tabLabel',rec_tab.tablabel, 'active', true );
            formWorkcat := gw_fct_json_object_set_key(formWorkcat, 'fields', fieldsJson);
            formTabs := formTabs || formWorkcat::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;    

    END IF;
       


-- Psector tab
--------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F31' AND formtab='tabPsector' ;
    IF rec_tab IS NOT NULL THEN

        -- Init combo json
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='psector_expl';
        comboType := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','combo','dataType','string','placeholder','','disabled',false);

        -- Get exploitation vdefault
        SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='search_exploitation_vdefault' AND cur_user=current_user 
        AND value::integer IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user);
        IF v_search_vdef IS NULL THEN v_search_vdef=(SELECT expl_id FROM selector_expl WHERE cur_user=current_user LIMIT 1); END IF;
            
        -- Get Ids for type combo
        EXECUTE 'SELECT array_to_json(array_agg(expl_id)) FROM (SELECT expl_id FROM exploitation WHERE expl_id 
            IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ORDER BY name) a'
            INTO combo_json; 
    
        -- Add to json
        comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);
    
        -- Add default
        IF combo_json IS NOT NULL THEN
            comboType := gw_fct_json_object_set_key(comboType, 'selectedId', v_search_vdef);
        ELSE
            comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
        END IF;
        
        -- Get Names for the combo
        EXECUTE 'SELECT array_to_json(array_agg(name)) FROM (SELECT name FROM exploitation WHERE expl_id 
            IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ORDER BY name) a'
            INTO combo_json;
            
        -- Add to json
        comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);
    
        -- Add edit box to introduce search text
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='psector_search';
        editCode := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','typeahead','dataType','string',
        'threshold', threshold, 'placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
    
        -- Create array with hydro fields
        fieldsJson := '[' || comboType || ',' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');
   
        -- Create tabs array
        IF v_firsttab THEN 
            formPsector := json_build_object('tabName','psector','tabLabel',rec_tab.tablabel, 'active', v_active );
            formPsector := gw_fct_json_object_set_key(formPsector, 'fields', fieldsJson);
            formTabs := formTabs || ',' || formPsector::text;
        ELSE 
            formPsector := json_build_object('tabName','psector','tabLabel',rec_tab.tablabel, 'active', true );
            formPsector := gw_fct_json_object_set_key(formPsector, 'fields', fieldsJson);
            formTabs := formTabs || formPsector::text;
        END IF;

    END IF;


-- Visit tab
--------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F31' AND formtab='tabVisit' ;
    IF rec_tab IS NOT NULL THEN

        -- Add edit box to introduce search text
        SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F31' AND name='visit_search';
        editCode := json_build_object('label',rec_fields.label,'name', rec_fields.name,'type','typeahead','dataType','string',
        'threshold', threshold, 'placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

        -- Create array with workcat fields
        fieldsJson := '[' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');


        -- Create tabs array
        IF v_firsttab THEN 
            formVisit := json_build_object('tabName','visit','tabLabel','Visita', 'active', v_active );
            formVisit := gw_fct_json_object_set_key(formVisit, 'fields', fieldsJson);
            formTabs := formTabs || ',' || formVisit::text;
        ELSE 
            formVisit := json_build_object('tabName','visit','tabLabel','Visita', 'active', true );
            formVisit := gw_fct_json_object_set_key(formVisit, 'fields', fieldsJson);
            formTabs := formTabs || formVisit::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;    

    END IF;



--    Finish the construction of formtabs
    formTabs := formtabs ||']';

--    Check null
    formTabs := COALESCE(formTabs, '[]');    

--     Return
    IF v_firsttab IS FALSE THEN
        -- Return not implemented
        RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "enabled":false'||
        '}')::json;
    ELSE 
        -- Return formtabs
        RETURN ('{"status":"Accepted"' ||
            ', "apiVersion":'|| api_version ||
            ', "enabled":true'||
            ', "formTabs":' || formTabs ||
            '}')::json;
    END IF;

--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

