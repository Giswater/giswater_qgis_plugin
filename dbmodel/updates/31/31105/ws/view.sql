/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

/* Instructions to fill this file for developers
- Use CREATE OR REPLACE
- DROP CASCADE IS FORBIDDEN
- Only use DROP when view:
	- is not customizable view (ie ve_node_* or ve_arc_*)
	- has not other views over
	- has not trigger
*/

DROP VIEW v_edit_rtc_hydro_data_x_connec;
CREATE OR REPLACE VIEW v_edit_rtc_hydro_data_x_connec AS
SELECT
ext_rtc_hydrometer_x_data.id,
rtc_hydrometer_x_connec.connec_id,
ext_rtc_hydrometer_x_data.hydrometer_id,
ext_rtc_hydrometer.catalog_id,
ext_rtc_hydrometer_x_data.cat_period_id,
ext_rct_period.code as cat_period_code,
sum,
custom_sum
FROM ext_rtc_hydrometer_x_data
JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::int8=ext_rtc_hydrometer.id::int8
LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::int8 = ext_rtc_hydrometer.catalog_id::int8
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::int8=ext_rtc_hydrometer_x_data.hydrometer_id::int8
JOIN ext_rct_period ON cat_period_id=ext_rct_period.id
ORDER BY 3, 5 DESC ;



CREATE OR REPLACE VIEW SCHEMA_NAME.v_arc_dattrib AS 
 SELECT arc_id,
	dattrib1 AS dminsector,
	dattrib2 AS dpipehazard,
	dattrib3 AS dinlet
	FROM SCHEMA_NAME.v_edit_arc
     LEFT JOIN ( SELECT rpt.feature_id,
            rpt.dattrib1,
            rpt.dattrib2,
            rpt.dattrib3
            FROM crosstab('SELECT feature_id, dattrib_type, idval FROM SCHEMA_NAME.dattrib ORDER BY 1,2'::text, 'VALUES (''1''), (''2''), (''3'')'::text) 
		rpt(feature_id character varying, dattrib1 text, dattrib2 text, dattrib3 text)) a ON arc_id = feature_id;
		
CREATE OR REPLACE VIEW SCHEMA_NAME.v_node_dattrib AS 
 SELECT node_id,
	dattrib4 AS dstaticpress
	FROM SCHEMA_NAME.v_edit_node
     LEFT JOIN ( SELECT rpt.feature_id,
            rpt.dattrib4
            FROM crosstab('SELECT feature_id, dattrib_type, idval FROM SCHEMA_NAME.dattrib ORDER BY 1,2'::text, 'VALUES (''4'')'::text) 
		rpt(feature_id character varying, dattrib4 text)) a ON node_id = feature_id;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_connec_dattrib AS 
 SELECT connec_id,
	dattrib4 AS dstaticpress
	FROM SCHEMA_NAME.v_edit_connec
     LEFT JOIN ( SELECT rpt.feature_id,
            rpt.dattrib4
            FROM crosstab('SELECT feature_id, dattrib_type, idval FROM SCHEMA_NAME.dattrib ORDER BY 1,2'::text, 'VALUES (''4'')'::text) 
		rpt(feature_id character varying, dattrib4 text)) a ON connec_id = feature_id

