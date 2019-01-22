/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2558

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_get_featureinfo(
    p_table_id character varying,
    p_id character varying,
    p_device integer,
    p_infotype integer,
    p_configtable boolean)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
    column_type character varying;
    position json;
    fields json;
    fields_array json[];
    combo_rows json[];
    aux_json json;    
    table_pkey varchar;
    schemas_array name[];
    array_index integer DEFAULT 0;
    field_value character varying;
    api_version json;
    v_values_array json;
    v_combo_json json;
    v_combo_json_child json;
    v_como_id json;
    field_value_parent text;
    v_vdefault text;
    v_selected_id text;
    query_text text;
    v_query_text text;
    aux_json_child json;  
    v_tabname text = 'data';



BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get schema name
    schemas_array := current_schemas(FALSE);

--  Get if field's table are configured on config_api_layer_field
    -- DONT FORCE CONFIGTABLE
    --p_configtable = False;
    IF  p_configtable THEN 

       raise notice 'Configuration fields are defined on config_api_layer_field';

       	-- Call the function of feature fields generation
       	
	SELECT gw_api_get_formfields( p_table_id, 'feature', 'data', p_table_id, null, p_id, null, 'SELECT',null, p_device) INTO fields_array;
	--SELECT gw_api_get_formfields( p_table_id, 'feature', 'data', p_table_id, 'arc_id', p_id, 'text', 'SELECT',null, p_device) INTO fields_array;

    ELSE

       raise notice 'Configuration fields are NOT defined on config_api_layer_field. System values will be used';
        
	-- Get fields
	EXECUTE 'SELECT array_agg(row_to_json(a)) FROM 
		(SELECT a.attname as label, a.attname as column_id, concat('||quote_literal(v_tabname)||',''_'',a.attname) AS widgetname,
		(case when a.atttypid=16 then ''checkbox'' else ''textline'' end ) as widgettype, 
		(case when a.atttypid=16 then ''boolean'' else ''string'' end ) as "datatype", 
		''::TEXT AS tooltip, ''::TEXT as placeholder, false AS iseditable, false as isclickable,
		row_number()over() AS orderby, 
		3 AS layout_id, 
		row_number()over() AS layout_order, 
		FALSE AS dv_parent_id, FALSE AS isparent, FALSE AS button_function, ''::TEXT AS dv_querytext, ''::TEXT AS dv_querytext_filterc, FALSE AS action_function, FALSE AS isautoupdate
		FROM pg_attribute a
		JOIN pg_class t on a.attrelid = t.oid
		JOIN pg_namespace s on t.relnamespace = s.oid
		WHERE a.attnum > 0 
		AND NOT a.attisdropped
		AND t.relname = $1 
		AND s.nspname = $2
		AND a.attname !=''the_geom''
		AND a.attname !=''geom''
		ORDER BY a.attnum) a'
			INTO fields_array
			USING p_table_id, schemas_array[1]; 
   END IF;

--    Get id column
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO table_pkey
        USING p_table_id;


--    For views it suposse pk is the first column
    IF table_pkey ISNULL THEN
        EXECUTE 'SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		 AND t.relname = $1 
		 AND s.nspname = $2
		 ORDER BY a.attnum LIMIT 1'

		INTO table_pkey
		USING p_table_id, schemas_array[1];
    END IF;


--    Get column type
    EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
	    JOIN pg_class t on a.attrelid = t.oid
	    JOIN pg_namespace s on t.relnamespace = s.oid
	    WHERE a.attnum > 0 
	    AND NOT a.attisdropped
	    AND a.attname = $3
	    AND t.relname = $2 
	    AND s.nspname = $1
	    ORDER BY a.attnum'
	    USING schemas_array[1], p_table_id, table_pkey
            INTO column_type;
        
	raise notice 'Layer pkey: % ; Column_type %', table_pkey, column_type;
--    getting values
    EXECUTE 'SELECT (row_to_json(a)) FROM 
	    (SELECT * FROM '||p_table_id||' WHERE '||table_pkey||' = CAST($1 AS '||column_type||'))a'
	    INTO v_values_array
	    USING p_id;
--    Fill every value
    FOREACH aux_json IN ARRAY fields_array
    LOOP
--      Index
        array_index := array_index + 1;

	field_value := (v_values_array->>(aux_json->>'column_id'));
          
        field_value := COALESCE(field_value, '');
        
--      Update array
        fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'value', field_value);
           
    END LOOP;
   
--    Convert to json
    fields := array_to_json(fields_array);


--    Control NULL's
    api_version := COALESCE(api_version, '[]');    
    fields := COALESCE(fields, '[]');    
    position := COALESCE(position, '[]');


--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "fields":' || fields ||
        '}')::json;

--    Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
  --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

