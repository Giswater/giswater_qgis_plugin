/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


-- delete all views to avoid conflicts, then recreate them
DROP VIEW IF EXISTS v_plan_psector_budget_detail;
DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_psector_budget;
DROP VIEW IF EXISTS v_plan_psector_all;
DROP VIEW IF EXISTS v_plan_current_psector;
DROP VIEW IF EXISTS v_plan_psector_arc;
DROP VIEW IF EXISTS v_plan_psector_connec;
DROP VIEW IF EXISTS v_plan_psector_node;
DROP VIEW IF EXISTS v_plan_psector_link;
DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_plan_result_arc;
DROP VIEW IF EXISTS v_plan_netscenario_arc;
DROP VIEW IF EXISTS v_plan_netscenario_node;
DROP VIEW IF EXISTS v_plan_netscenario_connec;
DROP VIEW IF EXISTS v_edit_plan_netscenario_valve;
DROP VIEW IF EXISTS v_ui_plan_arc_cost;

DROP VIEW IF EXISTS v_ui_workcat_x_feature;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;

DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_outlet;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_virtual;
DROP VIEW IF EXISTS v_edit_inp_weir;

DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_weir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_outlet;
DROP VIEW IF EXISTS v_edit_inp_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_flwreg_weir;
DROP VIEW IF EXISTS v_edit_inp_flwreg_outlet;


DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
DROP VIEW IF EXISTS v_edit_inp_dscenario_treatment;
DROP VIEW IF EXISTS v_edit_inp_dwf;
DROP VIEW IF EXISTS v_edit_inp_inflows;
DROP VIEW IF EXISTS v_edit_inp_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_treatment;
DROP VIEW IF EXISTS v_edit_inp_junction;

DROP VIEW IF EXISTS v_edit_inp_divider;
DROP VIEW IF EXISTS v_edit_inp_dscenario_outfall;
DROP VIEW IF EXISTS v_edit_inp_outfall;
DROP VIEW IF EXISTS v_edit_inp_dscenario_storage;
DROP VIEW IF EXISTS v_edit_inp_storage;
DROP VIEW IF EXISTS v_edit_inp_netgully;
DROP VIEW IF EXISTS v_edit_man_netelement;
DROP VIEW IF EXISTS v_plan_psector_budget_node;
DROP VIEW IF EXISTS v_plan_result_node;
DROP VIEW IF EXISTS v_ui_plan_node_cost;
DROP VIEW IF EXISTS v_plan_node;
DROP VIEW IF EXISTS ve_pol_chamber;
DROP VIEW IF EXISTS ve_pol_netgully;
DROP VIEW IF EXISTS ve_pol_node;
DROP VIEW IF EXISTS ve_pol_storage;
DROP VIEW IF EXISTS ve_pol_wwtp;
DROP VIEW IF EXISTS vi_coverages;
DROP VIEW IF EXISTS vi_groundwater;

DROP VIEW IF EXISTS v_edit_inp_dscenario_conduit;
DROP VIEW IF EXISTS v_edit_inp_conduit;

DROP VIEW IF EXISTS v_rtc_period_dma;
DROP VIEW IF EXISTS v_rtc_period_node;
DROP VIEW IF EXISTS v_rtc_period_pjoint;
DROP VIEW IF EXISTS v_rtc_period_hydrometer;

DROP VIEW IF EXISTS ve_pol_connec;

DROP VIEW IF EXISTS v_ui_presszone;
DROP VIEW IF EXISTS v_ui_arc_x_relations;
DROP VIEW IF EXISTS v_ui_arc_x_node;
DROP VIEW IF EXISTS v_ui_node_x_relations;

DROP VIEW IF EXISTS vu_element_x_node;
DROP VIEW IF EXISTS vu_element_x_connec;
DROP VIEW IF EXISTS vu_element_x_arc;
DROP VIEW IF EXISTS vu_element_x_gully;

DROP VIEW IF EXISTS v_ui_element;
DROP VIEW IF EXISTS v_ui_element_x_arc;
DROP VIEW IF EXISTS v_ui_element_x_connec;
DROP VIEW IF EXISTS v_ui_element_x_node;
DROP VIEW IF EXISTS ve_pol_element;

DROP VIEW IF EXISTS v_ui_doc_x_arc;
DROP VIEW IF EXISTS v_ui_doc_x_connec;
DROP VIEW IF EXISTS v_ui_doc_x_gully;
DROP VIEW IF EXISTS v_ui_doc_x_node;
DROP VIEW IF EXISTS v_ui_doc_x_psector;
DROP VIEW IF EXISTS v_ui_doc_x_visit;
DROP VIEW IF EXISTS v_ui_doc_x_workcat;
DROP VIEW IF EXISTS v_ui_om_visit_x_doc;

DROP VIEW IF EXISTS v_ext_raster_dem;

DROP VIEW IF EXISTS v_plan_arc;
DROP VIEW IF EXISTS v_price_x_catarc;
DROP VIEW IF EXISTS v_plan_aux_arc_pavement;

DROP VIEW IF EXISTS vi_parent_dma;
DROP VIEW IF EXISTS vi_parent_arc;
DROP VIEW IF EXISTS vi_parent_hydrometer;
DROP VIEW IF EXISTS vi_parent_connec;

DROP VIEW IF EXISTS v_edit_field_valve;
DROP VIEW IF EXISTS ve_pol_register;
DROP VIEW IF EXISTS ve_pol_tank;
DROP VIEW IF EXISTS ve_pol_fountain;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pump;
DROP VIEW IF EXISTS v_edit_inp_pump_additional;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pump_additional;
DROP VIEW IF EXISTS v_edit_inp_dscenario_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_dscenario_connec;
DROP VIEW IF EXISTS v_edit_inp_connec;
DROP VIEW IF EXISTS v_edit_inp_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_dscenario_tank;
DROP VIEW IF EXISTS v_edit_inp_tank;
DROP VIEW IF EXISTS v_edit_inp_dscenario_reservoir;
DROP VIEW IF EXISTS v_edit_inp_reservoir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_valve;
DROP VIEW IF EXISTS v_edit_inp_valve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inlet;
DROP VIEW IF EXISTS v_edit_inp_inlet;

DROP VIEW IF EXISTS v_edit_inp_dscenario_demand;
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pipe;
DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_pipe;

DROP VIEW IF EXISTS v_edit_review_audit_node;
DROP VIEW IF EXISTS v_edit_review_audit_arc;
DROP VIEW IF EXISTS v_edit_review_audit_connec;
DROP VIEW IF EXISTS v_edit_review_audit_gully;

DROP VIEW IF EXISTS v_edit_review_node;
DROP VIEW IF EXISTS v_edit_review_arc;
DROP VIEW IF EXISTS v_edit_review_connec;
DROP VIEW IF EXISTS v_edit_review_gully;

DROP VIEW IF EXISTS v_edit_link_connec;
DROP VIEW IF EXISTS v_edit_link_gully;

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);

DROP VIEW IF EXISTS ve_epa_junction;
DROP VIEW IF EXISTS ve_epa_tank;
DROP VIEW IF EXISTS ve_epa_reservoir;
DROP VIEW IF EXISTS ve_epa_connec;
DROP VIEW IF EXISTS ve_epa_inlet;

DROP VIEW IF EXISTS v_rpt_node;
DROP VIEW IF EXISTS v_rpt_node_all;

DROP VIEW IF EXISTS ve_epa_pump;
DROP VIEW IF EXISTS ve_epa_pump_additional;
DROP VIEW IF EXISTS ve_epa_valve;
DROP VIEW IF EXISTS ve_epa_shortpipe;
DROP VIEW IF EXISTS ve_epa_pipe;
DROP VIEW IF EXISTS ve_epa_virtualvalve;
DROP VIEW IF EXISTS ve_epa_virtualpump;

DROP VIEW IF EXISTS v_rpt_arc;
DROP VIEW IF EXISTS v_rpt_arc_all;

DROP VIEW IF EXISTS v_edit_arc;
DROP VIEW IF EXISTS v_edit_node;
DROP VIEW IF EXISTS v_edit_connec;

DROP VIEW IF EXISTS ve_arc CASCADE;
DROP VIEW IF EXISTS vu_arc;

DROP VIEW IF EXISTS ve_node CASCADE;
DROP VIEW IF EXISTS vu_node;

DROP VIEW IF EXISTS ve_connec CASCADE;
DROP VIEW IF EXISTS vu_connec;

DROP VIEW IF EXISTS v_edit_link;

DROP VIEW IF EXISTS v_edit_minsector;
DROP VIEW IF EXISTS v_edit_samplepoint;

DROP VIEW IF EXISTS v_plan_psector_gully;
DROP VIEW IF EXISTS v_ui_element_x_gully;
DROP VIEW IF EXISTS vi_gully2node;
DROP VIEW IF EXISTS ve_pol_gully;
DROP VIEW IF EXISTS v_edit_inp_gully;

DROP VIEW IF EXISTS v_edit_gully;
DROP VIEW IF EXISTS v_edit_element;

DROP VIEW IF EXISTS ve_gully;
DROP VIEW IF EXISTS vu_gully;

DROP view IF EXISTS vu_link;
DROP view IF EXISTS vu_link_connec;
DROP view IF EXISTS vu_link_gully;

DROP VIEW IF EXISTS v_edit_presszone;
DROP VIEW IF EXISTS vu_presszone;

DROP VIEW IF EXISTS v_om_mincut_hydrometer;

DROP VIEW IF EXISTS v_edit_dma;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS v_ui_macrodma;
DROP VIEW IF EXISTS v_edit_macrodma;
DROP VIEW IF EXISTS vu_dma;
DROP VIEW IF EXISTS v_edit_plan_netscenario_presszone;
DROP VIEW IF EXISTS v_edit_plan_psector_x_other;
DROP VIEW IF EXISTS v_edit_dqa;
DROP VIEW IF EXISTS v_ui_dqa;
DROP VIEW IF EXISTS v_edit_macrodqa;
DROP VIEW IF EXISTS v_ui_macrodqa;
DROP VIEW IF EXISTS vu_dqa;

DROP VIEW IF EXISTS v_edit_macrosector;
DROP VIEW IF EXISTS v_ui_macrosector;

DROP VIEW IF EXISTS v_edit_macroexploitation;
DROP VIEW IF EXISTS v_edit_exploitation;

DROP VIEW IF EXISTS v_state_arc;
DROP VIEW IF EXISTS v_state_node;
DROP VIEW IF EXISTS v_state_link;
DROP VIEW IF EXISTS v_state_connec;

DROP VIEW IF EXISTS v_edit_pond;
DROP VIEW IF EXISTS v_edit_pool;
DROP VIEW IF EXISTS v_om_waterbalance_report;

DROP VIEW IF EXISTS v_om_waterbalance;


DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS vu_sector;

DROP VIEW IF EXISTS v_anl_arc;
DROP VIEW IF EXISTS v_anl_arc_point;
DROP VIEW IF EXISTS v_anl_arc_x_node;
DROP VIEW IF EXISTS v_anl_arc_x_node_point;
DROP VIEW IF EXISTS v_anl_node;
DROP VIEW IF EXISTS v_edit_anl_hydrant;
DROP VIEW IF EXISTS v_anl_connec;
DROP VIEW IF EXISTS vi_options;
DROP VIEW IF EXISTS vi_report;
DROP VIEW IF EXISTS vi_times;
DROP VIEW IF EXISTS vi_timeseries;
DROP VIEW IF EXISTS vi_reactions;
DROP VIEW IF EXISTS vi_energy;
DROP VIEW IF EXISTS vi_quality;
DROP VIEW IF EXISTS vi_controls;
DROP VIEW IF EXISTS vi_coordinates;
DROP VIEW IF EXISTS vi_curves;
DROP VIEW IF EXISTS vi_demands;
DROP VIEW IF EXISTS vi_emitters;
DROP VIEW IF EXISTS vi_junctions;
DROP VIEW IF EXISTS vi_labels;
DROP VIEW IF EXISTS vi_mixing;
DROP VIEW IF EXISTS vi_patterns;
DROP VIEW IF EXISTS vi_pipes;
DROP VIEW IF EXISTS vi_pumps;
DROP VIEW IF EXISTS vi_reservoirs;
DROP VIEW IF EXISTS vi_rules;
DROP VIEW IF EXISTS vi_sources;
DROP VIEW IF EXISTS vi_status;
DROP VIEW IF EXISTS vi_tags;
DROP VIEW IF EXISTS vi_tanks;
DROP VIEW IF EXISTS vi_title;
DROP VIEW IF EXISTS vi_valves;
DROP VIEW IF EXISTS vi_vertices;

DROP VIEW IF EXISTS vi_adjustments;
DROP VIEW IF EXISTS vi_aquifers;
DROP VIEW IF EXISTS vi_buildup;
DROP VIEW IF EXISTS vi_evaporation;
DROP VIEW IF EXISTS vi_files;
DROP VIEW IF EXISTS vi_gully;
DROP VIEW IF EXISTS vi_hydrographs;
DROP VIEW IF EXISTS vi_inflows;
DROP VIEW IF EXISTS vi_landuses;
DROP VIEW IF EXISTS vi_lid_controls;
DROP VIEW IF EXISTS vi_map;
-- DROP VIEW IF EXISTS vi_pollutants; -- TODO: refactor gw_fct_rpt2pg_import_rpt
DROP VIEW IF EXISTS vi_polygons;
DROP VIEW IF EXISTS vi_conduits;
DROP VIEW IF EXISTS vi_dividers;
DROP VIEW IF EXISTS vi_losses;
DROP VIEW IF EXISTS vi_orifices;
DROP VIEW IF EXISTS vi_outfalls;
DROP VIEW IF EXISTS vi_outlets;
DROP VIEW IF EXISTS vi_storage;
DROP VIEW IF EXISTS vi_weirs;
DROP VIEW IF EXISTS vi_xsections;
DROP VIEW IF EXISTS vi_quality;
DROP VIEW IF EXISTS vi_raingages;
DROP VIEW IF EXISTS vi_rdii;
DROP VIEW IF EXISTS vi_snowpacks;
DROP VIEW IF EXISTS vi_symbols;
DROP VIEW IF EXISTS vi_temperature;
DROP VIEW IF EXISTS vi_transects;
DROP VIEW IF EXISTS vi_treatment;
DROP VIEW IF EXISTS vi_washoff;
DROP VIEW IF EXISTS vcp_pipes;
DROP VIEW IF EXISTS vcp_demands;

DROP VIEW IF EXISTS v_edit_inp_coverage;
DROP VIEW IF EXISTS vi_dwf;
DROP VIEW IF EXISTS v_edit_inp_dscenario_lid_usage; -- renamed to v_edit_inp_dscenario_lids
DROP VIEW IF EXISTS vi_gwf;
DROP VIEW IF EXISTS vi_infiltration;
DROP VIEW IF EXISTS vi_lid_usage;
DROP VIEW IF EXISTS vi_subareas;
DROP VIEW IF EXISTS vi_subcatchcentroid;
DROP VIEW IF EXISTS vi_subcatchments;
DROP VIEW IF EXISTS v_edit_inp_subc2outlet;
DROP VIEW IF EXISTS vi_loadings;
DROP VIEW IF EXISTS v_edit_inp_subcatchment;
DROP VIEW IF EXISTS v_ui_drainzone;
DROP VIEW IF EXISTS vu_drainzone;

DROP VIEW IF EXISTS v_edit_inp_timeseries;
DROP VIEW IF EXISTS v_edit_inp_timeseries_value;

DROP VIEW IF EXISTS v_ui_hydrometer;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_node;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;
DROP VIEW IF EXISTS v_rtc_hydrometer;

DROP VIEW IF EXISTS v_ui_om_event;
DROP VIEW IF EXISTS v_ui_om_visitman_x_node;
DROP VIEW IF EXISTS v_ui_om_visit_x_node;
DROP VIEW IF EXISTS v_ui_om_visitman_x_arc;
DROP VIEW IF EXISTS v_ui_om_visit_x_arc;
DROP VIEW IF EXISTS v_ui_om_visitman_x_connec;
DROP VIEW IF EXISTS v_ui_om_visit_x_connec;
DROP VIEW IF EXISTS v_ui_om_visitman_x_gully;
DROP VIEW IF EXISTS v_ui_om_visit_x_gully;
DROP VIEW IF EXISTS ve_visit_node_singlevent;
DROP VIEW IF EXISTS ve_visit_arc_singlevent;
DROP VIEW IF EXISTS ve_visit_connec_singlevent;
DROP VIEW IF EXISTS ve_visit_gully_singlevent;
DROP VIEW IF EXISTS v_om_visit;
DROP VIEW IF EXISTS v_ui_event_x_node;
DROP VIEW IF EXISTS v_ui_event_x_arc;
DROP VIEW IF EXISTS v_ui_event_x_connec;
DROP VIEW IF EXISTS v_ui_event_x_gully;

DROP VIEW IF EXISTS v_ui_hydroval_x_connec;
DROP VIEW IF EXISTS v_ui_hydroval;

DROP VIEW IF EXISTS v_price_x_arc;

DROP VIEW IF EXISTS v_edit_plan_psector_x_connec;
DROP VIEW IF EXISTS v_edit_plan_psector_x_gully;

DROP VIEW IF EXISTS v_inp_pjointpattern;

DROP VIEW IF EXISTS v_edit_rtc_hydro_data_x_connec;

DROP VIEW IF EXISTS v_ui_mincut_hydrometer;
DROP VIEW IF EXISTS v_om_mincut_current_hydrometer;

DROP VIEW IF EXISTS v_om_mincut_planned_valve;
DROP VIEW IF EXISTS v_om_mincut_valve;
DROP VIEW IF EXISTS v_om_mincut_arc;
DROP VIEW IF EXISTS v_om_mincut_planned_arc;
DROP VIEW IF EXISTS v_om_mincut_current_arc;
DROP VIEW IF EXISTS v_om_mincut_connec;
DROP VIEW IF EXISTS v_om_mincut_current_connec;
DROP VIEW IF EXISTS v_ui_mincut_connec;
DROP VIEW IF EXISTS v_om_mincut_node;
DROP VIEW IF EXISTS v_om_mincut_current_node;

DROP VIEW IF EXISTS v_polygon;

DROP VIEW IF EXISTS v_rpt_compare_node;
DROP VIEW IF EXISTS v_rpt_arc_hourly;
DROP VIEW IF EXISTS v_rpt_comp_node_hourly;
DROP VIEW IF EXISTS v_rpt_comp_arc_hourly;
DROP VIEW IF EXISTS v_rpt_comp_arc;
DROP VIEW IF EXISTS v_rpt_comp_node;
DROP VIEW IF EXISTS v_rpt_node_hourly;

DROP VIEW IF EXISTS v_expl_connec;

DROP VIEW IF EXISTS ve_epa_netgully;
DROP VIEW IF EXISTS ve_epa_outfall;
DROP VIEW IF EXISTS ve_epa_conduit;
DROP VIEW IF EXISTS ve_epa_outlet;
DROP VIEW IF EXISTS ve_epa_weir;
DROP VIEW IF EXISTS ve_epa_gully;
DROP VIEW IF EXISTS ve_epa_virtual;
DROP VIEW IF EXISTS ve_epa_storage;

DROP VIEW IF EXISTS v_sector_node;

DROP VIEW IF EXISTS v_state_gully;
DROP VIEW IF EXISTS v_state_link_connec;
DROP VIEW IF EXISTS v_state_link_gully;

DROP VIEW IF EXISTS v_rpt_arc_compare_all;
DROP VIEW IF EXISTS v_rpt_arc_compare_timestep;
DROP VIEW IF EXISTS v_rpt_arc_timestep;
DROP VIEW IF EXISTS v_rpt_comp_arcflow_sum;
DROP VIEW IF EXISTS v_rpt_arcflow_sum;
DROP VIEW IF EXISTS v_rpt_arcpolload_sum;
DROP VIEW IF EXISTS v_rpt_comp_condsurcharge_sum;
DROP VIEW IF EXISTS v_rpt_condsurcharge_sum;
DROP VIEW IF EXISTS v_rpt_comp_flowclass_sum;
DROP VIEW IF EXISTS v_rpt_flowclass_sum;
DROP VIEW IF EXISTS v_rpt_comp_pumping_sum;
DROP VIEW IF EXISTS v_rpt_pumping_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodedepth_sum;
DROP VIEW IF EXISTS v_rpt_nodedepth_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodeflooding_sum;
DROP VIEW IF EXISTS v_rpt_nodeflooding_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodeinflow_sum;
DROP VIEW IF EXISTS v_rpt_nodeinflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodesurcharge_sum;
DROP VIEW IF EXISTS v_rpt_nodesurcharge_sum;
DROP VIEW IF EXISTS v_rpt_comp_outfallflow_sum;
DROP VIEW IF EXISTS v_rpt_outfallflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_outfallload_sum;
DROP VIEW IF EXISTS v_rpt_outfallload_sum;
DROP VIEW IF EXISTS v_rpt_node_compare_timestep;
DROP VIEW IF EXISTS v_rpt_node_timestep;
DROP VIEW IF EXISTS v_rpt_storagevol_sum;
DROP VIEW IF EXISTS v_rpt_node_compare_all;
DROP VIEW IF EXISTS v_rpt_comp_storagevol_sum;

DROP VIEW IF EXISTS v_edit_dimensions;

DROP VIEW IF EXISTS v_expl_gully;
DROP VIEW IF EXISTS v_man_gully;

DROP VIEW IF EXISTS ve_epa_virtual;
DROP VIEW IF EXISTS v_edit_inp_virtual;

DROP VIEW IF EXISTS v_edit_cat_feature_connec;

-- 30/10/2024

CREATE OR REPLACE VIEW vcv_times AS
 SELECT rpt.result_id,
    rpt.inp_options ->> 'inp_times_duration'::text AS duration
   FROM selector_inp_result r, rpt_cat_result rpt
   WHERE r.result_id = rpt.result_id AND r.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW vcv_dma AS
 SELECT ext_rtc_dma_period.id,
    ext_rtc_dma_period.dma_id,
    ext_rtc_dma_period.cat_period_id AS period_id,
    ext_rtc_dma_period.effc,
    ext_rtc_dma_period.pattern_id
   FROM ext_rtc_dma_period;


-- 12/11/2024
CREATE OR REPLACE VIEW ve_config_addfields
AS SELECT sys_addfields.param_name AS columnname,
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
            WHEN sys_addfields.cat_feature_id IS NOT NULL THEN config_form_fields.formname
            ELSE NULL::character varying
        END AS formname,
    sys_addfields.id AS param_id,
    sys_addfields.cat_feature_id
   FROM sys_addfields
     LEFT JOIN cat_feature ON cat_feature.id::text = sys_addfields.cat_feature_id::text
     LEFT JOIN config_form_fields ON config_form_fields.columnname::text = sys_addfields.param_name::text;


CREATE OR REPLACE VIEW ve_config_sysfields
AS SELECT row_number() OVER () AS rid,
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
    config_form_fields.stylesheet::text AS stylesheet,
    config_form_fields.isparent,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    config_form_fields.widgetcontrols::text AS widgetcontrols,
    config_form_fields.widgetfunction,
    config_form_fields.linkedobject,
    cat_feature.id AS cat_feature_id
   FROM config_form_fields
     LEFT JOIN cat_feature ON cat_feature.child_layer::text = config_form_fields.formname::text
  WHERE config_form_fields.formtype::text = 'form_feature'::text AND config_form_fields.formname::text <> 've_arc'::text AND config_form_fields.formname::text <> 've_node'::text AND config_form_fields.formname::text <> 've_connec'::text AND config_form_fields.formname::text <> 've_gully'::text;

-- 21/11/2024
DROP VIEW IF EXISTS v_minsector_graph;

-- 04/12/2024
CREATE OR REPLACE VIEW v_ui_doc
AS SELECT doc.id,
    doc.name,
    doc.observ,
    doc.doc_type,
    doc.path,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;

-- 05/12/2024
CREATE OR REPLACE VIEW v_edit_plan_psector
AS SELECT plan_psector.psector_id,
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
    plan_psector.archived,
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
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_plan_psector
AS SELECT plan_psector.psector_id,
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
    plan_psector.archived,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    plan_psector
     JOIN exploitation USING (expl_id)
     LEFT JOIN plan_typevalue p ON p.id::text = plan_psector.priority::text AND p.typevalue = 'value_priority'::text
     LEFT JOIN plan_typevalue s ON s.id::text = plan_psector.status::text AND s.typevalue = 'psector_status'::text
     LEFT JOIN plan_typevalue t ON t.id::integer = plan_psector.psector_type AND t.typevalue = 'psector_type'::text
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

-- 10/02/2025
CREATE OR REPLACE VIEW v_ui_workspace
AS SELECT cat_workspace.id,
    cat_workspace.name,
    cat_workspace.private,
    cat_workspace.descript,
    cat_workspace.config,
    cat_workspace.insert_user,
    cat_workspace.insert_timestamp,
    cat_workspace.lastupdate_user,
    cat_workspace.lastupdate_timestamp
   FROM cat_workspace
  WHERE
  cat_workspace.private IS FALSE
  OR cat_workspace.private IS TRUE
  AND (cat_workspace.insert_user = CURRENT_USER::text OR cat_workspace.lastupdate_user = CURRENT_USER::text);


--25/03/2025
CREATE OR REPLACE VIEW v_ui_doc_x_link
AS SELECT doc_x_link.doc_id,
    doc_x_link.link_id,
    doc.name as doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
  FROM doc_x_link
     JOIN doc ON doc.id::text = doc_x_link.doc_id::text;
