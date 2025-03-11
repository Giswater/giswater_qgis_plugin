/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 4 test
SELECT plan(4);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_om_mincut_initpoint", "visibleLayers":["v_om_mincut_initpoint",
    "v_om_mincut_valve", "v_om_mincut_node", "v_om_mincut_connec", "v_om_mincut_arc", "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_link",
    "ve_pol_connec", "ve_pol_node", "v_edit_dimensions", "v_edit_inp_reservoir", "v_edit_inp_tank", "v_edit_inp_inlet", "v_edit_inp_junction",
    "v_edit_inp_shortpipe", "v_edit_inp_valve", "v_edit_inp_pump", "v_edit_inp_connec", "v_edit_inp_pipe", "v_edit_inp_virtualvalve",
    "v_edit_inp_virtualpump", "v_rpt_node", "v_rpt_node", "v_rpt_arc", "v_plan_psector_connec", "v_plan_psector_node", "v_plan_psector_arc",
    "v_plan_psector_link", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL",
    "projecRole":"role_admin", "coordinates":{"xcoord":419024.41071384674,"ycoord":4576386.2594633605, "zoomRatio":753.3624190341469}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_om_mincut_initpoint",
    "visibleLayers":["v_om_mincut_initpoint", "v_om_mincut_valve", "v_om_mincut_node", "v_om_mincut_connec", "v_om_mincut_arc",
    "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_link", "ve_pol_connec", "ve_pol_node", "v_edit_dimensions",
    "v_edit_inp_reservoir", "v_edit_inp_tank", "v_edit_inp_inlet", "v_edit_inp_junction", "v_edit_inp_shortpipe", "v_edit_inp_valve",
    "v_edit_inp_pump", "v_edit_inp_connec", "v_edit_inp_pipe", "v_edit_inp_virtualvalve", "v_edit_inp_virtualpump", "v_rpt_node",
    "v_rpt_node", "v_rpt_arc", "v_plan_psector_connec", "v_plan_psector_node", "v_plan_psector_arc", "v_plan_psector_link",
    "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL", "projecRole":"role_admin",
    "coordinates":{"xcoord":419111.6495588101,"ycoord":4576807.83636452, "zoomRatio":251.120806333698}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_om_mincut_initpoint",
    "visibleLayers":["v_om_mincut_initpoint", "v_om_mincut_valve", "v_om_mincut_node", "v_om_mincut_connec", "v_om_mincut_arc",
    "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_link", "ve_pol_connec", "ve_pol_node", "v_edit_dimensions",
    "v_edit_inp_reservoir", "v_edit_inp_tank", "v_edit_inp_inlet", "v_edit_inp_junction", "v_edit_inp_shortpipe", "v_edit_inp_valve",
    "v_edit_inp_pump", "v_edit_inp_connec", "v_edit_inp_pipe", "v_edit_inp_virtualvalve", "v_edit_inp_virtualpump", "v_rpt_node",
    "v_rpt_node", "v_rpt_arc", "v_plan_psector_connec", "v_plan_psector_node", "v_plan_psector_arc", "v_plan_psector_link",
    "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL", "projecRole":"role_admin",
    "coordinates":{"xcoord":419101.6832018088,"ycoord":4576803.185397919, "zoomRatio":251.120806333698}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_om_mincut_initpoint",
    "visibleLayers":["v_om_mincut_initpoint", "v_om_mincut_valve", "v_om_mincut_node", "v_om_mincut_connec", "v_om_mincut_arc",
    "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_link", "ve_pol_connec", "ve_pol_node", "v_edit_dimensions",
    "v_edit_inp_reservoir", "v_edit_inp_tank", "v_edit_inp_inlet", "v_edit_inp_junction", "v_edit_inp_shortpipe", "v_edit_inp_valve",
    "v_edit_inp_pump", "v_edit_inp_connec", "v_edit_inp_pipe", "v_edit_inp_virtualvalve", "v_edit_inp_virtualpump", "v_rpt_node",
    "v_rpt_node", "v_rpt_arc", "v_plan_psector_connec", "v_plan_psector_node", "v_plan_psector_arc", "v_plan_psector_link",
    "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL", "projecRole":"role_admin",
    "coordinates":{"xcoord":419104.2080122491,"ycoord":4576806.97261358, "zoomRatio":251.120806333698}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);
-- Finish the test
SELECT finish();

ROLLBACK;
