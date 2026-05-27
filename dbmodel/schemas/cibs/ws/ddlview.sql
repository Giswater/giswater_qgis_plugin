/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE OR REPLACE VIEW v_hydrometer AS
SELECT * FROM cibs.hydrometer;

CREATE OR REPLACE VIEW v_hydrometer_data AS
SELECT * FROM cibs.hydrometer_data;

CREATE OR REPLACE VIEW v_cat_hydrometer AS
SELECT * FROM cibs.cat_hydrometer;

CREATE OR REPLACE VIEW v_cat_hydrometer_state AS
SELECT * FROM cibs.cat_hydrometer_state;

CREATE OR REPLACE VIEW v_cat_hydrometer_priority AS
SELECT * FROM cibs.cat_hydrometer_priority;

CREATE OR REPLACE VIEW v_cat_hydrometer_type AS
SELECT * FROM cibs.cat_hydrometer_type;

CREATE OR REPLACE VIEW v_cat_hydrometer_category AS
SELECT * FROM cibs.cat_hydrometer_category;
