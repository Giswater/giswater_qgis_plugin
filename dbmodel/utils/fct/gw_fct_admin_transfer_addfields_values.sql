/*
This file is part of Giswater
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


	IF EXISTS (SELECT 1 FROM sys_addfields) THEN

        -- check cat_feature_id null on sys_addfields
        FOR rec_sa_featurestypes IN
            SELECT sa.param_name, sa.feature_type, sa.datatype_id FROM sys_addfields sa
            WHERE sa.feature_type != 'CHILD' AND sa.active
        LOOP
            IF rec_sa_featurestypes.feature_type = 'ALL' THEN
                -- create all addfields tables for everything in cat_feature
                FOR rec_sa IN
                    SELECT cf.id, cf.feature_type FROM cat_feature cf
                    WHERE feature_class <> 'LINK' AND child_layer IS NOT NULL
                    AND cf.active
                LOOP
                    v_feature_childtable_name := 'man_' || lower(rec_sa.feature_type) || '_' || lower(rec_sa.id);

                    IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
                        IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = lower(rec_sa_featurestypes.param_name))) IS FALSE THEN
                            EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||'';
                        END IF;
                    ELSE
                        EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                                '|| lower(rec_sa.feature_type) || '_id varchar PRIMARY KEY,
                                ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||'
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
                        IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = lower(rec_sa_featurestypes.param_name))) IS FALSE THEN
                            EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||'';
                        END IF;
                    ELSE
                        EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                                '|| lower(rec_sa.type) || '_id varchar PRIMARY KEY,
                                ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||',
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
                        IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = lower(rec_sa_featurestypes.param_name))) IS FALSE THEN
                            EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||'';
                        END IF;
                    ELSE
                        EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                                '|| lower(rec_sa.type) || '_id varchar PRIMARY KEY,
                                ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||',
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
                        IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = lower(rec_sa_featurestypes.param_name))) IS FALSE THEN
                            EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||'';
                        END IF;
                    ELSE
                        EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                                '|| lower(rec_sa.type) || '_id varchar PRIMARY KEY,
                                ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||',
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
                        IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = lower(rec_sa_featurestypes.param_name))) IS FALSE THEN
                            EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||'';
                        END IF;
                    ELSE
                        EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                                '|| lower(rec_sa.type) || '_id varchar PRIMARY KEY,
                                ' || lower(rec_sa_featurestypes.param_name) || ' '||rec_sa_featurestypes.datatype_id||',
                                CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.type) || '('|| lower(rec_sa.type) || '_id) 
                                ON UPDATE CASCADE ON DELETE CASCADE
                            )';

                        EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                    END IF;

                END LOOP;

            END IF;

        END LOOP;


        -- transfer data from _man_addfields_value_ to new childtables
        IF EXISTS (SELECT 1 FROM _man_addfields_value_ mav LEFT JOIN sys_addfields sa ON sa.id = mav.parameter_id WHERE mav.value_param IS NOT NULL) THEN
            FOR rec_sa IN
                SELECT sa.param_name, sa.datatype_id, cf.id, cf.feature_type FROM sys_addfields sa
                INNER JOIN cat_feature cf ON cf.id = sa.cat_feature_id
                WHERE sa.feature_type = 'CHILD'
                AND sa.active AND cf.active
                ORDER BY sa.orderby
            LOOP
                v_feature_childtable_name := 'man_' || lower(rec_sa.feature_type) || '_' || lower(rec_sa.id);

                IF (SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name)) IS TRUE THEN
                    IF (SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = v_feature_childtable_name AND column_name = lower(rec_sa.param_name))) IS FALSE THEN
                        EXECUTE 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || lower(rec_sa.param_name) || ' '||rec_sa.datatype_id||'';
                    END IF;
                ELSE
                    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                            '|| lower(rec_sa.feature_type) || '_id varchar PRIMARY KEY,
                            ' || lower(rec_sa.param_name) || ' '||rec_sa.datatype_id||',
                            CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.feature_type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.feature_type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.feature_type) || '('|| lower(rec_sa.feature_type) || '_id) 
                            ON UPDATE CASCADE ON DELETE CASCADE
                        )';

                    EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                END IF;
            END LOOP;
        END IF;

        -- insert into log tables those null addfield values
        INSERT INTO audit_log_data (fid, feature_id, feature_type, log_message, addparam)
        SELECT 525, feature_id, cat_Feature_id, 'Null value on addfield',
        concat('{"parameter_id": ', parameter_id, '}')::json
        FROM _man_addfields_value_ mav
        JOIN sys_addfields sa ON sa.id = mav.parameter_id
        WHERE value_param IS NULL;

        FOR rec_mav IN
            SELECT mav.feature_id, mav.value_param, mav.parameter_id, sa.param_name, sa.datatype_id, cf.id, cf.feature_type, cf.child_layer
            FROM _man_addfields_value_ mav
            INNER JOIN sys_addfields sa ON sa.id = mav.parameter_id
            INNER JOIN cat_feature cf ON cf.id = sa.cat_feature_id
            WHERE mav.value_param IS NOT NULL
            AND sa.active AND cf.active
            ORDER BY sa.param_name
        LOOP
            v_feature_childtable_name := 'man_' || lower(rec_mav.feature_type) || '_' || lower(rec_mav.id);

            -- check if feature_id exists in parent table
            v_sql = 'SELECT count(*) FROM vu_'||lower(rec_mav.feature_type)||' 
                    WHERE '||lower(rec_mav.feature_type)||'_id = '||quote_literal(rec_mav.feature_id)||'';

            EXECUTE v_sql INTO v_count;

            IF v_count = 0 THEN

                v_sql =
                'INSERT INTO audit_log_data (fid, feature_id, feature_type, log_message, addparam)
                SELECT 525, '||quote_literal(rec_mav.feature_id)||', '||quote_literal(rec_mav.feature_type)||', 
                ''Non-existing feature_id for this addfield '',
                json_build_object(''parameter_id'', '||quote_literal(rec_mav.parameter_id)||', ''value_param'', '||quote_literal(rec_mav.value_param)||') AS js 
                FROM _man_addfields_value_
                WHERE feature_id = '||quote_literal(rec_mav.feature_id)||' AND parameter_id = '||quote_literal(rec_mav.parameter_id)||'';

                EXECUTE v_sql;

            ELSIF v_count > 0 THEN

                -- check if feature_type of the feature_id of the addfield matches the real feature_type of the object
                v_sql = 'SELECT count(*) FROM vu_'||lower(rec_mav.feature_type)||' 
                        WHERE '||lower(rec_mav.feature_type)||'_id = '||quote_literal(rec_mav.feature_id)||'
                        AND '||lower(rec_mav.feature_type)||'_type  = '||quote_literal(rec_mav.id)||'';

                EXECUTE v_sql INTO v_count;

                IF v_count = 0 THEN

                    v_sql = 'INSERT INTO audit_log_data (fid, feature_id, feature_type, log_message, addparam)
                        SELECT 525, '||quote_literal(rec_mav.feature_id)||', '||quote_literal(rec_mav.feature_type)||', 
                        ''The value of this addfield is related to a different feature_type from the existing feature.'',
                        json_build_object(''parameter_id'', '||quote_literal(rec_mav.parameter_id)||', ''value_param'', '||quote_literal(rec_mav.value_param)||') AS js 
                        FROM _man_addfields_value_
                        WHERE feature_id = '||quote_literal(rec_mav.feature_id)||' AND parameter_id = '||quote_literal(rec_mav.parameter_id)||'';

                    EXECUTE v_sql;

                ELSIF v_count > 0 THEN -- feature_id and feature_type of _man_addfields_value match with an existing object in parent table

                    -- check if man_feature_type table exist (addfield table)
                    v_sql = 'SELECT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_schema = '||quote_literal(v_schemaname)||' 
                    AND table_name = '||quote_literal(v_feature_childtable_name)||')';

                    EXECUTE v_sql INTO exists_record;

                    IF (exists_record) IS FALSE THEN

                        -- create table and one column for each addfield
                        v_sql = 'CREATE TABLE IF NOT EXISTS ' || v_feature_childtable_name || ' (
                                '|| lower(rec_sa.feature_type) || '_id varchar PRIMARY KEY,
                                CONSTRAINT ' || v_feature_childtable_name || '_'|| lower(rec_sa.feature_type) ||'_fk FOREIGN KEY ('|| lower(rec_sa.feature_type) ||'_id) REFERENCES '|| v_schemaname ||'.'|| lower(rec_sa.feature_type) || '('|| lower(rec_sa.feature_type) || '_id) 
                                ON UPDATE CASCADE ON DELETE CASCADE
                            )';

                        EXECUTE v_sql;

                        v_sql = 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || lower(rec_mav.param_name) || ' '||rec_mav.datatype_id||'';

                        EXECUTE v_sql;

                        EXECUTE 'INSERT INTO sys_table (id, descript, sys_role) 
                        VALUES ('||quote_literal(v_feature_childtable_name)||', null, ''role_edit'') ON CONFLICT (id) DO NOTHING;';

                    ELSIF (exists_record) IS TRUE THEN

                        -- check if the corresponding column for the addfield exists in man_table_feature
                        v_sql = 'SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = '||quote_literal(v_schemaname)||' 
                                AND table_name = '||quote_literal(v_feature_childtable_name)||' AND column_name = '||quote_literal(lower(rec_mav.param_name))||')';

                        EXECUTE v_sql INTO v_exists_col;

                        IF v_exists_col IS FALSE THEN

                            v_sql = 'ALTER TABLE ' || v_feature_childtable_name || ' ADD COLUMN ' || lower(rec_mav.param_name) || ' '||rec_mav.datatype_id||'';

                            EXECUTE v_sql;

                        elsif v_exists_col is true then

                            -- check if feature_id exists in man_feature_type table (addfield table)
                            v_sql = 'SELECT count(*) from man_'||lower(rec_mav.feature_type)|| '_' || lower(rec_mav.id)||' 
                                    WHERE '||lower(rec_mav.feature_type)||'_id = '||quote_literal(rec_mav.feature_id)||'';

                            EXECUTE v_sql INTO v_count;

                            IF v_count = 0 THEN

                                v_sql = 'INSERT INTO man_'||lower(rec_mav.feature_type)|| '_' || lower(rec_mav.id)||' ('||lower(rec_mav.feature_type)||'_id) 
                                        VALUES ('||quote_literal(rec_mav.feature_id)||')';

                                EXECUTE v_sql;

                            END IF;

                            -- insert addfields by updating table
                            v_sql = 'UPDATE man_'||lower(rec_mav.feature_type)|| '_' || lower(rec_mav.id)||' 
                                    SET '||rec_mav.param_name||' = '||quote_literal(rec_mav.value_param)||'::'||rec_mav.datatype_id||' 
                                    WHERE '||lower(rec_mav.feature_type)||'_id = '||quote_literal(rec_mav.feature_id)||'';

                            EXECUTE v_sql;

                        END IF;

                    END IF;

                END IF;

            END IF;

        END LOOP;

        -- transfer common addfields
        SELECT count(*) INTO v_count FROM node;

        IF v_count > 0 THEN

            IF v_project_type = 'UD' THEN

                v_partialquery = ' UNION SELECT gully_id AS feature_id, ''GULLY''
                AS sys_type, gully_type AS feature_type FROM vu_gully';

            END IF;

            IF EXISTS (SELECT 1 FROM _man_addfields_value_ mav LEFT JOIN sys_addfields sa ON sa.id = mav.parameter_id WHERE mav.value_param IS NOT NULL) THEN

                FOR rec_feature IN EXECUTE '
                        WITH subq_1 AS (
                        SELECT node_id AS feature_id, ''NODE'' AS sys_type, node_type AS feature_type FROM vu_node UNION 
                        SELECT arc_id AS feature_id, ''ARC'' AS sys_type, arc_type AS feature_type FROM vu_arc UNION 
                        SELECT connec_id AS feature_id, ''CONNEC'' AS sys_type, connec_type AS feature_type FROM vu_connec
                        '||v_partialquery||'),       
                    subq_2 as (
                        SELECT mav.feature_id, mav.value_param, sa.param_name, sa.datatype_id
                        FROM _man_addfields_value_ mav
                        LEFT JOIN sys_addfields sa ON sa.id = mav.parameter_id
                        LEFT JOIN cat_feature cf ON cf.id = sa.cat_feature_id
                        WHERE sa.feature_type = ''ALL'' AND value_param IS NOT NULL
                        ORDER BY sa.param_name
                    )       
                SELECT * FROM subq_2 JOIN subq_1 USING (feature_id)'
                loop
                    v_feature_childtable_name := 'man_' || lower(rec_feature.sys_type) || '_' || lower(rec_feature.feature_type);

                    v_sql := 'UPDATE ' ||v_feature_childtable_name||
                    ' SET '||rec_feature.param_name||' = '||quote_literal(rec_feature.value_param)|| '::' ||rec_feature.datatype_id||
                    ' WHERE  '||lower(rec_feature.sys_type)||'_id = '||quote_literal(rec_feature.feature_id)||'';

                    EXECUTE v_sql;
                END LOOP;
            END IF;
        END IF;

        -- update sys_foreignkey values
        IF EXISTS (SELECT 1 FROM _man_addfields_value_ mav LEFT JOIN sys_addfields sa ON sa.id = mav.parameter_id WHERE mav.value_param IS NOT NULL) THEN
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
        END IF;
    END IF;

	RETURN ('{"status":"Accepted", "message":{"level":"3", "text":"Process done successfully"}, "version":"'||v_version||'"}')::json;

	-- the exception when others need to be disabled because in case of update if it breaks update proces need to be canceled
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;