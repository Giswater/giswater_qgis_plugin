/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_rpt_comp_arc
AS WITH main AS (
         SELECT r.arc_id,
            r.result_id,
            r.arc_type,
            r.sector_id,
            r.arccat_id,
            r.flow_max,
            r.flow_min,
            r.flow_avg,
            r.vel_max,
            r.vel_min,
            r.vel_avg,
            r.headloss_max,
            r.headloss_min,
            r.setting_max,
            r.setting_min,
            r.reaction_max,
            r.reaction_min,
            r.ffactor_max,
            r.ffactor_min,
            arc.diameter,
            r.the_geom
           FROM rpt_arc_stats r
             JOIN selector_rpt_main s ON s.result_id::text = r.result_id::text
           	 LEFT JOIN rpt_inp_arc arc ON arc.arc_id::text = r.arc_id::TEXT AND arc.result_id = s.result_id 
          WHERE s.cur_user = CURRENT_USER
        ), compare AS (
         SELECT r.arc_id,
            r.result_id,
            r.arc_type,
            r.sector_id,
            r.arccat_id,
            r.flow_max,
            r.flow_min,
            r.flow_avg,
            r.vel_max,
            r.vel_min,
            r.vel_avg,
            r.headloss_max,
            r.headloss_min,
            r.setting_max,
            r.setting_min,
            r.reaction_max,
            r.reaction_min,
            r.ffactor_max,
            r.ffactor_min,
            arc.diameter,
            r.the_geom
            FROM rpt_arc_stats r
             JOIN selector_rpt_compare s ON s.result_id::text = r.result_id::text
           	 LEFT JOIN rpt_inp_arc arc ON arc.arc_id::text = r.arc_id::TEXT AND arc.result_id = s.result_id 
          WHERE s.cur_user = CURRENT_USER
        )
 SELECT main.arc_id,
    main.arc_type,
    main.sector_id,
    main.arccat_id,
    main.result_id AS main_result,
    compare.result_id AS compare_result,
    main.flow_max AS flow_max_main,
    compare.flow_max AS flow_max_compare,
    main.flow_max - compare.flow_max AS flow_max_diff,
    main.flow_min AS flow_min_main,
    compare.flow_min AS flow_min_compare,
    main.flow_min - compare.flow_min AS flow_min_diff,
    main.flow_avg AS flow_avg_main,
    compare.flow_avg AS flow_avg_compare,
    main.flow_avg - compare.flow_avg AS flow_avg_diff,
    main.vel_max AS vel_max_main,
    compare.vel_max AS vel_max_compare,
    main.vel_max - compare.vel_max AS vel_max_diff,
    main.vel_min AS vel_min_main,
    compare.vel_min AS vel_min_compare,
    main.vel_min - compare.vel_min AS vel_min_diff,
    main.vel_avg AS vel_avg_main,
    compare.vel_avg AS vel_avg_compare,
    main.vel_avg - compare.vel_avg AS vel_avg_diff,
    main.headloss_max AS headloss_max_main,
    compare.headloss_max AS headloss_max_compare,
    main.headloss_max - compare.headloss_max AS headloss_max_diff,
    main.headloss_min AS headloss_min_main,
    compare.headloss_min AS headloss_min_compare,
    main.headloss_min - compare.headloss_min AS headloss_min_diff,
    main.setting_max AS setting_max_main,
    compare.setting_max AS setting_max_compare,
    main.setting_max - compare.setting_max AS setting_max_diff,
    main.setting_min AS setting_min_main,
    compare.setting_min AS setting_min_compare,
    main.setting_min - compare.setting_min AS setting_min_diff,
    main.reaction_max AS reaction_max_main,
    compare.reaction_max AS reaction_max_compare,
    main.reaction_max - compare.reaction_max AS reaction_max_diff,
    main.reaction_min AS reaction_min_main,
    compare.reaction_min AS reaction_min_compare,
    main.reaction_min - compare.reaction_min AS reaction_min_diff,
    main.ffactor_max AS ffactor_max_main,
    compare.ffactor_max AS ffactor_max_compare,
    main.ffactor_max - compare.ffactor_max AS ffactor_max_diff,
    main.ffactor_min AS ffactor_min_main,
    compare.ffactor_min AS ffactor_min_compare,
    main.ffactor_min - compare.ffactor_min AS ffactor_min_diff,
    main.diameter AS diameter_main,
    compare.diameter AS diameter_compare,
    main.diameter - compare.diameter AS diameter_diff,
    main.the_geom
   FROM main
     JOIN compare ON main.arc_id::text = compare.arc_id::text;

DROP VIEW IF EXISTS ve_minsector_mincut;
CREATE OR REPLACE VIEW ve_minsector_mincut
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), minsector_mapzones AS (
         SELECT t.mincut_minsector_id AS minsector_id,
            array_agg(DISTINCT t.dma_id) AS dma_id,
            array_agg(DISTINCT t.dqa_id) AS dqa_id,
            array_agg(DISTINCT t.presszone_id) AS presszone_id,
            array_agg(DISTINCT t.expl_id) AS expl_id,
            array_agg(DISTINCT t.sector_id) AS sector_id,
            array_agg(DISTINCT t.muni_id) AS muni_id,
            array_agg(DISTINCT t.supplyzone_id) AS supplyzone_id,
            st_union(t.the_geom) AS the_geom
           FROM ( SELECT m_1.minsector_id,
                    mm.minsector_id AS mincut_minsector_id,
                    unnest(m_1.dma_id) AS dma_id,
                    unnest(m_1.dqa_id) AS dqa_id,
                    unnest(m_1.presszone_id) AS presszone_id,
                    unnest(m_1.expl_id) AS expl_id,
                    unnest(m_1.sector_id) AS sector_id,
                    unnest(m_1.muni_id) AS muni_id,
                    unnest(m_1.supplyzone_id) AS supplyzone_id,
                    m_1.the_geom
                   FROM minsector m_1
                     JOIN minsector_mincut mm ON mm.mincut_minsector_id = m_1.minsector_id) t
          GROUP BY t.mincut_minsector_id
        ), minsector_sums AS (
         SELECT mm.minsector_id,
            sum(m_1.num_border) AS num_border,
            sum(m_1.num_connec) AS num_connec,
            sum(m_1.num_hydro) AS num_hydro,
            sum(m_1.length) AS length
           FROM minsector_mincut mm
             JOIN minsector m_1 ON m_1.minsector_id = mm.mincut_minsector_id
          GROUP BY mm.minsector_id
        )
 SELECT m.minsector_id,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.expl_id,
    m.sector_id,
    m.muni_id,
    m.supplyzone_id,
    s.num_border,
    s.num_connec,
    s.num_hydro,
    s.length,
    m.the_geom::geometry(Polygon, SRID_VALUE) AS the_geom
   FROM minsector_mapzones m
     JOIN minsector_sums s ON s.minsector_id = m.minsector_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = ANY (m.expl_id)));


CREATE OR REPLACE VIEW v_rpt_arc_stats
AS SELECT r.arc_id,
    r.result_id,
    rpt_cat_result.flow_units,
    rpt_cat_result.quality_units,
    r.arc_type,
    r.sector_id,
    r.arccat_id,
    r.flow_max,
    r.flow_min,
    r.flow_avg,
    r.vel_max,
    r.vel_min,
    r.vel_avg,
    r.headloss_max,
    r.headloss_min,
    r.setting_max,
    r.setting_min,
    r.reaction_max,
    r.reaction_min,
    r.ffactor_max,
    r.ffactor_min,
    r.length,
    r.tot_headloss_max,
    r.tot_headloss_min,
    arc.diameter,
    r.the_geom
   FROM rpt_arc_stats r
     JOIN selector_rpt_main s ON s.result_id::text = r.result_id::text
     JOIN rpt_inp_arc arc ON arc.result_id::text = s.result_id::text AND arc.arc_id = r.arc_id 
     JOIN rpt_cat_result ON rpt_cat_result.result_id::text = s.result_id::text
  WHERE s.cur_user = CURRENT_USER;
