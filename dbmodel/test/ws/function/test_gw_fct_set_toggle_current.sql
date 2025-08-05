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

SELECT plan(16);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_set_toggle_current('{"data":{"type": "psector", "id": "1"}}')::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_set_toggle_current psector with id value returns status "Accepted"'
);

SELECT is (
    (gw_fct_set_toggle_current('{"data":{"type": "psector"}}')::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_set_toggle_current psector returns status "Accepted"'
);

INSERT INTO plan_netscenario (netscenario_id, "name", descript, parent_id, netscenario_type, active, expl_id, log)
VALUES(5, 'test_netscenario', NULL, NULL, 'DMA', true, 0, 'Created in testing');

SELECT is (
    (gw_fct_set_toggle_current('{"data":{"type": "netscenario", "id": "5"}}')::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_set_toggle_current netscenario with id value returns status "Accepted"'
);

SELECT is (
    (gw_fct_set_toggle_current('{"data":{"type": "netscenario"}}')::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_set_toggle_current netscenario returns status "Accepted"'
);

-- prepare test
INSERT INTO cat_workspace (id, "name", descript, config, private, active, iseditable, insert_user, insert_timestamp, lastupdate_user, lastupdate_timestamp) VALUES(1, 'test', NULL, '{"inp":{"inp_report_file": null, "inp_report_flow": "YES", "inp_report_head": "YES", "inp_report_links": "ALL", "inp_report_nodes": "ALL", "inp_options_units": "LPS", "inp_report_demand": "YES", "inp_report_energy": "YES", "inp_report_length": "YES", "inp_report_status": "YES", "inp_options_trials": "40", "inp_report_quality": "YES", "inp_report_setting": "YES", "inp_report_summary": "YES", "inp_times_duration": "24", "inp_options_node_id": null, "inp_options_pattern": null, "inp_report_diameter": "YES", "inp_report_f_factor": "NO", "inp_report_pagesize": null, "inp_report_pressure": "YES", "inp_report_reaction": "YES", "inp_report_velocity": "YES", "inp_times_statistic": "NONE", "inp_options_accuracy": "0.001", "inp_options_headloss": "D-W", "inp_options_maxcheck": "10.00", "inp_report_elevation": "YES", "inp_options_checkfreq": "2.00", "inp_options_damplimit": "0.00", "inp_options_tolerance": "0.01", "inp_options_viscosity": "1.00", "inp_options_demandtype": "1", "inp_options_hydraulics": "NONE", "inp_options_unbalanced": "CONTINUE", "inp_times_report_start": null, "inp_options_diffusivity": "1", "inp_options_interval_to": null, "inp_options_networkmode": "2", "inp_times_pattern_start": null, "inp_times_rule_timestep": null, "inp_options_buildup_mode": "2", "inp_options_demand_model": "PDA", "inp_options_quality_mode": "NONE", "inp_options_unbalanced_n": "40", "inp_options_interval_from": null, "inp_options_max_headerror": "0", "inp_options_nodarc_length": "0.3", "inp_options_patternmethod": "11", "inp_options_rtc_period_id": null, "inp_times_report_timestep": null, "inp_times_start_clocktime": null, "inp_options_max_flowchange": "0", "inp_times_pattern_timestep": null, "inp_times_quality_timestep": null, "inp_options_emitter_exponent": "0.5", "inp_options_hydraulics_fname": null, "inp_options_minimum_pressure": "0", "inp_options_specific_gravity": "1.00", "inp_times_hydraulic_timestep": "0:30", "inp_options_buildup_transport": null, "inp_options_demand_multiplier": "1.00", "inp_options_pressure_exponent": "0.5", "inp_options_required_pressure": "10", "inp_options_dscenario_priority": "1"},"inp_json":{ "inp_options_buildup_supply" : {"reservoir":{"switch2Junction":["ETAP", "POU", "CAPTACIO"]},
"tank":{"distVirtualReservoir":0.01},
"pressGroup":{"status":"ACTIVE", "forceStatus":"ACTIVE", "defaultCurve":"GP30"},
"pumpStation":{"status":"CLOSED", "forceStatus":"CLOSED", "defaultCurve":"IM00"},
"PRV":{"status":"ACTIVE", "forceStatus":"ACTIVE", "pressure":"30"},
"PSV":{"status":"ACTIVE", "forceStatus":"ACTIVE", "pressure":"30"}
}, "inp_options_advancedsettings" : {"status":false, "parameters":{"junction":{"baseDemand":0},  "reservoir":{"addElevation":1},  "tank":{"addElevation":1}, "valve":{"length":"0.3", "diameter":"100", "minorloss":0.2, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}},"pump":{"length":0.3, "diameter":100, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}}}}, "inp_options_vdefault" : {"status":false, "parameters":{"node":{"nullElevBuffer":100, "ceroElevBuffer":100}, "pipe":{"diameter":"160","roughness":"avg"}}}, "inp_options_debug" : {"forceReservoirsOnInlets":false, "forceTanksOnInlets":false, "setDemand":true,"checkResult":true,"onlyIsOperative":true,"delDisconnNetwork":false,"delDryNetwork":false, "removeDemandOnDryNodes":true,"breakPipes":{"status":false, "maxLength":10, "removeVnodeBuffer":1},"graphicLog":"true","steps":0,"autoRepair":true} },"selectors":[{"selector_inp_dscenario": [1]}, {"selector_sector": [1, 2, 3, 4, 5, 0]}, {"selector_state": [1]}, {"selector_rpt_compare": null}, {"selector_rpt_main": null}, {"selector_municipality": [0, 1, 2]}, {"selector_expl": [1, 2, 0]}, {"selector_hydrometer": [1]}, {"selector_psector": [1, 2]}, {"selector_rpt_compare_tstep": null}, {"selector_rpt_main_tstep": null}, {"selector_date": null}]}'::json, false, true, true, 'postgres', now(), 'postgres', now());

SELECT is (
    (gw_fct_set_toggle_current('{"data":{"type": "workspace", "id": "1"}}')::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_set_toggle_current workspace with id value returns status "Accepted"'
);

SELECT is (
    (gw_fct_set_toggle_current('{"data":{"type": "workspace"}}')::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_set_toggle_current workspace returns status "Accepted"'
);

-- test error messages
SELECT throws_ok(
    $$
        SELECT gw_fct_set_toggle_current('{"data":{"type": "psector_wrong"}}')::JSON;
    $$,
    'GW002',
    'Function: [gw_fct_set_toggle_current] - UNKNOWN TYPE. HINT: YOU NEED TO PASS CORRECT PARAMETERS. - <NULL>',
    'Check if gw_fct_set_toggle_current with wrong type throws expected error'
);

SELECT throws_ok(
    $$
        SELECT gw_fct_set_toggle_current('{"data":{}}')::JSON;
    $$,
    'GW002',
    'Function: [gw_fct_set_toggle_current] - INPUT PARAMETER: "TYPE" IS REQUIRED. HINT: YOU NEED TO PASS CORRECT PARAMETERS. - <NULL>',
    'Check if gw_fct_set_toggle_current without type throws expected error'
);

-- Toggle psector id=1 ON
SELECT is(
    (gw_fct_set_toggle_current('{"data": {"type": "psector", "id": 1}}')::json->'status')::text,
    '"Accepted"',
    'Toggle psector 1 ON returns status Accepted'
);
SELECT is(
    (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = 'plan_psector_current'),
    '1',
    'plan_psector_current is set to 1 after toggling psector 1 ON'
);

-- Toggle psector id=1 OFF
SELECT is(
    (gw_fct_set_toggle_current('{"data": {"type": "psector", "id": 1}}')::json->'status')::text,
    '"Accepted"',
    'Toggle psector 1 OFF returns status Accepted'
);
SELECT is(
    (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = 'plan_psector_current'),
    NULL,
    'plan_psector_current is NULL after toggling psector 1 OFF'
);

-- Toggle psector id=2 ON
SELECT is(
    (gw_fct_set_toggle_current('{"data": {"type": "psector", "id": 2}}')::json->'status')::text,
    '"Accepted"',
    'Toggle psector 2 ON returns status Accepted'
);
SELECT is(
    (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = 'plan_psector_current'),
    '2',
    'plan_psector_current is set to 2 after toggling psector 2 ON'
);

-- Toggle psector id=1 ON (should switch from 2 to 1)
SELECT is(
    (gw_fct_set_toggle_current('{"data": {"type": "psector", "id": 1}}')::json->'status')::text,
    '"Accepted"',
    'Toggle psector 1 ON (from 2) returns status Accepted'
);
SELECT is(
    (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = 'plan_psector_current'),
    '1',
    'plan_psector_current is set to 1 after toggling psector 1 ON (from 2)'
);

-- Finish the test
SELECT finish();

ROLLBACK;
