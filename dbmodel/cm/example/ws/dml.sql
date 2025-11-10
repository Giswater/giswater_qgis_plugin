/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;

-- Review class
INSERT INTO om_reviewclass (id, idval, pschema_id, descript, active) VALUES(1, 'DEPOSITOS', 'PARENT_SCHEMA', 'TEST INSERT', TRUE);
INSERT INTO om_reviewclass (id, idval, pschema_id, descript, active) VALUES(2, 'VALVULAS HIDRAULICAS','PARENT_SCHEMA','TEST INSERT', TRUE);

DO $$
DECLARE
    v_review1 integer;
    v_review2 integer;
    v_objects RECORD;
    v_order integer := 1;
BEGIN
    SELECT id INTO v_review1 FROM om_reviewclass WHERE id = 1;
    SELECT id INTO v_review2 FROM om_reviewclass WHERE id = 2;

    IF v_review1 IS NOT NULL THEN
        FOR v_objects IN
            SELECT id
            FROM PARENT_SCHEMA.cat_feature
            WHERE feature_type ILIKE 'node'
              AND id IN ('TANK')
        LOOP
            INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active)
            VALUES (v_review1, v_objects.id, v_order, TRUE)
            ON CONFLICT DO NOTHING;
            v_order := v_order + 1;
        END LOOP;
    END IF;

    IF v_review2 IS NOT NULL THEN
        v_order := 1;
        FOR v_objects IN
            SELECT id
            FROM PARENT_SCHEMA.cat_feature
            WHERE feature_type ILIKE 'node'
              AND id IN ('PR_SUSTA_VALVE','PR_REDUC_VALVE','PR_BREAK_VALVE','FL_CONTR_VALVE','THROTTLE_VALVE')
        LOOP
            INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active)
            VALUES (v_review2, v_objects.id, v_order, TRUE)
            ON CONFLICT DO NOTHING;
            v_order := v_order + 1;
        END LOOP;
    END IF;
END;
$$;

-- Campaign
INSERT INTO om_campaign (campaign_id, name, active, organization_id, campaign_type, status) values (1, 'Campaign num.1', TRUE, 1, 1, 1);
INSERT INTO om_campaign (campaign_id, name, active, organization_id, campaign_type, status) values (2, 'Campaign num.2', TRUE, 2, 1, 1);

-- Campaign review
INSERT INTO om_campaign_review (campaign_id, reviewclass_id) VALUES(1, 1);
INSERT INTO om_campaign_review (campaign_id, reviewclass_id) VALUES(2, 1);

DO $$
DECLARE
    v_visitclass_id integer;
    v_feature_id text;
BEGIN
    SELECT id INTO v_feature_id
    FROM PARENT_SCHEMA.cat_feature
    WHERE feature_type ILIKE 'node'
    ORDER BY id
    LIMIT 1;

    IF v_feature_id IS NULL THEN
        RAISE NOTICE 'WS sample visit class skipped: no node feature found in catalog.';
        RETURN;
    END IF;

    INSERT INTO om_visitclass (idval, pschema_id, feature_type, descript, active)
    VALUES ('WS NODE VISIT', 'PARENT_SCHEMA', v_feature_id, 'Sample node visit class', TRUE)
    ON CONFLICT (idval) DO NOTHING
    RETURNING id INTO v_visitclass_id;

    IF v_visitclass_id IS NULL THEN
        SELECT id INTO v_visitclass_id FROM om_visitclass WHERE idval = 'WS NODE VISIT';
    END IF;

    INSERT INTO om_campaign_visit (campaign_id, visitclass_id)
    VALUES (1, v_visitclass_id)
    ON CONFLICT DO NOTHING;
END;
$$;

-- Campaign lot
INSERT INTO om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (1, 'Lot num.1', 1, TRUE, 4, 1);
INSERT INTO om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (2, 'Lot num.2', 1, TRUE, 5, 1);
INSERT INTO om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (3, 'Lot num.3', 2, TRUE, 6, 1);
INSERT INTO om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (4, 'Lot num.4', 2, TRUE, 7, 1);
