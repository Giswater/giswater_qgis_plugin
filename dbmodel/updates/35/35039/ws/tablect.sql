/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;


DROP INDEX IF EXISTS ws.inp_dscenario_demand_source;

CREATE INDEX IF NOT EXISTS inp_dscenario_demand_dscenario_id
ON inp_dscenario_demand USING btree (dscenario_id) TABLESPACE pg_default;
