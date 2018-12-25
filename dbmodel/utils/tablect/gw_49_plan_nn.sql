/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP

ALTER TABLE plan_psector ALTER COLUMN name DROP NOT NULL;

ALTER TABLE plan_psector_x_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE plan_psector_x_arc ALTER COLUMN psector_id DROP NOT NULL;
ALTER TABLE plan_psector_x_arc ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE plan_psector_x_arc ALTER COLUMN doable DROP NOT NULL;

ALTER TABLE plan_psector_x_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE plan_psector_x_node ALTER COLUMN psector_id DROP NOT NULL;
ALTER TABLE plan_psector_x_node ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE plan_psector_x_node ALTER COLUMN doable DROP NOT NULL;

ALTER TABLE plan_psector_x_other ALTER COLUMN price_id DROP NOT NULL;
ALTER TABLE plan_psector_x_other ALTER COLUMN psector_id DROP NOT NULL;

ALTER TABLE plan_arc_x_pavement ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE plan_arc_x_pavement ALTER COLUMN percent DROP NOT NULL;

ALTER TABLE price_simple ALTER COLUMN price DROP NOT NULL;
ALTER TABLE price_simple ALTER COLUMN unit DROP NOT NULL;
ALTER TABLE price_simple ALTER COLUMN descript DROP NOT NULL;


ALTER TABLE price_compost ALTER COLUMN unit DROP NOT NULL;
ALTER TABLE price_compost ALTER COLUMN descript DROP NOT NULL;

ALTER TABLE price_compost_value ALTER COLUMN compost_id DROP NOT NULL;
ALTER TABLE price_compost_value ALTER COLUMN simple_id DROP NOT NULL;


--SET

ALTER TABLE plan_psector ALTER COLUMN name SET NOT NULL;
ALTER TABLE plan_psector ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE plan_psector ALTER COLUMN sector_id SET NOT NULL;

ALTER TABLE plan_psector_x_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE plan_psector_x_arc ALTER COLUMN psector_id SET NOT NULL;
ALTER TABLE plan_psector_x_arc ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE plan_psector_x_arc ALTER COLUMN doable SET NOT NULL;

ALTER TABLE plan_psector_x_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE plan_psector_x_node ALTER COLUMN psector_id SET NOT NULL;
ALTER TABLE plan_psector_x_node ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE plan_psector_x_node ALTER COLUMN doable SET NOT NULL;

ALTER TABLE plan_psector_x_other ALTER COLUMN price_id SET NOT NULL;
ALTER TABLE plan_psector_x_other ALTER COLUMN psector_id SET NOT NULL;

ALTER TABLE plan_arc_x_pavement ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE plan_arc_x_pavement ALTER COLUMN percent SET NOT NULL;


ALTER TABLE price_simple ALTER COLUMN unit SET NOT NULL;
ALTER TABLE price_simple ALTER COLUMN descript SET NOT NULL;

ALTER TABLE price_compost ALTER COLUMN unit SET NOT NULL;
ALTER TABLE price_compost ALTER COLUMN descript SET NOT NULL;

ALTER TABLE price_compost_value ALTER COLUMN compost_id SET NOT NULL;
ALTER TABLE price_compost_value ALTER COLUMN simple_id SET NOT NULL;

