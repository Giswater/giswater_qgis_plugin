CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_dev_getinsertform"(table_id varchar, lang varchar, id varchar, formtodisplay varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    column_type character varying;
    query_result character varying;
    position json;
    fields json;
    fields_array json[];
    position_row integer;
    combo_rows json[];
    aux_json json;    
    combo_json json;
    project_type character varying;
    formToDisplayName character varying;
    table_pkey varchar;
    schemas_array name[];
    array_index integer DEFAULT 0;
    config_param_vdefault_var text;
    field_value text;
    filter_val text;
    vdefault_var text;
    rownum_aux integer;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get schema name
    schemas_array := current_schemas(FALSE);
    

--    Get fields
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT label, name, type, "dataType", placeholder FROM config_web_fields WHERE table_id = $1) a'
        INTO fields_array
        USING table_id;    

--    Get combo rows
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT id, name, type, dv_table, dv_id_column, dv_name_column, sql_text, vdefault, onfilter, filterby, ROW_NUMBER() OVER() AS rownum 
        FROM config_web_fields WHERE table_id = $1) a WHERE type = $2'
    INTO combo_rows
    USING table_id, 'combo';
    combo_rows := COALESCE(combo_rows, '{}');


--    Update combos
    FOREACH aux_json IN ARRAY combo_rows
    LOOP

	-- For filtered combos
	IF (aux_json->>'filterby') IS NOT NULL THEN 

		-- Get vdefault values of parent filter
		EXECUTE 'SELECT config_param_vdefault FROM config_web_fields WHERE table_id=$1 AND name='|| quote_ident(aux_json->>'filterby')
		INTO config_param_vdefault_var
		USING table_id, filterby;

		-- Get filter
		IF config_param_vdefault_var IS NOT NULL THEN 
			EXECUTE 'SELECT value FROM config_param_user WHERE parameter=$1 cur_user=$2'
			INTO filter_val
			USING config_param_vdefault_var, current_user;
		END IF;

		-- Get combo id's using filtered values
		IF filter_val IS NOT NULL THEN
			EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'id') || ')) FROM ('|| quote_ident(aux_json->>'query_text')||' AND '
			||quote_ident(aux_json->>'onfilter')||' = '||filter_val||') a'
			INTO combo_json;
		END IF;

		EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'id') || ')) FROM ('|| quote_ident(aux_json->>'query_text')') a'
		INTO combo_json;

		-- Update array
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboIds', COALESCE(combo_json, '[]'));

		-- Set selected id
		IF combo_json IS NOT NULL THEN
			fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedId', combo_json->0);
		ELSE
			fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedId', to_json('Fred said "Hi."'::text));        
		END IF;

		-- Get combo values using filtered values
		IF filter_val IS NOT NULL THEN
			EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'name') || ')) FROM ('|| quote_ident(aux_json->>'query_text')||' AND '
			||quote_ident(aux_json->>'onfilter')||' = '||filter_val||') a'
			INTO combo_json;
		END IF;

		EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'name') || ')) FROM ('|| quote_ident(aux_json->>'query_text')') a'
		INTO combo_json; 
		
		combo_json := COALESCE(combo_json, '[]');

--        	Update array
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboNames', combo_json);

	ELSE

		-- Get combo id's values
		EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'id') || ')) FROM ('|| quote_ident(aux_json->>'query_text')') a'
		INTO combo_json;

		-- Update array
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboIds', COALESCE(combo_json, '[]'));

		-- Set selected id
		IF combo_json IS NOT NULL AND (aux_json->>'vdefault') IS NOT NULL THEN

			-- Get vdefault values
			EXECUTE 'SELECT value FROM config_param_user WHERE parameter=$1 cur_user=$2'
			INTO vdefault_var
			USING (aux_json->>'vdefault'), current_user;
		
			EXECUTE 'SELECT '|| quote_ident(aux_json->>'rownum')||'WHERE '||quote_ident(aux_json->>'id')' = '|| vdefault_var
			INTO rownum_aux;
			
			fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedId', combo_json->rownum_aux);
		ELSE
			fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedId', to_json('Fred said "Hi."'::text));        
		END IF;

		-- Get combo name values
		EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'name') || ')) FROM ('|| quote_ident(aux_json->>'query_text')') a'
		INTO combo_json; 
		
		combo_json := COALESCE(combo_json, '[]');

		-- Update array
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboNames', combo_json);
		
	END IF;

    END LOOP;


--    Get existing values for the element
    IF id IS NOT NULL THEN

--        Get id column
        EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
            INTO table_pkey
            USING table_id;

--        For views is the first column
        IF table_pkey ISNULL THEN
            EXECUTE 'SELECT column_name FROM information_schema.columns WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND ordinal_position = 1'
            INTO table_pkey
            USING schemas_array[1];
        END IF;

--        Get column type
        EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND column_name = $2'
            USING schemas_array[1], table_pkey
            INTO column_type;


--        Fill every value
        FOREACH aux_json IN ARRAY fields_array
        LOOP

--            Index
            array_index := array_index + 1;

--            Get combo values
            EXECUTE 'SELECT ' || quote_ident(aux_json->>'name') || ' FROM ' || quote_ident(table_id) || ' WHERE ' || quote_ident(table_pkey) || ' = CAST(' || quote_literal(id) || ' AS ' || column_type || ')' 
                INTO field_value; 
            field_value := COALESCE(field_value, '');


--            Update array
            IF aux_json->>'type' = 'combo' THEN
                fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'selectedId', field_value);
            ELSE            
                fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'value', field_value);
            END IF;
            
        END LOOP;

    END IF;    

    
--    Convert to json
    fields := array_to_json(fields_array);


--    Control NULL's
    formToDisplay := COALESCE(formToDisplay, '');
    fields := COALESCE(fields, '[]');    
    position := COALESCE(position, '[]');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "formToDisplay":"' || formToDisplay || '"' ||
        ', "fields":' || fields ||
        '}')::json;

--    Exception handling
   EXCEPTION WHEN OTHERS THEN 
       RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

