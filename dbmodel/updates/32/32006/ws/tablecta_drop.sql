/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE  inp_typevalue DROP CONSTRAINT IF EXISTS inp_typevalue_id_unique CASCADE;


--check typevalue

ALTER TABLE inp_shortpipe  DROP CONSTRAINT IF EXISTS inp_shortpipe_status_check;
ALTER TABLE inp_pump  DROP CONSTRAINT IF EXISTS inp_pumpe_status_check ;
ALTER TABLE inp_pipe  DROP CONSTRAINT IF EXISTS inp_pipe_status_check ;
ALTER TABLE inp_valve  DROP CONSTRAINT IF EXISTS inp_valve_status_check;
ALTER TABLE inp_pump_additional  DROP CONSTRAINT IF EXISTS inp_pump_additional_pattern_check;




