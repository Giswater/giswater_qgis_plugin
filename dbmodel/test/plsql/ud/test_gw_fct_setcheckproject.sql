/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 1 test
SELECT plan(1);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setcheckproject($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "version":"3.6.012", "fid":101, "initProject":false, "addSchema":"NULL",
    "mainSchema":"NULL", "projecRole":"role_admin", "infoType":"full", "logFolderVolume":"7.52 MB", "projectType":"ud",
    "qgisVersion":"3.34.9-Prizren", "osVersion":"Windows 11", "fields":[ {"table_schema":"ud_36", "table_id":"v_edit_exploitation",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36",
    "table_id":"v_edit_drainzone", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"},
    {"table_schema":"ud_36", "table_id":"v_edit_sector", "table_dbname":"giswater", "table_host":"localhost", "fid":101,
    "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_node", "table_dbname":"giswater", "table_host":"localhost",
    "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_connec", "table_dbname":"giswater",
    "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_gully",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36",
    "table_id":"v_edit_arc", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"},
    {"table_schema":"ud_36", "table_id":"v_edit_link", "table_dbname":"giswater", "table_host":"localhost", "fid":101,
    "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"ve_pol_node", "table_dbname":"giswater",
    "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"ve_pol_gully",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36",
    "table_id":"ve_pol_connec", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"},
    {"table_schema":"ud_36", "table_id":"v_edit_dimensions", "table_dbname":"giswater", "table_host":"localhost", "fid":101,
    "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_element", "table_dbname":"giswater", "table_host":"localhost",
    "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_raingage", "table_dbname":"giswater",
    "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_subcatchment",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36",
    "table_id":"v_edit_inp_subc2outlet", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"},
    {"table_schema":"ud_36", "table_id":"v_edit_inp_junction", "table_dbname":"giswater", "table_host":"localhost", "fid":101,
    "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_outfall", "table_dbname":"giswater", "table_host":"localhost",
    "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_divider", "table_dbname":"giswater",
    "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_storage",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36",
    "table_id":"v_edit_inp_netgully", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"},
    {"table_schema":"ud_36", "table_id":"v_edit_inp_conduit", "table_dbname":"giswater", "table_host":"localhost", "fid":101,
    "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_virtual", "table_dbname":"giswater", "table_host":"localhost",
    "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_pump", "table_dbname":"giswater",
    "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_weir",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36",
    "table_id":"v_edit_inp_outlet", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"},
    {"table_schema":"ud_36", "table_id":"v_edit_inp_orifice", "table_dbname":"giswater", "table_host":"localhost", "fid":101,
    "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_gully", "table_dbname":"giswater", "table_host":"localhost",
    "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"vi_gully2node", "table_dbname":"giswater",
    "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_flwreg_orifice",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36",
    "table_id":"v_edit_inp_flwreg_outlet", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"},
    {"table_schema":"ud_36", "table_id":"v_edit_inp_flwreg_pump", "table_dbname":"giswater", "table_host":"localhost", "fid":101,
    "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_inp_flwreg_weir", "table_dbname":"giswater",
    "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_nodeflooding_sum",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36",
    "table_id":"v_rpt_nodesurcharge_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"},
    {"table_schema":"ud_36", "table_id":"v_rpt_nodeinflow_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101,
    "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_nodedepth_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_arcflow_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_condsurcharge_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_pumping_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_flowclass_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_arcpolload_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_outfallflow_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_outfallload_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_storagevol_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_subcatchrunoff_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_subcatchwasoff_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_rpt_lidperfomance_sum", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_edit_plan_psector", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_plan_current_psector", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_plan_psector_connec", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_plan_psector_link", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_plan_psector_node", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_plan_psector_arc", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"ext_municipality", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_ext_address", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_ext_streetaxis", "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}, {"table_schema":"ud_36", "table_id":"v_ext_plot",
    "table_dbname":"giswater", "table_host":"localhost", "fid":101, "table_user":"postgres"}]}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setprint returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;