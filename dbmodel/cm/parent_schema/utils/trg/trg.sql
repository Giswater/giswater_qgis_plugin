/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS trg_validate_campaign_x_arc_feature ON "SCHEMA_NAME".om_campaign_x_arc;
CREATE TRIGGER trg_validate_campaign_x_arc_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_arc
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('arc');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_node_feature ON "SCHEMA_NAME".om_campaign_x_node;
CREATE TRIGGER trg_validate_campaign_x_node_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_node
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('node');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_connec_feature ON "SCHEMA_NAME".om_campaign_x_connec;
CREATE TRIGGER trg_validate_campaign_x_connec_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_connec
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('connec');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_link_feature ON "SCHEMA_NAME".om_campaign_x_link;
CREATE TRIGGER trg_validate_campaign_x_link_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_link
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('link');

DROP TRIGGER IF EXISTS trg_edit_view_campaign_node ON ve_PARENT_SCHEMA_camp_node;
CREATE TRIGGER trg_edit_view_campaign_node INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('node');

DROP TRIGGER IF EXISTS trg_edit_view_campaign_arc ON ve_PARENT_SCHEMA_camp_arc;
CREATE TRIGGER trg_edit_view_campaign_arc INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('arc');

DROP TRIGGER IF EXISTS trg_edit_view_campaign_connec ON ve_PARENT_SCHEMA_camp_connec;
CREATE TRIGGER trg_edit_view_campaign_connec INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('connec');

DROP TRIGGER IF EXISTS trg_edit_view_campaign_link ON ve_PARENT_SCHEMA_camp_link;
CREATE TRIGGER trg_edit_view_campaign_link INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('link');

DROP TRIGGER IF EXISTS trg_edit_view_lot_node ON ve_PARENT_SCHEMA_lot_node;
CREATE TRIGGER trg_edit_view_lot_node INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_lot_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign_lot('node');

DROP TRIGGER IF EXISTS trg_edit_view_lot_arc ON ve_PARENT_SCHEMA_lot_arc;
CREATE TRIGGER trg_edit_view_lot_arc INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_lot_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign_lot('arc');

DROP TRIGGER IF EXISTS trg_edit_view_lot_connec ON ve_PARENT_SCHEMA_lot_connec;
CREATE TRIGGER trg_edit_view_lot_connec INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_lot_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign_lot('connec');

DROP TRIGGER IF EXISTS trg_edit_view_lot_link ON ve_PARENT_SCHEMA_lot_link;
CREATE TRIGGER trg_edit_view_lot_link INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_lot_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign_lot('link');

DROP TRIGGER IF EXISTS trg_lot_x_node_feature ON "SCHEMA_NAME".om_campaign_lot_x_node;
CREATE TRIGGER trg_lot_x_node_feature AFTER INSERT ON "SCHEMA_NAME".om_campaign_lot_x_node
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature('node');

DROP TRIGGER IF EXISTS trg_lot_x_arc_feature ON "SCHEMA_NAME".om_campaign_lot_x_arc;
CREATE TRIGGER trg_lot_x_arc_feature AFTER INSERT ON "SCHEMA_NAME".om_campaign_lot_x_arc
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature('arc');

DROP TRIGGER IF EXISTS trg_lot_x_connec_feature ON "SCHEMA_NAME".om_campaign_lot_x_connec;
CREATE TRIGGER trg_lot_x_connec_feature AFTER INSERT ON "SCHEMA_NAME".om_campaign_lot_x_connec
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature('connec');

DROP TRIGGER IF EXISTS trg_lot_x_link_feature ON "SCHEMA_NAME".om_campaign_lot_x_link;
CREATE TRIGGER trg_lot_x_link_feature AFTER INSERT ON "SCHEMA_NAME".om_campaign_lot_x_link
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature('link');

DROP TRIGGER IF EXISTS trg_validate_lot_x_arc_feature ON "SCHEMA_NAME".om_campaign_lot_x_arc;
CREATE TRIGGER trg_validate_lot_x_arc_feature BEFORE INSERT OR UPDATE ON "SCHEMA_NAME".om_campaign_lot_x_arc
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature_check_campaign('arc');

DROP TRIGGER IF EXISTS trg_validate_lot_x_node_feature ON "SCHEMA_NAME".om_campaign_lot_x_node;
CREATE TRIGGER trg_validate_lot_x_node_feature BEFORE INSERT OR UPDATE ON "SCHEMA_NAME".om_campaign_lot_x_node
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature_check_campaign('node');

DROP TRIGGER IF EXISTS trg_validate_lot_x_connec_feature ON "SCHEMA_NAME".om_campaign_lot_x_connec;
CREATE TRIGGER trg_validate_lot_x_connec_feature BEFORE INSERT OR UPDATE ON "SCHEMA_NAME".om_campaign_lot_x_connec
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature_check_campaign('connec');

DROP TRIGGER IF EXISTS trg_validate_lot_x_link_feature ON "SCHEMA_NAME".om_campaign_lot_x_link;
CREATE TRIGGER trg_validate_lot_x_link_feature BEFORE INSERT OR UPDATE ON "SCHEMA_NAME".om_campaign_lot_x_link
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature_check_campaign('link');

DO $$
DECLARE
    rec record;
    view_name text;
    trigger_name text;
    feature_type text;
BEGIN
    FOR rec IN
        SELECT id FROM PARENT_SCHEMA.cat_feature
    LOOP
        feature_type := lower(rec.id);
        
        -- Conditional for gully, same as before
        IF feature_type = 'gully' AND 'PARENT_TYPE' <> 'ud' THEN
            CONTINUE;
        END IF;

        -- Construct the view name exactly as in ddl.sql
        view_name := 've_' || 'PARENT_SCHEMA' || '_lot_' || feature_type;
        trigger_name := 'trg_PARENT_SCHEMA_edit_lot_' || feature_type;

        EXECUTE
        'CREATE OR REPLACE TRIGGER ' || trigger_name || ' INSTEAD OF
        INSERT OR DELETE OR UPDATE
        ON ' || 'SCHEMA_NAME' || '.' || view_name ||' FOR EACH ROW EXECUTE FUNCTION '||'SCHEMA_NAME'||'.cm_trg_edit_feature()';
    END LOOP;
END
$$;

-- Create triggers for log in the tables
DO $$
DECLARE
    rec record;
    trigger_name text;
    feature_type text;
    mission_type text;
    mission_id_column text;
    has_lot_id boolean;
    has_campaign_id boolean;
BEGIN
    -- Triggers for parent schema tables (e.g., junio06_ws_adaptation)
    FOR rec IN
        SELECT
            t.table_name,
            cf.feature_type
        FROM
            information_schema.tables t
        JOIN
            PARENT_SCHEMA.cat_feature cf ON t.table_name = 'PARENT_SCHEMA' || '_' || lower(cf.id)
        WHERE
            t.table_schema = 'SCHEMA_NAME'
    LOOP
        -- Check for lot_id column
        SELECT EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'SCHEMA_NAME' AND table_name = rec.table_name AND column_name = 'lot_id'
        ) INTO has_lot_id;

        -- Check for campaign_id column
        SELECT EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'SCHEMA_NAME' AND table_name = rec.table_name AND column_name = 'campaign_id'
        ) INTO has_campaign_id;

        feature_type := lower(rec.feature_type);
        trigger_name := 'trg_log_' || rec.table_name;
        mission_type := NULL;
        mission_id_column := NULL;

        IF has_lot_id THEN
            mission_type := 'lot';
            mission_id_column := 'lot_id';
        ELSIF has_campaign_id THEN
            mission_type := 'campaign';
            mission_id_column := 'campaign_id';
        END IF;

        IF mission_type IS NOT NULL THEN
            EXECUTE format(
                'CREATE OR REPLACE TRIGGER %I ' ||
                'AFTER INSERT OR UPDATE OR DELETE ON %I.%I ' ||
                'FOR EACH ROW EXECUTE PROCEDURE %I.gw_trg_log_cm(%L, %L, %L)',
                trigger_name, 'SCHEMA_NAME', rec.table_name, 'SCHEMA_NAME', feature_type, mission_type, mission_id_column
            );
        END IF;
    END LOOP;

    -- Triggers for om_campaign_x_ tables
    FOR rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'SCHEMA_NAME' AND table_name LIKE 'om_campaign_x_%'
    LOOP
        feature_type := split_part(rec.table_name, '_x_', 2);
        trigger_name := 'trg_log_' || rec.table_name;
        mission_type := 'campaign';
        mission_id_column := 'campaign_id';

        EXECUTE format(
            'CREATE OR REPLACE TRIGGER %I ' ||
            'AFTER INSERT OR UPDATE OR DELETE ON %I.%I ' ||
            'FOR EACH ROW EXECUTE PROCEDURE %I.gw_trg_log_cm(%L, %L, %L)',
            trigger_name, 'SCHEMA_NAME', rec.table_name, 'SCHEMA_NAME', feature_type, mission_type, mission_id_column
        );
    END LOOP;

    -- Triggers for om_campaign_lot_x_ tables
    FOR rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'SCHEMA_NAME' AND table_name LIKE 'om_campaign_lot_x_%'
    LOOP
        feature_type := split_part(rec.table_name, '_x_', 2);
        trigger_name := 'trg_log_' || rec.table_name;
        mission_type := 'lot';
        mission_id_column := 'lot_id';

        EXECUTE format(
            'CREATE OR REPLACE TRIGGER %I ' ||
            'AFTER INSERT OR UPDATE OR DELETE ON %I.%I ' ||
            'FOR EACH ROW EXECUTE PROCEDURE %I.gw_trg_log_cm(%L, %L, %L)',
            trigger_name, 'SCHEMA_NAME', rec.table_name, 'SCHEMA_NAME', feature_type, mission_type, mission_id_column
        );
    END LOOP;
END
$$;