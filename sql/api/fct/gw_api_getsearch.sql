/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2600

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getsearch(p_data json)
  RETURNS json AS
$BODY$

-- TODO: Implementar el threshold per a tots els widgets igual que està en la 3.1

/*EXAMPLE
SELECT SCHEMA_NAME.gw_api_getsearch($${
"client":{"device":3, "infoType":100, "lang":"ES"}
}$$)
*/

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
    v_form text;
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
    v_character_number json;

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
        
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''api_search_character_number'') row'
        INTO v_character_number;

-- Create tabs array
    v_form := '[';

-- Network Tab
-------------------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='search' AND formtab='tab_network' ;

    IF rec_tab.id IS NOT NULL THEN

        -- Init combo json
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='net_type';

        comboType := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id, 'widgetname', concat('network_',rec_fields.column_id),'widgettype','combo','datatype','string','placeholder','','disabled',false);
        
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
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='net_code';
        editCode := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id, 'widgetname', concat('network_',rec_fields.column_id),'widgettype','typeahead','datatype',
        'string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
        
        -- Create array with network fields
        fieldsJson := '[' || comboType || ',' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');
        
        -- Create network tab form
        IF v_firsttab THEN
	    formNetwork := json_build_object('tabName','network','tabHeaderText',rec_tab.headertext, 'active' , v_active);
        ELSE
            formNetwork := json_build_object('tabName','network','tabHeaderText',rec_tab.headertext, 'active' , true);
        formNetwork := gw_fct_json_object_set_key(formNetwork, 'fields', fieldsJson);
	END IF;
        -- Create tabs array
        v_form := v_form || formNetwork::text;

        v_firsttab := TRUE;
        v_active :=FALSE;

    END IF;

-- Search tab
-------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='search' AND formtab='tab_search' ;
    IF rec_tab.id IS NOT NULL THEN
    
        -- Create search field
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='generic_search';
        editCode := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('network_',rec_fields.column_id),'widgettype','typeahead', 'searchService', 
        (SELECT value FROM config_param_system WHERE parameter='api_search_service' LIMIT 1),'datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
        
        fieldsJson := '[' ||  editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');

        -- Create search tab form
	
        IF v_firsttab THEN 
            formSearch := json_build_object('tabName','search','tabHeaderText',rec_tab.headertext, 'active', v_active );
            formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);
            v_form := v_form || ',' || formSearch::text;
        ELSE 
            formSearch := json_build_object('tabName','search','tabHeaderText',rec_tab.headertext, 'active', true );
            formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);
            v_form := v_form || formSearch::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;

    END IF;


-- Address tab
-------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='search' AND formtab='tab_address' ;
    IF rec_tab.id IS NOT NULL THEN

        -- Parameters of the municipality layer
        SELECT ((value::json)->>'sys_table_id') INTO v_search_muni_table FROM config_param_system WHERE parameter='api_search_muni';
        SELECT ((value::json)->>'sys_id_field') INTO v_search_muni_id_field FROM config_param_system WHERE parameter='api_search_muni';
        SELECT ((value::json)->>'sys_search_field') INTO v_search_muni_search_field FROM config_param_system WHERE parameter='api_search_muni';
        SELECT ((value::json)->>'sys_geom_field') INTO v_search_muni_geom_field FROM config_param_system WHERE parameter='api_search_muni';
        
        -- Get municipality vdefault
        SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='search_municipality_vdefault' AND cur_user=current_user;
        
        -- Init combo json
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='add_muni';
        comboType := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('address_',rec_fields.column_id),'widgettype','combo','datatype','string','placeholder','','disabled',false);

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
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='add_street';
        editCode1 := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('address_',rec_fields.column_id),'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
                

        -- Create postnumber search field
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='add_postnumber';
        editCode2 := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('address_',rec_fields.column_id),'widgettype','typeahead','threshold', 
        (SELECT value::integer FROM config_param_system WHERE parameter='api_search_minimsearch' LIMIT 1),
        'datatype','integer','placeholder','','disabled',true,'noresultsMsg','No results','loadingMsg','Searching...');

    
        -- Create array with network fields
        fieldsJson := '[' || comboType || ',' || editCode1 || ',' || editCode2 || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');
        
        -- Create tabs array
        IF v_firsttab THEN 
            formAddress := json_build_object('tabName','address','tabHeaderText',rec_tab.headertext, 'active', v_active );
            formAddress := gw_fct_json_object_set_key(formAddress, 'fields', fieldsJson);

            v_form := v_form || ',' || formAddress::text;
        ELSE 
            formAddress := json_build_object('tabName','address','tabHeaderText',rec_tab.headertext, 'active', true );
            formAddress := gw_fct_json_object_set_key(formAddress, 'fields', fieldsJson);

            v_form := v_form || formAddress::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;

    END IF;


-- Hydro tab
------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='search' AND formtab='tab_hydro' ;
    IF rec_tab.id IS NOT NULL THEN

        -- Init combo json
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='hydro_expl';
        comboType := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('hydro_',rec_fields.column_id),'widgettype','combo','datatype','string','placeholder','','disabled',false);

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
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='hydro_search';
        editCode := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('hydro_',rec_fields.column_id),'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
    
        -- Create array with hydro fields
        fieldsJson := '[' || comboType || ',' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');
        
        -- Create tabs array
        IF v_firsttab THEN 
            formHydro := json_build_object('tabName','hydro','tabHeaderText',rec_tab.headertext, 'active', v_active );
            formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);
            v_form := v_form || ',' || formHydro::text;
        ELSE 
            formHydro := json_build_object('tabName','hydro','tabHeaderText',rec_tab.headertext, 'active', true );
            formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);
            v_form := v_form || formHydro::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;

    END IF;
    

-- Workcat tab
--------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='search' AND formtab='tab_workcat' ;
    IF rec_tab.id IS NOT NULL THEN

        -- Add edit box to introduce search text
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='workcat_search';
        editCode := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('workcat_',rec_fields.column_id),'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

        -- Create array with workcat fields
        fieldsJson := '[' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');    

        -- Create tabs array
        IF v_firsttab THEN 
            formWorkcat := json_build_object('tabName','workcat','tabHeaderText',rec_tab.headertext, 'active', v_active );
            formWorkcat := gw_fct_json_object_set_key(formWorkcat, 'fields', fieldsJson);
            v_form := v_form || ',' || formWorkcat::text;
        ELSE 
            formWorkcat := json_build_object('tabName','workcat','tabHeaderText',rec_tab.headertext, 'active', true );
            formWorkcat := gw_fct_json_object_set_key(formWorkcat, 'fields', fieldsJson);
            v_form := v_form || formWorkcat::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;  
          
    END IF;
       


-- Psector tab
--------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='search' AND formtab='tab_psector' ;
    IF rec_tab.id IS NOT NULL THEN

        -- Init combo json
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='psector_expl';
        comboType := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('psector_',rec_fields.column_id),'widgettype','combo','datatype','string','placeholder','','disabled',false);

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
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='psector_search';
        editCode := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('psector_',rec_fields.column_id),'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
    
        -- Create array with hydro fields
        fieldsJson := '[' || comboType || ',' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');
   
        -- Create tabs array
        IF v_firsttab THEN 
            formPsector := json_build_object('tabName','psector','tabHeaderText',rec_tab.headertext, 'active', v_active );
            formPsector := gw_fct_json_object_set_key(formPsector, 'fields', fieldsJson);
            v_form := v_form || ',' || formPsector::text;
        ELSE 
            formPsector := json_build_object('tabName','psector','tabHeaderText',rec_tab.headertext, 'active', true );
            formPsector := gw_fct_json_object_set_key(formPsector, 'fields', fieldsJson);
            v_form := v_form || formPsector::text;
        END IF;

    END IF;


-- Visit tab
--------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='search' AND formtab='tab_visit' ;
    IF rec_tab.id IS NOT NULL THEN

        -- Add edit box to introduce search text
        SELECT * INTO rec_fields FROM config_api_form_fields WHERE formname='search' AND column_id='visit_search';
        editCode := json_build_object('label',rec_fields.label,'column_id', rec_fields.column_id,'widgetname', concat('visit_',rec_fields.column_id),'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

        -- Create array with workcat fields
        fieldsJson := '[' || editCode || ']';
        fieldsJson := COALESCE(fieldsJson, '[]');


        -- Create tabs array
        IF v_firsttab THEN 
            formVisit := json_build_object('tabName','visit','tabHeaderText','Visita', 'active', v_active );
            formVisit := gw_fct_json_object_set_key(formVisit, 'fields', fieldsJson);
            v_form := v_form || ',' || formVisit::text;
        ELSE 
            formVisit := json_build_object('tabName','visit','tabHeaderText','Visita', 'active', true );
            formVisit := gw_fct_json_object_set_key(formVisit, 'fields', fieldsJson);
            v_form := v_form || formVisit::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;    

    END IF;

--    Finish the construction of v_form
    v_form := v_form ||']';

--    Check null
    v_form := COALESCE(v_form, '[]');
    v_character_number := COALESCE(v_character_number, '[]');    

--     Return
    IF v_firsttab IS FALSE THEN
        -- Return not implemented
        RETURN ('{"status":"Accepted"' || ', "apiVersion":'|| api_version || ', "enabled":false'|| '}')::json;
    ELSE 
        -- Return 
        RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||', "enabled":true'||
		',"form":' || v_form ||
            '}')::json;
    END IF;


--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
