/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--check typevalue
ALTER TABLE inp_pipe ADD CONSTRAINT inp_pipe_status_check CHECK ( status IN ('CLOSED','CV','OPEN'));
ALTER TABLE inp_shortpipe ADD CONSTRAINT inp_shortpipe_status_check CHECK ( status IN ('CLOSED','CV','OPEN'));
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_status_check CHECK ( status IN ('CLOSED','OPEN'));
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_pattern_check CHECK ( status IN ('CLOSED','OPEN'));
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_status_check CHECK ( status IN ('ACTIVE','CLOSED','OPEN'));