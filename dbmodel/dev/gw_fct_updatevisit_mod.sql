
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_updatevisit_mod(
    visit_id bigint,
    column_name character varying,
    value_new character varying)
  RETURNS json AS
$BODY$
DECLARE

--	Variables
	column_type character varying;
	schemas_array name[];
	sql_query varchar;
	return_multiplier_aux text;

BEGIN


--	Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--	Get schema name
	schemas_array := current_schemas(FALSE);

--	Get column type
	EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ''om_visit'' AND column_name = $2'
		USING schemas_array[1], column_name
		INTO column_type;

--	Error control
	IF column_type ISNULL THEN
		RETURN ('{"status":"Failed","SQLERR":"Column ' || column_name || ' does not exist in table om_visit"}')::json;
	END IF;		

--	Value update
	sql_query := 'UPDATE om_visit SET ' || quote_ident(column_name) || ' = CAST(' || quote_literal(value_new) || ' AS ' || column_type || ') WHERE id = ' || visit_id::INT;
	EXECUTE sql_query;


	IF column_name='is_done' THEN
		IF value_new::boolean IS TRUE THEN
			SELECT gw_fct_om_visit_event_multiplier(visit_id::integer) INTO return_multiplier_aux;
		END IF;
	END IF;

--	Control NULL's
	return_multiplier_aux := COALESCE(return_multiplier_aux, '');

--	Return
	RETURN ('{"status":"Accepted", "geometry":"'||return_multiplier_aux||'"}')::json;	

--	Exception handling
	EXCEPTION WHEN OTHERS THEN 
		RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


