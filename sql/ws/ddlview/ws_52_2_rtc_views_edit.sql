/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Updated on 3.1.105
------------------------------------

DROP VIEW IF EXISTS v_edit_rtc_hydro_data_x_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_rtc_hydro_data_x_connec AS
SELECT *
FROM ext_rtc_hydrometer_x_data

