/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 28/10/2025
DROP VIEW IF EXISTS ve_plan_netscenario_dma;
DROP VIEW IF EXISTS ve_plan_netscenario_presszone;

ALTER TABLE plan_netscenario_dma RENAME COLUMN expl_id2 TO expl_id;
ALTER TABLE plan_netscenario_dma ALTER COLUMN expl_id TYPE _int4 USING ARRAY[expl_id::int4];
ALTER TABLE plan_netscenario_dma ADD muni_id _int4 NULL;
ALTER TABLE plan_netscenario_dma ADD sector_id _int4 NULL;

ALTER TABLE plan_netscenario_presszone RENAME COLUMN expl_id2 TO expl_id;
ALTER TABLE plan_netscenario_presszone ALTER COLUMN expl_id TYPE _int4 USING ARRAY[expl_id::int4];
ALTER TABLE plan_netscenario_presszone ADD muni_id _int4 NULL;
ALTER TABLE plan_netscenario_presszone ADD sector_id _int4 NULL;

ALTER TABLE om_mincut
ADD CONSTRAINT chk_forecast_order
CHECK (
  forecast_end >= forecast_start
);

ALTER TABLE om_mincut
ADD CONSTRAINT chk_exec_order
CHECK (
  exec_end >= exec_start
);
