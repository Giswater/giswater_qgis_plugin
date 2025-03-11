/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3358

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_transfer_cat_material();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_transfer_cat_material()
  RETURNS json AS
$BODY$


/* EXAMPLE
    This function is used to transfer the catalog of materials from the old version to the new version of the database.

    The function is called in the updates of the database, when is completed the materials catalog is transferred to the new version, passing
    from 3/4 tables to 1 table.

    SELECT * FROM SCHEMA_NAME.gw_fct_admin_transfer_cat_material();
*/

DECLARE

    v_schemaname text;
    v_project_type text;
    v_version text;
    v_querytext text;

    v_table text;
    v_base_table text = 'cat_mat_';
    v_table_name text;
    v_cat_material text = 'cat_material';

    v_list text[];
    rec record;
    v_feature_type text[];
	v_link TEXT;

BEGIN
	-- Set the search_path
    SET search_path = "SCHEMA_NAME", public;
    v_schemaname := 'SCHEMA_NAME';

    -- Get the project type and version
    SELECT UPPER(project_type), giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    IF v_project_type = 'UD' THEN
        v_list := ARRAY['ARC', 'NODE', 'ELEMENT', 'GRATE', 'GULLY'];
    ELSE
        v_list := ARRAY['ARC', 'NODE', 'ELEMENT'];
    END IF;

    FOR v_table IN SELECT UNNEST(v_list) LOOP
        v_table_name := v_base_table || LOWER(v_table); -- e.g., cat_mat_arc, cat_mat_node, etc.

        FOR rec IN EXECUTE 'SELECT * FROM ' || v_table_name LOOP
            -- Check if an existing record in cat_material exists with the same id and get the feature_type
            v_querytext := 'SELECT feature_type, v_link FROM ' || v_cat_material || ' WHERE id = ' || quote_literal(rec.id);
			RAISE NOTICE 'v_querytext: %', v_querytext;
            EXECUTE v_querytext INTO v_feature_type, v_link;

            IF v_feature_type IS NULL THEN
				RAISE NOTICE 'v_feature_type es null: %', v_feature_type;

                -- If no record exists, initialize feature_type with the current table
                v_feature_type := ARRAY[v_table];
				RAISE NOTICE 'v_feature_type actualizado: %', v_feature_type;

                v_querytext := 'INSERT INTO ' || v_cat_material ||
                               ' (id, descript, feature_type, featurecat_id, link, active) ' ||
                               'VALUES(' || quote_literal(rec.id) || ', ' || quote_literal(rec.descript) ||
                               ', ' || quote_literal(v_feature_type) || ', NULL, ' ||
                               quote_nullable(rec.link) || ', ' || quote_nullable(rec.active) || ')';
				RAISE NOTICE 'v_querytext: %', v_querytext;
                EXECUTE v_querytext;

                -- For UD project type and 'arc' table, add the 'n' column
                IF v_project_type = 'UD' AND v_table = 'ARC' THEN
                    v_querytext := 'UPDATE ' || v_cat_material ||
                                   ' SET n = ' || rec.n || ' WHERE id = ' || quote_literal(rec.id);
					RAISE NOTICE 'v_querytext: %', v_querytext;
                    EXECUTE v_querytext;
                END IF;
            ELSE
				RAISE NOTICE 'v_feature_type no es null: %', v_feature_type;
                -- If a record exists, add the current table to the feature_type array
                v_feature_type := v_feature_type || v_table;

                v_querytext := 'UPDATE ' || v_cat_material ||
                               ' SET feature_type = ' || quote_nullable(v_feature_type) ||
                               ' WHERE id = ' || quote_literal(rec.id);
                EXECUTE v_querytext;

                -- For UD project type and 'arc' table, update the 'n' column
                IF v_project_type = 'UD' AND v_table = 'ARC' THEN
                    v_querytext := 'UPDATE ' || v_cat_material ||
                                   ' SET n = ' || rec.n || ' WHERE id = ' || quote_literal(rec.id);
                    EXECUTE v_querytext;
                END IF;
            END IF;

        END LOOP;
    END LOOP;

    RETURN ('{"status":"Accepted", "message":{"level":"3", "text":"Process of transfer cat_material done successfully"}, "version":"' || v_version || '"}')::json;

EXCEPTION
    WHEN OTHERS THEN
        -- Error handling
        RETURN json_build_object(
            'status', 'Failed',
            'message', json_build_object('level', 'ERROR', 'text', SQLERRM),
            'SQLSTATE', SQLSTATE
        );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;