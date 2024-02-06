/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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
-- Name: v_expl_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_expl_arc AS
 SELECT DISTINCT arc.arc_id
   FROM selector_expl,
    arc
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND ((arc.expl_id = selector_expl.expl_id) OR (arc.expl_id2 = selector_expl.expl_id)));


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
    arc.node_2,
    arc.elevation1,
    arc.depth1,
    arc.elevation2,
    arc.depth2,
    arc.arccat_id,
    cat_arc.arctype_id AS arc_type,
    cat_feature.system_id AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    arc.epa_type,
    arc.expl_id,
    exploitation.macroexpl_id,
    arc.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.observ,
    arc.comment,
    (public.st_length2d(arc.the_geom))::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.minsector_id,
    arc.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    arc.presszone_id,
    presszone.name AS presszone_name,
    arc.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.buildercat_id,
    arc.builtdate,
    arc.enddate,
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
    arc.num_value,
    cat_arc.arctype_id AS cat_arctype_id,
    arc.nodetype_1,
    arc.staticpress1,
    arc.nodetype_2,
    arc.staticpress2,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.depth,
    arc.adate,
    arc.adescript,
    (dma.stylesheet ->> 'featureColor'::text) AS dma_style,
    (presszone.stylesheet ->> 'featureColor'::text) AS presszone_style,
    arc.workcat_id_plan,
    arc.asset_id,
    arc.pavcat_id,
    arc.om_state,
    arc.conserv_state,
    e.flow_max,
    e.flow_min,
    e.flow_avg,
    e.vel_max,
    e.vel_min,
    e.vel_avg,
    arc.parent_id,
    arc.expl_id2
   FROM ((((((((((arc
     LEFT JOIN sector ON ((arc.sector_id = sector.sector_id)))
     LEFT JOIN exploitation ON ((arc.expl_id = exploitation.expl_id)))
     LEFT JOIN cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_arc.arctype_id)::text)))
     LEFT JOIN dma ON ((arc.dma_id = dma.dma_id)))
     LEFT JOIN dqa ON ((arc.dqa_id = dqa.dqa_id)))
     LEFT JOIN presszone ON (((presszone.presszone_id)::text = (arc.presszone_id)::text)))
     LEFT JOIN v_ext_streetaxis c ON (((c.id)::text = (arc.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis d ON (((d.id)::text = (arc.streetaxis2_id)::text)))
     LEFT JOIN arc_add e ON (((arc.arc_id)::text = (e.arc_id)::text)));


--
-- Name: v_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_arc AS
 SELECT vu_arc.arc_id,
    vu_arc.code,
    vu_arc.node_1,
    vu_arc.node_2,
    vu_arc.elevation1,
    vu_arc.depth1,
    vu_arc.elevation2,
    vu_arc.depth2,
    vu_arc.arccat_id,
    vu_arc.arc_type,
    vu_arc.sys_type,
    vu_arc.cat_matcat_id,
    vu_arc.cat_pnom,
    vu_arc.cat_dnom,
    vu_arc.epa_type,
    vu_arc.expl_id,
    vu_arc.macroexpl_id,
    vu_arc.sector_id,
    vu_arc.sector_name,
    vu_arc.macrosector_id,
    vu_arc.state,
    vu_arc.state_type,
    vu_arc.annotation,
    vu_arc.observ,
    vu_arc.comment,
    vu_arc.gis_length,
    vu_arc.custom_length,
    vu_arc.minsector_id,
    vu_arc.dma_id,
    vu_arc.dma_name,
    vu_arc.macrodma_id,
    vu_arc.presszone_id,
    vu_arc.presszone_name,
    vu_arc.dqa_id,
    vu_arc.dqa_name,
    vu_arc.macrodqa_id,
    vu_arc.soilcat_id,
    vu_arc.function_type,
    vu_arc.category_type,
    vu_arc.fluid_type,
    vu_arc.location_type,
    vu_arc.workcat_id,
    vu_arc.workcat_id_end,
    vu_arc.buildercat_id,
    vu_arc.builtdate,
    vu_arc.enddate,
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
    vu_arc.num_value,
    vu_arc.cat_arctype_id,
    vu_arc.nodetype_1,
    vu_arc.staticpress1,
    vu_arc.nodetype_2,
    vu_arc.staticpress2,
    vu_arc.tstamp,
    vu_arc.insert_user,
    vu_arc.lastupdate,
    vu_arc.lastupdate_user,
    vu_arc.the_geom,
    vu_arc.depth,
    vu_arc.adate,
    vu_arc.adescript,
    vu_arc.dma_style,
    vu_arc.presszone_style,
    vu_arc.workcat_id_plan,
    vu_arc.asset_id,
    vu_arc.pavcat_id,
    vu_arc.om_state,
    vu_arc.conserv_state,
    vu_arc.flow_max,
    vu_arc.flow_min,
    vu_arc.flow_avg,
    vu_arc.vel_max,
    vu_arc.vel_min,
    vu_arc.vel_avg,
    vu_arc.parent_id,
    vu_arc.expl_id2
   FROM ((vu_arc
     JOIN v_state_arc USING (arc_id))
     JOIN v_expl_arc e ON (((e.arc_id)::text = (vu_arc.arc_id)::text)));


--
-- Name: v_audit_check_project; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_audit_check_project AS
 SELECT audit_check_project.id,
    audit_check_project.table_id,
    audit_check_project.table_host,
    audit_check_project.table_dbname,
    audit_check_project.table_schema,
    audit_check_project.fid AS fprocesscat_id,
    audit_check_project.criticity,
    audit_check_project.enabled,
    audit_check_project.message,
    audit_check_project.tstamp,
    audit_check_project.cur_user AS user_name,
    audit_check_project.observ
   FROM audit_check_project
  ORDER BY audit_check_project.table_id, audit_check_project.id;


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
    (presszone_id)::character varying(16) AS presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    (public.st_length2d(l.the_geom))::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    d.name AS dma_name,
    q.name AS dqa_name,
    p.name AS presszone_name,
    s.macrosector_id,
    d.macrodma_id,
    q.macrodqa_id,
    l.expl_id2
   FROM ((((link l
     LEFT JOIN sector s USING (sector_id))
     LEFT JOIN presszone p USING (presszone_id))
     LEFT JOIN dma d USING (dma_id))
     LEFT JOIN dqa q USING (dqa_id));


--
-- Name: v_link_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_link_connec AS
 SELECT DISTINCT ON (vu_link.link_id) vu_link.link_id,
    vu_link.feature_type,
    vu_link.feature_id,
    vu_link.exit_type,
    vu_link.exit_id,
    vu_link.state,
    vu_link.expl_id,
    vu_link.sector_id,
    vu_link.dma_id,
    vu_link.presszone_id,
    vu_link.dqa_id,
    vu_link.minsector_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.dma_name,
    vu_link.dqa_name,
    vu_link.presszone_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.macrodqa_id,
    vu_link.expl_id2
   FROM (vu_link
     JOIN v_state_link_connec USING (link_id));


--
-- Name: v_state_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_connec AS
 SELECT DISTINCT ON (a.connec_id) a.connec_id,
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
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id AS connec_type,
    cat_feature.system_id AS sys_type,
    connec.connecat_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    connec.customer_code,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.connec_length,
    connec.state,
    connec.state_type,
    a.n_hydrometer,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.minsector_id,
    connec.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    connec.presszone_id,
    presszone.name AS presszone_name,
    connec.staticpressure,
    connec.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
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
    (b.descript)::character varying(100) AS streetname2,
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
    connec.publish,
    connec.inventory,
    connec.num_value,
    cat_connec.connectype_id,
    connec.pjoint_id,
    connec.pjoint_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    connec.adate,
    connec.adescript,
    connec.accessibility,
    (dma.stylesheet ->> 'featureColor'::text) AS dma_style,
    (presszone.stylesheet ->> 'featureColor'::text) AS presszone_style,
    connec.workcat_id_plan,
    connec.asset_id,
    connec.epa_type,
    connec.om_state,
    connec.conserv_state,
    connec.priority,
    connec.valve_location,
    connec.valve_type,
    connec.shutoff_valve,
    connec.access_type,
    connec.placement_type,
    connec.crmzone_id,
    crm_zone.name AS crmzone_name,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.demand,
    connec.expl_id2,
    e.quality_max,
    e.quality_min,
    e.quality_avg
   FROM ((((((((((((connec
     LEFT JOIN ( SELECT connec_1.connec_id,
            (count(ext_rtc_hydrometer.id))::integer AS n_hydrometer
           FROM selector_hydrometer,
            (ext_rtc_hydrometer
             JOIN connec connec_1 ON (((ext_rtc_hydrometer.connec_id)::text = (connec_1.customer_code)::text)))
          WHERE ((selector_hydrometer.state_id = ext_rtc_hydrometer.state_id) AND (selector_hydrometer.cur_user = ("current_user"())::text))
          GROUP BY connec_1.connec_id) a USING (connec_id))
     JOIN cat_connec ON (((connec.connecat_id)::text = (cat_connec.id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_connec.connectype_id)::text)))
     LEFT JOIN dma ON ((connec.dma_id = dma.dma_id)))
     LEFT JOIN sector ON ((connec.sector_id = sector.sector_id)))
     LEFT JOIN exploitation ON ((connec.expl_id = exploitation.expl_id)))
     LEFT JOIN dqa ON ((connec.dqa_id = dqa.dqa_id)))
     LEFT JOIN presszone ON (((presszone.presszone_id)::text = (connec.presszone_id)::text)))
     LEFT JOIN crm_zone ON (((crm_zone.id)::text = (connec.crmzone_id)::text)))
     LEFT JOIN v_ext_streetaxis c ON (((c.id)::text = (connec.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis b ON (((b.id)::text = (connec.streetaxis2_id)::text)))
     LEFT JOIN connec_add e ON (((e.connec_id)::text = (connec.connec_id)::text)));


--
-- Name: v_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_connec AS
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.elevation,
    vu_connec.depth,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.connecat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN (a.sector_id IS NULL) THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
    vu_connec.sector_name,
    vu_connec.macrosector_id,
    vu_connec.customer_code,
    vu_connec.cat_matcat_id,
    vu_connec.cat_pnom,
    vu_connec.cat_dnom,
    vu_connec.connec_length,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.n_hydrometer,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN (a.minsector_id IS NULL) THEN vu_connec.minsector_id
            ELSE a.minsector_id
        END AS minsector_id,
        CASE
            WHEN (a.dma_id IS NULL) THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN (a.dma_name IS NULL) THEN vu_connec.dma_name
            ELSE a.dma_name
        END AS dma_name,
        CASE
            WHEN (a.macrodma_id IS NULL) THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
        CASE
            WHEN (a.presszone_id IS NULL) THEN vu_connec.presszone_id
            ELSE (a.presszone_id)::character varying(30)
        END AS presszone_id,
        CASE
            WHEN (a.presszone_name IS NULL) THEN vu_connec.presszone_name
            ELSE a.presszone_name
        END AS presszone_name,
    vu_connec.staticpressure,
        CASE
            WHEN (a.dqa_id IS NULL) THEN vu_connec.dqa_id
            ELSE a.dqa_id
        END AS dqa_id,
        CASE
            WHEN (a.dqa_name IS NULL) THEN vu_connec.dqa_name
            ELSE a.dqa_name
        END AS dqa_name,
        CASE
            WHEN (a.macrodqa_id IS NULL) THEN vu_connec.macrodqa_id
            ELSE a.macrodqa_id
        END AS macrodqa_id,
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
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.num_value,
    vu_connec.connectype_id,
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
    vu_connec.adate,
    vu_connec.adescript,
    vu_connec.accessibility,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.dma_style,
    vu_connec.presszone_style,
    vu_connec.epa_type,
    vu_connec.priority,
    vu_connec.valve_location,
    vu_connec.valve_type,
    vu_connec.shutoff_valve,
    vu_connec.access_type,
    vu_connec.placement_type,
    vu_connec.press_max,
    vu_connec.press_min,
    vu_connec.press_avg,
    vu_connec.demand,
    vu_connec.om_state,
    vu_connec.conserv_state,
    vu_connec.crmzone_id,
    vu_connec.crmzone_name,
    vu_connec.expl_id2,
    vu_connec.quality_max,
    vu_connec.quality_min,
    vu_connec.quality_avg
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
            v_link_connec.presszone_id,
            v_link_connec.dqa_id,
            v_link_connec.minsector_id,
            v_link_connec.exit_topelev,
            v_link_connec.exit_elev,
            v_link_connec.fluid_type,
            v_link_connec.gis_length,
            v_link_connec.the_geom,
            v_link_connec.sector_name,
            v_link_connec.dma_name,
            v_link_connec.dqa_name,
            v_link_connec.presszone_name,
            v_link_connec.macrosector_id,
            v_link_connec.macrodma_id,
            v_link_connec.macrodqa_id,
            v_link_connec.expl_id2
           FROM v_link_connec
          WHERE (v_link_connec.state = 2)) a ON (((a.feature_id)::text = (vu_connec.connec_id)::text)));


--
-- Name: v_edit_anl_hydrant; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_anl_hydrant AS
 SELECT anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.expl_id,
    anl_node.the_geom
   FROM anl_node
  WHERE ((anl_node.fid = 468) AND ((anl_node.cur_user)::name = "current_user"()));


--
-- Name: v_edit_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.arccat_id,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.cat_matcat_id,
    v_arc.cat_pnom,
    v_arc.cat_dnom,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.sector_name,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.minsector_id,
    v_arc.dma_id,
    v_arc.dma_name,
    v_arc.macrodma_id,
    v_arc.presszone_id,
    v_arc.presszone_name,
    v_arc.dqa_id,
    v_arc.dqa_name,
    v_arc.macrodqa_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
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
    v_arc.num_value,
    v_arc.cat_arctype_id,
    v_arc.nodetype_1,
    v_arc.staticpress1,
    v_arc.nodetype_2,
    v_arc.staticpress2,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom,
    v_arc.depth,
    v_arc.adate,
    v_arc.adescript,
    v_arc.dma_style,
    v_arc.presszone_style,
    v_arc.workcat_id_plan,
    v_arc.asset_id,
    v_arc.pavcat_id,
    v_arc.om_state,
    v_arc.conserv_state,
    v_arc.flow_max,
    v_arc.flow_min,
    v_arc.flow_avg,
    v_arc.vel_max,
    v_arc.vel_min,
    v_arc.vel_avg,
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
    cat_feature_connec.epa_default,
    cat_feature.code_autofill,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_connec USING (id));


--
-- Name: v_edit_cat_feature_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_feature_node AS
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_node.epa_default,
    cat_feature_node.isarcdivide,
    cat_feature_node.isprofilesurface,
    cat_feature_node.choose_hemisphere,
    cat_feature.code_autofill,
    (cat_feature_node.double_geom)::text AS double_geom,
    cat_feature_node.num_arcs,
    cat_feature_node.graph_delimiter,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_node USING (id));


--
-- Name: v_edit_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_connec AS
 SELECT v_connec.connec_id,
    v_connec.code,
    v_connec.elevation,
    v_connec.depth,
    v_connec.connec_type,
    v_connec.sys_type,
    v_connec.connecat_id,
    v_connec.expl_id,
    v_connec.macroexpl_id,
    v_connec.sector_id,
    v_connec.sector_name,
    v_connec.macrosector_id,
    v_connec.customer_code,
    v_connec.cat_matcat_id,
    v_connec.cat_pnom,
    v_connec.cat_dnom,
    v_connec.connec_length,
    v_connec.state,
    v_connec.state_type,
    v_connec.n_hydrometer,
    v_connec.arc_id,
    v_connec.annotation,
    v_connec.observ,
    v_connec.comment,
    v_connec.minsector_id,
    v_connec.dma_id,
    v_connec.dma_name,
    v_connec.macrodma_id,
    v_connec.presszone_id,
    v_connec.presszone_name,
    v_connec.staticpressure,
    v_connec.dqa_id,
    v_connec.dqa_name,
    v_connec.macrodqa_id,
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
    v_connec.publish,
    v_connec.inventory,
    v_connec.num_value,
    v_connec.connectype_id,
    v_connec.pjoint_id,
    v_connec.pjoint_type,
    v_connec.tstamp,
    v_connec.insert_user,
    v_connec.lastupdate,
    v_connec.lastupdate_user,
    v_connec.the_geom,
    v_connec.adate,
    v_connec.adescript,
    v_connec.accessibility,
    v_connec.workcat_id_plan,
    v_connec.asset_id,
    v_connec.dma_style,
    v_connec.presszone_style,
    v_connec.epa_type,
    v_connec.priority,
    v_connec.valve_location,
    v_connec.valve_type,
    v_connec.shutoff_valve,
    v_connec.access_type,
    v_connec.placement_type,
    v_connec.press_max,
    v_connec.press_min,
    v_connec.press_avg,
    v_connec.demand,
    v_connec.om_state,
    v_connec.conserv_state,
    v_connec.crmzone_id,
    v_connec.crmzone_name,
    v_connec.expl_id2,
    v_connec.quality_max,
    v_connec.quality_min,
    v_connec.quality_avg
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
    (dma.graphconfig)::text AS graphconfig,
    (dma.stylesheet)::text AS stylesheet,
    dma.active,
    dma.avg_press
   FROM selector_expl,
    dma
  WHERE ((dma.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_dqa; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_dqa AS
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
    (dqa.graphconfig)::text AS graphconfig,
    (dqa.stylesheet)::text AS stylesheet,
    dqa.active
   FROM selector_expl,
    dqa
  WHERE ((dqa.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


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
 SELECT node.node_id,
    node.code,
    node.elevation,
    node.depth,
    cat_node.nodetype_id AS node_type,
    cat_feature.system_id AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.expl_id,
    exploitation.macroexpl_id,
    node.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    node.arc_id,
    node.parent_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.minsector_id,
    node.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    node.presszone_id,
    presszone.name AS presszone_name,
    node.staticpressure,
    node.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.workcat_id_end,
    node.builtdate,
    node.enddate,
    node.buildercat_id,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.district_id,
    (a.descript)::character varying(100) AS streetname,
    node.postnumber,
    node.postcomplement,
    (b.descript)::character varying(100) AS streetname2,
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
    node.hemisphere,
    node.num_value,
    cat_node.nodetype_id,
    date_trunc('second'::text, node.tstamp) AS tstamp,
    node.insert_user,
    date_trunc('second'::text, node.lastupdate) AS lastupdate,
    node.lastupdate_user,
    node.the_geom,
    node.adate,
    node.adescript,
    node.accessibility,
    (dma.stylesheet ->> 'featureColor'::text) AS dma_style,
    (presszone.stylesheet ->> 'featureColor'::text) AS presszone_style,
    node.workcat_id_plan,
    node.asset_id,
    node.om_state,
    node.conserv_state,
    node.access_type,
    node.placement_type,
    e.demand_max,
    e.demand_min,
    e.demand_avg,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.head_max,
    e.head_min,
    e.head_avg,
    e.quality_max,
    e.quality_min,
    e.quality_avg,
    node.expl_id2
   FROM ((((((((((node
     LEFT JOIN cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_node.nodetype_id)::text)))
     LEFT JOIN dma ON ((node.dma_id = dma.dma_id)))
     LEFT JOIN sector ON ((node.sector_id = sector.sector_id)))
     LEFT JOIN exploitation ON ((node.expl_id = exploitation.expl_id)))
     LEFT JOIN dqa ON ((node.dqa_id = dqa.dqa_id)))
     LEFT JOIN presszone ON (((presszone.presszone_id)::text = (node.presszone_id)::text)))
     LEFT JOIN v_ext_streetaxis a ON (((a.id)::text = (node.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis b ON (((b.id)::text = (node.streetaxis2_id)::text)))
     LEFT JOIN node_add e ON (((e.node_id)::text = (node.node_id)::text)));


--
-- Name: v_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_node AS
 SELECT vu_node.node_id,
    vu_node.code,
    vu_node.elevation,
    vu_node.depth,
    vu_node.node_type,
    vu_node.sys_type,
    vu_node.nodecat_id,
    vu_node.cat_matcat_id,
    vu_node.cat_pnom,
    vu_node.cat_dnom,
    vu_node.epa_type,
    vu_node.expl_id,
    vu_node.macroexpl_id,
    vu_node.sector_id,
    vu_node.sector_name,
    vu_node.macrosector_id,
    vu_node.arc_id,
    vu_node.parent_id,
    vu_node.state,
    vu_node.state_type,
    vu_node.annotation,
    vu_node.observ,
    vu_node.comment,
    vu_node.minsector_id,
    vu_node.dma_id,
    vu_node.dma_name,
    vu_node.macrodma_id,
    vu_node.presszone_id,
    vu_node.presszone_name,
    vu_node.staticpressure,
    vu_node.dqa_id,
    vu_node.dqa_name,
    vu_node.macrodqa_id,
    vu_node.soilcat_id,
    vu_node.function_type,
    vu_node.category_type,
    vu_node.fluid_type,
    vu_node.location_type,
    vu_node.workcat_id,
    vu_node.workcat_id_end,
    vu_node.builtdate,
    vu_node.enddate,
    vu_node.buildercat_id,
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
    vu_node.undelete,
    vu_node.label,
    vu_node.label_x,
    vu_node.label_y,
    vu_node.label_rotation,
    vu_node.publish,
    vu_node.inventory,
    vu_node.hemisphere,
    vu_node.num_value,
    vu_node.nodetype_id,
    vu_node.tstamp,
    vu_node.insert_user,
    vu_node.lastupdate,
    vu_node.lastupdate_user,
    vu_node.the_geom,
    vu_node.adate,
    vu_node.adescript,
    vu_node.accessibility,
    vu_node.dma_style,
    vu_node.presszone_style,
    vu_node.workcat_id_plan,
    vu_node.asset_id,
    vu_node.om_state,
    vu_node.conserv_state,
    vu_node.access_type,
    vu_node.placement_type,
    vu_node.demand_max,
    vu_node.demand_min,
    vu_node.demand_avg,
    vu_node.press_max,
    vu_node.press_min,
    vu_node.press_avg,
    vu_node.head_max,
    vu_node.head_min,
    vu_node.head_avg,
    vu_node.quality_max,
    vu_node.quality_min,
    vu_node.quality_avg,
    vu_node.expl_id2
   FROM ((vu_node
     JOIN v_state_node USING (node_id))
     JOIN v_expl_node e ON (((e.node_id)::text = (vu_node.node_id)::text)));


--
-- Name: v_edit_field_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_field_valve AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszone_id,
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
    v_node.postcomplement2,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    v_node.the_geom,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    man_valve.ordinarystatus
   FROM (v_node
     JOIN man_valve ON (((man_valve.node_id)::text = (v_node.node_id)::text)));





--
-- Name: v_edit_inp_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_connec AS
 SELECT connec.connec_id,
    connec.elevation,
    connec.depth,
    connec.connecat_id,
    connec.arc_id,
    connec.sector_id,
    connec.dma_id,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.expl_id,
    connec.pjoint_type,
    connec.pjoint_id,
    inp_connec.demand,
    inp_connec.pattern_id,
    connec.the_geom,
    inp_connec.peak_factor,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    connec.epa_type,
    inp_connec.status,
    inp_connec.minorloss
   FROM selector_sector,
    ((v_connec connec
     JOIN inp_connec USING (connec_id))
     JOIN value_state_type vs ON ((vs.id = connec.state_type)))
  WHERE ((connec.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (vs.is_operative IS TRUE));


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
-- Name: v_edit_inp_dscenario_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_connec AS
 SELECT d.dscenario_id,
    connec.connec_id,
    connec.pjoint_type,
    connec.pjoint_id,
    c.demand,
    c.pattern_id,
    c.peak_factor,
    c.status,
    c.minorloss,
    c.custom_roughness,
    c.custom_length,
    c.custom_dint,
    connec.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_connec connec
     JOIN inp_dscenario_connec c USING (connec_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((c.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


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
-- Name: v_edit_inp_dscenario_demand; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_demand AS
 SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    node.sector_id,
    node.expl_id,
    node.presszone_id,
    node.dma_id,
    node.the_geom
   FROM (((inp_dscenario_demand
     JOIN node ON (((node.node_id)::text = (inp_dscenario_demand.feature_id)::text)))
     JOIN selector_sector s ON ((s.sector_id = node.sector_id)))
     JOIN selector_inp_dscenario d USING (dscenario_id))
  WHERE ((s.cur_user = CURRENT_USER) AND (d.cur_user = CURRENT_USER))
UNION
 SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    connec.sector_id,
    connec.expl_id,
    connec.presszone_id,
    connec.dma_id,
    connec.the_geom
   FROM (((inp_dscenario_demand
     JOIN connec ON (((connec.connec_id)::text = (inp_dscenario_demand.feature_id)::text)))
     JOIN selector_sector s ON ((s.sector_id = connec.sector_id)))
     JOIN selector_inp_dscenario d USING (dscenario_id))
  WHERE ((s.cur_user = CURRENT_USER) AND (d.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_dscenario_inlet; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_inlet AS
 SELECT d.dscenario_id,
    n.node_id,
    i.initlevel,
    i.minlevel,
    i.maxlevel,
    i.diameter,
    i.minvol,
    i.curve_id,
    i.pattern_id,
    i.overflow,
    i.head,
    n.the_geom
   FROM selector_inp_dscenario,
    ((node n
     JOIN inp_dscenario_inlet i USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((i.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text) AND ((n.epa_type)::text = 'INLET'::text));


--
-- Name: v_edit_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_node AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.expl_id,
    v_node.macroexpl_id,
    v_node.sector_id,
    v_node.sector_name,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.minsector_id,
    v_node.dma_id,
    v_node.dma_name,
    v_node.macrodma_id,
    v_node.presszone_id,
    v_node.presszone_name,
    v_node.staticpressure,
    v_node.dqa_id,
    v_node.dqa_name,
    v_node.macrodqa_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.buildercat_id,
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
    v_node.undelete,
    v_node.label,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.hemisphere,
    v_node.num_value,
    v_node.nodetype_id,
    v_node.tstamp,
    v_node.insert_user,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.the_geom,
    v_node.adate,
    v_node.adescript,
    v_node.accessibility,
    v_node.dma_style,
    v_node.presszone_style,
    man_valve.closed AS closed_valve,
    man_valve.broken AS broken_valve,
    v_node.workcat_id_plan,
    v_node.asset_id,
    v_node.om_state,
    v_node.conserv_state,
    v_node.access_type,
    v_node.placement_type,
    v_node.demand_max,
    v_node.demand_min,
    v_node.demand_avg,
    v_node.press_max,
    v_node.press_min,
    v_node.press_avg,
    v_node.head_max,
    v_node.head_min,
    v_node.head_avg,
    v_node.quality_max,
    v_node.quality_min,
    v_node.quality_avg,
    v_node.expl_id2
   FROM (v_node
     LEFT JOIN man_valve USING (node_id));


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
-- Name: v_edit_inp_junction; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_junction AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    n.the_geom,
    inp_junction.peak_factor,
    n.expl_id
   FROM (((v_sector_node sn
     JOIN v_edit_node n USING (node_id))
     JOIN inp_junction USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_junction; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_junction AS
 SELECT d.dscenario_id,
    n.node_id,
    j.demand,
    j.pattern_id,
    j.peak_factor,
    n.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_junction n
     JOIN inp_dscenario_junction j USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((j.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_pipe; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pipe AS
 SELECT arc.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    arc.sector_id,
    arc.macrosector_id,
    arc.dma_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.expl_id,
    arc.custom_length,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint,
    arc.the_geom
   FROM selector_sector,
    ((v_arc arc
     JOIN inp_pipe USING (arc_id))
     JOIN value_state_type vs ON ((vs.id = arc.state_type)))
  WHERE ((arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (vs.is_operative IS TRUE));


--
-- Name: v_edit_inp_dscenario_pipe; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_pipe AS
 SELECT d.dscenario_id,
    p.arc_id,
    p.minorloss,
    p.status,
    p.roughness,
    p.dint,
    v_edit_inp_pipe.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_pipe
     JOIN inp_dscenario_pipe p USING (arc_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_pump; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pump AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    n.dma_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type,
    n.the_geom
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_pump USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_pump; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_pump AS
 SELECT d.dscenario_id,
    p.node_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status,
    v_edit_inp_pump.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_pump
     JOIN inp_dscenario_pump p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_dscenario_pump_additional; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_pump_additional AS
 SELECT d.dscenario_id,
    p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status,
    v_edit_inp_pump.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_pump
     JOIN inp_dscenario_pump_additional p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_reservoir; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_reservoir AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    n.the_geom
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_reservoir USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_reservoir; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_reservoir AS
 SELECT d.dscenario_id,
    p.node_id,
    p.pattern_id,
    p.head,
    v_edit_inp_reservoir.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_reservoir
     JOIN inp_dscenario_reservoir p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_dscenario_rules; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_rules AS
 SELECT i.id,
    d.dscenario_id,
    i.sector_id,
    i.text,
    i.active
   FROM selector_inp_dscenario,
    (inp_dscenario_rules i
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((i.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_shortpipe; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_shortpipe AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status,
    n.the_geom
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_shortpipe USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_shortpipe; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_shortpipe AS
 SELECT d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status,
    v.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_shortpipe v
     JOIN inp_dscenario_shortpipe p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_dscenario_tank; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_tank AS
 SELECT d.dscenario_id,
    p.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    v.the_geom
   FROM selector_inp_dscenario,
    ((node v
     JOIN inp_dscenario_tank p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text) AND ((v.epa_type)::text = 'TANK'::text));


--
-- Name: v_edit_inp_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_valve AS
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status,
    v_node.the_geom,
    inp_valve.custom_dint,
    inp_valve.add_settings
   FROM (((v_sector_node sn
     JOIN v_node USING (node_id))
     JOIN inp_valve USING (node_id))
     JOIN value_state_type vs ON ((vs.id = v_node.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_valve AS
 SELECT d.dscenario_id,
    p.node_id,
    p.valv_type,
    p.pressure,
    p.flow,
    p.coef_loss,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    v.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_valve v
     JOIN inp_dscenario_valve p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_virtualvalve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_virtualvalve AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    ((v_arc.elevation1 + v_arc.elevation2) / (2)::numeric) AS elevation,
    ((v_arc.depth1 + v_arc.depth2) / (2)::numeric) AS depth,
    v_arc.arccat_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.dma_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.expl_id,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.status,
    v_arc.the_geom
   FROM selector_sector,
    ((v_arc
     JOIN inp_virtualvalve USING (arc_id))
     JOIN value_state_type vs ON ((vs.id = v_arc.state_type)))
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (vs.is_operative IS TRUE));


--
-- Name: v_edit_inp_dscenario_virtualvalve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_virtualvalve AS
 SELECT d.dscenario_id,
    v_edit_inp_virtualvalve.arc_id,
    v.valv_type,
    v.pressure,
    v.diameter,
    v.flow,
    v.coef_loss,
    v.curve_id,
    v.minorloss,
    v.status,
    v_edit_inp_virtualvalve.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_virtualvalve
     JOIN inp_dscenario_virtualvalve v USING (arc_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((v.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_inlet; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_inlet AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
    n.the_geom,
    inp_inlet.overflow,
    inp_inlet.head
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_inlet USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_pattern; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pattern AS
 SELECT DISTINCT p.pattern_id,
    p.observ,
    p.tscode,
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
 SELECT DISTINCT inp_pattern_value.id,
    p.pattern_id,
    p.observ,
    p.tscode,
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
    inp_pattern_value.factor_18
   FROM selector_expl s,
    (inp_pattern p
     JOIN inp_pattern_value USING (pattern_id))
  WHERE (((p.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (p.expl_id IS NULL))
  ORDER BY inp_pattern_value.id;


--
-- Name: v_edit_inp_pump_additional; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pump_additional AS
 SELECT p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status
   FROM (inp_pump_additional p
     JOIN v_edit_inp_pump USING (node_id));


--
-- Name: v_edit_inp_rules; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_rules AS
 SELECT DISTINCT rules.id,
    rules.sector_id,
    rules.text,
    rules.active
   FROM selector_sector,
    inp_rules rules
  WHERE ((rules.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_tank; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_tank AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    n.the_geom,
    inp_tank.overflow
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_tank USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


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
    vu_link.presszone_id,
    vu_link.dqa_id,
    vu_link.minsector_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.dma_name,
    vu_link.dqa_name,
    vu_link.presszone_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.macrodqa_id,
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
    l.presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    l.gis_length,
    l.the_geom,
    l.sector_name,
    l.dma_name,
    l.dqa_name,
    l.presszone_name,
    l.macrosector_id,
    l.macrodma_id,
    l.macrodqa_id,
    l.expl_id2
   FROM v_link l;


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
-- Name: v_edit_macrodqa; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_macrodqa AS
 SELECT macrodqa.macrodqa_id,
    macrodqa.name,
    macrodqa.expl_id,
    macrodqa.descript,
    macrodqa.undelete,
    macrodqa.the_geom,
    macrodqa.active
   FROM selector_expl,
    macrodqa
  WHERE ((macrodqa.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


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
-- Name: v_edit_pond; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_pond AS
 SELECT pond.pond_id,
    pond.connec_id,
    pond.dma_id,
    dma.macrodma_id,
    pond.state,
    pond.the_geom,
    pond.expl_id
   FROM selector_expl,
    (pond
     LEFT JOIN dma ON ((pond.dma_id = dma.dma_id)))
  WHERE ((pond.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_edit_pool; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_pool AS
 SELECT pool.pool_id,
    pool.connec_id,
    pool.dma_id,
    dma.macrodma_id,
    pool.state,
    pool.the_geom,
    pool.expl_id
   FROM selector_expl,
    (pool
     LEFT JOIN dma ON ((pool.dma_id = dma.dma_id)))
  WHERE ((pool.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_edit_presszone; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_presszone AS
 SELECT presszone.presszone_id,
    presszone.name,
    presszone.expl_id,
    presszone.the_geom,
    (presszone.graphconfig)::text AS graphconfig,
    presszone.head,
    (presszone.stylesheet)::text AS stylesheet,
    presszone.active,
    presszone.descript
   FROM selector_expl,
    presszone
  WHERE ((presszone.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_review_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_arc AS
 SELECT review_arc.arc_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.review_obs,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_date,
    review_arc.field_checked,
    review_arc.is_validated
   FROM review_arc,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_arc.expl_id = selector_expl.expl_id));


--
-- Name: v_edit_review_audit_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_arc AS
 SELECT review_audit_arc.id,
    review_audit_arc.arc_id,
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
-- Name: v_edit_review_audit_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_node AS
 SELECT review_audit_node.id,
    review_audit_node.node_id,
    review_audit_node.old_elevation,
    review_audit_node.new_elevation,
    review_audit_node.old_depth,
    review_audit_node.new_depth,
    review_audit_node.old_nodecat_id,
    review_audit_node.new_nodecat_id,
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
-- Name: v_edit_review_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_node AS
 SELECT review_node.node_id,
    review_node.elevation,
    review_node.depth,
    review_node.nodecat_id,
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
    samplepoint.presszone_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.muni_id,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcode,
    samplepoint.district_id,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement,
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
    (sector.graphconfig)::text AS graphconfig,
    (sector.stylesheet)::text AS stylesheet,
    sector.active,
    sector.parent_id,
    sector.pattern_id
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
-- Name: v_inp_pjointpattern; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_inp_pjointpattern AS
 SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
    a.idrow,
        CASE
            WHEN ((a.pjoint_type)::text = 'VNODE'::text) THEN (concat('VN', a.pattern_id))::character varying
            ELSE a.pattern_id
        END AS pattern_id,
    a.pjoint_type,
    (sum(a.factor_1))::numeric(10,8) AS factor_1,
    (sum(a.factor_2))::numeric(10,8) AS factor_2,
    (sum(a.factor_3))::numeric(10,8) AS factor_3,
    (sum(a.factor_4))::numeric(10,8) AS factor_4,
    (sum(a.factor_5))::numeric(10,8) AS factor_5,
    (sum(a.factor_6))::numeric(10,8) AS factor_6,
    (sum(a.factor_7))::numeric(10,8) AS factor_7,
    (sum(a.factor_8))::numeric(10,8) AS factor_8,
    (sum(a.factor_9))::numeric(10,8) AS factor_9,
    (sum(a.factor_10))::numeric(10,8) AS factor_10,
    (sum(a.factor_11))::numeric(10,8) AS factor_11,
    (sum(a.factor_12))::numeric(10,8) AS factor_12,
    (sum(a.factor_13))::numeric(10,8) AS factor_13,
    (sum(a.factor_14))::numeric(10,8) AS factor_14,
    (sum(a.factor_15))::numeric(10,8) AS factor_15,
    (sum(a.factor_16))::numeric(10,8) AS factor_16,
    (sum(a.factor_17))::numeric(10,8) AS factor_17,
    (sum(a.factor_18))::numeric(10,8) AS factor_18
   FROM ( SELECT c.pjoint_type,
                CASE
                    WHEN (b.id = ( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 1
                    WHEN (b.id = ( SELECT (min(sub.id) + 1)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 2
                    WHEN (b.id = ( SELECT (min(sub.id) + 2)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 3
                    WHEN (b.id = ( SELECT (min(sub.id) + 3)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 4
                    WHEN (b.id = ( SELECT (min(sub.id) + 4)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 5
                    WHEN (b.id = ( SELECT (min(sub.id) + 5)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 6
                    WHEN (b.id = ( SELECT (min(sub.id) + 6)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 7
                    WHEN (b.id = ( SELECT (min(sub.id) + 7)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 8
                    WHEN (b.id = ( SELECT (min(sub.id) + 8)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 9
                    WHEN (b.id = ( SELECT (min(sub.id) + 9)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 10
                    WHEN (b.id = ( SELECT (min(sub.id) + 10)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 11
                    WHEN (b.id = ( SELECT (min(sub.id) + 11)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 12
                    WHEN (b.id = ( SELECT (min(sub.id) + 12)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 13
                    WHEN (b.id = ( SELECT (min(sub.id) + 13)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 14
                    WHEN (b.id = ( SELECT (min(sub.id) + 14)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 15
                    WHEN (b.id = ( SELECT (min(sub.id) + 15)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 16
                    WHEN (b.id = ( SELECT (min(sub.id) + 16)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 17
                    WHEN (b.id = ( SELECT (min(sub.id) + 17)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 18
                    WHEN (b.id = ( SELECT (min(sub.id) + 18)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 19
                    WHEN (b.id = ( SELECT (min(sub.id) + 19)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 20
                    WHEN (b.id = ( SELECT (min(sub.id) + 20)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 21
                    WHEN (b.id = ( SELECT (min(sub.id) + 21)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 22
                    WHEN (b.id = ( SELECT (min(sub.id) + 22)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 23
                    WHEN (b.id = ( SELECT (min(sub.id) + 23)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 24
                    WHEN (b.id = ( SELECT (min(sub.id) + 24)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 25
                    WHEN (b.id = ( SELECT (min(sub.id) + 25)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 26
                    WHEN (b.id = ( SELECT (min(sub.id) + 26)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 27
                    WHEN (b.id = ( SELECT (min(sub.id) + 27)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 28
                    WHEN (b.id = ( SELECT (min(sub.id) + 28)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 29
                    WHEN (b.id = ( SELECT (min(sub.id) + 29)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 30
                    ELSE NULL::integer
                END AS idrow,
            c.pjoint_id AS pattern_id,
            sum(((c.demand)::double precision * (b.factor_1)::double precision)) AS factor_1,
            sum(((c.demand)::double precision * (b.factor_2)::double precision)) AS factor_2,
            sum(((c.demand)::double precision * (b.factor_3)::double precision)) AS factor_3,
            sum(((c.demand)::double precision * (b.factor_4)::double precision)) AS factor_4,
            sum(((c.demand)::double precision * (b.factor_5)::double precision)) AS factor_5,
            sum(((c.demand)::double precision * (b.factor_6)::double precision)) AS factor_6,
            sum(((c.demand)::double precision * (b.factor_7)::double precision)) AS factor_7,
            sum(((c.demand)::double precision * (b.factor_8)::double precision)) AS factor_8,
            sum(((c.demand)::double precision * (b.factor_9)::double precision)) AS factor_9,
            sum(((c.demand)::double precision * (b.factor_10)::double precision)) AS factor_10,
            sum(((c.demand)::double precision * (b.factor_11)::double precision)) AS factor_11,
            sum(((c.demand)::double precision * (b.factor_12)::double precision)) AS factor_12,
            sum(((c.demand)::double precision * (b.factor_13)::double precision)) AS factor_13,
            sum(((c.demand)::double precision * (b.factor_14)::double precision)) AS factor_14,
            sum(((c.demand)::double precision * (b.factor_15)::double precision)) AS factor_15,
            sum(((c.demand)::double precision * (b.factor_16)::double precision)) AS factor_16,
            sum(((c.demand)::double precision * (b.factor_17)::double precision)) AS factor_17,
            sum(((c.demand)::double precision * (b.factor_18)::double precision)) AS factor_18
           FROM (( SELECT inp_connec.connec_id,
                    inp_connec.demand,
                    inp_connec.pattern_id,
                    connec.pjoint_id,
                    connec.pjoint_type
                   FROM (inp_connec
                     JOIN connec USING (connec_id))) c
             JOIN inp_pattern_value b USING (pattern_id))
          GROUP BY c.pjoint_type, c.pjoint_id,
                CASE
                    WHEN (b.id = ( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 1
                    WHEN (b.id = ( SELECT (min(sub.id) + 1)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 2
                    WHEN (b.id = ( SELECT (min(sub.id) + 2)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 3
                    WHEN (b.id = ( SELECT (min(sub.id) + 3)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 4
                    WHEN (b.id = ( SELECT (min(sub.id) + 4)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 5
                    WHEN (b.id = ( SELECT (min(sub.id) + 5)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 6
                    WHEN (b.id = ( SELECT (min(sub.id) + 6)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 7
                    WHEN (b.id = ( SELECT (min(sub.id) + 7)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 8
                    WHEN (b.id = ( SELECT (min(sub.id) + 8)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 9
                    WHEN (b.id = ( SELECT (min(sub.id) + 9)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 10
                    WHEN (b.id = ( SELECT (min(sub.id) + 10)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 11
                    WHEN (b.id = ( SELECT (min(sub.id) + 11)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 12
                    WHEN (b.id = ( SELECT (min(sub.id) + 12)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 13
                    WHEN (b.id = ( SELECT (min(sub.id) + 13)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 14
                    WHEN (b.id = ( SELECT (min(sub.id) + 14)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 15
                    WHEN (b.id = ( SELECT (min(sub.id) + 15)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 16
                    WHEN (b.id = ( SELECT (min(sub.id) + 16)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 17
                    WHEN (b.id = ( SELECT (min(sub.id) + 17)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 18
                    WHEN (b.id = ( SELECT (min(sub.id) + 18)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 19
                    WHEN (b.id = ( SELECT (min(sub.id) + 19)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 20
                    WHEN (b.id = ( SELECT (min(sub.id) + 20)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 21
                    WHEN (b.id = ( SELECT (min(sub.id) + 21)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 22
                    WHEN (b.id = ( SELECT (min(sub.id) + 22)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 23
                    WHEN (b.id = ( SELECT (min(sub.id) + 23)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 24
                    WHEN (b.id = ( SELECT (min(sub.id) + 24)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 25
                    WHEN (b.id = ( SELECT (min(sub.id) + 25)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 26
                    WHEN (b.id = ( SELECT (min(sub.id) + 26)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 27
                    WHEN (b.id = ( SELECT (min(sub.id) + 27)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 28
                    WHEN (b.id = ( SELECT (min(sub.id) + 28)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 29
                    WHEN (b.id = ( SELECT (min(sub.id) + 29)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 30
                    ELSE NULL::integer
                END) a
  GROUP BY a.idrow, a.pattern_id, a.pjoint_type;


--
-- Name: v_minsector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_minsector AS
 SELECT m.minsector_id,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.sector_id,
    m.expl_id,
    m.the_geom,
    m.num_border,
    m.num_connec,
    m.num_hydro,
    m.length,
    m.addparam
   FROM selector_expl s,
    minsector m
  WHERE ((m.expl_id = s.expl_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_om_mincut; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut AS
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output
   FROM selector_mincut_result,
    (((((((om_mincut
     LEFT JOIN om_typevalue a ON ((((a.id)::integer = om_mincut.mincut_state) AND (a.typevalue = 'mincut_state'::text))))
     LEFT JOIN om_typevalue b ON ((((b.id)::integer = om_mincut.mincut_class) AND (b.typevalue = 'mincut_class'::text))))
     LEFT JOIN om_typevalue c ON ((((c.id)::integer = (om_mincut.anl_cause)::integer) AND (c.typevalue = 'mincut_cause'::text))))
     LEFT JOIN exploitation ON ((om_mincut.expl_id = exploitation.expl_id)))
     LEFT JOIN ext_streetaxis ON (((om_mincut.streetaxis_id)::text = (ext_streetaxis.id)::text)))
     LEFT JOIN macroexploitation ON ((om_mincut.macroexpl_id = macroexploitation.macroexpl_id)))
     LEFT JOIN ext_municipality ON ((om_mincut.muni_id = ext_municipality.muni_id)))
  WHERE ((selector_mincut_result.result_id = om_mincut.id) AND (selector_mincut_result.cur_user = ("current_user"())::text) AND (om_mincut.id > 0));


--
-- Name: v_om_mincut_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_arc AS
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    om_mincut_arc.the_geom
   FROM selector_mincut_result,
    (om_mincut_arc
     JOIN om_mincut ON ((om_mincut_arc.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_arc.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text))
  ORDER BY om_mincut_arc.arc_id;


--
-- Name: v_om_mincut_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_connec AS
 SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    om_mincut_connec.customer_code,
    om_mincut_connec.the_geom
   FROM selector_mincut_result,
    (om_mincut_connec
     JOIN om_mincut ON ((om_mincut_connec.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_connec.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_mincut_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_hydrometer AS
 SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS connec_code
   FROM selector_mincut_result,
    ((((om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON (((om_mincut_hydrometer.hydrometer_id)::text = (ext_rtc_hydrometer.id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((om_mincut_hydrometer.hydrometer_id)::text = (rtc_hydrometer_x_connec.hydrometer_id)::text)))
     JOIN connec ON (((rtc_hydrometer_x_connec.connec_id)::text = (connec.connec_id)::text)))
     JOIN om_mincut ON ((om_mincut_hydrometer.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_hydrometer.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_mincut_initpoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_initpoint AS
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.notified,
    om_mincut.output
   FROM selector_mincut_result,
    (((((((om_mincut
     LEFT JOIN om_typevalue a ON ((((a.id)::integer = om_mincut.mincut_state) AND (a.typevalue = 'mincut_state'::text))))
     LEFT JOIN om_typevalue b ON ((((b.id)::integer = om_mincut.mincut_class) AND (b.typevalue = 'mincut_class'::text))))
     LEFT JOIN om_typevalue c ON ((((c.id)::integer = (om_mincut.anl_cause)::integer) AND (c.typevalue = 'mincut_cause'::text))))
     LEFT JOIN exploitation ON ((om_mincut.expl_id = exploitation.expl_id)))
     LEFT JOIN ext_streetaxis ON (((om_mincut.streetaxis_id)::text = (ext_streetaxis.id)::text)))
     LEFT JOIN macroexploitation ON ((om_mincut.macroexpl_id = macroexploitation.macroexpl_id)))
     LEFT JOIN ext_municipality ON ((om_mincut.muni_id = ext_municipality.muni_id)))
  WHERE ((selector_mincut_result.result_id = om_mincut.id) AND (selector_mincut_result.cur_user = ("current_user"())::text) AND (om_mincut.id > 0));


--
-- Name: v_om_mincut_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_node AS
 SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    om_mincut_node.node_type,
    om_mincut_node.the_geom
   FROM selector_mincut_result,
    (om_mincut_node
     JOIN om_mincut ON ((om_mincut_node.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_node.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_mincut_planned_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_planned_arc AS
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut_arc.arc_id,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_arc.the_geom
   FROM (om_mincut_arc
     JOIN om_mincut ON ((om_mincut.id = om_mincut_arc.result_id)))
  WHERE (om_mincut.mincut_state < 2);


--
-- Name: v_om_mincut_planned_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_planned_valve AS
 SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_valve.the_geom
   FROM (om_mincut_valve
     JOIN om_mincut ON ((om_mincut.id = om_mincut_valve.result_id)))
  WHERE ((om_mincut.mincut_state < 2) AND (om_mincut_valve.proposed = true));


--
-- Name: v_om_mincut_polygon; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_polygon AS
 SELECT om_mincut_polygon.id,
    om_mincut_polygon.result_id,
    om_mincut.work_order,
    om_mincut_polygon.polygon_id,
    om_mincut_polygon.the_geom
   FROM selector_mincut_result,
    (om_mincut_polygon
     JOIN om_mincut ON ((om_mincut_polygon.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_polygon.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_mincut_selected_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_selected_valve AS
 SELECT v_node.node_id,
    v_node.nodetype_id,
    man_valve.closed,
    man_valve.broken,
    v_node.the_geom
   FROM ((v_node
     JOIN man_valve ON (((v_node.node_id)::text = (man_valve.node_id)::text)))
     JOIN config_graph_valve ON (((v_node.nodetype_id)::text = (config_graph_valve.id)::text)))
  WHERE (config_graph_valve.active IS TRUE);


--
-- Name: v_om_mincut_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_valve AS
 SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut.work_order,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.broken,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut_valve.the_geom
   FROM selector_mincut_result,
    (om_mincut_valve
     JOIN om_mincut ON ((om_mincut_valve.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_valve.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


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
          WHERE ((selector_state.state_id = connec.state) AND (selector_state.cur_user = ("current_user"())::text))) a;


--
-- Name: v_om_waterbalance; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_waterbalance AS
 SELECT e.name AS exploitation,
    d.name AS dma,
    p.code AS period,
    om_waterbalance.auth_bill,
    om_waterbalance.auth_unbill,
    om_waterbalance.loss_app,
    om_waterbalance.loss_real,
    om_waterbalance.total_in,
    om_waterbalance.total_out,
    om_waterbalance.total,
    (p.start_date)::date AS crm_startdate,
    (p.end_date)::date AS crm_enddate,
    om_waterbalance.startdate AS wbal_startdate,
    om_waterbalance.enddate AS wbal_enddate,
    om_waterbalance.ili,
    om_waterbalance.auth,
    om_waterbalance.loss,
        CASE
            WHEN (om_waterbalance.total > (0)::double precision) THEN (((((100)::numeric)::double precision * (om_waterbalance.auth_bill + om_waterbalance.auth_unbill)) / om_waterbalance.total))::numeric(12,2)
            ELSE (0)::numeric(12,2)
        END AS loss_eff,
    om_waterbalance.auth_bill AS rw,
    ((om_waterbalance.total - om_waterbalance.auth_bill))::numeric(12,2) AS nrw,
        CASE
            WHEN (om_waterbalance.total > (0)::double precision) THEN (((((100)::numeric)::double precision * om_waterbalance.auth_bill) / om_waterbalance.total))::numeric(12,2)
            ELSE (0)::numeric(12,2)
        END AS nrw_eff,
    d.the_geom
   FROM (((om_waterbalance
     JOIN exploitation e USING (expl_id))
     JOIN dma d USING (dma_id))
     JOIN ext_cat_period p ON (((p.id)::text = (om_waterbalance.cat_period_id)::text)));


--
-- Name: v_om_waterbalance_report; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_waterbalance_report AS
 WITH expl_data AS (
         SELECT (sum(w_1.auth) / sum(w_1.total)) AS expl_rw_eff,
            ((1)::double precision - (sum(w_1.auth) / sum(w_1.total))) AS expl_nrw_eff,
            NULL::text AS expl_nightvol,
                CASE
                    WHEN (sum(w_1.arc_length) = (0)::double precision) THEN NULL::double precision
                    ELSE ((sum(w_1.nrw) / sum(w_1.arc_length)) / ((EXTRACT(epoch FROM age(p_1.end_date, p_1.start_date)) / (3600)::numeric))::double precision)
                END AS expl_m4day,
                CASE
                    WHEN ((sum(w_1.arc_length) = (0)::double precision) AND (sum(w_1.n_connec) = 0) AND (sum(w_1.link_length) = (0)::double precision)) THEN NULL::double precision
                    ELSE ((sum(w_1.loss) * (((365)::numeric / EXTRACT(day FROM (p_1.end_date - p_1.start_date))))::double precision) / ((((6.57)::double precision * sum(w_1.arc_length)) + ((9.13)::double precision * sum(w_1.link_length))) + (((0.256 * (sum(w_1.n_connec))::numeric) * avg(d_1.avg_press)))::double precision))
                END AS expl_ili,
            w_1.expl_id,
            w_1.cat_period_id,
            p_1.start_date
           FROM ((om_waterbalance w_1
             JOIN ext_cat_period p_1 ON (((w_1.cat_period_id)::text = (p_1.id)::text)))
             JOIN dma d_1 ON ((d_1.dma_id = w_1.dma_id)))
          GROUP BY w_1.expl_id, w_1.cat_period_id, p_1.end_date, p_1.start_date
        )
 SELECT DISTINCT e.name AS exploitation,
    w.expl_id,
    d.name AS dma,
    w.dma_id,
    w.cat_period_id,
    p.code AS period,
    p.start_date,
    p.end_date,
    w.meters_in,
    w.meters_out,
    w.n_connec,
    w.n_hydro,
    w.arc_length,
    w.link_length,
    w.total_in,
    w.total_out,
    w.total,
    w.auth,
    w.nrw,
        CASE
            WHEN (w.total <> (0)::double precision) THEN (w.auth / w.total)
            ELSE NULL::double precision
        END AS dma_rw_eff,
        CASE
            WHEN (w.total <> (0)::double precision) THEN ((1)::double precision - (w.auth / w.total))
            ELSE NULL::double precision
        END AS dma_nrw_eff,
    w.ili AS dma_ili,
    NULL::text AS dma_nightvol,
    ((w.nrw / w.arc_length) / ((EXTRACT(epoch FROM age(p.end_date, p.start_date)) / (3600)::numeric))::double precision) AS dma_m4day,
    ed.expl_rw_eff,
    ed.expl_nrw_eff,
    ed.expl_nightvol,
    ed.expl_ili,
    ed.expl_m4day
   FROM ((((om_waterbalance w
     JOIN exploitation e USING (expl_id))
     JOIN dma d USING (dma_id))
     JOIN ext_cat_period p ON (((w.cat_period_id)::text = (p.id)::text)))
     JOIN expl_data ed ON (((ed.expl_id = w.expl_id) AND ((w.cat_period_id)::text = (p.id)::text))))
  WHERE (ed.start_date = p.start_date);


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
    cat_arc.dint,
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
    d.sector_id,
    d.expl_id,
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
    d.total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_arc.arc_id,
                            v_arc.depth1,
                            v_arc.depth2,
                                CASE
                                    WHEN (((v_arc.depth1 * v_arc.depth2) = (0)::numeric) OR ((v_arc.depth1 * v_arc.depth2) IS NULL)) THEN v_price_x_catarc.estimated_depth
                                    ELSE (((v_arc.depth1 + v_arc.depth2) / (2)::numeric))::numeric(12,2)
                                END AS mean_depth,
                            v_arc.arccat_id,
                            (COALESCE((v_price_x_catarc.dint / (1000)::numeric), (0)::numeric))::numeric(12,4) AS dint,
                            (COALESCE(v_price_x_catarc.z1, (0)::numeric))::numeric(12,2) AS z1,
                            (COALESCE(v_price_x_catarc.z2, (0)::numeric))::numeric(12,2) AS z2,
                            (COALESCE(v_price_x_catarc.area, (0)::numeric))::numeric(12,4) AS area,
                            (COALESCE(v_price_x_catarc.width, (0)::numeric))::numeric(12,2) AS width,
                            (COALESCE((v_price_x_catarc.bulk / (1000)::numeric), (0)::numeric))::numeric(12,4) AS bulk,
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
                    v_plan_aux_arc_ml.depth1,
                    v_plan_aux_arc_ml.depth2,
                    v_plan_aux_arc_ml.mean_depth,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.dint,
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
                    (((((2)::numeric * (((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)))::numeric(12,3) AS m2mlpavement,
                    ((((2)::numeric * v_plan_aux_arc_ml.b) + v_plan_aux_arc_ml.width))::numeric(12,3) AS m2mlbase,
                    ((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS calculed_depth,
                    (((v_plan_aux_arc_ml.trenchlining * (2)::numeric) * (((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness)))::numeric(12,3) AS m2mltrenchl,
                    ((((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + (v_plan_aux_arc_ml.b * (2)::numeric)) + v_plan_aux_arc_ml.width)) / (2)::numeric))::numeric(12,3) AS m3mlexc,
                    ((((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric)) - v_plan_aux_arc_ml.area))::numeric(12,3) AS m3mlprotec,
                    (((((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + (v_plan_aux_arc_ml.b * (2)::numeric)) + v_plan_aux_arc_ml.width)) / (2)::numeric) - ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric))))::numeric(12,3) AS m3mlfill,
                    (((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric)))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE (v_plan_aux_arc_ml.arc_id IS NOT NULL)
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            v_plan_aux_arc_cost.arccat_id AS arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            arc.sector_id,
            v_plan_aux_arc_cost.expl_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.depth1 AS y1,
            v_plan_aux_arc_cost.depth2 AS y2,
            v_plan_aux_arc_cost.mean_depth AS mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.dint AS geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            ((v_plan_aux_arc_cost.calculed_depth + v_plan_aux_arc_cost.thickness))::numeric(12,2) AS total_y,
            (((((v_plan_aux_arc_cost.calculed_depth - ((2)::numeric * v_plan_aux_arc_cost.bulk)) - v_plan_aux_arc_cost.z1) - v_plan_aux_arc_cost.z2) - v_plan_aux_arc_cost.dint))::numeric(12,2) AS rec_y,
            ((v_plan_aux_arc_cost.dint + ((2)::numeric * v_plan_aux_arc_cost.bulk)))::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_depth AS calculed_y,
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
            v_plan_aux_arc_connec.connec_total_cost AS other_budget,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN (v_plan_aux_arc_cost.arc_cost +
                    CASE
                        WHEN (v_plan_aux_arc_connec.connec_total_cost IS NULL) THEN (0)::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END)
                    ELSE (((public.st_length2d(v_plan_aux_arc_cost.the_geom))::numeric(12,2) * (((((((((v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost) + (v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost)) + (v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost)) + (v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost)) + (v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost)) + (v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost)) + (v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost)) + v_plan_aux_arc_cost.arc_cost))::numeric(14,2)) +
                    CASE
                        WHEN (v_plan_aux_arc_connec.connec_total_cost IS NULL) THEN (0)::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END)
                END)::numeric(14,2) AS total_budget,
            v_plan_aux_arc_cost.the_geom
           FROM ((v_plan_aux_arc_cost
             JOIN arc ON (((arc.arc_id)::text = (v_plan_aux_arc_cost.arc_id)::text)))
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    ((p.price * (count(*))::numeric))::numeric(12,2) AS connec_total_cost
                   FROM (((v_edit_connec c
                     JOIN arc arc_1 USING (arc_id))
                     JOIN cat_arc ON (((cat_arc.id)::text = (arc_1.arccat_id)::text)))
                     LEFT JOIN v_price_compost p ON ((cat_arc.connect_cost = (p.id)::text)))
                  WHERE (c.arc_id IS NOT NULL)
                  GROUP BY c.arc_id, p.price) v_plan_aux_arc_connec ON (((v_plan_aux_arc_connec.arc_id)::text = (v_plan_aux_arc_cost.arc_id)::text)))) d
  WHERE (d.arc_id IS NOT NULL);


--
-- Name: v_price_x_catnode; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catnode AS
 SELECT cat_node.id,
    cat_node.estimated_depth,
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
            v_node.elevation AS top_elev,
            (v_node.elevation - v_node.depth) AS elev,
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
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'u'::text) THEN (
                    CASE
                        WHEN ((v_node.sys_type)::text = 'PUMP'::text) THEN
                        CASE
                            WHEN (man_pump.pump_number IS NOT NULL) THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END)::numeric
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm3'::text) THEN
                    CASE
                        WHEN ((v_node.sys_type)::text = 'TANK'::text) THEN man_tank.vmax
                        ELSE NULL::numeric
                    END
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm'::text) THEN
                    CASE
                        WHEN (v_node.depth = (0)::numeric) THEN v_price_x_catnode.estimated_depth
                        WHEN (v_node.depth IS NULL) THEN v_price_x_catnode.estimated_depth
                        ELSE v_node.depth
                    END
                    ELSE NULL::numeric
                END)::numeric(12,2) AS measurement,
            (
                CASE
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'u'::text) THEN ((
                    CASE
                        WHEN ((v_node.sys_type)::text = 'PUMP'::text) THEN
                        CASE
                            WHEN (man_pump.pump_number IS NOT NULL) THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END)::numeric * v_price_x_catnode.cost)
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm3'::text) THEN (
                    CASE
                        WHEN ((v_node.sys_type)::text = 'TANK'::text) THEN man_tank.vmax
                        ELSE NULL::numeric
                    END * v_price_x_catnode.cost)
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm'::text) THEN (
                    CASE
                        WHEN (v_node.depth = (0)::numeric) THEN v_price_x_catnode.estimated_depth
                        WHEN (v_node.depth IS NULL) THEN v_price_x_catnode.estimated_depth
                        ELSE v_node.depth
                    END * v_price_x_catnode.cost)
                    ELSE NULL::numeric
                END)::numeric(12,2) AS budget,
            v_node.the_geom
           FROM (((((v_node
             LEFT JOIN v_price_x_catnode ON (((v_node.nodecat_id)::text = (v_price_x_catnode.id)::text)))
             LEFT JOIN man_tank ON (((man_tank.node_id)::text = (v_node.node_id)::text)))
             LEFT JOIN man_pump ON (((man_pump.node_id)::text = (v_node.node_id)::text)))
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
    cat_arc.arctype_id,
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
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_arc.arctype_id)::text)))
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
    cat_connec.connectype_id,
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
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_connec.connectype_id)::text)))
  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_link AS
 SELECT row_number() OVER () AS rid,
    link.link_id,
    plan_psector_x_connec.psector_id,
    connec.connec_id,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    link.the_geom
   FROM selector_psector,
    ((connec
     JOIN plan_psector_x_connec USING (connec_id))
     JOIN link ON (((link.feature_id)::text = (connec.connec_id)::text)))
  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_node AS
 SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    cat_node.nodetype_id,
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
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_node.nodetype_id)::text)))
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
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.state,
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
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.state,
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
-- Name: v_rpt_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc AS
 SELECT arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.sector_id,
    arc.arccat_id,
    max(rpt_arc.flow) AS flow_max,
    min(rpt_arc.flow) AS flow_min,
    avg(rpt_arc.flow) AS flow_avg,
    max(rpt_arc.vel) AS vel_max,
    min(rpt_arc.vel) AS vel_min,
    avg(rpt_arc.vel) AS vel_avg,
    max(rpt_arc.headloss) AS headloss_max,
    min(rpt_arc.headloss) AS headloss_min,
    (max(((rpt_arc.headloss)::double precision / ((public.st_length2d(arc.the_geom) * (10)::double precision) + (0.1)::double precision))))::numeric(12,2) AS uheadloss_max,
    (min(((rpt_arc.headloss)::double precision / ((public.st_length2d(arc.the_geom) * (10)::double precision) + (0.1)::double precision))))::numeric(12,2) AS uheadloss_min,
    max(rpt_arc.setting) AS setting_max,
    min(rpt_arc.setting) AS setting_min,
    max(rpt_arc.reaction) AS reaction_max,
    min(rpt_arc.reaction) AS reaction_min,
    max(rpt_arc.ffactor) AS ffactor_max,
    min(rpt_arc.ffactor) AS ffactor_min,
    arc.the_geom
   FROM selector_rpt_main,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_main.result_id)::text))
  GROUP BY arc.arc_id, arc.arc_type, arc.sector_id, arc.arccat_id, selector_rpt_main.result_id, arc.the_geom
  ORDER BY arc.arc_id;


--
-- Name: v_rpt_arc_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc_all AS
 SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.sector_id,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    ((now())::date + (rpt_arc."time")::interval) AS "time",
    arc.the_geom
   FROM selector_rpt_main,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_arc.setting, arc.arc_id;


--
-- Name: v_rpt_arc_hourly; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc_hourly AS
 SELECT rpt_arc.id,
    arc.arc_id,
    arc.sector_id,
    selector_rpt_main.result_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    rpt_arc."time",
    arc.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_main.result_id)::text) AND ((rpt_arc."time")::text = (selector_rpt_main_tstep.timestep)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_arc."time", arc.arc_id;


--
-- Name: v_rpt_comp_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_arc AS
 SELECT arc.arc_id,
    arc.sector_id,
    selector_rpt_compare.result_id,
    max(rpt_arc.flow) AS max_flow,
    min(rpt_arc.flow) AS min_flow,
    max(rpt_arc.vel) AS max_vel,
    min(rpt_arc.vel) AS min_vel,
    max(rpt_arc.headloss) AS max_headloss,
    min(rpt_arc.headloss) AS min_headloss,
    (max(((rpt_arc.headloss)::double precision / ((public.st_length2d(arc.the_geom) * (10)::double precision) + (0.1)::double precision))))::numeric(12,2) AS max_uheadloss,
    (min(((rpt_arc.headloss)::double precision / ((public.st_length2d(arc.the_geom) * (10)::double precision) + (0.1)::double precision))))::numeric(12,2) AS min_uheadloss,
    max(rpt_arc.setting) AS max_setting,
    min(rpt_arc.setting) AS min_setting,
    max(rpt_arc.reaction) AS max_reaction,
    min(rpt_arc.reaction) AS min_reaction,
    max(rpt_arc.ffactor) AS max_ffactor,
    min(rpt_arc.ffactor) AS min_ffactor,
    arc.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_compare.result_id)::text))
  GROUP BY arc.arc_id, arc.sector_id, arc.arc_type, arc.arccat_id, selector_rpt_compare.result_id, arc.the_geom
  ORDER BY arc.arc_id;


--
-- Name: v_rpt_comp_arc_hourly; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_arc_hourly AS
 SELECT rpt_arc.id,
    arc.arc_id,
    arc.sector_id,
    selector_rpt_compare.result_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    rpt_arc."time",
    arc.the_geom
   FROM selector_rpt_compare,
    selector_rpt_main_tstep,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_compare.result_id)::text) AND ((rpt_arc."time")::text = (selector_rpt_main_tstep.timestep)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_energy_usage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_energy_usage AS
 SELECT rpt_energy_usage.id,
    rpt_energy_usage.result_id,
    rpt_energy_usage.nodarc_id,
    rpt_energy_usage.usage_fact,
    rpt_energy_usage.avg_effic,
    rpt_energy_usage.kwhr_mgal,
    rpt_energy_usage.avg_kw,
    rpt_energy_usage.peak_kw,
    rpt_energy_usage.cost_day
   FROM rpt_energy_usage,
    selector_rpt_compare
  WHERE (((selector_rpt_compare.result_id)::text = (rpt_energy_usage.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_hydraulic_status; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_hydraulic_status AS
 SELECT rpt_hydraulic_status.id,
    rpt_hydraulic_status.result_id,
    rpt_hydraulic_status."time",
    rpt_hydraulic_status.text
   FROM rpt_hydraulic_status,
    selector_rpt_compare
  WHERE (((selector_rpt_compare.result_id)::text = (rpt_hydraulic_status.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_node AS
 SELECT node.node_id,
    selector_rpt_compare.result_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS max_demand,
    min(rpt_node.demand) AS min_demand,
    max(rpt_node.head) AS max_head,
    min(rpt_node.head) AS min_head,
    max(rpt_node.press) AS max_pressure,
    min(rpt_node.press) AS min_pressure,
    avg(rpt_node.press) AS avg_pressure,
    max(rpt_node.quality) AS max_quality,
    min(rpt_node.quality) AS min_quality,
    node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_compare.result_id)::text))
  GROUP BY node.node_id, node.node_type, node.sector_id, node.nodecat_id, selector_rpt_compare.result_id, node.the_geom
  ORDER BY node.node_id;


--
-- Name: v_rpt_comp_node_hourly; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_node_hourly AS
 SELECT rpt_node.id,
    node.node_id,
    node.sector_id,
    selector_rpt_compare.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    rpt_node."time",
    node.the_geom
   FROM selector_rpt_compare,
    selector_rpt_main_tstep,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_compare.result_id)::text) AND ((rpt_node."time")::text = (selector_rpt_main_tstep.timestep)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_energy_usage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_energy_usage AS
SELECT
    NULL::integer AS id,
    NULL::character varying(30) AS result_id,
    NULL::character varying(16) AS nodarc_id,
    NULL::numeric AS usage_fact,
    NULL::numeric AS avg_effic,
    NULL::numeric AS kwhr_mgal,
    NULL::numeric AS avg_kw,
    NULL::numeric AS peak_kw,
    NULL::numeric AS cost_day;


--
-- Name: v_rpt_hydraulic_status; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_hydraulic_status AS
SELECT
    NULL::integer AS id,
    NULL::character varying(30) AS result_id,
    NULL::character varying(20) AS "time",
    NULL::text AS text;


--
-- Name: v_rpt_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node AS
 SELECT node.node_id,
    selector_rpt_main.result_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS demand_max,
    min(rpt_node.demand) AS demand_min,
    avg(rpt_node.demand) AS demand_avg,
    max(rpt_node.head) AS head_max,
    min(rpt_node.head) AS head_min,
    avg(rpt_node.head) AS head_avg,
    max(rpt_node.press) AS press_max,
    min(rpt_node.press) AS press_min,
    avg(rpt_node.press) AS press_avg,
    max(rpt_node.quality) AS quality_max,
    min(rpt_node.quality) AS quality_min,
    avg(rpt_node.quality) AS quality_avg,
    node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_main.result_id)::text))
  GROUP BY node.node_id, node.node_type, node.sector_id, node.nodecat_id, selector_rpt_main.result_id, node.the_geom
  ORDER BY node.node_id;


--
-- Name: v_rpt_node_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node_all AS
 SELECT rpt_node.id,
    node.node_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    selector_rpt_main.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    ((now())::date + (rpt_node."time")::interval) AS "time",
    node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_node.press, node.node_id;


--
-- Name: v_rpt_node_hourly; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node_hourly AS
 SELECT rpt_node.id,
    node.node_id,
    node.sector_id,
    selector_rpt_main.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    rpt_node."time",
    node.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_main.result_id)::text) AND ((rpt_node."time")::text = (selector_rpt_main_tstep.timestep)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_node."time", node.node_id;


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
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
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
-- Name: v_ui_arc_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_arc_x_node AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    public.st_x(a.the_geom) AS x1,
    public.st_y(a.the_geom) AS y1,
    v_arc.node_2,
    public.st_x(b.the_geom) AS x2,
    public.st_y(b.the_geom) AS y2
   FROM ((v_arc
     LEFT JOIN node a ON (((a.node_id)::text = (v_arc.node_1)::text)))
     LEFT JOIN node b ON (((b.node_id)::text = (v_arc.node_2)::text)));


--
-- Name: v_ui_arc_x_relations; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_arc_x_relations AS
 SELECT (row_number() OVER (ORDER BY v_node.node_id) + 1000000) AS rid,
    v_node.arc_id,
    v_node.nodetype_id AS featurecat_id,
    v_node.nodecat_id AS catalog,
    v_node.node_id AS feature_id,
    v_node.code AS feature_code,
    v_node.sys_type,
    v_arc.state AS arc_state,
    v_node.state AS feature_state,
    public.st_x(v_node.the_geom) AS x,
    public.st_y(v_node.the_geom) AS y,
    'v_edit_node'::text AS sys_table_id
   FROM (v_node
     JOIN v_arc ON (((v_arc.arc_id)::text = (v_node.arc_id)::text)))
  WHERE (v_node.arc_id IS NOT NULL)
UNION
 SELECT (row_number() OVER () + 2000000) AS rid,
    v_arc.arc_id,
    v_connec.connectype_id AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    v_arc.state AS arc_state,
    v_connec.state AS feature_state,
    public.st_x(v_connec.the_geom) AS x,
    public.st_y(v_connec.the_geom) AS y,
    'v_edit_connec'::text AS sys_table_id
   FROM (v_connec
     JOIN v_arc ON (((v_arc.arc_id)::text = (v_connec.arc_id)::text)))
  WHERE (v_connec.arc_id IS NOT NULL);


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
-- Name: v_ui_mincut; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_mincut AS
 SELECT om_mincut.id,
    om_mincut.id AS name,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    exploitation.name AS exploitation,
    ext_municipality.name AS municipality,
    om_mincut.postcode,
    ext_streetaxis.name AS streetaxis,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    cat_users.name AS assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output
   FROM ((((((((om_mincut
     LEFT JOIN om_typevalue a ON ((((a.id)::integer = om_mincut.mincut_state) AND (a.typevalue = 'mincut_state'::text))))
     LEFT JOIN om_typevalue b ON ((((b.id)::integer = om_mincut.mincut_class) AND (b.typevalue = 'mincut_class'::text))))
     LEFT JOIN om_typevalue c ON ((((c.id)::integer = (om_mincut.anl_cause)::integer) AND (c.typevalue = 'mincut_cause'::text))))
     LEFT JOIN exploitation ON ((exploitation.expl_id = om_mincut.expl_id)))
     LEFT JOIN macroexploitation ON ((macroexploitation.macroexpl_id = om_mincut.macroexpl_id)))
     LEFT JOIN ext_municipality ON ((ext_municipality.muni_id = om_mincut.muni_id)))
     LEFT JOIN ext_streetaxis ON (((ext_streetaxis.id)::text = (om_mincut.streetaxis_id)::text)))
     LEFT JOIN cat_users ON (((cat_users.id)::text = (om_mincut.assigned_to)::text)))
  WHERE (om_mincut.id > 0);


--
-- Name: v_ui_mincut_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_mincut_connec AS
 SELECT om_mincut_connec.id,
    om_mincut_connec.connec_id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut_cat_type.virtual,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN (om_mincut.mincut_state = 0) THEN (om_mincut.forecast_start)::timestamp with time zone
            WHEN (om_mincut.mincut_state = 1) THEN now()
            WHEN (om_mincut.mincut_state = 2) THEN (om_mincut.exec_start)::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN (om_mincut.mincut_state = 0) THEN (om_mincut.forecast_end)::timestamp with time zone
            WHEN (om_mincut.mincut_state = 1) THEN now()
            WHEN (om_mincut.mincut_state = 2) THEN (om_mincut.exec_end)::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date
   FROM ((om_mincut_connec
     JOIN om_mincut ON ((om_mincut_connec.result_id = om_mincut.id)))
     JOIN om_mincut_cat_type ON (((om_mincut.mincut_type)::text = (om_mincut_cat_type.id)::text)));


--
-- Name: v_ui_mincut_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_mincut_hydrometer AS
 SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.hydrometer_id,
    rtc_hydrometer_x_connec.connec_id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN (om_mincut.mincut_state = 0) THEN (om_mincut.forecast_start)::timestamp with time zone
            WHEN (om_mincut.mincut_state = 1) THEN now()
            WHEN (om_mincut.mincut_state = 2) THEN (om_mincut.exec_start)::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN (om_mincut.mincut_state = 0) THEN (om_mincut.forecast_end)::timestamp with time zone
            WHEN (om_mincut.mincut_state = 1) THEN now()
            WHEN (om_mincut.mincut_state = 2) THEN (om_mincut.exec_end)::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date
   FROM ((om_mincut_hydrometer
     JOIN om_mincut ON ((om_mincut_hydrometer.result_id = om_mincut.id)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (om_mincut_hydrometer.hydrometer_id)::bigint)));


--
-- Name: v_ui_node_x_relations; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_node_x_relations AS
 SELECT row_number() OVER (ORDER BY v_node.node_id) AS rid,
    v_node.parent_id AS node_id,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.node_id AS child_id,
    v_node.code,
    v_node.sys_type,
    'v_edit_node'::text AS sys_table_id
   FROM v_node
  WHERE (v_node.parent_id IS NOT NULL);


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
            a.id,
            a.arctype_id,
            a.matcat_id,
            a.pnom,
            a.dnom,
            a.dint,
            a.dext,
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
            a.shape,
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
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM (((p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM ((p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id))
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
    rpt_cat_result.iscorporate,
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
  WHERE ((arc.state = 1) AND (arc.workcat_id IS NOT NULL))
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
  WHERE ((node.state = 1) AND (node.workcat_id IS NOT NULL))
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
  WHERE ((connec.state = 1) AND (connec.workcat_id IS NOT NULL))
UNION
 SELECT (row_number() OVER (ORDER BY element.element_id) + 4000000) AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM (element
     JOIN exploitation ON ((exploitation.expl_id = element.expl_id)))
  WHERE ((element.state = 1) AND (element.workcat_id IS NOT NULL));


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
  WHERE (v_edit_element.state = 0);


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
-- Name: v_value_cat_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_value_cat_connec AS
 SELECT cat_connec.id,
    cat_connec.connectype_id AS connec_type,
    cat_feature_connec.type
   FROM (cat_connec
     JOIN cat_feature_connec ON (((cat_feature_connec.id)::text = (cat_connec.connectype_id)::text)));


--
-- Name: v_value_cat_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_value_cat_node AS
 SELECT cat_node.id,
    cat_node.nodetype_id,
    cat_feature_node.type
   FROM (cat_node
     JOIN cat_feature_node ON (((cat_feature_node.id)::text = (cat_node.nodetype_id)::text)));


--
-- Name: ve_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.arccat_id,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.cat_matcat_id,
    v_arc.cat_pnom,
    v_arc.cat_dnom,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.sector_name,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.minsector_id,
    v_arc.dma_id,
    v_arc.dma_name,
    v_arc.macrodma_id,
    v_arc.presszone_id,
    v_arc.presszone_name,
    v_arc.dqa_id,
    v_arc.dqa_name,
    v_arc.macrodqa_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
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
    v_arc.num_value,
    v_arc.cat_arctype_id,
    v_arc.nodetype_1,
    v_arc.staticpress1,
    v_arc.nodetype_2,
    v_arc.staticpress2,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom,
    v_arc.depth,
    v_arc.adate,
    v_arc.adescript,
    v_arc.dma_style,
    v_arc.presszone_style,
    v_arc.workcat_id_plan,
    v_arc.asset_id,
    v_arc.pavcat_id,
    v_arc.om_state,
    v_arc.conserv_state,
    v_arc.flow_max,
    v_arc.flow_min,
    v_arc.flow_avg,
    v_arc.vel_max,
    v_arc.vel_min,
    v_arc.vel_avg,
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
    v_connec.elevation,
    v_connec.depth,
    v_connec.connec_type,
    v_connec.sys_type,
    v_connec.connecat_id,
    v_connec.expl_id,
    v_connec.macroexpl_id,
    v_connec.sector_id,
    v_connec.sector_name,
    v_connec.macrosector_id,
    v_connec.customer_code,
    v_connec.cat_matcat_id,
    v_connec.cat_pnom,
    v_connec.cat_dnom,
    v_connec.connec_length,
    v_connec.state,
    v_connec.state_type,
    v_connec.n_hydrometer,
    v_connec.arc_id,
    v_connec.annotation,
    v_connec.observ,
    v_connec.comment,
    v_connec.minsector_id,
    v_connec.dma_id,
    v_connec.dma_name,
    v_connec.macrodma_id,
    v_connec.presszone_id,
    v_connec.presszone_name,
    v_connec.staticpressure,
    v_connec.dqa_id,
    v_connec.dqa_name,
    v_connec.macrodqa_id,
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
    v_connec.publish,
    v_connec.inventory,
    v_connec.num_value,
    v_connec.connectype_id,
    v_connec.pjoint_id,
    v_connec.pjoint_type,
    v_connec.tstamp,
    v_connec.insert_user,
    v_connec.lastupdate,
    v_connec.lastupdate_user,
    v_connec.the_geom,
    v_connec.adate,
    v_connec.adescript,
    v_connec.accessibility,
    v_connec.workcat_id_plan,
    v_connec.asset_id,
    v_connec.dma_style,
    v_connec.presszone_style,
    v_connec.epa_type,
    v_connec.priority,
    v_connec.valve_location,
    v_connec.valve_type,
    v_connec.shutoff_valve,
    v_connec.access_type,
    v_connec.placement_type,
    v_connec.press_max,
    v_connec.press_min,
    v_connec.press_avg,
    v_connec.demand,
    v_connec.om_state,
    v_connec.conserv_state,
    v_connec.crmzone_id,
    v_connec.crmzone_name,
    v_connec.expl_id2,
    v_connec.quality_max,
    v_connec.quality_min,
    v_connec.quality_avg
   FROM v_connec;


--
-- Name: ve_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_node AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.expl_id,
    v_node.macroexpl_id,
    v_node.sector_id,
    v_node.sector_name,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.minsector_id,
    v_node.dma_id,
    v_node.dma_name,
    v_node.macrodma_id,
    v_node.presszone_id,
    v_node.presszone_name,
    v_node.staticpressure,
    v_node.dqa_id,
    v_node.dqa_name,
    v_node.macrodqa_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.buildercat_id,
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
    v_node.undelete,
    v_node.label,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.hemisphere,
    v_node.num_value,
    v_node.nodetype_id,
    v_node.tstamp,
    v_node.insert_user,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.the_geom,
    v_node.adate,
    v_node.adescript,
    v_node.accessibility,
    v_node.dma_style,
    v_node.presszone_style,
    v_node.workcat_id_plan,
    v_node.asset_id,
    v_node.om_state,
    v_node.conserv_state,
    v_node.access_type,
    v_node.placement_type,
    v_node.demand_max,
    v_node.demand_min,
    v_node.demand_avg,
    v_node.press_max,
    v_node.press_min,
    v_node.press_avg,
    v_node.head_max,
    v_node.head_min,
    v_node.head_avg,
    v_node.quality_max,
    v_node.quality_min,
    v_node.quality_avg,
    v_node.expl_id2
   FROM v_node;


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
-- Name: ve_pol_fountain; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_fountain AS
 SELECT polygon.pol_id,
    polygon.feature_id AS connec_id,
    polygon.the_geom
   FROM (v_connec
     JOIN polygon ON (((polygon.feature_id)::text = (v_connec.connec_id)::text)))
  WHERE ((polygon.sys_type)::text = 'FOUNTAIN'::text);


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
   FROM (((node
     JOIN v_state_node USING (node_id))
     JOIN v_expl_node USING (node_id))
     JOIN polygon ON (((polygon.feature_id)::text = (node.node_id)::text)));


--
-- Name: ve_pol_register; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_register AS
 SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM (v_node
     JOIN polygon ON (((polygon.feature_id)::text = (v_node.node_id)::text)))
  WHERE ((polygon.sys_type)::text = 'REGISTER'::text);


--
-- Name: ve_pol_tank; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_tank AS
 SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM (v_node
     JOIN polygon ON (((polygon.feature_id)::text = (v_node.node_id)::text)))
  WHERE ((polygon.sys_type)::text = 'TANK'::text);


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
-- Name: vi_backdrop; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_backdrop AS
 SELECT inp_backdrop.text
   FROM inp_backdrop;


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
-- Name: vi_curves; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_curves AS
 SELECT
        CASE
            WHEN (a.x_value IS NULL) THEN (a.curve_type)::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    (a.x_value)::numeric(12,4) AS x_value,
    (a.y_value)::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( SELECT row_number() OVER (ORDER BY a_1.id) AS rid,
            a_1.id,
            a_1.curve_id,
            a_1.curve_type,
            a_1.x_value,
            a_1.y_value
           FROM ( SELECT DISTINCT ON (inp_curve_value.curve_id) ( SELECT min(sub.id) AS min
                           FROM inp_curve_value sub
                          WHERE ((sub.curve_id)::text = (inp_curve_value.curve_id)::text)) AS id,
                    inp_curve_value.curve_id,
                    concat(';', inp_curve.curve_type, ':', inp_curve.descript) AS curve_type,
                    NULL::numeric AS x_value,
                    NULL::numeric AS y_value
                   FROM (inp_curve
                     JOIN inp_curve_value ON (((inp_curve_value.curve_id)::text = (inp_curve.id)::text)))
                UNION
                 SELECT inp_curve_value.id,
                    inp_curve_value.curve_id,
                    inp_curve.curve_type,
                    inp_curve_value.x_value,
                    inp_curve_value.y_value
                   FROM (inp_curve_value
                     JOIN inp_curve ON (((inp_curve_value.curve_id)::text = (inp_curve.id)::text)))
          ORDER BY 1, 4 DESC) a_1) a
  WHERE ((a.curve_id)::text IN ( SELECT ((temp_node.addparam)::json ->> 'curve_id'::text)
           FROM temp_node
        UNION
         SELECT ((temp_arc.addparam)::json ->> 'curve_id'::text)
           FROM temp_arc))
  ORDER BY a.rid, NULL::text;


--
-- Name: vi_demands; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_demands AS
 SELECT temp_demand.feature_id,
    temp_demand.demand,
    temp_demand.pattern_id,
    concat(';', temp_demand.dscenario_id, ' ', temp_demand.source, ' ', temp_demand.demand_type) AS other
   FROM (temp_demand
     JOIN temp_node ON (((temp_demand.feature_id)::text = (temp_node.node_id)::text)))
  ORDER BY temp_demand.feature_id, (concat(';', temp_demand.dscenario_id, ' ', temp_demand.source, ' ', temp_demand.demand_type));


--
-- Name: vi_emitters; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_emitters AS
 SELECT inp_emitter.node_id,
    inp_emitter.coef
   FROM (inp_emitter
     JOIN temp_node t USING (node_id))
  WHERE (NOT ((t.node_id)::text IN ( SELECT anl_node.node_id
           FROM anl_node
          WHERE ((anl_node.fid = 232) AND ((anl_node.cur_user)::text = CURRENT_USER)))));


--
-- Name: vi_energy; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_energy AS
 SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
    inp_typevalue.idval,
    inp_pump.energyvalue
   FROM selector_inp_result,
    ((inp_pump
     JOIN rpt_inp_arc ON ((concat(inp_pump.node_id, '_n2a') = (rpt_inp_arc.arc_id)::text)))
     LEFT JOIN inp_typevalue ON ((((inp_pump.energyparam)::text = (inp_typevalue.id)::text) AND ((inp_typevalue.typevalue)::text = 'inp_value_param_energy'::text))))
  WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND (inp_pump.energyparam IS NOT NULL))
UNION
 SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
    inp_pump_additional.energyparam AS idval,
    inp_pump_additional.energyvalue
   FROM selector_inp_result,
    (inp_pump_additional
     JOIN rpt_inp_arc ON ((concat(inp_pump_additional.node_id, '_n2a') = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND (inp_pump_additional.energyparam IS NOT NULL))
UNION
 SELECT inp_energy.descript AS pump_id,
    NULL::character varying AS idval,
    NULL::character varying AS energyvalue
   FROM inp_energy;


--
-- Name: vi_junctions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_junctions AS
 SELECT temp_node.node_id,
        CASE
            WHEN (temp_node.elev IS NOT NULL) THEN temp_node.elev
            ELSE temp_node.elevation
        END AS elevation,
    temp_node.demand,
    temp_node.pattern_id,
    concat(';', temp_node.sector_id, ' ', COALESCE(temp_node.presszone_id, '0'::text), ' ', COALESCE(temp_node.dma_id, 0), ' ', COALESCE(temp_node.dqa_id, 0), ' ', COALESCE(temp_node.minsector_id, 0), ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE ((temp_node.epa_type)::text <> ALL (ARRAY[('RESERVOIR'::character varying)::text, ('TANK'::character varying)::text]))
  ORDER BY temp_node.node_id;


--
-- Name: vi_labels; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_labels AS
 SELECT inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.node_id
   FROM inp_label;


--
-- Name: vi_mixing; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_mixing AS
 SELECT inp_mixing.node_id,
    inp_mixing.mix_type,
    inp_mixing.value
   FROM selector_inp_result,
    (inp_mixing
     JOIN rpt_inp_node ON (((inp_mixing.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_inp_node.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text));


--
-- Name: vi_options; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_options AS
 SELECT a.parameter,
    a.value
   FROM ( SELECT a_1.parameter,
            a_1.value,
                CASE
                    WHEN (a_1.parameter = 'UNITS'::text) THEN 1
                    ELSE 2
                END AS t
           FROM ( SELECT a_1_1.idval AS parameter,
                        CASE
                            WHEN ((a_1_1.idval = 'UNBALANCED'::text) AND (b.value = 'CONTINUE'::text)) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE (((config_param_user.parameter)::text = 'inp_options_unbalanced_n'::text) AND ((config_param_user.cur_user)::name = "current_user"()))))
                            WHEN ((a_1_1.idval = 'QUALITY'::text) AND (b.value = 'TRACE'::text)) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE (((config_param_user.parameter)::text = 'inp_options_node_id'::text) AND ((config_param_user.cur_user)::name = "current_user"()))))
                            WHEN ((a_1_1.idval = 'HYDRAULICS'::text) AND ((b.value = 'USE'::text) OR (b.value = 'SAVE'::text))) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE (((config_param_user.parameter)::text = 'inp_options_hydraulics_fname'::text) AND ((config_param_user.cur_user)::name = "current_user"()))))
                            WHEN ((a_1_1.idval = 'HYDRAULICS'::text) AND (b.value = 'NONE'::text)) THEN NULL::text
                            ELSE b.value
                        END AS value
                   FROM (sys_param_user a_1_1
                     JOIN config_param_user b ON ((a_1_1.id = (b.parameter)::text)))
                  WHERE ((a_1_1.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text])) AND (a_1_1.idval <> ALL (ARRAY['UNBALANCED_N'::text, 'NODE_ID'::text, 'HYDRAULICS_FNAME'::text])) AND ((b.cur_user)::name = "current_user"()) AND (b.value IS NOT NULL) AND (a_1_1.idval <> 'VALVE_MODE_MINCUT_RESULT'::text) AND ((b.parameter)::text <> 'PATTERN'::text) AND (b.value <> 'NULLVALUE'::text))) a_1
          WHERE ((a_1.parameter <> 'HYDRAULICS'::text) OR ((a_1.parameter = 'HYDRAULICS'::text) AND (a_1.value IS NOT NULL)))) a
  ORDER BY a.t;


--
-- Name: vi_parent_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.arccat_id,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.cat_matcat_id,
    v_arc.cat_pnom,
    v_arc.cat_dnom,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.sector_name,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.minsector_id,
    v_arc.dma_id,
    v_arc.dma_name,
    v_arc.macrodma_id,
    v_arc.presszone_id,
    v_arc.presszone_name,
    v_arc.dqa_id,
    v_arc.dqa_name,
    v_arc.macrodqa_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
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
    v_arc.num_value,
    v_arc.cat_arctype_id,
    v_arc.nodetype_1,
    v_arc.staticpress1,
    v_arc.nodetype_2,
    v_arc.staticpress2,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom
   FROM v_arc,
    selector_sector
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: vi_parent_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_connec AS
 SELECT ve_connec.connec_id,
    ve_connec.code,
    ve_connec.elevation,
    ve_connec.depth,
    ve_connec.connec_type,
    ve_connec.sys_type,
    ve_connec.connecat_id,
    ve_connec.expl_id,
    ve_connec.macroexpl_id,
    ve_connec.sector_id,
    ve_connec.sector_name,
    ve_connec.macrosector_id,
    ve_connec.customer_code,
    ve_connec.cat_matcat_id,
    ve_connec.cat_pnom,
    ve_connec.cat_dnom,
    ve_connec.connec_length,
    ve_connec.state,
    ve_connec.state_type,
    ve_connec.n_hydrometer,
    ve_connec.arc_id,
    ve_connec.annotation,
    ve_connec.observ,
    ve_connec.comment,
    ve_connec.minsector_id,
    ve_connec.dma_id,
    ve_connec.dma_name,
    ve_connec.macrodma_id,
    ve_connec.presszone_id,
    ve_connec.presszone_name,
    ve_connec.staticpressure,
    ve_connec.dqa_id,
    ve_connec.dqa_name,
    ve_connec.macrodqa_id,
    ve_connec.soilcat_id,
    ve_connec.function_type,
    ve_connec.category_type,
    ve_connec.fluid_type,
    ve_connec.location_type,
    ve_connec.workcat_id,
    ve_connec.workcat_id_end,
    ve_connec.buildercat_id,
    ve_connec.builtdate,
    ve_connec.enddate,
    ve_connec.ownercat_id,
    ve_connec.muni_id,
    ve_connec.postcode,
    ve_connec.district_id,
    ve_connec.streetname,
    ve_connec.postnumber,
    ve_connec.postcomplement,
    ve_connec.streetname2,
    ve_connec.postnumber2,
    ve_connec.postcomplement2,
    ve_connec.descript,
    ve_connec.svg,
    ve_connec.rotation,
    ve_connec.link,
    ve_connec.verified,
    ve_connec.undelete,
    ve_connec.label,
    ve_connec.label_x,
    ve_connec.label_y,
    ve_connec.label_rotation,
    ve_connec.publish,
    ve_connec.inventory,
    ve_connec.num_value,
    ve_connec.connectype_id,
    ve_connec.pjoint_id,
    ve_connec.pjoint_type,
    ve_connec.tstamp,
    ve_connec.insert_user,
    ve_connec.lastupdate,
    ve_connec.lastupdate_user,
    ve_connec.the_geom
   FROM ve_connec,
    selector_sector
  WHERE ((ve_connec.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: vi_parent_dma; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_dma AS
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
   FROM (dma
     JOIN vi_parent_arc USING (dma_id));


--
-- Name: vi_parent_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_hydrometer AS
 SELECT v_rtc_hydrometer.hydrometer_id,
    v_rtc_hydrometer.hydrometer_customer_code,
    v_rtc_hydrometer.connec_id,
    v_rtc_hydrometer.connec_customer_code,
    v_rtc_hydrometer.state,
    v_rtc_hydrometer.muni_name,
    v_rtc_hydrometer.expl_id,
    v_rtc_hydrometer.expl_name,
    v_rtc_hydrometer.plot_code,
    v_rtc_hydrometer.priority_id,
    v_rtc_hydrometer.catalog_id,
    v_rtc_hydrometer.category_id,
    v_rtc_hydrometer.hydro_number,
    v_rtc_hydrometer.hydro_man_date,
    v_rtc_hydrometer.crm_number,
    v_rtc_hydrometer.customer_name,
    v_rtc_hydrometer.address1,
    v_rtc_hydrometer.address2,
    v_rtc_hydrometer.address3,
    v_rtc_hydrometer.address2_1,
    v_rtc_hydrometer.address2_2,
    v_rtc_hydrometer.address2_3,
    v_rtc_hydrometer.m3_volume,
    v_rtc_hydrometer.start_date,
    v_rtc_hydrometer.end_date,
    v_rtc_hydrometer.update_date,
    v_rtc_hydrometer.hydrometer_link
   FROM (v_rtc_hydrometer
     JOIN ve_connec USING (connec_id));


--
-- Name: vi_patterns; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_patterns AS
 SELECT a.pattern_id,
    a.factor_1,
    a.factor_2,
    a.factor_3,
    a.factor_4,
    a.factor_5,
    a.factor_6,
    a.factor_7,
    a.factor_8,
    a.factor_9,
    a.factor_10,
    a.factor_11,
    a.factor_12,
    a.factor_13,
    a.factor_14,
    a.factor_15,
    a.factor_16,
    a.factor_17,
    a.factor_18
   FROM rpt_inp_pattern_value a,
    selector_inp_result b
  WHERE (((a.result_id)::text = (b.result_id)::text) AND (b.cur_user = ("current_user"())::text))
  ORDER BY a.id;


--
-- Name: vi_pipes; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pipes AS
 SELECT temp_arc.arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
    temp_arc.length,
    temp_arc.diameter,
    temp_arc.roughness,
    temp_arc.minorloss,
    (temp_arc.status)::character varying(30) AS status,
    concat(';', temp_arc.sector_id, ' ', COALESCE(temp_arc.presszone_id, '0'::text), ' ', COALESCE(temp_arc.dma_id, 0), ' ', COALESCE(temp_arc.dqa_id, 0), ' ', COALESCE(temp_arc.minsector_id, 0), ' ', temp_arc.arccat_id) AS other
   FROM temp_arc
  WHERE ((temp_arc.epa_type)::text = ANY (ARRAY[('PIPE'::character varying)::text, ('SHORTPIPE'::character varying)::text, ('NODE2NODE'::character varying)::text]));


--
-- Name: vi_pjoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pjoint AS
 SELECT v_edit_inp_connec.pjoint_id,
    v_edit_inp_connec.pjoint_type,
    sum(v_edit_inp_connec.demand) AS sum
   FROM v_edit_inp_connec
  WHERE (v_edit_inp_connec.pjoint_id IS NOT NULL)
  GROUP BY v_edit_inp_connec.pjoint_id, v_edit_inp_connec.pjoint_type;


--
-- Name: vi_pjointpattern; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pjointpattern AS
 SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
    a.idrow,
    a.pattern_id,
    (sum(a.factor_1))::numeric(10,8) AS factor_1,
    (sum(a.factor_2))::numeric(10,8) AS factor_2,
    (sum(a.factor_3))::numeric(10,8) AS factor_3,
    (sum(a.factor_4))::numeric(10,8) AS factor_4,
    (sum(a.factor_5))::numeric(10,8) AS factor_5,
    (sum(a.factor_6))::numeric(10,8) AS factor_6,
    (sum(a.factor_7))::numeric(10,8) AS factor_7,
    (sum(a.factor_8))::numeric(10,8) AS factor_8,
    (sum(a.factor_9))::numeric(10,8) AS factor_9,
    (sum(a.factor_10))::numeric(10,8) AS factor_10,
    (sum(a.factor_11))::numeric(10,8) AS factor_11,
    (sum(a.factor_12))::numeric(10,8) AS factor_12,
    (sum(a.factor_13))::numeric(10,8) AS factor_13,
    (sum(a.factor_14))::numeric(10,8) AS factor_14,
    (sum(a.factor_15))::numeric(10,8) AS factor_15,
    (sum(a.factor_16))::numeric(10,8) AS factor_16,
    (sum(a.factor_17))::numeric(10,8) AS factor_17,
    (sum(a.factor_18))::numeric(10,8) AS factor_18
   FROM ( SELECT
                CASE
                    WHEN (b.id = ( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 1
                    WHEN (b.id = ( SELECT (min(sub.id) + 1)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 2
                    WHEN (b.id = ( SELECT (min(sub.id) + 2)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 3
                    WHEN (b.id = ( SELECT (min(sub.id) + 3)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 4
                    WHEN (b.id = ( SELECT (min(sub.id) + 4)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 5
                    WHEN (b.id = ( SELECT (min(sub.id) + 5)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 6
                    WHEN (b.id = ( SELECT (min(sub.id) + 6)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 7
                    WHEN (b.id = ( SELECT (min(sub.id) + 7)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 8
                    WHEN (b.id = ( SELECT (min(sub.id) + 8)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 9
                    WHEN (b.id = ( SELECT (min(sub.id) + 9)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 10
                    WHEN (b.id = ( SELECT (min(sub.id) + 10)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 11
                    WHEN (b.id = ( SELECT (min(sub.id) + 11)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 12
                    WHEN (b.id = ( SELECT (min(sub.id) + 12)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 13
                    WHEN (b.id = ( SELECT (min(sub.id) + 13)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 14
                    WHEN (b.id = ( SELECT (min(sub.id) + 14)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 15
                    WHEN (b.id = ( SELECT (min(sub.id) + 15)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 16
                    WHEN (b.id = ( SELECT (min(sub.id) + 16)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 17
                    WHEN (b.id = ( SELECT (min(sub.id) + 17)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 18
                    WHEN (b.id = ( SELECT (min(sub.id) + 18)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 19
                    WHEN (b.id = ( SELECT (min(sub.id) + 19)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 20
                    WHEN (b.id = ( SELECT (min(sub.id) + 20)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 21
                    WHEN (b.id = ( SELECT (min(sub.id) + 21)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 22
                    WHEN (b.id = ( SELECT (min(sub.id) + 22)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 23
                    WHEN (b.id = ( SELECT (min(sub.id) + 23)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 24
                    WHEN (b.id = ( SELECT (min(sub.id) + 24)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 25
                    WHEN (b.id = ( SELECT (min(sub.id) + 25)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 26
                    WHEN (b.id = ( SELECT (min(sub.id) + 26)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 27
                    WHEN (b.id = ( SELECT (min(sub.id) + 27)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 28
                    WHEN (b.id = ( SELECT (min(sub.id) + 28)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 29
                    WHEN (b.id = ( SELECT (min(sub.id) + 29)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 30
                    ELSE NULL::integer
                END AS idrow,
            c.pjoint_id AS pattern_id,
            sum(((c.demand)::double precision * (b.factor_1)::double precision)) AS factor_1,
            sum(((c.demand)::double precision * (b.factor_2)::double precision)) AS factor_2,
            sum(((c.demand)::double precision * (b.factor_3)::double precision)) AS factor_3,
            sum(((c.demand)::double precision * (b.factor_4)::double precision)) AS factor_4,
            sum(((c.demand)::double precision * (b.factor_5)::double precision)) AS factor_5,
            sum(((c.demand)::double precision * (b.factor_6)::double precision)) AS factor_6,
            sum(((c.demand)::double precision * (b.factor_7)::double precision)) AS factor_7,
            sum(((c.demand)::double precision * (b.factor_8)::double precision)) AS factor_8,
            sum(((c.demand)::double precision * (b.factor_9)::double precision)) AS factor_9,
            sum(((c.demand)::double precision * (b.factor_10)::double precision)) AS factor_10,
            sum(((c.demand)::double precision * (b.factor_11)::double precision)) AS factor_11,
            sum(((c.demand)::double precision * (b.factor_12)::double precision)) AS factor_12,
            sum(((c.demand)::double precision * (b.factor_13)::double precision)) AS factor_13,
            sum(((c.demand)::double precision * (b.factor_14)::double precision)) AS factor_14,
            sum(((c.demand)::double precision * (b.factor_15)::double precision)) AS factor_15,
            sum(((c.demand)::double precision * (b.factor_16)::double precision)) AS factor_16,
            sum(((c.demand)::double precision * (b.factor_17)::double precision)) AS factor_17,
            sum(((c.demand)::double precision * (b.factor_18)::double precision)) AS factor_18
           FROM (( SELECT inp_connec.connec_id,
                    inp_connec.demand,
                    inp_connec.pattern_id,
                    connec.pjoint_id
                   FROM (inp_connec
                     JOIN connec USING (connec_id))) c
             JOIN inp_pattern_value b USING (pattern_id))
          GROUP BY c.pjoint_id,
                CASE
                    WHEN (b.id = ( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 1
                    WHEN (b.id = ( SELECT (min(sub.id) + 1)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 2
                    WHEN (b.id = ( SELECT (min(sub.id) + 2)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 3
                    WHEN (b.id = ( SELECT (min(sub.id) + 3)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 4
                    WHEN (b.id = ( SELECT (min(sub.id) + 4)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 5
                    WHEN (b.id = ( SELECT (min(sub.id) + 5)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 6
                    WHEN (b.id = ( SELECT (min(sub.id) + 6)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 7
                    WHEN (b.id = ( SELECT (min(sub.id) + 7)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 8
                    WHEN (b.id = ( SELECT (min(sub.id) + 8)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 9
                    WHEN (b.id = ( SELECT (min(sub.id) + 9)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 10
                    WHEN (b.id = ( SELECT (min(sub.id) + 10)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 11
                    WHEN (b.id = ( SELECT (min(sub.id) + 11)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 12
                    WHEN (b.id = ( SELECT (min(sub.id) + 12)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 13
                    WHEN (b.id = ( SELECT (min(sub.id) + 13)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 14
                    WHEN (b.id = ( SELECT (min(sub.id) + 14)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 15
                    WHEN (b.id = ( SELECT (min(sub.id) + 15)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 16
                    WHEN (b.id = ( SELECT (min(sub.id) + 16)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 17
                    WHEN (b.id = ( SELECT (min(sub.id) + 17)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 18
                    WHEN (b.id = ( SELECT (min(sub.id) + 18)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 19
                    WHEN (b.id = ( SELECT (min(sub.id) + 19)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 20
                    WHEN (b.id = ( SELECT (min(sub.id) + 20)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 21
                    WHEN (b.id = ( SELECT (min(sub.id) + 21)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 22
                    WHEN (b.id = ( SELECT (min(sub.id) + 22)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 23
                    WHEN (b.id = ( SELECT (min(sub.id) + 23)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 24
                    WHEN (b.id = ( SELECT (min(sub.id) + 24)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 25
                    WHEN (b.id = ( SELECT (min(sub.id) + 25)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 26
                    WHEN (b.id = ( SELECT (min(sub.id) + 26)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 27
                    WHEN (b.id = ( SELECT (min(sub.id) + 27)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 28
                    WHEN (b.id = ( SELECT (min(sub.id) + 28)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 29
                    WHEN (b.id = ( SELECT (min(sub.id) + 29)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 30
                    ELSE NULL::integer
                END) a
  GROUP BY a.idrow, a.pattern_id;


--
-- Name: vi_valves; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_valves AS
 SELECT DISTINCT ON (a.arc_id) a.arc_id,
    a.node_1,
    a.node_2,
    a.diameter,
    a.valv_type,
    a.setting,
    a.minorloss,
    concat(';', a.sector_id, ' ', COALESCE(a.presszone_id, '0'::text), ' ', COALESCE(a.dma_id, 0), ' ', COALESCE(a.dqa_id, 0), ' ', COALESCE(a.minsector_id, 0), ' ', a.arccat_id) AS other
   FROM ( SELECT (temp_arc.arc_id)::text AS arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            (((temp_arc.addparam)::json ->> 'valv_type'::text))::character varying(18) AS valv_type,
            ((temp_arc.addparam)::json ->> 'pressure'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM temp_arc
          WHERE ((((temp_arc.addparam)::json ->> 'valv_type'::text) = 'PRV'::text) OR (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'PSV'::text) OR (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'PBV'::text))
        UNION
         SELECT temp_arc.arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            ((temp_arc.addparam)::json ->> 'valv_type'::text) AS valv_type,
            ((temp_arc.addparam)::json ->> 'flow'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM temp_arc
          WHERE (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'FCV'::text)
        UNION
         SELECT temp_arc.arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            ((temp_arc.addparam)::json ->> 'valv_type'::text) AS valv_type,
            ((temp_arc.addparam)::json ->> 'coef_loss'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM temp_arc
          WHERE (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'TCV'::text)
        UNION
         SELECT temp_arc.arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            ((temp_arc.addparam)::json ->> 'valv_type'::text) AS valv_type,
            ((temp_arc.addparam)::json ->> 'curve_id'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM temp_arc
          WHERE (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'GPV'::text)
        UNION
         SELECT temp_arc.arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            'PRV'::character varying(18) AS valv_type,
            ((temp_arc.addparam)::json ->> 'pressure'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM (temp_arc
             JOIN inp_pump ON (((temp_arc.arc_id)::text = concat(inp_pump.node_id, '_n2a_4'))))) a;


--
-- Name: vi_pumps; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pumps AS
 SELECT temp_arc.arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
        CASE
            WHEN (((temp_arc.addparam)::json ->> 'power'::text) <> ''::text) THEN (('POWER'::text || ' '::text) || ((temp_arc.addparam)::json ->> 'power'::text))
            ELSE NULL::text
        END AS power,
        CASE
            WHEN (((temp_arc.addparam)::json ->> 'curve_id'::text) <> ''::text) THEN (('HEAD'::text || ' '::text) || ((temp_arc.addparam)::json ->> 'curve_id'::text))
            ELSE NULL::text
        END AS head,
        CASE
            WHEN (((temp_arc.addparam)::json ->> 'speed'::text) <> ''::text) THEN (('SPEED'::text || ' '::text) || ((temp_arc.addparam)::json ->> 'speed'::text))
            ELSE NULL::text
        END AS speed,
        CASE
            WHEN (((temp_arc.addparam)::json ->> 'pattern'::text) <> ''::text) THEN (('PATTERN'::text || ' '::text) || ((temp_arc.addparam)::json ->> 'pattern'::text))
            ELSE NULL::text
        END AS pattern,
    concat(';', temp_arc.sector_id, ' ', COALESCE(temp_arc.presszone_id, '0'::text), ' ', COALESCE(temp_arc.dma_id, 0), ' ', COALESCE(temp_arc.dqa_id, 0), ' ', COALESCE(temp_arc.minsector_id, 0), ' ', temp_arc.arccat_id) AS other
   FROM temp_arc
  WHERE (((temp_arc.epa_type)::text = 'PUMP'::text) AND (NOT ((temp_arc.arc_id)::text IN ( SELECT vi_valves.arc_id
           FROM vi_valves))))
  ORDER BY temp_arc.arc_id;


--
-- Name: vi_quality; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_quality AS
 SELECT inp_quality.node_id,
    inp_quality.initqual
   FROM inp_quality
  ORDER BY inp_quality.node_id;


--
-- Name: vi_reactions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_reactions AS
 SELECT inp_typevalue.idval,
    inp_pipe.arc_id,
    inp_pipe.reactionvalue
   FROM selector_inp_result,
    ((inp_pipe
     JOIN rpt_inp_arc ON (((inp_pipe.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
     LEFT JOIN inp_typevalue ON (((upper((inp_pipe.reactionparam)::text) = (inp_typevalue.id)::text) AND ((inp_typevalue.typevalue)::text = 'inp_value_reactions'::text))))
  WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND (inp_typevalue.idval IS NOT NULL))
UNION
 SELECT upper(inp_reactions.descript) AS idval,
    NULL::character varying AS arc_id,
    NULL::character varying AS reactionvalue
   FROM inp_reactions
  ORDER BY 1;


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
-- Name: vi_reservoirs; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_reservoirs AS
 SELECT temp_node.node_id,
        CASE
            WHEN (temp_node.elev IS NOT NULL) THEN temp_node.elev
            ELSE temp_node.elevation
        END AS head,
    temp_node.pattern_id,
    concat(';', temp_node.sector_id, ' ', temp_node.dma_id, ' ', temp_node.presszone_id, ' ', temp_node.dqa_id, ' ', temp_node.minsector_id, ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE ((temp_node.epa_type)::text = 'RESERVOIR'::text)
  ORDER BY temp_node.node_id;


--
-- Name: vi_rules; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_rules AS
 SELECT c.text
   FROM ( SELECT inp_rules.id,
            inp_rules.text
           FROM selector_sector,
            inp_rules
          WHERE ((selector_sector.sector_id = inp_rules.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (inp_rules.active IS NOT FALSE))
        UNION
         SELECT d.id,
            d.text
           FROM selector_sector s,
            v_edit_inp_dscenario_rules d
          WHERE ((s.sector_id = d.sector_id) AND (s.cur_user = ("current_user"())::text) AND (d.active IS NOT FALSE))
  ORDER BY 1) c
  ORDER BY c.id;


--
-- Name: vi_sources; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_sources AS
 SELECT inp_source.node_id,
    inp_source.sourc_type,
    inp_source.quality,
    inp_source.pattern_id
   FROM selector_inp_result,
    (inp_source
     JOIN rpt_inp_node ON (((inp_source.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_inp_node.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text));


--
-- Name: vi_status; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_status AS
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE ((((rpt_inp_arc.status)::text = 'CLOSED'::text) OR ((rpt_inp_arc.status)::text = 'OPEN'::text)) AND ((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.epa_type)::text = 'VALVE'::text))
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (((rpt_inp_arc.status)::text = 'CLOSED'::text) AND ((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.epa_type)::text = 'PUMP'::text))
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (((rpt_inp_arc.status)::text = 'CLOSED'::text) AND ((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.epa_type)::text = 'PUMP'::text));


--
-- Name: vi_tags; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_tags AS
 SELECT inp_tags.feature_type,
    inp_tags.feature_id,
    inp_tags.tag
   FROM inp_tags
  ORDER BY inp_tags.feature_type;


--
-- Name: vi_tanks; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_tanks AS
 SELECT temp_node.node_id,
        CASE
            WHEN (temp_node.elev IS NOT NULL) THEN temp_node.elev
            ELSE temp_node.elevation
        END AS elevation,
    (((temp_node.addparam)::json ->> 'initlevel'::text))::numeric AS initlevel,
    (((temp_node.addparam)::json ->> 'minlevel'::text))::numeric AS minlevel,
    (((temp_node.addparam)::json ->> 'maxlevel'::text))::numeric AS maxlevel,
    (((temp_node.addparam)::json ->> 'diameter'::text))::numeric AS diameter,
    (((temp_node.addparam)::json ->> 'minvol'::text))::numeric AS minvol,
        CASE
            WHEN (((temp_node.addparam)::json ->> 'curve_id'::text) IS NULL) THEN '*'::text
            ELSE ((temp_node.addparam)::json ->> 'curve_id'::text)
        END AS curve_id,
    ((temp_node.addparam)::json ->> 'overflow'::text) AS overflow,
    concat(';', temp_node.sector_id, ' ', temp_node.dma_id, ' ', temp_node.presszone_id, ' ', temp_node.dqa_id, ' ', temp_node.minsector_id, ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE ((temp_node.epa_type)::text = 'TANK'::text)
  ORDER BY temp_node.node_id;


--
-- Name: vi_times; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_times AS
 SELECT a.idval AS parameter,
    b.value
   FROM (sys_param_user a
     JOIN config_param_user b ON ((a.id = (b.parameter)::text)))
  WHERE ((a.layoutname = ANY (ARRAY['lyt_date_1'::text, 'lyt_date_2'::text])) AND ((b.cur_user)::name = "current_user"()) AND (b.value IS NOT NULL));


--
-- Name: vi_title; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_title AS
 SELECT inp_project_id.title,
    inp_project_id.date
   FROM inp_project_id
  ORDER BY inp_project_id.title;


--
-- Name: vi_vertices; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_vertices AS
 SELECT arc.arc_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    arc.point AS the_geom
   FROM ( SELECT (public.st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
            public.st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            public.st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.arc_id
           FROM selector_inp_result,
            rpt_inp_arc
          WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text))) arc
  WHERE (((arc.point OPERATOR(public.<) arc.startpoint) OR (arc.point OPERATOR(public.>) arc.startpoint)) AND ((arc.point OPERATOR(public.<) arc.endpoint) OR (arc.point OPERATOR(public.>) arc.endpoint)));


--
-- Name: vp_basic_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_arc AS
 SELECT arc.arc_id AS nid,
    cat_arc.arctype_id AS custom_type
   FROM (arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)));


--
-- Name: vp_basic_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_connec AS
 SELECT connec.connec_id AS nid,
    cat_connec.connectype_id AS custom_type
   FROM (connec
     JOIN cat_connec ON (((cat_connec.id)::text = (connec.connecat_id)::text)));


--
-- Name: vp_basic_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_node AS
 SELECT node.node_id AS nid,
    cat_node.nodetype_id AS custom_type
   FROM (node
     JOIN cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)));


--
-- Name: v_rpt_energy_usage _RETURN; Type: RULE; Schema: Schema; Owner: -
--

CREATE OR REPLACE VIEW v_rpt_energy_usage AS
 SELECT rpt_energy_usage.id,
    rpt_energy_usage.result_id,
    rpt_energy_usage.nodarc_id,
    rpt_energy_usage.usage_fact,
    rpt_energy_usage.avg_effic,
    rpt_energy_usage.kwhr_mgal,
    rpt_energy_usage.avg_kw,
    rpt_energy_usage.peak_kw,
    rpt_energy_usage.cost_day
   FROM rpt_energy_usage,
    selector_rpt_main
  WHERE (((selector_rpt_main.result_id)::text = (rpt_energy_usage.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()))
  GROUP BY rpt_energy_usage.id, selector_rpt_main.result_id;


--
-- Name: v_rpt_hydraulic_status _RETURN; Type: RULE; Schema: Schema; Owner: -
--

CREATE OR REPLACE VIEW v_rpt_hydraulic_status AS
 SELECT rpt_hydraulic_status.id,
    rpt_hydraulic_status.result_id,
    rpt_hydraulic_status."time",
    rpt_hydraulic_status.text
   FROM rpt_hydraulic_status,
    selector_rpt_main
  WHERE (((selector_rpt_main.result_id)::text = (rpt_hydraulic_status.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()))
  GROUP BY rpt_hydraulic_status.id, selector_rpt_main.result_id;


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
-- Name: dqa dqa_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dqa_conflict AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = '-1'::integer) OR (old.dqa_id = '-1'::integer)) DO INSTEAD NOTHING;


--
-- Name: dqa dqa_del_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dqa_del_conflict AS
    ON DELETE TO dqa
   WHERE (old.dqa_id = '-1'::integer) DO INSTEAD NOTHING;


--
-- Name: dqa dqa_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dqa_del_undefined AS
    ON DELETE TO dqa
   WHERE (old.dqa_id = 0) DO INSTEAD NOTHING;


--
-- Name: dqa dqa_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dqa_undefined AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = 0) OR (old.dqa_id = 0)) DO INSTEAD NOTHING;


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
-- Name: cat_mat_arc insert_inp_cat_mat_roughness; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE insert_inp_cat_mat_roughness AS
    ON INSERT TO cat_mat_arc DO  INSERT INTO cat_mat_roughness (matcat_id)
  VALUES (new.id);


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
-- Name: presszone presszone_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE presszone_conflict AS
    ON UPDATE TO presszone
   WHERE (((new.presszone_id)::text = '-1'::text) OR ((old.presszone_id)::text = '-1'::text)) DO INSTEAD NOTHING;


--
-- Name: presszone presszone_del_uconflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE presszone_del_uconflict AS
    ON DELETE TO presszone
   WHERE ((old.presszone_id)::text = '-1'::text) DO INSTEAD NOTHING;


--
-- Name: presszone presszone_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE presszone_del_undefined AS
    ON DELETE TO presszone
   WHERE ((old.presszone_id)::text = '0'::text) DO INSTEAD NOTHING;


--
-- Name: presszone presszone_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE presszone_undefined AS
    ON UPDATE TO presszone
   WHERE (((new.presszone_id)::text = '0'::text) OR ((old.presszone_id)::text = '0'::text)) DO INSTEAD NOTHING;


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
-- Name: macrodma undelete_dma; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_dma AS
    ON DELETE TO macrodma
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

