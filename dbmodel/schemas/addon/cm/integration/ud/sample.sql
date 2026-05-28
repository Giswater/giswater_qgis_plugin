/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DO $$
DECLARE
    v_review_network  integer;
    v_review_surface  integer;
    v_visit_gully     integer;
    v_campaign_net    integer;
    v_campaign_gully  integer;
    v_arc_obj         text;
    v_node_obj        text;
    v_connec_obj      text;
    v_link_obj        text;
    v_gully_obj       text;
BEGIN
    -- Review classes -------------------------------------------------------
    SELECT id INTO v_review_network
    FROM om_reviewclass
    WHERE idval = 'UD NETWORK';

    IF v_review_network IS NULL THEN
        INSERT INTO om_reviewclass (idval, pschema_id, descript, active)
        VALUES ('UD NETWORK', 'PARENT_SCHEMA', 'UD sample review set', TRUE)
        RETURNING id INTO v_review_network;
    END IF;

    SELECT id INTO v_review_surface
    FROM om_reviewclass
    WHERE idval = 'UD SURFACE';

    IF v_review_surface IS NULL THEN
        INSERT INTO om_reviewclass (idval, pschema_id, descript, active)
        VALUES ('UD SURFACE', 'PARENT_SCHEMA', 'Gully-focused review', TRUE)
        RETURNING id INTO v_review_surface;
    END IF;

    -- Review class objects -------------------------------------------------
    SELECT id INTO v_arc_obj
    FROM PARENT_SCHEMA.cat_feature
    WHERE feature_type ILIKE 'arc'
    ORDER BY id LIMIT 1;

    SELECT id INTO v_node_obj
    FROM PARENT_SCHEMA.cat_feature
    WHERE feature_type ILIKE 'node'
    ORDER BY id LIMIT 1;

    SELECT id INTO v_connec_obj
    FROM PARENT_SCHEMA.cat_feature
    WHERE feature_type ILIKE 'connec'
    ORDER BY id LIMIT 1;

    SELECT id INTO v_link_obj
    FROM PARENT_SCHEMA.cat_feature
    WHERE feature_type ILIKE 'link'
    ORDER BY id LIMIT 1;

    SELECT id INTO v_gully_obj
    FROM PARENT_SCHEMA.cat_feature
    WHERE feature_type ILIKE 'gully'
    ORDER BY id LIMIT 1;

    IF v_review_network IS NOT NULL THEN
        IF v_arc_obj IS NOT NULL THEN
            PERFORM 1 FROM om_reviewclass_x_object WHERE reviewclass_id = v_review_network AND object_id = v_arc_obj;
            IF NOT FOUND THEN
            INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active)
            VALUES (v_review_network, v_arc_obj, 1, TRUE);
            END IF;
        END IF;

        IF v_node_obj IS NOT NULL THEN
            PERFORM 1 FROM om_reviewclass_x_object WHERE reviewclass_id = v_review_network AND object_id = v_node_obj;
            IF NOT FOUND THEN
            INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active)
            VALUES (v_review_network, v_node_obj, 2, TRUE);
            END IF;
        END IF;

        IF v_connec_obj IS NOT NULL THEN
            PERFORM 1 FROM om_reviewclass_x_object WHERE reviewclass_id = v_review_network AND object_id = v_connec_obj;
            IF NOT FOUND THEN
            INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active)
            VALUES (v_review_network, v_connec_obj, 3, TRUE);
            END IF;
        END IF;

        IF v_link_obj IS NOT NULL THEN
            PERFORM 1 FROM om_reviewclass_x_object WHERE reviewclass_id = v_review_network AND object_id = v_link_obj;
            IF NOT FOUND THEN
            INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active)
            VALUES (v_review_network, v_link_obj, 4, TRUE);
            END IF;
        END IF;
    END IF;

    IF v_review_surface IS NOT NULL AND v_gully_obj IS NOT NULL THEN
        PERFORM 1 FROM om_reviewclass_x_object WHERE reviewclass_id = v_review_surface AND object_id = v_gully_obj;
        IF NOT FOUND THEN
            INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active)
            VALUES (v_review_surface, v_gully_obj, 1, TRUE);
        END IF;
    END IF;

    -- Visit class ----------------------------------------------------------
    SELECT id INTO v_visit_gully
    FROM om_visitclass
    WHERE idval = 'UD Gully Visit';

    IF v_visit_gully IS NULL THEN
        IF v_gully_obj IS NOT NULL THEN
            INSERT INTO om_visitclass (idval, pschema_id, feature_type, descript, active)
            VALUES ('UD Gully Visit', 'PARENT_SCHEMA', v_gully_obj, 'UD visit template for gullies', TRUE)
            RETURNING id INTO v_visit_gully;
        ELSE
            RAISE NOTICE 'Skipping UD Gully Visit creation: no gully object found in catalog.';
        END IF;
    END IF;

    -- Campaigns ------------------------------------------------------------
    SELECT campaign_id INTO v_campaign_net
    FROM om_campaign
    WHERE name = 'UD Network Inspection';

    IF v_campaign_net IS NULL THEN
        INSERT INTO om_campaign (name, active, organization_id, campaign_type, status)
        VALUES ('UD Network Inspection', TRUE, 1, 1, 1)
        RETURNING campaign_id INTO v_campaign_net;

        IF v_review_network IS NOT NULL THEN
            INSERT INTO om_campaign_review (campaign_id, reviewclass_id)
            VALUES (v_campaign_net, v_review_network)
            ON CONFLICT DO NOTHING;
        END IF;
    END IF;

    SELECT campaign_id INTO v_campaign_gully
    FROM om_campaign
    WHERE name = 'UD Gully Sweep';

    IF v_campaign_gully IS NULL THEN
        INSERT INTO om_campaign (name, active, organization_id, campaign_type, status)
        VALUES ('UD Gully Sweep', TRUE, 1, 2, 1)
        RETURNING campaign_id INTO v_campaign_gully;

        IF v_review_surface IS NOT NULL THEN
            INSERT INTO om_campaign_review (campaign_id, reviewclass_id)
            VALUES (v_campaign_gully, v_review_surface)
            ON CONFLICT DO NOTHING;
        END IF;

        IF v_visit_gully IS NOT NULL THEN
            INSERT INTO om_campaign_visit (campaign_id, visitclass_id)
            VALUES (v_campaign_gully, v_visit_gully)
            ON CONFLICT DO NOTHING;
        END IF;
    END IF;

    -- Campaign lots --------------------------------------------------------
    IF v_campaign_net IS NOT NULL THEN
        INSERT INTO om_campaign_lot (name, campaign_id, active, team_id, status)
        SELECT 'Lot A - Network', v_campaign_net, TRUE, 4, 1
        WHERE NOT EXISTS (
            SELECT 1 FROM om_campaign_lot
            WHERE name = 'Lot A - Network' AND campaign_id = v_campaign_net
        );

        INSERT INTO om_campaign_lot (name, campaign_id, active, team_id, status)
        SELECT 'Lot B - Network', v_campaign_net, TRUE, 5, 1
        WHERE NOT EXISTS (
            SELECT 1 FROM om_campaign_lot
            WHERE name = 'Lot B - Network' AND campaign_id = v_campaign_net
        );
    END IF;

    IF v_campaign_gully IS NOT NULL THEN
        INSERT INTO om_campaign_lot (name, campaign_id, active, team_id, status)
        SELECT 'Lot C - Surface', v_campaign_gully, TRUE, 6, 1
        WHERE NOT EXISTS (
            SELECT 1 FROM om_campaign_lot
            WHERE name = 'Lot C - Surface' AND campaign_id = v_campaign_gully
        );
    END IF;
END;
$$;