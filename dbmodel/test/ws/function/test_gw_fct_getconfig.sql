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

-- Plan for 2 test
SELECT plan(2);

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
SELECT is (
    (gw_fct_getconfig($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"epaoptions"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getconfig --> "formName":"epaoptions" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getconfig($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"config"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "list_layers_name":"{Mincut init point, Mincut result valve, Mincut result node, Mincut result connec, Mincut result arc, Node, Connec, Arc, Link, Connec polygon, Node polygon, Dimensioning, Inp reservoir, Inp tank, Inp inlet, Inp junction, Inp shortpipe, Inp valve, Inp pump, Inp connec, Inp pipe, Inp virtualvalve, Inp virtualpump, Plan psector connec, Plan psector node, Plan psector arc, Plan psector link, Municipality, Streetaxis, Plot}", "list_tables_name":"{v_om_mincut_initpoint, v_om_mincut_valve, v_om_mincut_node, v_om_mincut_connec, v_om_mincut_arc, ve_node, ve_connec, ve_arc, ve_link, ve_pol_connec, ve_pol_node, ve_dimensions, ve_inp_reservoir, ve_inp_tank, ve_inp_inlet, ve_inp_junction, ve_inp_shortpipe, ve_inp_valve, ve_inp_pump, ve_inp_connec, ve_inp_pipe, ve_inp_virtualvalve, ve_inp_virtualpump, v_plan_psector_connec, v_plan_psector_node, v_plan_psector_arc, v_plan_psector_link, ext_municipality, v_ext_streetaxis, v_ext_plot}"}}$$)::JSON)->>'status','Accepted',
    'Check if gw_fct_getconfig --> "formName":"config" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;