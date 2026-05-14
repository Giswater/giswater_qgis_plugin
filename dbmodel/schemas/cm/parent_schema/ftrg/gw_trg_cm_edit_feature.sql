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
v_lot_id int;
v_campaign_id int;
v_current_table text := TG_TABLE_NAME;
v_feature_type text;
v_epavdef json;

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
		IF v_feature = 'node' THEN
		    NEW.node_id := nextval('cm_urn_id_seq');
			IF (lower(replace(v_current_table, 've_PARENT_SCHEMA_lot_', '')) IN (SELECT lower(id) FROM PARENT_SCHEMA.cat_feature WHERE feature_class = 'VALVE')) THEN

				SELECT vdef INTO v_epavdef FROM (
					SELECT json_array_elements_text ((value::json->>'catfeatureId')::json) id , (value::json->>'vdefault') vdef
					FROM PARENT_SCHEMA.config_param_system
					WHERE parameter like 'epa_valve_vdefault_%'
				)a
				WHERE lower(id) = lower(replace(v_current_table, 've_PARENT_SCHEMA_lot_', ''));
				SELECT v_epavdef->>'valve_type'
				INTO NEW.valve_type;
			END IF;
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
		NEW.created_by=current_user; NEW.created_at=now();
		NEW.datasource=1;
	END IF;

	-- get json data
	SELECT COALESCE(row_to_json(NEW), '{}') INTO v_json_new_data;
    SELECT COALESCE(row_to_json(OLD), '{}') INTO v_json_old_data;

   	IF TG_OP IN ('INSERT', 'UPDATE') THEN

  		SELECT COALESCE(row_to_json(NEW), '{}') INTO v_json_data;

		v_lot_id := NEW.lot_id;

		SELECT campaign_id INTO v_campaign_id
	    FROM cm.om_campaign_lot
	    WHERE lot_id = v_lot_id;
	
		IF v_campaign_id IS NULL THEN
	        RAISE EXCEPTION 'Lot % does not have an assigned campaign.', v_lot_id;
	    END IF;
		v_feature_type := UPPER(replace(v_current_table, 've_PARENT_SCHEMA_lot_', ''));
		IF v_feature IN ('arc','node') THEN
			EXECUTE format('INSERT INTO cm.om_campaign_x_%I (%s_id, campaign_id, %scat_id, %s_type, status)
							VALUES ($1.%I_id, $2, $1.%Icat_id, COALESCE($1.%I_type, $3), $1.status) ON CONFLICT (%s_id, campaign_id)
							DO UPDATE SET status = EXCLUDED.status, %s_type = EXCLUDED.%s_type, %scat_id = EXCLUDED.%scat_id
							WHERE cm.om_campaign_x_%I.%s_id = EXCLUDED.%s_id',
					v_feature, v_feature, v_feature, v_feature, v_feature, v_feature, v_feature, v_feature, v_feature, v_feature,
					v_feature, v_feature, v_feature, v_feature, v_feature)
					USING NEW, v_campaign_id, v_feature_type;
		END IF;
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
