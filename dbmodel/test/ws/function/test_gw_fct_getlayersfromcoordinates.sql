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
    (gw_fct_getlayersfromcoordinates($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "pointClickCoords":{"xcoord":418999.0449511094, "ycoord":4576781.3148895465},
    "visibleLayers":["v_om_mincut_initpoint", "v_om_mincut_valve", "v_om_mincut_node", "v_om_mincut_connec", "v_om_mincut_arc",
    "ve_node", "ve_connec", "ve_arc", "ve_link", "ve_pol_connec", "ve_pol_node", "ve_dimensions",
    "ve_inp_reservoir", "ve_inp_tank", "ve_inp_inlet", "ve_inp_junction", "ve_inp_shortpipe", "ve_inp_valve",
    "ve_inp_pump", "ve_inp_connec", "ve_inp_pipe", "ve_inp_virtualvalve", "ve_inp_virtualpump", "v_rpt_node",
    "v_rpt_node", "v_rpt_arc", "v_plan_psector_connec", "v_plan_psector_node", "v_plan_psector_arc", "v_plan_psector_link",
    "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "zoomScale":1340.2752149622331 }}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlayersfromcoordinates returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
