/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;
-----------------------
-- remove all the views that are refactored in the v3.2
-----------------------
/*DROP VIEW IF EXISTS v_edit_inp_conduit;
DROP VIEW IF EXISTS v_edit_inp_junction;
DROP VIEW IF EXISTS v_edit_inp_divider;
DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_outfall;
DROP VIEW IF EXISTS v_edit_inp_outlet;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_storage;
DROP VIEW IF EXISTS v_edit_inp_virtual;
DROP VIEW IF EXISTS v_edit_inp_weir;

DROP VIEW IF EXISTS v_edit_man_chamber;
DROP VIEW IF EXISTS v_edit_man_chamber_pol;
DROP VIEW IF EXISTS v_edit_man_conduit;
DROP VIEW IF EXISTS v_edit_man_connec;
DROP VIEW IF EXISTS v_edit_man_gully;
DROP VIEW IF EXISTS v_edit_man_gully_pol;
DROP VIEW IF EXISTS v_edit_man_junction;
DROP VIEW IF EXISTS v_edit_man_manhole;
DROP VIEW IF EXISTS v_edit_man_netelement;
DROP VIEW IF EXISTS v_edit_man_netgully_pol;
DROP VIEW IF EXISTS v_edit_man_netinit;
DROP VIEW IF EXISTS v_edit_man_outfall;
DROP VIEW IF EXISTS v_edit_man_siphon;
DROP VIEW IF EXISTS v_edit_man_storage;
DROP VIEW IF EXISTS v_edit_man_storage_pol;
DROP VIEW IF EXISTS v_edit_man_valve;
DROP VIEW IF EXISTS v_edit_man_varc;
DROP VIEW IF EXISTS v_edit_man_waccel;
DROP VIEW IF EXISTS v_edit_man_wjump;
DROP VIEW IF EXISTS v_edit_man_wwtp;
DROP VIEW IF EXISTS v_edit_man_wwtp_pol;
*/



--connec


-----------------------
-- create views ve
-----------------------
DROP VIEW IF EXISTS ve_arc;
CREATE OR REPLACE VIEW ve_arc AS 
 SELECT v_arc_x_node.arc_id,
    v_arc_x_node.code,
    v_arc_x_node.node_1,
    v_arc_x_node.node_2,
    v_arc_x_node.y1,
    v_arc_x_node.custom_y1,
    v_arc_x_node.elev1,
    v_arc_x_node.custom_elev1,
    v_arc_x_node.sys_elev1,
    v_arc_x_node.y2,
    v_arc_x_node.custom_y2,
    v_arc_x_node.elev2,
    v_arc_x_node.custom_elev2,
    v_arc_x_node.sys_elev2,
    v_arc_x_node.z1,
    v_arc_x_node.z2,
    v_arc_x_node.r1,
    v_arc_x_node.r2,
    v_arc_x_node.slope,
    v_arc_x_node.arc_type,
    v_arc_x_node.sys_type,
    v_arc_x_node.arccat_id,
    v_arc_x_node.matcat_id AS cat_matcat_id,
    v_arc_x_node.shape AS cat_shape,
    v_arc_x_node.geom1 AS cat_geom1,
    v_arc_x_node.geom2 AS cat_geom2,
    v_arc_x_node.gis_length,
    v_arc_x_node.epa_type,
    v_arc_x_node.sector_id,
    v_arc_x_node.macrosector_id,
    v_arc_x_node.state,
    v_arc_x_node.state_type,
    v_arc_x_node.annotation,
    v_arc_x_node.observ,
    v_arc_x_node.comment,
    v_arc_x_node.inverted_slope,
    v_arc_x_node.custom_length,
    v_arc_x_node.dma_id,
    v_arc_x_node.soilcat_id,
    v_arc_x_node.function_type,
    v_arc_x_node.category_type,
    v_arc_x_node.fluid_type,
    v_arc_x_node.location_type,
    v_arc_x_node.workcat_id,
    v_arc_x_node.workcat_id_end,
    v_arc_x_node.buildercat_id,
    v_arc_x_node.builtdate,
    v_arc_x_node.enddate,
    v_arc_x_node.ownercat_id,
    v_arc_x_node.muni_id,
    v_arc_x_node.postcode,
    v_arc_x_node.streetaxis_id,
    v_arc_x_node.postnumber,
    v_arc_x_node.postcomplement,
    v_arc_x_node.postcomplement2,
    v_arc_x_node.streetaxis2_id,
    v_arc_x_node.postnumber2,
    v_arc_x_node.descript,
    v_arc_x_node.link,
    v_arc_x_node.verified,
    v_arc_x_node.the_geom,
    v_arc_x_node.undelete,
    v_arc_x_node.label_x,
    v_arc_x_node.label_y,
    v_arc_x_node.label_rotation,
    v_arc_x_node.publish,
    v_arc_x_node.inventory,
    v_arc_x_node.uncertain,
    v_arc_x_node.macrodma_id,
    v_arc_x_node.expl_id,
    v_arc_x_node.num_value
   FROM v_arc_x_node;


DROP VIEW IF EXISTS ve_node;
CREATE OR REPLACE VIEW ve_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    v_node.num_value
   FROM v_node;


DROP VIEW IF EXISTS ve_connec;
CREATE OR REPLACE VIEW ve_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    connec_type.type AS sys_type,
    connec.private_connecat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.demand,
    connec.state,
    connec.state_type,
    connec.connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
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
    connec.streetaxis_id,
    connec.postnumber,
    connec.postcomplement,
    connec.streetaxis2_id,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.featurecat_id,
    connec.feature_id,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value
   FROM connec
     JOIN v_state_connec ON connec.connec_id::text = v_state_connec.connec_id::text
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN connec_type ON connec.connec_type::text = connec_type.id::text;


DROP VIEW IF EXISTS ve_gully;
CREATE OR REPLACE VIEW ve_gully AS 
 SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    gully_type.type AS sys_type,
    gully.gratecat_id,
    cat_grate.matcat_id AS cat_grate_matcat,
    gully.units,
    gully.groove,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
    gully.connec_depth,
    gully.arc_id,
    gully.sector_id,
    sector.macrosector_id,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    gully.dma_id,
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
    gully.streetaxis_id,
    gully.postnumber,
    gully.postcomplement,
    gully.streetaxis2_id,
    gully.postnumber2,
    gully.postcomplement2,
    gully.descript,
    cat_grate.svg,
    gully.rotation,
    concat(gully_type.link_path, gully.link) AS link,
    gully.verified,
    gully.the_geom,
    gully.undelete,
    gully.featurecat_id,
    gully.feature_id,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.publish,
    gully.inventory,
    gully.expl_id,
    dma.macrodma_id,
    gully.uncertain,
    gully.num_value
   FROM gully
     JOIN v_state_gully ON gully.gully_id::text = v_state_gully.gully_id::text
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN gully_type ON gully.gully_type::text = gully_type.id::text;



-----------------------
-- create parent views
-----------------------
DROP VIEW IF EXISTS vp_arc;
CREATE OR REPLACE VIEW vp_arc AS 
 SELECT ve_arc.arc_id AS nid,
    ve_arc.arc_type AS custom_type
   FROM ve_arc;

DROP VIEW IF EXISTS vp_connec;
CREATE OR REPLACE VIEW vp_connec AS 
 SELECT ve_connec.connec_id AS nid,
    ve_connec.connec_type AS custom_type
   FROM ve_connec;

DROP VIEW IF EXISTS vp_node;
CREATE OR REPLACE VIEW vp_node AS 
 SELECT ve_node.node_id AS nid,
    ve_node.node_type AS custom_type
   FROM ve_node;

DROP VIEW IF EXISTS vp_gully;
CREATE OR REPLACE VIEW vp_gully AS 
 SELECT ve_gully.arc_id AS nid,
    ve_gully.gully_type AS custom_type
   FROM ve_gully;

-----------------------
-- create child views
-----------------------

DROP VIEW IF EXISTS ve_node_chamber;
CREATE OR REPLACE VIEW ve_node_chamber AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_chamber.pol_id,
    man_chamber.length,
    man_chamber.width,
    man_chamber.sander_depth,
    man_chamber.max_volume,
    man_chamber.util_volume,
    man_chamber.inlet,
    man_chamber.bottom_channel,
    man_chamber.accessibility,
    man_chamber.name,
    a.chamber_param_1,
    a.chamber_param_2,
    a.chamber_param_3
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_chamber ON man_chamber.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.chamber_param_1,ct.chamber_param_2, ct.chamber_param_3
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''CHAMBER''
                    ORDER  BY 1,2'::text, ' VALUES (''3''),(''4''),(''5'')'::text) 
                    ct(feature_id character varying, chamber_param_1 text, chamber_param_2 text, chamber_param_3 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.node_type::text = 'CHAMBER'::text;



DROP VIEW IF EXISTS ve_node_weir;
CREATE OR REPLACE VIEW ve_node_weir AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_chamber.pol_id,
    man_chamber.length,
    man_chamber.width,
    man_chamber.sander_depth,
    man_chamber.max_volume,
    man_chamber.util_volume,
    man_chamber.inlet,
    man_chamber.bottom_channel,
    man_chamber.accessibility,
    man_chamber.name
   FROM v_node
     JOIN man_chamber ON man_chamber.node_id::text = v_node.node_id::text
      WHERE node_type = 'WEIR';


DROP VIEW IF EXISTS ve_node_pumpstation;
CREATE OR REPLACE VIEW ve_node_pumpstation AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_chamber.pol_id,
    man_chamber.length,
    man_chamber.width,
    man_chamber.sander_depth,
    man_chamber.max_volume,
    man_chamber.util_volume,
    man_chamber.inlet,
    man_chamber.bottom_channel,
    man_chamber.accessibility,
    man_chamber.name
   FROM v_node
     JOIN man_chamber ON man_chamber.node_id::text = v_node.node_id::text
     WHERE node_type = 'PUMP-STATION';



DROP VIEW IF EXISTS ve_node_register;
CREATE OR REPLACE VIEW ve_node_register AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    v_node.num_value
   FROM v_node
     JOIN man_junction ON man_junction.node_id::text = v_node.node_id::text
     WHERE node_type = 'REGISTER';


DROP VIEW IF EXISTS ve_node_change;
CREATE OR REPLACE VIEW ve_node_change AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    v_node.num_value
   FROM v_node
     JOIN man_junction ON man_junction.node_id::text = v_node.node_id::text
     WHERE node_type = 'CHANGE';


DROP VIEW IF EXISTS ve_node_vnode;
CREATE OR REPLACE VIEW ve_node_vnode AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    v_node.num_value
   FROM v_node
     JOIN man_junction ON man_junction.node_id::text = v_node.node_id::text
     WHERE node_type = 'VNODE';


DROP VIEW IF EXISTS ve_node_junction;
CREATE OR REPLACE VIEW ve_node_junction AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    v_node.num_value
   FROM v_node
     JOIN man_junction ON man_junction.node_id::text = v_node.node_id::text
     WHERE node_type = 'JUNCTION';


DROP VIEW IF EXISTS ve_node_highpoint;
CREATE OR REPLACE VIEW ve_node_highpoint AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    v_node.num_value
   FROM v_node
     JOIN man_junction ON man_junction.node_id::text = v_node.node_id::text
     WHERE node_type = 'HIGHPOINT';



DROP VIEW IF EXISTS ve_node_circmanhole;
CREATE OR REPLACE VIEW ve_node_circmanhole AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_manhole.length,
    man_manhole.width,
    man_manhole.sander_depth,
    man_manhole.prot_surface,
    man_manhole.inlet,
    man_manhole.bottom_channel,
    man_manhole.accessibility,
    a.circmanhole_param_1,
    a.circmanhole_param_2,
    a.circmanhole_param_3
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_manhole ON man_manhole.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.circmanhole_param_1,ct.circmanhole_param_2, ct.circmanhole_param_3
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''CIRC-MANHOLE''
                    ORDER  BY 1,2'::text, ' VALUES (''10''),(''11''),(''12'')'::text) 
                    ct(feature_id character varying, circmanhole_param_1 text, circmanhole_param_2 text, circmanhole_param_3 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.node_type::text = 'CIRC-MANHOLE'::text;


DROP VIEW IF EXISTS ve_node_rectmanhole;
CREATE OR REPLACE VIEW ve_node_rectmanhole AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_manhole.length,
    man_manhole.width,
    man_manhole.sander_depth,
    man_manhole.prot_surface,
    man_manhole.inlet,
    man_manhole.bottom_channel,
    man_manhole.accessibility,
    a.rectmanhole_param_1,
    a.rectmanhole_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_manhole ON man_manhole.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.rectmanhole_param_1,ct.rectmanhole_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''RECT-MANHOLE''
                    ORDER  BY 1,2'::text, ' VALUES (''22''),(''23'')'::text) 
                    ct(feature_id character varying, rectmanhole_param_1 text, rectmanhole_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.node_type::text = 'RECT-MANHOLE'::text;



DROP VIEW IF EXISTS ve_node_netelement;
CREATE OR REPLACE VIEW ve_node_netelement AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_netelement.serial_number
   FROM v_node
     JOIN man_netelement ON man_netelement.node_id::text = v_node.node_id::text
     WHERE node_type = 'NETELEMENT';



DROP VIEW IF EXISTS ve_node_netgully;
CREATE OR REPLACE VIEW ve_node_netgully AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_netgully.pol_id,
    man_netgully.sander_depth,
    man_netgully.gratecat_id,
    man_netgully.units,
    man_netgully.groove,
    man_netgully.siphon
   FROM v_node
     JOIN man_netgully ON man_netgully.node_id::text = v_node.node_id::text
     WHERE node_type = 'NETGULLY';



DROP VIEW IF EXISTS ve_node_sandbox;
CREATE OR REPLACE VIEW ve_node_sandbox AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_netinit.length,
    man_netinit.width,
    man_netinit.inlet,
    man_netinit.bottom_channel,
    man_netinit.accessibility,
    man_netinit.name,
    man_netinit.sander_depth
   FROM v_node
     JOIN man_netinit ON man_netinit.node_id::text = v_node.node_id::text
     WHERE node_type = 'SANDBOX';



DROP VIEW IF EXISTS ve_node_outfall;
CREATE OR REPLACE VIEW ve_node_outfall AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_outfall.name
   FROM v_node
     JOIN man_outfall ON man_outfall.node_id::text = v_node.node_id::text
     WHERE node_type = 'OUFALL';




DROP VIEW IF EXISTS ve_node_overflowstorage;
CREATE OR REPLACE VIEW ve_node_overflowstorage AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_storage.pol_id,
    man_storage.length,
    man_storage.width,
    man_storage.custom_area,
    man_storage.max_volume,
    man_storage.util_volume,
    man_storage.min_height,
    man_storage.accessibility,
    man_storage.name
   FROM v_node
     JOIN man_storage ON man_storage.node_id::text = v_node.node_id::text
     WHERE node_type = 'OWERFLOW-STORAGE';



DROP VIEW IF EXISTS ve_node_sewerstorage;
CREATE OR REPLACE VIEW ve_node_sewerstorage AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_storage.pol_id,
    man_storage.length,
    man_storage.width,
    man_storage.custom_area,
    man_storage.max_volume,
    man_storage.util_volume,
    man_storage.min_height,
    man_storage.accessibility,
    man_storage.name,
    a.sewerstorage_param_1,
    a.sewerstorage_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_storage ON man_storage.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.sewerstorage_param_1,ct.sewerstorage_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''SEWER-STORAGE''
                    ORDER  BY 1,2'::text, ' VALUES (''24''),(''25'')'::text) 
                    ct(feature_id character varying, sewerstorage_param_1 text, sewerstorage_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.node_type::text = 'SEWER-STORAGE'::text;



DROP VIEW IF EXISTS ve_node_valve;
CREATE OR REPLACE VIEW ve_node_valve AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_valve.name,
    a.valve_param_1,
    a.valve_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.valve_param_1,ct.valve_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''VALVE''
                    ORDER  BY 1,2'::text, ' VALUES (''26''),(''27'')'::text) 
                    ct(feature_id character varying, valve_param_1 text, valve_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.node_type::text = 'VALVE'::text;



DROP VIEW IF EXISTS ve_node_jump;
CREATE OR REPLACE VIEW ve_node_jump AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_wjump.length,
    man_wjump.width,
    man_wjump.sander_depth,
    man_wjump.prot_surface,
    man_wjump.accessibility,
    man_wjump.name
   FROM v_node
     JOIN man_wjump ON man_wjump.node_id::text = v_node.node_id::text
     WHERE node_type = 'JUMP';



DROP VIEW IF EXISTS ve_node_wwtp;
CREATE OR REPLACE VIEW ve_node_wwtp AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
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
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
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
    man_wwtp.pol_id,
    man_wwtp.name
   FROM v_node
     JOIN man_wwtp ON man_wwtp.node_id::text = v_node.node_id::text
     WHERE node_type = 'WWTP';


--arc

DROP VIEW IF EXISTS ve_arc_pumppipe;
CREATE OR REPLACE VIEW ve_arc_pumppipe AS 
 SELECT v_arc_x_node.arc_id,
    v_arc_x_node.code,
    v_arc_x_node.node_1,
    v_arc_x_node.node_2,
    v_arc_x_node.y1,
    v_arc_x_node.custom_y1,
    v_arc_x_node.elev1,
    v_arc_x_node.custom_elev1,
    v_arc_x_node.sys_elev1,
    v_arc_x_node.y2,
    v_arc_x_node.elev2,
    v_arc_x_node.custom_y2,
    v_arc_x_node.custom_elev2,
    v_arc_x_node.sys_elev2,
    v_arc_x_node.z1,
    v_arc_x_node.z2,
    v_arc_x_node.r1,
    v_arc_x_node.r2,
    v_arc_x_node.slope,
    v_arc_x_node.arc_type,
    v_arc_x_node.arccat_id,
    v_arc_x_node.matcat_id,
    v_arc_x_node.shape,
    v_arc_x_node.geom1 AS cat_geom1,
    v_arc_x_node.geom2 AS cat_geom2,
    v_arc_x_node.gis_length,
    v_arc_x_node.epa_type,
    v_arc_x_node.sector_id,
    v_arc_x_node.macrosector_id,
    v_arc_x_node.state,
    v_arc_x_node.state_type,
    v_arc_x_node.annotation,
    v_arc_x_node.observ,
    v_arc_x_node.comment,
    v_arc_x_node.inverted_slope,
    v_arc_x_node.custom_length,
    v_arc_x_node.dma_id,
    v_arc_x_node.soilcat_id,
    v_arc_x_node.function_type,
    v_arc_x_node.category_type,
    v_arc_x_node.fluid_type,
    v_arc_x_node.location_type,
    v_arc_x_node.workcat_id,
    v_arc_x_node.workcat_id_end,
    v_arc_x_node.buildercat_id,
    v_arc_x_node.builtdate,
    v_arc_x_node.enddate,
    v_arc_x_node.ownercat_id,
    v_arc_x_node.muni_id,
    v_arc_x_node.postcode,
    v_arc_x_node.streetaxis_id,
    v_arc_x_node.postnumber,
    v_arc_x_node.postcomplement,
    v_arc_x_node.streetaxis2_id,
    v_arc_x_node.postnumber2,
    v_arc_x_node.postcomplement2,
    v_arc_x_node.descript,
    v_arc_x_node.link,
    v_arc_x_node.verified,
    v_arc_x_node.the_geom,
    v_arc_x_node.undelete,
    v_arc_x_node.label_x,
    v_arc_x_node.label_y,
    v_arc_x_node.label_rotation,
    v_arc_x_node.publish,
    v_arc_x_node.inventory,
    v_arc_x_node.uncertain,
    v_arc_x_node.macrodma_id,
    v_arc_x_node.expl_id,
    v_arc_x_node.num_value
   FROM v_arc_x_node
     JOIN man_conduit ON man_conduit.arc_id::text = v_arc_x_node.arc_id::text
     WHERE arc_type = 'PUMP-PIPE';




DROP VIEW IF EXISTS ve_arc_conduit;
CREATE OR REPLACE VIEW ve_arc_conduit AS 
 SELECT v_arc_x_node.arc_id,
    v_arc_x_node.code,
    v_arc_x_node.node_1,
    v_arc_x_node.node_2,
    v_arc_x_node.y1,
    v_arc_x_node.custom_y1,
    v_arc_x_node.elev1,
    v_arc_x_node.custom_elev1,
    v_arc_x_node.sys_elev1,
    v_arc_x_node.y2,
    v_arc_x_node.elev2,
    v_arc_x_node.custom_y2,
    v_arc_x_node.custom_elev2,
    v_arc_x_node.sys_elev2,
    v_arc_x_node.z1,
    v_arc_x_node.z2,
    v_arc_x_node.r1,
    v_arc_x_node.r2,
    v_arc_x_node.slope,
    v_arc_x_node.arc_type,
    v_arc_x_node.arccat_id,
    v_arc_x_node.matcat_id,
    v_arc_x_node.shape,
    v_arc_x_node.geom1 AS cat_geom1,
    v_arc_x_node.geom2 AS cat_geom2,
    v_arc_x_node.gis_length,
    v_arc_x_node.epa_type,
    v_arc_x_node.sector_id,
    v_arc_x_node.macrosector_id,
    v_arc_x_node.state,
    v_arc_x_node.state_type,
    v_arc_x_node.annotation,
    v_arc_x_node.observ,
    v_arc_x_node.comment,
    v_arc_x_node.inverted_slope,
    v_arc_x_node.custom_length,
    v_arc_x_node.dma_id,
    v_arc_x_node.soilcat_id,
    v_arc_x_node.function_type,
    v_arc_x_node.category_type,
    v_arc_x_node.fluid_type,
    v_arc_x_node.location_type,
    v_arc_x_node.workcat_id,
    v_arc_x_node.workcat_id_end,
    v_arc_x_node.buildercat_id,
    v_arc_x_node.builtdate,
    v_arc_x_node.enddate,
    v_arc_x_node.ownercat_id,
    v_arc_x_node.muni_id,
    v_arc_x_node.postcode,
    v_arc_x_node.streetaxis_id,
    v_arc_x_node.postnumber,
    v_arc_x_node.postcomplement,
    v_arc_x_node.streetaxis2_id,
    v_arc_x_node.postnumber2,
    v_arc_x_node.postcomplement2,
    v_arc_x_node.descript,
    v_arc_x_node.link,
    v_arc_x_node.verified,
    v_arc_x_node.the_geom,
    v_arc_x_node.undelete,
    v_arc_x_node.label_x,
    v_arc_x_node.label_y,
    v_arc_x_node.label_rotation,
    v_arc_x_node.publish,
    v_arc_x_node.inventory,
    v_arc_x_node.uncertain,
    v_arc_x_node.macrodma_id,
    v_arc_x_node.expl_id,
    v_arc_x_node.num_value,
    a.conduit_param_1,
    a.conduit_param_2
   FROM SCHEMA_NAME.v_arc_x_node
     JOIN SCHEMA_NAME.man_conduit ON man_conduit.arc_id::text = v_arc_x_node.arc_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.conduit_param_1,ct.conduit_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''CONDUIT''
                    ORDER  BY 1,2'::text, ' VALUES (''30''),(''31'')'::text) 
                    ct(feature_id character varying, conduit_param_1 text, conduit_param_2 text)) a ON a.feature_id::text = v_arc_x_node.arc_id::text
                    WHERE v_arc_x_node.arc_type::text = 'CONDUIT'::text;



DROP VIEW IF EXISTS ve_arc_siphon;
CREATE OR REPLACE VIEW ve_arc_siphon AS 
 SELECT v_arc_x_node.arc_id,
    v_arc_x_node.code,
    v_arc_x_node.node_1,
    v_arc_x_node.node_2,
    v_arc_x_node.y1,
    v_arc_x_node.custom_y1,
    v_arc_x_node.elev1,
    v_arc_x_node.custom_elev1,
    v_arc_x_node.sys_elev1,
    v_arc_x_node.y2,
    v_arc_x_node.elev2,
    v_arc_x_node.custom_y2,
    v_arc_x_node.custom_elev2,
    v_arc_x_node.sys_elev2,
    v_arc_x_node.z1,
    v_arc_x_node.z2,
    v_arc_x_node.r1,
    v_arc_x_node.r2,
    v_arc_x_node.slope,
    v_arc_x_node.arc_type,
    v_arc_x_node.arccat_id,
    v_arc_x_node.matcat_id,
    v_arc_x_node.shape,
    v_arc_x_node.geom1 AS cat_geom1,
    v_arc_x_node.geom2 AS cat_geom2,
    v_arc_x_node.gis_length,
    v_arc_x_node.epa_type,
    v_arc_x_node.sector_id,
    v_arc_x_node.macrosector_id,
    v_arc_x_node.state,
    v_arc_x_node.state_type,
    v_arc_x_node.annotation,
    v_arc_x_node.observ,
    v_arc_x_node.comment,
    v_arc_x_node.inverted_slope,
    v_arc_x_node.custom_length,
    v_arc_x_node.dma_id,
    v_arc_x_node.soilcat_id,
    v_arc_x_node.function_type,
    v_arc_x_node.category_type,
    v_arc_x_node.fluid_type,
    v_arc_x_node.location_type,
    v_arc_x_node.workcat_id,
    v_arc_x_node.workcat_id_end,
    v_arc_x_node.buildercat_id,
    v_arc_x_node.builtdate,
    v_arc_x_node.enddate,
    v_arc_x_node.ownercat_id,
    v_arc_x_node.muni_id,
    v_arc_x_node.postcode,
    v_arc_x_node.streetaxis_id,
    v_arc_x_node.postnumber,
    v_arc_x_node.postcomplement,
    v_arc_x_node.streetaxis2_id,
    v_arc_x_node.postnumber2,
    v_arc_x_node.postcomplement2,
    v_arc_x_node.descript,
    v_arc_x_node.link,
    v_arc_x_node.verified,
    v_arc_x_node.the_geom,
    v_arc_x_node.undelete,
    v_arc_x_node.label_x,
    v_arc_x_node.label_y,
    v_arc_x_node.label_rotation,
    v_arc_x_node.publish,
    v_arc_x_node.inventory,
    v_arc_x_node.uncertain,
    v_arc_x_node.macrodma_id,
    v_arc_x_node.expl_id,
    v_arc_x_node.num_value,
    man_siphon.name
   FROM v_arc_x_node
     JOIN man_siphon ON man_siphon.arc_id::text = v_arc_x_node.arc_id::text
     WHERE arc_type = 'SIPHON';




DROP VIEW IF EXISTS ve_arc_varc;
CREATE OR REPLACE VIEW ve_arc_varc AS 
 SELECT v_arc_x_node.arc_id,
    v_arc_x_node.code,
    v_arc_x_node.node_1,
    v_arc_x_node.node_2,
    v_arc_x_node.y1,
    v_arc_x_node.custom_y1,
    v_arc_x_node.elev1,
    v_arc_x_node.custom_elev1,
    v_arc_x_node.sys_elev1,
    v_arc_x_node.y2,
    v_arc_x_node.elev2,
    v_arc_x_node.custom_y2,
    v_arc_x_node.custom_elev2,
    v_arc_x_node.sys_elev2,
    v_arc_x_node.z1,
    v_arc_x_node.z2,
    v_arc_x_node.r1,
    v_arc_x_node.r2,
    v_arc_x_node.slope,
    v_arc_x_node.arc_type,
    v_arc_x_node.arccat_id,
    v_arc_x_node.matcat_id,
    v_arc_x_node.shape,
    v_arc_x_node.geom1 AS cat_geom1,
    v_arc_x_node.geom2 AS cat_geom2,
    v_arc_x_node.gis_length,
    v_arc_x_node.epa_type,
    v_arc_x_node.sector_id,
    v_arc_x_node.macrosector_id,
    v_arc_x_node.state,
    v_arc_x_node.state_type,
    v_arc_x_node.annotation,
    v_arc_x_node.observ,
    v_arc_x_node.comment,
    v_arc_x_node.inverted_slope,
    v_arc_x_node.custom_length,
    v_arc_x_node.dma_id,
    v_arc_x_node.soilcat_id,
    v_arc_x_node.function_type,
    v_arc_x_node.category_type,
    v_arc_x_node.fluid_type,
    v_arc_x_node.location_type,
    v_arc_x_node.workcat_id,
    v_arc_x_node.workcat_id_end,
    v_arc_x_node.buildercat_id,
    v_arc_x_node.builtdate,
    v_arc_x_node.enddate,
    v_arc_x_node.ownercat_id,
    v_arc_x_node.muni_id,
    v_arc_x_node.postcode,
    v_arc_x_node.streetaxis_id,
    v_arc_x_node.postnumber,
    v_arc_x_node.postcomplement,
    v_arc_x_node.streetaxis2_id,
    v_arc_x_node.postnumber2,
    v_arc_x_node.postcomplement2,
    v_arc_x_node.descript,
    v_arc_x_node.link,
    v_arc_x_node.verified,
    v_arc_x_node.the_geom,
    v_arc_x_node.undelete,
    v_arc_x_node.label_x,
    v_arc_x_node.label_y,
    v_arc_x_node.label_rotation,
    v_arc_x_node.publish,
    v_arc_x_node.inventory,
    v_arc_x_node.uncertain,
    v_arc_x_node.macrodma_id,
    v_arc_x_node.expl_id,
    v_arc_x_node.num_value
   FROM v_arc_x_node
     JOIN man_varc ON man_varc.arc_id::text = v_arc_x_node.arc_id::text
     WHERE arc_type = 'VARC';


DROP VIEW IF EXISTS ve_arc_waccel;
CREATE OR REPLACE VIEW ve_arc_waccel AS 
 SELECT v_arc_x_node.arc_id,
    v_arc_x_node.node_1,
    v_arc_x_node.node_2,
    v_arc_x_node.y1,
    v_arc_x_node.custom_y1,
    v_arc_x_node.elev1,
    v_arc_x_node.custom_elev1,
    v_arc_x_node.sys_elev1,
    v_arc_x_node.y2,
    v_arc_x_node.elev2,
    v_arc_x_node.custom_y2,
    v_arc_x_node.custom_elev2,
    v_arc_x_node.sys_elev2,
    v_arc_x_node.z1,
    v_arc_x_node.z2,
    v_arc_x_node.r1,
    v_arc_x_node.r2,
    v_arc_x_node.slope,
    v_arc_x_node.arc_type,
    v_arc_x_node.arccat_id,
    v_arc_x_node.matcat_id,
    v_arc_x_node.shape,
    v_arc_x_node.geom1 AS cat_geom1,
    v_arc_x_node.geom2 AS cat_geom2,
    v_arc_x_node.gis_length,
    v_arc_x_node.epa_type,
    v_arc_x_node.sector_id,
    v_arc_x_node.macrosector_id,
    v_arc_x_node.state,
    v_arc_x_node.state_type,
    v_arc_x_node.annotation,
    v_arc_x_node.observ,
    v_arc_x_node.comment,
    v_arc_x_node.inverted_slope,
    v_arc_x_node.custom_length,
    v_arc_x_node.dma_id,
    v_arc_x_node.soilcat_id,
    v_arc_x_node.function_type,
    v_arc_x_node.category_type,
    v_arc_x_node.fluid_type,
    v_arc_x_node.location_type,
    v_arc_x_node.workcat_id,
    v_arc_x_node.workcat_id_end,
    v_arc_x_node.buildercat_id,
    v_arc_x_node.builtdate,
    v_arc_x_node.enddate,
    v_arc_x_node.ownercat_id,
    v_arc_x_node.muni_id,
    v_arc_x_node.postcode,
    v_arc_x_node.streetaxis_id,
    v_arc_x_node.postnumber,
    v_arc_x_node.postcomplement,
    v_arc_x_node.streetaxis2_id,
    v_arc_x_node.postnumber2,
    v_arc_x_node.postcomplement2,
    v_arc_x_node.descript,
    v_arc_x_node.link,
    v_arc_x_node.verified,
    v_arc_x_node.the_geom,
    v_arc_x_node.undelete,
    v_arc_x_node.label_x,
    v_arc_x_node.label_y,
    v_arc_x_node.label_rotation,
    v_arc_x_node.code,
    v_arc_x_node.publish,
    v_arc_x_node.inventory,
    v_arc_x_node.uncertain,
    v_arc_x_node.macrodma_id,
    v_arc_x_node.expl_id,
    v_arc_x_node.num_value,
    man_waccel.sander_length,
    man_waccel.sander_depth,
    man_waccel.prot_surface,
    man_waccel.name,
    man_waccel.accessibility
   FROM v_arc_x_node
     JOIN man_waccel ON man_waccel.arc_id::text = v_arc_x_node.arc_id::text
     WHERE arc_type = 'WACCEL';


-----------------------
-- polygon views
-----------------------

DROP VIEW IF EXISTS ve_pol_chamber;
CREATE OR REPLACE VIEW ve_pol_chamber AS 
 SELECT man_chamber.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_chamber ON man_chamber.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_chamber.pol_id::text;

DROP VIEW IF EXISTS ve_pol_gully;
CREATE OR REPLACE VIEW ve_pol_gully AS 
 SELECT gully.pol_id,
    gully.gully_id,
    polygon.the_geom
   FROM gully
     JOIN v_state_gully ON gully.gully_id::text = v_state_gully.gully_id::text
     JOIN polygon ON polygon.pol_id::text = gully.pol_id::text;

DROP VIEW IF EXISTS ve_pol_netgully;
CREATE OR REPLACE VIEW ve_pol_netgully AS 
 SELECT man_netgully.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_netgully ON man_netgully.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_netgully.pol_id::text;

DROP VIEW IF EXISTS ve_pol_storage;
CREATE OR REPLACE VIEW ve_pol_storage AS 
 SELECT man_storage.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_storage ON man_storage.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_storage.pol_id::text;

DROP VIEW IF EXISTS ve_pol_wwtp;
CREATE OR REPLACE VIEW ve_pol_wwtp AS 
 SELECT man_wwtp.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_wwtp ON man_wwtp.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_wwtp.pol_id::text;


-----------------------
-- inp edit views
-----------------------

DROP VIEW IF EXISTS ve_inp_junction CASCADE;
CREATE VIEW ve_inp_junction AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
elev AS sys_elev,
nodecat_id, 
v_node.sector_id, 
macrosector_id,
state, 
the_geom,
annotation, 
inp_junction.y0, 
inp_junction.ysur,
inp_junction.apond
FROM inp_selector_sector, v_node
    JOIN inp_junction ON inp_junction.node_id = v_node.node_id
    WHERE ((v_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS ve_inp_divider CASCADE;
CREATE VIEW ve_inp_divider AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
macrosector_id,
state, 
annotation, 
the_geom,
inp_divider.divider_type, 
inp_divider.arc_id, 
inp_divider.curve_id, 
inp_divider.qmin, 
inp_divider.ht, 
inp_divider.cd, 
inp_divider.y0, 
inp_divider.ysur, 
inp_divider.apond
FROM inp_selector_sector, v_node
    JOIN inp_divider ON (((v_node.node_id) = (inp_divider.node_id)))
    WHERE ((v_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS ve_inp_outfall CASCADE;
CREATE VIEW ve_inp_outfall AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
macrosector_id,
"state", 
the_geom,
annotation, 
inp_outfall.outfall_type, 
inp_outfall.stage, 
inp_outfall.curve_id, 
inp_outfall.timser_id,
inp_outfall.gate
FROM inp_selector_sector, v_node
    JOIN inp_outfall ON (((v_node.node_id) = (inp_outfall.node_id)))
    WHERE ((v_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS ve_inp_storage CASCADE;
CREATE VIEW ve_inp_storage AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
macrosector_id,"state", 
the_geom,
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
inp_storage.ysur
FROM inp_selector_sector, v_node
    JOIN inp_storage ON (((v_node.node_id) = (inp_storage.node_id)))
    WHERE ((v_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());




-- ----------------------------
-- View structure for v_arc
-- ----------------------------

DROP VIEW IF EXISTS ve_inp_conduit CASCADE;
CREATE VIEW ve_inp_conduit AS
SELECT 
v_arc_x_node.arc_id,
node_1,
node_2,
y1, 
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
custom_y2,
elev2,
custom_elev2,
sys_elev2,
arccat_id,
matcat_id AS cat_matcat_id,
shape AS cat_shape,
geom1 AS cat_geom1,
gis_length,
v_arc_x_node.sector_id,
macrosector_id,
state,
annotation,
inverted_slope,
custom_length,
the_geom,
inp_conduit.barrels, 
inp_conduit.culvert, 
inp_conduit.kentry, 
inp_conduit.kexit, 
inp_conduit.kavg, 
inp_conduit.flap, 
inp_conduit.q0, 
inp_conduit.qmax, 
inp_conduit.seepage, 
inp_conduit.custom_n
FROM inp_selector_sector,v_arc_x_node
    JOIN inp_conduit ON (((v_arc_x_node.arc_id) = (inp_conduit.arc_id)))
    WHERE ((v_arc_x_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS ve_inp_orifice CASCADE;
CREATE VIEW ve_inp_orifice AS
SELECT
v_arc_x_node.arc_id,
node_1,
node_2,
y1, 
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
custom_y2,
elev2,
custom_elev2,
sys_elev2,
arccat_id,
gis_length,
v_arc_x_node.sector_id,
macrosector_id,
state,
annotation,
inverted_slope,
custom_length,
the_geom,
inp_orifice.ori_type,
inp_orifice."offset", 
inp_orifice.cd, 
inp_orifice.orate, 
inp_orifice.flap, 
inp_orifice.shape, 
inp_orifice.geom1, 
inp_orifice.geom2, 
inp_orifice.geom3, 
inp_orifice.geom4,
expl_id
FROM inp_selector_sector,v_arc_x_node
    JOIN inp_orifice ON (((v_arc_x_node.arc_id) = (inp_orifice.arc_id)))
    WHERE ((v_arc_x_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS ve_inp_outlet CASCADE;
CREATE VIEW ve_inp_outlet AS
SELECT 
v_arc_x_node.arc_id,
node_1,
node_2,
y1, 
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
custom_y2,
elev2,
custom_elev2,
sys_elev2,
arccat_id,
gis_length,
v_arc_x_node.sector_id,
macrosector_id,
state,
annotation,
inverted_slope,
custom_length,
the_geom,
inp_outlet.outlet_type, 
inp_outlet."offset", 
inp_outlet.curve_id, 
inp_outlet.cd1, 
inp_outlet.cd2, 
inp_outlet.flap,
expl_id
FROM inp_selector_sector,v_arc_x_node
    JOIN inp_outlet ON (((v_arc_x_node.arc_id) = (inp_outlet.arc_id)))
    WHERE ((v_arc_x_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS ve_inp_pump CASCADE;
CREATE VIEW ve_inp_pump AS
SELECT 
v_arc_x_node.arc_id,
node_1,
node_2,
y1, 
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
custom_y2,
elev2,
custom_elev2,
sys_elev2,
arccat_id,
gis_length,
v_arc_x_node.sector_id,
macrosector_id,
state,
annotation,
inverted_slope,
custom_length,
the_geom,
inp_pump.curve_id, 
inp_pump.status, 
inp_pump.startup, 
inp_pump.shutoff,
expl_id
FROM inp_selector_sector,v_arc_x_node
    JOIN inp_pump ON (((v_arc_x_node.arc_id) = (inp_pump.arc_id)))
    WHERE ((v_arc_x_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS ve_inp_weir CASCADE;
CREATE VIEW ve_inp_weir AS 
SELECT
v_arc_x_node.arc_id,
node_1,
node_2,
y1, 
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
custom_y2,
elev2,
custom_elev2,
sys_elev2,
arccat_id,
gis_length,
v_arc_x_node.sector_id,
macrosector_id,state,
annotation,
inverted_slope,
custom_length,
the_geom,
inp_weir.weir_type, 
inp_weir."offset", 
inp_weir.cd, 
inp_weir.ec, 
inp_weir.cd2, 
inp_weir.flap, 
inp_weir.geom1, 
inp_weir.geom2, 
inp_weir.geom3, 
inp_weir.geom4, 
inp_weir.surcharge,
expl_id
FROM inp_selector_sector,v_arc_x_node
    JOIN inp_weir ON (((v_arc_x_node.arc_id) = (inp_weir.arc_id)))
    WHERE ((v_arc_x_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());



DROP VIEW IF EXISTS ve_inp_virtual CASCADE;
CREATE VIEW ve_inp_virtual AS 
SELECT
v_arc_x_node.arc_id,
node_1,
node_2,
gis_length,
v_arc_x_node.sector_id,
macrosector_id,
state,
the_geom,
fusion_node,
add_length,
expl_id
FROM inp_selector_sector,v_arc_x_node
    JOIN inp_virtual ON (((v_arc_x_node.arc_id) = (inp_virtual.arc_id)))
    WHERE ((v_arc_x_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());

  


DROP VIEW IF EXISTS ve_raingage CASCADE;
CREATE VIEW ve_raingage AS SELECT
rg_id,
form_type,
intvl,
scf,
rgage_type,
timser_id,
fname,
sta,
units,
raingage.the_geom,
raingage.expl_id
FROM selector_expl,raingage
    WHERE ((raingage.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS ve_subcatchment CASCADE;
CREATE VIEW ve_subcatchment AS SELECT
subc_id,
subcatchment.node_id,
rg_id,
area,
imperv,
width,
slope,
clength,
snow_id,
nimp,
nperv,
simp,
sperv,
zero,
routeto,
rted,
maxrate,
minrate,
decay,
drytime,
maxinfil,
suction,
conduct,
initdef,
curveno,
conduct_2,
drytime_2,
subcatchment.sector_id,
subcatchment.hydrology_id,
subcatchment.the_geom
FROM inp_selector_sector,inp_selector_hydrology, subcatchment
JOIN v_node ON v_node.node_id=subcatchment.node_id
       WHERE 
       ((subcatchment.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"()) AND
       ((subcatchment.hydrology_id)=(inp_selector_hydrology.hydrology_id) AND inp_selector_hydrology.cur_user="current_user"());



-----------------------
-- inp views
-----------------------

DROP VIEW IF EXISTS vi_title CASCADE;
CREATE OR REPLACE VIEW vi_title AS 
 SELECT inp_project_id.title,
    inp_project_id.date
   FROM inp_project_id
  ORDER BY inp_project_id.title;

DROP VIEW IF EXISTS vi_options CASCADE;
CREATE OR REPLACE VIEW vi_options AS 
 SELECT a.description as parameter,
 CASE WHEN inp_typevalue.idval is not null then inp_typevalue.idval
 else b.value end as value
   FROM audit_cat_param_user a
     LEFT JOIN config_param_user b ON a.id = b.parameter::text
     LEFT JOIN inp_typevalue ON  inp_typevalue.id=b.value and inp_typevalue.typevalue LIKE 'inp_value_options%'
  WHERE a.context = 'inp_options'::text AND b.cur_user::name = "current_user"();


DROP VIEW IF EXISTS vi_report CASCADE;
CREATE OR REPLACE VIEW vi_report AS 
 SELECT a.description as parameter,
    b.value
   FROM audit_cat_param_user a
     LEFT JOIN config_param_user b ON a.id = b.parameter::text
  WHERE a.context = 'inp_report'::text AND b.cur_user::name = "current_user"();
  

DROP VIEW IF EXISTS  vi_files CASCADE;
CREATE OR REPLACE VIEW vi_files AS 
 SELECT
    inp_files.actio_type,
    inp_files.file_type,
    inp_files.fname
   FROM inp_files;


DROP VIEW IF EXISTS vi_evaporation CASCADE;
CREATE OR REPLACE VIEW vi_evaporation AS 
 SELECT inp_evaporation.evap_type,
    inp_evaporation.value
   FROM inp_evaporation;

DROP VIEW IF EXISTS  vi_raingages CASCADE;
CREATE OR REPLACE VIEW vi_raingages AS 
SELECT v_edit_raingage.rg_id,
    v_edit_raingage.form_type,
    v_edit_raingage.intvl,
    v_edit_raingage.scf,
    concat(inp_typevalue.idval,' ',v_edit_raingage.timser_id,' ',v_edit_raingage.fname,' ',
      v_edit_raingage.sta,' ',v_edit_raingage.units) as other_val
   FROM v_edit_raingage
   LEFT JOIN inp_typevalue ON inp_typevalue.id=v_edit_raingage.rgage_type
   WHERE inp_typevalue.typevalue='inp_typevalue_raingage';


DROP VIEW IF EXISTS  vi_temperature CASCADE;
CREATE OR REPLACE VIEW vi_temperature AS 
 SELECT inp_temperature.temp_type,
    inp_temperature.value
   FROM inp_temperature;



DROP VIEW IF EXISTS  vi_subcatchments CASCADE;
CREATE OR REPLACE VIEW vi_subcatchments AS 
 SELECT v_edit_subcatchment.subc_id,
  v_edit_subcatchment.rg_id,
    v_edit_subcatchment.node_id,
    v_edit_subcatchment.area,
    v_edit_subcatchment.imperv,
    v_edit_subcatchment.width,
    v_edit_subcatchment.slope,
    v_edit_subcatchment.clength,
  v_edit_subcatchment.snow_id
   FROM v_edit_subcatchment;


DROP VIEW IF EXISTS  vi_subareas CASCADE;
CREATE OR REPLACE VIEW vi_subareas AS 
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.nimp,
    v_edit_subcatchment.nperv,
    v_edit_subcatchment.simp,
    v_edit_subcatchment.sperv,
    v_edit_subcatchment.zero,
    v_edit_subcatchment.routeto,
    v_edit_subcatchment.rted
   FROM v_edit_subcatchment;




DROP VIEW IF EXISTS  vi_infiltration CASCADE;
CREATE OR REPLACE VIEW vi_infiltration AS 
 SELECT v_edit_subcatchment.subc_id,concat(v_edit_subcatchment.curveno,' ',v_edit_subcatchment.conduct_2,' ',
  v_edit_subcatchment.drytime_2) as other_val
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
UNION
  SELECT v_edit_subcatchment.subc_id, concat(v_edit_subcatchment.suction,' ',v_edit_subcatchment.conduct,' ',
    v_edit_subcatchment.initdef) as other_val
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
UNION
 SELECT v_edit_subcatchment.subc_id,concat(v_edit_subcatchment.maxrate,' ',v_edit_subcatchment.minrate,' ',
  v_edit_subcatchment.decay,' ', v_edit_subcatchment.drytime,' ',v_edit_subcatchment.maxinfil) as other_val
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
  WHERE cat_hydrology.infiltration::text = 'MODIFIED_HORTON'::text OR cat_hydrology.infiltration::text = 'HORTON'::text
 ORDER BY other_val;


DROP VIEW IF EXISTS vi_aquifers CASCADE;
CREATE OR REPLACE VIEW vi_aquifers AS 
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


DROP VIEW IF EXISTS  vi_groundwater CASCADE;
CREATE OR REPLACE VIEW vi_groundwater AS 
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
   FROM v_edit_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_subcatchment.subc_id::text;


DROP VIEW IF EXISTS  vi_gwf CASCADE;
CREATE OR REPLACE VIEW vi_gwf AS 
 SELECT inp_groundwater.subc_id,
    ('LATERAL'::text || ' '::text) || inp_groundwater.fl_eq_lat::text AS fl_eq_lat,
    ('DEEP'::text || ' '::text) || inp_groundwater.fl_eq_lat::text AS fl_eq_deep
 FROM v_edit_subcatchment
 JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_subcatchment.subc_id::text;



DROP VIEW IF EXISTS  vi_snowpacks CASCADE;
CREATE OR REPLACE VIEW vi_snowpacks AS select
snow_id,
snow_type,
value_1,
value_2,
value_3,
value_4,
value_5,
value_6,
value_7
FROM inp_snowpack
order by snow_id;


DROP VIEW IF EXISTS  vi_junction CASCADE;
CREATE OR REPLACE VIEW vi_junction AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    rpt_inp_node.ymax,
    rpt_inp_node.y0,
    rpt_inp_node.ysur,
    rpt_inp_node.apond
   FROM inp_selector_result,rpt_inp_node
   WHERE rpt_inp_node.epa_type::text = 'JUNCTION'::text 
   AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
   AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS  vi_outfalls CASCADE;
CREATE OR REPLACE VIEW vi_outfalls AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    concat(inp_outfall.stage,' ', inp_outfall.gate) AS other_val
   FROM inp_selector_result,rpt_inp_node
     JOIN inp_outfall ON inp_outfall.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_outfall.outfall_type::text = 'FIXED'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    inp_outfall.gate AS other_val 
   FROM inp_selector_result,rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
  WHERE inp_outfall.outfall_type::text = 'FREE'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    inp_outfall.gate AS other_val
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
  WHERE inp_outfall.outfall_type::text = 'NORMAL'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_typevalue.idval AS outfall_type,
    concat(inp_outfall.curve_id,' ',inp_outfall.gate) AS other_val
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_outfall.outfall_type
   WHERE inp_typevalue.typevalue='inp_typevalue_outfall'
  AND inp_outfall.outfall_type::text = 'TIDAL_OUTFALL'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
  SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_typevalue.idval AS outfall_type,
    concat(inp_outfall.timser_id,' ',inp_outfall.gate) AS other_val
   FROM inp_selector_result,rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_outfall.outfall_type
  WHERE inp_typevalue.typevalue='inp_typevalue_outfall'
  AND inp_outfall.outfall_type::text = 'TIMESERIES_OUTFALL'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS  vi_dividers CASCADE;
CREATE OR REPLACE VIEW vi_dividers AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_divider.arc_id,
    inp_divider.divider_type,
    concat(inp_divider.qmin,' ',inp_divider.y0,' ',inp_divider.ysur,' ',inp_divider.apond) as other_val
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_divider ON rpt_inp_node.node_id::text = inp_divider.node_id::text
  WHERE inp_divider.divider_type::text = 'CUTOFF'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_divider.arc_id,
    inp_divider.divider_type,
    concat(inp_divider.y0,' ',inp_divider.ysur,' ',inp_divider.apond) as other_val
   FROM inp_selector_result,rpt_inp_node
     JOIN inp_divider ON rpt_inp_node.node_id::text = inp_divider.node_id::text
  WHERE inp_divider.divider_type::text = 'OVERFLOW'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
  SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_divider.arc_id,
    inp_typevalue.idval AS divider_type,
    concat(inp_divider.curve_id,' ',inp_divider.y0,' ',inp_divider.ysur,' ',inp_divider.apond) as other_val
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_divider ON rpt_inp_node.node_id::text = inp_divider.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_divider.divider_type
  WHERE inp_typevalue.typevalue='inp_typevalue_divider'
  AND inp_divider.divider_type::text = 'TABULAR_DIVIDER'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_divider.arc_id,
    inp_divider.divider_type,
    concat(inp_divider.qmin,' ',inp_divider.ht,' ',inp_divider.cd,' ',inp_divider.y0,' ',inp_divider.ysur,' ',
      inp_divider.apond) as other_val
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_divider ON rpt_inp_node.node_id::text = inp_divider.node_id::text
  WHERE inp_divider.divider_type::text = 'WEIR'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS  vi_storage CASCADE;
CREATE OR REPLACE VIEW vi_storage AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    rpt_inp_node.ymax,
    inp_storage.y0,
    inp_storage.storage_type,
    concat(inp_storage.a1,' ',inp_storage.a2,' ',inp_storage.a0,' ',inp_storage.apond,' ',
      inp_storage.fevap,' ',inp_storage.sh,' ',inp_storage.hc,' ',inp_storage.imd) as other_val
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_storage ON rpt_inp_node.node_id::text = inp_storage.node_id::text
  WHERE inp_storage.storage_type::text = 'FUNCTIONAL'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    rpt_inp_node.ymax,
    inp_storage.y0,
    inp_typevalue.idval AS storage_type,
    concat(inp_storage.curve_id,' ',inp_storage.apond,' ',inp_storage.fevap,' ',inp_storage.sh,' ',
      inp_storage.hc,' ',inp_storage.imd) as other_val
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_storage ON rpt_inp_node.node_id::text = inp_storage.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_storage.storage_type
  WHERE inp_typevalue.typevalue='inp_typevalue_storage'
  AND inp_storage.storage_type::text = 'TABULAR_STORAGE'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS  vi_conduits CASCADE;
CREATE OR REPLACE VIEW vi_conduits AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.n,
    rpt_inp_arc.elevmax1 AS z1,
    rpt_inp_arc.elevmax2 AS z2,
    inp_conduit.q0,
    inp_conduit.qmax
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS  vi_pumps CASCADE;
CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_pump.curve_id,
    inp_pump.status,
    inp_pump.startup,
    inp_pump.shutoff
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = inp_pump.arc_id::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_pump.curve_id,
    inp_flwreg_pump.status,
    inp_flwreg_pump.startup,
    inp_flwreg_pump.shutoff
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_flwreg_pump ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_pump.node_id, '_', inp_flwreg_pump.to_arc, '_pump_', inp_flwreg_pump.flwreg_id)
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS  vi_orifices CASCADE;
CREATE OR REPLACE VIEW vi_orifices AS 
 SELECT inp_orifice.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_orifice.ori_type,
    inp_orifice."offset",
    inp_orifice.cd,
    inp_orifice.flap,
    inp_orifice.orate
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_orifice ON inp_orifice.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_orifice.ori_type,
    inp_flwreg_orifice."offset",
    inp_flwreg_orifice.cd,
    inp_flwreg_orifice.flap,
    inp_flwreg_orifice.orate
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_flwreg_orifice ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_orifice.node_id, '_', inp_flwreg_orifice.to_arc, '_ori_', inp_flwreg_orifice.flwreg_id)
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS  vi_weirs CASCADE;
CREATE OR REPLACE VIEW vi_weirs AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_typevalue.idval as weir_type,
    inp_weir."offset",
    inp_weir.cd,
    inp_weir.flap,
    inp_weir.ec,
    inp_weir.cd2,
    inp_weir.surcharge
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_weir ON inp_weir.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_weir.weir_type
  WHERE inp_typevalue.typevalue='inp_value_weirs'
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_typevalue.idval as weir_type,
    inp_flwreg_weir."offset",
    inp_flwreg_weir.cd,
    inp_flwreg_weir.flap,
    inp_flwreg_weir.ec,
    inp_flwreg_weir.cd2,
    inp_flwreg_weir.surcharge
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_flwreg_weir ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_weir.node_id, '_', inp_flwreg_weir.to_arc, '_weir_', inp_flwreg_weir.flwreg_id)
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_flwreg_weir.weir_type
  WHERE inp_typevalue.typevalue='inp_value_weirs'
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS  vi_outlets CASCADE;
CREATE OR REPLACE VIEW vi_outlets AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_outlet."offset",
    inp_outlet.outlet_type,
    concat(inp_outlet.cd1,' ',inp_outlet.cd2,' ',inp_outlet.flap) as other_val
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_outlet ON rpt_inp_arc.arc_id::text = inp_outlet.arc_id::text
  WHERE inp_outlet.outlet_type::text = 'FUNCTIONAL/DEPTH'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_outlet."offset",
    inp_flwreg_outlet.outlet_type,
    concat(inp_flwreg_outlet.cd1,' ',inp_flwreg_outlet.cd2,' ',inp_flwreg_outlet.flap) as other_val
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_flwreg_outlet ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_outlet.node_id, '_', inp_flwreg_outlet.to_arc, '_out_', inp_flwreg_outlet.flwreg_id)
  WHERE inp_flwreg_outlet.outlet_type::text = 'FUNCTIONAL/DEPTH'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
  SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_outlet."offset",
    inp_outlet.outlet_type,
    concat(inp_outlet.cd1,' ',inp_outlet.cd2,' ',inp_outlet.flap) as other_val
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_outlet ON rpt_inp_arc.arc_id::text = inp_outlet.arc_id::text
  WHERE inp_outlet.outlet_type::text = 'FUNCTIONAL/HEAD'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_outlet."offset",
    inp_flwreg_outlet.outlet_type,
    concat(inp_flwreg_outlet.cd1,' ',inp_flwreg_outlet.cd2,' ',inp_flwreg_outlet.flap) as other_val
   FROM inp_selector_result,  rpt_inp_arc
     JOIN inp_flwreg_outlet ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_outlet.node_id, '_', inp_flwreg_outlet.to_arc, '_out_', inp_flwreg_outlet.flwreg_id)
  WHERE inp_flwreg_outlet.outlet_type::text = 'FUNCTIONAL/HEAD'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_outlet."offset",
    inp_outlet.outlet_type,
    concat(inp_outlet.curve_id,' ',inp_outlet.flap) as other_val
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_outlet ON rpt_inp_arc.arc_id::text = inp_outlet.arc_id::text
  WHERE inp_outlet.outlet_type::text = 'TABULAR/DEPTH'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_outlet."offset",
    inp_flwreg_outlet.outlet_type,
    concat(inp_flwreg_outlet.curve_id,' ',inp_flwreg_outlet.flap) as other_val
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_flwreg_outlet ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_outlet.node_id, '_', inp_flwreg_outlet.to_arc, '_out_', inp_flwreg_outlet.flwreg_id)
  WHERE inp_flwreg_outlet.outlet_type::text = 'TABULAR/DEPTH'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_outlet."offset",
    inp_outlet.outlet_type,
    concat(inp_outlet.curve_id,' ',inp_outlet.flap) as other_val
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_outlet ON rpt_inp_arc.arc_id::text = inp_outlet.arc_id::text
  WHERE inp_outlet.outlet_type::text = 'TABULAR/HEAD'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_outlet."offset",
    inp_flwreg_outlet.outlet_type,
    concat(inp_flwreg_outlet.curve_id,' ',inp_flwreg_outlet.flap) as other_val
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_flwreg_outlet ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_outlet.node_id, '_', inp_flwreg_outlet.to_arc, '_out_', inp_flwreg_outlet.flwreg_id)
  WHERE inp_flwreg_outlet.outlet_type::text = 'TABULAR/HEAD'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS  vi_xsections CASCADE;
CREATE OR REPLACE VIEW vi_xsections AS 
SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    concat(cat_arc_shape.curve_id,' ',cat_arc.geom1,' ',cat_arc.geom2,' ',cat_arc.geom3,' ',
      cat_arc.geom4,' ',inp_conduit.barrels,' ',inp_conduit.culvert) as other_val
  FROM inp_selector_result,rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text <> 'IRREGULAR'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    concat(cat_arc_shape.tsect_id,' ',cat_arc.geom1,' ',cat_arc.geom2,' ',cat_arc.geom3,' ',
      cat_arc.geom4,' ',inp_conduit.barrels,' ',inp_conduit.culvert) as other_val
  FROM inp_selector_result, rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'IRREGULAR'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT inp_orifice.arc_id,
    inp_typevalue.idval as shape,
    concat(inp_orifice.geom1,' ',inp_orifice.geom2,' ',inp_orifice.geom3,' ',inp_orifice.geom4) as other_val
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_orifice ON inp_orifice.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_orifice.shape
  WHERE inp_typevalue.typevalue='inp_value_orifice'
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval as shape,
    concat(inp_flwreg_orifice.geom1,' ',inp_flwreg_orifice.geom2,' ',inp_flwreg_orifice.geom3,' ',
      inp_flwreg_orifice.geom4) as other_val
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_flwreg_orifice ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_orifice.node_id, '_', inp_flwreg_orifice.to_arc, '_ori_', inp_flwreg_orifice.flwreg_id)
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_flwreg_orifice.shape
  WHERE inp_typevalue.typevalue='inp_value_orifice'
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript as shape,
    concat(inp_weir.geom1,' ',inp_weir.geom2,' ',inp_weir.geom3,' ',inp_weir.geom4) as other_val
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_weir ON inp_weir.arc_id::text = rpt_inp_arc.arc_id::text
     JOIN inp_typevalue ON inp_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript as shape,
    concat(inp_flwreg_weir.geom1,' ',inp_flwreg_weir.geom2,' ',inp_flwreg_weir.geom3) as other_val
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_flwreg_weir ON rpt_inp_arc.flw_code::text = 
     concat(inp_flwreg_weir.node_id, '_', inp_flwreg_weir.to_arc, '_weir_', inp_flwreg_weir.flwreg_id)
     JOIN inp_typevalue ON inp_flwreg_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS  vi_losses CASCADE;
CREATE OR REPLACE VIEW vi_losses AS 
 SELECT inp_conduit.arc_id,
    inp_conduit.kentry,
    inp_conduit.kexit,
    inp_conduit.kavg,
    inp_conduit.flap,
    inp_conduit.seepage
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
  WHERE inp_conduit.kentry > 0::numeric OR inp_conduit.kexit > 0::numeric OR inp_conduit.kavg > 0::numeric OR inp_conduit.flap::text = 'YES'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_transects CASCADE;
CREATE OR REPLACE VIEW vi_transects AS 
 SELECT inp_transects.text
   FROM inp_transects;


DROP VIEW IF EXISTS vi_controls CASCADE;
CREATE OR REPLACE VIEW vi_controls AS 
 SELECT inp_controls_x_arc.text
   FROM inp_selector_sector,inp_controls_x_arc
     JOIN rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_inp_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
UNION
 SELECT inp_controls_x_node.text
   FROM inp_selector_sector, inp_controls_x_node
     JOIN rpt_inp_node ON inp_controls_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
  ORDER BY 1;


DROP VIEW IF EXISTS  vi_pollutants CASCADE;
CREATE OR REPLACE VIEW vi_pollutants AS 
 SELECT inp_pollutant.poll_id,
    inp_pollutant.units_type,
    inp_pollutant.crain,
    inp_pollutant.cgw,
    inp_pollutant.cii,
    inp_pollutant.kd,
    inp_pollutant.sflag,
    inp_pollutant.copoll_id,
    inp_pollutant.cofract,
    inp_pollutant.cdwf
   FROM inp_pollutant
  ORDER BY inp_pollutant.poll_id;


DROP VIEW IF EXISTS  vi_landuses CASCADE;
CREATE OR REPLACE VIEW vi_landuses AS 
 SELECT inp_landuses.landus_id,
    inp_landuses.sweepint,
    inp_landuses.availab,
    inp_landuses.lastsweep
   FROM inp_landuses;


DROP VIEW IF EXISTS  vi_coverages CASCADE;
CREATE OR REPLACE VIEW vi_coverages AS 
 SELECT v_edit_subcatchment.subc_id,
    inp_coverage_land_x_subc.landus_id,
    inp_coverage_land_x_subc.percent
   FROM inp_coverage_land_x_subc
     JOIN v_edit_subcatchment ON inp_coverage_land_x_subc.subc_id::text = v_edit_subcatchment.subc_id::text;

DROP VIEW IF EXISTS  vi_buildup CASCADE;
CREATE OR REPLACE VIEW vi_buildup AS 
 SELECT inp_buildup_land_x_pol.landus_id,
    inp_buildup_land_x_pol.poll_id,
    inp_typevalue.idval as funcb_type,
    inp_buildup_land_x_pol.c1,
    inp_buildup_land_x_pol.c2,
    inp_buildup_land_x_pol.c3,
    inp_buildup_land_x_pol.perunit
   FROM inp_buildup_land_x_pol
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_buildup_land_x_pol.funcb_type
  WHERE inp_typevalue.typevalue='inp_value_buildup';


DROP VIEW IF EXISTS  vi_washoff CASCADE;
CREATE OR REPLACE VIEW vi_washoff AS 
 SELECT inp_washoff_land_x_pol.landus_id,
    inp_washoff_land_x_pol.poll_id,
    inp_typevalue.idval as funcw_type,
    inp_washoff_land_x_pol.c1,
    inp_washoff_land_x_pol.c2,
    inp_washoff_land_x_pol.sweepeffic,
    inp_washoff_land_x_pol.bmpeffic
   FROM inp_washoff_land_x_pol
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_washoff_land_x_pol.funcw_type
  WHERE inp_typevalue.typevalue='inp_value_washoff';

DROP VIEW IF EXISTS  vi_treatment CASCADE;
CREATE OR REPLACE VIEW vi_treatment AS 
 SELECT rpt_inp_node.node_id,
    inp_treatment_node_x_pol.poll_id,
    inp_typevalue.idval as function
   FROM inp_selector_result,rpt_inp_node
     JOIN inp_treatment_node_x_pol ON inp_treatment_node_x_pol.node_id::text = rpt_inp_node.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_treatment_node_x_pol.function
  WHERE inp_typevalue.typevalue='inp_value_treatment'
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text
   AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS  vi_dwf CASCADE;
CREATE OR REPLACE VIEW vi_dwf AS 
 SELECT rpt_inp_node.node_id,
    'FLOW'::text AS type_dwf,
    inp_dwf.value,
    inp_dwf.pat1,
    inp_dwf.pat2,
    inp_dwf.pat3,
    inp_dwf.pat4
   FROM inp_selector_result,
    rpt_inp_node
     JOIN inp_dwf ON inp_dwf.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
  SELECT rpt_inp_node.node_id,
    inp_dwf_pol_x_node.poll_id AS type_dwf,
    inp_dwf_pol_x_node.value,
    inp_dwf_pol_x_node.pat1,
    inp_dwf_pol_x_node.pat2,
    inp_dwf_pol_x_node.pat3,
    inp_dwf_pol_x_node.pat4
   FROM inp_selector_result,
    rpt_inp_node
     JOIN inp_dwf_pol_x_node ON inp_dwf_pol_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;




DROP VIEW IF EXISTS vi_patterns CASCADE;
CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.pattern_id,
    inp_pattern.pattern_type,
    concat(inp_pattern_value.factor_1,' ',inp_pattern_value.factor_2,' ',inp_pattern_value.factor_3,' ',inp_pattern_value.factor_4,' ',
    inp_pattern_value.factor_5,' ',inp_pattern_value.factor_6,' ',inp_pattern_value.factor_7,' ',inp_pattern_value.factor_8,' ',
    inp_pattern_value.factor_9,' ',inp_pattern_value.factor_10,' ',inp_pattern_value.factor_11,' ', inp_pattern_value.factor_12,' ',
    inp_pattern_value.factor_13,' ', inp_pattern_value.factor_14,' ',inp_pattern_value.factor_15,' ', inp_pattern_value.factor_16,' ',
    inp_pattern_value.factor_17,' ', inp_pattern_value.factor_18,' ',inp_pattern_value.factor_19,' ',inp_pattern_value.factor_20,' ',
    inp_pattern_value.factor_21,' ',inp_pattern_value.factor_22,' ',inp_pattern_value.factor_23,' ',inp_pattern_value.factor_24) as multipliers
   FROM inp_pattern_value
   JOIN inp_pattern ON inp_pattern_value.pattern_id=inp_pattern.pattern_id
  ORDER BY inp_pattern_value.pattern_id;



DROP VIEW IF EXISTS  vi_inflows CASCADE;
CREATE OR REPLACE VIEW vi_inflows AS 
 SELECT rpt_inp_node.node_id,
    'FLOW'::text AS type_flow,
    inp_inflows.timser_id,
    concat('FLOW'::text,' ','1'::text,' ',inp_inflows.sfactor,' ',inp_inflows.base,' ',
      inp_inflows.pattern_id) as other_val
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_inflows ON inp_inflows.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    inp_inflows_pol_x_node.poll_id AS type_flow,
    inp_inflows_pol_x_node.timser_id,
    concat(inp_typevalue.idval,' ',inp_inflows_pol_x_node.mfactor,' ',
      inp_inflows_pol_x_node.sfactor,' ',inp_inflows_pol_x_node.base,' ',inp_inflows_pol_x_node.pattern_id)
   FROM inp_selector_result,rpt_inp_node
     JOIN inp_inflows_pol_x_node ON inp_inflows_pol_x_node.node_id::text = rpt_inp_node.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_inflows_pol_x_node.form_type
  WHERE inp_typevalue.typevalue='inp_value_inflows'
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_loadings CASCADE;
CREATE OR REPLACE VIEW vi_loadings AS 
 SELECT inp_loadings_pol_x_subc.subc_id,
  inp_loadings_pol_x_subc.poll_id,
    inp_loadings_pol_x_subc.ibuildup
   FROM v_edit_subcatchment
     JOIN inp_loadings_pol_x_subc ON inp_loadings_pol_x_subc.subc_id::text = v_edit_subcatchment.subc_id::text;



DROP VIEW IF EXISTS  vi_rdii CASCADE;
CREATE OR REPLACE VIEW vi_rdii AS 
 SELECT rpt_inp_node.node_id,
    inp_rdii.hydro_id,
    inp_rdii.sewerarea
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_rdii ON inp_rdii.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS  vi_hydrographs CASCADE;
CREATE OR REPLACE VIEW vi_hydrographs AS 
 SELECT 
 inp_hydrograph.hydro_id,
 inp_hydrograph.text
   FROM inp_hydrograph;


DROP VIEW IF EXISTS  vi_curves CASCADE;
CREATE OR REPLACE VIEW vi_curves AS 
 SELECT inp_curve.curve_id,
    CASE
       WHEN inp_curve.x_value = (( SELECT min(sub.x_value) AS min
          FROM inp_curve sub
          WHERE sub.curve_id::text = inp_curve.curve_id::text)) THEN inp_typevalue.idval
       ELSE NULL::character varying
     END AS curve_type,
    inp_curve.x_value,
    inp_curve.y_value
   FROM inp_curve
     JOIN inp_curve_id ON inp_curve_id.id::text = inp_curve.curve_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_curve_id.curve_type
   WHERE inp_typevalue.typevalue='inp_value_curve'
  ORDER BY inp_curve.id;


DROP VIEW IF EXISTS  vi_timeseries CASCADE;
CREATE OR REPLACE VIEW vi_timeseries AS 
 SELECT inp_timeseries.timser_id,
    concat(inp_timeseries.date,' ',inp_timeseries.hour,' ',inp_timeseries.value) as other_val
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'ABSOLUTE'::text
UNION
 SELECT inp_timeseries.timser_id,
    concat('FILE',' ',inp_timeseries.fname) as other_val
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'FILE_TIME'::text
UNION
 SELECT inp_timeseries.timser_id,
    concat(inp_timeseries."time",' ',inp_timeseries.value) as other_val
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'RELATIVE'::text
ORDER BY 1,2;


DROP VIEW IF EXISTS vi_lid_controls CASCADE;
CREATE OR REPLACE VIEW vi_lid_controls AS 
 SELECT inp_lid_control.lidco_id,
    inp_typevalue.idval as lidco_type,
    concat(inp_lid_control.value_2,' ',inp_lid_control.value_3,' ',inp_lid_control.value_4,' ',
      inp_lid_control.value_5,' ',inp_lid_control.value_6,' ',inp_lid_control.value_7,' ',
      inp_lid_control.value_8) as other_val
   FROM inp_lid_control
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_lid_control.lidco_type
  WHERE inp_typevalue.typevalue='inp_value_lidcontrol'
  ORDER BY inp_lid_control.id;


DROP VIEW IF EXISTS vi_lid_usage CASCADE;
CREATE OR REPLACE VIEW vi_lid_usage AS 
 SELECT inp_lidusage_subc_x_lidco.subc_id,
    inp_lidusage_subc_x_lidco.lidco_id,
    inp_lidusage_subc_x_lidco.number::integer AS number,
    inp_lidusage_subc_x_lidco.area,
    inp_lidusage_subc_x_lidco.width,
    inp_lidusage_subc_x_lidco.initsat,
    inp_lidusage_subc_x_lidco.fromimp,
    inp_lidusage_subc_x_lidco.toperv::integer AS toperv,
    inp_lidusage_subc_x_lidco.rptfile
   FROM v_edit_subcatchment
     JOIN inp_lidusage_subc_x_lidco ON inp_lidusage_subc_x_lidco.subc_id::text = v_edit_subcatchment.subc_id::text;



DROP VIEW IF EXISTS vi_adjustments CASCADE;
CREATE OR REPLACE VIEW vi_adjustments AS 
 SELECT inp_adjustments.adj_type,
    concat(inp_adjustments.value_1,' ',inp_adjustments.value_2,' ',inp_adjustments.value_3,' ',
      inp_adjustments.value_4,' ',inp_adjustments.value_5,' ',inp_adjustments.value_6,' ',
      inp_adjustments.value_7,' ',inp_adjustments.value_8,' ',inp_adjustments.value_9,' ',
      inp_adjustments.value_10,' ',inp_adjustments.value_11,' ',inp_adjustments.value_12) as monthly_adj
   FROM inp_adjustments
  ORDER BY inp_adjustments.adj_type;


DROP VIEW IF EXISTS vi_map CASCADE;
CREATE OR REPLACE VIEW vi_map AS 
 SELECT inp_mapdim.type_dim,
    concat(inp_mapdim.x1,' ',inp_mapdim.y1,' ',inp_mapdim.x2,' ',inp_mapdim.y2)as other_val
   FROM inp_mapdim
UNION
 SELECT inp_typevalue.idval as type_units,
    inp_mapunits.map_type as other_val
   FROM inp_mapunits
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_mapunits.type_units
  WHERE inp_typevalue.typevalue='inp_value_mapunits';;


DROP VIEW IF EXISTS vi_backdrop CASCADE;
CREATE OR REPLACE VIEW vi_backdrop AS 
 SELECT inp_backdrop.text
   FROM inp_backdrop;


DROP VIEW IF EXISTS vi_symbols CASCADE;
CREATE OR REPLACE VIEW vi_symbols AS 
 SELECT v_edit_raingage.rg_id,
    st_x(v_edit_raingage.the_geom)::numeric(16,3) AS xcoord,
    st_y(v_edit_raingage.the_geom)::numeric(16,3) AS ycoord
   FROM v_edit_raingage;


DROP VIEW IF EXISTS vi_labels CASCADE;
CREATE OR REPLACE VIEW vi_labels AS 
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



DROP VIEW IF EXISTS vi_coordinates CASCADE;
CREATE OR REPLACE VIEW vi_coordinates AS 
 SELECT rpt_inp_node.node_id,
    st_x(rpt_inp_node.the_geom)::numeric(16,3) AS xcoord,
    st_y(rpt_inp_node.the_geom)::numeric(16,3) AS ycoord
   FROM inp_selector_result,
    rpt_inp_node
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_vertices CASCADE;
CREATE OR REPLACE VIEW vi_vertices AS 
 SELECT
    arc.arc_id,
    st_x(arc.point)::numeric(16,3) AS xcoord,
    st_y(arc.point)::numeric(16,3) AS ycoord
   FROM ( SELECT (st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
            st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.state,
            rpt_inp_arc.arc_id
           FROM inp_selector_result,
            rpt_inp_arc
          WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
          AND inp_selector_result.cur_user = "current_user"()::text) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) 
  AND (arc.point < arc.endpoint OR arc.point > arc.endpoint);


DROP VIEW IF EXISTS vi_polygons CASCADE;
CREATE OR REPLACE VIEW vi_polygons AS 
 SELECT
 temp_table.text_column
 FROM temp_table
 WHERE fprocesscat_id=17;
