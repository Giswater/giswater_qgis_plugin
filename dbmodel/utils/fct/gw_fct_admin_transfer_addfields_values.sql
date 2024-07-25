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
v_sql text;
v_count integer;

rec_mav record;
rec_sa record;
rec_sa_featurestypes record;
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
v_exists_col boolean;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

 	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (218, null, 4, 'TRANSFER ADDFIELDS VALUES');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (218, null, 4, '-------------------------------------------------------------');


    -- check cat_feature_id null on sys_addfields
    FOR rec_sa_featurestypes IN
        select sa.param_name, sa.feature_type, sa.datatype_id from sys_addfields sa
        where sa.feature_type != 'CHILD'
    LOOP
        IF rec_sa_featurestypes.feature_type = 'ALL' THEN
            -- create all addfields tables for everything in cat_feature
            FOR rec_sa IN
                SELECT cf.id, cf.feature_type FROM cat_feature cf
                WHERE system_id <> 'LINK' AND child_layer IS NOT NULL
            LOOP
                v_feature_childtable_name := 'man_' || lower(rec_sa.feature_type) || '_' || lower(rec_sa.id);

                IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
                    IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = rec_sa_featurestypes.param_name)) IS FALSE THEN
                        EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||'';
                    END IF;
                ELSE
                    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                            '|| lower(rec_sa.feature_type) || '_id varchar PRIMARY KEY,
                            ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||'
                        )';

                    EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD CONSTRAINT ' || v_feature_childtable_name || '_fk FOREIGN KEY ('|| lower(rec_sa.feature_type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.feature_type) || '('|| lower(rec_sa.feature_type) || '_id) 
                    ON UPDATE CASCADE ON DELETE CASCADE;';

                    EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                END IF;

            END LOOP;

        ELSIF rec_sa_featurestypes.feature_type = 'NODE' THEN
            -- create all addfields tables for everything in cat_feature_node
            FOR rec_sa IN
                SELECT cf.id, cf.type FROM cat_feature_node cf
            LOOP

                v_feature_childtable_name := 'man_' || lower(rec_sa.type) || '_' || lower(rec_sa.id);

                IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
                    IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = rec_sa_featurestypes.param_name)) IS FALSE THEN
                        EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||'';
                    END IF;
                ELSE
                    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                            '|| lower(rec_sa.type) || '_id varchar PRIMARY KEY,
                            ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||',
                            CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.type) || '('|| lower(rec_sa.type) || '_id) 
                        ON UPDATE CASCADE ON DELETE CASCADE
                        )';

                    EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                END IF;

            END LOOP;

        ELSIF rec_sa_featurestypes.feature_type = 'ARC' THEN
            -- create all addfields tables for everything in cat_feature_arc
            FOR rec_sa IN
                SELECT cf.id, cf.type FROM cat_feature_arc cf
            LOOP

                v_feature_childtable_name := 'man_' || lower(rec_sa.type) || '_' || lower(rec_sa.id);

                IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
                    IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = rec_sa_featurestypes.param_name)) IS FALSE THEN
                        EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||'';
                    END IF;
                ELSE
                    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                            '|| lower(rec_sa.type) || '_id varchar PRIMARY KEY,
                            ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||',
                            CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.type) || '('|| lower(rec_sa.type) || '_id) 
                            ON UPDATE CASCADE ON DELETE CASCADE
                        )';

                    EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                END IF;

            END LOOP;

        ELSIF rec_sa_featurestypes.feature_type = 'CONNEC' THEN
            -- create all addfields tables for everything in cat_feature_connec
            FOR rec_sa IN
                SELECT cf.id, cf.type FROM cat_feature_connec cf
            LOOP

                v_feature_childtable_name := 'man_' || lower(rec_sa.type) || '_' || lower(rec_sa.id);

                IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
                    IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = rec_sa_featurestypes.param_name)) IS FALSE THEN
                        EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||'';
                    END IF;
                ELSE
                    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                            '|| lower(rec_sa.type) || '_id varchar PRIMARY KEY,
                            ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||',
                            CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.type) || '('|| lower(rec_sa.type) || '_id) 
                            ON UPDATE CASCADE ON DELETE CASCADE
                        )';

                    EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                END IF;

            END LOOP;

        ELSIF rec_sa_featurestypes.feature_type = 'GULLY' THEN
            -- create all addfields tables for everything in cat_feature_gully
            FOR rec_sa IN
                SELECT cf.id, cf.type FROM cat_feature_gully cf
            LOOP

                v_feature_childtable_name := 'man_' || lower(rec_sa.type) || '_' || lower(rec_sa.id);

                IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
                    IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = rec_sa_featurestypes.param_name)) IS FALSE THEN
                        EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||'';
                    END IF;
                ELSE
                    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                            '|| lower(rec_sa.type) || '_id varchar PRIMARY KEY,
                            ' || rec_sa_featurestypes.param_name || ' '||rec_sa_featurestypes.datatype_id||',
                            CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.type) || '('|| lower(rec_sa.type) || '_id) 
                            ON UPDATE CASCADE ON DELETE CASCADE
                        )';

                    EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                END IF;

            END LOOP;

        END IF;

    END LOOP;


    -- transfer data from _man_addfields_value_ to new childtables
    FOR rec_sa IN
        SELECT sa.param_name, sa.datatype_id, cf.id, cf.feature_type FROM sys_addfields sa
        INNER JOIN cat_feature cf ON cf.id = sa.cat_feature_id
        WHERE sa.feature_type = 'CHILD'
        ORDER BY sa.orderby
    LOOP
        v_feature_childtable_name := 'man_' || lower(rec_sa.feature_type) || '_' || lower(rec_sa.id);

        IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
            IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = rec_sa.param_name)) IS FALSE THEN
                EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_sa.param_name || ' '||rec_sa.datatype_id||'';
            END IF;
        ELSE
            EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                    '|| lower(rec_sa.feature_type) || '_id varchar PRIMARY KEY,
                    ' || rec_sa.param_name || ' '||rec_sa.datatype_id||',
                    CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.feature_type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.feature_type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.feature_type) || '('|| lower(rec_sa.feature_type) || '_id) 
                    ON UPDATE CASCADE ON DELETE CASCADE
                )';

            EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

        END IF;
    END LOOP;

    -- insert into log tables those null addfield values
    insert into audit_log_data (fid, feature_id, feature_type, log_message, addparam)
    select 525, feature_id, cat_Feature_id, 'Null value on addfield',
    concat('{"parameter_id": ', parameter_id, '}')::json
    from _man_addfields_value_ mav
    join sys_addfields sa ON sa.id = mav.parameter_id
    where value_param is null;  

    FOR rec_mav IN
        SELECT mav.feature_id, mav.value_param, mav.parameter_id, sa.param_name, sa.datatype_id, cf.id, cf.feature_type, cf.child_layer
        FROM _man_addfields_value_ mav
        INNER JOIN sys_addfields sa ON sa.id = mav.parameter_id
        INNER JOIN cat_feature cf ON cf.id = sa.cat_feature_id
        WHERE mav.value_param is not null
        ORDER BY sa.param_name
    LOOP
        v_feature_childtable_name := 'man_' || lower(rec_mav.feature_type) || '_' || lower(rec_mav.id);

       -- check if feature_id exists in parent table
        v_sql = 'select count(*) from vu_'||lower(rec_mav.feature_type)||' 
                 where '||lower(rec_mav.feature_type)||'_id = '||quote_literal(rec_mav.feature_id)||'';

        execute v_sql into v_count;

        if v_count = 0 then

            v_sql =
            'INSERT INTO audit_log_data (fid, feature_id, feature_type, log_message, addparam)
             SELECT 525, '||quote_literal(rec_mav.feature_id)||', '||quote_literal(rec_mav.feature_type)||', 
             ''Non-existing feature_id for this addfield '',
             json_build_object(''parameter_id'', '||quote_literal(rec_mav.parameter_id)||', ''value_param'', '||quote_literal(rec_mav.value_param)||') as js 
             from _man_addfields_value_
             WHERE feature_id = '||quote_literal(rec_mav.feature_id)||' AND parameter_id = '||quote_literal(rec_mav.parameter_id)||'';

            execute v_sql;

        elsif v_count > 0 then

            -- check if feature_type of the feature_id of the addfield matches the real feature_type of the object
            v_sql = 'select count(*) from vu_'||lower(rec_mav.feature_type)||' 
                     where '||lower(rec_mav.feature_type)||'_id = '||quote_literal(rec_mav.feature_id)||'
                     AND '||lower(rec_mav.feature_type)||'_type  = '||quote_literal(rec_mav.id)||'';

            execute v_sql into v_count;

            if v_count = 0 then

                v_sql = 'INSERT INTO audit_log_data (fid, feature_id, feature_type, log_message, addparam)
                     SELECT 525, '||quote_literal(rec_mav.feature_id)||', '||quote_literal(rec_mav.feature_type)||', 
                     ''The value of this addfield is related to a different feature_type from the existing feature.'',
                     json_build_object(''parameter_id'', '||quote_literal(rec_mav.parameter_id)||', ''value_param'', '||quote_literal(rec_mav.value_param)||') as js 
                     from _man_addfields_value_
                     WHERE feature_id = '||quote_literal(rec_mav.feature_id)||' AND parameter_id = '||quote_literal(rec_mav.parameter_id)||'';

                execute v_sql;

            elsif v_count > 0 then -- feature_id and feature_type of _man_addfields_value match with an existing object in parent table

                -- check if man_feature_type table exist (addfield table)
                v_sql = 'SELECT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_schema = '||quote_literal(v_schemaname)||' 
                AND table_name = '||quote_literal(v_feature_childtable_name)||')';

                execute v_sql into exists_record;

                IF (exists_record) IS FALSE THEN

                    -- create table and one column for each addfield
                    v_sql = 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                            '|| lower(rec_sa.feature_type) || '_id varchar PRIMARY KEY,
                            CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.feature_type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.feature_type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.feature_type) || '('|| lower(rec_sa.feature_type) || '_id) 
                            ON UPDATE CASCADE ON DELETE CASCADE
                        )';

                    execute v_sql;

                    v_sql = 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_mav.param_name || ' '||rec_mav.datatype_id||'';

                    EXECUTE v_sql;

                    EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) 
                    VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                ELSIF (exists_record) IS TRUE then

                   -- check if the corresponding column for the addfield exists in man_table_feature
                    v_sql = 'SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = '||quote_literal(v_schemaname)||' 
                            AND table_name = '||quote_literal(v_feature_childtable_name)||' AND column_name = '||quote_literal(rec_mav.param_name)||')';

                    execute v_sql into v_exists_col;

                    IF v_exists_col is false then

                        v_sql = 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || rec_mav.param_name || ' '||rec_mav.datatype_id||'';

                        execute v_sql;

                    elsif v_exists_col is true then
                    
                        -- check if feature_id exists in man_feature_type table (addfield table)
                        v_sql = 'select count(*) from man_'||lower(rec_mav.feature_type)|| '_' || lower(rec_mav.id)||' 
                                 where '||lower(rec_mav.feature_type)||'_id = '||quote_literal(rec_mav.feature_id)||'';
                        
                        execute v_sql into v_count;
                    
                        if v_count = 0 then
                            
                            v_sql = 'insert into man_'||lower(rec_mav.feature_type)|| '_' || lower(rec_mav.id)||' ('||lower(rec_mav.feature_type)||'_id) 
                                     values ('||quote_literal(rec_mav.feature_id)||')';

                            execute v_sql;
                        
                        end if;
                            
                        -- insert addfields by updating table
                        v_sql = 'update man_'||lower(rec_mav.feature_type)|| '_' || lower(rec_mav.id)||' 
                                 set '||rec_mav.param_name||' = '||quote_literal(rec_mav.value_param)||'::'||rec_mav.datatype_id||' 
                                 where '||lower(rec_mav.feature_type)||'_id = '||quote_literal(rec_mav.feature_id)||'';
                                
                        execute v_sql;

                    end if;

                 end if;

            end if;

        end if;

    END LOOP;

    -- recreate views
    FOR rec_sys IN
        SELECT cat_feature_id FROM sys_addfields WHERE cat_feature_id IS NOT NULL
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

	-- the exception when others need to be disabled because in case of update if it breaks update proces need to be canceled
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;