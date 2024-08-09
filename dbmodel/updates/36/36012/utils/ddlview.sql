/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW if EXISTS v_ui_doc;
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

--29/07/2024
DROP VIEW if EXISTS v_ui_doc_x_workcat;
CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;

CREATE OR REPLACE VIEW v_ext_municipality AS
SELECT DISTINCT s.muni_id,
    m.name,
    m.active,
    m.the_geom
   FROM v_ext_streetaxis s
     JOIN ext_municipality m USING (muni_id);


-- drop depedency views from arc
-----------------------------------
DROP VIEW IF EXISTS v_plan_psector_budget_detail;
DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_psector_budget;
DROP VIEW IF EXISTS v_plan_psector_all;
DROP VIEW IF EXISTS v_plan_current_psector;
DROP VIEW IF EXISTS v_plan_psector_arc;
DROP VIEW IF EXISTS v_plan_psector_connec;
DROP VIEW IF EXISTS v_plan_psector_node;
DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_plan_result_arc;
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

DROP VIEW IF EXISTS v_ui_arc_x_relations;
DROP VIEW IF EXISTS v_ui_arc_x_node;
DROP VIEW IF EXISTS v_ui_node_x_relations;

DROP VIEW IF EXISTS v_ui_element;
DROP VIEW IF EXISTS v_ui_element_x_arc;
DROP VIEW IF EXISTS v_ui_element_x_connec;
DROP VIEW IF EXISTS v_ui_element_x_node;
DROP VIEW IF EXISTS ve_pol_element;

DROP VIEW IF EXISTS v_ext_raster_dem;

DROP VIEW IF EXISTS v_plan_arc;
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

DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pipe;
DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_pipe;

DROP VIEW IF EXISTS v_edit_arc;
DROP VIEW IF EXISTS v_edit_node;
DROP VIEW IF EXISTS v_edit_connec;

DROP VIEW IF EXISTS ve_arc;
DROP VIEW IF EXISTS v_arc; -- permanently delete
DROP VIEW IF EXISTS vu_arc;

DROP VIEW IF EXISTS ve_node;
DROP VIEW IF EXISTS v_node; -- permanently delete
DROP VIEW IF EXISTS vu_node;

DROP VIEW IF EXISTS ve_connec;
DROP VIEW IF EXISTS v_connec; -- permanently delete
DROP VIEW IF EXISTS vu_connec;

DROP VIEW IF EXISTS v_om_mincut_hydrometer;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"node", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_arc", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_node", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_arc_traceability", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_psector_arc_traceability", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_psector_node_traceability", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_psector_connec_traceability", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"config_visit_parameter", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_cat_hydrometer_priority", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_cat_hydrometer_type", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_cat_raster", "column":"code", "dataType":"text"}}$$);
