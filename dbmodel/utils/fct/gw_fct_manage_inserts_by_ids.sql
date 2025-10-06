/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3516

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_manage_inserts_by_ids(INTEGER, TEXT, TEXT, INTEGER[]);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_manage_inserts_by_ids(
    p_relation_id INTEGER,
    p_relation_type TEXT,
    p_feature_type TEXT,
    p_ids INTEGER[]
)
RETURNS json AS
$BODY$

/*
 * PARAMETERS:
 * * p_relation_id: Relation ID (campaign_id, lot_id, psector_id, element_id, visit_id, etc.) (mandatory)
 * * p_relation_type: Relation type - 'campaign', 'lot', 'psector', 'element', 'visit', etc. (mandatory)
 * * p_feature_type: Feature type - 'node', 'arc', 'connec', 'gully', 'link' (mandatory)
 * * p_ids: Array of feature IDs to insert (mandatory)
 * 
 * RETURNS: JSON object with status and inserted count
 * 
 * EXAMPLE CALLS:
 * * SELECT SCHEMA_NAME.gw_fct_manage_inserts_by_ids(51, 'campaign', 'node', ARRAY[25009, 27022, 27024, 27025, 27026, 27029, 27030]);
 * * SELECT SCHEMA_NAME.gw_fct_manage_inserts_by_ids(101, 'lot', 'connec', ARRAY[5001, 5002]);
 * * SELECT SCHEMA_NAME.gw_fct_manage_inserts_by_ids(201, 'psector', 'node', ARRAY[3001, 3002]);
 * * SELECT SCHEMA_NAME.gw_fct_manage_inserts_by_ids(301, 'element', 'arc', ARRAY[1001, 1002, 1003]);
 * * SELECT SCHEMA_NAME.gw_fct_manage_inserts_by_ids(401, 'visit', 'connec', ARRAY[5001, 5002]);
 * 
 * TABLE MAPPINGS:
 * * campaign -> cm.om_campaign_x_*
 * * lot -> cm.om_campaign_lot_x_*
 * * psector -> plan_psector_x_*
 * * element -> element_x_*
 * * visit -> om_visit_x_*
 */

DECLARE

    v_relation_id INTEGER;
    v_relation_type TEXT;
    v_feature_type TEXT;
    v_ids INTEGER[];
    v_schema_name TEXT;
    v_parent_table TEXT;
    v_cat_table TEXT;
    v_relation_table TEXT;
    v_cat_id_col TEXT;
    v_type_col TEXT;
    v_feature_id_col TEXT;
    v_relation_id_col TEXT;
    v_inserted_count INTEGER := 0;
    v_querytext TEXT;
    v_from_clause TEXT;
    v_select_cols TEXT;
    v_insert_cols TEXT;

BEGIN

    -- set search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get parameters
    v_relation_id := p_relation_id;
    v_relation_type := p_relation_type;
    v_feature_type := p_feature_type;
    v_ids := p_ids;
    v_schema_name := 'SCHEMA_NAME';

    -- Validate inputs
    IF v_relation_id IS NULL THEN
        RAISE EXCEPTION 'Relation ID cannot be null';
    END IF;

    IF v_relation_type IS NULL OR v_relation_type = '' THEN
        RAISE EXCEPTION 'Relation type cannot be null or empty';
    END IF;

    IF v_feature_type IS NULL OR v_feature_type = '' THEN
        RAISE EXCEPTION 'Feature type cannot be null or empty';
    END IF;

    IF v_ids IS NULL OR array_length(v_ids, 1) IS NULL THEN
        RAISE EXCEPTION 'Feature IDs array cannot be null or empty';
    END IF;

    -- Validate feature type
    IF v_feature_type NOT IN ('node', 'arc', 'connec', 'gully', 'link') THEN
        RAISE EXCEPTION 'Invalid feature type: %. Must be one of: node, arc, connec, gully, link', v_feature_type;
    END IF;

    -- Set table names and column mappings based on feature type and relation type
    v_parent_table := v_schema_name || '.' || v_feature_type;
    
    -- Handle different table naming patterns for each relation type
    IF v_relation_type = 'campaign' THEN
        v_relation_table := 'cm.om_campaign_x_' || v_feature_type;
    ELSIF v_relation_type = 'lot' THEN
        v_relation_table := 'cm.om_campaign_lot_x_' || v_feature_type;
    ELSIF v_relation_type = 'psector' THEN
        v_relation_table := 'plan_psector_x_' || v_feature_type;
    ELSIF v_relation_type = 'element' THEN
        v_relation_table := 'element_x_' || v_feature_type;
    ELSIF v_relation_type = 'visit' THEN
        v_relation_table := 'om_visit_x_' || v_feature_type;
    ELSE
        RAISE EXCEPTION 'Unsupported relation type: %', v_relation_type;
    END IF;
    
    v_feature_id_col := v_feature_type || '_id';
    v_relation_id_col := v_relation_type || '_id';

    -- Configure columns based on feature type
    v_cat_id_col := v_feature_type || 'cat_id';
    v_type_col := v_feature_type || '_type';

    if v_feature_type IN('connec', 'link') THEN
        v_type_col := NULL;
    END IF;


    -- Build FROM clause based on relation type
    IF v_relation_type = 'campaign' AND v_type_col IS NOT NULL THEN
        -- Campaign tables need cat table join for type information
        v_cat_table := v_schema_name || '.cat_' || v_feature_type;
        v_from_clause := 'FROM ' || v_parent_table || ' p JOIN ' || v_cat_table || ' c ON p.' || v_cat_id_col || ' = c.id';
    ELSE
        -- Other relation types (lot, psector, element, visit) don't need cat table join
        v_from_clause := 'FROM ' || v_parent_table || ' p';
    END IF;

    -- Build SELECT and INSERT columns based on relation type
    -- Campaign tables have the_geom and cat columns, lot/psector/element/visit tables have different structures
    IF v_relation_type = 'campaign' THEN
        -- Campaign tables: relation_id, feature_id, status, the_geom, cat_id, type
        v_select_cols := v_relation_id || ', p.' || v_feature_id_col || ', 1, p.the_geom, p.' || v_cat_id_col;
        IF v_type_col IS NOT NULL THEN
            v_select_cols := v_select_cols || ', c.' || v_type_col;
        ELSE
            v_select_cols := v_select_cols || ', NULL';
        END IF;
        
        -- Add extra columns for arc features
        IF v_feature_type = 'arc' THEN
            v_select_cols := v_select_cols || ', p.node_1, p.node_2';
        END IF;
        
        -- Build INSERT columns for campaign
        v_insert_cols := v_relation_id_col || ', ' || v_feature_id_col || ', status, the_geom, ' || v_cat_id_col || ', ' || COALESCE(v_type_col, 'NULL');
        IF v_feature_type = 'arc' THEN
            v_insert_cols := v_insert_cols || ', node_1, node_2';
        END IF;
        
    ELSIF v_relation_type = 'lot' THEN
        -- Lot tables: relation_id, feature_id, code, status (no the_geom, no cat columns)
        v_select_cols := v_relation_id || ', p.' || v_feature_id_col || ', p.code, 1';
        
        -- Add extra columns for arc features
        IF v_feature_type = 'arc' THEN
            v_select_cols := v_select_cols || ', p.node_1, p.node_2';
        END IF;
        
        -- Build INSERT columns for lot
        v_insert_cols := v_relation_id_col || ', ' || v_feature_id_col || ', code, status';
        IF v_feature_type = 'arc' THEN
            v_insert_cols := v_insert_cols || ', node_1, node_2';
        END IF;
        
    ELSIF v_relation_type = 'psector' THEN
        -- Psector tables: special logic for connec/gully vs other features
        IF v_feature_type IN ('connec', 'gully') THEN
            -- Connec/gully: psector_id, feature_id, state (state=1)
            v_select_cols := v_relation_id || ', p.' || v_feature_id_col || ', 1';
            v_insert_cols := v_relation_id_col || ', ' || v_feature_id_col || ', state';
        ELSE
            -- Other features: psector_id, feature_id only
            v_select_cols := v_relation_id || ', p.' || v_feature_id_col;
            v_insert_cols := v_relation_id_col || ', ' || v_feature_id_col;
        END IF;
        
    ELSE
        -- Other relation types (element, visit): just relation_id, feature_id
        v_select_cols := v_relation_id || ', p.' || v_feature_id_col;
        v_insert_cols := v_relation_id_col || ', ' || v_feature_id_col;
    END IF;

    -- Build and execute the insert query
    v_querytext := '
        WITH features AS (
            SELECT unnest($1) AS id
        )
        INSERT INTO ' || v_relation_table || ' (' || v_insert_cols || ')
        SELECT ' || v_select_cols || '
        ' || v_from_clause || '
        WHERE EXISTS (SELECT 1 FROM features WHERE features.id = p.' || v_feature_id_col || ')
        ON CONFLICT (' || v_relation_id_col || ', ' || v_feature_id_col || ') DO NOTHING';

    -- Execute the query and get the count of inserted rows
    RAISE NOTICE 'Executing query for % features', array_length(v_ids, 1);
    EXECUTE v_querytext USING v_ids;
    GET DIAGNOSTICS v_inserted_count = ROW_COUNT;
    RAISE NOTICE 'Inserted % records', v_inserted_count;

    -- Return JSON object with status and inserted count
    RETURN json_build_object(
        'status', 'Accepted',
        'message', 'Records inserted successfully',
        'body', json_build_object(
            'data', json_build_object(
                'inserted_count', v_inserted_count,
                'relation_type', v_relation_type,
                'feature_type', v_feature_type
            )
        )
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in gw_fct_manage_inserts_by_ids: %', SQLERRM;

END;
$BODY$
LANGUAGE plpgsql;
