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
    "ycoord":4576704.824530694}, "visibleLayers":["ve_node", "ve_connec", "ve_gully", "ve_arc",
    "ve_link", "ve_pol_node", "ve_pol_gully", "ve_pol_connec", "ve_dimensions", "ve_element", "ve_inp_junction",
    "ve_inp_outfall", "ve_inp_divider", "ve_inp_storage", "ve_inp_netgully", "ve_inp_conduit",
    "ve_inp_virtual", "ve_inp_pump", "ve_inp_weir", "ve_inp_outlet", "ve_inp_orifice", "ve_inp_gully",
    "vi_gully2node", "ve_inp_frorifice", "ve_inp_froutlet", "ve_inp_frpump", "ve_inp_frweir",
    "ve_plan_psector", "v_plan_current_psector", "v_plan_psector_connec", "v_plan_psector_gully", "v_plan_psector_link",
    "v_plan_psector_node", "v_plan_psector_arc", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "zoomScale":2564.170513209851 }}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlayersfromcoordinates returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
