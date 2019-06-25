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
 SELECT v_edit_arc.arc_id AS nid,
    v_edit_arc.arc_type AS custom_type
   FROM v_edit_arc;
   
  
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
    a.chamber_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_chamber ON man_chamber.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.chamber_param_1,ct.chamber_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''CHAMBER''
                    ORDER  BY 1,2'::text, ' VALUES (''3''),(''4'')'::text) 
                    ct(feature_id character varying, chamber_param_1 text, chamber_param_2 date)) a ON a.feature_id::text = v_node.node_id::text
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
    man_chamber.name,
    a.weir_param_1,
    a.weir_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_chamber ON man_chamber.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.weir_param_1,ct.weir_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''WEIR''
                    ORDER  BY 1,2'::text, ' VALUES (''47''),(''48'')'::text) 
                    ct(feature_id character varying, weir_param_1 integer, weir_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.node_type::text = 'WEIR'::text;


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
    v_node.num_value,
    a.register_param_1,
    a.register_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_junction ON man_junction.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.register_param_1,ct.register_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''REGISTER''
                    ORDER  BY 1,2'::text, ' VALUES (''28''),(''29'')'::text) 
                    ct(feature_id character varying, register_param_1 date, register_param_2 integer)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.node_type::text = 'REGISTER'::text;


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
    a.circmanhole_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_manhole ON man_manhole.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.circmanhole_param_1,ct.circmanhole_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''CIRC-MANHOLE''
                    ORDER  BY 1,2'::text, ' VALUES (''5''),(''6'')'::text) 
                    ct(feature_id character varying, circmanhole_param_1 integer, circmanhole_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
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
                    ORDER  BY 1,2'::text, ' VALUES (''26''),(''27'')'::text) 
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
    man_storage.name,
    a.owestorage_param_1,
    a.owestorage_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_storage ON man_storage.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.owestorage_param_1,ct.owestorage_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''OWERFLOW-STORAGE''
                    ORDER  BY 1,2'::text, ' VALUES (''22''),(''23'')'::text) 
                    ct(feature_id character varying, owestorage_param_1 text, owestorage_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.node_type::text = 'OWERFLOW-STORAGE'::text;


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
                    ORDER  BY 1,2'::text, ' VALUES (''35''),(''36'')'::text) 
                    ct(feature_id character varying, sewerstorage_param_1 text, sewerstorage_param_2 integer)) a ON a.feature_id::text = v_node.node_id::text
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
    man_valve.name
   FROM v_node
    JOIN man_valve ON man_valve.node_id::text = v_node.node_id::text
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

-- connec
CREATE OR REPLACE VIEW ve_connec_connec AS 
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


-- gully
CREATE OR REPLACE VIEW ve_gully_gully AS 
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


CREATE OR REPLACE VIEW ve_gully_pgully AS 
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
    gully.num_value,
    a.grate_param_1,
    a.grate_param_2
   FROM SCHEMA_NAME.gully
     JOIN SCHEMA_NAME.v_state_gully ON gully.gully_id::text = v_state_gully.gully_id::text
     LEFT JOIN SCHEMA_NAME.cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN SCHEMA_NAME.ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN SCHEMA_NAME.dma ON gully.dma_id = dma.dma_id
     LEFT JOIN SCHEMA_NAME.sector ON gully.sector_id = sector.sector_id
     LEFT JOIN SCHEMA_NAME.gully_type ON gully.gully_type::text = gully_type.id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.grate_param_1,ct.grate_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''SEWER-STORAGE''
                    ORDER  BY 1,2'::text, ' VALUES (''35''),(''36'')'::text) 
                    ct(feature_id character varying, grate_param_1 text, grate_param_2 boolean)) a ON a.feature_id::text = gully.gully_id::text
                    WHERE gully.gully_type::text = 'SEWER-STORAGE'::text;     
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
    v_arc_x_node.num_value,
    a.pumpipe_param_1,
    a.pumpipe_param_2
   FROM SCHEMA_NAME.v_arc_x_node
     JOIN SCHEMA_NAME.man_conduit ON man_conduit.arc_id::text = v_arc_x_node.arc_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.pumpipe_param_1,ct.pumpipe_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''PUMP-PIPE''
                    ORDER  BY 1,2'::text, ' VALUES (''24''),(''25'')'::text) 
                    ct(feature_id character varying, pumpipe_param_1 boolean, pumpipe_param_2 text)) a ON a.feature_id::text = v_arc_x_node.arc_id::text
                    WHERE v_arc_x_node.arc_type::text = 'PUMP-PIPE'::text;




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
    v_arc_x_node.num_value
   FROM v_arc_x_node
   JOIN man_conduit ON man_conduit.arc_id::text = v_arc_x_node.arc_id::text
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

