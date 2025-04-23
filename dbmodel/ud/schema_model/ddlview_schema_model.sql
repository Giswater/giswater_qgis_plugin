/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Name: v_anl_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_arc AS
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom,
    anl_arc.result_id,
    anl_arc.descript
   FROM selector_audit,
    (anl_arc
     JOIN exploitation ON ((anl_arc.expl_id = exploitation.expl_id)))
  WHERE ((anl_arc.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_arc.cur_user)::name = "current_user"()));


--
-- Name: v_anl_arc_point; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_arc_point AS
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom_p
   FROM selector_audit,
    ((anl_arc
     JOIN sys_fprocess ON ((anl_arc.fid = sys_fprocess.fid)))
     JOIN exploitation ON ((anl_arc.expl_id = exploitation.expl_id)))
  WHERE ((anl_arc.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_arc.cur_user)::name = "current_user"()));


--
-- Name: v_anl_arc_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_arc_x_node AS
 SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.state,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom
   FROM selector_audit,
    (anl_arc_x_node
     JOIN exploitation ON ((anl_arc_x_node.expl_id = exploitation.expl_id)))
  WHERE ((anl_arc_x_node.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_arc_x_node.cur_user)::name = "current_user"()));


--
-- Name: v_anl_arc_x_node_point; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_arc_x_node_point AS
 SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom_p
   FROM selector_audit,
    (anl_arc_x_node
     JOIN exploitation ON ((anl_arc_x_node.expl_id = exploitation.expl_id)))
  WHERE ((anl_arc_x_node.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_arc_x_node.cur_user)::name = "current_user"()));


--
-- Name: v_anl_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_connec AS
 SELECT anl_connec.id,
    anl_connec.connec_id,
    anl_connec.connecat_id,
    anl_connec.state,
    anl_connec.connec_id_aux,
    anl_connec.connecat_id_aux AS state_aux,
    anl_connec.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_connec.the_geom,
    anl_connec.result_id,
    anl_connec.descript
   FROM selector_audit,
    (anl_connec
     JOIN exploitation ON ((anl_connec.expl_id = exploitation.expl_id)))
  WHERE ((anl_connec.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_connec.cur_user)::name = "current_user"()));


--
-- Name: v_anl_flow_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_flow_arc AS
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
        CASE
            WHEN (anl_arc.fid = 220) THEN 'Flow trace'::text
            WHEN (anl_arc.fid = 221) THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    anl_arc.the_geom
   FROM selector_expl,
    anl_arc
  WHERE ((anl_arc.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text) AND ((anl_arc.cur_user)::name = "current_user"()) AND ((anl_arc.fid = 220) OR (anl_arc.fid = 221)));


--
-- Name: v_anl_flow_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_flow_connec AS
 SELECT connec.connec_id,
        CASE
            WHEN (anl_arc.fid = 220) THEN 'Flow trace'::text
            WHEN (anl_arc.fid = 221) THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    connec.the_geom
   FROM ((anl_arc
     JOIN connec ON (((anl_arc.arc_id)::text = (connec.arc_id)::text)))
     JOIN selector_expl ON (((anl_arc.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text) AND ((anl_arc.cur_user)::name = "current_user"()) AND ((anl_arc.fid = 220) OR (anl_arc.fid = 221)))));


--
-- Name: v_ext_streetaxis; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ext_streetaxis AS
 SELECT ext_streetaxis.id,
    ext_streetaxis.code,
    ext_streetaxis.type,
    ext_streetaxis.name,
    ext_streetaxis.text,
    ext_streetaxis.the_geom,
    ext_streetaxis.expl_id,
    ext_streetaxis.muni_id,
        CASE
            WHEN (ext_streetaxis.type IS NULL) THEN (ext_streetaxis.name)::text
            WHEN (ext_streetaxis.text IS NULL) THEN ((((ext_streetaxis.name)::text || ', '::text) || (ext_streetaxis.type)::text) || '.'::text)
            WHEN ((ext_streetaxis.type IS NULL) AND (ext_streetaxis.text IS NULL)) THEN (ext_streetaxis.name)::text
            ELSE (((((ext_streetaxis.name)::text || ', '::text) || (ext_streetaxis.type)::text) || '. '::text) || ext_streetaxis.text)
        END AS descript
   FROM selector_expl,
    ext_streetaxis
  WHERE ((ext_streetaxis.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_state_link_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_link_gully AS
(
         SELECT DISTINCT link.link_id
           FROM selector_state,
            selector_expl,
            link
          WHERE ((link.state = selector_state.state_id) AND ((link.expl_id = selector_expl.expl_id) OR (link.expl_id2 = selector_expl.expl_id)) AND (selector_state.cur_user = ("current_user"())::text) AND (selector_expl.cur_user = ("current_user"())::text) AND ((link.feature_type)::text = 'GULLY'::text))
        EXCEPT ALL
         SELECT plan_psector_x_gully.link_id
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_gully
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_gully.psector_id)))
          WHERE ((plan_psector_x_gully.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_gully.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_gully.active IS TRUE))
) UNION ALL
 SELECT plan_psector_x_gully.link_id
   FROM selector_psector,
    selector_expl,
    (plan_psector_x_gully
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_gully.psector_id)))
  WHERE ((plan_psector_x_gully.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_gully.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_gully.active IS TRUE));


--
-- Name: vu_link_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_link_gully AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    (public.st_length2d(l.the_geom))::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    s.macrosector_id,
    d.macrodma_id
   FROM ((link l
     LEFT JOIN sector s USING (sector_id))
     LEFT JOIN dma d USING (dma_id))
  WHERE ((l.feature_type)::text = 'GULLY'::text);


--
-- Name: v_link_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_link_gully AS
 SELECT DISTINCT ON (vu_link_gully.link_id) vu_link_gully.link_id,
    vu_link_gully.feature_type,
    vu_link_gully.feature_id,
    vu_link_gully.exit_type,
    vu_link_gully.exit_id,
    vu_link_gully.state,
    vu_link_gully.expl_id,
    vu_link_gully.sector_id,
    vu_link_gully.dma_id,
    vu_link_gully.exit_topelev,
    vu_link_gully.exit_elev,
    vu_link_gully.fluid_type,
    vu_link_gully.gis_length,
    vu_link_gully.the_geom,
    vu_link_gully.sector_name,
    vu_link_gully.macrosector_id,
    vu_link_gully.macrodma_id
   FROM (vu_link_gully
     JOIN v_state_link_gully USING (link_id));


--
-- Name: v_state_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_gully AS
 SELECT DISTINCT ON (a.gully_id) a.gully_id,
    a.arc_id
   FROM ((
                 SELECT gully.gully_id,
                    gully.arc_id,
                    1 AS flag
                   FROM selector_state,
                    selector_expl,
                    gully
                  WHERE ((gully.state = selector_state.state_id) AND ((gully.expl_id = selector_expl.expl_id) OR (gully.expl_id2 = selector_expl.expl_id)) AND (selector_state.cur_user = ("current_user"())::text) AND (selector_expl.cur_user = ("current_user"())::text))
                EXCEPT
                 SELECT plan_psector_x_gully.gully_id,
                    plan_psector_x_gully.arc_id,
                    1 AS flag
                   FROM selector_psector,
                    selector_expl,
                    (plan_psector_x_gully
                     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_gully.psector_id)))
                  WHERE ((plan_psector_x_gully.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_gully.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text))
        ) UNION
         SELECT plan_psector_x_gully.gully_id,
            plan_psector_x_gully.arc_id,
            2 AS flag
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_gully
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_gully.psector_id)))
          WHERE ((plan_psector_x_gully.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_gully.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text))
  ORDER BY 1, 3 DESC) a;


--
-- Name: vu_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_gully AS
 SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    cat_feature.system_id AS sys_type,
    gully.gratecat_id,
    cat_grate.matcat_id AS cat_grate_matcat,
    gully.units,
    gully.groove,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
        CASE
            WHEN (((((gully.top_elev - gully.ymax) + gully.sandbox) + gully.connec_y2) / (2)::numeric) IS NOT NULL) THEN (((((gully.top_elev - gully.ymax) + gully.sandbox) + gully.connec_y2) / (2)::numeric))::numeric(12,3)
            ELSE gully.connec_depth
        END AS connec_depth,
    gully.arc_id,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.sector_id,
    sector.macrosector_id,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    gully.dma_id,
    dma.macrodma_id,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.buildercat_id,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.muni_id,
    gully.postcode,
    gully.district_id,
    (c.descript)::character varying(100) AS streetname,
    gully.postnumber,
    gully.postcomplement,
    (d.descript)::character varying(100) AS streetname2,
    gully.postnumber2,
    gully.postcomplement2,
    gully.descript,
    cat_grate.svg,
    gully.rotation,
    concat(cat_feature.link_path, gully.link) AS link,
    gully.verified,
    gully.undelete,
    cat_grate.label,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.publish,
    gully.inventory,
    gully.uncertain,
    gully.num_value,
    gully.pjoint_id,
    gully.pjoint_type,
    date_trunc('second'::text, gully.tstamp) AS tstamp,
    gully.insert_user,
    date_trunc('second'::text, gully.lastupdate) AS lastupdate,
    gully.lastupdate_user,
    gully.the_geom,
    gully.workcat_id_plan,
    gully.asset_id,
        CASE
            WHEN (gully.connec_matcat_id IS NULL) THEN (cc.matcat_id)::text
            ELSE gully.connec_matcat_id
        END AS connec_matcat_id,
    gully.gratecat2_id,
    ((gully.top_elev - gully.ymax) + gully.sandbox) AS connec_y1,
    gully.connec_y2,
    gully.epa_type,
    gully.groove_height,
    gully.groove_length,
    cat_grate.width AS grate_width,
    cat_grate.length AS grate_length,
    gully.units_placement,
    gully.drainzone_id,
    gully.expl_id2
   FROM ((((((((gully
     LEFT JOIN cat_grate ON (((gully.gratecat_id)::text = (cat_grate.id)::text)))
     LEFT JOIN dma ON ((gully.dma_id = dma.dma_id)))
     LEFT JOIN sector ON ((gully.sector_id = sector.sector_id)))
     LEFT JOIN exploitation ON ((gully.expl_id = exploitation.expl_id)))
     LEFT JOIN cat_feature ON (((gully.gully_type)::text = (cat_feature.id)::text)))
     LEFT JOIN v_ext_streetaxis c ON (((c.id)::text = (gully.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis d ON (((d.id)::text = (gully.streetaxis2_id)::text)))
     LEFT JOIN cat_connec cc ON (((cc.id)::text = (gully.connec_arccat_id)::text)));


--
-- Name: v_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_gully AS
 SELECT vu_gully.gully_id,
    vu_gully.code,
    vu_gully.top_elev,
    vu_gully.ymax,
    vu_gully.sandbox,
    vu_gully.matcat_id,
    vu_gully.gully_type,
    vu_gully.sys_type,
    vu_gully.gratecat_id,
    vu_gully.cat_grate_matcat,
    vu_gully.units,
    vu_gully.groove,
    vu_gully.siphon,
    vu_gully.connec_arccat_id,
    vu_gully.connec_length,
    vu_gully.connec_depth,
    v_state_gully.arc_id,
    vu_gully.expl_id,
    vu_gully.macroexpl_id,
        CASE
            WHEN (a.sector_id IS NULL) THEN vu_gully.sector_id
            ELSE a.sector_id
        END AS sector_id,
        CASE
            WHEN (a.macrosector_id IS NULL) THEN vu_gully.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
    vu_gully.state,
    vu_gully.state_type,
    vu_gully.annotation,
    vu_gully.observ,
    vu_gully.comment,
        CASE
            WHEN (a.dma_id IS NULL) THEN vu_gully.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN (a.macrodma_id IS NULL) THEN vu_gully.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
    vu_gully.soilcat_id,
    vu_gully.function_type,
    vu_gully.category_type,
    vu_gully.fluid_type,
    vu_gully.location_type,
    vu_gully.workcat_id,
    vu_gully.workcat_id_end,
    vu_gully.buildercat_id,
    vu_gully.builtdate,
    vu_gully.enddate,
    vu_gully.ownercat_id,
    vu_gully.muni_id,
    vu_gully.postcode,
    vu_gully.district_id,
    vu_gully.streetname,
    vu_gully.postnumber,
    vu_gully.postcomplement,
    vu_gully.streetname2,
    vu_gully.postnumber2,
    vu_gully.postcomplement2,
    vu_gully.descript,
    vu_gully.svg,
    vu_gully.rotation,
    vu_gully.link,
    vu_gully.verified,
    vu_gully.undelete,
    vu_gully.label,
    vu_gully.label_x,
    vu_gully.label_y,
    vu_gully.label_rotation,
    vu_gully.publish,
    vu_gully.inventory,
    vu_gully.uncertain,
    vu_gully.num_value,
        CASE
            WHEN (a.exit_id IS NULL) THEN vu_gully.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN (a.exit_type IS NULL) THEN vu_gully.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_gully.tstamp,
    vu_gully.insert_user,
    vu_gully.lastupdate,
    vu_gully.lastupdate_user,
    vu_gully.the_geom,
    vu_gully.workcat_id_plan,
    vu_gully.asset_id,
    vu_gully.connec_matcat_id,
    vu_gully.gratecat2_id,
    vu_gully.connec_y1,
    vu_gully.connec_y2,
    vu_gully.epa_type,
    vu_gully.groove_height,
    vu_gully.groove_length,
    vu_gully.grate_width,
    vu_gully.grate_length,
    vu_gully.units_placement,
    vu_gully.drainzone_id,
    vu_gully.expl_id2
   FROM ((vu_gully
     JOIN v_state_gully USING (gully_id))
     LEFT JOIN ( SELECT DISTINCT ON (v_link_gully.feature_id) v_link_gully.link_id,
            v_link_gully.feature_type,
            v_link_gully.feature_id,
            v_link_gully.exit_type,
            v_link_gully.exit_id,
            v_link_gully.state,
            v_link_gully.expl_id,
            v_link_gully.sector_id,
            v_link_gully.dma_id,
            v_link_gully.exit_topelev,
            v_link_gully.exit_elev,
            v_link_gully.fluid_type,
            v_link_gully.gis_length,
            v_link_gully.the_geom,
            v_link_gully.sector_name,
            v_link_gully.macrosector_id,
            v_link_gully.macrodma_id
           FROM v_link_gully
          WHERE (v_link_gully.state = 2)) a ON (((a.feature_id)::text = (vu_gully.gully_id)::text)));


--
-- Name: v_anl_flow_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_flow_gully AS
 SELECT v_gully.gully_id,
        CASE
            WHEN (anl_arc.fid = 220) THEN 'Flow trace'::text
            WHEN (anl_arc.fid = 221) THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    v_gully.the_geom
   FROM ((anl_arc
     JOIN v_gully ON (((anl_arc.arc_id)::text = (v_gully.arc_id)::text)))
     JOIN selector_expl ON (((anl_arc.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text) AND ((anl_arc.cur_user)::name = "current_user"()) AND ((anl_arc.fid = 220) OR (anl_arc.fid = 221)))));


--
-- Name: v_anl_flow_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_flow_node AS
 SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id AS node_type,
        CASE
            WHEN (anl_node.fid = 220) THEN 'Flow trace'::text
            WHEN (anl_node.fid = 221) THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_node.expl_id,
    anl_node.the_geom
   FROM selector_expl,
    anl_node
  WHERE ((anl_node.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text) AND ((anl_node.cur_user)::name = "current_user"()) AND ((anl_node.fid = 220) OR (anl_node.fid = 221)));


--
-- Name: v_anl_graph; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_graph AS
 SELECT anl_graph.arc_id,
    anl_graph.node_1,
    anl_graph.node_2,
    anl_graph.flag,
    a.flag AS flagi,
    a.value
   FROM (temp_anlgraph anl_graph
     JOIN ( SELECT anl_graph_1.arc_id,
            anl_graph_1.node_1,
            anl_graph_1.node_2,
            anl_graph_1.water,
            anl_graph_1.flag,
            anl_graph_1.checkf,
            anl_graph_1.value
           FROM temp_anlgraph anl_graph_1
          WHERE (anl_graph_1.water = 1)) a ON (((anl_graph.node_1)::text = (a.node_2)::text)))
  WHERE ((anl_graph.flag < 2) AND (anl_graph.water = 0) AND (a.flag < 2));


--
-- Name: v_anl_graphanalytics_mapzones; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_graphanalytics_mapzones AS
 SELECT temp_anlgraph.arc_id,
    temp_anlgraph.node_1,
    temp_anlgraph.node_2,
    temp_anlgraph.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM (temp_anlgraph
     JOIN ( SELECT temp_anlgraph_1.arc_id,
            temp_anlgraph_1.node_1,
            temp_anlgraph_1.node_2,
            temp_anlgraph_1.water,
            temp_anlgraph_1.flag,
            temp_anlgraph_1.checkf,
            temp_anlgraph_1.value,
            temp_anlgraph_1.trace
           FROM temp_anlgraph temp_anlgraph_1
          WHERE (temp_anlgraph_1.water = 1)) a2 ON (((temp_anlgraph.node_1)::text = (a2.node_2)::text)))
  WHERE ((temp_anlgraph.flag < 2) AND (temp_anlgraph.water = 0) AND (a2.flag = 0));


--
-- Name: v_anl_graphanalytics_upstream; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_graphanalytics_upstream AS
 SELECT temp_anlgraph.arc_id,
    temp_anlgraph.node_1,
    temp_anlgraph.node_2,
    temp_anlgraph.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM (temp_anlgraph
     JOIN ( SELECT temp_anlgraph_1.arc_id,
            temp_anlgraph_1.node_1,
            temp_anlgraph_1.node_2,
            temp_anlgraph_1.water,
            temp_anlgraph_1.flag,
            temp_anlgraph_1.checkf,
            temp_anlgraph_1.value,
            temp_anlgraph_1.trace
           FROM temp_anlgraph temp_anlgraph_1
          WHERE (temp_anlgraph_1.water = 1)) a2 ON (((temp_anlgraph.node_2)::text = (a2.node_1)::text)))
  WHERE ((temp_anlgraph.flag < 2) AND (temp_anlgraph.water = 0) AND (a2.flag = 0));


--
-- Name: v_anl_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_node AS
 SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.state,
    anl_node.node_id_aux,
    anl_node.nodecat_id_aux AS state_aux,
    anl_node.num_arcs,
    anl_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_node.the_geom,
    anl_node.result_id,
    anl_node.descript
   FROM selector_audit,
    (anl_node
     JOIN exploitation ON ((anl_node.expl_id = exploitation.expl_id)))
  WHERE ((anl_node.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_node.cur_user)::name = "current_user"()));


--
-- Name: v_anl_pgrouting_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_pgrouting_node AS
 SELECT row_number() OVER (ORDER BY node.node_id) AS rid,
    node.node_id
   FROM node;


--
-- Name: v_anl_pgrouting_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_pgrouting_arc AS
 SELECT row_number() OVER (ORDER BY arc.arc_id) AS id,
    arc.arc_id,
    (a.rid)::integer AS source,
    (b.rid)::integer AS target,
    public.st_length(arc.the_geom) AS cost
   FROM ((arc
     JOIN v_anl_pgrouting_node a ON (((arc.node_1)::text = (a.node_id)::text)))
     JOIN v_anl_pgrouting_node b ON (((arc.node_2)::text = (b.node_id)::text)));


--
-- Name: v_expl_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_expl_arc AS
 SELECT DISTINCT arc.arc_id
   FROM selector_expl,
    arc
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND ((arc.expl_id = selector_expl.expl_id) OR (arc.expl_id2 = selector_expl.expl_id)));


--
-- Name: v_state_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_arc AS
(
         SELECT arc.arc_id
           FROM selector_state,
            arc
          WHERE ((arc.state = selector_state.state_id) AND (selector_state.cur_user = ("current_user"())::text))
        EXCEPT
         SELECT plan_psector_x_arc.arc_id
           FROM selector_psector,
            (plan_psector_x_arc
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_arc.psector_id)))
          WHERE ((plan_psector_x_arc.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_arc.state = 0))
) UNION
 SELECT plan_psector_x_arc.arc_id
   FROM selector_psector,
    (plan_psector_x_arc
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_arc.psector_id)))
  WHERE ((plan_psector_x_arc.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_arc.state = 1));


--
-- Name: vu_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_arc AS
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
        CASE
            WHEN (arc.sys_elev1 IS NULL) THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END AS sys_elev1,
        CASE
            WHEN (
            CASE
                WHEN (arc.custom_y1 IS NULL) THEN arc.y1
                ELSE arc.custom_y1
            END IS NULL) THEN (arc.node_sys_top_elev_1 - arc.sys_elev1)
            ELSE
            CASE
                WHEN (arc.custom_y1 IS NULL) THEN arc.y1
                ELSE arc.custom_y1
            END
        END AS sys_y1,
    ((arc.node_sys_top_elev_1 -
        CASE
            WHEN (arc.sys_elev1 IS NULL) THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END) - cat_arc.geom1) AS r1,
    (
        CASE
            WHEN (arc.sys_elev1 IS NULL) THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END - arc.node_sys_elev_1) AS z1,
    arc.node_2,
    arc.nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
        CASE
            WHEN (arc.sys_elev2 IS NULL) THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END AS sys_elev2,
        CASE
            WHEN (
            CASE
                WHEN (arc.custom_y2 IS NULL) THEN arc.y2
                ELSE arc.custom_y2
            END IS NULL) THEN (arc.node_sys_top_elev_2 - arc.sys_elev2)
            ELSE
            CASE
                WHEN (arc.custom_y2 IS NULL) THEN arc.y2
                ELSE arc.custom_y2
            END
        END AS sys_y2,
    ((arc.node_sys_top_elev_2 -
        CASE
            WHEN (arc.sys_elev2 IS NULL) THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END) - cat_arc.geom1) AS r2,
    (
        CASE
            WHEN (arc.sys_elev2 IS NULL) THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END - arc.node_sys_elev_2) AS z2,
    arc.sys_slope AS slope,
    arc.arc_type,
    cat_feature.system_id AS sys_type,
    arc.arccat_id,
        CASE
            WHEN (arc.matcat_id IS NULL) THEN cat_arc.matcat_id
            ELSE arc.matcat_id
        END AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width,
    arc.epa_type,
    arc.expl_id,
    e.macroexpl_id,
    arc.sector_id,
    s.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    (public.st_length(arc.the_geom))::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    m.macrodma_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.builtdate,
    arc.enddate,
    arc.buildercat_id,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    (c.descript)::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    (d.descript)::character varying(100) AS streetname2,
    arc.postnumber2,
    arc.postcomplement2,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    arc.uncertain,
    arc.num_value,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.workcat_id_plan,
    arc.asset_id,
    arc.pavcat_id,
    arc.drainzone_id,
    cat_arc.area AS cat_area,
    arc.parent_id,
    arc.expl_id2
   FROM (((((((arc
     JOIN cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)))
     JOIN cat_feature ON (((arc.arc_type)::text = (cat_feature.id)::text)))
     JOIN sector s ON ((s.sector_id = arc.sector_id)))
     JOIN exploitation e USING (expl_id))
     JOIN dma m USING (dma_id))
     LEFT JOIN v_ext_streetaxis c ON (((c.id)::text = (arc.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis d ON (((d.id)::text = (arc.streetaxis2_id)::text)));


--
-- Name: v_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_arc AS
 SELECT vu_arc.arc_id,
    vu_arc.code,
    vu_arc.node_1,
    vu_arc.nodetype_1,
    vu_arc.y1,
    vu_arc.custom_y1,
    vu_arc.elev1,
    vu_arc.custom_elev1,
    vu_arc.sys_elev1,
    vu_arc.sys_y1,
    vu_arc.r1,
    vu_arc.z1,
    vu_arc.node_2,
    vu_arc.nodetype_2,
    vu_arc.y2,
    vu_arc.custom_y2,
    vu_arc.elev2,
    vu_arc.custom_elev2,
    vu_arc.sys_elev2,
    vu_arc.sys_y2,
    vu_arc.r2,
    vu_arc.z2,
    vu_arc.slope,
    vu_arc.arc_type,
    vu_arc.sys_type,
    vu_arc.arccat_id,
    vu_arc.matcat_id,
    vu_arc.cat_shape,
    vu_arc.cat_geom1,
    vu_arc.cat_geom2,
    vu_arc.width,
    vu_arc.epa_type,
    vu_arc.expl_id,
    vu_arc.macroexpl_id,
    vu_arc.sector_id,
    vu_arc.macrosector_id,
    vu_arc.state,
    vu_arc.state_type,
    vu_arc.annotation,
    vu_arc.gis_length,
    vu_arc.custom_length,
    vu_arc.inverted_slope,
    vu_arc.observ,
    vu_arc.comment,
    vu_arc.dma_id,
    vu_arc.macrodma_id,
    vu_arc.soilcat_id,
    vu_arc.function_type,
    vu_arc.category_type,
    vu_arc.fluid_type,
    vu_arc.location_type,
    vu_arc.workcat_id,
    vu_arc.workcat_id_end,
    vu_arc.builtdate,
    vu_arc.enddate,
    vu_arc.buildercat_id,
    vu_arc.ownercat_id,
    vu_arc.muni_id,
    vu_arc.postcode,
    vu_arc.district_id,
    vu_arc.streetname,
    vu_arc.postnumber,
    vu_arc.postcomplement,
    vu_arc.streetname2,
    vu_arc.postnumber2,
    vu_arc.postcomplement2,
    vu_arc.descript,
    vu_arc.link,
    vu_arc.verified,
    vu_arc.undelete,
    vu_arc.label,
    vu_arc.label_x,
    vu_arc.label_y,
    vu_arc.label_rotation,
    vu_arc.publish,
    vu_arc.inventory,
    vu_arc.uncertain,
    vu_arc.num_value,
    vu_arc.tstamp,
    vu_arc.insert_user,
    vu_arc.lastupdate,
    vu_arc.lastupdate_user,
    vu_arc.the_geom,
    vu_arc.workcat_id_plan,
    vu_arc.asset_id,
    vu_arc.pavcat_id,
    vu_arc.drainzone_id,
    vu_arc.cat_area,
    vu_arc.parent_id,
    vu_arc.expl_id2
   FROM ((vu_arc
     JOIN v_state_arc USING (arc_id))
     JOIN v_expl_arc e ON (((e.arc_id)::text = (vu_arc.arc_id)::text)));


--
-- Name: v_state_link_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_link_connec AS
(
         SELECT DISTINCT link.link_id
           FROM selector_state,
            selector_expl,
            link
          WHERE ((link.state = selector_state.state_id) AND ((link.expl_id = selector_expl.expl_id) OR (link.expl_id2 = selector_expl.expl_id)) AND (selector_state.cur_user = ("current_user"())::text) AND (selector_expl.cur_user = ("current_user"())::text) AND ((link.feature_type)::text = 'CONNEC'::text))
        EXCEPT ALL
         SELECT plan_psector_x_connec.link_id
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_connec
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
          WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_connec.active IS TRUE))
) UNION ALL
 SELECT plan_psector_x_connec.link_id
   FROM selector_psector,
    selector_expl,
    (plan_psector_x_connec
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_connec.active IS TRUE));


--
-- Name: vu_link_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_link_connec AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    (public.st_length2d(l.the_geom))::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    s.macrosector_id,
    d.macrodma_id
   FROM ((link l
     LEFT JOIN sector s USING (sector_id))
     LEFT JOIN dma d USING (dma_id))
  WHERE ((l.feature_type)::text = 'CONNEC'::text);


--
-- Name: v_link_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_link_connec AS
 SELECT DISTINCT ON (vu_link_connec.link_id) vu_link_connec.link_id,
    vu_link_connec.feature_type,
    vu_link_connec.feature_id,
    vu_link_connec.exit_type,
    vu_link_connec.exit_id,
    vu_link_connec.state,
    vu_link_connec.expl_id,
    vu_link_connec.sector_id,
    vu_link_connec.dma_id,
    vu_link_connec.exit_topelev,
    vu_link_connec.exit_elev,
    vu_link_connec.fluid_type,
    vu_link_connec.gis_length,
    vu_link_connec.the_geom,
    vu_link_connec.sector_name,
    vu_link_connec.macrosector_id,
    vu_link_connec.macrodma_id
   FROM (vu_link_connec
     JOIN v_state_link_connec USING (link_id));


--
-- Name: v_state_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_connec AS
 SELECT DISTINCT ON (((a.connec_id)::character varying(30))) (a.connec_id)::character varying(30) AS connec_id,
    a.arc_id
   FROM ((
                 SELECT connec.connec_id,
                    connec.arc_id,
                    1 AS flag
                   FROM selector_state,
                    selector_expl,
                    connec
                  WHERE ((connec.state = selector_state.state_id) AND ((connec.expl_id = selector_expl.expl_id) OR (connec.expl_id2 = selector_expl.expl_id)) AND (selector_state.cur_user = ("current_user"())::text) AND (selector_expl.cur_user = ("current_user"())::text))
                EXCEPT
                 SELECT plan_psector_x_connec.connec_id,
                    plan_psector_x_connec.arc_id,
                    1 AS flag
                   FROM selector_psector,
                    selector_expl,
                    (plan_psector_x_connec
                     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
                  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text))
        ) UNION
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.arc_id,
            2 AS flag
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_connec
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
          WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text))
  ORDER BY 1, 3 DESC) a;


--
-- Name: vu_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_connec AS
 SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    cat_feature.system_id AS sys_type,
    connec.private_connecat_id,
        CASE
            WHEN (connec.matcat_id IS NULL) THEN cat_connec.matcat_id
            ELSE connec.matcat_id
        END AS matcat_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.demand,
    connec.state,
    connec.state_type,
        CASE
            WHEN (((connec.y1 + connec.y2) / (2)::numeric) IS NOT NULL) THEN (((connec.y1 + connec.y2) / (2)::numeric))::numeric(12,3)
            ELSE connec.connec_depth
        END AS connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    dma.macrodma_id,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    (c.descript)::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    (d.descript)::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    connec.workcat_id_plan,
    connec.asset_id,
    connec.drainzone_id,
    connec.expl_id2
   FROM ((((((((connec
     JOIN cat_connec ON (((connec.connecat_id)::text = (cat_connec.id)::text)))
     LEFT JOIN ext_streetaxis ON (((connec.streetaxis_id)::text = (ext_streetaxis.id)::text)))
     LEFT JOIN dma ON ((connec.dma_id = dma.dma_id)))
     LEFT JOIN exploitation ON ((connec.expl_id = exploitation.expl_id)))
     LEFT JOIN sector ON ((connec.sector_id = sector.sector_id)))
     LEFT JOIN cat_feature ON (((connec.connec_type)::text = (cat_feature.id)::text)))
     LEFT JOIN v_ext_streetaxis c ON (((c.id)::text = (connec.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis d ON (((d.id)::text = (connec.streetaxis2_id)::text)));


--
-- Name: v_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_connec AS
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.customer_code,
    vu_connec.top_elev,
    vu_connec.y1,
    vu_connec.y2,
    vu_connec.connecat_id,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.private_connecat_id,
    vu_connec.matcat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN (a.sector_id IS NULL) THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
        CASE
            WHEN (a.macrosector_id IS NULL) THEN vu_connec.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
    vu_connec.demand,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.connec_depth,
    vu_connec.connec_length,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN (a.dma_id IS NULL) THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN (a.macrodma_id IS NULL) THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.accessibility,
    vu_connec.diagonal,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.uncertain,
    vu_connec.num_value,
        CASE
            WHEN (a.exit_id IS NULL) THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN (a.exit_type IS NULL) THEN vu_connec.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.drainzone_id,
    vu_connec.expl_id2
   FROM ((vu_connec
     JOIN v_state_connec USING (connec_id))
     LEFT JOIN ( SELECT DISTINCT ON (v_link_connec.feature_id) v_link_connec.link_id,
            v_link_connec.feature_type,
            v_link_connec.feature_id,
            v_link_connec.exit_type,
            v_link_connec.exit_id,
            v_link_connec.state,
            v_link_connec.expl_id,
            v_link_connec.sector_id,
            v_link_connec.dma_id,
            v_link_connec.exit_topelev,
            v_link_connec.exit_elev,
            v_link_connec.fluid_type,
            v_link_connec.gis_length,
            v_link_connec.the_geom,
            v_link_connec.sector_name,
            v_link_connec.macrosector_id,
            v_link_connec.macrodma_id
           FROM v_link_connec
          WHERE (v_link_connec.state = 2)) a ON (((a.feature_id)::text = (vu_connec.connec_id)::text)));


--
-- Name: v_edit_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.nodetype_1,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.sys_y1,
    v_arc.r1,
    v_arc.z1,
    v_arc.node_2,
    v_arc.nodetype_2,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.sys_y2,
    v_arc.r2,
    v_arc.z2,
    v_arc.slope,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.cat_shape,
    v_arc.cat_geom1,
    v_arc.cat_geom2,
    v_arc.width,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.inverted_slope,
    v_arc.observ,
    v_arc.comment,
    v_arc.dma_id,
    v_arc.macrodma_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.buildercat_id,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.district_id,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.undelete,
    v_arc.label,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.num_value,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom,
    v_arc.workcat_id_plan,
    v_arc.asset_id,
    v_arc.pavcat_id,
    v_arc.drainzone_id,
    v_arc.cat_area,
    v_arc.parent_id,
    v_arc.expl_id2
   FROM v_arc;


--
-- Name: v_edit_cad_auxcircle; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cad_auxcircle AS
 SELECT temp_table.id,
    temp_table.geom_polygon
   FROM temp_table
  WHERE ((temp_table.cur_user = ("current_user"())::text) AND (temp_table.fid = 361));


--
-- Name: v_edit_cad_auxline; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cad_auxline AS
 SELECT temp_table.id,
    temp_table.geom_line
   FROM temp_table
  WHERE ((temp_table.cur_user = ("current_user"())::text) AND (temp_table.fid = 362));


--
-- Name: v_edit_cad_auxpoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cad_auxpoint AS
 SELECT temp_table.id,
    temp_table.geom_point
   FROM temp_table
  WHERE ((temp_table.cur_user = ("current_user"())::text) AND (temp_table.fid = 127));


--
-- Name: v_edit_cat_dscenario; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_dscenario AS
 SELECT DISTINCT ON (c.dscenario_id) c.dscenario_id,
    c.name,
    c.descript,
    c.dscenario_type,
    c.parent_id,
    c.expl_id,
    c.active,
    c.log
   FROM cat_dscenario c,
    selector_expl s
  WHERE (((s.expl_id = c.expl_id) AND (s.cur_user = CURRENT_USER)) OR (c.expl_id IS NULL));


--
-- Name: v_edit_cat_dwf_scenario; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_dwf_scenario AS
 SELECT DISTINCT ON (c.id) c.id,
    c.idval,
    c.startdate,
    c.enddate,
    c.observ,
    c.expl_id,
    c.active,
    c.log
   FROM cat_dwf_scenario c,
    selector_expl s
  WHERE (((s.expl_id = c.expl_id) AND (s.cur_user = CURRENT_USER)) OR (c.expl_id IS NULL));


--
-- Name: v_edit_cat_feature_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_feature_arc AS
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_arc.epa_default,
    cat_feature.code_autofill,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_arc USING (id));


--
-- Name: v_edit_cat_feature_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_feature_connec AS
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature.code_autofill,
    (cat_feature_connec.double_geom)::text AS double_geom,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_connec USING (id));


--
-- Name: v_edit_cat_feature_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_feature_gully AS
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_gully.epa_default,
    cat_feature.code_autofill,
    (cat_feature_gully.double_geom)::text AS double_geom,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_gully USING (id));


--
-- Name: v_edit_cat_feature_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_feature_node AS
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_node.epa_default,
    cat_feature_node.isarcdivide,
    cat_feature_node.isprofilesurface,
    cat_feature.code_autofill,
    cat_feature_node.choose_hemisphere,
    (cat_feature_node.double_geom)::text AS double_geom,
    cat_feature_node.num_arcs,
    cat_feature_node.isexitupperintro,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_node USING (id));


--
-- Name: v_edit_cat_hydrology; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_hydrology AS
 SELECT DISTINCT ON (c.hydrology_id) c.hydrology_id,
    c.name,
    c.infiltration,
    c.text,
    c.expl_id,
    c.active,
    c.log
   FROM cat_hydrology c,
    selector_expl s
  WHERE (((s.expl_id = c.expl_id) AND (s.cur_user = CURRENT_USER)) OR (c.expl_id IS NULL));


--
-- Name: v_edit_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_connec AS
 SELECT v_connec.connec_id,
    v_connec.code,
    v_connec.customer_code,
    v_connec.top_elev,
    v_connec.y1,
    v_connec.y2,
    v_connec.connecat_id,
    v_connec.connec_type,
    v_connec.sys_type,
    v_connec.private_connecat_id,
    v_connec.matcat_id,
    v_connec.expl_id,
    v_connec.macroexpl_id,
    v_connec.sector_id,
    v_connec.macrosector_id,
    v_connec.demand,
    v_connec.state,
    v_connec.state_type,
    v_connec.connec_depth,
    v_connec.connec_length,
    v_connec.arc_id,
    v_connec.annotation,
    v_connec.observ,
    v_connec.comment,
    v_connec.dma_id,
    v_connec.macrodma_id,
    v_connec.soilcat_id,
    v_connec.function_type,
    v_connec.category_type,
    v_connec.fluid_type,
    v_connec.location_type,
    v_connec.workcat_id,
    v_connec.workcat_id_end,
    v_connec.buildercat_id,
    v_connec.builtdate,
    v_connec.enddate,
    v_connec.ownercat_id,
    v_connec.muni_id,
    v_connec.postcode,
    v_connec.district_id,
    v_connec.streetname,
    v_connec.postnumber,
    v_connec.postcomplement,
    v_connec.streetname2,
    v_connec.postnumber2,
    v_connec.postcomplement2,
    v_connec.descript,
    v_connec.svg,
    v_connec.rotation,
    v_connec.link,
    v_connec.verified,
    v_connec.undelete,
    v_connec.label,
    v_connec.label_x,
    v_connec.label_y,
    v_connec.label_rotation,
    v_connec.accessibility,
    v_connec.diagonal,
    v_connec.publish,
    v_connec.inventory,
    v_connec.uncertain,
    v_connec.num_value,
    v_connec.pjoint_id,
    v_connec.pjoint_type,
    v_connec.tstamp,
    v_connec.insert_user,
    v_connec.lastupdate,
    v_connec.lastupdate_user,
    v_connec.the_geom,
    v_connec.workcat_id_plan,
    v_connec.asset_id,
    v_connec.drainzone_id,
    v_connec.expl_id2
   FROM v_connec;


--
-- Name: v_state_dimensions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_dimensions AS
 SELECT dimensions.id
   FROM selector_state,
    dimensions
  WHERE ((dimensions.state = selector_state.state_id) AND (selector_state.cur_user = CURRENT_USER));


--
-- Name: v_edit_dimensions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_dimensions AS
 SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.x_label,
    dimensions.y_label,
    dimensions.rotation_label,
    dimensions.offset_label,
    dimensions.direction_arrow,
    dimensions.x_symbol,
    dimensions.y_symbol,
    dimensions.feature_id,
    dimensions.feature_type,
    dimensions.state,
    dimensions.expl_id,
    dimensions.observ,
    dimensions.comment
   FROM selector_expl,
    (dimensions
     JOIN v_state_dimensions ON ((dimensions.id = v_state_dimensions.id)))
  WHERE ((dimensions.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_dma; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_dma AS
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
    dma.active
   FROM selector_expl,
    dma
  WHERE ((dma.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_drainzone; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_drainzone AS
 SELECT drainzone.drainzone_id,
    drainzone.name,
    drainzone.expl_id,
    drainzone.descript,
    drainzone.undelete,
    drainzone.link,
    drainzone.graphconfig,
    drainzone.stylesheet,
    drainzone.active,
    drainzone.the_geom
   FROM selector_expl,
    drainzone
  WHERE ((drainzone.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_state_element; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_element AS
 SELECT element.element_id
   FROM selector_state,
    element
  WHERE ((element.state = selector_state.state_id) AND (selector_state.cur_user = CURRENT_USER));


--
-- Name: v_edit_element; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_element AS
 SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.elementtype_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id
   FROM selector_expl,
    (((element
     JOIN v_state_element ON (((element.element_id)::text = (v_state_element.element_id)::text)))
     JOIN cat_element ON (((element.elementcat_id)::text = (cat_element.id)::text)))
     JOIN element_type ON (((element_type.id)::text = (cat_element.elementtype_id)::text)))
  WHERE ((element.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_exploitation; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_exploitation AS
 SELECT exploitation.expl_id,
    exploitation.name,
    exploitation.macroexpl_id,
    exploitation.descript,
    exploitation.undelete,
    exploitation.the_geom,
    exploitation.tstamp,
    exploitation.active
   FROM selector_expl,
    exploitation
  WHERE ((exploitation.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_gully AS
 SELECT v_gully.gully_id,
    v_gully.code,
    v_gully.top_elev,
    v_gully.ymax,
    v_gully.sandbox,
    v_gully.matcat_id,
    v_gully.gully_type,
    v_gully.sys_type,
    v_gully.gratecat_id,
    v_gully.cat_grate_matcat,
    v_gully.units,
    v_gully.groove,
    v_gully.siphon,
    v_gully.connec_arccat_id,
    v_gully.connec_length,
    v_gully.connec_depth,
    v_gully.arc_id,
    v_gully.expl_id,
    v_gully.macroexpl_id,
    v_gully.sector_id,
    v_gully.macrosector_id,
    v_gully.state,
    v_gully.state_type,
    v_gully.annotation,
    v_gully.observ,
    v_gully.comment,
    v_gully.dma_id,
    v_gully.macrodma_id,
    v_gully.soilcat_id,
    v_gully.function_type,
    v_gully.category_type,
    v_gully.fluid_type,
    v_gully.location_type,
    v_gully.workcat_id,
    v_gully.workcat_id_end,
    v_gully.buildercat_id,
    v_gully.builtdate,
    v_gully.enddate,
    v_gully.ownercat_id,
    v_gully.muni_id,
    v_gully.postcode,
    v_gully.district_id,
    v_gully.streetname,
    v_gully.postnumber,
    v_gully.postcomplement,
    v_gully.streetname2,
    v_gully.postnumber2,
    v_gully.postcomplement2,
    v_gully.descript,
    v_gully.svg,
    v_gully.rotation,
    v_gully.link,
    v_gully.verified,
    v_gully.undelete,
    v_gully.label,
    v_gully.label_x,
    v_gully.label_y,
    v_gully.label_rotation,
    v_gully.publish,
    v_gully.inventory,
    v_gully.uncertain,
    v_gully.num_value,
    v_gully.pjoint_id,
    v_gully.pjoint_type,
    v_gully.tstamp,
    v_gully.insert_user,
    v_gully.lastupdate,
    v_gully.lastupdate_user,
    v_gully.the_geom,
    v_gully.workcat_id_plan,
    v_gully.asset_id,
    v_gully.connec_matcat_id,
    v_gully.gratecat2_id,
    v_gully.connec_y1,
    v_gully.connec_y2,
    v_gully.epa_type,
    v_gully.groove_height,
    v_gully.groove_length,
    v_gully.grate_width,
    v_gully.grate_length,
    v_gully.units_placement,
    v_gully.drainzone_id,
    v_gully.expl_id2
   FROM v_gully;





--
-- Name: v_edit_inp_conduit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_conduit AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.cat_shape,
    v_arc.cat_geom1,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_conduit.barrels,
    inp_conduit.culvert,
    inp_conduit.kentry,
    inp_conduit.kexit,
    inp_conduit.kavg,
    inp_conduit.flap,
    inp_conduit.q0,
    inp_conduit.qmax,
    inp_conduit.seepage,
    inp_conduit.custom_n,
    v_arc.the_geom
   FROM selector_sector,
    ((v_arc
     JOIN inp_conduit USING (arc_id))
     JOIN value_state_type ON ((value_state_type.id = v_arc.state_type)))
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (value_state_type.is_operative IS TRUE));


--
-- Name: v_edit_inp_controls; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_controls AS
 SELECT DISTINCT c.id,
    c.sector_id,
    c.text,
    c.active
   FROM selector_sector,
    inp_controls c
  WHERE ((c.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_coverage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_coverage AS
 SELECT c.subc_id,
    c.landus_id,
    c.percent,
    c.hydrology_id
   FROM selector_sector,
    config_param_user,
    (inp_coverage c
     JOIN inp_subcatchment s USING (subc_id))
  WHERE ((s.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (c.hydrology_id = (config_param_user.value)::integer) AND ((config_param_user.cur_user)::text = ("current_user"())::text) AND ((config_param_user.parameter)::text = 'inp_options_hydrology_scenario'::text));


--
-- Name: v_edit_inp_curve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_curve AS
 SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.expl_id,
    c.log
   FROM selector_expl s,
    inp_curve c
  WHERE (((c.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (c.expl_id IS NULL))
  ORDER BY c.id;


--
-- Name: v_edit_inp_curve_value; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_curve_value AS
 SELECT DISTINCT cv.id,
    cv.curve_id,
    cv.x_value,
    cv.y_value
   FROM selector_expl s,
    (inp_curve c
     JOIN inp_curve_value cv ON (((c.id)::text = (cv.curve_id)::text)))
  WHERE (((c.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (c.expl_id IS NULL))
  ORDER BY cv.id;


--
-- Name: v_expl_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_expl_node AS
 SELECT DISTINCT node.node_id
   FROM selector_expl,
    node
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND ((node.expl_id = selector_expl.expl_id) OR (node.expl_id2 = selector_expl.expl_id)));


--
-- Name: v_state_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_node AS
(
         SELECT node.node_id
           FROM selector_state,
            node
          WHERE ((node.state = selector_state.state_id) AND (selector_state.cur_user = ("current_user"())::text))
        EXCEPT
         SELECT plan_psector_x_node.node_id
           FROM selector_psector,
            plan_psector_x_node
          WHERE ((plan_psector_x_node.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_node.state = 0))
) UNION
 SELECT plan_psector_x_node.node_id
   FROM selector_psector,
    plan_psector_x_node
  WHERE ((plan_psector_x_node.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_node.state = 1));


--
-- Name: vu_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_node AS
 WITH vu_node AS (
         SELECT node.node_id,
            node.code,
            node.top_elev,
            node.custom_top_elev,
                CASE
                    WHEN (node.custom_top_elev IS NOT NULL) THEN node.custom_top_elev
                    ELSE node.top_elev
                END AS sys_top_elev,
            node.ymax,
            node.custom_ymax,
                CASE
                    WHEN (node.custom_ymax IS NOT NULL) THEN node.custom_ymax
                    ELSE node.ymax
                END AS sys_ymax,
            node.elev,
            node.custom_elev,
                CASE
                    WHEN ((node.elev IS NOT NULL) AND (node.custom_elev IS NULL)) THEN node.elev
                    WHEN (node.custom_elev IS NOT NULL) THEN node.custom_elev
                    ELSE NULL::numeric(12,3)
                END AS sys_elev,
            node.node_type,
            cat_feature.system_id AS sys_type,
            node.nodecat_id,
                CASE
                    WHEN (node.matcat_id IS NULL) THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.epa_type,
            node.expl_id,
            exploitation.macroexpl_id,
            node.sector_id,
            sector.macrosector_id,
            node.state,
            node.state_type,
            node.annotation,
            node.observ,
            node.comment,
            node.dma_id,
            dma.macrodma_id,
            node.soilcat_id,
            node.function_type,
            node.category_type,
            node.fluid_type,
            node.location_type,
            node.workcat_id,
            node.workcat_id_end,
            node.buildercat_id,
            node.builtdate,
            node.enddate,
            node.ownercat_id,
            node.muni_id,
            node.postcode,
            node.district_id,
            (c.descript)::character varying(100) AS streetname,
            node.postnumber,
            node.postcomplement,
            (d.descript)::character varying(100) AS streetname2,
            node.postnumber2,
            node.postcomplement2,
            node.descript,
            cat_node.svg,
            node.rotation,
            concat(cat_feature.link_path, node.link) AS link,
            node.verified,
            node.undelete,
            cat_node.label,
            node.label_x,
            node.label_y,
            node.label_rotation,
            node.publish,
            node.inventory,
            node.uncertain,
            node.xyz_date,
            node.unconnected,
            node.num_value,
            date_trunc('second'::text, node.tstamp) AS tstamp,
            node.insert_user,
            date_trunc('second'::text, node.lastupdate) AS lastupdate,
            node.lastupdate_user,
            node.the_geom,
            node.workcat_id_plan,
            node.asset_id,
            node.drainzone_id,
            node.parent_id,
            node.arc_id,
            node.expl_id2
           FROM (((((((node
             LEFT JOIN cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)))
             LEFT JOIN cat_feature ON (((cat_feature.id)::text = (node.node_type)::text)))
             LEFT JOIN dma ON ((node.dma_id = dma.dma_id)))
             LEFT JOIN sector ON ((node.sector_id = sector.sector_id)))
             LEFT JOIN exploitation ON ((node.expl_id = exploitation.expl_id)))
             LEFT JOIN v_ext_streetaxis c ON (((c.id)::text = (node.streetaxis_id)::text)))
             LEFT JOIN v_ext_streetaxis d ON (((d.id)::text = (node.streetaxis2_id)::text)))
        )
 SELECT vu_node.node_id,
    vu_node.code,
    vu_node.top_elev,
    vu_node.custom_top_elev,
    vu_node.sys_top_elev,
    vu_node.ymax,
    vu_node.custom_ymax,
        CASE
            WHEN (vu_node.sys_ymax IS NOT NULL) THEN vu_node.sys_ymax
            ELSE ((vu_node.sys_top_elev - vu_node.sys_elev))::numeric(12,3)
        END AS sys_ymax,
    vu_node.elev,
    vu_node.custom_elev,
        CASE
            WHEN (vu_node.sys_elev IS NOT NULL) THEN vu_node.sys_elev
            ELSE ((vu_node.sys_top_elev - vu_node.sys_ymax))::numeric(12,3)
        END AS sys_elev,
    vu_node.node_type,
    vu_node.sys_type,
    vu_node.nodecat_id,
    vu_node.matcat_id,
    vu_node.epa_type,
    vu_node.expl_id,
    vu_node.macroexpl_id,
    vu_node.sector_id,
    vu_node.macrosector_id,
    vu_node.state,
    vu_node.state_type,
    vu_node.annotation,
    vu_node.observ,
    vu_node.comment,
    vu_node.dma_id,
    vu_node.macrodma_id,
    vu_node.soilcat_id,
    vu_node.function_type,
    vu_node.category_type,
    vu_node.fluid_type,
    vu_node.location_type,
    vu_node.workcat_id,
    vu_node.workcat_id_end,
    vu_node.buildercat_id,
    vu_node.builtdate,
    vu_node.enddate,
    vu_node.ownercat_id,
    vu_node.muni_id,
    vu_node.postcode,
    vu_node.district_id,
    vu_node.streetname,
    vu_node.postnumber,
    vu_node.postcomplement,
    vu_node.streetname2,
    vu_node.postnumber2,
    vu_node.postcomplement2,
    vu_node.descript,
    vu_node.svg,
    vu_node.rotation,
    vu_node.link,
    vu_node.verified,
    vu_node.the_geom,
    vu_node.undelete,
    vu_node.label,
    vu_node.label_x,
    vu_node.label_y,
    vu_node.label_rotation,
    vu_node.publish,
    vu_node.inventory,
    vu_node.uncertain,
    vu_node.xyz_date,
    vu_node.unconnected,
    vu_node.num_value,
    vu_node.tstamp,
    vu_node.insert_user,
    vu_node.lastupdate,
    vu_node.lastupdate_user,
    vu_node.workcat_id_plan,
    vu_node.asset_id,
    vu_node.drainzone_id,
    vu_node.parent_id,
    vu_node.arc_id,
    vu_node.expl_id2
   FROM vu_node;


--
-- Name: v_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_node AS
 SELECT vu_node.node_id,
    vu_node.code,
    vu_node.top_elev,
    vu_node.custom_top_elev,
    vu_node.sys_top_elev,
    vu_node.ymax,
    vu_node.custom_ymax,
    vu_node.sys_ymax,
    vu_node.elev,
    vu_node.custom_elev,
    vu_node.sys_elev,
    vu_node.node_type,
    vu_node.sys_type,
    vu_node.nodecat_id,
    vu_node.matcat_id,
    vu_node.epa_type,
    vu_node.expl_id,
    vu_node.macroexpl_id,
    vu_node.sector_id,
    vu_node.macrosector_id,
    vu_node.state,
    vu_node.state_type,
    vu_node.annotation,
    vu_node.observ,
    vu_node.comment,
    vu_node.dma_id,
    vu_node.macrodma_id,
    vu_node.soilcat_id,
    vu_node.function_type,
    vu_node.category_type,
    vu_node.fluid_type,
    vu_node.location_type,
    vu_node.workcat_id,
    vu_node.workcat_id_end,
    vu_node.buildercat_id,
    vu_node.builtdate,
    vu_node.enddate,
    vu_node.ownercat_id,
    vu_node.muni_id,
    vu_node.postcode,
    vu_node.district_id,
    vu_node.streetname,
    vu_node.postnumber,
    vu_node.postcomplement,
    vu_node.streetname2,
    vu_node.postnumber2,
    vu_node.postcomplement2,
    vu_node.descript,
    vu_node.svg,
    vu_node.rotation,
    vu_node.link,
    vu_node.verified,
    vu_node.the_geom,
    vu_node.undelete,
    vu_node.label,
    vu_node.label_x,
    vu_node.label_y,
    vu_node.label_rotation,
    vu_node.publish,
    vu_node.inventory,
    vu_node.uncertain,
    vu_node.xyz_date,
    vu_node.unconnected,
    vu_node.num_value,
    vu_node.tstamp,
    vu_node.insert_user,
    vu_node.lastupdate,
    vu_node.lastupdate_user,
    vu_node.workcat_id_plan,
    vu_node.asset_id,
    vu_node.drainzone_id,
    vu_node.parent_id,
    vu_node.arc_id,
    vu_node.expl_id2
   FROM ((vu_node
     JOIN v_state_node USING (node_id))
     JOIN v_expl_node e ON (((e.node_id)::text = (vu_node.node_id)::text)));


--
-- Name: v_sector_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_sector_node AS
 SELECT node.node_id
   FROM selector_sector,
    node
  WHERE ((selector_sector.cur_user = ("current_user"())::text) AND (node.sector_id = selector_sector.sector_id))
UNION
 SELECT node_border_sector.node_id
   FROM selector_sector,
    node_border_sector
  WHERE ((selector_sector.cur_user = ("current_user"())::text) AND (node_border_sector.sector_id = selector_sector.sector_id));


--
-- Name: v_edit_inp_divider; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_divider AS
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_divider.divider_type,
    inp_divider.arc_id,
    inp_divider.curve_id,
    inp_divider.qmin,
    inp_divider.ht,
    inp_divider.cd,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond,
    v_node.the_geom
   FROM (((v_sector_node
     JOIN v_node USING (node_id))
     JOIN inp_divider ON (((v_node.node_id)::text = (inp_divider.node_id)::text)))
     JOIN value_state_type ON ((value_state_type.id = v_node.state_type)))
  WHERE (value_state_type.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_conduit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_conduit AS
 SELECT f.dscenario_id,
    arc_id,
    f.arccat_id,
    f.matcat_id,
    f.elev1,
    f.elev2,
    f.custom_n,
    f.barrels,
    f.culvert,
    f.kentry,
    f.kexit,
    f.kavg,
    f.flap,
    f.q0,
    f.qmax,
    f.seepage,
    v_edit_inp_conduit.the_geom
   FROM selector_inp_dscenario s,
    (inp_dscenario_conduit f
     JOIN v_edit_inp_conduit USING (arc_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_dscenario_controls; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_controls AS
 SELECT i.id,
    d.dscenario_id,
    i.sector_id,
    i.text,
    i.active
   FROM selector_inp_dscenario,
    (inp_dscenario_controls i
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((i.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_node AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.sys_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.sys_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.matcat_id,
    v_node.epa_type,
    v_node.expl_id,
    v_node.macroexpl_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.macrodma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.num_value,
    v_node.tstamp,
    v_node.insert_user,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.workcat_id_plan,
    v_node.asset_id,
    v_node.drainzone_id,
    v_node.parent_id,
    v_node.arc_id,
    v_node.expl_id2
   FROM v_node;


--
-- Name: v_edit_inp_flwreg_orifice; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_flwreg_orifice AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.ori_type,
    f.offsetval,
    f.cd,
    f.orate,
    f.flap,
    f.shape,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.close_time,
    (public.st_setsrid(public.st_makeline(n.the_geom, public.st_lineinterpolatepoint(a.the_geom, (f.flwreg_length / public.st_length(a.the_geom)))), SRID_VALUE))::public.geometry(LineString,SRID_VALUE) AS the_geom
   FROM ((((v_sector_node
     JOIN inp_flwreg_orifice f USING (node_id))
     JOIN v_edit_node n USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
     LEFT JOIN arc a ON (((a.arc_id)::text = (f.to_arc)::text)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_flwreg_orifice; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_flwreg_orifice AS
 SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.ori_type,
    f.offsetval,
    f.cd,
    f.orate,
    f.flap,
    f.shape,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.close_time,
    n.the_geom
   FROM selector_inp_dscenario s,
    (inp_dscenario_flwreg_orifice f
     JOIN v_edit_inp_flwreg_orifice n USING (nodarc_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = (CURRENT_USER)::text));


--
-- Name: v_edit_inp_flwreg_outlet; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_flwreg_outlet AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    (public.st_setsrid(public.st_makeline(n.the_geom, public.st_lineinterpolatepoint(a.the_geom, (f.flwreg_length / public.st_length(a.the_geom)))), SRID_VALUE))::public.geometry(LineString,SRID_VALUE) AS the_geom
   FROM ((((v_sector_node
     JOIN inp_flwreg_outlet f USING (node_id))
     JOIN v_edit_node n USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
     LEFT JOIN arc a ON (((a.arc_id)::text = (f.to_arc)::text)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_flwreg_outlet; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_flwreg_outlet AS
 SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    n.the_geom
   FROM selector_inp_dscenario s,
    (inp_dscenario_flwreg_outlet f
     JOIN v_edit_inp_flwreg_outlet n USING (nodarc_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = (CURRENT_USER)::text));


--
-- Name: v_edit_inp_flwreg_pump; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_flwreg_pump AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    (public.st_setsrid(public.st_makeline(n.the_geom, public.st_lineinterpolatepoint(a.the_geom, (f.flwreg_length / public.st_length(a.the_geom)))), SRID_VALUE))::public.geometry(LineString,SRID_VALUE) AS the_geom
   FROM ((((v_sector_node
     JOIN inp_flwreg_pump f USING (node_id))
     JOIN v_edit_node n USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
     LEFT JOIN arc a ON (((a.arc_id)::text = (f.to_arc)::text)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_flwreg_pump; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_flwreg_pump AS
 SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
   FROM selector_inp_dscenario s,
    (inp_dscenario_flwreg_pump f
     JOIN v_edit_inp_flwreg_pump n USING (nodarc_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = (CURRENT_USER)::text));


--
-- Name: v_edit_inp_flwreg_weir; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_flwreg_weir AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.weir_type,
    f.offsetval,
    f.cd,
    f.ec,
    f.cd2,
    f.flap,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.surcharge,
    f.road_width,
    f.road_surf,
    f.coef_curve,
    (public.st_setsrid(public.st_makeline(n.the_geom, public.st_lineinterpolatepoint(a.the_geom, (f.flwreg_length / public.st_length(a.the_geom)))), SRID_VALUE))::public.geometry(LineString,SRID_VALUE) AS the_geom
   FROM ((((v_sector_node
     JOIN inp_flwreg_weir f USING (node_id))
     JOIN v_edit_node n USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
     LEFT JOIN arc a ON (((a.arc_id)::text = (f.to_arc)::text)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_flwreg_weir; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_flwreg_weir AS
 SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.weir_type,
    f.offsetval,
    f.cd,
    f.ec,
    f.cd2,
    f.flap,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.surcharge,
    f.road_width,
    f.road_surf,
    f.coef_curve,
    n.the_geom
   FROM selector_inp_dscenario s,
    (inp_dscenario_flwreg_weir f
     JOIN v_edit_inp_flwreg_weir n USING (nodarc_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = (CURRENT_USER)::text));


--
-- Name: v_edit_inp_junction; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_junction AS
 SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    (inp_junction.outfallparam)::text AS outfallparam,
    n.the_geom
   FROM (((v_sector_node
     JOIN v_edit_node n USING (node_id))
     JOIN inp_junction USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_inflows; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_inflows AS
 SELECT s.dscenario_id,
    node_id,
    f.order_id,
    f.timser_id,
    f.sfactor,
    f.base,
    f.pattern_id
   FROM selector_inp_dscenario s,
    (inp_dscenario_inflows f
     JOIN v_edit_inp_junction USING (node_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_dscenario_inflows_poll; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_inflows_poll AS
 SELECT s.dscenario_id,
    node_id,
    f.poll_id,
    f.timser_id,
    f.form_type,
    f.mfactor,
    f.sfactor,
    f.base,
    f.pattern_id
   FROM selector_inp_dscenario s,
    (inp_dscenario_inflows_poll f
     JOIN v_edit_inp_junction USING (node_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_dscenario_junction; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_junction AS
 SELECT f.dscenario_id,
    node_id,
    f.elev,
    f.ymax,
    f.y0,
    f.ysur,
    f.apond,
    f.outfallparam,
    v_edit_inp_junction.the_geom
   FROM selector_inp_dscenario s,
    (inp_dscenario_junction f
     JOIN v_edit_inp_junction USING (node_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_subcatchment; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_subcatchment AS
 SELECT inp_subcatchment.hydrology_id,
    inp_subcatchment.subc_id,
    inp_subcatchment.outlet_id,
    inp_subcatchment.rg_id,
    inp_subcatchment.area,
    inp_subcatchment.imperv,
    inp_subcatchment.width,
    inp_subcatchment.slope,
    inp_subcatchment.clength,
    inp_subcatchment.snow_id,
    inp_subcatchment.nimp,
    inp_subcatchment.nperv,
    inp_subcatchment.simp,
    inp_subcatchment.sperv,
    inp_subcatchment.zero,
    inp_subcatchment.routeto,
    inp_subcatchment.rted,
    inp_subcatchment.maxrate,
    inp_subcatchment.minrate,
    inp_subcatchment.decay,
    inp_subcatchment.drytime,
    inp_subcatchment.maxinfil,
    inp_subcatchment.suction,
    inp_subcatchment.conduct,
    inp_subcatchment.initdef,
    inp_subcatchment.curveno,
    inp_subcatchment.conduct_2,
    inp_subcatchment.drytime_2,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom,
    inp_subcatchment.descript
   FROM selector_sector,
    inp_subcatchment,
    config_param_user
  WHERE ((inp_subcatchment.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (inp_subcatchment.hydrology_id = (config_param_user.value)::integer) AND ((config_param_user.cur_user)::text = ("current_user"())::text) AND ((config_param_user.parameter)::text = 'inp_options_hydrology_scenario'::text));


--
-- Name: v_edit_inp_dscenario_lid_usage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_lid_usage AS
 SELECT sd.dscenario_id,
    l.subc_id,
    l.lidco_id,
    l.numelem,
    l.area,
    l.width,
    l.initsat,
    l.fromimp,
    l.toperv,
    l.rptfile,
    l.descript,
    s.the_geom
   FROM selector_inp_dscenario sd,
    (inp_dscenario_lid_usage l
     JOIN v_edit_inp_subcatchment s USING (subc_id))
  WHERE ((l.dscenario_id = sd.dscenario_id) AND (sd.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_outfall; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_outfall AS
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate,
    v_node.the_geom
   FROM (((v_sector_node
     JOIN v_node USING (node_id))
     JOIN inp_outfall USING (node_id))
     JOIN value_state_type ON ((value_state_type.id = v_node.state_type)))
  WHERE (value_state_type.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_outfall; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_outfall AS
 SELECT s.dscenario_id,
    f.node_id,
    f.elev,
    f.ymax,
    f.outfall_type,
    f.stage,
    f.curve_id,
    f.timser_id,
    f.gate,
    v_edit_inp_outfall.the_geom
   FROM selector_inp_dscenario s,
    (inp_dscenario_outfall f
     JOIN v_edit_inp_outfall USING (node_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_edit_raingage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_raingage AS
 SELECT raingage.rg_id,
    raingage.form_type,
    raingage.intvl,
    raingage.scf,
    raingage.rgage_type,
    raingage.timser_id,
    raingage.fname,
    raingage.sta,
    raingage.units,
    raingage.the_geom,
    raingage.expl_id
   FROM selector_expl,
    raingage
  WHERE ((raingage.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_edit_inp_dscenario_raingage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_raingage AS
 SELECT p.dscenario_id,
    p.rg_id,
    p.form_type,
    p.intvl,
    p.scf,
    p.rgage_type,
    p.timser_id,
    p.fname,
    p.sta,
    p.units,
    v_edit_raingage.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_raingage
     JOIN inp_dscenario_raingage p USING (rg_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_storage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_storage AS
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_storage.storage_type,
    inp_storage.curve_id,
    inp_storage.a1,
    inp_storage.a2,
    inp_storage.a0,
    inp_storage.fevap,
    inp_storage.sh,
    inp_storage.hc,
    inp_storage.imd,
    inp_storage.y0,
    inp_storage.ysur,
    inp_storage.apond,
    v_node.the_geom
   FROM (((v_sector_node
     JOIN v_node USING (node_id))
     JOIN inp_storage USING (node_id))
     JOIN value_state_type ON ((value_state_type.id = v_node.state_type)))
  WHERE (value_state_type.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_storage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_storage AS
 SELECT s.dscenario_id,
    f.node_id,
    f.elev,
    f.ymax,
    f.storage_type,
    f.curve_id,
    f.a1,
    f.a2,
    f.a0,
    f.fevap,
    f.sh,
    f.hc,
    f.imd,
    f.y0,
    f.ysur,
    f.apond,
    v_edit_inp_storage.the_geom
   FROM selector_inp_dscenario s,
    (inp_dscenario_storage f
     JOIN v_edit_inp_storage USING (node_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_dscenario_treatment; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_treatment AS
 SELECT s.dscenario_id,
    node_id,
    f.poll_id,
    f.function
   FROM selector_inp_dscenario s,
    (inp_dscenario_treatment f
     JOIN v_edit_inp_junction USING (node_id))
  WHERE ((s.dscenario_id = f.dscenario_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_dwf; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dwf AS
 SELECT i.dwfscenario_id,
    node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4
   FROM config_param_user c,
    (inp_dwf i
     JOIN v_edit_inp_junction USING (node_id))
  WHERE (((c.cur_user)::name = CURRENT_USER) AND ((c.parameter)::text = 'inp_options_dwfscenario'::text) AND ((c.value)::integer = i.dwfscenario_id));


--
-- Name: v_edit_inp_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_gully AS
 SELECT g.gully_id,
    g.code,
    g.top_elev,
    g.gully_type,
    g.gratecat_id,
    ((g.grate_width / (100)::numeric))::numeric(12,2) AS grate_width,
    ((g.grate_length / (100)::numeric))::numeric(12,2) AS grate_length,
    g.arc_id,
    s.sector_id,
    g.expl_id,
    g.state,
    g.state_type,
    g.the_geom,
    g.units,
    g.units_placement,
    g.groove,
    g.groove_height,
    g.groove_length,
    g.pjoint_id,
    g.pjoint_type,
    cat_grate.a_param,
    cat_grate.b_param,
        CASE
            WHEN ((g.units_placement)::text = 'LENGTH-SIDE'::text) THEN ((((COALESCE((g.units)::integer, 1))::numeric * g.grate_width) / (100)::numeric))::numeric(12,3)
            WHEN ((g.units_placement)::text = 'WIDTH-SIDE'::text) THEN ((((COALESCE((g.units)::integer, 1))::numeric * g.grate_length) / (100)::numeric))::numeric(12,3)
            ELSE ((cat_grate.width / (100)::numeric))::numeric(12,3)
        END AS total_width,
        CASE
            WHEN ((g.units_placement)::text = 'LENGTH-SIDE'::text) THEN ((((COALESCE((g.units)::integer, 1))::numeric * g.grate_width) / (100)::numeric))::numeric(12,3)
            WHEN ((g.units_placement)::text = 'WIDTH-SIDE'::text) THEN ((((COALESCE((g.units)::integer, 1))::numeric * g.grate_length) / (100)::numeric))::numeric(12,3)
            ELSE ((cat_grate.length / (100)::numeric))::numeric(12,3)
        END AS total_length,
    (g.ymax - COALESCE(g.sandbox, (0)::numeric)) AS depth,
    g.annotation,
    i.outlet_type,
    i.custom_top_elev,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
   FROM selector_sector s,
    (((v_edit_gully g
     JOIN inp_gully i USING (gully_id))
     JOIN cat_grate ON (((g.gratecat_id)::text = (cat_grate.id)::text)))
     JOIN value_state_type vs ON ((vs.id = g.state_type)))
  WHERE ((g.sector_id = s.sector_id) AND (s.cur_user = ("current_user"())::text) AND (vs.is_operative IS TRUE));


--
-- Name: v_edit_inp_inflows; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_inflows AS
 SELECT node_id,
    inp_inflows.order_id,
    inp_inflows.timser_id,
    inp_inflows.sfactor,
    inp_inflows.base,
    inp_inflows.pattern_id
   FROM (inp_inflows
     JOIN v_edit_inp_junction USING (node_id));


--
-- Name: v_edit_inp_inflows_poll; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_inflows_poll AS
 SELECT node_id,
    inp_inflows_poll.poll_id,
    inp_inflows_poll.timser_id,
    inp_inflows_poll.form_type,
    inp_inflows_poll.mfactor,
    inp_inflows_poll.sfactor,
    inp_inflows_poll.base,
    inp_inflows_poll.pattern_id
   FROM (inp_inflows_poll
     JOIN v_edit_inp_junction USING (node_id));


--
-- Name: v_edit_inp_netgully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_netgully AS
 SELECT n.node_id,
    n.code,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.node_type,
    n.nodecat_id,
    man_netgully.gratecat_id,
    ((cat_grate.width / (100)::numeric))::numeric(12,3) AS grate_width,
    ((cat_grate.length / (100)::numeric))::numeric(12,3) AS grate_length,
    n.sector_id,
    n.macrosector_id,
    n.expl_id,
    n.state,
    n.state_type,
    n.the_geom,
    man_netgully.units,
    man_netgully.units_placement,
    man_netgully.groove,
    man_netgully.groove_height,
    man_netgully.groove_length,
    cat_grate.a_param,
    cat_grate.b_param,
        CASE
            WHEN ((man_netgully.units_placement)::text = 'LENGTH-SIDE'::text) THEN ((((COALESCE((man_netgully.units)::integer, 1))::numeric * cat_grate.width) / (100)::numeric))::numeric(12,3)
            WHEN ((man_netgully.units_placement)::text = 'WIDTH-SIDE'::text) THEN ((((COALESCE((man_netgully.units)::integer, 1))::numeric * cat_grate.length) / (100)::numeric))::numeric(12,3)
            ELSE ((cat_grate.width / (100)::numeric))::numeric(12,3)
        END AS total_width,
        CASE
            WHEN ((man_netgully.units_placement)::text = 'LENGTH-SIDE'::text) THEN ((((COALESCE((man_netgully.units)::integer, 1))::numeric * cat_grate.width) / (100)::numeric))::numeric(12,3)
            WHEN ((man_netgully.units_placement)::text = 'WIDTH-SIDE'::text) THEN ((((COALESCE((man_netgully.units)::integer, 1))::numeric * cat_grate.length) / (100)::numeric))::numeric(12,3)
            ELSE ((cat_grate.length / (100)::numeric))::numeric(12,3)
        END AS total_length,
    (n.ymax - COALESCE(man_netgully.sander_depth, (0)::numeric)) AS depth,
    n.annotation,
    i.y0,
    i.ysur,
    i.apond,
    i.outlet_type,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
   FROM (((((v_sector_node
     JOIN v_node n USING (node_id))
     JOIN inp_netgully i USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
     LEFT JOIN man_netgully USING (node_id))
     LEFT JOIN cat_grate ON (((man_netgully.gratecat_id)::text = (cat_grate.id)::text)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_orifice; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_orifice AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_orifice.ori_type,
    inp_orifice.offsetval,
    inp_orifice.cd,
    inp_orifice.orate,
    inp_orifice.flap,
    inp_orifice.shape,
    inp_orifice.geom1,
    inp_orifice.geom2,
    inp_orifice.geom3,
    inp_orifice.geom4,
    v_arc.the_geom,
    inp_orifice.close_time
   FROM selector_sector,
    ((v_arc
     JOIN inp_orifice USING (arc_id))
     JOIN value_state_type ON ((value_state_type.id = v_arc.state_type)))
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (value_state_type.is_operative IS TRUE));


--
-- Name: v_edit_inp_outlet; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_outlet AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_outlet.outlet_type,
    inp_outlet.offsetval,
    inp_outlet.curve_id,
    inp_outlet.cd1,
    inp_outlet.cd2,
    inp_outlet.flap,
    v_arc.the_geom
   FROM selector_sector,
    ((v_arc
     JOIN inp_outlet USING (arc_id))
     JOIN value_state_type ON ((value_state_type.id = v_arc.state_type)))
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (value_state_type.is_operative IS TRUE));


--
-- Name: v_edit_inp_pattern; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pattern AS
 SELECT DISTINCT p.pattern_id,
    p.pattern_type,
    p.observ,
    (p.tsparameters)::text AS tsparameters,
    p.expl_id,
    p.log
   FROM selector_expl s,
    inp_pattern p
  WHERE (((p.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (p.expl_id IS NULL))
  ORDER BY p.pattern_id;


--
-- Name: v_edit_inp_pattern_value; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pattern_value AS
 SELECT p.pattern_id,
    p.pattern_type,
    p.observ,
    (p.tsparameters)::text AS tsparameters,
    p.expl_id,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18,
    inp_pattern_value.factor_19,
    inp_pattern_value.factor_20,
    inp_pattern_value.factor_21,
    inp_pattern_value.factor_22,
    inp_pattern_value.factor_23,
    inp_pattern_value.factor_24
   FROM selector_expl s,
    (inp_pattern p
     JOIN inp_pattern_value USING (pattern_id))
  WHERE (((p.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (p.expl_id IS NULL))
  ORDER BY p.pattern_id;


--
-- Name: v_edit_inp_pump; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pump AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_pump.curve_id,
    inp_pump.status,
    inp_pump.startup,
    inp_pump.shutoff,
    v_arc.the_geom
   FROM selector_sector,
    ((v_arc
     JOIN inp_pump USING (arc_id))
     JOIN value_state_type ON ((value_state_type.id = v_arc.state_type)))
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (value_state_type.is_operative IS TRUE));


--
-- Name: v_edit_inp_timeseries; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_timeseries AS
 SELECT DISTINCT p.id,
    p.timser_type,
    p.times_type,
    p.idval,
    p.descript,
    p.fname,
    p.expl_id,
    p.log,
    p.active
   FROM selector_expl s,
    inp_timeseries p
  WHERE (((p.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (p.expl_id IS NULL))
  ORDER BY p.id;


--
-- Name: v_edit_inp_timeseries_value; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_timeseries_value AS
 SELECT DISTINCT p.id,
    p.timser_id,
    t.timser_type,
    t.times_type,
    t.idval,
    t.expl_id,
    p.date,
    p.hour,
    p."time",
    p.value
   FROM selector_expl s,
    (inp_timeseries t
     JOIN inp_timeseries_value p ON (((t.id)::text = (p.timser_id)::text)))
  WHERE (((t.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (t.expl_id IS NULL))
  ORDER BY p.id;


--
-- Name: v_edit_inp_treatment; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_treatment AS
 SELECT node_id,
    inp_treatment.poll_id,
    inp_treatment.function
   FROM (inp_treatment
     JOIN v_edit_inp_junction USING (node_id));


--
-- Name: v_edit_inp_virtual; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_virtual AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.expl_id,
    inp_virtual.fusion_node,
    inp_virtual.add_length,
    v_arc.the_geom
   FROM selector_sector,
    ((v_arc
     JOIN inp_virtual USING (arc_id))
     JOIN value_state_type ON ((value_state_type.id = v_arc.state_type)))
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (value_state_type.is_operative IS TRUE));


--
-- Name: v_edit_inp_weir; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_weir AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_weir.weir_type,
    inp_weir.offsetval,
    inp_weir.cd,
    inp_weir.ec,
    inp_weir.cd2,
    inp_weir.flap,
    inp_weir.geom1,
    inp_weir.geom2,
    inp_weir.geom3,
    inp_weir.geom4,
    inp_weir.surcharge,
    v_arc.the_geom,
    inp_weir.road_width,
    inp_weir.road_surf,
    inp_weir.coef_curve
   FROM selector_sector,
    ((v_arc
     JOIN inp_weir USING (arc_id))
     JOIN value_state_type ON ((value_state_type.id = v_arc.state_type)))
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (value_state_type.is_operative IS TRUE));


--
-- Name: v_state_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_link AS
(
         SELECT DISTINCT link.link_id
           FROM selector_state,
            selector_expl,
            link
          WHERE ((link.state = selector_state.state_id) AND ((link.expl_id = selector_expl.expl_id) OR (link.expl_id2 = selector_expl.expl_id)) AND (selector_state.cur_user = ("current_user"())::text) AND (selector_expl.cur_user = ("current_user"())::text))
        EXCEPT ALL (
                 SELECT plan_psector_x_connec.link_id
                   FROM selector_psector,
                    selector_expl,
                    (plan_psector_x_connec
                     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
                  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_connec.active IS TRUE))
                UNION ALL
                 SELECT plan_psector_x_gully.link_id
                   FROM selector_psector,
                    selector_expl,
                    (plan_psector_x_gully
                     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_gully.psector_id)))
                  WHERE ((plan_psector_x_gully.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_gully.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_gully.active IS TRUE))
        )
) UNION ALL (
         SELECT plan_psector_x_connec.link_id
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_connec
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
          WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_connec.active IS TRUE))
        UNION ALL
         SELECT plan_psector_x_gully.link_id
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_gully
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_gully.psector_id)))
          WHERE ((plan_psector_x_gully.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_gully.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_gully.active IS TRUE))
);


--
-- Name: vu_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    (public.st_length2d(l.the_geom))::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    s.macrosector_id,
    d.macrodma_id,
    l.expl_id2
   FROM ((link l
     LEFT JOIN sector s USING (sector_id))
     LEFT JOIN dma d USING (dma_id));


--
-- Name: v_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_link AS
 SELECT DISTINCT ON (vu_link.link_id) vu_link.link_id,
    vu_link.feature_type,
    vu_link.feature_id,
    vu_link.exit_type,
    vu_link.exit_id,
    vu_link.state,
    vu_link.expl_id,
    vu_link.sector_id,
    vu_link.dma_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.expl_id2
   FROM (vu_link
     JOIN v_state_link USING (link_id));


--
-- Name: v_edit_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    l.gis_length,
    l.the_geom,
    l.sector_name,
    l.macrosector_id,
    l.macrodma_id,
    l.expl_id2
   FROM v_link l;


--
-- Name: v_edit_link_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_link_connec AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    l.gis_length,
    l.the_geom,
    l.sector_name,
    l.macrosector_id,
    l.macrodma_id
   FROM v_link_connec l;


--
-- Name: v_edit_link_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_link_gully AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    l.gis_length,
    l.the_geom,
    l.sector_name,
    l.macrosector_id,
    l.macrodma_id
   FROM v_link_gully l;


--
-- Name: v_edit_macrodma; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_macrodma AS
 SELECT macrodma.macrodma_id,
    macrodma.name,
    macrodma.descript,
    macrodma.the_geom,
    macrodma.undelete,
    macrodma.expl_id,
    macrodma.active
   FROM selector_expl,
    macrodma
  WHERE ((macrodma.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_macrosector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_macrosector AS
 SELECT macrosector.macrosector_id,
    macrosector.name,
    macrosector.descript,
    macrosector.the_geom,
    macrosector.undelete,
    macrosector.active
   FROM macrosector
  WHERE (macrosector.active IS TRUE);


--
-- Name: v_edit_man_netelement; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_man_netelement AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN (v_node.sys_elev IS NOT NULL) THEN v_node.sys_elev
            ELSE ((v_node.sys_top_elev - v_node.sys_ymax))::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    v_node.the_geom,
    man_netelement.serial_number
   FROM (v_node
     JOIN man_netelement ON (((man_netelement.node_id)::text = (v_node.node_id)::text)));


--
-- Name: v_edit_om_visit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_om_visit AS
 SELECT om_visit.id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.the_geom,
    om_visit.webclient_id,
    om_visit.expl_id
   FROM selector_expl,
    om_visit
  WHERE ((om_visit.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_edit_plan_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_plan_psector AS
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active,
    plan_psector.ext_code,
    plan_psector.status,
    plan_psector.text3,
    plan_psector.text4,
    plan_psector.text5,
    plan_psector.text6,
    plan_psector.num_value,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    plan_psector
  WHERE ((plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_plan_psector_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_plan_psector_x_connec AS
 SELECT plan_psector_x_connec.id,
    plan_psector_x_connec.connec_id,
    plan_psector_x_connec.arc_id,
    plan_psector_x_connec.psector_id,
    plan_psector_x_connec.state,
    plan_psector_x_connec.doable,
    plan_psector_x_connec.descript,
    plan_psector_x_connec.link_id,
    plan_psector_x_connec.active,
    plan_psector_x_connec.insert_tstamp,
    plan_psector_x_connec.insert_user
   FROM plan_psector_x_connec;


--
-- Name: v_edit_plan_psector_x_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_plan_psector_x_gully AS
 SELECT plan_psector_x_gully.id,
    plan_psector_x_gully.gully_id,
    plan_psector_x_gully.arc_id,
    plan_psector_x_gully.psector_id,
    plan_psector_x_gully.state,
    plan_psector_x_gully.doable,
    plan_psector_x_gully.descript,
    plan_psector_x_gully.link_id,
    plan_psector_x_gully.active,
    plan_psector_x_gully.insert_tstamp,
    plan_psector_x_gully.insert_user
   FROM plan_psector_x_gully;


--
-- Name: v_price_compost; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_compost AS
SELECT
    NULL::character varying(16) AS id,
    NULL::character varying(5) AS unit,
    NULL::character varying(100) AS descript,
    NULL::numeric(14,2) AS price;


--
-- Name: v_edit_plan_psector_x_other; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_plan_psector_x_other AS
 SELECT plan_psector_x_other.id,
    plan_psector_x_other.psector_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    rpad((v_price_compost.descript)::text, 125) AS price_descript,
    v_price_compost.price,
    plan_psector_x_other.measurement,
    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget,
    plan_psector_x_other.observ,
    plan_psector.atlas_id
   FROM ((plan_psector_x_other
     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_other.psector_id)))
  ORDER BY plan_psector_x_other.psector_id;


--
-- Name: v_edit_review_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_arc AS
 SELECT review_arc.arc_id,
    arc.node_1,
    review_arc.y1,
    arc.node_2,
    review_arc.y2,
    review_arc.arc_type,
    review_arc.matcat_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.review_obs,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_date,
    review_arc.field_checked,
    review_arc.is_validated
   FROM selector_expl,
    (review_arc
     JOIN arc ON (((review_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_arc.expl_id = selector_expl.expl_id));


--
-- Name: v_edit_review_audit_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_arc AS
 SELECT review_audit_arc.id,
    review_audit_arc.arc_id,
    review_audit_arc.old_y1,
    review_audit_arc.new_y1,
    review_audit_arc.old_y2,
    review_audit_arc.new_y2,
    review_audit_arc.old_arc_type,
    review_audit_arc.new_arc_type,
    review_audit_arc.old_matcat_id,
    review_audit_arc.new_matcat_id,
    review_audit_arc.old_arccat_id,
    review_audit_arc.new_arccat_id,
    review_audit_arc.old_annotation,
    review_audit_arc.new_annotation,
    review_audit_arc.old_observ,
    review_audit_arc.new_observ,
    review_audit_arc.review_obs,
    review_audit_arc.expl_id,
    review_audit_arc.the_geom,
    review_audit_arc.review_status_id,
    review_audit_arc.field_date,
    review_audit_arc.field_user,
    review_audit_arc.is_validated
   FROM review_audit_arc,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_audit_arc.expl_id = selector_expl.expl_id) AND (review_audit_arc.review_status_id <> 0) AND (review_audit_arc.is_validated IS NULL));


--
-- Name: v_edit_review_audit_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_connec AS
 SELECT review_audit_connec.id,
    review_audit_connec.connec_id,
    review_audit_connec.old_y1,
    review_audit_connec.new_y1,
    review_audit_connec.old_y2,
    review_audit_connec.new_y2,
    review_audit_connec.old_connec_type,
    review_audit_connec.new_connec_type,
    review_audit_connec.old_matcat_id,
    review_audit_connec.new_matcat_id,
    review_audit_connec.old_connecat_id,
    review_audit_connec.new_connecat_id,
    review_audit_connec.old_annotation,
    review_audit_connec.new_annotation,
    review_audit_connec.old_observ,
    review_audit_connec.new_observ,
    review_audit_connec.review_obs,
    review_audit_connec.expl_id,
    review_audit_connec.the_geom,
    review_audit_connec.review_status_id,
    review_audit_connec.field_date,
    review_audit_connec.field_user,
    review_audit_connec.is_validated
   FROM review_audit_connec,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_audit_connec.expl_id = selector_expl.expl_id) AND (review_audit_connec.review_status_id <> 0) AND (review_audit_connec.is_validated IS NULL));


--
-- Name: v_edit_review_audit_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_gully AS
 SELECT review_audit_gully.id,
    review_audit_gully.gully_id,
    review_audit_gully.old_top_elev,
    review_audit_gully.new_top_elev,
    review_audit_gully.old_ymax,
    review_audit_gully.new_ymax,
    review_audit_gully.old_sandbox,
    review_audit_gully.new_sandbox,
    review_audit_gully.old_matcat_id,
    review_audit_gully.new_matcat_id,
    review_audit_gully.old_gully_type,
    review_audit_gully.new_gully_type,
    review_audit_gully.old_gratecat_id,
    review_audit_gully.new_gratecat_id,
    review_audit_gully.old_units,
    review_audit_gully.new_units,
    review_audit_gully.old_groove,
    review_audit_gully.new_groove,
    review_audit_gully.old_siphon,
    review_audit_gully.new_siphon,
    review_audit_gully.old_connec_arccat_id,
    review_audit_gully.new_connec_arccat_id,
    review_audit_gully.old_annotation,
    review_audit_gully.new_annotation,
    review_audit_gully.old_observ,
    review_audit_gully.new_observ,
    review_audit_gully.review_obs,
    review_audit_gully.expl_id,
    review_audit_gully.the_geom,
    review_audit_gully.review_status_id,
    review_audit_gully.field_date,
    review_audit_gully.field_user,
    review_audit_gully.is_validated
   FROM review_audit_gully,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_audit_gully.expl_id = selector_expl.expl_id) AND (review_audit_gully.review_status_id <> 0) AND (review_audit_gully.is_validated IS NULL));


--
-- Name: v_edit_review_audit_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_node AS
 SELECT review_audit_node.id,
    review_audit_node.node_id,
    review_audit_node.old_top_elev,
    review_audit_node.new_top_elev,
    review_audit_node.old_ymax,
    review_audit_node.new_ymax,
    review_audit_node.old_node_type,
    review_audit_node.new_node_type,
    review_audit_node.old_matcat_id,
    review_audit_node.new_matcat_id,
    review_audit_node.old_nodecat_id,
    review_audit_node.new_nodecat_id,
    review_audit_node.old_step_pp,
    review_audit_node.new_step_pp,
    review_audit_node.old_step_fe,
    review_audit_node.new_step_fe,
    review_audit_node.old_step_replace,
    review_audit_node.new_step_replace,
    review_audit_node.old_cover,
    review_audit_node.new_cover,
    review_audit_node.old_annotation,
    review_audit_node.new_annotation,
    review_audit_node.old_observ,
    review_audit_node.new_observ,
    review_audit_node.review_obs,
    review_audit_node.expl_id,
    review_audit_node.the_geom,
    review_audit_node.review_status_id,
    review_audit_node.field_date,
    review_audit_node.field_user,
    review_audit_node.is_validated
   FROM review_audit_node,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_audit_node.expl_id = selector_expl.expl_id) AND (review_audit_node.review_status_id <> 0) AND (review_audit_node.is_validated IS NULL));


--
-- Name: v_edit_review_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_connec AS
 SELECT review_connec.connec_id,
    review_connec.y1,
    review_connec.y2,
    review_connec.connec_type,
    review_connec.matcat_id,
    review_connec.connecat_id,
    review_connec.annotation,
    review_connec.observ,
    review_connec.review_obs,
    review_connec.expl_id,
    review_connec.the_geom,
    review_connec.field_date,
    review_connec.field_checked,
    review_connec.is_validated
   FROM review_connec,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_connec.expl_id = selector_expl.expl_id));


--
-- Name: v_edit_review_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_gully AS
 SELECT review_gully.gully_id,
    review_gully.top_elev,
    review_gully.ymax,
    review_gully.sandbox,
    review_gully.matcat_id,
    review_gully.gully_type,
    review_gully.gratecat_id,
    review_gully.units,
    review_gully.groove,
    review_gully.siphon,
    review_gully.connec_arccat_id,
    review_gully.annotation,
    review_gully.observ,
    review_gully.review_obs,
    review_gully.expl_id,
    review_gully.the_geom,
    review_gully.field_date,
    review_gully.field_checked,
    review_gully.is_validated
   FROM review_gully,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_gully.expl_id = selector_expl.expl_id));


--
-- Name: v_edit_review_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_node AS
 SELECT review_node.node_id,
    review_node.top_elev,
    review_node.ymax,
    review_node.node_type,
    review_node.matcat_id,
    review_node.nodecat_id,
    review_node.step_pp,
    review_node.step_fe,
    review_node.step_replace,
    review_node.cover,
    review_node.annotation,
    review_node.observ,
    review_node.review_obs,
    review_node.expl_id,
    review_node.the_geom,
    review_node.field_date,
    review_node.field_checked,
    review_node.is_validated
   FROM review_node,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_node.expl_id = selector_expl.expl_id));


--
-- Name: v_edit_rtc_hydro_data_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_rtc_hydro_data_x_connec AS
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_cat_period.code AS cat_period_code,
    ext_rtc_hydrometer_x_data.value_date,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum
   FROM ((((ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     LEFT JOIN ext_cat_hydrometer ON (((ext_cat_hydrometer.id)::bigint = (ext_rtc_hydrometer.catalog_id)::bigint)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (ext_rtc_hydrometer_x_data.hydrometer_id)::bigint)))
     JOIN ext_cat_period ON (((ext_rtc_hydrometer_x_data.cat_period_id)::text = (ext_cat_period.id)::text)))
  ORDER BY ext_rtc_hydrometer_x_data.hydrometer_id, ext_rtc_hydrometer_x_data.cat_period_id DESC;


--
-- Name: v_state_samplepoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_samplepoint AS
 SELECT samplepoint.sample_id
   FROM selector_state,
    samplepoint
  WHERE ((samplepoint.state = selector_state.state_id) AND (selector_state.cur_user = CURRENT_USER));


--
-- Name: v_edit_samplepoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_samplepoint AS
 SELECT samplepoint.sample_id,
    samplepoint.code,
    samplepoint.lab_code,
    samplepoint.feature_id,
    samplepoint.featurecat_id,
    samplepoint.dma_id,
    dma.macrodma_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.muni_id,
    samplepoint.postcode,
    samplepoint.district_id,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcomplement,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement2,
    samplepoint.place_name,
    samplepoint.cabinet,
    samplepoint.observations,
    samplepoint.verified,
    samplepoint.the_geom,
    samplepoint.expl_id,
    samplepoint.link
   FROM selector_expl,
    ((samplepoint
     JOIN v_state_samplepoint ON (((samplepoint.sample_id)::text = (v_state_samplepoint.sample_id)::text)))
     LEFT JOIN dma ON ((dma.dma_id = samplepoint.dma_id)))
  WHERE ((samplepoint.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_sector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_sector AS
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.active,
    sector.parent_id
   FROM selector_sector,
    sector
  WHERE ((sector.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: v_expl_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_expl_connec AS
 SELECT connec.connec_id
   FROM selector_expl,
    connec
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (connec.expl_id = selector_expl.expl_id));


--
-- Name: v_expl_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_expl_gully AS
 SELECT gully.gully_id
   FROM selector_expl,
    gully
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (gully.expl_id = selector_expl.expl_id));


--
-- Name: v_ext_address; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ext_address AS
 SELECT ext_address.id,
    ext_address.muni_id,
    ext_address.postcode,
    ext_address.streetaxis_id,
    ext_address.postnumber,
    ext_address.plot_id,
    ext_address.expl_id,
    ext_streetaxis.name,
    ext_address.the_geom
   FROM selector_expl,
    (ext_address
     LEFT JOIN ext_streetaxis ON (((ext_streetaxis.id)::text = (ext_address.streetaxis_id)::text)))
  WHERE ((ext_address.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_ext_plot; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ext_plot AS
 SELECT ext_plot.id,
    ext_plot.plot_code,
    ext_plot.muni_id,
    ext_plot.postcode,
    ext_plot.streetaxis_id,
    ext_plot.postnumber,
    ext_plot.complement,
    ext_plot.placement,
    ext_plot.square,
    ext_plot.observ,
    ext_plot.text,
    ext_plot.the_geom,
    ext_plot.expl_id
   FROM selector_expl,
    ext_plot
  WHERE ((ext_plot.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_ext_raster_dem; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ext_raster_dem AS
 SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
   FROM v_edit_exploitation a,
    (ext_raster_dem r
     JOIN ext_cat_raster c ON ((c.id = r.rastercat_id)))
  WHERE public.st_dwithin(r.envelope, a.the_geom, (0)::double precision);


--
-- Name: v_man_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_man_gully AS
 SELECT gully.gully_id,
    gully.the_geom
   FROM (gully
     JOIN selector_state ON ((gully.state = selector_state.state_id)));


--
-- Name: v_om_visit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_visit AS
 SELECT DISTINCT ON (a.visit_id) a.visit_id,
    a.code,
    a.visitcat_id,
    a.name,
    a.visit_start,
    a.visit_end,
    a.user_name,
    a.is_done,
    a.feature_id,
    a.feature_type,
    a.the_geom
   FROM ( SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_node.node_id AS feature_id,
            'NODE'::text AS feature_type,
                CASE
                    WHEN (om_visit.the_geom IS NULL) THEN node.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state,
            (((om_visit
             JOIN om_visit_x_node ON ((om_visit_x_node.visit_id = om_visit.id)))
             JOIN node ON (((node.node_id)::text = (om_visit_x_node.node_id)::text)))
             JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
          WHERE ((selector_state.state_id = node.state) AND (selector_state.cur_user = ("current_user"())::text))
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_arc.arc_id AS feature_id,
            'ARC'::text AS feature_type,
                CASE
                    WHEN (om_visit.the_geom IS NULL) THEN public.st_lineinterpolatepoint(arc.the_geom, (0.5)::double precision)
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state,
            (((om_visit
             JOIN om_visit_x_arc ON ((om_visit_x_arc.visit_id = om_visit.id)))
             JOIN arc ON (((arc.arc_id)::text = (om_visit_x_arc.arc_id)::text)))
             JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
          WHERE ((selector_state.state_id = arc.state) AND (selector_state.cur_user = ("current_user"())::text))
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_connec.connec_id AS feature_id,
            'CONNEC'::text AS feature_type,
                CASE
                    WHEN (om_visit.the_geom IS NULL) THEN connec.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state,
            (((om_visit
             JOIN om_visit_x_connec ON ((om_visit_x_connec.visit_id = om_visit.id)))
             JOIN connec ON (((connec.connec_id)::text = (om_visit_x_connec.connec_id)::text)))
             JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
          WHERE ((selector_state.state_id = connec.state) AND (selector_state.cur_user = ("current_user"())::text))
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_gully.gully_id AS feature_id,
            'GULLY'::text AS feature_type,
                CASE
                    WHEN (om_visit.the_geom IS NULL) THEN gully.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state,
            (((om_visit
             JOIN om_visit_x_gully ON ((om_visit_x_gully.visit_id = om_visit.id)))
             JOIN gully ON (((gully.gully_id)::text = (om_visit_x_gully.gully_id)::text)))
             JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
          WHERE ((selector_state.state_id = gully.state) AND (selector_state.cur_user = ("current_user"())::text))) a;


--
-- Name: v_price_x_catpavement; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catpavement AS
 SELECT cat_pavement.id AS pavcat_id,
    cat_pavement.thickness,
    v_price_compost.price AS m2pav_cost
   FROM (cat_pavement
     JOIN v_price_compost ON (((cat_pavement.m2_cost)::text = (v_price_compost.id)::text)));


--
-- Name: v_plan_aux_arc_pavement; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_aux_arc_pavement AS
 SELECT plan_arc_x_pavement.arc_id,
    (sum((v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)))::numeric(12,2) AS thickness,
    (sum((v_price_x_catpavement.m2pav_cost * plan_arc_x_pavement.percent)))::numeric(12,2) AS m2pav_cost,
    'Various pavements'::character varying AS pavcat_id,
    1 AS percent,
    'VARIOUS'::character varying AS price_id
   FROM (plan_arc_x_pavement
     JOIN v_price_x_catpavement USING (pavcat_id))
  GROUP BY plan_arc_x_pavement.arc_id
UNION
 SELECT v_edit_arc.arc_id,
    c.thickness,
    v_price_x_catpavement.m2pav_cost,
    v_edit_arc.pavcat_id,
    1 AS percent,
    p.id AS price_id
   FROM ((((v_edit_arc
     JOIN cat_pavement c ON (((c.id)::text = (v_edit_arc.pavcat_id)::text)))
     JOIN v_price_x_catpavement USING (pavcat_id))
     LEFT JOIN v_price_compost p ON (((c.m2_cost)::text = (p.id)::text)))
     LEFT JOIN ( SELECT plan_arc_x_pavement.arc_id
           FROM plan_arc_x_pavement) a USING (arc_id))
  WHERE (a.arc_id IS NULL);


--
-- Name: v_price_x_catarc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catarc AS
 SELECT cat_arc.id,
    cat_arc.geom1,
    cat_arc.z1,
    cat_arc.z2,
    cat_arc.width,
    cat_arc.area,
    cat_arc.bulk,
    cat_arc.estimated_depth,
    cat_arc.cost_unit,
    price_cost.price AS cost,
    price_m2bottom.price AS m2bottom_cost,
    price_m3protec.price AS m3protec_cost
   FROM (((cat_arc
     JOIN v_price_compost price_cost ON (((cat_arc.cost)::text = (price_cost.id)::text)))
     JOIN v_price_compost price_m2bottom ON (((cat_arc.m2bottom_cost)::text = (price_m2bottom.id)::text)))
     JOIN v_price_compost price_m3protec ON (((cat_arc.m3protec_cost)::text = (price_m3protec.id)::text)));


--
-- Name: v_price_x_catsoil; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catsoil AS
 SELECT cat_soil.id,
    cat_soil.y_param,
    cat_soil.b,
    cat_soil.trenchlining,
    price_m3exc.price AS m3exc_cost,
    price_m3fill.price AS m3fill_cost,
    price_m3excess.price AS m3excess_cost,
        CASE
            WHEN (price_m2trenchl.price IS NULL) THEN (0)::numeric(14,2)
            ELSE price_m2trenchl.price
        END AS m2trenchl_cost
   FROM ((((cat_soil
     JOIN v_price_compost price_m3exc ON (((cat_soil.m3exc_cost)::text = (price_m3exc.id)::text)))
     JOIN v_price_compost price_m3fill ON (((cat_soil.m3fill_cost)::text = (price_m3fill.id)::text)))
     JOIN v_price_compost price_m3excess ON (((cat_soil.m3excess_cost)::text = (price_m3excess.id)::text)))
     LEFT JOIN v_price_compost price_m2trenchl ON (((cat_soil.m2trenchl_cost)::text = (price_m2trenchl.id)::text)));


--
-- Name: v_plan_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_arc AS
 SELECT d.arc_id,
    d.node_1,
    d.node_2,
    d.arc_type,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.expl_id,
    d.sector_id,
    d.annotation,
    d.soilcat_id,
    d.y1,
    d.y2,
    d.mean_y,
    d.z1,
    d.z2,
    d.thickness,
    d.width,
    d.b,
    d.bulk,
    d.geom1,
    d.area,
    d.y_param,
    d.total_y,
    d.rec_y,
    d.geom1_ext,
    d.calculed_y,
    d.m3mlexc,
    d.m2mltrenchl,
    d.m2mlbottom,
    d.m2mlpav,
    d.m3mlprotec,
    d.m3mlfill,
    d.m3mlexcess,
    d.m3exc_cost,
    d.m2trenchl_cost,
    d.m2bottom_cost,
    d.m2pav_cost,
    d.m3protec_cost,
    d.m3fill_cost,
    d.m3excess_cost,
    d.cost_unit,
    d.pav_cost,
    d.exc_cost,
    d.trenchl_cost,
    d.base_cost,
    d.protec_cost,
    d.fill_cost,
    d.excess_cost,
    d.arc_cost,
    d.cost,
    d.length,
    d.budget,
    d.other_budget,
        CASE
            WHEN (d.other_budget IS NOT NULL) THEN ((d.budget + d.other_budget))::numeric(14,2)
            ELSE d.budget
        END AS total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_arc.arc_id,
                            v_arc.y1,
                            v_arc.y2,
                                CASE
                                    WHEN (((v_arc.y1 * v_arc.y2) = (0)::numeric) OR ((v_arc.y1 * v_arc.y2) IS NULL)) THEN v_price_x_catarc.estimated_depth
                                    ELSE (((v_arc.y1 + v_arc.y2) / (2)::numeric))::numeric(12,2)
                                END AS mean_y,
                            v_arc.arccat_id,
                            (COALESCE(v_price_x_catarc.geom1, (0)::numeric))::numeric(12,4) AS geom1,
                            (COALESCE(v_price_x_catarc.z1, (0)::numeric))::numeric(12,2) AS z1,
                            (COALESCE(v_price_x_catarc.z2, (0)::numeric))::numeric(12,2) AS z2,
                            (COALESCE(v_price_x_catarc.area, (0)::numeric))::numeric(12,4) AS area,
                            (COALESCE(v_price_x_catarc.width, (0)::numeric))::numeric(12,2) AS width,
                            (COALESCE((v_price_x_catarc.bulk / (1000)::numeric), (0)::numeric))::numeric(12,2) AS bulk,
                            v_price_x_catarc.cost_unit,
                            (COALESCE(v_price_x_catarc.cost, (0)::numeric))::numeric(12,2) AS arc_cost,
                            (COALESCE(v_price_x_catarc.m2bottom_cost, (0)::numeric))::numeric(12,2) AS m2bottom_cost,
                            (COALESCE(v_price_x_catarc.m3protec_cost, (0)::numeric))::numeric(12,2) AS m3protec_cost,
                            v_price_x_catsoil.id AS soilcat_id,
                            (COALESCE(v_price_x_catsoil.y_param, (10)::numeric))::numeric(5,2) AS y_param,
                            (COALESCE(v_price_x_catsoil.b, (0)::numeric))::numeric(5,2) AS b,
                            COALESCE(v_price_x_catsoil.trenchlining, (0)::numeric) AS trenchlining,
                            (COALESCE(v_price_x_catsoil.m3exc_cost, (0)::numeric))::numeric(12,2) AS m3exc_cost,
                            (COALESCE(v_price_x_catsoil.m3fill_cost, (0)::numeric))::numeric(12,2) AS m3fill_cost,
                            (COALESCE(v_price_x_catsoil.m3excess_cost, (0)::numeric))::numeric(12,2) AS m3excess_cost,
                            (COALESCE(v_price_x_catsoil.m2trenchl_cost, (0)::numeric))::numeric(12,2) AS m2trenchl_cost,
                            (COALESCE(v_plan_aux_arc_pavement.thickness, (0)::numeric))::numeric(12,2) AS thickness,
                            COALESCE(v_plan_aux_arc_pavement.m2pav_cost, (0)::numeric) AS m2pav_cost,
                            v_arc.state,
                            v_arc.expl_id,
                            v_arc.the_geom
                           FROM (((v_arc
                             LEFT JOIN v_price_x_catarc ON (((v_arc.arccat_id)::text = (v_price_x_catarc.id)::text)))
                             LEFT JOIN v_price_x_catsoil ON (((v_arc.soilcat_id)::text = (v_price_x_catsoil.id)::text)))
                             LEFT JOIN v_plan_aux_arc_pavement ON (((v_plan_aux_arc_pavement.arc_id)::text = (v_arc.arc_id)::text)))
                          WHERE (v_plan_aux_arc_pavement.arc_id IS NOT NULL)
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.y1,
                    v_plan_aux_arc_ml.y2,
                    v_plan_aux_arc_ml.mean_y,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.geom1,
                    v_plan_aux_arc_ml.z1,
                    v_plan_aux_arc_ml.z2,
                    v_plan_aux_arc_ml.area,
                    v_plan_aux_arc_ml.width,
                    v_plan_aux_arc_ml.bulk,
                    v_plan_aux_arc_ml.cost_unit,
                    v_plan_aux_arc_ml.arc_cost,
                    v_plan_aux_arc_ml.m2bottom_cost,
                    v_plan_aux_arc_ml.m3protec_cost,
                    v_plan_aux_arc_ml.soilcat_id,
                    v_plan_aux_arc_ml.y_param,
                    v_plan_aux_arc_ml.b,
                    v_plan_aux_arc_ml.trenchlining,
                    v_plan_aux_arc_ml.m3exc_cost,
                    v_plan_aux_arc_ml.m3fill_cost,
                    v_plan_aux_arc_ml.m3excess_cost,
                    v_plan_aux_arc_ml.m2trenchl_cost,
                    v_plan_aux_arc_ml.thickness,
                    v_plan_aux_arc_ml.m2pav_cost,
                    v_plan_aux_arc_ml.state,
                    v_plan_aux_arc_ml.expl_id,
                    (((((2)::numeric * (((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)))::numeric(12,3) AS m2mlpavement,
                    ((((2)::numeric * v_plan_aux_arc_ml.b) + v_plan_aux_arc_ml.width))::numeric(12,3) AS m2mlbase,
                    ((((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS calculed_y,
                    (((v_plan_aux_arc_ml.trenchlining * (2)::numeric) * (((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness)))::numeric(12,3) AS m2mltrenchl,
                    ((((((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + (v_plan_aux_arc_ml.b * (2)::numeric)) + v_plan_aux_arc_ml.width)) / (2)::numeric))::numeric(12,3) AS m3mlexc,
                    ((((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric)) - v_plan_aux_arc_ml.area))::numeric(12,3) AS m3mlprotec,
                    (((((((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + (v_plan_aux_arc_ml.b * (2)::numeric)) + v_plan_aux_arc_ml.width)) / (2)::numeric) - ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric))))::numeric(12,3) AS m3mlfill,
                    (((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric)))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE (v_plan_aux_arc_ml.arc_id IS NOT NULL)
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            arc.arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            v_plan_aux_arc_cost.expl_id,
            arc.sector_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.y1,
            v_plan_aux_arc_cost.y2,
            v_plan_aux_arc_cost.mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            ((v_plan_aux_arc_cost.calculed_y + v_plan_aux_arc_cost.thickness))::numeric(12,2) AS total_y,
            (((((v_plan_aux_arc_cost.calculed_y - ((2)::numeric * v_plan_aux_arc_cost.bulk)) - v_plan_aux_arc_cost.z1) - v_plan_aux_arc_cost.z2) - v_plan_aux_arc_cost.geom1))::numeric(12,2) AS rec_y,
            ((v_plan_aux_arc_cost.geom1 + ((2)::numeric * v_plan_aux_arc_cost.bulk)))::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_y,
            v_plan_aux_arc_cost.m3mlexc,
            v_plan_aux_arc_cost.m2mltrenchl,
            v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
            v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
            v_plan_aux_arc_cost.m3mlprotec,
            v_plan_aux_arc_cost.m3mlfill,
            v_plan_aux_arc_cost.m3mlexcess,
            v_plan_aux_arc_cost.m3exc_cost,
            v_plan_aux_arc_cost.m2trenchl_cost,
            v_plan_aux_arc_cost.m2bottom_cost,
            (v_plan_aux_arc_cost.m2pav_cost)::numeric(12,2) AS m2pav_cost,
            v_plan_aux_arc_cost.m3protec_cost,
            v_plan_aux_arc_cost.m3fill_cost,
            v_plan_aux_arc_cost.m3excess_cost,
            v_plan_aux_arc_cost.cost_unit,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost)
                END)::numeric(12,3) AS pav_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost)
                END)::numeric(12,3) AS exc_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost)
                END)::numeric(12,3) AS trenchl_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost)
                END)::numeric(12,3) AS base_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost)
                END)::numeric(12,3) AS protec_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost)
                END)::numeric(12,3) AS fill_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost)
                END)::numeric(12,3) AS excess_cost,
            (v_plan_aux_arc_cost.arc_cost)::numeric(12,3) AS arc_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN v_plan_aux_arc_cost.arc_cost
                    ELSE ((((((((v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost) + (v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost)) + (v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost)) + (v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost)) + (v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost)) + (v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost)) + (v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost)) + v_plan_aux_arc_cost.arc_cost)
                END)::numeric(12,2) AS cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::double precision
                    ELSE public.st_length2d(v_plan_aux_arc_cost.the_geom)
                END)::numeric(12,2) AS length,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN v_plan_aux_arc_cost.arc_cost
                    ELSE ((public.st_length2d(v_plan_aux_arc_cost.the_geom))::numeric(12,2) * (((((((((v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost) + (v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost)) + (v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost)) + (v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost)) + (v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost)) + (v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost)) + (v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost)) + v_plan_aux_arc_cost.arc_cost))::numeric(14,2))
                END)::numeric(14,2) AS budget,
            (COALESCE(v_plan_aux_arc_connec.connec_total_cost, (0)::numeric) + COALESCE(v_plan_aux_arc_gully.gully_total_cost, (0)::numeric)) AS other_budget,
            v_plan_aux_arc_cost.the_geom
           FROM (((v_plan_aux_arc_cost
             JOIN arc ON (((v_plan_aux_arc_cost.arc_id)::text = (arc.arc_id)::text)))
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    ((min(p.price) * (count(*))::numeric))::numeric(12,2) AS connec_total_cost
                   FROM (((v_edit_connec c
                     JOIN arc arc_1 USING (arc_id))
                     JOIN cat_arc ON (((cat_arc.id)::text = (arc_1.arccat_id)::text)))
                     LEFT JOIN v_price_compost p ON ((cat_arc.connect_cost = (p.id)::text)))
                  WHERE (c.arc_id IS NOT NULL)
                  GROUP BY c.arc_id) v_plan_aux_arc_connec ON (((v_plan_aux_arc_connec.arc_id)::text = (v_plan_aux_arc_cost.arc_id)::text)))
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    ((min(p.price) * (count(*))::numeric))::numeric(12,2) AS gully_total_cost
                   FROM (((v_edit_gully c
                     JOIN arc arc_1 USING (arc_id))
                     JOIN cat_arc ON (((cat_arc.id)::text = (arc_1.arccat_id)::text)))
                     LEFT JOIN v_price_compost p ON ((cat_arc.connect_cost = (p.id)::text)))
                  WHERE (c.arc_id IS NOT NULL)
                  GROUP BY c.arc_id) v_plan_aux_arc_gully ON (((v_plan_aux_arc_gully.arc_id)::text = (v_plan_aux_arc_cost.arc_id)::text)))) d;


--
-- Name: v_price_x_catnode; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catnode AS
 SELECT cat_node.id,
    cat_node.estimated_y,
    cat_node.cost_unit,
    v_price_compost.price AS cost
   FROM (cat_node
     JOIN v_price_compost ON (((cat_node.cost)::text = (v_price_compost.id)::text)));


--
-- Name: v_plan_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_node AS
 SELECT a.node_id,
    a.nodecat_id,
    a.node_type,
    a.top_elev,
    a.elev,
    a.epa_type,
    a.state,
    a.sector_id,
    a.expl_id,
    a.annotation,
    a.cost_unit,
    a.descript,
    a.cost,
    a.measurement,
    a.budget,
    a.the_geom
   FROM ( SELECT v_node.node_id,
            v_node.nodecat_id,
            v_node.sys_type AS node_type,
            v_node.top_elev,
            v_node.elev,
            v_node.epa_type,
            v_node.state,
            v_node.sector_id,
            v_node.expl_id,
            v_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
            (
                CASE
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'u'::text) THEN (1)::numeric
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm3'::text) THEN
                    CASE
                        WHEN ((v_node.sys_type)::text = 'STORAGE'::text) THEN man_storage.max_volume
                        WHEN ((v_node.sys_type)::text = 'CHAMBER'::text) THEN man_chamber.max_volume
                        ELSE NULL::numeric
                    END
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm'::text) THEN
                    CASE
                        WHEN (v_node.ymax = (0)::numeric) THEN v_price_x_catnode.estimated_y
                        WHEN (v_node.ymax IS NULL) THEN v_price_x_catnode.estimated_y
                        ELSE v_node.ymax
                    END
                    ELSE NULL::numeric
                END)::numeric(12,2) AS measurement,
            (
                CASE
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'u'::text) THEN v_price_x_catnode.cost
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm3'::text) THEN
                    CASE
                        WHEN ((v_node.sys_type)::text = 'STORAGE'::text) THEN (man_storage.max_volume * v_price_x_catnode.cost)
                        WHEN ((v_node.sys_type)::text = 'CHAMBER'::text) THEN (man_chamber.max_volume * v_price_x_catnode.cost)
                        ELSE NULL::numeric
                    END
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm'::text) THEN
                    CASE
                        WHEN (v_node.ymax = (0)::numeric) THEN (v_price_x_catnode.estimated_y * v_price_x_catnode.cost)
                        WHEN (v_node.ymax IS NULL) THEN (v_price_x_catnode.estimated_y * v_price_x_catnode.cost)
                        ELSE (v_node.ymax * v_price_x_catnode.cost)
                    END
                    ELSE NULL::numeric
                END)::numeric(12,2) AS budget,
            v_node.the_geom
           FROM (((((v_node
             LEFT JOIN v_price_x_catnode ON (((v_node.nodecat_id)::text = (v_price_x_catnode.id)::text)))
             LEFT JOIN man_chamber ON (((man_chamber.node_id)::text = (v_node.node_id)::text)))
             LEFT JOIN man_storage ON (((man_storage.node_id)::text = (v_node.node_id)::text)))
             LEFT JOIN cat_node ON (((cat_node.id)::text = (v_node.nodecat_id)::text)))
             LEFT JOIN v_price_compost ON (((v_price_compost.id)::text = (cat_node.cost)::text)))) a;


--
-- Name: v_plan_current_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_current_psector AS
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    (a.suma)::numeric(14,2) AS total_arc,
    (b.suma)::numeric(14,2) AS total_node,
    (c.suma)::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((((100)::numeric + plan_psector.gexpenses) / (100)::numeric))::numeric(14,2) * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2)) AS pec,
    plan_psector.vat,
    ((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)))::numeric(14,2) * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2)) AS pec_vat,
    plan_psector.other,
    (((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)) * (((100)::numeric + plan_psector.other) / (100)::numeric)))::numeric(14,2) * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2)) AS pca,
    plan_psector.the_geom
   FROM config_param_user,
    (((plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM ((v_plan_arc
                     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_arc.psector_id)))
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON ((a.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM ((v_plan_node
                     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_node.psector_id)))
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON ((b.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget
                   FROM ((plan_psector_x_other
                     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_other.psector_id)))
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON ((c.psector_id = plan_psector.psector_id)))
  WHERE (((config_param_user.cur_user)::text = ("current_user"())::text) AND ((config_param_user.parameter)::text = 'plan_psector_vdefault'::text) AND ((config_param_user.value)::integer = plan_psector.psector_id));


--
-- Name: v_plan_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector AS
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    (a.suma)::numeric(14,2) AS total_arc,
    (b.suma)::numeric(14,2) AS total_node,
    (c.suma)::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pec,
    plan_psector.vat,
    (((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)) * (((100)::numeric + plan_psector.other) / (100)::numeric)))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    (((plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM ((v_plan_arc
                     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_arc.psector_id)))
                  WHERE (plan_psector_x_arc.doable IS TRUE)
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON ((a.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM ((v_plan_node
                     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_node.psector_id)))
                  WHERE (plan_psector_x_node.doable IS TRUE)
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON ((b.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget
                   FROM ((plan_psector_x_other
                     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_other.psector_id)))
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON ((c.psector_id = plan_psector.psector_id)))
  WHERE ((plan_psector.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_all AS
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    (a.suma)::numeric(14,2) AS total_arc,
    (b.suma)::numeric(14,2) AS total_node,
    (c.suma)::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pec,
    plan_psector.vat,
    (((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)) * (((100)::numeric + plan_psector.other) / (100)::numeric)))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    (((plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.expl_id,
                    v_plan_arc.sector_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM ((v_plan_arc
                     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_arc.psector_id)))
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON ((a.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM ((v_plan_node
                     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_node.psector_id)))
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON ((b.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget
                   FROM ((plan_psector_x_other
                     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_other.psector_id)))
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON ((c.psector_id = plan_psector.psector_id)));


--
-- Name: v_plan_psector_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_arc AS
 SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    arc.arc_type,
    cat_feature.system_id,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    (plan_psector_x_arc.addparam)::text AS addparam,
    arc.the_geom
   FROM selector_psector,
    (((arc
     JOIN plan_psector_x_arc USING (arc_id))
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (arc.arc_type)::text)))
  WHERE ((plan_psector_x_arc.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_budget; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget AS
 SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    'arc'::text AS feature_type,
    v_plan_arc.arccat_id AS featurecat_id,
    v_plan_arc.arc_id AS feature_id,
    v_plan_arc.length,
    ((v_plan_arc.total_budget / v_plan_arc.length))::numeric(14,2) AS unitary_cost,
    v_plan_arc.total_budget
   FROM (v_plan_arc
     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
  WHERE (plan_psector_x_arc.doable = true)
UNION
 SELECT (row_number() OVER (ORDER BY v_plan_node.node_id) + 9999) AS rid,
    plan_psector_x_node.psector_id,
    'node'::text AS feature_type,
    v_plan_node.nodecat_id AS featurecat_id,
    v_plan_node.node_id AS feature_id,
    1 AS length,
    v_plan_node.budget AS unitary_cost,
    v_plan_node.budget AS total_budget
   FROM (v_plan_node
     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
  WHERE (plan_psector_x_node.doable = true)
UNION
 SELECT (row_number() OVER (ORDER BY v_edit_plan_psector_x_other.id) + 19999) AS rid,
    v_edit_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    v_edit_plan_psector_x_other.price_id AS featurecat_id,
    v_edit_plan_psector_x_other.observ AS feature_id,
    v_edit_plan_psector_x_other.measurement AS length,
    v_edit_plan_psector_x_other.price AS unitary_cost,
    v_edit_plan_psector_x_other.total_budget
   FROM v_edit_plan_psector_x_other
  ORDER BY 1, 2, 4;


--
-- Name: v_plan_psector_budget_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget_arc AS
 SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    (v_plan_arc.cost)::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_arc.doable,
    plan_psector.priority,
    v_plan_arc.the_geom
   FROM ((v_plan_arc
     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_arc.psector_id)))
  WHERE (plan_psector_x_arc.doable = true)
  ORDER BY plan_psector_x_arc.psector_id;


--
-- Name: v_plan_psector_budget_detail; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget_detail AS
 SELECT v_plan_arc.arc_id,
    plan_psector_x_arc.psector_id,
    v_plan_arc.arccat_id,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.arc_cost AS mlarc_cost,
    v_plan_arc.m3mlexc,
    v_plan_arc.exc_cost AS mlexc_cost,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.trenchl_cost AS mltrench_cost,
    v_plan_arc.m2mlbottom AS m2mlbase,
    v_plan_arc.base_cost AS mlbase_cost,
    v_plan_arc.m2mlpav,
    v_plan_arc.pav_cost AS mlpav_cost,
    v_plan_arc.m3mlprotec,
    v_plan_arc.protec_cost AS mlprotec_cost,
    v_plan_arc.m3mlfill,
    v_plan_arc.fill_cost AS mlfill_cost,
    v_plan_arc.m3mlexcess,
    v_plan_arc.excess_cost AS mlexcess_cost,
    v_plan_arc.cost AS mltotal_cost,
    v_plan_arc.length,
    v_plan_arc.budget AS other_budget,
    v_plan_arc.total_budget
   FROM (v_plan_arc
     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
  WHERE (plan_psector_x_arc.doable = true)
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


--
-- Name: v_plan_psector_budget_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget_node AS
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
    plan_psector_x_node.psector_id,
    plan_psector.psector_type,
    v_plan_node.node_id,
    v_plan_node.nodecat_id,
    (v_plan_node.cost)::numeric(12,2) AS cost,
    v_plan_node.measurement,
    v_plan_node.budget AS total_budget,
    v_plan_node.state,
    v_plan_node.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_node.doable,
    plan_psector.priority,
    v_plan_node.the_geom
   FROM ((v_plan_node
     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_node.psector_id)))
  WHERE (plan_psector_x_node.doable = true)
  ORDER BY plan_psector_x_node.psector_id;


--
-- Name: v_plan_psector_budget_other; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget_other AS
 SELECT plan_psector_x_other.id,
    plan_psector_x_other.psector_id,
    plan_psector.psector_type,
    v_price_compost.id AS price_id,
    v_price_compost.descript,
    v_price_compost.price,
    plan_psector_x_other.measurement,
    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget,
    plan_psector.priority
   FROM ((plan_psector_x_other
     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_other.psector_id)))
  ORDER BY plan_psector_x_other.psector_id;


--
-- Name: v_plan_psector_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_connec AS
 SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.connecat_id,
    connec.connec_type,
    cat_feature.system_id,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    connec.the_geom
   FROM selector_psector,
    (((connec
     JOIN plan_psector_x_connec USING (connec_id))
     JOIN cat_connec ON (((cat_connec.id)::text = (connec.connecat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (connec.connec_type)::text)))
  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_gully AS
 SELECT row_number() OVER () AS rid,
    gully.gully_id,
    plan_psector_x_gully.psector_id,
    gully.code,
    gully.gratecat_id,
    gully.gully_type,
    cat_feature.system_id,
    gully.state AS original_state,
    gully.state_type AS original_state_type,
    plan_psector_x_gully.state AS plan_state,
    plan_psector_x_gully.doable,
    gully.the_geom
   FROM selector_psector,
    (((gully
     JOIN plan_psector_x_gully USING (gully_id))
     JOIN cat_grate ON (((cat_grate.id)::text = (gully.gratecat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (gully.gully_type)::text)))
  WHERE ((plan_psector_x_gully.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_link AS
 SELECT row_number() OVER () AS rid,
    a.link_id,
    a.psector_id,
    a.feature_id,
    a.original_state,
    a.original_state_type,
    a.plan_state,
    a.doable,
    a.the_geom
   FROM ( SELECT link.link_id,
            plan_psector_x_connec.psector_id,
            connec.connec_id AS feature_id,
            connec.state AS original_state,
            connec.state_type AS original_state_type,
            plan_psector_x_connec.state AS plan_state,
            plan_psector_x_connec.doable,
            link.the_geom
           FROM selector_psector,
            ((connec
             JOIN plan_psector_x_connec USING (connec_id))
             JOIN link ON (((link.feature_id)::text = (connec.connec_id)::text)))
          WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text))
        UNION
         SELECT link.link_id,
            plan_psector_x_gully.psector_id,
            gully.gully_id AS feature_id,
            gully.state AS original_state,
            gully.state_type AS original_state_type,
            plan_psector_x_gully.state AS plan_state,
            plan_psector_x_gully.doable,
            link.the_geom
           FROM selector_psector,
            ((gully
             JOIN plan_psector_x_gully USING (gully_id))
             JOIN link ON (((link.feature_id)::text = (gully.gully_id)::text)))
          WHERE ((plan_psector_x_gully.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text))) a;


--
-- Name: v_plan_psector_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_node AS
 SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    node.node_type,
    cat_feature.system_id,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    node.the_geom
   FROM selector_psector,
    (((node
     JOIN plan_psector_x_node USING (node_id))
     JOIN cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (node.node_type)::text)))
  WHERE ((plan_psector_x_node.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_result_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_result_arc AS
 SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.state,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.annotation,
    plan_rec_result_arc.soilcat_id,
    plan_rec_result_arc.y1,
    plan_rec_result_arc.y2,
    plan_rec_result_arc.mean_y,
    plan_rec_result_arc.z1,
    plan_rec_result_arc.z2,
    plan_rec_result_arc.thickness,
    plan_rec_result_arc.width,
    plan_rec_result_arc.b,
    plan_rec_result_arc.bulk,
    plan_rec_result_arc.geom1,
    plan_rec_result_arc.area,
    plan_rec_result_arc.y_param,
    plan_rec_result_arc.total_y,
    plan_rec_result_arc.rec_y,
    plan_rec_result_arc.geom1_ext,
    plan_rec_result_arc.calculed_y,
    plan_rec_result_arc.m3mlexc,
    plan_rec_result_arc.m2mltrenchl,
    plan_rec_result_arc.m2mlbottom,
    plan_rec_result_arc.m2mlpav,
    plan_rec_result_arc.m3mlprotec,
    plan_rec_result_arc.m3mlfill,
    plan_rec_result_arc.m3mlexcess,
    plan_rec_result_arc.m3exc_cost,
    plan_rec_result_arc.m2trenchl_cost,
    plan_rec_result_arc.m2bottom_cost,
    plan_rec_result_arc.m2pav_cost,
    plan_rec_result_arc.m3protec_cost,
    plan_rec_result_arc.m3fill_cost,
    plan_rec_result_arc.m3excess_cost,
    plan_rec_result_arc.cost_unit,
    plan_rec_result_arc.pav_cost,
    plan_rec_result_arc.exc_cost,
    plan_rec_result_arc.trenchl_cost,
    plan_rec_result_arc.base_cost,
    plan_rec_result_arc.protec_cost,
    plan_rec_result_arc.fill_cost,
    plan_rec_result_arc.excess_cost,
    plan_rec_result_arc.arc_cost,
    plan_rec_result_arc.cost,
    plan_rec_result_arc.length,
    plan_rec_result_arc.budget,
    plan_rec_result_arc.other_budget,
    plan_rec_result_arc.total_budget,
    plan_rec_result_arc.the_geom,
    plan_rec_result_arc.builtcost,
    plan_rec_result_arc.builtdate,
    plan_rec_result_arc.age,
    plan_rec_result_arc.acoeff,
    plan_rec_result_arc.aperiod,
    plan_rec_result_arc.arate,
    plan_rec_result_arc.amortized,
    plan_rec_result_arc.pending
   FROM selector_plan_result,
    plan_rec_result_arc
  WHERE (((plan_rec_result_arc.result_id)::text = (selector_plan_result.result_id)::text) AND (selector_plan_result.cur_user = ("current_user"())::text) AND (plan_rec_result_arc.state = 1))
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.state,
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.annotation,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.mean_y,
    v_plan_arc.z1,
    v_plan_arc.z2,
    v_plan_arc.thickness,
    v_plan_arc.width,
    v_plan_arc.b,
    v_plan_arc.bulk,
    v_plan_arc.geom1,
    v_plan_arc.area,
    v_plan_arc.y_param,
    v_plan_arc.total_y,
    v_plan_arc.rec_y,
    v_plan_arc.geom1_ext,
    v_plan_arc.calculed_y,
    v_plan_arc.m3mlexc,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.m2mlbottom,
    v_plan_arc.m2mlpav,
    v_plan_arc.m3mlprotec,
    v_plan_arc.m3mlfill,
    v_plan_arc.m3mlexcess,
    v_plan_arc.m3exc_cost,
    v_plan_arc.m2trenchl_cost,
    v_plan_arc.m2bottom_cost,
    v_plan_arc.m2pav_cost,
    v_plan_arc.m3protec_cost,
    v_plan_arc.m3fill_cost,
    v_plan_arc.m3excess_cost,
    v_plan_arc.cost_unit,
    v_plan_arc.pav_cost,
    v_plan_arc.exc_cost,
    v_plan_arc.trenchl_cost,
    v_plan_arc.base_cost,
    v_plan_arc.protec_cost,
    v_plan_arc.fill_cost,
    v_plan_arc.excess_cost,
    v_plan_arc.arc_cost,
    v_plan_arc.cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_arc
  WHERE (v_plan_arc.state = 2);


--
-- Name: v_plan_result_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_result_node AS
 SELECT plan_rec_result_node.node_id,
    plan_rec_result_node.nodecat_id,
    plan_rec_result_node.node_type,
    plan_rec_result_node.top_elev,
    plan_rec_result_node.elev,
    plan_rec_result_node.epa_type,
    plan_rec_result_node.state,
    plan_rec_result_node.sector_id,
    plan_rec_result_node.expl_id,
    plan_rec_result_node.cost_unit,
    plan_rec_result_node.descript,
    plan_rec_result_node.measurement,
    plan_rec_result_node.cost,
    plan_rec_result_node.budget,
    plan_rec_result_node.the_geom,
    plan_rec_result_node.builtcost,
    plan_rec_result_node.builtdate,
    plan_rec_result_node.age,
    plan_rec_result_node.acoeff,
    plan_rec_result_node.aperiod,
    plan_rec_result_node.arate,
    plan_rec_result_node.amortized,
    plan_rec_result_node.pending
   FROM selector_expl,
    selector_plan_result,
    plan_rec_result_node
  WHERE ((plan_rec_result_node.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text) AND ((plan_rec_result_node.result_id)::text = (selector_plan_result.result_id)::text) AND (selector_plan_result.cur_user = ("current_user"())::text) AND (plan_rec_result_node.state = 1))
UNION
 SELECT v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.node_type,
    v_plan_node.top_elev,
    v_plan_node.elev,
    v_plan_node.epa_type,
    v_plan_node.state,
    v_plan_node.sector_id,
    v_plan_node.expl_id,
    v_plan_node.cost_unit,
    v_plan_node.descript,
    v_plan_node.measurement,
    v_plan_node.cost,
    v_plan_node.budget,
    v_plan_node.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_node
  WHERE (v_plan_node.state = 2);


--
-- Name: v_polygon; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_polygon AS
 SELECT p.pol_id,
    p.state,
    p.feature_id,
    p.sys_type,
    p.featurecat_id,
    p.the_geom
   FROM selector_state s,
    polygon p
  WHERE ((s.state_id = p.state) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_price_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_arc AS
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'element'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm2bottom'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.m2bottom_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3protec'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.m3protec_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3exc'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3exc_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3fill'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3fill_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3excess'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3excess_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm2trenchl'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m2trenchl_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_pavement.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'pavement'::text AS identif
   FROM (((arc
     JOIN plan_arc_x_pavement ON (((plan_arc_x_pavement.arc_id)::text = (arc.arc_id)::text)))
     JOIN cat_pavement ON (((cat_pavement.id)::text = (plan_arc_x_pavement.pavcat_id)::text)))
     JOIN v_price_compost ON (((cat_pavement.m2_cost)::text = (v_price_compost.id)::text)))
  ORDER BY 1, 2;


--
-- Name: v_rpt_arc_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc_all AS
 SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM selector_rpt_main,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY arc.arc_id;


--
-- Name: v_rpt_arc_compare_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc_compare_all AS
 SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_compare.result_id,
    arc.arc_type,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_compare.result_id)::text))
  ORDER BY arc.arc_id;


--
-- Name: v_rpt_arc_compare_timestep; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc_compare_timestep AS
 SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_compare.result_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM selector_rpt_compare,
    selector_rpt_compare_tstep,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_compare.result_id)::text) AND ((rpt_arc.resulttime)::text = (selector_rpt_compare_tstep.resulttime)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND (selector_rpt_compare_tstep.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_compare.result_id)::text))
  ORDER BY rpt_arc.resulttime, arc.arc_id;


--
-- Name: v_rpt_arc_timestep; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc_timestep AS
 SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_main.result_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_main.result_id)::text) AND ((rpt_arc.resulttime)::text = (selector_rpt_main_tstep.resulttime)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_arc.resulttime, arc.arc_id;


--
-- Name: v_rpt_arcflow_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arcflow_sum AS
 SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcflow_sum.arc_type AS swarc_type,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_dept,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM selector_rpt_main,
    (rpt_inp_arc
     JOIN rpt_arcflow_sum ON (((rpt_arcflow_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_arcflow_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_arcpolload_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arcpolload_sum AS
 SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcpolload_sum.poll_id
   FROM selector_rpt_main,
    (rpt_inp_arc
     JOIN rpt_arcpolload_sum ON (((rpt_arcpolload_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_arcpolload_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_comp_arcflow_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_arcflow_sum AS
 SELECT rpt_arcflow_sum.id,
    selector_rpt_compare.result_id,
    rpt_arcflow_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_dept,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_arc
     JOIN rpt_arcflow_sum ON (((rpt_arcflow_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_arcflow_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_condsurcharge_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_condsurcharge_sum AS
 SELECT rpt_condsurcharge_sum.id,
    rpt_condsurcharge_sum.result_id,
    rpt_condsurcharge_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_condsurcharge_sum.both_ends,
    rpt_condsurcharge_sum.upstream,
    rpt_condsurcharge_sum.dnstream,
    rpt_condsurcharge_sum.hour_nflow,
    rpt_condsurcharge_sum.hour_limit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_arc
     JOIN rpt_condsurcharge_sum ON (((rpt_condsurcharge_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_condsurcharge_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_continuity_errors; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_continuity_errors AS
 SELECT rpt_continuity_errors.id,
    rpt_continuity_errors.result_id,
    rpt_continuity_errors.text
   FROM selector_rpt_compare,
    rpt_continuity_errors
  WHERE (((rpt_continuity_errors.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_critical_elements; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_critical_elements AS
 SELECT rpt_critical_elements.id,
    rpt_critical_elements.result_id,
    rpt_critical_elements.text
   FROM selector_rpt_compare,
    rpt_critical_elements
  WHERE (((rpt_critical_elements.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_flowclass_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_flowclass_sum AS
 SELECT rpt_flowclass_sum.id,
    rpt_flowclass_sum.result_id,
    rpt_flowclass_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_flowclass_sum.length,
    rpt_flowclass_sum.dry,
    rpt_flowclass_sum.up_dry,
    rpt_flowclass_sum.down_dry,
    rpt_flowclass_sum.sub_crit,
    rpt_flowclass_sum.sub_crit_1,
    rpt_flowclass_sum.up_crit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_arc
     JOIN rpt_flowclass_sum ON (((rpt_flowclass_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_flowclass_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_flowrouting_cont; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_flowrouting_cont AS
 SELECT rpt_flowrouting_cont.id,
    rpt_flowrouting_cont.result_id,
    rpt_flowrouting_cont.dryw_inf,
    rpt_flowrouting_cont.wetw_inf,
    rpt_flowrouting_cont.ground_inf,
    rpt_flowrouting_cont.rdii_inf,
    rpt_flowrouting_cont.ext_inf,
    rpt_flowrouting_cont.ext_out,
    rpt_flowrouting_cont.int_out,
    rpt_flowrouting_cont.evap_losses,
    rpt_flowrouting_cont.seepage_losses,
    rpt_flowrouting_cont.stor_loss,
    rpt_flowrouting_cont.initst_vol,
    rpt_flowrouting_cont.finst_vol,
    rpt_flowrouting_cont.cont_error
   FROM selector_rpt_compare,
    rpt_flowrouting_cont
  WHERE (((rpt_flowrouting_cont.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_groundwater_cont; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_groundwater_cont AS
 SELECT rpt_groundwater_cont.id,
    rpt_groundwater_cont.result_id,
    rpt_groundwater_cont.init_stor,
    rpt_groundwater_cont.infilt,
    rpt_groundwater_cont.upzone_et,
    rpt_groundwater_cont.lowzone_et,
    rpt_groundwater_cont.deep_perc,
    rpt_groundwater_cont.groundw_fl,
    rpt_groundwater_cont.final_stor,
    rpt_groundwater_cont.cont_error
   FROM selector_rpt_compare,
    rpt_groundwater_cont
  WHERE (((rpt_groundwater_cont.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_high_cont_errors; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_high_cont_errors AS
 SELECT rpt_continuity_errors.id,
    rpt_continuity_errors.result_id,
    rpt_continuity_errors.text
   FROM selector_rpt_compare,
    rpt_continuity_errors
  WHERE (((rpt_continuity_errors.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_high_flowinest_ind; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_high_flowinest_ind AS
 SELECT rpt_high_flowinest_ind.id,
    rpt_high_flowinest_ind.result_id,
    rpt_high_flowinest_ind.text
   FROM selector_rpt_compare,
    rpt_high_flowinest_ind
  WHERE (((rpt_high_flowinest_ind.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_instability_index; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_instability_index AS
 SELECT rpt_instability_index.id,
    rpt_instability_index.result_id,
    rpt_instability_index.text
   FROM selector_rpt_compare,
    rpt_instability_index
  WHERE (((rpt_instability_index.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_lidperformance_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_lidperformance_sum AS
 SELECT rpt_lidperformance_sum.id,
    rpt_lidperformance_sum.result_id,
    rpt_lidperformance_sum.subc_id,
    rpt_lidperformance_sum.lidco_id,
    rpt_lidperformance_sum.tot_inflow,
    rpt_lidperformance_sum.evap_loss,
    rpt_lidperformance_sum.infil_loss,
    rpt_lidperformance_sum.surf_outf,
    rpt_lidperformance_sum.drain_outf,
    rpt_lidperformance_sum.init_stor,
    rpt_lidperformance_sum.final_stor,
    rpt_lidperformance_sum.per_error,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_compare,
    (inp_subcatchment
     JOIN rpt_lidperformance_sum ON (((rpt_lidperformance_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_lidperformance_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_nodedepth_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_nodedepth_sum AS
 SELECT rpt_nodedepth_sum.id,
    rpt_nodedepth_sum.result_id,
    rpt_nodedepth_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodedepth_sum.swnod_type,
    rpt_nodedepth_sum.aver_depth,
    rpt_nodedepth_sum.max_depth,
    rpt_nodedepth_sum.max_hgl,
    rpt_nodedepth_sum.time_days,
    rpt_nodedepth_sum.time_hour,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node
     JOIN rpt_nodedepth_sum ON (((rpt_nodedepth_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_nodedepth_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_nodeflooding_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_nodeflooding_sum AS
 SELECT rpt_nodeflooding_sum.id,
    selector_rpt_compare.result_id,
    rpt_nodeflooding_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodeflooding_sum.hour_flood,
    rpt_nodeflooding_sum.max_rate,
    rpt_nodeflooding_sum.time_days,
    rpt_nodeflooding_sum.time_hour,
    rpt_nodeflooding_sum.tot_flood,
    rpt_nodeflooding_sum.max_ponded,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node
     JOIN rpt_nodeflooding_sum ON (((rpt_nodeflooding_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_nodeflooding_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_nodeinflow_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_nodeinflow_sum AS
 SELECT rpt_nodeinflow_sum.id,
    rpt_nodeinflow_sum.result_id,
    rpt_nodeinflow_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodeinflow_sum.swnod_type,
    rpt_nodeinflow_sum.max_latinf,
    rpt_nodeinflow_sum.max_totinf,
    rpt_nodeinflow_sum.time_days,
    rpt_nodeinflow_sum.time_hour,
    rpt_nodeinflow_sum.latinf_vol,
    rpt_nodeinflow_sum.totinf_vol,
    rpt_nodeinflow_sum.flow_balance_error,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node
     JOIN rpt_nodeinflow_sum ON (((rpt_nodeinflow_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_nodeinflow_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_nodesurcharge_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_nodesurcharge_sum AS
 SELECT rpt_nodesurcharge_sum.id,
    rpt_nodesurcharge_sum.result_id,
    rpt_inp_node.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodesurcharge_sum.swnod_type,
    rpt_nodesurcharge_sum.hour_surch,
    rpt_nodesurcharge_sum.max_height,
    rpt_nodesurcharge_sum.min_depth,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node
     JOIN rpt_nodesurcharge_sum ON (((rpt_nodesurcharge_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_nodesurcharge_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_outfallflow_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_outfallflow_sum AS
 SELECT rpt_outfallflow_sum.id,
    rpt_outfallflow_sum.result_id,
    rpt_outfallflow_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallflow_sum.flow_freq,
    rpt_outfallflow_sum.avg_flow,
    rpt_outfallflow_sum.max_flow,
    rpt_outfallflow_sum.total_vol,
    rpt_inp_node.the_geom,
    rpt_inp_node.sector_id
   FROM selector_rpt_compare,
    (rpt_inp_node
     JOIN rpt_outfallflow_sum ON (((rpt_outfallflow_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_outfallflow_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_outfallload_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_outfallload_sum AS
 SELECT rpt_outfallload_sum.id,
    rpt_outfallload_sum.result_id,
    rpt_outfallload_sum.poll_id,
    rpt_outfallload_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallload_sum.value,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node
     JOIN rpt_outfallload_sum ON (((rpt_outfallload_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_outfallload_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_pumping_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_pumping_sum AS
 SELECT rpt_pumping_sum.id,
    rpt_pumping_sum.result_id,
    rpt_pumping_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_pumping_sum.percent,
    rpt_pumping_sum.num_startup,
    rpt_pumping_sum.min_flow,
    rpt_pumping_sum.avg_flow,
    rpt_pumping_sum.max_flow,
    rpt_pumping_sum.vol_ltr,
    rpt_pumping_sum.powus_kwh,
    rpt_pumping_sum.timoff_min,
    rpt_pumping_sum.timoff_max,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_arc
     JOIN rpt_pumping_sum ON (((rpt_pumping_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_pumping_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_qualrouting; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_qualrouting AS
 SELECT rpt_qualrouting_cont.id,
    rpt_qualrouting_cont.result_id,
    rpt_qualrouting_cont.poll_id,
    rpt_qualrouting_cont.dryw_inf,
    rpt_qualrouting_cont.wetw_inf,
    rpt_qualrouting_cont.ground_inf,
    rpt_qualrouting_cont.rdii_inf,
    rpt_qualrouting_cont.ext_inf,
    rpt_qualrouting_cont.int_inf,
    rpt_qualrouting_cont.ext_out,
    rpt_qualrouting_cont.mass_reac,
    rpt_qualrouting_cont.initst_mas,
    rpt_qualrouting_cont.finst_mas,
    rpt_qualrouting_cont.cont_error
   FROM selector_rpt_compare,
    rpt_qualrouting_cont
  WHERE (((rpt_qualrouting_cont.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_rainfall_dep; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_rainfall_dep AS
 SELECT rpt_rainfall_dep.id,
    rpt_rainfall_dep.result_id,
    rpt_rainfall_dep.sewer_rain,
    rpt_rainfall_dep.rdiip_prod,
    rpt_rainfall_dep.rdiir_rat
   FROM selector_rpt_compare,
    rpt_rainfall_dep
  WHERE (((rpt_rainfall_dep.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_routing_timestep; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_routing_timestep AS
 SELECT rpt_routing_timestep.id,
    rpt_routing_timestep.result_id,
    rpt_routing_timestep.text
   FROM selector_rpt_compare,
    rpt_routing_timestep
  WHERE (((rpt_routing_timestep.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_runoff_qual; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_runoff_qual AS
 SELECT rpt_runoff_qual.id,
    rpt_runoff_qual.result_id,
    rpt_runoff_qual.poll_id,
    rpt_runoff_qual.init_buil,
    rpt_runoff_qual.surf_buil,
    rpt_runoff_qual.wet_dep,
    rpt_runoff_qual.sweep_re,
    rpt_runoff_qual.infil_loss,
    rpt_runoff_qual.bmp_re,
    rpt_runoff_qual.surf_runof,
    rpt_runoff_qual.rem_buil,
    rpt_runoff_qual.cont_error
   FROM selector_rpt_compare,
    rpt_runoff_qual
  WHERE (((rpt_runoff_qual.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_runoff_quant; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_runoff_quant AS
 SELECT rpt_runoff_quant.id,
    rpt_runoff_quant.result_id,
    rpt_runoff_quant.initsw_co,
    rpt_runoff_quant.total_prec,
    rpt_runoff_quant.evap_loss,
    rpt_runoff_quant.infil_loss,
    rpt_runoff_quant.surf_runof,
    rpt_runoff_quant.snow_re,
    rpt_runoff_quant.finalsw_co,
    rpt_runoff_quant.finals_sto,
    rpt_runoff_quant.cont_error
   FROM selector_rpt_compare,
    rpt_runoff_quant
  WHERE (((rpt_runoff_quant.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_storagevol_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_storagevol_sum AS
 SELECT rpt_storagevol_sum.id,
    rpt_storagevol_sum.result_id,
    rpt_storagevol_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_storagevol_sum.aver_vol,
    rpt_storagevol_sum.avg_full,
    rpt_storagevol_sum.ei_loss,
    rpt_storagevol_sum.max_vol,
    rpt_storagevol_sum.max_full,
    rpt_storagevol_sum.time_days,
    rpt_storagevol_sum.time_hour,
    rpt_storagevol_sum.max_out,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node
     JOIN rpt_storagevol_sum ON (((rpt_storagevol_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_storagevol_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text));


--
-- Name: v_rpt_comp_subcatchrunoff_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_subcatchrunoff_sum AS
 SELECT rpt_subcatchrunoff_sum.id,
    rpt_subcatchrunoff_sum.result_id,
    rpt_subcatchrunoff_sum.subc_id,
    rpt_subcatchrunoff_sum.tot_precip,
    rpt_subcatchrunoff_sum.tot_runon,
    rpt_subcatchrunoff_sum.tot_evap,
    rpt_subcatchrunoff_sum.tot_infil,
    rpt_subcatchrunoff_sum.tot_runoff,
    rpt_subcatchrunoff_sum.tot_runofl,
    rpt_subcatchrunoff_sum.peak_runof,
    rpt_subcatchrunoff_sum.runoff_coe,
    rpt_subcatchrunoff_sum.vxmax,
    rpt_subcatchrunoff_sum.vymax,
    rpt_subcatchrunoff_sum.depth,
    rpt_subcatchrunoff_sum.vel,
    rpt_subcatchrunoff_sum.vhmax,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_compare,
    (inp_subcatchment
     JOIN rpt_subcatchrunoff_sum ON (((rpt_subcatchrunoff_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_subcatchrunoff_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_subcatchwashoff_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_subcatchwashoff_sum AS
 SELECT rpt_subcatchwashoff_sum.id,
    rpt_subcatchwashoff_sum.result_id,
    rpt_subcatchwashoff_sum.subc_id,
    rpt_subcatchwashoff_sum.poll_id,
    rpt_subcatchwashoff_sum.value,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_compare,
    (inp_subcatchment
     JOIN rpt_subcatchwashoff_sum ON (((rpt_subcatchwashoff_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_subcatchwashoff_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_timestep_critelem; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_timestep_critelem AS
 SELECT rpt_timestep_critelem.id,
    rpt_timestep_critelem.result_id,
    rpt_timestep_critelem.text
   FROM selector_rpt_compare,
    rpt_timestep_critelem
  WHERE (((rpt_timestep_critelem.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_condsurcharge_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_condsurcharge_sum AS
 SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_condsurcharge_sum.both_ends,
    rpt_condsurcharge_sum.upstream,
    rpt_condsurcharge_sum.dnstream,
    rpt_condsurcharge_sum.hour_nflow,
    rpt_condsurcharge_sum.hour_limit
   FROM selector_rpt_main,
    (rpt_inp_arc
     JOIN rpt_condsurcharge_sum ON (((rpt_condsurcharge_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_condsurcharge_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_continuity_errors; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_continuity_errors AS
 SELECT rpt_continuity_errors.id,
    rpt_continuity_errors.result_id,
    rpt_continuity_errors.text
   FROM selector_rpt_main,
    rpt_continuity_errors
  WHERE (((rpt_continuity_errors.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_critical_elements; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_critical_elements AS
 SELECT rpt_critical_elements.id,
    rpt_critical_elements.result_id,
    rpt_critical_elements.text
   FROM selector_rpt_main,
    rpt_critical_elements
  WHERE (((rpt_critical_elements.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_flowclass_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_flowclass_sum AS
 SELECT rpt_flowclass_sum.id,
    rpt_flowclass_sum.result_id,
    rpt_flowclass_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_flowclass_sum.length,
    rpt_flowclass_sum.dry,
    rpt_flowclass_sum.up_dry,
    rpt_flowclass_sum.down_dry,
    rpt_flowclass_sum.sub_crit,
    rpt_flowclass_sum.sub_crit_1,
    rpt_flowclass_sum.up_crit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM selector_rpt_main,
    (rpt_inp_arc
     JOIN rpt_flowclass_sum ON (((rpt_flowclass_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_flowclass_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_flowrouting_cont; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_flowrouting_cont AS
 SELECT rpt_flowrouting_cont.id,
    rpt_flowrouting_cont.result_id,
    rpt_flowrouting_cont.dryw_inf,
    rpt_flowrouting_cont.wetw_inf,
    rpt_flowrouting_cont.ground_inf,
    rpt_flowrouting_cont.rdii_inf,
    rpt_flowrouting_cont.ext_inf,
    rpt_flowrouting_cont.ext_out,
    rpt_flowrouting_cont.int_out,
    rpt_flowrouting_cont.evap_losses,
    rpt_flowrouting_cont.seepage_losses,
    rpt_flowrouting_cont.stor_loss,
    rpt_flowrouting_cont.initst_vol,
    rpt_flowrouting_cont.finst_vol,
    rpt_flowrouting_cont.cont_error
   FROM selector_rpt_main,
    rpt_flowrouting_cont
  WHERE (((rpt_flowrouting_cont.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_groundwater_cont; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_groundwater_cont AS
 SELECT rpt_groundwater_cont.id,
    rpt_groundwater_cont.result_id,
    rpt_groundwater_cont.init_stor,
    rpt_groundwater_cont.infilt,
    rpt_groundwater_cont.upzone_et,
    rpt_groundwater_cont.lowzone_et,
    rpt_groundwater_cont.deep_perc,
    rpt_groundwater_cont.groundw_fl,
    rpt_groundwater_cont.final_stor,
    rpt_groundwater_cont.cont_error
   FROM selector_rpt_main,
    rpt_groundwater_cont
  WHERE (((rpt_groundwater_cont.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_high_cont_errors; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_high_cont_errors AS
 SELECT rpt_continuity_errors.id,
    rpt_continuity_errors.result_id,
    rpt_continuity_errors.text
   FROM selector_rpt_main,
    rpt_continuity_errors
  WHERE (((rpt_continuity_errors.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_high_flowinest_ind; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_high_flowinest_ind AS
 SELECT rpt_high_flowinest_ind.id,
    rpt_high_flowinest_ind.result_id,
    rpt_high_flowinest_ind.text
   FROM selector_rpt_main,
    rpt_high_flowinest_ind
  WHERE (((rpt_high_flowinest_ind.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_instability_index; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_instability_index AS
 SELECT rpt_instability_index.id,
    rpt_instability_index.result_id,
    rpt_instability_index.text
   FROM selector_rpt_main,
    rpt_instability_index
  WHERE (((rpt_instability_index.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_lidperformance_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_lidperformance_sum AS
 SELECT rpt_lidperformance_sum.id,
    rpt_lidperformance_sum.result_id,
    rpt_lidperformance_sum.subc_id,
    rpt_lidperformance_sum.lidco_id,
    rpt_lidperformance_sum.tot_inflow,
    rpt_lidperformance_sum.evap_loss,
    rpt_lidperformance_sum.infil_loss,
    rpt_lidperformance_sum.surf_outf,
    rpt_lidperformance_sum.drain_outf,
    rpt_lidperformance_sum.init_stor,
    rpt_lidperformance_sum.final_stor,
    rpt_lidperformance_sum.per_error,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_main,
    (inp_subcatchment
     JOIN rpt_lidperformance_sum ON (((rpt_lidperformance_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_lidperformance_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_node_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node_all AS
SELECT
    NULL::bigint AS id,
    NULL::character varying(16) AS node_id,
    NULL::character varying(30) AS result_id,
    NULL::character varying(30) AS node_type,
    NULL::character varying(30) AS nodecat_id,
    NULL::character varying(16) AS resultdate,
    NULL::character varying(12) AS resulttime,
    NULL::double precision AS flooding,
    NULL::double precision AS depth,
    NULL::double precision AS head,
    NULL::public.geometry(Point,SRID_VALUE) AS the_geom;


--
-- Name: v_rpt_node_compare_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node_compare_all AS
SELECT
    NULL::bigint AS id,
    NULL::character varying(16) AS node_id,
    NULL::character varying(30) AS result_id,
    NULL::character varying(30) AS node_type,
    NULL::character varying(30) AS nodecat_id,
    NULL::character varying(16) AS resultdate,
    NULL::character varying(12) AS resulttime,
    NULL::double precision AS flooding,
    NULL::double precision AS depth,
    NULL::double precision AS head,
    NULL::public.geometry(Point,SRID_VALUE) AS the_geom;


--
-- Name: v_rpt_node_compare_timestep; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node_compare_timestep AS
 SELECT rpt_node.id,
    node.node_id,
    selector_rpt_compare.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM selector_rpt_compare,
    selector_rpt_compare_tstep,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_compare.result_id)::text) AND ((rpt_node.resulttime)::text = (selector_rpt_compare_tstep.resulttime)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND (selector_rpt_compare_tstep.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_compare.result_id)::text))
  ORDER BY rpt_node.resulttime, node.node_id;


--
-- Name: v_rpt_node_timestep; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node_timestep AS
 SELECT rpt_node.id,
    node.node_id,
    selector_rpt_main.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_main.result_id)::text) AND ((rpt_node.resulttime)::text = (selector_rpt_main_tstep.resulttime)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_node.resulttime, node.node_id;


--
-- Name: v_rpt_nodedepth_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_nodedepth_sum AS
 SELECT rpt_nodedepth_sum.id,
    rpt_nodedepth_sum.result_id,
    rpt_nodedepth_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodedepth_sum.swnod_type,
    rpt_nodedepth_sum.aver_depth,
    rpt_nodedepth_sum.max_depth,
    rpt_nodedepth_sum.max_hgl,
    rpt_nodedepth_sum.time_days,
    rpt_nodedepth_sum.time_hour,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node
     JOIN rpt_nodedepth_sum ON (((rpt_nodedepth_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_nodedepth_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_nodeflooding_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_nodeflooding_sum AS
 SELECT rpt_inp_node.id,
    rpt_nodeflooding_sum.node_id,
    selector_rpt_main.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodeflooding_sum.hour_flood,
    rpt_nodeflooding_sum.max_rate,
    rpt_nodeflooding_sum.time_days,
    rpt_nodeflooding_sum.time_hour,
    rpt_nodeflooding_sum.tot_flood,
    rpt_nodeflooding_sum.max_ponded,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node
     JOIN rpt_nodeflooding_sum ON (((rpt_nodeflooding_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_nodeflooding_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_nodeinflow_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_nodeinflow_sum AS
 SELECT rpt_inp_node.id,
    rpt_nodeinflow_sum.node_id,
    rpt_nodeinflow_sum.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodeinflow_sum.swnod_type,
    rpt_nodeinflow_sum.max_latinf,
    rpt_nodeinflow_sum.max_totinf,
    rpt_nodeinflow_sum.time_days,
    rpt_nodeinflow_sum.time_hour,
    rpt_nodeinflow_sum.latinf_vol,
    rpt_nodeinflow_sum.totinf_vol,
    rpt_nodeinflow_sum.flow_balance_error,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node
     JOIN rpt_nodeinflow_sum ON (((rpt_nodeinflow_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_nodeinflow_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_nodesurcharge_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_nodesurcharge_sum AS
 SELECT rpt_inp_node.id,
    rpt_inp_node.node_id,
    rpt_nodesurcharge_sum.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodesurcharge_sum.swnod_type,
    rpt_nodesurcharge_sum.hour_surch,
    rpt_nodesurcharge_sum.max_height,
    rpt_nodesurcharge_sum.min_depth,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node
     JOIN rpt_nodesurcharge_sum ON (((rpt_nodesurcharge_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_nodesurcharge_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_outfallflow_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_outfallflow_sum AS
 SELECT rpt_inp_node.id,
    rpt_outfallflow_sum.node_id,
    rpt_outfallflow_sum.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallflow_sum.flow_freq,
    rpt_outfallflow_sum.avg_flow,
    rpt_outfallflow_sum.max_flow,
    rpt_outfallflow_sum.total_vol,
    rpt_inp_node.the_geom,
    rpt_inp_node.sector_id
   FROM selector_rpt_main,
    (rpt_inp_node
     JOIN rpt_outfallflow_sum ON (((rpt_outfallflow_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_outfallflow_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_outfallload_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_outfallload_sum AS
 SELECT rpt_inp_node.id,
    rpt_outfallload_sum.node_id,
    rpt_outfallload_sum.result_id,
    rpt_outfallload_sum.poll_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallload_sum.value,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node
     JOIN rpt_outfallload_sum ON (((rpt_outfallload_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_outfallload_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_pumping_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_pumping_sum AS
 SELECT rpt_pumping_sum.id,
    rpt_pumping_sum.result_id,
    rpt_pumping_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_pumping_sum.percent,
    rpt_pumping_sum.num_startup,
    rpt_pumping_sum.min_flow,
    rpt_pumping_sum.avg_flow,
    rpt_pumping_sum.max_flow,
    rpt_pumping_sum.vol_ltr,
    rpt_pumping_sum.powus_kwh,
    rpt_pumping_sum.timoff_min,
    rpt_pumping_sum.timoff_max,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM selector_rpt_main,
    (rpt_inp_arc
     JOIN rpt_pumping_sum ON (((rpt_pumping_sum.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_pumping_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_qualrouting; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_qualrouting AS
 SELECT rpt_qualrouting_cont.id,
    rpt_qualrouting_cont.result_id,
    rpt_qualrouting_cont.poll_id,
    rpt_qualrouting_cont.dryw_inf,
    rpt_qualrouting_cont.wetw_inf,
    rpt_qualrouting_cont.ground_inf,
    rpt_qualrouting_cont.rdii_inf,
    rpt_qualrouting_cont.ext_inf,
    rpt_qualrouting_cont.int_inf,
    rpt_qualrouting_cont.ext_out,
    rpt_qualrouting_cont.mass_reac,
    rpt_qualrouting_cont.initst_mas,
    rpt_qualrouting_cont.finst_mas,
    rpt_qualrouting_cont.cont_error
   FROM selector_rpt_main,
    rpt_qualrouting_cont
  WHERE (((rpt_qualrouting_cont.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_rainfall_dep; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_rainfall_dep AS
 SELECT rpt_rainfall_dep.id,
    rpt_rainfall_dep.result_id,
    rpt_rainfall_dep.sewer_rain,
    rpt_rainfall_dep.rdiip_prod,
    rpt_rainfall_dep.rdiir_rat
   FROM selector_rpt_main,
    rpt_rainfall_dep
  WHERE (((rpt_rainfall_dep.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_routing_timestep; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_routing_timestep AS
 SELECT rpt_routing_timestep.id,
    rpt_routing_timestep.result_id,
    rpt_routing_timestep.text
   FROM selector_rpt_main,
    rpt_routing_timestep
  WHERE (((rpt_routing_timestep.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_runoff_qual; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_runoff_qual AS
 SELECT rpt_runoff_qual.id,
    rpt_runoff_qual.result_id,
    rpt_runoff_qual.poll_id,
    rpt_runoff_qual.init_buil,
    rpt_runoff_qual.surf_buil,
    rpt_runoff_qual.wet_dep,
    rpt_runoff_qual.sweep_re,
    rpt_runoff_qual.infil_loss,
    rpt_runoff_qual.bmp_re,
    rpt_runoff_qual.surf_runof,
    rpt_runoff_qual.rem_buil,
    rpt_runoff_qual.cont_error
   FROM selector_rpt_main,
    rpt_runoff_qual
  WHERE (((rpt_runoff_qual.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_runoff_quant; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_runoff_quant AS
 SELECT rpt_runoff_quant.id,
    rpt_runoff_quant.result_id,
    rpt_runoff_quant.initsw_co,
    rpt_runoff_quant.total_prec,
    rpt_runoff_quant.evap_loss,
    rpt_runoff_quant.infil_loss,
    rpt_runoff_quant.surf_runof,
    rpt_runoff_quant.snow_re,
    rpt_runoff_quant.finalsw_co,
    rpt_runoff_quant.finals_sto,
    rpt_runoff_quant.cont_error
   FROM selector_rpt_main,
    rpt_runoff_quant
  WHERE (((rpt_runoff_quant.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_storagevol_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_storagevol_sum AS
 SELECT rpt_storagevol_sum.id,
    rpt_storagevol_sum.result_id,
    rpt_storagevol_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_storagevol_sum.aver_vol,
    rpt_storagevol_sum.avg_full,
    rpt_storagevol_sum.ei_loss,
    rpt_storagevol_sum.max_vol,
    rpt_storagevol_sum.max_full,
    rpt_storagevol_sum.time_days,
    rpt_storagevol_sum.time_hour,
    rpt_storagevol_sum.max_out,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node
     JOIN rpt_storagevol_sum ON (((rpt_storagevol_sum.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_storagevol_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((rpt_inp_node.result_id)::text = (selector_rpt_main.result_id)::text));


--
-- Name: v_rpt_subcatchrunoff_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_subcatchrunoff_sum AS
 SELECT rpt_subcatchrunoff_sum.id,
    rpt_subcatchrunoff_sum.result_id,
    rpt_subcatchrunoff_sum.subc_id,
    rpt_subcatchrunoff_sum.tot_precip,
    rpt_subcatchrunoff_sum.tot_runon,
    rpt_subcatchrunoff_sum.tot_evap,
    rpt_subcatchrunoff_sum.tot_infil,
    rpt_subcatchrunoff_sum.tot_runoff,
    rpt_subcatchrunoff_sum.tot_runofl,
    rpt_subcatchrunoff_sum.peak_runof,
    rpt_subcatchrunoff_sum.runoff_coe,
    rpt_subcatchrunoff_sum.vxmax,
    rpt_subcatchrunoff_sum.vymax,
    rpt_subcatchrunoff_sum.depth,
    rpt_subcatchrunoff_sum.vel,
    rpt_subcatchrunoff_sum.vhmax,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_main,
    (inp_subcatchment
     JOIN rpt_subcatchrunoff_sum ON (((rpt_subcatchrunoff_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_subcatchrunoff_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_subcatchwashoff_sum; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_subcatchwashoff_sum AS
 SELECT rpt_subcatchwashoff_sum.id,
    rpt_subcatchwashoff_sum.result_id,
    rpt_subcatchwashoff_sum.subc_id,
    rpt_subcatchwashoff_sum.poll_id,
    rpt_subcatchwashoff_sum.value,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_main,
    (inp_subcatchment
     JOIN rpt_subcatchwashoff_sum ON (((rpt_subcatchwashoff_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_subcatchwashoff_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rpt_timestep_critelem; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_timestep_critelem AS
 SELECT rpt_timestep_critelem.id,
    rpt_timestep_critelem.result_id,
    rpt_timestep_critelem.text
   FROM selector_rpt_main,
    rpt_timestep_critelem
  WHERE (((rpt_timestep_critelem.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));


--
-- Name: v_rtc_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_hydrometer AS
 SELECT (ext_rtc_hydrometer.id)::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN (connec.connec_id IS NULL) THEN 'XXXX'::character varying
            ELSE connec.connec_id
        END AS connec_id,
        CASE
            WHEN ((ext_rtc_hydrometer.connec_id)::text IS NULL) THEN 'XXXX'::text
            ELSE (ext_rtc_hydrometer.connec_id)::text
        END AS connec_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE ((config_param_system.parameter)::text = 'edit_hydro_link_absolute_path'::text)) IS NULL) THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE ((config_param_system.parameter)::text = 'edit_hydro_link_absolute_path'::text)), rtc_hydrometer.link)
        END AS hydrometer_link
   FROM selector_hydrometer,
    selector_expl,
    (((((rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON (((ext_rtc_hydrometer.id)::text = (rtc_hydrometer.hydrometer_id)::text)))
     JOIN ext_rtc_hydrometer_state ON ((ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id)))
     JOIN connec ON (((connec.customer_code)::text = (ext_rtc_hydrometer.connec_id)::text)))
     LEFT JOIN ext_municipality ON ((ext_municipality.muni_id = connec.muni_id)))
     LEFT JOIN exploitation ON ((exploitation.expl_id = connec.expl_id)))
  WHERE ((selector_hydrometer.state_id = ext_rtc_hydrometer.state_id) AND (selector_hydrometer.cur_user = ("current_user"())::text) AND (selector_expl.expl_id = connec.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_rtc_hydrometer_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_hydrometer_x_connec AS
 SELECT rtc_hydrometer_x_connec.connec_id,
    (count(v_rtc_hydrometer.hydrometer_id))::integer AS n_hydrometer
   FROM (rtc_hydrometer_x_connec
     JOIN v_rtc_hydrometer ON ((v_rtc_hydrometer.hydrometer_id = (rtc_hydrometer_x_connec.hydrometer_id)::text)))
  GROUP BY rtc_hydrometer_x_connec.connec_id;


--
-- Name: v_rtc_period_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_period_hydrometer AS
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    temp_arc.node_1,
    temp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    (c.effc)::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ((ext_rtc_hydrometer_x_data.custom_sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
            ELSE ((ext_rtc_hydrometer_x_data.sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ((((((ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     JOIN ext_cat_period ON (((ext_rtc_hydrometer_x_data.cat_period_id)::text = (ext_cat_period.id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     JOIN v_connec ON (((v_connec.connec_id)::text = (rtc_hydrometer_x_connec.connec_id)::text)))
     JOIN temp_arc ON (((v_connec.arc_id)::text = (temp_arc.arc_id)::text)))
     JOIN ext_rtc_dma_period c ON ((((c.cat_period_id)::text = (ext_cat_period.id)::text) AND ((c.dma_id)::integer = v_connec.dma_id))))
  WHERE ((ext_cat_period.id)::text = ( SELECT config_param_user.value
           FROM config_param_user
          WHERE (((config_param_user.cur_user)::name = "current_user"()) AND ((config_param_user.parameter)::text = 'inp_options_rtc_period_id'::text))))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    (c.effc)::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ((ext_rtc_hydrometer_x_data.custom_sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
            ELSE ((ext_rtc_hydrometer_x_data.sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ((((((ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     JOIN ext_cat_period ON (((ext_rtc_hydrometer_x_data.cat_period_id)::text = (ext_cat_period.id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     LEFT JOIN v_connec ON (((v_connec.connec_id)::text = (rtc_hydrometer_x_connec.connec_id)::text)))
     JOIN temp_node ON ((concat('VN', v_connec.pjoint_id) = (temp_node.node_id)::text)))
     JOIN ext_rtc_dma_period c ON ((((c.cat_period_id)::text = (ext_cat_period.id)::text) AND ((v_connec.dma_id)::text = (c.dma_id)::text))))
  WHERE (((v_connec.pjoint_type)::text = 'VNODE'::text) AND ((ext_cat_period.id)::text = ( SELECT config_param_user.value
           FROM config_param_user
          WHERE (((config_param_user.cur_user)::name = "current_user"()) AND ((config_param_user.parameter)::text = 'inp_options_rtc_period_id'::text)))))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    (c.effc)::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ((ext_rtc_hydrometer_x_data.custom_sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
            ELSE ((ext_rtc_hydrometer_x_data.sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ((((((ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     JOIN ext_cat_period ON (((ext_rtc_hydrometer_x_data.cat_period_id)::text = (ext_cat_period.id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     LEFT JOIN v_connec ON (((v_connec.connec_id)::text = (rtc_hydrometer_x_connec.connec_id)::text)))
     JOIN temp_node ON (((v_connec.pjoint_id)::text = (temp_node.node_id)::text)))
     JOIN ext_rtc_dma_period c ON ((((c.cat_period_id)::text = (ext_cat_period.id)::text) AND ((v_connec.dma_id)::text = (c.dma_id)::text))))
  WHERE (((v_connec.pjoint_type)::text = 'NODE'::text) AND ((ext_cat_period.id)::text = ( SELECT config_param_user.value
           FROM config_param_user
          WHERE (((config_param_user.cur_user)::name = "current_user"()) AND ((config_param_user.parameter)::text = 'inp_options_rtc_period_id'::text)))));


--
-- Name: v_rtc_period_dma; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_period_dma AS
 SELECT (v_rtc_period_hydrometer.dma_id)::integer AS dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period,
    a.pattern_id
   FROM (v_rtc_period_hydrometer
     JOIN ext_rtc_dma_period a ON ((((a.dma_id)::text = (v_rtc_period_hydrometer.dma_id)::text) AND ((v_rtc_period_hydrometer.period_id)::text = (a.cat_period_id)::text))))
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id, a.pattern_id;


--
-- Name: v_rtc_period_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_period_node AS
 SELECT a.node_id,
    a.dma_id,
    a.period_id,
    sum(a.lps_avg) AS lps_avg,
    a.effc,
    sum(a.lps_avg_real) AS lps_avg_real,
    a.minc,
    sum(a.lps_min) AS lps_min,
    a.maxc,
    sum(a.lps_max) AS lps_max,
    sum(a.m3_total_period) AS m3_total_period
   FROM ( SELECT v_rtc_period_hydrometer.node_1 AS node_id,
            v_rtc_period_hydrometer.dma_id,
            v_rtc_period_hydrometer.period_id,
            sum((v_rtc_period_hydrometer.lps_avg * (0.5)::double precision)) AS lps_avg,
            v_rtc_period_hydrometer.effc,
            sum(((v_rtc_period_hydrometer.lps_avg * (0.5)::double precision) / (v_rtc_period_hydrometer.effc)::double precision)) AS lps_avg_real,
            v_rtc_period_hydrometer.minc,
            sum((((v_rtc_period_hydrometer.lps_avg * (0.5)::double precision) / (v_rtc_period_hydrometer.effc)::double precision) * v_rtc_period_hydrometer.minc)) AS lps_min,
            v_rtc_period_hydrometer.maxc,
            sum((((v_rtc_period_hydrometer.lps_avg * (0.5)::double precision) / (v_rtc_period_hydrometer.effc)::double precision) * v_rtc_period_hydrometer.maxc)) AS lps_max,
            sum((v_rtc_period_hydrometer.m3_total_period * (0.5)::double precision)) AS m3_total_period
           FROM v_rtc_period_hydrometer
          WHERE (v_rtc_period_hydrometer.pjoint_id IS NULL)
          GROUP BY v_rtc_period_hydrometer.node_1, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc
        UNION
         SELECT v_rtc_period_hydrometer.node_2 AS node_id,
            v_rtc_period_hydrometer.dma_id,
            v_rtc_period_hydrometer.period_id,
            sum((v_rtc_period_hydrometer.lps_avg * (0.5)::double precision)) AS lps_avg,
            v_rtc_period_hydrometer.effc,
            sum(((v_rtc_period_hydrometer.lps_avg * (0.5)::double precision) / (v_rtc_period_hydrometer.effc)::double precision)) AS lps_avg_real,
            v_rtc_period_hydrometer.minc,
            sum((((v_rtc_period_hydrometer.lps_avg * (0.5)::double precision) / (v_rtc_period_hydrometer.effc)::double precision) * v_rtc_period_hydrometer.minc)) AS lps_min,
            v_rtc_period_hydrometer.maxc,
            sum((((v_rtc_period_hydrometer.lps_avg * (0.5)::double precision) / (v_rtc_period_hydrometer.effc)::double precision) * v_rtc_period_hydrometer.maxc)) AS lps_max,
            sum((v_rtc_period_hydrometer.m3_total_period * (0.5)::double precision)) AS m3_total_period
           FROM v_rtc_period_hydrometer
          WHERE (v_rtc_period_hydrometer.pjoint_id IS NULL)
          GROUP BY v_rtc_period_hydrometer.node_2, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc) a
  GROUP BY a.node_id, a.period_id, a.dma_id, a.effc, a.minc, a.maxc;


--
-- Name: v_rtc_period_pjoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_period_pjoint AS
 SELECT v_rtc_period_hydrometer.pjoint_id,
    v_rtc_period_hydrometer.dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.lps_avg) AS lps_avg,
    v_rtc_period_hydrometer.effc,
    sum((v_rtc_period_hydrometer.lps_avg / (v_rtc_period_hydrometer.effc)::double precision)) AS lps_avg_real,
    v_rtc_period_hydrometer.minc,
    sum(((v_rtc_period_hydrometer.lps_avg / (v_rtc_period_hydrometer.effc)::double precision) * v_rtc_period_hydrometer.minc)) AS lps_min,
    v_rtc_period_hydrometer.maxc,
    sum(((v_rtc_period_hydrometer.lps_avg / (v_rtc_period_hydrometer.effc)::double precision) * v_rtc_period_hydrometer.maxc)) AS lps_max,
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period
   FROM v_rtc_period_hydrometer
  WHERE (v_rtc_period_hydrometer.pjoint_id IS NOT NULL)
  GROUP BY v_rtc_period_hydrometer.pjoint_id, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc;


--
-- Name: v_ui_arc_x_relations; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_arc_x_relations AS
 WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM (v_node n
             JOIN v_edit_link l ON (((n.node_id)::text = (l.exit_id)::text)))
        )
 SELECT (row_number() OVER () + 1000000) AS rid,
    v_connec.arc_id,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    v_connec.state AS feature_state,
    public.st_x(v_connec.the_geom) AS x,
    public.st_y(v_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM (v_connec
     JOIN v_edit_link l ON (((v_connec.connec_id)::text = (l.feature_id)::text)))
  WHERE ((v_connec.arc_id IS NOT NULL) AND ((l.exit_type)::text <> 'NODE'::text))
UNION
 SELECT DISTINCT ON (c.connec_id) (row_number() OVER () + 2000000) AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.connecat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    c.state AS feature_state,
    public.st_x(c.the_geom) AS x,
    public.st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM ((v_arc a
     JOIN links_node n ON (((a.node_1)::text = (n.node_id)::text)))
     JOIN v_connec c ON (((c.connec_id)::text = (n.feature_id)::text)))
UNION
 SELECT (row_number() OVER () + 3000000) AS rid,
    v_gully.arc_id,
    v_gully.gully_type AS featurecat_id,
    v_gully.gratecat_id AS catalog,
    v_gully.gully_id AS feature_id,
    v_gully.code AS feature_code,
    v_gully.sys_type,
    v_gully.state AS feature_state,
    public.st_x(v_gully.the_geom) AS x,
    public.st_y(v_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM (v_gully
     JOIN v_edit_link l ON (((v_gully.gully_id)::text = (l.feature_id)::text)))
  WHERE ((v_gully.arc_id IS NOT NULL) AND ((l.exit_type)::text <> 'NODE'::text))
UNION
 SELECT DISTINCT ON (g.gully_id) (row_number() OVER () + 4000000) AS rid,
    a.arc_id,
    g.gully_type AS featurecat_id,
    g.gratecat_id AS catalog,
    g.gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    g.state AS feature_state,
    public.st_x(g.the_geom) AS x,
    public.st_y(g.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM ((v_arc a
     JOIN links_node n ON (((a.node_1)::text = (n.node_id)::text)))
     JOIN v_gully g ON (((g.gully_id)::text = (n.feature_id)::text)));


--
-- Name: v_ui_cat_dscenario; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_cat_dscenario AS
 SELECT DISTINCT ON (c.dscenario_id) c.dscenario_id,
    c.name,
    c.descript,
    c.dscenario_type,
    c.parent_id,
    c.expl_id,
    c.active,
    c.log
   FROM cat_dscenario c,
    selector_expl s
  WHERE (((s.expl_id = c.expl_id) AND (s.cur_user = (CURRENT_USER)::text)) OR (c.expl_id IS NULL));


--
-- Name: v_ui_doc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc AS
 SELECT doc.id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;


--
-- Name: v_ui_doc_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_arc AS
 SELECT doc_x_arc.id,
    doc_x_arc.arc_id,
    doc_x_arc.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_arc
     JOIN doc ON (((doc.id)::text = (doc_x_arc.doc_id)::text)));


--
-- Name: v_ui_doc_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_connec AS
 SELECT doc_x_connec.id,
    doc_x_connec.connec_id,
    doc_x_connec.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_connec
     JOIN doc ON (((doc.id)::text = (doc_x_connec.doc_id)::text)));


--
-- Name: v_ui_doc_x_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_gully AS
 SELECT doc_x_gully.id,
    doc_x_gully.gully_id,
    doc_x_gully.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_gully
     JOIN doc ON (((doc.id)::text = (doc_x_gully.doc_id)::text)));


--
-- Name: v_ui_doc_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_node AS
 SELECT doc_x_node.id,
    doc_x_node.node_id,
    doc_x_node.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_node
     JOIN doc ON (((doc.id)::text = (doc_x_node.doc_id)::text)));


--
-- Name: v_ui_doc_x_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_psector AS
 SELECT doc_x_psector.id,
    doc_x_psector.psector_id,
    doc_x_psector.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_psector
     JOIN doc ON (((doc.id)::text = (doc_x_psector.doc_id)::text)));


--
-- Name: v_ui_doc_x_visit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_visit AS
 SELECT doc_x_visit.id,
    doc_x_visit.visit_id,
    doc_x_visit.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_visit
     JOIN doc ON (((doc.id)::text = (doc_x_visit.doc_id)::text)));


--
-- Name: v_ui_doc_x_workcat; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_workcat AS
 SELECT doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc_x_workcat.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_workcat
     JOIN doc ON (((doc.id)::text = (doc_x_workcat.doc_id)::text)));


--
-- Name: v_ui_document; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_document AS
 SELECT doc.id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;


--
-- Name: v_ui_element; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element AS
 SELECT element.element_id AS id,
    element.code,
    element.elementcat_id,
    element.serial_number,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.fluid_type,
    element.location_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.undelete,
    element.publish,
    element.inventory,
    element.expl_id,
    element.feature_type,
    element.tstamp
   FROM element;


--
-- Name: v_ui_element_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element_x_arc AS
 SELECT element_x_arc.id,
    element_x_arc.arc_id,
    element_x_arc.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM (((((element_x_arc
     JOIN v_edit_element ON (((v_edit_element.element_id)::text = (element_x_arc.element_id)::text)))
     JOIN value_state ON ((v_edit_element.state = value_state.id)))
     LEFT JOIN value_state_type ON ((v_edit_element.state_type = value_state_type.id)))
     LEFT JOIN man_type_location ON ((((man_type_location.location_type)::text = (v_edit_element.location_type)::text) AND ((man_type_location.feature_type)::text = 'ELEMENT'::text))))
     LEFT JOIN cat_element ON (((cat_element.id)::text = (v_edit_element.elementcat_id)::text)));


--
-- Name: v_ui_element_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element_x_connec AS
 SELECT element_x_connec.id,
    element_x_connec.connec_id,
    element_x_connec.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM (((((element_x_connec
     JOIN v_edit_element ON (((v_edit_element.element_id)::text = (element_x_connec.element_id)::text)))
     JOIN value_state ON ((v_edit_element.state = value_state.id)))
     LEFT JOIN value_state_type ON ((v_edit_element.state_type = value_state_type.id)))
     LEFT JOIN man_type_location ON ((((man_type_location.location_type)::text = (v_edit_element.location_type)::text) AND ((man_type_location.feature_type)::text = 'ELEMENT'::text))))
     LEFT JOIN cat_element ON (((cat_element.id)::text = (v_edit_element.elementcat_id)::text)));


--
-- Name: v_ui_element_x_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element_x_gully AS
 SELECT element_x_gully.id,
    element_x_gully.gully_id,
    element_x_gully.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate
   FROM (((((element_x_gully
     JOIN v_edit_element ON (((v_edit_element.element_id)::text = (element_x_gully.element_id)::text)))
     JOIN value_state ON ((v_edit_element.state = value_state.id)))
     LEFT JOIN value_state_type ON ((v_edit_element.state_type = value_state_type.id)))
     LEFT JOIN man_type_location ON ((((man_type_location.location_type)::text = (v_edit_element.location_type)::text) AND ((man_type_location.feature_type)::text = 'ELEMENT'::text))))
     LEFT JOIN cat_element ON (((cat_element.id)::text = (v_edit_element.elementcat_id)::text)));


--
-- Name: v_ui_element_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element_x_node AS
 SELECT element_x_node.id,
    element_x_node.node_id,
    element_x_node.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM (((((element_x_node
     JOIN v_edit_element ON (((v_edit_element.element_id)::text = (element_x_node.element_id)::text)))
     JOIN value_state ON ((v_edit_element.state = value_state.id)))
     LEFT JOIN value_state_type ON ((v_edit_element.state_type = value_state_type.id)))
     LEFT JOIN man_type_location ON ((((man_type_location.location_type)::text = (v_edit_element.location_type)::text) AND ((man_type_location.feature_type)::text = 'ELEMENT'::text))))
     LEFT JOIN cat_element ON (((cat_element.id)::text = (v_edit_element.elementcat_id)::text)));


--
-- Name: v_ui_event_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_event_x_arc AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_arc ON ((om_visit_x_arc.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     JOIN arc ON (((arc.arc_id)::text = (om_visit_x_arc.arc_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_arc.arc_id;


--
-- Name: v_ui_event_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_event_x_connec AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_connec ON ((om_visit_x_connec.visit_id = om_visit.id)))
     JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN connec ON (((connec.connec_id)::text = (om_visit_x_connec.connec_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_connec.connec_id;


--
-- Name: v_ui_event_x_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_event_x_gully AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_gully.gully_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_gully ON ((om_visit_x_gully.visit_id = om_visit.id)))
     JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN gully ON (((gully.gully_id)::text = (om_visit_x_gully.gully_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_gully.gully_id;


--
-- Name: v_ui_event_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_event_x_node AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document
   FROM (((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_node ON ((om_visit_x_node.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_node.node_id;


--
-- Name: v_ui_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_hydrometer AS
 SELECT v_rtc_hydrometer.hydrometer_id,
    v_rtc_hydrometer.connec_id,
    v_rtc_hydrometer.hydrometer_customer_code,
    v_rtc_hydrometer.connec_customer_code,
    v_rtc_hydrometer.state,
    v_rtc_hydrometer.expl_name,
    v_rtc_hydrometer.hydrometer_link
   FROM v_rtc_hydrometer;


--
-- Name: v_ui_hydroval_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_hydroval_x_connec AS
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM (((((((ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::text = (ext_rtc_hydrometer.id)::text)))
     LEFT JOIN ext_cat_hydrometer ON (((ext_cat_hydrometer.id)::text = (ext_rtc_hydrometer.catalog_id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::text = (ext_rtc_hydrometer_x_data.hydrometer_id)::text)))
     JOIN connec ON (((rtc_hydrometer_x_connec.connec_id)::text = (connec.connec_id)::text)))
     LEFT JOIN crm_typevalue crmtype ON (((ext_rtc_hydrometer_x_data.value_type = (crmtype.id)::integer) AND ((crmtype.typevalue)::text = 'crm_value_type'::text))))
     LEFT JOIN crm_typevalue crmstatus ON (((ext_rtc_hydrometer_x_data.value_status = (crmstatus.id)::integer) AND ((crmstatus.typevalue)::text = 'crm_value_status'::text))))
     LEFT JOIN crm_typevalue crmstate ON (((ext_rtc_hydrometer_x_data.value_state = (crmstate.id)::integer) AND ((crmstate.typevalue)::text = 'crm_value_state'::text))))
  ORDER BY ext_rtc_hydrometer_x_data.id;


--
-- Name: v_ui_node_x_connection_downstream; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_node_x_connection_downstream AS
 SELECT (row_number() OVER (ORDER BY v_arc.node_1) + 1000000) AS rid,
    v_arc.node_1 AS node_id,
    v_arc.arc_id AS feature_id,
    v_arc.code AS feature_code,
    v_arc.arc_type AS featurecat_id,
    v_arc.arccat_id,
    v_arc.y2 AS depth,
    (public.st_length2d(v_arc.the_geom))::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
    v_arc.y1 AS downstream_depth,
    v_arc.sys_type,
    public.st_x(public.st_lineinterpolatepoint(v_arc.the_geom, (0.5)::double precision)) AS x,
    public.st_y(public.st_lineinterpolatepoint(v_arc.the_geom, (0.5)::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM (((v_arc
     JOIN node ON (((v_arc.node_2)::text = (node.node_id)::text)))
     LEFT JOIN cat_arc ON (((v_arc.arccat_id)::text = (cat_arc.id)::text)))
     JOIN value_state ON ((v_arc.state = value_state.id)));


--
-- Name: v_ui_node_x_connection_upstream; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_node_x_connection_upstream AS
 SELECT (row_number() OVER (ORDER BY v_arc.node_2) + 1000000) AS rid,
    v_arc.node_2 AS node_id,
    v_arc.arc_id AS feature_id,
    v_arc.code AS feature_code,
    v_arc.arc_type AS featurecat_id,
    v_arc.arccat_id,
    v_arc.y1 AS depth,
    (public.st_length2d(v_arc.the_geom))::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_arc.y2 AS upstream_depth,
    v_arc.sys_type,
    public.st_x(public.st_lineinterpolatepoint(v_arc.the_geom, (0.5)::double precision)) AS x,
    public.st_y(public.st_lineinterpolatepoint(v_arc.the_geom, (0.5)::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM (((v_arc
     JOIN node ON (((v_arc.node_1)::text = (node.node_id)::text)))
     LEFT JOIN cat_arc ON (((v_arc.arccat_id)::text = (cat_arc.id)::text)))
     JOIN value_state ON ((v_arc.state = value_state.id)))
UNION
 SELECT DISTINCT ON (v_connec.connec_id) (row_number() OVER (ORDER BY node.node_id) + 2000000) AS rid,
    node.node_id,
    v_connec.connec_id AS feature_id,
    (v_connec.code)::text AS feature_code,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS arccat_id,
    v_connec.y1 AS depth,
    (public.st_length2d(link.the_geom))::numeric(12,2) AS length,
    v_connec.connec_id AS upstream_id,
    v_connec.code AS upstream_code,
    v_connec.connec_type AS upstream_type,
    v_connec.y2 AS upstream_depth,
    v_connec.sys_type,
    public.st_x(v_connec.the_geom) AS x,
    public.st_y(v_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM ((((v_connec
     JOIN link ON ((((link.feature_id)::text = (v_connec.connec_id)::text) AND ((link.feature_type)::text = 'CONNEC'::text))))
     JOIN node ON ((((v_connec.pjoint_id)::text = (node.node_id)::text) AND ((v_connec.pjoint_type)::text = 'NODE'::text))))
     LEFT JOIN cat_connec ON (((v_connec.connecat_id)::text = (cat_connec.id)::text)))
     JOIN value_state ON ((v_connec.state = value_state.id)))
UNION
 SELECT DISTINCT ON (v_connec.connec_id) (row_number() OVER (ORDER BY node.node_id) + 3000000) AS rid,
    node.node_id,
    v_connec.connec_id AS feature_id,
    (v_connec.code)::text AS feature_code,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS arccat_id,
    v_connec.y1 AS depth,
    (public.st_length2d(link.the_geom))::numeric(12,2) AS length,
    v_connec.connec_id AS upstream_id,
    v_connec.code AS upstream_code,
    v_connec.connec_type AS upstream_type,
    v_connec.y2 AS upstream_depth,
    v_connec.sys_type,
    public.st_x(v_connec.the_geom) AS x,
    public.st_y(v_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM (((((v_connec
     JOIN link ON ((((link.feature_id)::text = (v_connec.connec_id)::text) AND ((link.feature_type)::text = 'CONNEC'::text) AND ((link.exit_type)::text = 'CONNEC'::text))))
     JOIN connec ON ((((connec.connec_id)::text = (link.exit_id)::text) AND ((connec.pjoint_type)::text = 'NODE'::text))))
     JOIN node ON (((connec.pjoint_id)::text = (node.node_id)::text)))
     LEFT JOIN cat_connec ON (((v_connec.connecat_id)::text = (cat_connec.id)::text)))
     JOIN value_state ON ((v_connec.state = value_state.id)))
UNION
 SELECT DISTINCT ON (v_gully.gully_id) (row_number() OVER (ORDER BY node.node_id) + 4000000) AS rid,
    node.node_id,
    v_gully.gully_id AS feature_id,
    (v_gully.code)::text AS feature_code,
    v_gully.gully_type AS featurecat_id,
    v_gully.connec_arccat_id AS arccat_id,
    (v_gully.ymax - v_gully.sandbox) AS depth,
    v_gully.connec_length AS length,
    v_gully.gully_id AS upstream_id,
    v_gully.code AS upstream_code,
    v_gully.gully_type AS upstream_type,
    v_gully.connec_depth AS upstream_depth,
    v_gully.sys_type,
    public.st_x(v_gully.the_geom) AS x,
    public.st_y(v_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM ((((v_gully
     JOIN link ON ((((link.feature_id)::text = (v_gully.gully_id)::text) AND ((link.feature_type)::text = 'GULLY'::text))))
     JOIN node ON ((((v_gully.pjoint_id)::text = (node.node_id)::text) AND ((v_gully.pjoint_type)::text = 'NODE'::text))))
     LEFT JOIN cat_connec ON (((v_gully.connec_arccat_id)::text = (cat_connec.id)::text)))
     JOIN value_state ON ((v_gully.state = value_state.id)))
UNION
 SELECT DISTINCT ON (v_gully.gully_id) (row_number() OVER (ORDER BY node.node_id) + 5000000) AS rid,
    node.node_id,
    v_gully.gully_id AS feature_id,
    (v_gully.code)::text AS feature_code,
    v_gully.gully_type AS featurecat_id,
    v_gully.connec_arccat_id AS arccat_id,
    (v_gully.ymax - v_gully.sandbox) AS depth,
    v_gully.connec_length AS length,
    v_gully.gully_id AS upstream_id,
    v_gully.code AS upstream_code,
    v_gully.gully_type AS upstream_type,
    v_gully.connec_depth AS upstream_depth,
    v_gully.sys_type,
    public.st_x(v_gully.the_geom) AS x,
    public.st_y(v_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM (((((v_gully
     JOIN link ON ((((link.feature_id)::text = (v_gully.gully_id)::text) AND ((link.feature_type)::text = 'GULLY'::text) AND ((link.exit_type)::text = 'GULLY'::text))))
     JOIN gully ON ((((gully.gully_id)::text = (link.exit_id)::text) AND ((gully.pjoint_type)::text = 'NODE'::text))))
     JOIN node ON (((gully.pjoint_id)::text = (node.node_id)::text)))
     LEFT JOIN cat_connec ON (((v_gully.connec_arccat_id)::text = (cat_connec.id)::text)))
     JOIN value_state ON ((v_gully.state = value_state.id)));


--
-- Name: v_ui_om_event; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_event AS
 SELECT om_visit_event.id,
    om_visit_event.event_code,
    om_visit_event.visit_id,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit_event;


--
-- Name: v_ui_om_visit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit AS
 SELECT om_visit.id,
    om_visit_cat.name AS visit_catalog,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    exploitation.name AS exploitation,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done
   FROM ((om_visit
     JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
     LEFT JOIN exploitation ON ((exploitation.expl_id = om_visit.expl_id)));


--
-- Name: v_ui_om_visit_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_arc AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_arc ON ((om_visit_x_arc.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     JOIN arc ON (((arc.arc_id)::text = (om_visit_x_arc.arc_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_arc.arc_id;


--
-- Name: v_ui_om_visit_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_connec AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_connec ON ((om_visit_x_connec.visit_id = om_visit.id)))
     JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN connec ON (((connec.connec_id)::text = (om_visit_x_connec.connec_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_connec.connec_id;


--
-- Name: v_ui_om_visit_x_doc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_doc AS
 SELECT doc_x_visit.id,
    doc_x_visit.doc_id,
    doc_x_visit.visit_id
   FROM doc_x_visit;


--
-- Name: v_ui_om_visit_x_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_gully AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_gully.gully_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM (((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_gully ON ((om_visit_x_gully.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_gully.gully_id;


--
-- Name: v_ui_om_visit_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_node AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM (((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_node ON ((om_visit_x_node.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_node.node_id;


--
-- Name: v_ui_om_visitman_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visitman_x_arc AS
 SELECT DISTINCT ON (v_ui_om_visit_x_arc.visit_id) v_ui_om_visit_x_arc.visit_id,
    v_ui_om_visit_x_arc.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_arc.arc_id,
    date_trunc('second'::text, v_ui_om_visit_x_arc.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_arc.visit_end) AS visit_end,
    v_ui_om_visit_x_arc.user_name,
    v_ui_om_visit_x_arc.is_done,
    v_ui_om_visit_x_arc.feature_type,
    v_ui_om_visit_x_arc.form_type
   FROM (v_ui_om_visit_x_arc
     LEFT JOIN om_visit_cat ON ((om_visit_cat.id = v_ui_om_visit_x_arc.visitcat_id)));


--
-- Name: v_ui_om_visitman_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visitman_x_connec AS
 SELECT DISTINCT ON (v_ui_om_visit_x_connec.visit_id) v_ui_om_visit_x_connec.visit_id,
    v_ui_om_visit_x_connec.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_connec.connec_id,
    date_trunc('second'::text, v_ui_om_visit_x_connec.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_connec.visit_end) AS visit_end,
    v_ui_om_visit_x_connec.user_name,
    v_ui_om_visit_x_connec.is_done,
    v_ui_om_visit_x_connec.feature_type,
    v_ui_om_visit_x_connec.form_type
   FROM (v_ui_om_visit_x_connec
     LEFT JOIN om_visit_cat ON ((om_visit_cat.id = v_ui_om_visit_x_connec.visitcat_id)));


--
-- Name: v_ui_om_visitman_x_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visitman_x_gully AS
 SELECT DISTINCT ON (v_ui_om_visit_x_gully.visit_id) v_ui_om_visit_x_gully.visit_id,
    v_ui_om_visit_x_gully.ext_code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_gully.gully_id,
    date_trunc('second'::text, v_ui_om_visit_x_gully.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_gully.visit_end) AS visit_end,
    v_ui_om_visit_x_gully.user_name,
    v_ui_om_visit_x_gully.is_done,
    v_ui_om_visit_x_gully.feature_type,
    v_ui_om_visit_x_gully.form_type
   FROM (v_ui_om_visit_x_gully
     LEFT JOIN om_visit_cat ON ((om_visit_cat.id = v_ui_om_visit_x_gully.visitcat_id)));


--
-- Name: v_ui_om_visitman_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visitman_x_node AS
 SELECT DISTINCT ON (v_ui_om_visit_x_node.visit_id) v_ui_om_visit_x_node.visit_id,
    v_ui_om_visit_x_node.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_node.node_id,
    date_trunc('second'::text, v_ui_om_visit_x_node.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_node.visit_end) AS visit_end,
    v_ui_om_visit_x_node.user_name,
    v_ui_om_visit_x_node.is_done,
    v_ui_om_visit_x_node.feature_type,
    v_ui_om_visit_x_node.form_type
   FROM (v_ui_om_visit_x_node
     LEFT JOIN om_visit_cat ON ((om_visit_cat.id = v_ui_om_visit_x_node.visitcat_id)));


--
-- Name: v_ui_plan_arc_cost; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_plan_arc_cost AS
 WITH p AS (
         SELECT v_plan_arc.arc_id,
            v_plan_arc.node_1,
            v_plan_arc.node_2,
            v_plan_arc.arc_type,
            v_plan_arc.arccat_id,
            v_plan_arc.epa_type,
            v_plan_arc.state,
            v_plan_arc.expl_id,
            v_plan_arc.sector_id,
            v_plan_arc.annotation,
            v_plan_arc.soilcat_id,
            v_plan_arc.y1,
            v_plan_arc.y2,
            v_plan_arc.mean_y,
            v_plan_arc.z1,
            v_plan_arc.z2,
            v_plan_arc.thickness,
            v_plan_arc.width,
            v_plan_arc.b,
            v_plan_arc.bulk,
            v_plan_arc.geom1,
            v_plan_arc.area,
            v_plan_arc.y_param,
            v_plan_arc.total_y,
            v_plan_arc.rec_y,
            v_plan_arc.geom1_ext,
            v_plan_arc.calculed_y,
            v_plan_arc.m3mlexc,
            v_plan_arc.m2mltrenchl,
            v_plan_arc.m2mlbottom,
            v_plan_arc.m2mlpav,
            v_plan_arc.m3mlprotec,
            v_plan_arc.m3mlfill,
            v_plan_arc.m3mlexcess,
            v_plan_arc.m3exc_cost,
            v_plan_arc.m2trenchl_cost,
            v_plan_arc.m2bottom_cost,
            v_plan_arc.m2pav_cost,
            v_plan_arc.m3protec_cost,
            v_plan_arc.m3fill_cost,
            v_plan_arc.m3excess_cost,
            v_plan_arc.cost_unit,
            v_plan_arc.pav_cost,
            v_plan_arc.exc_cost,
            v_plan_arc.trenchl_cost,
            v_plan_arc.base_cost,
            v_plan_arc.protec_cost,
            v_plan_arc.fill_cost,
            v_plan_arc.excess_cost,
            v_plan_arc.arc_cost,
            v_plan_arc.cost,
            v_plan_arc.length,
            v_plan_arc.budget,
            v_plan_arc.other_budget,
            v_plan_arc.total_budget,
            v_plan_arc.the_geom,
            a.id,
            a.matcat_id,
            a.shape,
            a.geom1,
            a.geom2,
            a.geom3,
            a.geom4,
            a.geom5,
            a.geom6,
            a.geom7,
            a.geom8,
            a.geom_r,
            a.descript,
            a.link,
            a.brand,
            a.model,
            a.svg,
            a.z1,
            a.z2,
            a.width,
            a.area,
            a.estimated_depth,
            a.bulk,
            a.cost_unit,
            a.cost,
            a.m2bottom_cost,
            a.m3protec_cost,
            a.active,
            a.label,
            a.tsect_id,
            a.curve_id,
            a.arc_type,
            a.acoeff,
            a.connect_cost,
            s.id,
            s.descript,
            s.link,
            s.y_param,
            s.b,
            s.trenchlining,
            s.m3exc_cost,
            s.m3fill_cost,
            s.m3excess_cost,
            s.m2trenchl_cost,
            s.active,
            a.cost AS cat_cost,
            a.m2bottom_cost AS cat_m2bottom_cost,
            a.connect_cost AS cat_connect_cost,
            a.m3protec_cost AS cat_m3_protec_cost,
            s.m3exc_cost AS cat_m3exc_cost,
            s.m3fill_cost AS cat_m3fill_cost,
            s.m3excess_cost AS cat_m3excess_cost,
            s.m2trenchl_cost AS cat_m2trenchl_cost
           FROM ((v_plan_arc
             JOIN cat_arc a ON (((a.id)::text = (v_plan_arc.arccat_id)::text)))
             JOIN cat_soil s ON (((s.id)::text = (v_plan_arc.soilcat_id)::text)))
        )
 SELECT p.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    ((1)::numeric * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mlbottom AS measurement,
    (p.m2mlbottom * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m2bottom_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlprotec AS measurement,
    (p.m3mlprotec * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m3_protec_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexc AS measurement,
    (p.m3mlexc * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m3exc_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlfill AS measurement,
    (p.m3mlfill * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m3fill_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexcess AS measurement,
    (p.m3mlexcess * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m3excess_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mltrenchl AS measurement,
    (p.m2mltrenchl * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m2trenchl_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
        CASE
            WHEN (a.price_id IS NULL) THEN 'Various pavements'::character varying
            ELSE a.pavcat_id
        END AS catalog_id,
        CASE
            WHEN (a.price_id IS NULL) THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS price_id,
    'm2'::character varying AS unit,
        CASE
            WHEN (a.price_id IS NULL) THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS descript,
    a.m2pav_cost AS cost,
    1 AS measurement,
    a.m2pav_cost AS total_cost,
    p.length
   FROM (((p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON (((a.arc_id)::text = (p.arc_id)::text)))
     JOIN cat_pavement c ON (((a.pavcat_id)::text = (c.id)::text)))
     LEFT JOIN v_price_compost r ON (((a.price_id)::text = (c.m2_cost)::text)))
UNION
 SELECT p.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of connec connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_connec.connec_id) AS measurement,
    (((min(v.price) * (count(v_edit_connec.connec_id))::numeric) / COALESCE(min(p.length), (1)::numeric)))::numeric(12,2) AS total_cost,
    (min(p.length))::numeric(12,2) AS length
   FROM ((p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id))
     JOIN v_price_compost v ON ((p.cat_connect_cost = (v.id)::text)))
  GROUP BY p.arc_id
UNION
 SELECT p.arc_id,
    10 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of gully connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_gully.gully_id) AS measurement,
    (((min(v.price) * (count(v_edit_gully.gully_id))::numeric) / COALESCE(min(p.length), (1)::numeric)))::numeric(12,2) AS total_cost,
    (min(p.length))::numeric(12,2) AS length
   FROM ((p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_gully USING (arc_id))
     JOIN v_price_compost v ON ((p.cat_connect_cost = (v.id)::text)))
  GROUP BY p.arc_id
  ORDER BY 1, 2;


--
-- Name: v_ui_plan_node_cost; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_plan_node_cost AS
 SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    ((1)::numeric * v_price_compost.price) AS total_cost,
    NULL::double precision AS length
   FROM (((node
     JOIN cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
     JOIN v_price_compost ON (((cat_node.cost)::text = (v_price_compost.id)::text)))
     JOIN v_plan_node ON (((node.node_id)::text = (v_plan_node.node_id)::text)));


--
-- Name: v_ui_plan_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_plan_psector AS
 SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    ((((plan_psector
     JOIN exploitation USING (expl_id))
     LEFT JOIN plan_typevalue p ON ((((p.id)::text = (plan_psector.priority)::text) AND (p.typevalue = 'value_priority'::text))))
     LEFT JOIN plan_typevalue s ON ((((s.id)::text = (plan_psector.status)::text) AND (s.typevalue = 'psector_status'::text))))
     LEFT JOIN plan_typevalue t ON ((((t.id)::integer = plan_psector.psector_type) AND (t.typevalue = 'psector_type'::text))))
  WHERE ((plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_ui_rpt_cat_result; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_rpt_cat_result AS
 SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.cur_user,
    rpt_cat_result.exec_date,
    inp_typevalue.idval AS status,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats
   FROM selector_expl s,
    (rpt_cat_result
     JOIN inp_typevalue ON (((rpt_cat_result.status)::text = (inp_typevalue.id)::text)))
  WHERE (((inp_typevalue.typevalue)::text = 'inp_result_status'::text) AND (((s.expl_id = rpt_cat_result.expl_id) AND (s.cur_user = CURRENT_USER)) OR (rpt_cat_result.expl_id IS NULL)));


--
-- Name: v_ui_workcat_x_feature; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_workcat_x_feature AS
 SELECT (row_number() OVER (ORDER BY arc.arc_id) + 1000000) AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
    exploitation.expl_id
   FROM (arc
     JOIN exploitation ON ((exploitation.expl_id = arc.expl_id)))
  WHERE (arc.state = 1)
UNION
 SELECT (row_number() OVER (ORDER BY node.node_id) + 2000000) AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
    exploitation.expl_id
   FROM (node
     JOIN exploitation ON ((exploitation.expl_id = node.expl_id)))
  WHERE (node.state = 1)
UNION
 SELECT (row_number() OVER (ORDER BY connec.connec_id) + 3000000) AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
    exploitation.expl_id
   FROM (connec
     JOIN exploitation ON ((exploitation.expl_id = connec.expl_id)))
  WHERE (connec.state = 1)
UNION
 SELECT (row_number() OVER (ORDER BY gully.gully_id) + 4000000) AS rid,
    gully.feature_type,
    gully.gratecat_id AS featurecat_id,
    gully.gully_id AS feature_id,
    gully.code,
    exploitation.name AS expl_name,
    gully.workcat_id,
    exploitation.expl_id
   FROM (gully
     JOIN exploitation ON ((exploitation.expl_id = gully.expl_id)))
  WHERE (gully.state = 1)
UNION
 SELECT (row_number() OVER (ORDER BY element.element_id) + 5000000) AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM (element
     JOIN exploitation ON ((exploitation.expl_id = element.expl_id)))
  WHERE (element.state = 1);


--
-- Name: v_ui_workcat_x_feature_end; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_workcat_x_feature_end AS
 SELECT (row_number() OVER (ORDER BY v_arc.arc_id) + 1000000) AS rid,
    'ARC'::character varying AS feature_type,
    v_arc.arccat_id AS featurecat_id,
    v_arc.arc_id AS feature_id,
    v_arc.code,
    exploitation.name AS expl_name,
    v_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_arc
     JOIN exploitation ON ((exploitation.expl_id = v_arc.expl_id)))
  WHERE (v_arc.state = 0)
UNION
 SELECT (row_number() OVER (ORDER BY v_node.node_id) + 2000000) AS rid,
    'NODE'::character varying AS feature_type,
    v_node.nodecat_id AS featurecat_id,
    v_node.node_id AS feature_id,
    v_node.code,
    exploitation.name AS expl_name,
    v_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_node
     JOIN exploitation ON ((exploitation.expl_id = v_node.expl_id)))
  WHERE (v_node.state = 0)
UNION
 SELECT (row_number() OVER (ORDER BY v_connec.connec_id) + 3000000) AS rid,
    'CONNEC'::character varying AS feature_type,
    v_connec.connecat_id AS featurecat_id,
    v_connec.connec_id AS feature_id,
    v_connec.code,
    exploitation.name AS expl_name,
    v_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_connec
     JOIN exploitation ON ((exploitation.expl_id = v_connec.expl_id)))
  WHERE (v_connec.state = 0)
UNION
 SELECT (row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000) AS rid,
    'ELEMENT'::character varying AS feature_type,
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_edit_element
     JOIN exploitation ON ((exploitation.expl_id = v_edit_element.expl_id)))
  WHERE (v_edit_element.state = 0)
UNION
 SELECT (row_number() OVER (ORDER BY v_gully.gully_id) + 4000000) AS rid,
    'GULLY'::character varying AS feature_type,
    v_gully.gratecat_id AS featurecat_id,
    v_gully.gully_id AS feature_id,
    v_gully.code,
    exploitation.name AS expl_name,
    v_gully.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_gully
     JOIN exploitation ON ((exploitation.expl_id = v_gully.expl_id)))
  WHERE (v_gully.state = 0);


--
-- Name: v_ui_workspace; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_workspace AS
 SELECT cat_workspace.id,
    cat_workspace.name,
    cat_workspace.private,
    cat_workspace.descript,
    cat_workspace.config
   FROM cat_workspace
  WHERE ((cat_workspace.private IS FALSE) OR ((cat_workspace.private IS TRUE) AND (cat_workspace.cur_user = (CURRENT_USER)::text)));


--
-- Name: ve_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.nodetype_1,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.sys_y1,
    v_arc.r1,
    v_arc.z1,
    v_arc.node_2,
    v_arc.nodetype_2,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.sys_y2,
    v_arc.r2,
    v_arc.z2,
    v_arc.slope,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.cat_shape,
    v_arc.cat_geom1,
    v_arc.cat_geom2,
    v_arc.width,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.inverted_slope,
    v_arc.observ,
    v_arc.comment,
    v_arc.dma_id,
    v_arc.macrodma_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.buildercat_id,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.district_id,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.undelete,
    v_arc.label,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.num_value,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom,
    v_arc.workcat_id_plan,
    v_arc.asset_id,
    v_arc.pavcat_id,
    v_arc.drainzone_id,
    v_arc.cat_area,
    v_arc.parent_id,
    v_arc.expl_id2
   FROM v_arc;


--
-- Name: ve_config_addfields; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_config_addfields AS
 SELECT sys_addfields.param_name AS columnname,
    config_form_fields.datatype,
    config_form_fields.widgettype,
    config_form_fields.label,
    config_form_fields.hidden,
    config_form_fields.layoutname,
    config_form_fields.layoutorder AS layout_order,
    sys_addfields.orderby AS addfield_order,
    sys_addfields.active,
    config_form_fields.tooltip,
    config_form_fields.placeholder,
    config_form_fields.ismandatory,
    config_form_fields.isparent,
    config_form_fields.iseditable,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    config_form_fields.widgetfunction,
    config_form_fields.linkedobject,
    config_form_fields.stylesheet,
    config_form_fields.widgetcontrols,
        CASE
            WHEN (sys_addfields.cat_feature_id IS NOT NULL) THEN config_form_fields.formname
            ELSE NULL::character varying
        END AS formname,
    sys_addfields.id AS param_id,
    sys_addfields.cat_feature_id
   FROM ((sys_addfields
     LEFT JOIN cat_feature ON (((cat_feature.id)::text = (sys_addfields.cat_feature_id)::text)))
     LEFT JOIN config_form_fields ON (((config_form_fields.columnname)::text = (sys_addfields.param_name)::text)));


--
-- Name: ve_config_sysfields; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_config_sysfields AS
 SELECT row_number() OVER () AS rid,
    config_form_fields.formname,
    config_form_fields.formtype,
    config_form_fields.columnname,
    config_form_fields.label,
    config_form_fields.hidden,
    config_form_fields.layoutname,
    config_form_fields.layoutorder,
    config_form_fields.iseditable,
    config_form_fields.ismandatory,
    config_form_fields.datatype,
    config_form_fields.widgettype,
    config_form_fields.tooltip,
    config_form_fields.placeholder,
    (config_form_fields.stylesheet)::text AS stylesheet,
    config_form_fields.isparent,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    (config_form_fields.widgetcontrols)::text AS widgetcontrols,
    config_form_fields.widgetfunction,
    config_form_fields.linkedobject,
    cat_feature.id AS cat_feature_id
   FROM (config_form_fields
     LEFT JOIN cat_feature ON (((cat_feature.child_layer)::text = (config_form_fields.formname)::text)))
  WHERE (((config_form_fields.formtype)::text = 'form_feature'::text) AND ((config_form_fields.formname)::text <> 've_arc'::text) AND ((config_form_fields.formname)::text <> 've_node'::text) AND ((config_form_fields.formname)::text <> 've_connec'::text) AND ((config_form_fields.formname)::text <> 've_gully'::text));


--
-- Name: ve_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_connec AS
 SELECT v_connec.connec_id,
    v_connec.code,
    v_connec.customer_code,
    v_connec.top_elev,
    v_connec.y1,
    v_connec.y2,
    v_connec.connecat_id,
    v_connec.connec_type,
    v_connec.sys_type,
    v_connec.private_connecat_id,
    v_connec.matcat_id,
    v_connec.expl_id,
    v_connec.macroexpl_id,
    v_connec.sector_id,
    v_connec.macrosector_id,
    v_connec.demand,
    v_connec.state,
    v_connec.state_type,
    v_connec.connec_depth,
    v_connec.connec_length,
    v_connec.arc_id,
    v_connec.annotation,
    v_connec.observ,
    v_connec.comment,
    v_connec.dma_id,
    v_connec.macrodma_id,
    v_connec.soilcat_id,
    v_connec.function_type,
    v_connec.category_type,
    v_connec.fluid_type,
    v_connec.location_type,
    v_connec.workcat_id,
    v_connec.workcat_id_end,
    v_connec.buildercat_id,
    v_connec.builtdate,
    v_connec.enddate,
    v_connec.ownercat_id,
    v_connec.muni_id,
    v_connec.postcode,
    v_connec.district_id,
    v_connec.streetname,
    v_connec.postnumber,
    v_connec.postcomplement,
    v_connec.streetname2,
    v_connec.postnumber2,
    v_connec.postcomplement2,
    v_connec.descript,
    v_connec.svg,
    v_connec.rotation,
    v_connec.link,
    v_connec.verified,
    v_connec.undelete,
    v_connec.label,
    v_connec.label_x,
    v_connec.label_y,
    v_connec.label_rotation,
    v_connec.accessibility,
    v_connec.diagonal,
    v_connec.publish,
    v_connec.inventory,
    v_connec.uncertain,
    v_connec.num_value,
    v_connec.pjoint_id,
    v_connec.pjoint_type,
    v_connec.tstamp,
    v_connec.insert_user,
    v_connec.lastupdate,
    v_connec.lastupdate_user,
    v_connec.the_geom,
    v_connec.workcat_id_plan,
    v_connec.asset_id,
    v_connec.drainzone_id,
    v_connec.expl_id2
   FROM v_connec;


--
-- Name: ve_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_gully AS
 SELECT v_gully.gully_id,
    v_gully.code,
    v_gully.top_elev,
    v_gully.ymax,
    v_gully.sandbox,
    v_gully.matcat_id,
    v_gully.gully_type,
    v_gully.sys_type,
    v_gully.gratecat_id,
    v_gully.cat_grate_matcat,
    v_gully.units,
    v_gully.groove,
    v_gully.siphon,
    v_gully.connec_arccat_id,
    v_gully.connec_length,
    v_gully.connec_depth,
    v_gully.arc_id,
    v_gully.expl_id,
    v_gully.macroexpl_id,
    v_gully.sector_id,
    v_gully.macrosector_id,
    v_gully.state,
    v_gully.state_type,
    v_gully.annotation,
    v_gully.observ,
    v_gully.comment,
    v_gully.dma_id,
    v_gully.macrodma_id,
    v_gully.soilcat_id,
    v_gully.function_type,
    v_gully.category_type,
    v_gully.fluid_type,
    v_gully.location_type,
    v_gully.workcat_id,
    v_gully.workcat_id_end,
    v_gully.buildercat_id,
    v_gully.builtdate,
    v_gully.enddate,
    v_gully.ownercat_id,
    v_gully.muni_id,
    v_gully.postcode,
    v_gully.district_id,
    v_gully.streetname,
    v_gully.postnumber,
    v_gully.postcomplement,
    v_gully.streetname2,
    v_gully.postnumber2,
    v_gully.postcomplement2,
    v_gully.descript,
    v_gully.svg,
    v_gully.rotation,
    v_gully.link,
    v_gully.verified,
    v_gully.undelete,
    v_gully.label,
    v_gully.label_x,
    v_gully.label_y,
    v_gully.label_rotation,
    v_gully.publish,
    v_gully.inventory,
    v_gully.uncertain,
    v_gully.num_value,
    v_gully.pjoint_id,
    v_gully.pjoint_type,
    v_gully.tstamp,
    v_gully.insert_user,
    v_gully.lastupdate,
    v_gully.lastupdate_user,
    v_gully.the_geom,
    v_gully.workcat_id_plan,
    v_gully.asset_id,
    v_gully.connec_matcat_id,
    v_gully.gratecat2_id,
    v_gully.connec_y1,
    v_gully.connec_y2,
    v_gully.epa_type,
    v_gully.groove_height,
    v_gully.groove_length,
    v_gully.grate_width,
    v_gully.grate_length,
    v_gully.units_placement,
    v_gully.drainzone_id,
    v_gully.expl_id2
   FROM v_gully;


--
-- Name: ve_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_node AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.sys_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.sys_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.matcat_id,
    v_node.epa_type,
    v_node.expl_id,
    v_node.macroexpl_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.macrodma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.num_value,
    v_node.tstamp,
    v_node.insert_user,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.workcat_id_plan,
    v_node.asset_id,
    v_node.drainzone_id,
    v_node.parent_id,
    v_node.arc_id,
    v_node.expl_id2
   FROM v_node;


--
-- Name: ve_pol_chamber; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_chamber AS
 SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM (v_node
     JOIN polygon ON (((polygon.feature_id)::text = (v_node.node_id)::text)))
  WHERE ((polygon.sys_type)::text = 'CHAMBER'::text);


--
-- Name: ve_pol_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_connec AS
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom
   FROM ((connec
     JOIN v_state_connec USING (connec_id))
     JOIN polygon ON (((polygon.feature_id)::text = (connec.connec_id)::text)));


--
-- Name: ve_pol_element; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_element AS
 SELECT e.pol_id,
    e.element_id,
    polygon.the_geom
   FROM (v_edit_element e
     JOIN polygon USING (pol_id));


--
-- Name: ve_pol_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_gully AS
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    gully.fluid_type
   FROM ((gully
     JOIN v_state_gully USING (gully_id))
     JOIN polygon ON (((polygon.feature_id)::text = (gully.gully_id)::text)));


--
-- Name: ve_pol_netgully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_netgully AS
 SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM (v_node
     JOIN polygon ON (((polygon.feature_id)::text = (v_node.node_id)::text)))
  WHERE ((polygon.sys_type)::text = 'NETGULLY'::text);


--
-- Name: ve_pol_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_node AS
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom
   FROM ((node
     JOIN v_state_node USING (node_id))
     JOIN polygon ON (((polygon.feature_id)::text = (node.node_id)::text)));


--
-- Name: ve_pol_storage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_storage AS
 SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM (v_node
     JOIN polygon ON (((polygon.feature_id)::text = (v_node.node_id)::text)))
  WHERE ((polygon.sys_type)::text = 'STORAGE'::text);


--
-- Name: ve_pol_wwtp; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_wwtp AS
 SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM (v_node
     JOIN polygon ON (((polygon.feature_id)::text = (v_node.node_id)::text)))
  WHERE ((polygon.sys_type)::text = 'WWTP'::text);


--
-- Name: ve_raingage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_raingage AS
 SELECT raingage.rg_id,
    raingage.form_type,
    raingage.intvl,
    raingage.scf,
    raingage.rgage_type,
    raingage.timser_id,
    raingage.fname,
    raingage.sta,
    raingage.units,
    raingage.the_geom,
    raingage.expl_id
   FROM selector_expl,
    raingage
  WHERE ((raingage.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: ve_visit_arc_singlevent; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_visit_arc_singlevent AS
 SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    ("left"((date_trunc('second'::text, om_visit.startdate))::text, 19))::timestamp without time zone AS startdate,
    ("left"((date_trunc('second'::text, om_visit.enddate))::text, 19))::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.id AS event_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM (((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_arc ON ((om_visit.id = om_visit_x_arc.visit_id)))
     JOIN config_visit_class ON ((config_visit_class.id = om_visit.class_id)))
  WHERE (config_visit_class.ismultievent = false);


--
-- Name: ve_visit_connec_singlevent; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_visit_connec_singlevent AS
 SELECT om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    ("left"((date_trunc('second'::text, om_visit.startdate))::text, 19))::timestamp without time zone AS startdate,
    ("left"((date_trunc('second'::text, om_visit.enddate))::text, 19))::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM (((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_connec ON ((om_visit.id = om_visit_x_connec.visit_id)))
     JOIN config_visit_class ON ((config_visit_class.id = om_visit.class_id)))
  WHERE (config_visit_class.ismultievent = false);


--
-- Name: ve_visit_gully_singlevent; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_visit_gully_singlevent AS
 SELECT om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    ("left"((date_trunc('second'::text, om_visit.startdate))::text, 19))::timestamp without time zone AS startdate,
    ("left"((date_trunc('second'::text, om_visit.enddate))::text, 19))::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.id AS event_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM (((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_gully ON ((om_visit.id = om_visit_x_gully.visit_id)))
     JOIN config_visit_class ON ((config_visit_class.id = om_visit.class_id)))
  WHERE (config_visit_class.ismultievent = false);


--
-- Name: ve_visit_node_singlevent; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_visit_node_singlevent AS
 SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    ("left"((date_trunc('second'::text, om_visit.startdate))::text, 19))::timestamp without time zone AS startdate,
    ("left"((date_trunc('second'::text, om_visit.enddate))::text, 19))::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM (((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_node ON ((om_visit.id = om_visit_x_node.visit_id)))
     JOIN config_visit_class ON ((config_visit_class.id = om_visit.class_id)))
  WHERE (config_visit_class.ismultievent = false);


--
-- Name: vi_adjustments; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_adjustments AS
 SELECT a.adj_type AS parameter,
    a.subc_id,
    a.monthly_adj
   FROM ( SELECT 1 AS "order",
            inp_adjustments.adj_type,
            NULL::character varying AS subc_id,
            concat(inp_adjustments.value_1, ' ', inp_adjustments.value_2, ' ', inp_adjustments.value_3, ' ', inp_adjustments.value_4, ' ', inp_adjustments.value_5, ' ', inp_adjustments.value_6, ' ', inp_adjustments.value_7, ' ', inp_adjustments.value_8, ' ', inp_adjustments.value_9, ' ', inp_adjustments.value_10, ' ', inp_adjustments.value_11, ' ', inp_adjustments.value_12) AS monthly_adj
           FROM inp_adjustments
        UNION
         SELECT 2,
            'N-PERV'::character varying AS parameter,
            inp_subcatchment.subc_id,
            inp_subcatchment.nperv_pattern_id AS montly_adjunstment
           FROM inp_subcatchment
          WHERE (inp_subcatchment.nperv_pattern_id IS NOT NULL)
        UNION
         SELECT 2,
            'DSTORE'::character varying,
            inp_subcatchment.subc_id,
            inp_subcatchment.dstore_pattern_id AS montly_adjunstment
           FROM inp_subcatchment
          WHERE (inp_subcatchment.dstore_pattern_id IS NOT NULL)
        UNION
         SELECT 2,
            'INFIL'::character varying,
            inp_subcatchment.subc_id,
            inp_subcatchment.infil_pattern_id AS montly_adjunstment
           FROM inp_subcatchment
          WHERE (inp_subcatchment.infil_pattern_id IS NOT NULL)) a;


--
-- Name: vi_aquifers; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_aquifers AS
 SELECT inp_aquifer.aquif_id,
    inp_aquifer.por,
    inp_aquifer.wp,
    inp_aquifer.fc,
    inp_aquifer.k,
    inp_aquifer.ks,
    inp_aquifer.ps,
    inp_aquifer.uef,
    inp_aquifer.led,
    inp_aquifer.gwr,
    inp_aquifer.be,
    inp_aquifer.wte,
    inp_aquifer.umc,
    inp_aquifer.pattern_id
   FROM inp_aquifer
  ORDER BY inp_aquifer.aquif_id;


--
-- Name: vi_backdrop; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_backdrop AS
 SELECT inp_backdrop.text
   FROM inp_backdrop;


--
-- Name: vi_buildup; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_buildup AS
 SELECT inp_buildup.landus_id,
    inp_buildup.poll_id,
    inp_typevalue.idval AS funcb_type,
    inp_buildup.c1,
    inp_buildup.c2,
    inp_buildup.c3,
    inp_buildup.perunit
   FROM (inp_buildup
     LEFT JOIN inp_typevalue ON (((inp_typevalue.id)::text = (inp_buildup.funcb_type)::text)))
  WHERE ((inp_typevalue.typevalue)::text = 'inp_value_buildup'::text);


--
-- Name: vi_conduits; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_conduits AS
 SELECT arc_id,
    t.node_1,
    t.node_2,
    t.length,
    t.n,
    t.elevmax1 AS z1,
    t.elevmax2 AS z2,
    (t.q0)::numeric(12,4) AS q0,
    (t.qmax)::numeric(12,4) AS qmax,
    concat(';', t.sector_id, ' ', t.arccat_id, ' ', t.age) AS other
   FROM (temp_arc t
     JOIN inp_conduit USING (arc_id))
UNION
 SELECT t.arc_id,
    t.node_1,
    t.node_2,
    t.length,
    t.n,
    t.elevmax1 AS z1,
    t.elevmax2 AS z2,
    (t.q0)::numeric(12,4) AS q0,
    (t.qmax)::numeric(12,4) AS qmax,
    concat(';', t.sector_id, ' ', t.arccat_id) AS other
   FROM (temp_arc t
     JOIN inp_conduit ON (((t.arcparent)::text = (inp_conduit.arc_id)::text)));


--
-- Name: vi_controls; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_controls AS
 SELECT c.text
   FROM ( SELECT inp_controls.id,
            inp_controls.text
           FROM selector_sector,
            inp_controls
          WHERE ((selector_sector.sector_id = inp_controls.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (inp_controls.active IS NOT FALSE))
        UNION
         SELECT d.id,
            d.text
           FROM selector_sector s,
            v_edit_inp_dscenario_controls d
          WHERE ((s.sector_id = d.sector_id) AND (s.cur_user = ("current_user"())::text) AND (d.active IS NOT FALSE))
  ORDER BY 1) c
  ORDER BY c.id;


--
-- Name: vi_coordinates; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_coordinates AS
 SELECT rpt_inp_node.node_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    rpt_inp_node.the_geom
   FROM rpt_inp_node,
    selector_inp_result a
  WHERE (((a.result_id)::text = (rpt_inp_node.result_id)::text) AND (a.cur_user = ("current_user"())::text));


--
-- Name: vi_coverages; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_coverages AS
 SELECT v_edit_inp_subcatchment.subc_id,
    inp_coverage.landus_id,
    inp_coverage.percent
   FROM ((inp_coverage
     JOIN v_edit_inp_subcatchment ON (((inp_coverage.subc_id)::text = (v_edit_inp_subcatchment.subc_id)::text)))
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM (( SELECT unnest((inp_subcatchment.outlet_id)::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) = '{'::text)) a
             JOIN v_node ON (((v_node.node_id)::text = a.node_array)))) b ON (((v_edit_inp_subcatchment.subc_id)::text = (b.subc_id)::text)));


--
-- Name: vi_curves; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_curves AS
 SELECT a.curve_id,
    a.curve_type,
    a.x_value,
    a.y_value
   FROM ( WITH qt AS (
                 SELECT inp_curve_value.id,
                    inp_curve_value.curve_id,
                        CASE
                            WHEN (inp_curve_value.id = ( SELECT min(sub.id) AS min
                               FROM inp_curve_value sub
                              WHERE ((sub.curve_id)::text = (inp_curve_value.curve_id)::text))) THEN inp_typevalue.idval
                            ELSE NULL::character varying
                        END AS curve_type,
                    inp_curve_value.x_value,
                    inp_curve_value.y_value,
                    c.expl_id
                   FROM ((inp_curve c
                     JOIN inp_curve_value ON (((c.id)::text = (inp_curve_value.curve_id)::text)))
                     LEFT JOIN inp_typevalue ON (((inp_typevalue.id)::text = (c.curve_type)::text)))
                  WHERE ((inp_typevalue.typevalue)::text = 'inp_value_curve'::text)
                )
         SELECT qt.id,
            qt.curve_id,
            qt.curve_type,
            qt.x_value,
            qt.y_value,
            qt.expl_id
           FROM (qt
             JOIN selector_expl s USING (expl_id))
          WHERE (s.cur_user = ("current_user"())::text)
        UNION
         SELECT qt.id,
            qt.curve_id,
            qt.curve_type,
            qt.x_value,
            qt.y_value,
            qt.expl_id
           FROM qt
          WHERE (qt.expl_id IS NULL)) a
  ORDER BY a.id;


--
-- Name: vi_dividers; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_dividers AS
 SELECT temp_node.node_id,
    temp_node.elev,
    ((temp_node.addparam)::json ->> 'arc_id'::text) AS arc_id,
    ((temp_node.addparam)::json ->> 'divider_type'::text) AS divider_type,
    ((temp_node.addparam)::json ->> 'qmin'::text) AS other1,
    temp_node.y0 AS other2,
    temp_node.ysur AS other3,
    temp_node.apond AS other4,
    NULL::double precision AS other5,
    NULL::double precision AS other6
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'DIVIDER'::text) AND (((temp_node.addparam)::json ->> 'divider_type'::text) = 'CUTOFF'::text))
UNION
 SELECT temp_node.node_id,
    temp_node.elev,
    ((temp_node.addparam)::json ->> 'arc_id'::text) AS arc_id,
    ((temp_node.addparam)::json ->> 'divider_type'::text) AS divider_type,
    (temp_node.y0)::text AS other1,
    temp_node.ysur AS other2,
    temp_node.apond AS other3,
    NULL::numeric AS other4,
    NULL::double precision AS other5,
    NULL::double precision AS other6
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'DIVIDER'::text) AND (((temp_node.addparam)::json ->> 'divider_type'::text) = 'OVERFLOW'::text))
UNION
 SELECT temp_node.node_id,
    temp_node.elev,
    ((temp_node.addparam)::json ->> 'arc_id'::text) AS arc_id,
    ((temp_node.addparam)::json ->> 'divider_type'::text) AS divider_type,
    ((temp_node.addparam)::json ->> 'curve_id'::text) AS other1,
    temp_node.y0 AS other2,
    temp_node.ysur AS other3,
    temp_node.apond AS other4,
    NULL::double precision AS other5,
    NULL::double precision AS other6
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'DIVIDER'::text) AND (((temp_node.addparam)::json ->> 'divider_type'::text) = 'TABULAR'::text))
UNION
 SELECT temp_node.node_id,
    temp_node.elev,
    ((temp_node.addparam)::json ->> 'arc_id'::text) AS arc_id,
    ((temp_node.addparam)::json ->> 'divider_type'::text) AS divider_type,
    ((temp_node.addparam)::json ->> 'qmin'::text) AS other1,
    (((temp_node.addparam)::json ->> 'ht'::text))::numeric AS other2,
    (((temp_node.addparam)::json ->> 'cd'::text))::numeric AS other3,
    temp_node.y0 AS other4,
    temp_node.ysur AS other5,
    temp_node.apond AS other6
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'DIVIDER'::text) AND (((temp_node.addparam)::json ->> 'divider_type'::text) = 'WEIR'::text));


--
-- Name: vi_dwf; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_dwf AS
 SELECT rpt_inp_node.node_id,
    'FLOW'::text AS type_dwf,
    inp_dwf.value,
    inp_dwf.pat1,
    inp_dwf.pat2,
    inp_dwf.pat3,
    inp_dwf.pat4
   FROM selector_inp_result,
    (rpt_inp_node
     JOIN inp_dwf ON (((inp_dwf.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_inp_node.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND (inp_dwf.dwfscenario_id = ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'inp_options_dwfscenario'::text) AND ((config_param_user.cur_user)::text = CURRENT_USER)))))
UNION
 SELECT rpt_inp_node.node_id,
    inp_dwf_pol_x_node.poll_id AS type_dwf,
    inp_dwf_pol_x_node.value,
    inp_dwf_pol_x_node.pat1,
    inp_dwf_pol_x_node.pat2,
    inp_dwf_pol_x_node.pat3,
    inp_dwf_pol_x_node.pat4
   FROM selector_inp_result,
    (rpt_inp_node
     JOIN inp_dwf_pol_x_node ON (((inp_dwf_pol_x_node.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_inp_node.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND (inp_dwf_pol_x_node.dwfscenario_id = ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'inp_options_dwfscenario'::text) AND ((config_param_user.cur_user)::text = CURRENT_USER)))));


--
-- Name: vi_evaporation; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_evaporation AS
 SELECT inp_evaporation.evap_type,
    inp_evaporation.value
   FROM inp_evaporation;


--
-- Name: vi_files; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_files AS
 SELECT inp_files.actio_type,
    inp_files.file_type,
    inp_files.fname
   FROM inp_files
  WHERE (inp_files.active IS TRUE);


--
-- Name: vi_groundwater; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_groundwater AS
 SELECT inp_groundwater.subc_id,
    inp_groundwater.aquif_id,
    inp_groundwater.node_id,
    inp_groundwater.surfel,
    inp_groundwater.a1,
    inp_groundwater.b1,
    inp_groundwater.a2,
    inp_groundwater.b2,
    inp_groundwater.a3,
    inp_groundwater.tw,
    inp_groundwater.h
   FROM ((v_edit_inp_subcatchment
     JOIN inp_groundwater ON (((inp_groundwater.subc_id)::text = (v_edit_inp_subcatchment.subc_id)::text)))
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM (( SELECT unnest((inp_subcatchment.outlet_id)::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) = '{'::text)) a
             JOIN v_node ON (((v_node.node_id)::text = a.node_array)))) b ON (((v_edit_inp_subcatchment.subc_id)::text = (b.subc_id)::text)));


--
-- Name: vi_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_gully AS
 SELECT temp_gully.gully_id,
    temp_gully.outlet_type,
    COALESCE((temp_gully.node_id)::text, '-9999'::text) AS node_id,
    (public.st_x(temp_gully.the_geom))::numeric(12,3) AS xcoord,
    (public.st_y(temp_gully.the_geom))::numeric(12,3) AS ycoord,
    COALESCE((temp_gully.top_elev)::numeric(12,3), ('-9999'::integer)::numeric) AS zcoord,
    (temp_gully.width)::numeric(12,3) AS width,
    (temp_gully.length)::numeric(12,3) AS length,
    COALESCE((temp_gully.depth)::numeric(12,3), ('-9999'::integer)::numeric) AS depth,
    temp_gully.method,
    (temp_gully.weir_cd)::numeric(12,3) AS weir_cd,
    (temp_gully.orifice_cd)::numeric(12,3) AS orifice_cd,
    (temp_gully.a_param)::numeric(12,3) AS a_param,
    (temp_gully.b_param)::numeric(12,3) AS b_param,
    temp_gully.efficiency
   FROM temp_gully;


--
-- Name: vi_gully2node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_gully2node AS
 SELECT a.gully_id,
    n.node_id,
    public.st_makeline(a.the_geom, n.the_geom) AS the_geom
   FROM (( SELECT g.gully_id,
                CASE
                    WHEN ((g.pjoint_type)::text = 'NODE'::text) THEN g.pjoint_id
                    ELSE a_1.node_2
                END AS node_id,
            a_1.expl_id,
            g.the_geom
           FROM (v_edit_inp_gully g
             LEFT JOIN arc a_1 USING (arc_id))) a
     JOIN node n USING (node_id));


--
-- Name: vi_gwf; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_gwf AS
 SELECT inp_groundwater.subc_id,
    (('LATERAL'::text || ' '::text) || (inp_groundwater.fl_eq_lat)::text) AS fl_eq_lat,
    (('DEEP'::text || ' '::text) || (inp_groundwater.fl_eq_lat)::text) AS fl_eq_deep
   FROM (v_edit_inp_subcatchment
     JOIN inp_groundwater ON (((inp_groundwater.subc_id)::text = (v_edit_inp_subcatchment.subc_id)::text)));


--
-- Name: vi_hydrographs; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_hydrographs AS
 SELECT inp_hydrograph_value.text
   FROM inp_hydrograph_value;


--
-- Name: vi_infiltration; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_infiltration AS
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::numeric AS other4,
    NULL::double precision AS other5
   FROM ((v_edit_inp_subcatchment
     JOIN cat_hydrology ON ((cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id)))
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest((inp_subcatchment.outlet_id)::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM (inp_subcatchment
                     JOIN temp_node ON (((inp_subcatchment.outlet_id)::text = (temp_node.node_id)::text)))
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) = '{'::text)
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) <> '{'::text)) a) b USING (outlet_id))
  WHERE ((cat_hydrology.infiltration)::text = 'CURVE_NUMBER'::text)
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.suction AS other1,
    v_edit_inp_subcatchment.conduct AS other2,
    v_edit_inp_subcatchment.initdef AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM ((v_edit_inp_subcatchment
     JOIN cat_hydrology ON ((cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id)))
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest((inp_subcatchment.outlet_id)::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM (inp_subcatchment
                     JOIN temp_node ON (((inp_subcatchment.outlet_id)::text = (temp_node.node_id)::text)))
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) = '{'::text)
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) <> '{'::text)) a) b USING (outlet_id))
  WHERE ((cat_hydrology.infiltration)::text = 'GREEN_AMPT'::text)
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM ((v_edit_inp_subcatchment
     JOIN cat_hydrology ON ((cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id)))
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest((inp_subcatchment.outlet_id)::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM (inp_subcatchment
                     JOIN temp_node ON (((inp_subcatchment.outlet_id)::text = (temp_node.node_id)::text)))
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) = '{'::text)
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) <> '{'::text)) a) b USING (outlet_id))
  WHERE ((cat_hydrology.infiltration)::text = ANY (ARRAY['MODIFIED_HORTON'::text, 'HORTON'::text]));


--
-- Name: vi_inflows; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_inflows AS
 SELECT temp_node_other.node_id,
    temp_node_other.type,
    temp_node_other.timser_id,
    'FLOW'::text AS format,
    (1)::numeric(12,4) AS mfactor,
    temp_node_other.sfactor,
    temp_node_other.base,
    temp_node_other.pattern_id
   FROM temp_node_other
  WHERE ((temp_node_other.type)::text = 'FLOW'::text)
UNION
 SELECT temp_node_other.node_id,
    temp_node_other.poll_id AS type,
    temp_node_other.timser_id,
    temp_node_other.other AS format,
    temp_node_other.mfactor,
    temp_node_other.sfactor,
    temp_node_other.base,
    temp_node_other.pattern_id
   FROM temp_node_other
  WHERE ((temp_node_other.type)::text = 'POLLUTANT'::text)
  ORDER BY 1;


--
-- Name: vi_junctions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_junctions AS
 SELECT temp_node.node_id,
    temp_node.elev,
    temp_node.ymax,
    temp_node.y0,
    temp_node.ysur,
    temp_node.apond,
    concat(';', temp_node.sector_id, ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE ((temp_node.epa_type)::text = ANY (ARRAY['JUNCTION'::text, 'NETGULLY'::text]));


--
-- Name: vi_labels; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_labels AS
 SELECT inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.anchor,
    inp_label.font,
    inp_label.size,
    inp_label.bold,
    inp_label.italic
   FROM inp_label
  ORDER BY inp_label.label;


--
-- Name: vi_landuses; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_landuses AS
 SELECT inp_landuses.landus_id,
    inp_landuses.sweepint,
    inp_landuses.availab,
    inp_landuses.lastsweep
   FROM inp_landuses;


--
-- Name: vi_lid_controls; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_lid_controls AS
 SELECT a.lidco_id,
    a.lidco_type,
    a.other1,
    a.other2,
    a.other3,
    a.other4,
    a.other5,
    a.other6,
    a.other7
   FROM ( SELECT 0 AS id,
            inp_lid.lidco_id,
            inp_lid.lidco_type,
            NULL::numeric AS other1,
            NULL::numeric AS other2,
            NULL::numeric AS other3,
            NULL::numeric AS other4,
            NULL::text AS other5,
            NULL::text AS other6,
            NULL::text AS other7
           FROM inp_lid
        UNION
         SELECT inp_lid_value.id,
            inp_lid_value.lidco_id,
            inp_typevalue.idval AS lidco_type,
            inp_lid_value.value_2 AS other1,
            inp_lid_value.value_3 AS other2,
            inp_lid_value.value_4 AS other3,
            inp_lid_value.value_5 AS other4,
            inp_lid_value.value_6 AS other5,
            inp_lid_value.value_7 AS other6,
            inp_lid_value.value_8 AS other7
           FROM (inp_lid_value
             LEFT JOIN inp_typevalue ON (((inp_typevalue.id)::text = (inp_lid_value.lidlayer)::text)))
          WHERE ((inp_typevalue.typevalue)::text = 'inp_value_lidlayer'::text)) a
  ORDER BY a.lidco_id, a.id;


--
-- Name: vi_lid_usage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_lid_usage AS
 SELECT temp_lid_usage.subc_id,
    temp_lid_usage.lidco_id,
    (temp_lid_usage.numelem)::integer AS numelem,
    temp_lid_usage.area,
    temp_lid_usage.width,
    temp_lid_usage.initsat,
    temp_lid_usage.fromimp,
    (temp_lid_usage.toperv)::integer AS toperv,
    temp_lid_usage.rptfile
   FROM (v_edit_inp_subcatchment
     JOIN temp_lid_usage ON (((temp_lid_usage.subc_id)::text = (v_edit_inp_subcatchment.subc_id)::text)));


--
-- Name: vi_loadings; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_loadings AS
 SELECT inp_loadings.subc_id,
    inp_loadings.poll_id,
    inp_loadings.ibuildup
   FROM (v_edit_inp_subcatchment
     JOIN inp_loadings ON (((inp_loadings.subc_id)::text = (v_edit_inp_subcatchment.subc_id)::text)));


--
-- Name: vi_losses; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_losses AS
 SELECT temp_arc.arc_id,
        CASE
            WHEN (temp_arc.kentry IS NOT NULL) THEN temp_arc.kentry
            ELSE (0)::numeric
        END AS kentry,
        CASE
            WHEN (temp_arc.kexit IS NOT NULL) THEN temp_arc.kexit
            ELSE (0)::numeric
        END AS kexit,
        CASE
            WHEN (temp_arc.kavg IS NOT NULL) THEN temp_arc.kavg
            ELSE (0)::numeric
        END AS kavg,
        CASE
            WHEN (temp_arc.flap IS NOT NULL) THEN temp_arc.flap
            ELSE 'NO'::character varying
        END AS flap,
    temp_arc.seepage
   FROM temp_arc
  WHERE ((temp_arc.kentry > (0)::numeric) OR (temp_arc.kexit > (0)::numeric) OR (temp_arc.kavg > (0)::numeric) OR ((temp_arc.flap)::text = 'YES'::text) OR (temp_arc.seepage IS NOT NULL));


--
-- Name: vi_map; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_map AS
 SELECT inp_mapdim.type_dim,
    concat(inp_mapdim.x1, ' ', inp_mapdim.y1, ' ', inp_mapdim.x2, ' ', inp_mapdim.y2) AS other_val
   FROM inp_mapdim
UNION
 SELECT inp_typevalue.idval AS type_dim,
    inp_mapunits.map_type AS other_val
   FROM (inp_mapunits
     LEFT JOIN inp_typevalue ON (((inp_typevalue.id)::text = (inp_mapunits.type_units)::text)))
  WHERE ((inp_typevalue.typevalue)::text = 'inp_value_mapunits'::text);


--
-- Name: vi_options; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_options AS
 SELECT a.parameter,
    a.value
   FROM ( SELECT a_1.idval AS parameter,
            b.value,
                CASE
                    WHEN (a_1.layoutname ~~ '%general_1%'::text) THEN '1'::text
                    WHEN (a_1.layoutname ~~ '%hydraulics_1%'::text) THEN '2'::text
                    WHEN (a_1.layoutname ~~ '%hydraulics_2%'::text) THEN '3'::text
                    WHEN (a_1.layoutname ~~ '%date_1%'::text) THEN '3'::text
                    WHEN (a_1.layoutname ~~ '%date_2%'::text) THEN '4'::text
                    WHEN (a_1.layoutname ~~ '%general_2%'::text) THEN '5'::text
                    ELSE NULL::text
                END AS layoutname,
            a_1.layoutorder
           FROM (sys_param_user a_1
             JOIN config_param_user b ON ((a_1.id = (b.parameter)::text)))
          WHERE ((a_1.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text, 'lyt_date_1'::text, 'lyt_date_2'::text])) AND ((b.cur_user)::name = "current_user"()) AND (b.value IS NOT NULL) AND (a_1.idval IS NOT NULL))
        UNION
         SELECT 'INFILTRATION'::text AS parameter,
            cat_hydrology.infiltration AS value,
            '1'::text AS text,
            2
           FROM config_param_user,
            cat_hydrology
          WHERE (((config_param_user.parameter)::text = 'inp_options_hydrology_scenario'::text) AND ((config_param_user.cur_user)::text = ("current_user"())::text))) a
  ORDER BY a.layoutname, a.layoutorder;


--
-- Name: vi_orifices; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_orifices AS
 SELECT arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
    f.ori_type,
    f.offsetval,
    f.cd,
    f.flap,
    f.orate,
    f.close_time
   FROM (temp_arc_flowregulator f
     JOIN temp_arc USING (arc_id))
  WHERE ((f.type)::text = 'ORIFICE'::text);


--
-- Name: vi_outfalls; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_outfalls AS
 SELECT temp_node.node_id,
    temp_node.elev,
    ((temp_node.addparam)::json ->> 'outfall_type'::text) AS outfall_type,
    ((temp_node.addparam)::json ->> 'gate'::text) AS other1,
    NULL::text AS other2
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'OUTFALL'::text) AND (((temp_node.addparam)::json ->> 'outfall_type'::text) = ANY (ARRAY['FREE'::text, 'NORMAL'::text])))
UNION
 SELECT temp_node.node_id,
    temp_node.elev,
    ((temp_node.addparam)::json ->> 'outfall_type'::text) AS outfall_type,
    ((temp_node.addparam)::json ->> 'state'::text) AS other1,
    ((temp_node.addparam)::json ->> 'gate'::text) AS other2
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'OUTFALL'::text) AND (((temp_node.addparam)::json ->> 'outfall_type'::text) = 'FIXED'::text))
UNION
 SELECT temp_node.node_id,
    temp_node.elev,
    ((temp_node.addparam)::json ->> 'outfall_type'::text) AS outfall_type,
    ((temp_node.addparam)::json ->> 'curve_id'::text) AS other1,
    ((temp_node.addparam)::json ->> 'gate'::text) AS other2
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'OUTFALL'::text) AND (((temp_node.addparam)::json ->> 'outfall_type'::text) = 'TIDAL'::text))
UNION
 SELECT temp_node.node_id,
    temp_node.elev,
    ((temp_node.addparam)::json ->> 'outfall_type'::text) AS outfall_type,
    ((temp_node.addparam)::json ->> 'timser_id'::text) AS other1,
    ((temp_node.addparam)::json ->> 'gate'::text) AS other2
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'OUTFALL'::text) AND (((temp_node.addparam)::json ->> 'outfall_type'::text) = 'TIMESERIES'::text));


--
-- Name: vi_outlets; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_outlets AS
 SELECT arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
        CASE
            WHEN (f.offsetval IS NULL) THEN '*'::text
            ELSE (f.offsetval)::text
        END AS offsetval,
    f.outlet_type,
        CASE
            WHEN (f.curve_id IS NULL) THEN ((f.cd1)::text)::character varying
            ELSE f.curve_id
        END AS other1,
    (f.cd2)::text AS other2,
    (f.flap)::character varying AS other3
   FROM (temp_arc_flowregulator f
     JOIN temp_arc USING (arc_id))
  WHERE ((f.type)::text = 'OUTLET'::text);


--
-- Name: vi_parent_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.nodetype_1,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.sys_y1,
    v_arc.r1,
    v_arc.z1,
    v_arc.node_2,
    v_arc.nodetype_2,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.sys_y2,
    v_arc.r2,
    v_arc.z2,
    v_arc.slope,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.cat_shape,
    v_arc.cat_geom1,
    v_arc.cat_geom2,
    v_arc.width,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.inverted_slope,
    v_arc.observ,
    v_arc.comment,
    v_arc.dma_id,
    v_arc.macrodma_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.buildercat_id,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.district_id,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.undelete,
    v_arc.label,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.num_value,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom
   FROM v_arc,
    selector_sector
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: vi_patterns; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_patterns AS
 SELECT p.pattern_id,
    p.pattern_type,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18,
    inp_pattern_value.factor_19,
    inp_pattern_value.factor_20,
    inp_pattern_value.factor_21,
    inp_pattern_value.factor_22,
    inp_pattern_value.factor_23,
    inp_pattern_value.factor_24
   FROM selector_expl s,
    (inp_pattern p
     JOIN inp_pattern_value USING (pattern_id))
  WHERE (((p.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (p.expl_id IS NULL))
  ORDER BY p.pattern_id;


--
-- Name: vi_pollutants; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pollutants AS
 SELECT inp_pollutant.poll_id,
    inp_pollutant.units_type,
    inp_pollutant.crain,
    inp_pollutant.cgw,
    inp_pollutant.cii,
    inp_pollutant.kd,
    inp_pollutant.sflag,
    inp_pollutant.copoll_id,
    inp_pollutant.cofract,
    inp_pollutant.cdwf,
    inp_pollutant.cinit
   FROM inp_pollutant
  ORDER BY inp_pollutant.poll_id;


--
-- Name: vi_polygons; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_polygons AS
 SELECT temp_table.text_column
   FROM temp_table
  WHERE (temp_table.fid = 117);


--
-- Name: vi_pumps; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pumps AS
 SELECT arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
    temp_arc_flowregulator.curve_id,
    temp_arc_flowregulator.status,
    temp_arc_flowregulator.startup,
    temp_arc_flowregulator.shutoff
   FROM (temp_arc_flowregulator
     JOIN temp_arc USING (arc_id))
  WHERE ((temp_arc_flowregulator.type)::text = 'PUMP'::text);


--
-- Name: vi_raingages; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_raingages AS
 SELECT r.rg_id,
    r.form_type,
    r.intvl,
    r.scf,
    inp_typevalue.idval AS raingage_type,
    r.timser_id AS other1,
    NULL::character varying AS other2,
    NULL::character varying AS other3
   FROM selector_inp_result s,
    (rpt_inp_raingage r
     LEFT JOIN inp_typevalue ON (((inp_typevalue.id)::text = (r.rgage_type)::text)))
  WHERE (((inp_typevalue.typevalue)::text = 'inp_typevalue_raingage'::text) AND ((r.rgage_type)::text = 'TIMESERIES'::text) AND ((s.result_id)::text = (r.result_id)::text) AND (s.cur_user = CURRENT_USER))
UNION
 SELECT r.rg_id,
    r.form_type,
    r.intvl,
    r.scf,
    inp_typevalue.idval AS raingage_type,
    r.fname AS other1,
    r.sta AS other2,
    r.units AS other3
   FROM selector_inp_result s,
    (rpt_inp_raingage r
     LEFT JOIN inp_typevalue ON (((inp_typevalue.id)::text = (r.rgage_type)::text)))
  WHERE (((inp_typevalue.typevalue)::text = 'inp_typevalue_raingage'::text) AND ((r.rgage_type)::text = 'FILE'::text) AND ((s.result_id)::text = (r.result_id)::text) AND (s.cur_user = CURRENT_USER));


--
-- Name: vi_rdii; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_rdii AS
 SELECT rpt_inp_node.node_id,
    inp_rdii.hydro_id,
    inp_rdii.sewerarea
   FROM selector_inp_result,
    (rpt_inp_node
     JOIN inp_rdii ON (((inp_rdii.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_inp_node.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text));


--
-- Name: vi_report; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_report AS
 SELECT a.idval AS parameter,
    b.value
   FROM (sys_param_user a
     JOIN config_param_user b ON ((a.id = (b.parameter)::text)))
  WHERE ((a.layoutname = ANY (ARRAY['lyt_reports_1'::text, 'lyt_reports_2'::text])) AND ((b.cur_user)::name = "current_user"()) AND (b.value IS NOT NULL));


--
-- Name: vi_snowpacks; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_snowpacks AS
 SELECT inp_snowpack_value.snow_id,
    inp_snowpack_value.snow_type,
    inp_snowpack_value.value_1,
    inp_snowpack_value.value_2,
    inp_snowpack_value.value_3,
    inp_snowpack_value.value_4,
    inp_snowpack_value.value_5,
    inp_snowpack_value.value_6,
    inp_snowpack_value.value_7
   FROM inp_snowpack_value
  ORDER BY inp_snowpack_value.id;


--
-- Name: vi_storage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_storage AS
 SELECT temp_node.node_id,
    temp_node.elev,
    temp_node.ymax,
    temp_node.y0,
    ((temp_node.addparam)::json ->> 'storage_type'::text) AS storage_type,
    ((temp_node.addparam)::json ->> 'a1'::text) AS other1,
    ((temp_node.addparam)::json ->> 'a2'::text) AS other2,
    ((temp_node.addparam)::json ->> 'a0'::text) AS other3,
    (temp_node.apond)::text AS other4,
    ((temp_node.addparam)::json ->> 'fevap'::text) AS other5,
    ((temp_node.addparam)::json ->> 'sh'::text) AS other6,
    ((temp_node.addparam)::json ->> 'hc'::text) AS other7,
    ((temp_node.addparam)::json ->> 'imd'::text) AS other8
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'STORAGE'::text) AND (((temp_node.addparam)::json ->> 'storage_type'::text) = 'FUNCTIONAL'::text))
UNION
 SELECT temp_node.node_id,
    temp_node.elev,
    temp_node.ymax,
    temp_node.y0,
    ((temp_node.addparam)::json ->> 'storage_type'::text) AS storage_type,
    ((temp_node.addparam)::json ->> 'curve_id'::text) AS other1,
    (temp_node.apond)::text AS other2,
    ((temp_node.addparam)::json ->> 'fevap'::text) AS other3,
    ((temp_node.addparam)::json ->> 'sh'::text) AS other4,
    ((temp_node.addparam)::json ->> 'hc'::text) AS other5,
    ((temp_node.addparam)::json ->> 'imd'::text) AS other6,
    NULL::text AS other7,
    NULL::text AS other8
   FROM temp_node
  WHERE (((temp_node.epa_type)::text = 'STORAGE'::text) AND (((temp_node.addparam)::json ->> 'storage_type'::text) = 'TABULAR'::text));


--
-- Name: vi_subareas; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_subareas AS
 SELECT DISTINCT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.nimp,
    v_edit_inp_subcatchment.nperv,
    v_edit_inp_subcatchment.simp,
    v_edit_inp_subcatchment.sperv,
    v_edit_inp_subcatchment.zero,
    v_edit_inp_subcatchment.routeto,
    v_edit_inp_subcatchment.rted
   FROM (v_edit_inp_subcatchment
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest((inp_subcatchment.outlet_id)::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM (inp_subcatchment
                     JOIN temp_node ON (((inp_subcatchment.outlet_id)::text = (temp_node.node_id)::text)))
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) = '{'::text)
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) <> '{'::text)) a) b USING (outlet_id));


--
-- Name: vi_subcatch2outlet; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_subcatch2outlet AS
 SELECT s1.subc_id,
    s1.hydrology_id,
    (public.st_makeline(public.st_centroid(s1.the_geom), v_node.the_geom))::public.geometry(LineString,SRID_VALUE) AS the_geom
   FROM (v_edit_inp_subcatchment s1
     JOIN v_node ON (((v_node.node_id)::text = (s1.outlet_id)::text)))
UNION
 SELECT s1.subc_id,
    s1.hydrology_id,
    (public.st_makeline(public.st_centroid(s1.the_geom), public.st_centroid(s2.the_geom)))::public.geometry(LineString,SRID_VALUE) AS the_geom
   FROM (v_edit_inp_subcatchment s1
     JOIN v_edit_inp_subcatchment s2 ON (((s1.outlet_id)::text = (s2.subc_id)::text)));


--
-- Name: vi_subcatchcentroid; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_subcatchcentroid AS
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.hydrology_id,
    public.st_centroid(v_edit_inp_subcatchment.the_geom) AS the_geom
   FROM v_edit_inp_subcatchment;


--
-- Name: vi_subcatchments; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_subcatchments AS
 SELECT DISTINCT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.rg_id,
    b.outlet_id,
    v_edit_inp_subcatchment.area,
    v_edit_inp_subcatchment.imperv,
    v_edit_inp_subcatchment.width,
    v_edit_inp_subcatchment.slope,
    v_edit_inp_subcatchment.clength,
    v_edit_inp_subcatchment.snow_id
   FROM (v_edit_inp_subcatchment
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest((inp_subcatchment.outlet_id)::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM (inp_subcatchment
                     JOIN temp_node ON (((inp_subcatchment.outlet_id)::text = (temp_node.node_id)::text)))
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) = '{'::text)
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE ("left"((inp_subcatchment.outlet_id)::text, 1) <> '{'::text)) a) b USING (outlet_id));


--
-- Name: vi_symbols; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_symbols AS
 SELECT v_edit_raingage.rg_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    v_edit_raingage.the_geom
   FROM v_edit_raingage;


--
-- Name: vi_temperature; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_temperature AS
 SELECT inp_temperature.temp_type,
    inp_temperature.value
   FROM inp_temperature;


--
-- Name: vi_timeseries; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_timeseries AS
 SELECT DISTINCT t.timser_id,
    t.other1,
    t.other2,
    t.other3
   FROM selector_expl s,
    ( SELECT a.timser_id,
            a.other1,
            a.other2,
            a.other3,
            a.expl_id
           FROM ( SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    inp_timeseries_value.date AS other1,
                    inp_timeseries_value.hour AS other2,
                    inp_timeseries_value.value AS other3,
                    inp_timeseries.expl_id
                   FROM (inp_timeseries_value
                     JOIN inp_timeseries ON (((inp_timeseries_value.timser_id)::text = (inp_timeseries.id)::text)))
                  WHERE ((inp_timeseries.times_type)::text = 'ABSOLUTE'::text)
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    concat('FILE', ' ', inp_timeseries.fname) AS other1,
                    NULL::character varying AS other2,
                    NULL::numeric AS other3,
                    inp_timeseries.expl_id
                   FROM (inp_timeseries_value
                     JOIN inp_timeseries ON (((inp_timeseries_value.timser_id)::text = (inp_timeseries.id)::text)))
                  WHERE ((inp_timeseries.times_type)::text = 'FILE'::text)
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    NULL::text AS other1,
                    inp_timeseries_value."time" AS other2,
                    (inp_timeseries_value.value)::numeric AS other3,
                    inp_timeseries.expl_id
                   FROM (inp_timeseries_value
                     JOIN inp_timeseries ON (((inp_timeseries_value.timser_id)::text = (inp_timeseries.id)::text)))
                  WHERE ((inp_timeseries.times_type)::text = 'RELATIVE'::text)) a
          ORDER BY a.id) t
  WHERE (((t.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (t.expl_id IS NULL))
  ORDER BY t.timser_id, t.other1, t.other2;


--
-- Name: vi_transects; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_transects AS
 SELECT inp_transects_value.text
   FROM inp_transects_value
  ORDER BY inp_transects_value.id;


--
-- Name: vi_treatment; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_treatment AS
 SELECT temp_node_other.node_id,
    temp_node_other.poll_id,
    temp_node_other.other AS function
   FROM temp_node_other
  WHERE ((temp_node_other.type)::text = 'TREATMENT'::text);


--
-- Name: vi_vertices; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_vertices AS
 SELECT DISTINCT ON (arc.path, arc.point) arc.arc_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    arc.point AS the_geom
   FROM ( SELECT (public.st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
            (public.st_dumppoints(rpt_inp_arc.the_geom)).path AS path,
            public.st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            public.st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.arc_id
           FROM selector_inp_result,
            rpt_inp_arc
          WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text))) arc
  WHERE (((arc.point OPERATOR(public.<) arc.startpoint) OR (arc.point OPERATOR(public.>) arc.startpoint)) AND ((arc.point OPERATOR(public.<) arc.endpoint) OR (arc.point OPERATOR(public.>) arc.endpoint)))
  ORDER BY arc.path;


--
-- Name: vi_washoff; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_washoff AS
 SELECT inp_washoff.landus_id,
    inp_washoff.poll_id,
    inp_typevalue.idval AS funcw_type,
    inp_washoff.c1,
    inp_washoff.c2,
    inp_washoff.sweepeffic,
    inp_washoff.bmpeffic
   FROM (inp_washoff
     LEFT JOIN inp_typevalue ON (((inp_typevalue.id)::text = (inp_washoff.funcw_type)::text)))
  WHERE ((inp_typevalue.typevalue)::text = 'inp_value_washoff'::text);


--
-- Name: vi_weirs; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_weirs AS
 SELECT arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
    f.weir_type,
    f.offsetval,
    f.cd,
    f.flap,
    f.ec,
    f.cd2,
    f.surcharge,
    f.road_width,
    f.road_surf,
    f.coef_curve
   FROM (temp_arc_flowregulator f
     JOIN temp_arc USING (arc_id))
  WHERE ((f.type)::text = 'WEIR'::text);


--
-- Name: vi_xsections; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_xsections AS
 SELECT temp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    (cat_arc.geom1)::text AS other1,
    cat_arc.curve_id AS other2,
    (0)::text AS other3,
    (0)::text AS other4,
    temp_arc.barrels AS other5,
    NULL::text AS other6
   FROM ((temp_arc
     JOIN cat_arc ON (((temp_arc.arccat_id)::text = (cat_arc.id)::text)))
     JOIN cat_arc_shape ON (((cat_arc_shape.id)::text = (cat_arc.shape)::text)))
  WHERE ((cat_arc_shape.epa)::text = 'CUSTOM'::text)
UNION
 SELECT temp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    (cat_arc.geom1)::text AS other1,
    (cat_arc.geom2)::text AS other2,
    (cat_arc.geom3)::text AS other3,
    (cat_arc.geom4)::text AS other4,
    temp_arc.barrels AS other5,
    (temp_arc.culvert)::text AS other6
   FROM ((temp_arc
     JOIN cat_arc ON (((temp_arc.arccat_id)::text = (cat_arc.id)::text)))
     JOIN cat_arc_shape ON (((cat_arc_shape.id)::text = (cat_arc.shape)::text)))
  WHERE ((cat_arc_shape.epa)::text <> ALL (ARRAY['CUSTOM'::text, 'IRREGULAR'::text]))
UNION
 SELECT temp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.tsect_id AS other1,
    (0)::character varying AS other2,
    (0)::text AS other3,
    (0)::text AS other4,
    temp_arc.barrels AS other5,
    NULL::text AS other6
   FROM ((temp_arc
     JOIN cat_arc ON (((temp_arc.arccat_id)::text = (cat_arc.id)::text)))
     JOIN cat_arc_shape ON (((cat_arc_shape.id)::text = (cat_arc.shape)::text)))
  WHERE ((cat_arc_shape.epa)::text = 'IRREGULAR'::text)
UNION
 SELECT temp_arc_flowregulator.arc_id,
    temp_arc_flowregulator.shape,
    (temp_arc_flowregulator.geom1)::text AS other1,
    (temp_arc_flowregulator.geom2)::text AS other2,
    (temp_arc_flowregulator.geom3)::text AS other3,
    (temp_arc_flowregulator.geom4)::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM temp_arc_flowregulator
  WHERE ((temp_arc_flowregulator.type)::text = ANY ((ARRAY['ORIFICE'::character varying, 'WEIR'::character varying])::text[]));


--
-- Name: vp_basic_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_arc AS
 SELECT arc.arc_id AS nid,
    arc.arc_type AS custom_type
   FROM arc;


--
-- Name: vp_basic_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_connec AS
 SELECT connec.connec_id AS nid,
    connec.connec_type AS custom_type
   FROM connec;


--
-- Name: vp_basic_gully; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_gully AS
 SELECT gully.gully_id AS nid,
    gully.gully_type AS custom_type
   FROM gully;


--
-- Name: vp_basic_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_node AS
 SELECT node.node_id AS nid,
    node.node_type AS custom_type
   FROM node;


--
-- Name: v_price_compost _RETURN; Type: RULE; Schema: Schema; Owner: -
--

CREATE OR REPLACE VIEW v_price_compost AS
 SELECT plan_price.id,
    plan_price.unit,
    plan_price.descript,
        CASE
            WHEN (plan_price.price IS NOT NULL) THEN (plan_price.price)::numeric(14,2)
            ELSE (sum((plan_price.price * plan_price_compost.value)))::numeric(14,2)
        END AS price
   FROM (plan_price
     LEFT JOIN plan_price_compost ON (((plan_price.id)::text = (plan_price_compost.compost_id)::text)))
  GROUP BY plan_price.id, plan_price.unit, plan_price.descript;


--
-- Name: v_rpt_node_all _RETURN; Type: RULE; Schema: Schema; Owner: -
--

CREATE OR REPLACE VIEW v_rpt_node_all AS
 SELECT rpt_node.id,
    node.node_id,
    selector_rpt_main.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_main.result_id)::text))
  GROUP BY rpt_node.id, node.node_id, node.node_type, node.nodecat_id, selector_rpt_main.result_id, node.the_geom
  ORDER BY node.node_id;


--
-- Name: v_rpt_node_compare_all _RETURN; Type: RULE; Schema: Schema; Owner: -
--

CREATE OR REPLACE VIEW v_rpt_node_compare_all AS
 SELECT rpt_node.id,
    node.node_id,
    selector_rpt_compare.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_compare.result_id)::text))
  GROUP BY rpt_node.id, node.node_id, node.node_type, node.nodecat_id, selector_rpt_compare.result_id, node.the_geom
  ORDER BY node.node_id;


--
-- Name: dma dma_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dma_conflict AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = '-1'::integer) OR (old.dma_id = '-1'::integer)) DO INSTEAD NOTHING;


--
-- Name: dma dma_del_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dma_del_conflict AS
    ON DELETE TO dma
   WHERE (old.dma_id = '-1'::integer) DO INSTEAD NOTHING;


--
-- Name: dma dma_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dma_del_undefined AS
    ON DELETE TO dma
   WHERE (old.dma_id = 0) DO INSTEAD NOTHING;


--
-- Name: dma dma_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dma_undefined AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = 0) OR (old.dma_id = 0)) DO INSTEAD NOTHING;


--
-- Name: exploitation exploitation_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE exploitation_del_undefined AS
    ON DELETE TO exploitation
   WHERE (old.expl_id = 0) DO INSTEAD NOTHING;


--
-- Name: exploitation exploitation_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE exploitation_undefined AS
    ON UPDATE TO exploitation
   WHERE ((new.expl_id = 0) OR (old.expl_id = 0)) DO INSTEAD NOTHING;


--
-- Name: arc insert_plan_psector_x_arc; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE insert_plan_psector_x_arc AS
    ON INSERT TO arc
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable)
  VALUES (new.arc_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_vdefault'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);


--
-- Name: node insert_plan_psector_x_node; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE insert_plan_psector_x_node AS
    ON INSERT TO node
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable)
  VALUES (new.node_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_vdefault'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);


--
-- Name: macrodma macrodma_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macrodma_del_undefined AS
    ON DELETE TO macrodma
   WHERE (old.macrodma_id = 0) DO INSTEAD NOTHING;


--
-- Name: macrodma macrodma_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macrodma_undefined AS
    ON UPDATE TO macrodma
   WHERE ((new.macrodma_id = 0) OR (old.macrodma_id = 0)) DO INSTEAD NOTHING;


--
-- Name: macroexploitation macroexploitation_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macroexploitation_del_undefined AS
    ON DELETE TO macroexploitation
   WHERE (old.macroexpl_id = 0) DO INSTEAD NOTHING;


--
-- Name: macroexploitation macroexploitation_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macroexploitation_undefined AS
    ON UPDATE TO macroexploitation
   WHERE ((new.macroexpl_id = 0) OR (old.macroexpl_id = 0)) DO INSTEAD NOTHING;


--
-- Name: macrosector macrosector_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macrosector_del_undefined AS
    ON DELETE TO macrosector
   WHERE (old.macrosector_id = 0) DO INSTEAD NOTHING;


--
-- Name: macrosector macrosector_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macrosector_undefined AS
    ON UPDATE TO macrosector
   WHERE ((new.macrosector_id = 0) OR (old.macrosector_id = 0)) DO INSTEAD NOTHING;


--
-- Name: sector sector_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE sector_conflict AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = '-1'::integer) OR (old.sector_id = '-1'::integer)) DO INSTEAD NOTHING;


--
-- Name: sector sector_del_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE sector_del_conflict AS
    ON DELETE TO sector
   WHERE (old.sector_id = '-1'::integer) DO INSTEAD NOTHING;


--
-- Name: sector sector_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE sector_del_undefined AS
    ON DELETE TO sector
   WHERE (old.sector_id = 0) DO INSTEAD NOTHING;


--
-- Name: sector sector_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE sector_undefined AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = 0) OR (old.sector_id = 0)) DO INSTEAD NOTHING;


--
-- Name: arc undelete_arc; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_arc AS
    ON DELETE TO arc
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: connec undelete_connec; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_connec AS
    ON DELETE TO connec
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: exploitation undelete_dma; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_dma AS
    ON DELETE TO exploitation
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: dma undelete_dma; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_dma AS
    ON DELETE TO dma
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: gully undelete_gully; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_gully AS
    ON DELETE TO gully
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: macrosector undelete_macrosector; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_macrosector AS
    ON DELETE TO macrosector
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: node undelete_node; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_node AS
    ON DELETE TO node
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: sector undelete_sector; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_sector AS
    ON DELETE TO sector
   WHERE (old.undelete = true) DO INSTEAD NOTHING;
