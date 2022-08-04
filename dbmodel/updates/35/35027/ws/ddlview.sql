/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/11
CREATE OR REPLACE VIEW v_om_waterbalance AS 
 SELECT e.name AS exploitation,
    d.name AS dma,
    p.code AS period,
    (COALESCE(om_waterbalance.auth_bill_met_export, 0::double precision) + COALESCE(om_waterbalance.auth_bill_met_hydro, 0::double precision) + COALESCE(om_waterbalance.auth_bill_unmet, 0::double precision))::numeric(12,2) AS auth_bill,
    (COALESCE(om_waterbalance.auth_unbill_met, 0::double precision) + COALESCE(om_waterbalance.auth_unbill_unmet, 0::double precision) + COALESCE(om_waterbalance.loss_app_unath, 0::double precision))::numeric(12,2) AS auth_unbill,
    (COALESCE(om_waterbalance.loss_app_met_error, 0::double precision) + COALESCE(om_waterbalance.loss_app_data_error, 0::double precision))::numeric(12,2) AS loss_app,
    (COALESCE(om_waterbalance.loss_real_leak_main, 0::double precision) + COALESCE(om_waterbalance.loss_real_leak_service, 0::double precision) + COALESCE(om_waterbalance.loss_real_storage, 0::double precision))::numeric(12,2) AS loss_real,
    COALESCE(om_waterbalance.total_sys_input, 0::double precision) AS total,
    d.the_geom
   FROM om_waterbalance
     JOIN exploitation e USING (expl_id)
     JOIN dma d USING (dma_id)
     JOIN ext_cat_period p ON p.id::text = om_waterbalance.cat_period_id::text;


CREATE OR REPLACE VIEW v_om_waterbalance_loss AS 
 SELECT v_om_waterbalance.exploitation,
    v_om_waterbalance.dma,
    v_om_waterbalance.period,
    v_om_waterbalance.total,
    (v_om_waterbalance.auth_bill + v_om_waterbalance.auth_unbill)::numeric(12,2) AS auth,
    (v_om_waterbalance.total - v_om_waterbalance.auth_bill::double precision - v_om_waterbalance.auth_unbill::double precision)::numeric(12,2) AS loss,
        CASE
            WHEN v_om_waterbalance.total > 0::double precision THEN ((100::numeric * (v_om_waterbalance.auth_bill + v_om_waterbalance.auth_unbill))::double precision / v_om_waterbalance.total)::numeric(12,2)
            ELSE 0::numeric(12,2)
        END AS eff,
		the_geom
   FROM v_om_waterbalance;
   
   
   CREATE OR REPLACE VIEW v_om_waterbalance_nrw AS 
 SELECT v_om_waterbalance.exploitation,
    v_om_waterbalance.dma,
    v_om_waterbalance.period,
    v_om_waterbalance.total,
    v_om_waterbalance.auth_bill AS rw,
    (v_om_waterbalance.total - v_om_waterbalance.auth_bill::double precision)::numeric(12,2) AS nrw,
        CASE
            WHEN v_om_waterbalance.total > 0::double precision THEN ((100::numeric * v_om_waterbalance.auth_bill)::double precision / v_om_waterbalance.total)::numeric(12,2)
            ELSE 0::numeric(12,2)
        END AS eff,
	the_geom
   FROM v_om_waterbalance;

DROP VIEW vi_parent_dma;
CREATE OR REPLACE VIEW vi_parent_dma AS 
 SELECT DISTINCT ON (dma.dma_id) dma.dma_id,
    dma.name,
    dma.expl_id,
    dma.macrodma_id,
    dma.descript,
    dma.undelete,
    dma.minc,
    dma.maxc,
    dma.effc,
    dma.pattern_id,
    dma.link,
    dma.graphconfig,
    dma.the_geom
   FROM dma
     JOIN vi_parent_arc USING (dma_id);

DROP VIEW v_edit_sector;
CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.graphconfig::text AS graphconfig,
    sector.stylesheet::text AS stylesheet,
    sector.active,
    sector.parent_id,
    sector.pattern_id
   FROM selector_sector,
    sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

DROP VIEW v_edit_dma;
  CREATE OR REPLACE VIEW v_edit_dma AS 
 SELECT dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.descript,
    dma.the_geom,
    dma.undelete,
    dma.expl_id,
    dma.pattern_id,
    dma.link,
    dma.minc,
    dma.maxc,
    dma.effc,
    dma.graphconfig::text AS graphconfig,
    dma.stylesheet::text AS stylesheet,
    dma.active
   FROM selector_expl,
    dma
  WHERE dma.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

DROP VIEW v_edit_presszone;
CREATE OR REPLACE VIEW v_edit_presszone AS 
 SELECT presszone.presszone_id,
    presszone.name,
    presszone.expl_id,
    presszone.the_geom,
    presszone.graphconfig::text AS graphconfig,
    presszone.head,
    presszone.stylesheet::text AS stylesheet,
    presszone.active
   FROM selector_expl,
    presszone
  WHERE presszone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW v_edit_dqa;
CREATE OR REPLACE VIEW v_edit_dqa AS 
 SELECT dqa.dqa_id,
    dqa.name,
    dqa.expl_id,
    dqa.macrodqa_id,
    dqa.descript,
    dqa.undelete,
    dqa.the_geom,
    dqa.pattern_id,
    dqa.dqa_type,
    dqa.link,
    dqa.graphconfig::text AS graphconfig,
    dqa.stylesheet::text AS stylesheet,
    dqa.active
   FROM selector_expl,
    dqa
  WHERE dqa.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW v_edit_cat_feature_node;
CREATE OR REPLACE VIEW v_edit_cat_feature_node AS 
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_node.epa_default,
    cat_feature_node.isarcdivide,
    cat_feature_node.isprofilesurface,
    cat_feature_node.choose_hemisphere,
    cat_feature.code_autofill,
    cat_feature_node.double_geom::text AS double_geom,
    cat_feature_node.num_arcs,
    cat_feature_node.graph_delimiter AS graph_delimiter,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_node USING (id);

ALTER VIEW v_anl_grafanalytics_mapzones RENAME TO v_anl_graphanalytics_mapzones;