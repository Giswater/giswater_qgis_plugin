/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/24
CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT distinct on (link_id) a.link_id,
    a.feature_type,
    a.feature_id,
    a.exit_type,
    a.exit_id,
    a.sector_id,
    a.macrosector_id,
    a.dma_id,
    a.macrodma_id,
    a.expl_id,
    a.state,
    a.gis_length,
    a.userdefined_geom,
    a.the_geom,
    a.ispsectorgeom,
    a.psector_rowid
   FROM ( SELECT link.link_id,
            link.feature_type,
            link.feature_id,
            link.exit_type,
            link.exit_id,
            arc.sector_id,
            sector.macrosector_id,
            arc.dma_id,
            dma.macrodma_id,
            arc.expl_id,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN link.state
                    ELSE plan_psector_x_connec.state
                END AS state,
            st_length2d(link.the_geom) AS gis_length,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN link.userdefined_geom
                    ELSE plan_psector_x_connec.userdefined_geom
                END AS userdefined_geom,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN link.the_geom
                    ELSE plan_psector_x_connec.link_geom
                END AS the_geom,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN NULL::integer
                    ELSE plan_psector_x_connec.id
                END AS psector_rowid
           FROM link
             LEFT JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
             LEFT JOIN arc USING (arc_id)
             JOIN sector ON sector.sector_id::text = arc.sector_id::text
             JOIN dma ON dma.dma_id::text = arc.dma_id::text
             LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
          WHERE link.feature_id::text = v_state_connec.connec_id::text) a
  WHERE a.state < 2;
  
  
DROP VIEW v_ui_anl_mincut_result_cat;

CREATE OR REPLACE VIEW v_ui_anl_mincut_result_cat AS 
 SELECT anl_mincut_result_cat.id,
    anl_mincut_result_cat.id AS name,
    anl_mincut_result_cat.work_order,
    anl_mincut_cat_state.name AS state,
    anl_mincut_cat_class.name AS class,
    anl_mincut_result_cat.mincut_type,
    anl_mincut_result_cat.received_date,
    exploitation.name AS exploitation,
    ext_municipality.name AS municipality,
    anl_mincut_result_cat.postcode,
    ext_streetaxis.name AS streetaxis,
    anl_mincut_result_cat.postnumber,
    anl_mincut_result_cat.anl_cause,
    anl_mincut_result_cat.anl_tstamp,
    anl_mincut_result_cat.anl_user,
    anl_mincut_result_cat.anl_descript,
    anl_mincut_result_cat.anl_feature_id,
    anl_mincut_result_cat.anl_feature_type,
    anl_mincut_result_cat.forecast_start,
    anl_mincut_result_cat.forecast_end,
    cat_users.name AS assigned_to,
    anl_mincut_result_cat.exec_start,
    anl_mincut_result_cat.exec_end,
    anl_mincut_result_cat.exec_user,
    anl_mincut_result_cat.exec_descript,
    anl_mincut_result_cat.exec_from_plot,
    anl_mincut_result_cat.exec_depth,
    anl_mincut_result_cat.exec_appropiate,
    anl_mincut_result_cat.notified,
    output
   FROM anl_mincut_result_cat
     LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = anl_mincut_result_cat.mincut_class
     LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = anl_mincut_result_cat.mincut_state
     LEFT JOIN exploitation ON exploitation.expl_id = anl_mincut_result_cat.expl_id
     LEFT JOIN macroexploitation ON macroexploitation.macroexpl_id = anl_mincut_result_cat.macroexpl_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = anl_mincut_result_cat.muni_id
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = anl_mincut_result_cat.streetaxis_id::text
     LEFT JOIN cat_users ON cat_users.id::text = anl_mincut_result_cat.assigned_to::text
     WHERE anl_mincut_result_cat.id >0;