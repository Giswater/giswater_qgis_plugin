/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO cat_feature (id, feature_class, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
VALUES('SERVCONNECTION', 'SERVCONNECTION', 'LINK', NULL, 'v_edit_link', 've_link_servconnection', 'Connec link', NULL, true, true, NULL);

INSERT INTO cat_feature_link (id) VALUES ('SERVCONNECTION');

INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",dv_querytext,isenabled,layoutorder,project_type,isparent,feature_field_id,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable)
VALUES ('edit_connec_linkcat_vdefault','config','Value default catalog for link connected to connec','role_edit','Default catalog for linkcat','SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_feature.feature_class = ''SERVCONNECTION''',true,16,'utils',false,'linkcat_id',false,'text','combo',true,'PVC25-PN16-DOM','lyt_connec',true);

INSERT INTO cat_link (id, link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label)
SELECT id, 'SERVCONNECTION' AS link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label
FROM cat_connec ON CONFLICT DO NOTHING;

INSERT INTO cat_link (id, link_type) VALUES ('UPDATE_LINK_40','SERVCONNECTION');

INSERT INTO link (link_id, code, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id, the_geom, created_at, sector_id,
dma_id, fluid_type, presszone_id, dqa_id, minsector_id, expl_id2, epa_type, is_operative, created_by, updated_at, updated_by, staticpressure, linkcat_id,
workcat_id, workcat_id_end, builtdate, enddate, uncertain, muni_id, macrominsector_id, verified, supplyzone_id, n_hydrometer, top_elev1, depth1, top_elev2, depth2)
SELECT nextval('SCHEMA_NAME.urn_id_seq'::regclass), link_id::text, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id, the_geom, tstamp, sector_id,
dma_id, fluid_type, presszone_id, dqa_id, minsector_id, expl_id2, epa_type, is_operative, insert_user, lastupdate, lastupdate_user, staticpressure,
CASE
  WHEN conneccat_id IS NULL THEN
    CASE
      WHEN feature_type = 'CONNEC' THEN
        (SELECT conneccat_id FROM connec WHERE connec_id = feature_id LIMIT 1)
      ELSE
        'UPDATE_LINK_40'
    END
  ELSE conneccat_id
END	AS conneccat_id, workcat_id, workcat_id_end, builtdate, enddate, uncertain, muni_id, macrominsector_id, verified, supplyzone_id, n_hydrometer,
(SELECT c.top_elev FROM connec c WHERE c.connec_id=feature_id LIMIT 1) AS top_elev1,
(SELECT c.depth FROM connec c WHERE c.connec_id = feature_id LIMIT 1) AS depth1,
exit_topelev,
CASE
  WHEN exit_topelev IS NOT NULL AND exit_elev IS NOT NULL THEN
    exit_topelev - exit_elev
  ELSE NULL
END AS depth2
FROM _link;


DO $func$
DECLARE
  connecr record;
BEGIN
  FOR connecr IN (SELECT connec_id, conneccat_id  FROM connec)
  LOOP
    IF NOT EXISTS(SELECT 1 FROM link WHERE feature_id = connecr.connec_id) THEN
      EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831}, "form": {}, "feature": {"id": "[' || connecr.connec_id || ']"},
     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "CONNEC", "linkcatId":"UPDATE_LINK_40"}}$$);';
      UPDATE link SET uncertain=true WHERE feature_id = connecr.connec_id;
    END IF;
  END LOOP;
END $func$;

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('VALVE', 'ELEMENT', 'inp_flwreg_valve', NULL, true);


-- move data from old tables to new tables
INSERT INTO macroexploitation (macroexpl_id, code, "name", descript, lock_level, active, the_geom, updated_at)
SELECT macroexpl_id, macroexpl_id::text, "name", descript, NULL, active, the_geom, now()
FROM _macroexploitation;

INSERT INTO exploitation (expl_id, code, "name", descript, macroexpl_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT expl_id, expl_id::text, "name", descript, macroexpl_id, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _exploitation;

INSERT INTO macrosector (macrosector_id, code, "name", descript, lock_level, active, the_geom, updated_at)
SELECT macrosector_id, macrosector_id::text, "name", descript, NULL, active, the_geom, now()
FROM _macrosector;

INSERT INTO macrodma (macrodma_id, code, "name", descript, expl_id, lock_level, active, the_geom, updated_at)
SELECT macrodma_id, macrodma_id::text, "name", descript, expl_id, NULL, active, the_geom, now()
FROM _macrodma;

INSERT INTO macrodqa (macrodqa_id, code, "name", descript, expl_id, lock_level, active, the_geom, updated_at)
SELECT macrodqa_id, macrodqa_id::text, "name", descript, expl_id, NULL, active, the_geom, now()
FROM _macrodqa;

INSERT INTO dma (dma_id, code, "name", descript, dma_type, muni_id, expl_id, sector_id, macrodma_id, minc, maxc, effc, pattern_id, link, graphconfig, stylesheet, avg_press, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT dma_id, dma_id::text, "name", descript, dma_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], macrodma_id, minc, maxc, effc, pattern_id, link, graphconfig, stylesheet, avg_press, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _dma;

INSERT INTO presszone (presszone_id, code, "name", descript, presszone_type, muni_id, expl_id, sector_id, link, graphconfig, stylesheet, head, avg_press, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT presszone_id, presszone_id::text, "name", descript, presszone_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], link, graphconfig, stylesheet, head, avg_press, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _presszone;

INSERT INTO dqa (dqa_id, code, "name", descript, dqa_type, muni_id, expl_id, sector_id, macrodqa_id, pattern_id, link, graphconfig, stylesheet, avg_press, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT dqa_id, dqa_id::text, "name", descript, dqa_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], macrodqa_id, pattern_id, link, graphconfig, stylesheet, avg_press, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _dqa;

INSERT INTO sector (sector_id, code, descript, "name", sector_type, muni_id, expl_id, macrosector_id, graphconfig, stylesheet, parent_id, pattern_id, avg_press, link, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT sector_id, sector_id::text, descript, "name", sector_type, NULL::int4[], NULL::int4[], NULL, graphconfig, stylesheet, parent_id, pattern_id, avg_press, link, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _sector;

-- supplyzone is new
-- omzone is new

