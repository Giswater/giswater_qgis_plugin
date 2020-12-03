/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE arc_type DROP CONSTRAINT arc_type_epa_table_check;

ALTER TABLE arc_type
  ADD CONSTRAINT arc_type_epa_table_check CHECK (epa_table::text = ANY (ARRAY['inp_pipe'::character varying, 'inp_pump_importinp'::character varying,'inp_valve_importinp'::character varying]::text[]));
