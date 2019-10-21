/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/10/2019

CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec AS 
 SELECT rtc_hydrometer_x_connec.connec_id,count(v_rtc_hydrometer.hydrometer_id)::integer AS n_hydrometer
   FROM rtc_hydrometer_x_connec
   JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id = rtc_hydrometer_x_connec.hydrometer_id::text
	GROUP BY rtc_hydrometer_x_connec.connec_id;
