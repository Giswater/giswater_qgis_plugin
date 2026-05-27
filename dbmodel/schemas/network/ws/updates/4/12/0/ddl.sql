/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 27/05/2026
DROP VIEW IF EXISTS v_om_mincut_hydrometer;
DROP VIEW IF EXISTS v_om_mincut_current_hydrometer;
DROP VIEW IF EXISTS v_ui_mincut_hydrometer;

ALTER TABLE IF EXISTS om_mincut_hydrometer DROP CONSTRAINT IF EXISTS om_mincut_hydrometer_hydrometer_id_fkey;

ALTER TABLE om_mincut_hydrometer ADD CONSTRAINT om_mincut_hydrometer_hydrometer_id_fkey
FOREIGN KEY (hydrometer_id) REFERENCES ext_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE RESTRICT;
