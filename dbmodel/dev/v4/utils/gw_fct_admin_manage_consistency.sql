/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_consistency(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
* EXAMPLE

-- Se puede ejecutar para un caso concreto:
SELECT gw_fct_admin_manage_consistency($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"data":{"parameters":{"action":"POST-UPDATE", "actionType":"CONSTRAINTS", "referenceSchema":"ud_ref_454", "targetSchema":"ud"}}}$$);

... o para todos los action_type (lo que sería el ALL):
SELECT gw_fct_admin_manage_consistency(concat('{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"data":{"parameters":{"action":"POST-UPDATE", "actionType":"', action_type, '", "referenceSchema":"ud_ref_454", "targetSchema":"ud"}}}')::JSON) 
FROM (SELECT 'CONSTRAINTS' AS action_type UNION SELECT 'VIEWS-TRG');

*/

DECLARE
v_action TEXT;
v_action_type TEXT;

v_target_schema TEXT;
v_ref_schema TEXT;
v_child_layer TEXT;
v_parent_layer TEXT;

rec record;

v_errs_constr TEXT[] := '{}';
v_errs_views TEXT[] := '{}';
v_errs_trgs TEXT[] := '{}';



BEGIN

	SET search_path = 'SCHEMA_NAME', public;

	
	v_action :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'action'; -- 'POST-UPDATE'
	v_action_type :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'actionType'; -- 'CONSTRAINTS // POST-UPDATE'

	v_target_schema :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'targetSchema'; -- 'ud'
	v_ref_schema :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'referenceSchema'; -- 'ud_ref_454'

	

	IF v_action = 'SNAPSHOT' THEN 
	
		DROP TABLE IF EXISTS _bkp_constraints;
		DROP TABLE IF EXISTS _bkp_views;
		DROP TABLE IF EXISTS _bkp_trg;
	
	
		RAISE NOTICE 'Crear meta-tabla de constraints de TOTA la BASE DE DADES';

		CREATE TABLE _bkp_constraints as 
		SELECT 
		    con.conname AS constraint_name,
		    con.contype AS type,
		    rel.relname AS table_name,
		    nsp.nspname AS schema_name,
		    pg_get_constraintdef(con.oid) AS half_def,
		    concat('ALTER TABLE ', rel.relname, ' ADD CONSTRAINT ', con.conname, ' ',  pg_get_constraintdef(con.oid)) AS full_def
		FROM pg_constraint con
		JOIN pg_class rel ON rel.oid = con.conrelid
		JOIN pg_namespace nsp ON nsp.oid = con.connamespace
		WHERE nsp.nspname NOT IN ('pg_catalog', 'information_schema')
		ORDER BY nsp.nspname, rel.relname;
	
	
		RAISE NOTICE 'Crear meta-tabla de vistes de TOTA la BASE DE DADES';
		
		EXECUTE format($sql$
		    CREATE TABLE _bkp_views AS
		    WITH mec AS (
		      SELECT DISTINCT
		        v.table_schema AS view_schema,
		        v.table_name AS view_name,
		        view_definition,
		        CASE 
		          WHEN v.table_name IN (SELECT DISTINCT parent_layer FROM %I.cat_feature) THEN 1
		          WHEN v.table_name IN (SELECT DISTINCT child_layer FROM %I.cat_feature) THEN NULL
		          WHEN v.table_name ILIKE 'v_plan_*' THEN 3
		          WHEN v.table_name ILIKE 'v_plan_psector%%' THEN 4
		          WHEN v.table_name = 'v_price_compost' THEN 5
		          WHEN v.table_name ILIKE 'v_price_%%' THEN 6
		          WHEN v.table_name IN ('v_rpt_arc', 'v_rpt_node') THEN 7
		          WHEN v.table_name ILIKE 'v_rpt_arc%%' THEN 8
		          WHEN v.table_name ILIKE 'v_rpt_node%%' THEN 8
		          ELSE 9
		        END AS exec_order
		      FROM information_schema.views v
		      WHERE v.table_schema NOT IN ('geometry_columns', 'geography_columns', 'raster_columns', 'raster_overviews')
		    )
		    SELECT * FROM mec ORDER BY exec_order; 
			$sql$, 
		    v_ref_schema,
		    v_ref_schema
		);
	
		RAISE NOTICE 'Crear meta-tabla de trg de TOTA la BASE DE DADES';
	
		CREATE TABLE _bkp_trg as
		SELECT
		    n.nspname AS schema_name,
		    c.relname AS table_name,
		    tg.tgname AS trigger_name,
		    REPLACE(concat(pg_get_triggerdef(tg.oid, true), ';'), 'CREATE', 'CREATE OR REPLACE') AS exec_trg
		FROM pg_trigger tg
		JOIN pg_class c ON c.oid = tg.tgrelid
		JOIN pg_namespace n ON n.oid = c.relnamespace
		WHERE NOT tg.tgisinternal;



	ELSIF v_action = 'POST-UPDATE' THEN -- recrear DDLs y ejecutarlo desde un schema_source a un schema_target.
	
		IF v_action_type = 'CONSTRAINTS' THEN
	
			RAISE NOTICE '-- ---------- POST-UPDATE: Re-built missing constraints ---------- --';
			-- constraints que estan al esquema de ref i no estan al esquema a updatejar.
			-- las que apuntan a tablas del mismo esquema (por ejemplo: ud y ud_ref_454)
			FOR rec IN 
				SELECT table_name, constraint_name, concat('ALTER TABLE ', v_target_schema, '.', table_name, ' ADD CONSTRAINT ', constraint_name, ' ', replace(half_def, concat(schema_name, '.'), 
				concat(v_target_schema, '.')), ';') AS exec_constr
				FROM "_bkp_constraints" bc WHERE schema_name = v_ref_schema
				AND constraint_name NOT IN (
					SELECT conname FROM pg_constraint con JOIN pg_namespace nsp ON nsp.oid = con.connamespace 
					WHERE nsp.nspname = v_target_schema
				)
			LOOP
			
				BEGIN 
					
					EXECUTE rec.exec_constr;
					
					EXCEPTION WHEN OTHERS THEN 
					RAISE NOTICE '[ERR] % -> %: % ', rec.table_name, rec.constraint_name, SQLERRM;
					v_errs_constr := array_append(v_errs_constr, concat(rec.table_name, ' - ', SQLERRM));
				
				END;
			
				RAISE NOTICE '[OK] % -> % ', rec.table_name, rec.constraint_name;
			
			END LOOP;
		
		
			-- TO DO: las que apuntan a tablas de otro esquema (por ejemplo: ud --> utils/om/crm y ud)
	
		ELSIF v_action_type = 'VIEWS-TRG' THEN 
		
			RAISE NOTICE '-- ---------- POST-UPDATE: Re-built all views ---------- --';
			-- todas las que son del esquema de ref + childs
			FOR rec IN 
				SELECT view_name, concat('CREATE OR REPLACE VIEW ', v_target_schema, '.', view_name, ' AS ', REPLACE(view_definition, concat(v_ref_schema, '.'), concat(v_target_schema, '.')), ';') AS exec_view
				FROM _bkp_views WHERE view_schema = v_ref_schema ORDER BY exec_order ASC
			LOOP
			
				BEGIN
					
					EXECUTE rec.exec_view;
				
					EXCEPTION WHEN OTHERS THEN
					RAISE NOTICE '[ERR] %: % ', rec.view_name, SQLERRM;
					v_errs_views := array_append(v_errs_views, concat(rec.view_name, ' - ', SQLERRM));
				
				END;
			
				RAISE NOTICE '[OK] %', rec.view_name;
				
			END LOOP;
			
		
			RAISE NOTICE '-- ---------- POST-UPDATE: Re-built all triggers ---------- --';
			
			FOR rec IN 
				SELECT table_name, trigger_name, REPLACE(exec_trg, schema_name, v_target_schema) AS exec_trg FROM "_bkp_trg" bt
				WHERE schema_name = v_ref_schema AND table_name IN (SELECT table_name FROM information_schema.TABLES WHERE table_schema = v_target_schema)
			LOOP
			
				BEGIN 
					
					EXECUTE rec.exec_trg;
				
					EXCEPTION WHEN OTHERS THEN
					RAISE NOTICE '[ERR] % -> %: % ', rec.table_name, rec.trigger_name, SQLERRM;
					v_errs_trgs := array_append(v_errs_trgs, concat(rec.table_name, ' - ', SQLERRM));
					
				END;
				
				RAISE NOTICE '[OK] % - % ', rec.table_name, rec.trigger_name;
				
			END LOOP;
		
			RAISE NOTICE '-- ---------- POST-UPDATE: Re-built child views and their triggers ---------- --';
		
			EXECUTE 'SELECT '||v_target_schema||'.gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 			"data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-CREATE" }}$$)';
	
		ELSE
		
			RAISE EXCEPTION 'action type "%" no existe ', v_action_type;
		
		END IF;
	
	ELSIF v_action = 'CHECK-DATA' THEN
	
	
	END IF;

	


	RETURN json_build_object(
			'status', 'Process finished. See errors in this JSON', 
			'action', v_action,
			'actionType', v_action_type,
			'errors', json_build_object(
						'constraints', v_errs_constr,
						'views', v_errs_views,
						'trg', v_errs_trgs
		));

END;
$function$
;

