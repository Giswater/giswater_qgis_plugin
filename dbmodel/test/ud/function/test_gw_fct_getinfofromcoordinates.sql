/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 5 test
SELECT plan(5);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{},
    "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_edit_link", "visibleLayers":["v_edit_node", "v_edit_connec", "v_edit_gully", "v_edit_arc", "v_edit_link",
    "ve_pol_node", "ve_pol_gully", "ve_pol_connec", "v_edit_dimensions", "v_edit_element", "v_edit_inp_junction", "v_edit_inp_outfall", "v_edit_inp_divider",
    "v_edit_inp_storage", "v_edit_inp_netgully", "v_edit_inp_conduit", "v_edit_inp_virtual", "v_edit_inp_pump", "v_edit_inp_weir", "v_edit_inp_outlet",
    "v_edit_inp_orifice", "v_edit_inp_gully", "vi_gully2node", "v_edit_inp_frorifice", "v_edit_inp_froutlet", "v_edit_inp_frpump",
    "v_edit_inp_frweir", "v_edit_plan_psector", "v_plan_current_psector", "v_plan_psector_connec", "v_plan_psector_gully", "v_plan_psector_link",
    "v_plan_psector_node", "v_plan_psector_arc", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL",
    "projecRole":"role_admin", "coordinates":{"xcoord":419036.65214144497,"ycoord":4576777.421458042, "zoomRatio":455.32120419290476}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{},
    "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_edit_link", "visibleLayers":["v_edit_node", "v_edit_connec", "v_edit_gully", "v_edit_arc", "v_edit_link",
    "ve_pol_node", "ve_pol_gully", "ve_pol_connec", "v_edit_dimensions", "v_edit_element", "v_edit_inp_junction", "v_edit_inp_outfall", "v_edit_inp_divider",
    "v_edit_inp_storage", "v_edit_inp_netgully", "v_edit_inp_conduit", "v_edit_inp_virtual", "v_edit_inp_pump", "v_edit_inp_weir", "v_edit_inp_outlet",
    "v_edit_inp_orifice", "v_edit_inp_gully", "vi_gully2node", "v_edit_inp_frorifice", "v_edit_inp_froutlet", "v_edit_inp_frpump",
    "v_edit_inp_frweir", "v_edit_plan_psector", "v_plan_current_psector", "v_plan_psector_connec", "v_plan_psector_gully", "v_plan_psector_link",
    "v_plan_psector_node", "v_plan_psector_arc", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL",
    "projecRole":"role_admin", "coordinates":{"xcoord":419008.7030081943,"ycoord":4576783.926859748, "zoomRatio":455.32120419290476}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{},
    "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_edit_link", "visibleLayers":["v_edit_node", "v_edit_connec", "v_edit_gully", "v_edit_arc", "v_edit_link",
    "ve_pol_node", "ve_pol_gully", "ve_pol_connec", "v_edit_dimensions", "v_edit_element", "v_edit_inp_junction", "v_edit_inp_outfall", "v_edit_inp_divider",
    "v_edit_inp_storage", "v_edit_inp_netgully", "v_edit_inp_conduit", "v_edit_inp_virtual", "v_edit_inp_pump", "v_edit_inp_weir", "v_edit_inp_outlet",
    "v_edit_inp_orifice", "v_edit_inp_gully", "vi_gully2node", "v_edit_inp_frorifice", "v_edit_inp_froutlet", "v_edit_inp_frpump",
    "v_edit_inp_frweir", "v_edit_plan_psector", "v_plan_current_psector", "v_plan_psector_connec", "v_plan_psector_gully", "v_plan_psector_link",
    "v_plan_psector_node", "v_plan_psector_arc", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL",
    "projecRole":"role_admin", "coordinates":{"xcoord":419002.19760648935,"ycoord":4576765.615358652, "zoomRatio":455.32120419290476}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{},
    "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_edit_link", "visibleLayers":["v_edit_node", "v_edit_connec", "v_edit_gully", "v_edit_arc", "v_edit_link",
    "ve_pol_node", "ve_pol_gully", "ve_pol_connec", "v_edit_dimensions", "v_edit_element", "v_edit_inp_junction", "v_edit_inp_outfall", "v_edit_inp_divider",
    "v_edit_inp_storage", "v_edit_inp_netgully", "v_edit_inp_conduit", "v_edit_inp_virtual", "v_edit_inp_pump", "v_edit_inp_weir", "v_edit_inp_outlet",
    "v_edit_inp_orifice", "v_edit_inp_gully", "vi_gully2node", "v_edit_inp_frorifice", "v_edit_inp_froutlet", "v_edit_inp_frpump",
    "v_edit_inp_frweir", "v_edit_plan_psector", "v_plan_current_psector", "v_plan_psector_connec", "v_plan_psector_gully", "v_plan_psector_link",
    "v_plan_psector_node", "v_plan_psector_arc", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL",
    "projecRole":"role_admin", "coordinates":{"xcoord":419004.36607372435,"ycoord":4576774.409697994, "zoomRatio":455.32120419290476}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{},
    "pageInfo":{}, "toolBar":"basic", "activeLayer":"v_edit_link", "visibleLayers":["v_edit_node", "v_edit_connec", "v_edit_gully", "v_edit_arc", "v_edit_link",
    "ve_pol_node", "ve_pol_gully", "ve_pol_connec", "v_edit_dimensions", "v_edit_element", "v_edit_inp_junction", "v_edit_inp_outfall", "v_edit_inp_divider",
    "v_edit_inp_storage", "v_edit_inp_netgully", "v_edit_inp_conduit", "v_edit_inp_virtual", "v_edit_inp_pump", "v_edit_inp_weir", "v_edit_inp_outlet",
    "v_edit_inp_orifice", "v_edit_inp_gully", "vi_gully2node", "v_edit_inp_frorifice", "v_edit_inp_froutlet", "v_edit_inp_frpump",
    "v_edit_inp_frweir", "v_edit_plan_psector", "v_plan_current_psector", "v_plan_psector_connec", "v_plan_psector_gully", "v_plan_psector_link",
    "v_plan_psector_node", "v_plan_psector_arc", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "mainSchema":"NULL", "addSchema":"NULL",
    "projecRole":"role_admin", "coordinates":{"xcoord":419004.36607372435,"ycoord":4576774.409697994, "zoomRatio":455.32120419290476}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromcoordinates returns status "Accepted"'
);
-- Finish the test
SELECT finish();

ROLLBACK;
