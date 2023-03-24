/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE IF EXISTS inp_dscenario_demand DROP CONSTRAINT IF EXISTS inp_demand_pattern_id_fkey;

ALTER TABLE IF EXISTS inp_dscenario_demand
    ADD CONSTRAINT inp_dscenario_demand_pattern_id_fkey FOREIGN KEY (pattern_id)
    REFERENCES inp_pattern (pattern_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

 ALTER TABLE IF EXISTS inp_dscenario_junction DROP CONSTRAINT IF EXISTS inp_demand_pattern_id_fkey;

ALTER TABLE IF EXISTS inp_dscenario_junction
    ADD CONSTRAINT inp_dscenario_junction_pattern_id_fkey FOREIGN KEY (pattern_id)
    REFERENCES inp_pattern (pattern_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;