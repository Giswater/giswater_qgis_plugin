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

SELECT plan(6);

insert into plan_netscenario (netscenario_id, expl_id) values (-901, 1);
INSERT INTO selector_expl (cur_user, expl_id) VALUES (current_user, 1) ON CONFLICT (cur_user, expl_id) DO NOTHING;

INSERT INTO config_param_user ("parameter", value, cur_user) VALUES ('plan_netscenario_current', '-901', current_user)
ON CONFLICT ("parameter", cur_user) DO UPDATE SET value = EXCLUDED.value;

INSERT INTO ve_plan_netscenario_dma (netscenario_id, netscenario_name, dma_id, "name", pattern_id, graphconfig, the_geom, active, stylesheet, expl_id2)
VALUES(-901, '', -901, '', '', null, null, false, null, 0);
SELECT is((SELECT count(*)::integer FROM ve_plan_netscenario_dma WHERE dma_id = -901), 1, 'INSERT: ve_plan_netscenario_dma -901 was inserted');
SELECT is((SELECT count(*)::integer FROM plan_netscenario_dma WHERE dma_id = -901), 1, 'INSERT: plan_netscenario_dma -901 was inserted');


UPDATE ve_plan_netscenario_dma SET name = 'updated name' WHERE dma_id = -901;
SELECT is((SELECT name FROM ve_plan_netscenario_dma WHERE dma_id = -901), 'updated name', 'UPDATE: ve_plan_netscenario_dma -901 was updated');
SELECT is((SELECT dma_name FROM plan_netscenario_dma WHERE dma_id = -901), 'updated name', 'UPDATE: plan_netscenario_dma -901 was updated');


DELETE FROM ve_plan_netscenario_dma WHERE dma_id = -901;
SELECT is((SELECT count(*)::integer FROM ve_plan_netscenario_dma WHERE dma_id = -901), 0, 'DELETE: ve_plan_netscenario_dma -901 was deleted');
SELECT is((SELECT count(*)::integer FROM plan_netscenario_dma WHERE dma_id = -901), 0, 'DELETE: plan_netscenario_dma -901 was deleted');


SELECT * FROM finish();

ROLLBACK;