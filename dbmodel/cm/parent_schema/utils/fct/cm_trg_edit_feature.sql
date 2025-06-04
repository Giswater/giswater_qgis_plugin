-- DROP FUNCTION cm.cm_trg_edit_feature();

CREATE OR REPLACE FUNCTION cm.cm_trg_edit_feature()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
v_json_new_data json;
v_json_old_data json;
v_input_json json;
v_tg_table_name text;
v_pkey_column text;
v_pkey_value text;

v_pkey_cols TEXT;
v_search_schema TEXT;
v_update_where TEXT;
v_num_pkeys integer;
v_json_data JSON;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', ws_0604, public';

	-- get input params --
	v_num_pkeys = 2; -- number OF pkeys (first "n" columns of the view)



	-- schema where to search tables (for campaings)
	WITH mec AS (
		SELECT unnest(string_to_array(current_setting('search_path'), ', ')) AS esquema
	)
	SELECT string_agg(quote_literal(esquema), ', ') INTO v_search_schema 
	FROM mec WHERE esquema NOT ILIKE '%$%' AND esquema <> 'public';

	-- get json data
	SELECT COALESCE(row_to_json(NEW), '{}') INTO v_json_new_data;
    SELECT COALESCE(row_to_json(OLD), '{}') INTO v_json_old_data;
   
   	IF TG_OP IN ('INSERT', 'UPDATE') THEN
   	
   		SELECT COALESCE(row_to_json(NEW), '{}') INTO v_json_data;
   	
   	ELSE
   	
   		SELECT COALESCE(row_to_json(OLD), '{}') INTO v_json_data;

   END IF;
  -- RAISE EXCEPTION 'v_json_new_data %', v_json_old_data;
   
   	EXECUTE '
    WITH aaa AS (
	   	SELECT column_name AS col FROM information_schema.COLUMNS 
	  	WHERE table_schema = '||quote_literal(TG_TABLE_SCHEMA)||' AND table_name = '||quote_literal(TG_TABLE_NAME)||'
	  	LIMIT '||v_num_pkeys||'
	), aux AS (
   			SELECT 1 AS id, '||QUOTE_LITERAL(v_json_data)||'::json AS js
	), prep_pkey_syntax AS (		
		SELECT col, js->>col AS val FROM aux, aaa
	), casi_aux AS (
		SELECT concat(col, '' = '', val) AS casi FROM prep_pkey_syntax
	)
		SELECT string_agg(casi, '' AND '') FROM casi_aux' 
	INTO v_update_where;

	


    IF TG_OP <> 'TRUNCATE' THEN -- INSERT, UPDATE, DELETE
    
        v_input_json := jsonb_build_object(
        'client', jsonb_build_object(
            'device', 4,
            'infoType', 1,
            'lang', 'ES'
            ),
        'feature', '{}'::jsonb,
        'data', jsonb_build_object(
            'parameters', jsonb_build_object(
                'action', TG_OP,
                'searchSchema', v_search_schema,
                'tgTableName', TG_TABLE_NAME,
                'updateWhere', v_update_where,
                'jsonData', v_json_data
                )	
            )
        );
       
       	--RAISE EXCEPTION 'v_input_json %', v_input_json;

        PERFORM ws_0604_2.gw_fct_admin_dynamic_trigger(v_input_json);
 
       
       
    END IF;
   
   RETURN NEW;
  

END;
$function$
;

-- Permissions

ALTER FUNCTION cm.cm_trg_edit_feature() OWNER TO postgres;
GRANT ALL ON FUNCTION cm.cm_trg_edit_feature() TO postgres;
