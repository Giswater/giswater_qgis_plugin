/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2690

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_transfer_addfields_values();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_transfer_addfields_values()
  RETURNS json AS
$BODY$


/*EXAMPLE

-- fid: 218

*/

DECLARE 

v_schemaname text;
v_project_type text;
v_version text;
v_error_context text;

rec_mav record;
rec_sa record;
rec_sys record;
rec_fgk record;

v_feature_childtable_name text;

v_cat_feature text;
v_feature_type text;
v_feature_system_id text;
v_viewname text;
v_view_type integer;
v_man_fields text;
v_feature_childtable_fields text;
v_data_view json;
exists_record BOOLEAN;

BEGIN
	
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

 	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (218, null, 4, 'TRANSFER ADDFIELDS VALUES');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (218, null, 4, '-------------------------------------------------------------');

    -- transfer data from _man_addfields_value_ to new childtables
    FOR rec_sa IN
        SELECT sa.param_name, cf.id, cf.feature_type, cf.child_layer FROM sys_addfields sa
        INNER JOIN cat_feature cf ON cf.id = sa.cat_feature_id
    LOOP
        v_feature_childtable_name := 'man_' || lower(rec_sa.feature_type) || '_' || lower(rec_sa.id);

        IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
            IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = rec_sa.param_name)) IS FALSE THEN
                EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_sa.param_name || ' text';
            END IF;
        ELSE
            EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                    id BIGSERIAL PRIMARY KEY,
                    '|| lower(rec_sa.feature_type) || '_id varchar(16),
                    ' || rec_sa.param_name || ' text,
                    CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.feature_type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.feature_type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.feature_type) || '('|| lower(rec_sa.feature_type) || '_id) ON DELETE CASCADE ,
                    CONSTRAINT ' || v_feature_childtable_name || '_unique UNIQUE ('|| lower(rec_sa.feature_type) ||'_id)
                )';

            EXECUTE 'ALTER SEQUENCE ' || v_feature_childtable_name || '_id_seq OWNED BY ' || v_feature_childtable_name || '.id';

            EXECUTE 'ALTER TABLE ONLY ' || v_feature_childtable_name || ' ALTER COLUMN id SET DEFAULT nextval(''' || v_feature_childtable_name || '_id_seq''::regclass)';

            EXECUTE 'SELECT pg_catalog.setval(''' || v_feature_childtable_name || '_id_seq'', 1, false)';

            EXECUTE 'CREATE INDEX ' || v_feature_childtable_name || '_'|| lower(rec_sa.feature_type) ||'_id_index ON ' || v_feature_childtable_name || ' USING btree ('|| lower(rec_sa.feature_type) ||'_id)';

            EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES (''' || v_feature_childtable_name || ''', '''', ''role_edit'') ON CONFLICT (id) DO NOTHING;';

        END IF;
    END LOOP;

    FOR rec_mav IN
        SELECT mav.feature_id, mav.value_param, sa.param_name, cf.id, cf.feature_type, cf.child_layer
        FROM _man_addfields_value_ mav
        INNER JOIN sys_addfields sa ON sa.id = mav.parameter_id
        INNER JOIN cat_feature cf ON cf.id = sa.cat_feature_id
        ORDER BY sa.param_name
    LOOP
        -- Haz algo con cada fila, por ejemplo, imprimir
        v_feature_childtable_name := 'man_' || lower(rec_mav.feature_type) || '_' || lower(rec_mav.id);

        EXECUTE 'SELECT EXISTS (SELECT 1 FROM '|| v_feature_childtable_name ||' WHERE '|| lower(rec_mav.feature_type) ||'_id = $1)' INTO exists_record USING rec_mav.feature_id;

        IF (exists_record) IS TRUE THEN
            EXECUTE 'UPDATE '|| v_feature_childtable_name ||' SET '|| rec_mav.param_name ||' = '|| rec_mav.value_param ||' WHERE '|| v_feature_childtable_name ||'.'|| lower(rec_mav.feature_type) ||'_id=$1'
            USING rec_mav.feature_id;
        ELSE
            EXECUTE 'INSERT INTO '|| v_feature_childtable_name ||' ('|| lower(rec_mav.feature_type) ||'_id, '|| rec_mav.param_name ||') VALUES ($1, $2)'
            USING rec_mav.feature_id, rec_mav.value_param;
        END IF;

    END LOOP;

    -- recreate views
    FOR rec_sys IN
        SELECT cat_feature_id FROM sys_addfields
        GROUP BY cat_feature_id
    LOOP
        v_cat_feature = ''|| rec_sys.cat_feature_id ||'';
        v_feature_type = (SELECT lower(feature_type) FROM cat_feature where id=v_cat_feature);
        v_feature_system_id  = (SELECT lower(system_id) FROM cat_feature where id=v_cat_feature);
        v_viewname = (SELECT lower(child_layer) FROM cat_feature where id=v_cat_feature);
        v_feature_childtable_name := 'man_' || v_feature_type || '_' || lower(v_cat_feature);

        --select columns from man_* table without repeating the identifier
        EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
        FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||'''
        and column_name!='''||v_feature_type||'_id'''
        INTO v_man_fields;

        --select columns from v_feature_childtable_name.* table without repeating the identifiers
        EXECUTE 'SELECT DISTINCT string_agg(concat('''||v_feature_childtable_name||'.'',column_name)::text,'', '')
        FROM information_schema.columns where table_name='''||v_feature_childtable_name||''' and table_schema='''||v_schemaname||'''
        and column_name!=''id'' and column_name!='''||v_feature_type||'_id'''
        INTO v_feature_childtable_fields;

        IF (v_man_fields IS NULL AND v_project_type='WS') OR
            (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='arc' OR v_feature_type='node')) THEN

            EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
            v_view_type = 4;
        ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN
            EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
            v_view_type = 5;
        ELSE
            EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
            v_view_type = 6;
        END IF;

        v_man_fields := COALESCE(v_man_fields, 'null');
        v_feature_childtable_fields := COALESCE(v_feature_childtable_fields, 'null');

        v_data_view = '{
        "schema":"'||v_schemaname ||'",
        "body":{"viewname":"'||v_viewname||'",
            "feature_type":"'||v_feature_type||'",
            "feature_system_id":"'||v_feature_system_id||'",
            "feature_cat":"'||v_cat_feature||'",
            "feature_childtable_name":"'||v_feature_childtable_name||'",
            "feature_childtable_fields":"'||v_feature_childtable_fields||'",
            "man_fields":"'||v_man_fields||'",
            "view_type":"'||v_view_type||'"
            }
        }';

        PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

        --create trigger on view
        EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||' ON '||v_schemaname||'.'||v_viewname||';';

        EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||'
        INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
        FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||v_cat_feature||''');';

        INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
        VALUES (218, null, 4, concat('Recreate edition trigger for view ',v_viewname,'.'));

        PERFORM gw_fct_admin_role_permissions();

        INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
        VALUES (218, null, 4, 'Set role permissions.');

    END LOOP;

    -- update sys_foreignkey values
    FOR rec_fgk IN
        SELECT sf.id, cf.feature_type, sa.cat_feature_id, sa.param_name
        FROM sys_foreignkey sf
        INNER JOIN sys_addfields sa on sa.param_name = sf.typevalue_name
        INNER JOIN cat_feature cf on cf.id = sa.cat_feature_id
        WHERE sf.target_table = 'man_addfields_value'
    LOOP
         v_feature_childtable_name := 'man_' || lower(rec_fgk.feature_type) || '_' || lower(rec_fgk.cat_feature_id);
         EXECUTE 'UPDATE sys_foreignkey SET typevalue_table=''edit_typevalue'', typevalue_name='''|| rec_fgk.param_name ||''', target_table='''|| v_feature_childtable_name ||''', target_field='''|| rec_fgk.param_name ||''' WHERE id='|| rec_fgk.id ||';';
    END LOOP;

	RETURN ('{"status":"Accepted", "message":{"level":"3", "text":"Process done successfully"}, "version":"'||v_version||'"}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;