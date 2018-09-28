-- View: ws.vu_arc

-- DROP VIEW ws.vu_arc;

CREATE OR REPLACE VIEW ws.vu_arc AS 
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    cat_arc.arctype_id,
    cat_arc.matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    arc.epa_type,
    arc.sector_id,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.observ,
    arc.comment,
    cat_arc.label,
    st_length(arc.the_geom) AS st_length,
    arc.custom_length,
    arc.dma_id,
    arc.presszonecat_id,
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
    arc.streetaxis_id,
    arc.postnumber,
    arc.postcomplement,
    arc.postcomplement2,
    arc.streetaxis2_id,
    arc.postnumber2,
    arc.descript,
    arc.link,
    arc.verified,
    arc.the_geom,
    arc.undelete,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    dma.macrodma_id,
    arc.expl_id,
    arc.num_value
   FROM ws.arc
     LEFT JOIN ws.sector ON arc.sector_id = sector.sector_id
     JOIN ws.dma ON dma.dma_id = arc.dma_id
     JOIN ws.cat_arc ON arc.arccat_id::text = cat_arc.id::text
  WHERE arc.state <> 1;

ALTER TABLE ws.vu_arc
  OWNER TO amsaadmin;
GRANT ALL ON TABLE ws.vu_arc TO amsaadmin;
GRANT SELECT ON TABLE ws.vu_arc TO role_basic;
GRANT SELECT ON TABLE ws.vu_arc TO role_edit;
GRANT SELECT ON TABLE ws.vu_arc TO role_om;
GRANT SELECT ON TABLE ws.vu_arc TO role_epa;
GRANT SELECT ON TABLE ws.vu_arc TO role_master;
GRANT SELECT ON TABLE ws.vu_arc TO role_admin;
GRANT ALL ON TABLE ws.vu_arc TO qgisserver;
GRANT ALL ON TABLE ws.vu_arc TO test;


-- View: ws.vu_node

-- DROP VIEW ws.vu_node;

CREATE OR REPLACE VIEW ws.vu_node AS 
 SELECT node.node_id,
    node.code,
    node.elevation,
    node.depth,
    cat_node.nodetype_id,
    node.nodecat_id,
    cat_node.matcat_id,
    cat_node.pnom,
    cat_node.dnom,
    node.epa_type,
    node.sector_id,
    sector.macrosector_id,
    node.arc_id,
    node.parent_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    cat_node.label,
    node.dma_id,
    node.presszonecat_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.buildercat_id,
    node.workcat_id_end,
    node.builtdate,
    node.enddate,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.streetaxis_id,
    node.postnumber,
    node.postcomplement,
    node.postcomplement2,
    node.streetaxis2_id,
    node.postnumber2,
    node.descript,
    cat_node.svg,
    node.rotation,
    node.link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.publish,
    node.inventory,
    dma.macrodma_id,
    node.expl_id,
    node.hemisphere,
    node.num_value
   FROM ws.node
     LEFT JOIN ws.sector ON node.sector_id = sector.sector_id
     LEFT JOIN ws.dma ON dma.dma_id = node.dma_id
     LEFT JOIN ws.cat_node ON node.nodecat_id::text = cat_node.id::text
  WHERE node.state <> 1;

ALTER TABLE ws.vu_node
  OWNER TO amsaadmin;
GRANT ALL ON TABLE ws.vu_node TO amsaadmin;
GRANT SELECT ON TABLE ws.vu_node TO role_basic;
GRANT SELECT ON TABLE ws.vu_node TO role_edit;
GRANT SELECT ON TABLE ws.vu_node TO role_om;
GRANT SELECT ON TABLE ws.vu_node TO role_epa;
GRANT SELECT ON TABLE ws.vu_node TO role_master;
GRANT SELECT ON TABLE ws.vu_node TO role_admin;
GRANT ALL ON TABLE ws.vu_node TO qgisserver;
GRANT ALL ON TABLE ws.vu_node TO test;

