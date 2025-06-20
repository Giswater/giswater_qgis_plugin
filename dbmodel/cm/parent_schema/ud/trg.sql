/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;


DROP TRIGGER IF EXISTS trg_lot_x_gully_feature ON cm.om_campaign_lot_x_gully;
CREATE TRIGGER trg_lot_x_gully_feature AFTER INSERT OR DELETE OR UPDATE ON cm.om_campaign_lot_x_gully
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_cm_lot_x_feature('gully');

DROP TRIGGER IF EXISTS trg_validate_lot_x_gully_feature ON cm.om_campaign_lot_x_gully;
CREATE TRIGGER trg_validate_lot_x_gully_feature BEFORE INSERT OR UPDATE ON cm.om_campaign_lot_x_gully
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_cm_lot_x_feature_check_campaign('gully');

DROP TRIGGER IF EXISTS trg_update_action_gully ON cm.om_campaign_lot_x_gully;
CREATE TRIGGER trg_update_action_gully BEFORE INSERT OR UPDATE ON cm.om_campaign_lot_x_gully
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_update_lot_action(); 

DO $$
DECLARE
    v_rec record;
    v_view_name text;
    v_trigger_name text;
    v_feature_type text;
BEGIN
    FOR v_rec IN
        SELECT id FROM PARENT_SCHEMA.cat_feature WHERE feature_type = 'GULLY'
    LOOP
        v_feature_type := lower(v_rec.id);
        -- Construct the view name exactly as in ddl.sql
        v_view_name := 've_' || 'PARENT_SCHEMA' || '_lot_' || v_feature_type;
        v_trigger_name := 'trg_PARENT_SCHEMA_edit_lot_' || v_feature_type;

        EXECUTE
        'CREATE OR REPLACE TRIGGER ' || v_trigger_name || ' INSTEAD OF
        INSERT OR DELETE OR UPDATE
        ON cm.' || v_view_name ||' FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_cm_edit_feature()';
    END LOOP;
END
$$;
