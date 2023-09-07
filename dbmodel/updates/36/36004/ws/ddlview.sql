/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

CREATE OR REPLACE VIEW vu_link AS 
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    presszone_id::character varying(16) AS presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    d.name AS dma_name,
    q.name AS dqa_name,
    p.name AS presszone_name,
    s.macrosector_id,
    d.macrodma_id,
    q.macrodqa_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id);

CREATE OR REPLACE VIEW v_link AS 
 SELECT vu_link.link_id,
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
    vu_link.expl_id2,
    vu_link.epa_type,
    vu_link.is_operative,
    vu_link.staticpressure
   FROM vu_link
     JOIN v_state_link USING (link_id);


     CREATE OR REPLACE VIEW v_link_connec AS 
 SELECT vu_link.link_id,
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
    vu_link.expl_id2,
    vu_link.epa_type,
    vu_link.is_operative,
    vu_link.staticpressure
   FROM vu_link
     JOIN v_state_link_connec USING (link_id);


CREATE OR REPLACE VIEW v_edit_link AS 
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
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure
   FROM v_link l;



CREATE OR REPLACE VIEW v_connec AS 
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
            WHEN a.sector_id IS NULL THEN vu_connec.sector_id
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
            WHEN a.minsector_id IS NULL THEN vu_connec.minsector_id
            ELSE a.minsector_id
        END AS minsector_id,
        CASE
            WHEN a.dma_id IS NULL THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.dma_name IS NULL THEN vu_connec.dma_name
            ELSE a.dma_name
        END AS dma_name,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
        CASE
            WHEN a.presszone_id IS NULL THEN vu_connec.presszone_id
            ELSE a.presszone_id::character varying(30)
        END AS presszone_id,
        CASE
            WHEN a.presszone_name IS NULL THEN vu_connec.presszone_name
            ELSE a.presszone_name
        END AS presszone_name,
	CASE
            WHEN a.presszone_name IS NULL THEN vu_connec.staticpressure
            ELSE a.staticpressure::numeric(12,3)
        END AS staticpressure,
        CASE
            WHEN a.dqa_id IS NULL THEN vu_connec.dqa_id
            ELSE a.dqa_id
        END AS dqa_id,
        CASE
            WHEN a.dqa_name IS NULL THEN vu_connec.dqa_name
            ELSE a.dqa_name
        END AS dqa_name,
        CASE
            WHEN a.macrodqa_id IS NULL THEN vu_connec.macrodqa_id
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
            WHEN a.exit_id IS NULL THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_connec.pjoint_type
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
    vu_connec.quality_avg,
    vu_connec.is_operative,
    vu_connec.region_id,
    vu_connec.province_id
   FROM vu_connec
     JOIN v_state_connec USING (connec_id)
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
            v_link_connec.expl_id2,
            v_link_connec.staticpressure
           FROM v_link_connec
          WHERE v_link_connec.state = 2) a ON a.feature_id::text = vu_connec.connec_id::text;

 
CREATE OR REPLACE VIEW v_edit_plan_netscenario_presszone  AS
SELECT n.netscenario_id,
name AS netscenario_name, 
presszone_id, 
presszone_name as name,
head,
graphconfig,
the_geom
FROM selector_netscenario,
plan_netscenario_presszone n
JOIN plan_netscenario p USING (netscenario_id)
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_plan_netscenario_dma  AS
SELECT n.netscenario_id, 
name AS netscenario_name, 
dma_id, 
dma_name  as name,
pattern_id, 
graphconfig,
the_geom
FROM selector_netscenario,
plan_netscenario_dma n
JOIN plan_netscenario p USING (netscenario_id)
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_netscenario_arc  AS
SELECT n.netscenario_id, 
arc_id, 
presszone_id, 
dma_id,
the_geom
FROM selector_netscenario,
plan_netscenario_arc n
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_netscenario_node  AS
SELECT n.netscenario_id, 
node_id, 
presszone_id, 
staticpressure,
dma_id,
pattern_id,
the_geom
FROM selector_netscenario,
plan_netscenario_node n
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_netscenario_connec  AS
SELECT n.netscenario_id, 
connec_id, 
presszone_id, 
staticpressure,
dma_id,
pattern_id,
the_geom
FROM selector_netscenario,
plan_netscenario_connec n
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE VIEW v_minsector_graph AS
SELECT m.* FROM minsector_graph m, selector_expl s 
WHERE cur_user = current_user AND s.expl_id = m.expl_id;

DROP VIEW v_edit_minsector;
CREATE OR REPLACE VIEW v_edit_minsector AS
 SELECT m.minsector_id,
    m.code,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.expl_id,
    m.num_border,
    m.num_connec,
    m.num_hydro,
    m.length,
    m.descript,
    m.addparam,
    m.the_geom
   FROM selector_expl,  minsector m
  WHERE m.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"minsector", "column":"sector_id"}}$$);


CREATE OR REPLACE VIEW v_ui_plan_netscenario AS
 SELECT DISTINCT ON (c.netscenario_id) c.netscenario_id,
    c.name,
    c.descript,
    c.netscenario_type,
    c.parent_id,
    c.expl_id,
    c.active,
    c.log
   FROM plan_netscenario c,
    selector_expl s
  WHERE s.expl_id = c.expl_id AND s.cur_user = CURRENT_USER::text OR c.expl_id IS NULL;


--29/08/23
  CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM node
     JOIN v_state_node USING (node_id)
     JOIN polygon ON polygon.feature_id::text = node.node_id::text;

CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM connec
     JOIN v_state_connec USING (connec_id)
     JOIN polygon ON polygon.feature_id::text = connec.connec_id::text;


CREATE OR REPLACE VIEW v_edit_element
AS SELECT element.element_id,
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
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.elevation,
    element.expl_id2,
    element.trace_featuregeom
   FROM selector_expl,
    element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_pol_element
AS SELECT e.pol_id,
    e.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM v_edit_element e
     JOIN polygon USING (pol_id);


-- 07/09/2023
DROP VIEW IF EXISTS v_ui_sector;
CREATE OR REPLACE VIEW v_ui_sector AS
 SELECT s.sector_id,
    s.name,
    ms.name AS "macrosector",
    s.descript,
    s.undelete,
    s.sector_type,
    s.active,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.graphconfig,
    s.stylesheet
   FROM sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.sector_id > 0
  ORDER BY s.sector_id;


DROP VIEW IF EXISTS v_ui_dma;
CREATE OR REPLACE VIEW v_ui_dma AS
 SELECT d.dma_id,
	d.name,
	d.descript,
	d.expl_id,
	md.name AS "macrodma",
	d.active,
	d.undelete,
	d.minc,
	d.maxc,
	d.effc,
	d.avg_press,
	d.pattern_id,
	d.link,
	d.graphconfig,
	d.stylesheet,
	d.tstamp,
	d.insert_user,
	d.lastupdate,
	d.lastupdate_user
   FROM dma d
     LEFT JOIN macrodma md ON md.macrodma_id = d.macrodma_id
  WHERE d.dma_id > 0
  ORDER BY d.dma_id;


DROP VIEW IF EXISTS v_ui_presszone;
CREATE OR REPLACE VIEW v_ui_presszone AS
 SELECT p.presszone_id,
 	p.name,
 	p.descript,
 	p.expl_id,
 	p.link,
 	p.head,
 	p.active,
 	p.graphconfig,
 	p.stylesheet,
 	p.tstamp,
 	p.insert_user,
 	p.lastupdate,
 	p.lastupdate_user 
   FROM presszone p
  WHERE p.presszone_id NOT IN ('0', '-1')
  ORDER BY p.presszone_id;


DROP VIEW IF EXISTS v_ui_dqa;
CREATE OR REPLACE VIEW v_ui_dqa AS
 SELECT d.dqa_id,
	d."name",
	d.descript,
	d.expl_id,
	md.name as "macrodma",
	d.active,
	d.undelete,
	d.the_geom,
	d.pattern_id,
	d.dqa_type,
	d.link,
	d.graphconfig,
	d.stylesheet,
	d.tstamp,
	d.insert_user,
	d.lastupdate,
	d.lastupdate_user
   FROM dqa d
     LEFT JOIN macrodqa md ON md.macrodqa_id = d.macrodqa_id
  WHERE d.dqa_id > 0
  ORDER BY d.dqa_id;


