/*
This file is part of Giswater
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
SELECT is(
    (gw_fct_getlayersfromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "pointClickCoords":{"xcoord":418999.0449511094, "ycoord":4576781.3148895465},
    "visibleLayers":["v_om_mincut_initpoint", "v_om_mincut_valve", "v_om_mincut_node", "v_om_mincut_connec", "v_om_mincut_arc",
    "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_link", "ve_pol_connec", "ve_pol_node", "v_edit_dimensions",
    "v_edit_inp_reservoir", "v_edit_inp_tank", "v_edit_inp_inlet", "v_edit_inp_junction", "v_edit_inp_shortpipe", "v_edit_inp_valve",
    "v_edit_inp_pump", "v_edit_inp_connec", "v_edit_inp_pipe", "v_edit_inp_virtualvalve", "v_edit_inp_virtualpump", "v_rpt_node",
    "v_rpt_node", "v_rpt_arc", "v_plan_psector_connec", "v_plan_psector_node", "v_plan_psector_arc", "v_plan_psector_link",
    "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "zoomScale":1340.2752149622331 }}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlayersfromcoordinates returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
