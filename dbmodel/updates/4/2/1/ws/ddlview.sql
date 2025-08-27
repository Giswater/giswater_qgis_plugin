/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_ui_rpt_cat_result;
CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
    rpt_cat_result.dma_id,
    t2.idval AS network_type,
    t1.idval AS status,
    rpt_cat_result.iscorporate,
    rpt_cat_result.descript,
    rpt_cat_result.exec_date,
    rpt_cat_result.cur_user,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats,
    rpt_cat_result.addparam
   FROM selector_expl s,
    rpt_cat_result
     LEFT JOIN inp_typevalue t1 ON rpt_cat_result.status::text = t1.id::text
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL::integer]);

CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id = l.exit_id
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    ve_connec.arc_id,
    ve_connec.connec_type AS featurecat_id,
    ve_connec.conneccat_id AS catalog,
    ve_connec.connec_id AS feature_id,
    ve_connec.code AS feature_code,
    ve_connec.sys_type,
    a.state AS arc_state,
    ve_connec.state AS feature_state,
    st_x(ve_connec.the_geom) AS x,
    st_y(ve_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    've_connec'::text AS sys_table_id
   FROM ve_connec
     JOIN link l ON ve_connec.connec_id = l.feature_id
     JOIN arc a ON a.arc_id = ve_connec.arc_id
  WHERE ve_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.conneccat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    've_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN ve_connec c ON c.connec_id = n.feature_id;


CREATE OR REPLACE VIEW ve_epa_link
AS SELECT link.link_id,
	  inp_connec.minorloss,
	  inp_connec.status,
	  cat_link.matcat_id,
	  r.roughness AS cat_roughness,
	  inp_connec.custom_roughness,
	  cat_link.dint,
	  inp_connec.custom_dint,
	  inp_connec.custom_length,
	  v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max,
    v_rpt_arc_stats.flow_min,
    v_rpt_arc_stats.flow_avg,
    v_rpt_arc_stats.vel_max,
    v_rpt_arc_stats.vel_min,
    v_rpt_arc_stats.vel_avg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min,
    v_rpt_arc_stats.tot_headloss_max,
    v_rpt_arc_stats.tot_headloss_min
  FROM inp_connec
   	 JOIN link ON link.feature_id = inp_connec.connec_id
     LEFT JOIN v_rpt_arc_stats ON concat('CO', inp_connec.connec_id)::text = v_rpt_arc_stats.arc_id::text
     LEFT JOIN cat_link ON cat_link.id::text = link.linkcat_id::TEXT
     LEFT JOIN cat_mat_roughness r ON cat_link.matcat_id::text = r.matcat_id::text;

DROP VIEW IF EXISTS ve_epa_connec;
CREATE OR REPLACE VIEW ve_epa_connec
AS SELECT inp_connec.connec_id,
    inp_connec.demand,
    inp_connec.pattern_id,
    inp_connec.peak_factor,
    inp_connec.emitter_coeff,
    inp_connec.init_quality,
    inp_connec.source_type,
    inp_connec.source_quality,
    inp_connec.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_connec
     LEFT JOIN v_rpt_node_stats ON inp_connec.connec_id::text = v_rpt_node_stats.node_id::text;

-- Refactor mapzones
DROP VIEW IF EXISTS v_ui_omzone;
DROP VIEW IF EXISTS ve_omzone;
DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS ve_sector;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS ve_dma;
DROP VIEW IF EXISTS v_ui_dqa;
DROP VIEW IF EXISTS ve_dqa;
DROP VIEW IF EXISTS v_ui_presszone;
DROP VIEW IF EXISTS ve_presszone;
DROP VIEW IF EXISTS v_ui_supplyzone;
DROP VIEW IF EXISTS ve_supplyzone;
DROP VIEW IF EXISTS v_ui_macrosector;
DROP VIEW IF EXISTS ve_macrosector;
DROP VIEW IF EXISTS v_ui_macroomzone;
DROP VIEW IF EXISTS ve_macroomzone;
DROP VIEW IF EXISTS v_ui_macrodma;
DROP VIEW IF EXISTS ve_macrodma;
DROP VIEW IF EXISTS v_ui_macrodqa;
DROP VIEW IF EXISTS ve_macrodqa;

CREATE VIEW v_ui_omzone
AS SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    o.active,
    et.idval AS omzone_type,
    mo.name AS macroomzone,
    o.expl_id,
    o.sector_id,
    o.muni_id,
    o.graphconfig,
    o.stylesheet,
    o.lock_level,
    o.link,
    o.addparam,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
   FROM selector_expl se, omzone o
     LEFT JOIN macroomzone mo USING (macroomzone_id)
     LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
  WHERE se.expl_id = ANY(o.expl_id) AND se.cur_user = CURRENT_USER AND o.omzone_id > 0
  ORDER BY o.omzone_id;

CREATE VIEW ve_omzone
AS SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    o.active,
    o.omzone_type,
    o.macroomzone_id,
    o.expl_id,
    o.sector_id,
    o.muni_id,
    o.graphconfig,
    o.stylesheet,
    o.lock_level,
    o.link,
    o.addparam,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by,
    o.the_geom
   FROM selector_expl se, omzone o
  WHERE se.expl_id = ANY(o.expl_id) AND se.cur_user = CURRENT_USER AND o.omzone_id > 0
  ORDER BY o.omzone_id;

CREATE OR REPLACE VIEW v_ui_sector
AS SELECT DISTINCT ON (s.sector_id) s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    et.idval AS sector_type,
    ms.name AS macrosector,
    s.expl_id,
    s.muni_id,
    s.avg_press,
    s.pattern_id,
    s.graphconfig::text,
    s.stylesheet::text,
    s.lock_level,
    s.link,
    s.addparam::text,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
   FROM selector_sector ss, sector s
     LEFT JOIN macrosector ms USING (macrosector_id)
     LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text
  WHERE ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER AND s.sector_id > 0
  ORDER BY s.sector_id;

CREATE OR REPLACE VIEW ve_sector
AS SELECT DISTINCT ON (s.sector_id) s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    s.sector_type,
    s.macrosector_id,
    s.expl_id,
    s.muni_id,
    s.avg_press,
    s.pattern_id,
    s.graphconfig::text,
    s.stylesheet::text,
    s.lock_level,
    s.link,
    s.addparam::text,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by,
    s.the_geom
  FROM selector_sector ss, sector s
  WHERE ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER AND s.sector_id > 0
  ORDER BY s.sector_id;


CREATE OR REPLACE VIEW v_ui_dma
AS SELECT DISTINCT ON (d.dma_id) d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dma_type,
    md.name AS macrodma,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.effc,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dma d
     LEFT JOIN macrodma md USING (macrodma_id)
     LEFT JOIN edit_typevalue et ON et.id::text = d.dma_type::text AND et.typevalue::text = 'dma_type'::text
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dma_id > 0
  ORDER BY d.dma_id;

CREATE OR REPLACE VIEW ve_dma
AS SELECT DISTINCT ON (d.dma_id) d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dma_type,
    d.macrodma_id,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.effc,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by,
    d.the_geom
   FROM selector_expl se, dma d
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dma_id > 0
  ORDER BY d.dma_id;

CREATE OR REPLACE VIEW v_ui_dqa
AS SELECT DISTINCT ON (d.dqa_id) d.dqa_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dqa_type,
    md.name AS macrodqa,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dqa d
     LEFT JOIN macrodqa md USING (macrodqa_id)
     LEFT JOIN edit_typevalue et ON et.id::text = d.dqa_type::text AND et.typevalue::text = 'dqa_type'::text
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dqa_id > 0
  ORDER BY d.dqa_id;

CREATE OR REPLACE VIEW ve_dqa
AS SELECT DISTINCT ON (d.dqa_id) d.dqa_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dqa_type,
    d.macrodqa_id,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by,
    d.the_geom
   FROM selector_expl se, dqa d
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dqa_id > 0
  ORDER BY d.dqa_id;

CREATE OR REPLACE VIEW v_ui_presszone
AS SELECT DISTINCT ON (p.presszone_id) p.presszone_id,
    p.code,
    p.name,
    p.descript,
    p.active,
    et.idval AS presszone_type,
    p.expl_id,
    p.sector_id,
    p.muni_id,
    p.avg_press,
    p.head,
    p.graphconfig::text,
    p.stylesheet::text,
    p.lock_level,
    p.link,
    p.addparam::text,
    p.created_at,
    p.created_by,
    p.updated_at,
    p.updated_by
   FROM selector_expl se, presszone p
     LEFT JOIN edit_typevalue et ON et.id::text = p.presszone_type::text AND et.typevalue::text = 'presszone_type'::text
  WHERE se.expl_id = ANY(p.expl_id) AND se.cur_user = CURRENT_USER AND p.presszone_id > 0
  ORDER BY p.presszone_id;

CREATE OR REPLACE VIEW ve_presszone
AS SELECT DISTINCT ON (p.presszone_id) p.presszone_id,
    p.code,
    p.name,
    p.descript,
    p.active,
    p.presszone_type,
    p.expl_id,
    p.sector_id,
    p.muni_id,
    p.avg_press,
    p.head,
    p.graphconfig::text,
    p.stylesheet::text,
    p.lock_level,
    p.link,
    p.addparam::text,
    p.created_at,
    p.created_by,
    p.updated_at,
    p.updated_by,
    p.the_geom
   FROM selector_expl se, presszone p
  WHERE se.expl_id = ANY(p.expl_id) AND se.cur_user = CURRENT_USER AND p.presszone_id > 0
  ORDER BY p.presszone_id;

CREATE OR REPLACE VIEW v_ui_supplyzone
AS SELECT DISTINCT ON (supplyzone_id) supplyzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS supplyzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM supplyzone d
     LEFT JOIN edit_typevalue et ON et.id::text = d.supplyzone_type::text AND et.typevalue::text = 'supplyzone_type'::text
  WHERE supplyzone_id > 0
  ORDER BY supplyzone_id;

CREATE OR REPLACE VIEW ve_supplyzone
AS SELECT DISTINCT ON (supplyzone_id) supplyzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.supplyzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by,
    d.the_geom
   FROM supplyzone d
  WHERE supplyzone_id > 0
  ORDER BY supplyzone_id;

CREATE OR REPLACE VIEW v_ui_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    code,
    name,
    descript,
    active,
    expl_id,
    sector_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macroomzone m
  WHERE macroomzone_id > 0
  ORDER BY macroomzone_id;

CREATE OR REPLACE VIEW ve_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    code,
    name,
    descript,
    active,
    expl_id,
    sector_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom
   FROM macroomzone m
  WHERE macroomzone_id > 0
  ORDER BY macroomzone_id;


CREATE OR REPLACE VIEW v_ui_macrodma
AS SELECT DISTINCT ON (m.macrodma_id) m.macrodma_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,  
    m.sector_id,
    m.muni_id,
    m.stylesheet::text,
    m.lock_level,
    m.link,
    m.addparam::text,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
   FROM selector_expl se,
    macrodma m
  WHERE m.macrodma_id > 0
  ORDER BY m.macrodma_id;

CREATE OR REPLACE VIEW ve_macrodma
AS SELECT DISTINCT ON (m.macrodma_id) m.macrodma_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,  
    m.sector_id,
    m.muni_id,
    m.stylesheet::text,
    m.lock_level,
    m.link,
    m.addparam::text,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by,
    m.the_geom
   FROM selector_expl se,
    macrodma m
  WHERE (se.expl_id = ANY (m.expl_id)) AND se.cur_user = CURRENT_USER AND m.active IS TRUE;

CREATE OR REPLACE VIEW v_ui_macrodqa
AS SELECT DISTINCT ON (m.macrodqa_id) m.macrodqa_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,
    m.sector_id,
    m.muni_id,
    m.stylesheet::text,
    m.lock_level,
    m.link,
    m.addparam::text,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
   FROM selector_expl se,
    macrodqa m
  WHERE m.macrodqa_id > 0
  ORDER BY m.macrodqa_id;

CREATE OR REPLACE VIEW ve_macrodqa
AS SELECT DISTINCT ON (m.macrodqa_id) m.macrodqa_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,
    m.sector_id,
    m.muni_id,
    m.stylesheet::text,
    m.lock_level,
    m.link,
    m.addparam::text,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by,
    m.the_geom
   FROM selector_expl se,
    macrodqa m
  WHERE m.macrodqa_id > 0
  ORDER BY m.macrodqa_id;

CREATE OR REPLACE VIEW v_ui_macrosector
AS SELECT DISTINCT ON (m.macrosector_id) m.macrosector_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,
    m.muni_id,
    m.stylesheet::text,
    m.lock_level,
    m.link,
    m.addparam::text,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
   FROM selector_sector ss,
    macrosector m
  WHERE m.macrosector_id > 0
  ORDER BY m.macrosector_id;

CREATE OR REPLACE VIEW ve_macrosector
AS SELECT DISTINCT ON (m.macrosector_id) m.macrosector_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,
    m.muni_id,
    m.stylesheet::text,
    m.lock_level,
    m.link,
    m.addparam::text,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by,
    m.the_geom
   FROM selector_sector ss,
    macrosector m
  WHERE m.macrosector_id > 0
  ORDER BY m.macrosector_id;