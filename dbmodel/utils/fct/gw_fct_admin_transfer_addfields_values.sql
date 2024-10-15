/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3316

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
v_feature_class text;
v_viewname text;
v_view_type integer;
v_man_fields text;
v_feature_childtable_fields text;
v_data_view json;
exists_record BOOLEAN;
v_exists_col boolean;
rec_feature record;
v_partialquery text;

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
                WHERE feature_class <> 'LINK' AND child_layer IS NOT NULL
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
                SELECT c.id, cf.feature_class AS type FROM cat_feature_node c JOIN cat_feature cf ON cf.id = c.id
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
                SELECT c.id, cf.feature_class FROM cat_feature_arc c JOIN cat_feature cf ON cf.id = c.id
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
                SELECT c.id, cf.feature_class FROM cat_feature_connec cf JOIN cat_feature cf ON cf.id = c.id
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
                SELECT c.id, cf.feature_class FROM cat_feature_gully cf JOIN cat_feature cf ON cf.id = c.id
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

    -- transfer common addfields
    select count(*) into v_count from node;

    if v_count > 0 then

        if v_project_type = 'UD' then

            v_partialquery = ' union select gully_id as feature_id, ''GULLY''
            as sys_type, gully_type as feature_type from vu_gully';

        end if;

        for rec_feature in execute '
                with subq_1 as (
                select node_id as feature_id, ''NODE'' as sys_type, node_type as feature_type from vu_node union 
                select arc_id as feature_id, ''ARC'' as sys_type, arc_type as feature_type from vu_arc union 
                select connec_id as feature_id, ''CONNEC'' as sys_type, connec_type as feature_type from vu_connec
                '||v_partialquery||'),       
            subq_2 as (
                SELECT mav.feature_id, mav.value_param, sa.param_name, sa.datatype_id
                FROM _man_addfields_value_ mav
                left JOIN sys_addfields sa ON sa.id = mav.parameter_id
                left JOIN cat_feature cf ON cf.id = sa.cat_feature_id
                where sa.feature_type = ''ALL'' and value_param is not null
                ORDER BY sa.param_name
            )       
           select * from subq_2 join subq_1 using (feature_id)'
        loop
            v_feature_childtable_name := 'man_' || lower(rec_feature.sys_type) || '_' || lower(rec_feature.feature_type);

            v_sql := 'update ' ||v_feature_childtable_name||
            ' set '||rec_feature.param_name||' = '||quote_literal(rec_feature.value_param)|| '::' ||rec_feature.datatype_id||
            ' where  '||lower(rec_feature.sys_type)||'_id = '||quote_literal(rec_feature.feature_id)||'';

            execute v_sql;

        end loop;
     end if;

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
	--RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;