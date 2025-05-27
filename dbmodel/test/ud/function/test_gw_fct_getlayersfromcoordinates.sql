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

-- Plan for 1 test
SELECT plan(1);

-- Create roles for testing
CREATE USER plan_user;
GRANT role_plan to plan_user;

CREATE USER epa_user;
GRANT role_epa to epa_user;

CREATE USER edit_user;
GRANT role_edit to edit_user;

CREATE USER om_user;
GRANT role_om to om_user;

CREATE USER basic_user;
GRANT role_basic to basic_user;

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_getlayersfromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "pointClickCoords":{"xcoord":419229.18672544777,
    "ycoord":4576704.824530694}, "visibleLayers":["v_edit_node", "v_edit_connec", "v_edit_gully", "v_edit_arc",
    "v_edit_link", "ve_pol_node", "ve_pol_gully", "ve_pol_connec", "v_edit_dimensions", "v_edit_element", "v_edit_inp_junction",
    "v_edit_inp_outfall", "v_edit_inp_divider", "v_edit_inp_storage", "v_edit_inp_netgully", "v_edit_inp_conduit",
    "v_edit_inp_virtual", "v_edit_inp_pump", "v_edit_inp_weir", "v_edit_inp_outlet", "v_edit_inp_orifice", "v_edit_inp_gully",
    "vi_gully2node", "v_edit_inp_frorifice", "v_edit_inp_froutlet", "v_edit_inp_frpump", "v_edit_inp_frweir",
    "v_edit_plan_psector", "v_plan_current_psector", "v_plan_psector_connec", "v_plan_psector_gully", "v_plan_psector_link",
    "v_plan_psector_node", "v_plan_psector_arc", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "zoomScale":2564.170513209851 }}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlayersfromcoordinates returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
