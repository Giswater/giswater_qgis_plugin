/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2600

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getsearch(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getsearch(p_data json)
  RETURNS json AS
$BODY$

-- TODO: Implementar el threshold per a tots els widgets igual que està en la 3.1


/*EXAMPLE
SELECT gw_fct_getsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}}$$)
SELECT gw_fct_getsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"addSchema":"SCHEMA_NAME", "filterFields":{}, "pageInfo":{}}}$$);
SELECT gw_fct_getsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"singleTab":"tab_address"}, "feature":{}, "data":{"addSchema":"ud_sample", "filterFields":{}, "pageInfo":{}}}$$);

 SELECT gw_fct_getsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":"ud_sample"}}$$);

MAIN ISSUES
-----------
- basic_search_network is key issue to define variables on config_param_system to searh anything you want
- it is possible to get only one tab. values are: singleTab: (tab_network, tab_address, tab_search, tab_hydro, tab_workcat, tab_visit, tab_psector)
*/

DECLARE

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
v_version json;
formAddress json;
formVisit json;
rec_tab record;
v_firsttab boolean := FALSE;
v_active boolean;
rec_fields record;

--Address
v_search_vdef text;
v_search_muni_table text;
v_search_muni_id_field text;
v_search_muni_search_field text;
v_search_muni_geom_field text; 
v_addschema text;
v_singletab text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api values
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

        -- get values from input
        v_addschema = (p_data ->>'data')::json->>'addSchema';
        v_singletab = (p_data ->>'form')::json->>'singleTab';

	-- profilactic control for singletab
        IF v_singletab IN ('NULL', 'None', '') then v_singletab = null; end if;

        
	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null'
		THEN v_addschema = null; 
	ELSE
		IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3132", "function":"2580","debug_msg":null}}$$)';
			-- todo: send message to response
		END IF;
	END IF;
        
	-- Create tabs array
	v_form := '[';

	-- Network Tab
	-------------------------
	SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_network' ;
	IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_network' THEN

		-- Init combo json
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='net_type';

		comboType := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname, 'widgetname', concat('network_',rec_fields.columnname),
		'widgettype','combo','datatype','string','placeholder','','disabled',false);
		
		-- Get Ids for type combo
		SELECT array_to_json(array_agg(id)) INTO combo_json FROM (SELECT ((value)::json->'sys_table_id') AS id FROM config_param_system 
		WHERE parameter like '%basic_search_network%'ORDER BY ((value)::json->>'orderby'))a;
		comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);

		-- Add default
		IF combo_json IS NOT NULL THEN
			comboType := gw_fct_json_object_set_key(comboType, 'selectedId', 0);
		ELSE
			comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
		END IF;
	    
		-- Get Names for type combo
		SELECT array_to_json(array_agg(id)) INTO combo_json FROM (SELECT ((value)::json->'alias') AS id FROM config_param_system 
		WHERE parameter like '%basic_search_network%' ORDER BY ((value)::json->>'orderby'))a;    
		comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);

		-- Get feature type
		SELECT array_to_json(array_agg(id)) INTO combo_json FROM (SELECT ((value)::json->'search_type') AS id FROM config_param_system 
		WHERE parameter like '%basic_search_network%' ORDER BY ((value)::json->>'orderby'))a;    
		comboType := gw_fct_json_object_set_key(comboType, 'comboFeature', combo_json);

		-- Add edit box to introduce search text
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='net_code';
		editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname, 'widgetname', concat('network_',rec_fields.columnname),'widgettype','typeahead','datatype',
		'string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
		
		-- Create array with network fields
		fieldsJson := '[' || comboType || ',' || editCode || ']';
		fieldsJson := COALESCE(fieldsJson, '[]');
		
		-- Create network tab form
		IF v_firsttab THEN
			formNetwork := json_build_object('tabName','network', 'tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active' , v_active);
		ELSE
			formNetwork := json_build_object('tabName','network', 'tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active' , true);
			formNetwork := gw_fct_json_object_set_key(formNetwork, 'fields', fieldsJson);
		END IF;
		-- Create tabs array
		v_form := v_form || formNetwork::text;

		v_firsttab := TRUE;
		v_active :=FALSE;
	END IF;

	IF v_addschema IS NOT NULL AND v_singletab IS NULL THEN

		SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_add_network' ;

		-- Init combo json
		EXECUTE 'SELECT * FROM '||v_addschema||'.config_form_fields WHERE formname=''search'' AND columnname=''net_type'''
		INTO rec_fields;

		comboType := json_build_object('label',rec_fields.label, 'columnname', rec_fields.columnname, 'widgetname', concat('network_',rec_fields.columnname),
		'widgettype','combo','datatype','string','placeholder','','disabled',false);
		
		-- Get Ids for type combo
		EXECUTE 'SELECT array_to_json(array_agg(id)) FROM (SELECT ((value)::json->''sys_table_id'') AS id FROM '||v_addschema||'.config_param_system 
		WHERE parameter like ''%basic_search_network%'' ORDER BY ((value)::json->>''orderby'')) a'
		INTO combo_json;
		
		comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);

		-- Add default
		IF combo_json IS NOT NULL THEN
			comboType := gw_fct_json_object_set_key(comboType, 'selectedId', 0);
		ELSE
			comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));        
		END IF;

		-- Get Names for type combo
		EXECUTE 'SELECT array_to_json(array_agg(id)) FROM (SELECT ((value)::json->''alias'') AS id FROM '||v_addschema||'.config_param_system  
		WHERE parameter like ''%basic_search_network%'' ORDER BY ((value)::json->>''orderby''))a'
		INTO combo_json ;
		comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);
	
		-- Add edit box to introduce search text
		EXECUTE 'SELECT * FROM '||v_addschema||'.config_form_fields WHERE formname=''search'' AND columnname=''net_code'''
		INTO rec_fields ;
		editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname, 'widgetname', concat('add_network_',rec_fields.columnname),'widgettype','typeahead','datatype',
		'string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
		
		-- Create array with network fields
		fieldsJson := '[' || comboType || ',' || editCode || ']';
		fieldsJson := COALESCE(fieldsJson, '[]');
		
		-- Create network tab form
		IF v_firsttab THEN
			formNetwork := json_build_object('tabName','add_network','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active' , v_active);
			formNetwork := gw_fct_json_object_set_key(formNetwork, 'fields', fieldsJson);
			v_form := v_form || ',' || formNetwork::text;
		ELSE
			formNetwork := json_build_object('tabName','add_network','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active' , true);
			v_form := v_form || formNetwork::text;
		END IF;
		
		v_firsttab := TRUE;
		v_active :=FALSE;

		SET search_path = 'SCHEMA_NAME', public;

	END IF;

	-- Search tab
	-------------
	SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_search' ;
	IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_search' THEN
    
		-- Create search field
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='generic_search';
		editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('network_',rec_fields.columnname),'widgettype','typeahead', 'searchService', '...');

		fieldsJson := '[' ||  editCode || ']';
		fieldsJson := COALESCE(fieldsJson, '[]');

		-- Create search tab form

		IF v_firsttab THEN 
			formSearch := json_build_object('tabName','search','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
			formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);
			v_form := v_form || ',' || formSearch::text;
		ELSE 
			formSearch := json_build_object('tabName','search','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
			formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);
			v_form := v_form || formSearch::text;
		END IF;

		v_firsttab := TRUE;
		v_active :=FALSE;

	END IF;

	-- Address tab
	-------------
	SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_address' ;
	IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_address' THEN

		-- Parameters of the municipality layer
		SELECT ((value::json)->>'sys_table_id') INTO v_search_muni_table FROM config_param_system WHERE parameter='basic_search_muni';
		SELECT ((value::json)->>'sys_id_field') INTO v_search_muni_id_field FROM config_param_system WHERE parameter='basic_search_muni';
		SELECT ((value::json)->>'sys_search_field') INTO v_search_muni_search_field FROM config_param_system WHERE parameter='basic_search_muni';
		SELECT ((value::json)->>'sys_geom_field') INTO v_search_muni_geom_field FROM config_param_system WHERE parameter='basic_search_muni';
		
		-- Get municipality vdefault
		SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='basic_search_municipality_vdefault' AND cur_user=current_user;
		
		-- Init combo json
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='add_muni';
		comboType := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('address_',rec_fields.columnname),
		'widgettype','combo','datatype','string','placeholder','','disabled',false);


		-- Get Ids for type combo
		EXECUTE 'SELECT array_to_json(array_agg(id)) FROM (SELECT '||quote_ident(v_search_muni_id_field)||' AS id FROM '||quote_ident(v_search_muni_table) ||
		' WHERE active IS TRUE ORDER BY '||quote_ident(v_search_muni_search_field)||') a' INTO combo_json;
		
		comboType := gw_fct_json_object_set_key(comboType, 'comboIds', combo_json);

		-- Add default
		IF combo_json IS NOT NULL THEN
			comboType := gw_fct_json_object_set_key(comboType, 'selectedId', v_search_vdef);
		ELSE
			comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));
		END IF;

		-- Get name for type combo
		EXECUTE 'SELECT array_to_json(array_agg(idval)) FROM (SELECT '||quote_ident(v_search_muni_search_field)||' AS idval FROM '||quote_ident(v_search_muni_table) ||
		' WHERE active IS TRUE ORDER BY '||quote_ident(v_search_muni_search_field)||') a' INTO combo_json;
		comboType := gw_fct_json_object_set_key(comboType, 'comboNames', combo_json);

		-- Get geom for combo
		EXECUTE 'SELECT array_to_json(array_agg(st_astext(st_envelope(geom)))) FROM (SELECT '||quote_ident(v_search_muni_geom_field)||' AS geom FROM '||
		quote_ident(v_search_muni_table) ||' WHERE active IS TRUE ORDER BY '||quote_ident(v_search_muni_search_field)||') a' INTO combo_json;
		comboType := gw_fct_json_object_set_key(comboType, 'comboGeometry', combo_json);

		-- Create street search field
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='add_street';
		editCode1 := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('address_',rec_fields.columnname),
		'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

		-- Create postnumber search field
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='add_postnumber';
		editCode2 := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('address_',rec_fields.columnname),
		'widgettype','typeahead','threshold', 1, 'datatype','integer','placeholder','','disabled',true,'noresultsMsg','No results','loadingMsg','Searching...');

		-- Create array with network fields
		fieldsJson := '[' || comboType || ',' || editCode1 || ',' || editCode2 || ']';
		fieldsJson := COALESCE(fieldsJson, '[]');
		
		-- Create tabs array
		IF v_firsttab THEN 
			formAddress := json_build_object('tabName','address','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
			formAddress := gw_fct_json_object_set_key(formAddress, 'fields', fieldsJson);
			v_form := v_form || ',' || formAddress::text;
		ELSE 
			formAddress := json_build_object('tabName','address','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
			formAddress := gw_fct_json_object_set_key(formAddress, 'fields', fieldsJson);
			v_form := v_form || formAddress::text;
		END IF;

		v_firsttab := TRUE;
		v_active :=FALSE;

	END IF;

		RAISE NOTICE ' %', v_form;


	-- Hydro tab
	------------
	SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_hydro' ;
	IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_hydro' THEN

		-- Init combo json
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='hydro_expl';
		comboType := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('hydro_',rec_fields.columnname),
		'widgettype','combo','datatype','string','placeholder','','disabled',false);

		-- Get exploitation vdefault
		SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='basic_search_exploitation_vdefault' AND cur_user=current_user
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
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='hydro_search';
		editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('hydro_',rec_fields.columnname),
		'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
	
		-- Create array with hydro fields
		fieldsJson := '[' || comboType || ',' || editCode || ']';
		fieldsJson := COALESCE(fieldsJson, '[]');
		
		-- Create tabs array
		IF v_firsttab THEN 
			formHydro := json_build_object('tabName','hydro','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
			formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);
			v_form := v_form || ',' || formHydro::text;
		ELSE 
			formHydro := json_build_object('tabName','hydro','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
			formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);
			v_form := v_form || formHydro::text;
		END IF;

		v_firsttab := TRUE;
		v_active :=FALSE;

	END IF;

	-- Workcat tab
	--------------
	SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_workcat' ;
	IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_workcat' THEN

		-- Add edit box to introduce search text
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='workcat_search';
		editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('workcat_',rec_fields.columnname),
		'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

		-- Create array with workcat fields
		fieldsJson := '[' || editCode || ']';
		fieldsJson := COALESCE(fieldsJson, '[]');

		-- Create tabs array
		IF v_firsttab THEN 
			formWorkcat := json_build_object('tabName','workcat','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
			formWorkcat := gw_fct_json_object_set_key(formWorkcat, 'fields', fieldsJson);
			v_form := v_form || ',' || formWorkcat::text;
		ELSE 
			formWorkcat := json_build_object('tabName','workcat','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
			formWorkcat := gw_fct_json_object_set_key(formWorkcat, 'fields', fieldsJson);
			v_form := v_form || formWorkcat::text;
		END IF;

		v_firsttab := TRUE;
		v_active :=FALSE;  
		  
	END IF;

	
	-- Psector tab
	--------------
	SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_psector' ;
	IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_psector' THEN

		-- Init combo json
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='psector_expl';
		comboType := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('psector_',rec_fields.columnname),
		'widgettype','combo','datatype','string','placeholder','','disabled',false);

		-- Get exploitation vdefault
		SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='basic_search_exploitation_vdefault' AND cur_user=current_user
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
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='psector_search';
		editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('psector_',rec_fields.columnname),
		'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
	
		-- Create array with hydro fields
		fieldsJson := '[' || comboType || ',' || editCode || ']';
		fieldsJson := COALESCE(fieldsJson, '[]');
	   
		-- Create tabs array
		IF v_firsttab THEN 
			formPsector := json_build_object('tabName','psector','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
			formPsector := gw_fct_json_object_set_key(formPsector, 'fields', fieldsJson);
			v_form := v_form || ',' || formPsector::text;
		ELSE 
			formPsector := json_build_object('tabName','psector','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
			formPsector := gw_fct_json_object_set_key(formPsector, 'fields', fieldsJson);
			v_form := v_form || formPsector::text;
		END IF;
	END IF;

	-- Visit tab
	--------------
	SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_visit' ;
	IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_visit' THEN

		-- Add edit box to introduce search text
		SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='visit_search';
		editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('visit_',rec_fields.columnname),
		'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

		-- Create array with workcat fields
		fieldsJson := '[' || editCode || ']';
		fieldsJson := COALESCE(fieldsJson, '[]');


		-- Create tabs array
		IF v_firsttab THEN 
			formVisit := json_build_object('tabName','visit','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
			formVisit := gw_fct_json_object_set_key(formVisit, 'fields', fieldsJson);
			v_form := v_form || ',' || formVisit::text;
		ELSE 
			formVisit := json_build_object('tabName','visit','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
			formVisit := gw_fct_json_object_set_key(formVisit, 'fields', fieldsJson);
			v_form := v_form || formVisit::text;
		END IF;

		v_firsttab := TRUE;
		v_active :=FALSE;

	END IF;

	-- Finish the construction of v_form
	v_form := v_form ||']';

	-- Check null
	v_form := COALESCE(v_form, '[]');
	
	-- Return
	IF v_firsttab IS FALSE THEN
		-- Return not implemented
	RETURN ('{"status":"Accepted"' || ', "version":'|| v_version || ', "enabled":false'|| '}')::json;
	ELSE 

		-- Return 
		RETURN ('{"status":"Accepted", "version":'|| v_version ||', "enabled":true'||
			',"form":' || v_form ||
		'}')::json;
	END IF;

	--Exception handling
	--EXCEPTION WHEN OTHERS THEN 
	--RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
