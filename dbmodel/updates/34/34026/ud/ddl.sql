/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/16
ALTER TABLE IF EXISTS inp_timeseries RENAME TO inp_timeseries_value;
ALTER TABLE IF EXISTS inp_timser_id RENAME TO inp_timeseries;

ALTER TABLE IF EXISTS inp_transects RENAME TO inp_transects_value;
ALTER TABLE IF EXISTS inp_transects_id RENAME TO inp_transects;

ALTER SEQUENCE IF EXISTS inp_timeseries_seq RENAME TO inp_timeseries_value_seq;
ALTER SEQUENCE IF EXISTS inp_transects_seq RENAME TO inp_transects_value_seq;