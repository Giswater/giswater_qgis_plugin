/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE OR REPLACE VIEW v_edit_inp_conduit AS 
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
   FROM selector_sector, v_arc
     JOIN inp_conduit USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_divider AS 
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
   FROM v_sector_node
     JOIN v_node USING (node_id)
     JOIN inp_divider ON v_node.node_id::text = inp_divider.node_id::text
  WHERE is_operative IS TRUE;


  
CREATE OR REPLACE VIEW v_edit_inp_gully AS 
 SELECT g.gully_id,
    g.code,
    g.top_elev,
    g.gully_type,
    g.gratecat_id,
    (g.grate_width / 100::numeric)::numeric(12,2) AS grate_width,
    (g.grate_length / 100::numeric)::numeric(12,2) AS grate_length,
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
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    g.ymax - COALESCE(g.sandbox, 0::numeric) AS depth,
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
    v_edit_gully g
     JOIN inp_gully i USING (gully_id)
     JOIN cat_grate ON g.gratecat_id::text = cat_grate.id::text
  WHERE g.sector_id = s.sector_id AND s.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_junction AS 
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
    inp_junction.outfallparam::text AS outfallparam,
    n.the_geom
   FROM v_sector_node
     JOIN v_edit_node n USING (node_id)
     JOIN inp_junction USING (node_id)
  WHERE is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_netgully AS 
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
    (cat_grate.width / 100::numeric)::numeric(12,3) AS grate_width,
    (cat_grate.length / 100::numeric)::numeric(12,3) AS grate_length,
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
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    n.ymax - COALESCE(man_netgully.sander_depth, 0::numeric) AS depth,
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
   FROM v_sector_node
     JOIN v_node n USING (node_id)
     JOIN inp_netgully i USING (node_id)
     LEFT JOIN man_netgully USING (node_id)
     LEFT JOIN cat_grate ON man_netgully.gratecat_id::text = cat_grate.id::text
  WHERE is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_orifice AS 
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
    v_arc
     JOIN inp_orifice USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_outfall AS 
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
   FROM v_sector_node
     JOIN v_node USING (node_id)
     JOIN inp_outfall USING (node_id)
  WHERE is_operative IS TRUE;


  -- View: v_edit_inp_outlet

-- DROP VIEW v_edit_inp_outlet;

CREATE OR REPLACE VIEW v_edit_inp_outlet AS 
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
    v_arc
     JOIN inp_outlet USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
  AND is_operative IS TRUE;

-- View: v_edit_inp_pump

-- DROP VIEW v_edit_inp_pump;

CREATE OR REPLACE VIEW v_edit_inp_pump AS 
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
    v_arc
     JOIN inp_pump USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;

-- View: v_edit_inp_storage

-- DROP VIEW v_edit_inp_storage;

CREATE OR REPLACE VIEW v_edit_inp_storage AS 
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
   FROM v_sector_node
     JOIN v_node USING (node_id)
     JOIN inp_storage USING (node_id)
  WHERE is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_virtual AS 
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
    v_arc
     JOIN inp_virtual USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


-- View: v_edit_inp_weir

-- DROP VIEW v_edit_inp_weir;

CREATE OR REPLACE VIEW v_edit_inp_weir AS 
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
    v_arc
     JOIN inp_weir USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_element AS
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
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.top_elev,
    element.expl_id2
   FROM selector_expl,
    element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;