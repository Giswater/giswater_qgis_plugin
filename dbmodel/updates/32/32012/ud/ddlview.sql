/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS ve_inp_conduit;
DROP VIEW IF EXISTS ve_inp_pump;
DROP VIEW IF EXISTS ve_inp_orifice;
DROP VIEW IF EXISTS ve_inp_outlet;
DROP VIEW IF EXISTS ve_inp_weir;
DROP VIEW IF EXISTS ve_inp_storage;
DROP VIEW IF EXISTS ve_inp_junction;
DROP VIEW IF EXISTS ve_inp_divider;
DROP VIEW IF EXISTS ve_inp_outfall;


DROP VIEW IF EXISTS v_inp_adjustments;
DROP VIEW IF EXISTS v_inp_aquifer;
DROP VIEW IF EXISTS v_inp_backdrop;
DROP VIEW IF EXISTS v_inp_buildup;
DROP VIEW IF EXISTS v_inp_conduit_cu;
DROP VIEW IF EXISTS v_inp_conduit_no;
DROP VIEW IF EXISTS v_inp_conduit_xs;
DROP VIEW IF EXISTS v_inp_controls;
DROP VIEW IF EXISTS v_inp_coverages;
DROP VIEW IF EXISTS v_inp_curve;
DROP VIEW IF EXISTS v_inp_divider_cu;
DROP VIEW IF EXISTS v_inp_divider_ov;
DROP VIEW IF EXISTS v_inp_divider_tb;
DROP VIEW IF EXISTS v_inp_divider_wr;
DROP VIEW IF EXISTS v_inp_dwf_flow;
DROP VIEW IF EXISTS v_inp_dwf_load;
DROP VIEW IF EXISTS v_inp_evap_co;
DROP VIEW IF EXISTS v_inp_evap_do;
DROP VIEW IF EXISTS v_inp_evap_fl;
DROP VIEW IF EXISTS v_inp_evap_mo;
DROP VIEW IF EXISTS v_inp_evap_pa;
DROP VIEW IF EXISTS v_inp_evap_te;
DROP VIEW IF EXISTS v_inp_evap_ts;
DROP VIEW IF EXISTS v_inp_files;
DROP VIEW IF EXISTS v_inp_groundwater;
DROP VIEW IF EXISTS v_inp_hydrograph;
DROP VIEW IF EXISTS v_inp_infiltration_cu;
DROP VIEW IF EXISTS v_inp_infiltration_gr;
DROP VIEW IF EXISTS v_inp_infiltration_ho;
DROP VIEW IF EXISTS v_inp_inflows_flow;
DROP VIEW IF EXISTS v_inp_inflows_load;
DROP VIEW IF EXISTS v_inp_junction;
DROP VIEW IF EXISTS v_inp_label;
DROP VIEW IF EXISTS v_inp_landuses;
DROP VIEW IF EXISTS v_inp_lidusage;
DROP VIEW IF EXISTS v_inp_loadings;
DROP VIEW IF EXISTS v_inp_losses;
DROP VIEW IF EXISTS v_inp_mapdim;
DROP VIEW IF EXISTS v_inp_mapunits;
DROP VIEW IF EXISTS v_inp_options;
DROP VIEW IF EXISTS v_inp_orifice;
DROP VIEW IF EXISTS v_inp_outfall_fi;
DROP VIEW IF EXISTS v_inp_outfall_fr;
DROP VIEW IF EXISTS v_inp_outfall_nm;
DROP VIEW IF EXISTS v_inp_outfall_ti;
DROP VIEW IF EXISTS v_inp_outfall_ts;
DROP VIEW IF EXISTS v_inp_outlet_fcd;
DROP VIEW IF EXISTS v_inp_outlet_fch;
DROP VIEW IF EXISTS v_inp_outlet_tbd;
DROP VIEW IF EXISTS v_inp_outlet_tbh;
DROP VIEW IF EXISTS v_inp_pattern_dl;
DROP VIEW IF EXISTS v_inp_pattern_ho;
DROP VIEW IF EXISTS v_inp_pattern_mo;
DROP VIEW IF EXISTS v_inp_pattern_we;
DROP VIEW IF EXISTS v_inp_pollutant;
DROP VIEW IF EXISTS v_inp_project_id;
DROP VIEW IF EXISTS v_inp_pump;
DROP VIEW IF EXISTS v_inp_rdii;
DROP VIEW IF EXISTS v_inp_report;
DROP VIEW IF EXISTS v_inp_rgage_fl;
DROP VIEW IF EXISTS v_inp_rgage_ts;
DROP VIEW IF EXISTS v_inp_snowpack;
DROP VIEW IF EXISTS v_inp_storage_fc;
DROP VIEW IF EXISTS v_inp_storage_tb;
DROP VIEW IF EXISTS v_inp_subcatch;
DROP VIEW IF EXISTS v_inp_temp_fl;
DROP VIEW IF EXISTS v_inp_temp_sn;
DROP VIEW IF EXISTS v_inp_temp_ts;
DROP VIEW IF EXISTS v_inp_temp_wf;
DROP VIEW IF EXISTS v_inp_temp_wm;
DROP VIEW IF EXISTS v_inp_timser_abs;
DROP VIEW IF EXISTS v_inp_timser_fl;
DROP VIEW IF EXISTS v_inp_timser_rel;
DROP VIEW IF EXISTS v_inp_transects;
DROP VIEW IF EXISTS v_inp_treatment;
DROP VIEW IF EXISTS v_inp_vertice;
DROP VIEW IF EXISTS v_inp_washoff;
DROP VIEW IF EXISTS v_inp_weir;


DROP VIEW IF EXISTS vp_basic_arc;
CREATE OR REPLACE VIEW vp_basic_arc AS 
 SELECT v_edit_arc.arc_id AS nid,
    v_edit_arc.arc_type AS custom_type
   FROM v_edit_arc;
   
  
DROP VIEW IF EXISTS vp_basic_node;
CREATE OR REPLACE VIEW vp_basic_node AS 
 SELECT v_edit_node.node_id AS nid,
    v_edit_node.node_type AS custom_type
   FROM v_edit_node;
   
   
DROP VIEW IF EXISTS vp_basic_connec ;
CREATE OR REPLACE VIEW vp_basic_connec AS 
 SELECT v_edit_connec.connec_id AS nid,
    v_edit_connec.connec_type AS custom_type
   FROM SCHEMA_NAME.v_edit_connec;
   

DROP VIEW IF EXISTS vp_basic_gully;
CREATE OR REPLACE VIEW vp_basic_gully AS 
 SELECT v_edit_gully.gully_id AS nid,
    v_edit_gully.gully_type AS custom_type
   FROM v_edit_gully;
   
  
CREATE OR REPLACE VIEW vp_epa_arc AS 
 SELECT arc.arc_id AS nid,
    arc.epa_type,
        CASE
            WHEN arc.epa_type::text = 'CONDUIT'::text THEN 'v_edit_inp_conduit'::text
            WHEN arc.epa_type::text = 'PUMP'::text THEN 'v_edit_inp_pump'::text
            WHEN arc.epa_type::text = 'ORIFICE'::text THEN 'v_edit_inp_orifice'::text
            WHEN arc.epa_type::text = 'WEIR'::text THEN 'v_edit_inp_weir'::text
            WHEN arc.epa_type::text = 'OUTLET'::text THEN 'v_edit_inp_outlet'::text
            WHEN arc.epa_type::text = 'NOT DEFINED'::text THEN NULL::text
            ELSE NULL::text
        END AS epatable
   FROM arc;


CREATE OR REPLACE VIEW vp_epa_node AS 
 SELECT node.node_id AS nid,
    node.epa_type,
        CASE
            WHEN node.epa_type::text = 'JUNCTION'::text THEN 'v_edit_inp_junction'::text
            WHEN node.epa_type::text = 'STORAGE'::text THEN 'v_edit_inp_storage'::text
            WHEN node.epa_type::text = 'DIVIDER'::text THEN 'v_edit_inp_divider'::text
            WHEN node.epa_type::text = 'OUTFALL'::text THEN 'v_edit_inp_outfall'::text
            WHEN node.epa_type::text = 'NOT DEFINED'::text THEN NULL::text
            ELSE NULL::text
        END AS epatable
   FROM node;

   
CREATE OR REPLACE VIEW ve_node AS 
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
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
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
    cat_connec.label,
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
    cat_grate.label,
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
