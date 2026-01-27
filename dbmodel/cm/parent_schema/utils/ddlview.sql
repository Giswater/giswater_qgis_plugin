/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;


-- CAMPAIGN x FEATURE
CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_node as
SELECT
ocn.id,
oc.campaign_id,
ocn.node_id,
ocn.code,
ocn.node_type,
ocn.nodecat_id,
ocn.status,
ocn.admin_observ,
ocn.org_observ,
ocn.the_geom
FROM selector_campaign sc
JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
JOIN om_campaign_x_node ocn ON ocn.campaign_id = oc.campaign_id
WHERE sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_arc as
SELECT
oca.id,
oc.campaign_id,
oca.arc_id,
oca.code,
oca.arc_type,
oca.arccat_id,
oca.status,
oca.admin_observ,
oca.org_observ,
oca.the_geom
FROM selector_campaign sc
JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
JOIN om_campaign_x_arc oca ON oca.campaign_id = oc.campaign_id
WHERE sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_connec as
SELECT
occ.id,
oc.campaign_id,
occ.connec_id,
occ.code,
occ.conneccat_id,
occ.status,
occ.admin_observ,
occ.org_observ,
occ.the_geom
FROM selector_campaign sc
JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
JOIN om_campaign_x_connec occ ON occ.campaign_id = oc.campaign_id
WHERE sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_link AS
SELECT
ocl.id,
oc.campaign_id,
ocl.link_id,
ocl.code,
ocl.linkcat_id,
ocl.status,
ocl.admin_observ,
ocl.org_observ,
ocl.the_geom
FROM selector_campaign sc
JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
JOIN om_campaign_x_link ocl ON ocl.campaign_id = oc.campaign_id
WHERE sc.cur_user = "current_user"()::text;


-- LOT X FEATURE
CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_node as
SELECT
ocln.id,
ocl.lot_id,
ocln.node_id,
ocln.code,
ocln.status,
ocln.org_observ,
ocln.team_observ,
ocln.update_count,
ocln.update_log,
ocln.qindex1,
ocln.qindex2,
ocln.action,
ocn.the_geom
FROM selector_lot sl
JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
JOIN om_campaign_lot_x_node ocln ON ocln.lot_id = ocl.lot_id
JOIN om_campaign_x_node ocn ON ocn.campaign_id = ocl.campaign_id AND ocn.node_id = ocln.node_id
WHERE sl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_arc as
SELECT
ocla.id,
ocl.lot_id,
ocla.arc_id,
ocla.code,
ocla.status,
ocla.org_observ,
ocla.team_observ,
ocla.update_count,
ocla.update_log,
ocla.qindex1,
ocla.qindex2,
ocla.action,
oca.the_geom
FROM selector_lot sl
JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
JOIN om_campaign_lot_x_arc ocla ON ocla.lot_id = ocl.lot_id
JOIN om_campaign_x_arc oca ON oca.campaign_id = ocl.campaign_id AND oca.arc_id = ocla.arc_id
WHERE sl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_connec as
SELECT
oclc.id,
ocl.lot_id,
oclc.connec_id,
oclc.code,
oclc.status,
oclc.org_observ,
oclc.team_observ,
oclc.update_count,
oclc.update_log,
oclc.qindex1,
oclc.qindex2,
oclc.action,
occ.the_geom
FROM selector_lot sl
JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
JOIN om_campaign_lot_x_connec oclc ON oclc.lot_id = ocl.lot_id
JOIN om_campaign_x_connec occ ON occ.campaign_id = ocl.campaign_id AND occ.connec_id = oclc.connec_id
WHERE sl.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_link AS
SELECT
ocll.id,
ocl.lot_id,
ocll.link_id,
ocll.code,
ocll.status,
ocll.org_observ,
ocll.team_observ,
ocll.update_count,
ocll.update_log,
ocll.qindex1,
ocll.qindex2,
ocll.action,
oclink.the_geom
FROM selector_lot sl
JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
JOIN om_campaign_lot_x_link ocll ON ocll.lot_id = ocl.lot_id
JOIN om_campaign_x_link oclink ON oclink.campaign_id = ocl.campaign_id AND oclink.link_id = ocll.link_id
WHERE sl.cur_user = "current_user"()::text;

-- Views UI documents per feature (generated dynamically)

DO $$
DECLARE
  parent_s text := 'PARENT_SCHEMA';
  rec RECORD;
  view_name text;
  doc_table text;
  feature_uuid_col text;
  feature_id_col text;
  trigger_name text;
  v_count int := 0;
  v_query text;
BEGIN
  -- Create doc views per feature based on cat_feature
  -- Only node and arc features have featurecat_id in doc_x_node/doc_x_arc
  -- Use dynamic SQL to query cat_feature from parent schema
  v_query := format('SELECT id, feature_type FROM %I.cat_feature WHERE feature_type IN (''NODE'', ''ARC'')', parent_s);
  
  FOR rec IN EXECUTE v_query
  LOOP
    v_count := v_count + 1;
    view_name := format('v_ui_doc_x_%s', lower(rec.id));
    feature_uuid_col := format('%s_uuid', lower(rec.feature_type));
    feature_id_col := format('%s_id', lower(rec.feature_type));
    
    -- Create view filtering by featurecat_id
    IF rec.feature_type = 'NODE' THEN
      EXECUTE format(
        'CREATE OR REPLACE VIEW cm.%I AS
         SELECT dxn.doc_id,
                dxn.%I,
                d.name,
                d.doc_type,
                d.path,
                d.observ,
                d.date,
                d.user_name,
                dxn.%I,
                dxn.featurecat_id
         FROM cm.doc_x_node dxn
         JOIN cm.doc d ON d.id::text = dxn.doc_id::text
         WHERE dxn.featurecat_id = %L',
        view_name, feature_id_col, feature_uuid_col, rec.id
      );
    ELSIF rec.feature_type = 'ARC' THEN
      EXECUTE format(
        'CREATE OR REPLACE VIEW cm.%I AS
         SELECT dxa.doc_id,
                dxa.%I,
                d.name,
                d.doc_type,
                d.path,
                d.observ,
                d.date,
                d.user_name,
                dxa.%I,
                dxa.featurecat_id
         FROM cm.doc_x_arc dxa
         JOIN cm.doc d ON d.id::text = dxa.doc_id::text
         WHERE dxa.featurecat_id = %L',
        view_name, feature_id_col, feature_uuid_col, rec.id
      );
    END IF;
    
    -- Grant permissions
    EXECUTE format('GRANT ALL ON TABLE cm.%I TO role_cm_manager', view_name);
    EXECUTE format('GRANT ALL ON TABLE cm.%I TO role_cm_field', view_name);
    
    -- Create trigger (passes feature_type and featurecat_id as TG_ARGV[0] and TG_ARGV[1])
    trigger_name := format('gw_trg_ui_doc_x_%s', lower(rec.id));
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON cm.%I', trigger_name, view_name);
    EXECUTE format(
      'CREATE TRIGGER %I
       INSTEAD OF INSERT OR DELETE OR UPDATE
       ON cm.%I
       FOR EACH ROW
       EXECUTE FUNCTION cm.gw_trg_ui_doc(%L, %L)',
      trigger_name, view_name, lower(rec.feature_type), rec.id
    );
  END LOOP;
  
  -- Raise notice if no views were created
  IF v_count = 0 THEN
    RAISE NOTICE 'No doc views created: No features found in %.cat_feature with feature_type IN (''NODE'', ''ARC'')', parent_s;
  ELSE
    RAISE NOTICE 'Created % doc views (v_ui_doc_x_*)', v_count;
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE EXCEPTION 'Error creating doc views in schema %: %', parent_s, SQLERRM;
END
$$;
