/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3466

-- DROP FUNCTION if exists cm.gw_trg_cm_edit_feature();
CREATE OR REPLACE FUNCTION cm.gw_trg_cm_edit_feature()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

--FUNCTION CODE: UNKNOWN

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
v_feature TEXT := TG_ARGV[0];
v_prev_search_path text;

BEGIN

	-- transaction-local search_path to target schema, parent, public
	v_prev_search_path := current_setting('search_path');
	PERFORM set_config('search_path', format('%I, PARENT_SCHEMA, public', TG_TABLE_SCHEMA), true);

	-- get input params --
	v_num_pkeys = 2; -- number OF pkeys (first "n" columns of the view)


	-- schema where to search tables (for campaings)
	WITH mec AS (
		SELECT unnest(string_to_array(current_setting('search_path'), ', ')) AS esquema
	)
	SELECT string_agg(quote_literal(esquema), ', ') INTO v_search_schema
	FROM mec WHERE esquema NOT ILIKE '%$%' AND esquema <> 'public';

	IF TG_OP = 'INSERT' THEN
		IF NEW.id is null THEN
			EXECUTE 'SELECT nextval(''om_campaign_lot_x_'||v_feature||'_id_seq'')'
			INTO NEW.id;
		END IF;

		IF v_feature = 'node' THEN
		    NEW.node_id := nextval('cm_urn_id_seq');
		ELSIF v_feature = 'arc' THEN
		    NEW.arc_id := nextval('cm_urn_id_seq');
		ELSIF v_feature = 'connec' THEN
		    NEW.connec_id := nextval('cm_urn_id_seq');
		END IF;

		IF NEW.expl_id is null THEN
			NEW.expl_id = (SELECT expl_id FROM om_campaign_lot WHERE lot_id=NEW.lot_id);
		END IF;

		IF NEW.sector_id is null THEN
			NEW.sector_id = (SELECT sector_id FROM om_campaign_lot WHERE lot_id=NEW.lot_id);
		END IF;

		NEW.state=1; NEW.state_type=2;
	END IF;

	-- get json data
	SELECT COALESCE(row_to_json(NEW), '{}') INTO v_json_new_data;
    SELECT COALESCE(row_to_json(OLD), '{}') INTO v_json_old_data;

   	IF TG_OP IN ('INSERT', 'UPDATE') THEN

  		SELECT COALESCE(row_to_json(NEW), '{}') INTO v_json_data;

   	ELSE

  		SELECT COALESCE(row_to_json(OLD), '{}') INTO v_json_data;

  	END IF;
  
	-- offset 2 because the first two columns are id and campaign id. We need lot_id and feature_id
   	EXECUTE '
   	WITH aaa AS (
	   	SELECT column_name AS col FROM information_schema.COLUMNS 
	  	WHERE table_schema = '||quote_literal(TG_TABLE_SCHEMA)||' AND table_name = '||quote_literal(TG_TABLE_NAME)||'
	  	LIMIT '||v_num_pkeys||' OFFSET 2
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

		PERFORM cm.gw_fct_cm_admin_dynamic_trigger(v_input_json);



	END IF;

	PERFORM set_config('search_path', v_prev_search_path, true);
   RETURN NEW;


EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RAISE;
END;
$function$
;

-- Permissions

ALTER FUNCTION cm.gw_trg_cm_edit_feature() OWNER TO postgres;
GRANT ALL ON FUNCTION cm.gw_trg_cm_edit_feature() TO postgres;
