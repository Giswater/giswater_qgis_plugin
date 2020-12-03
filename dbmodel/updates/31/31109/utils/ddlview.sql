/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-- 
DROP VIEW IF EXISTS v_edit_rtc_hydro_data_x_connec;
CREATE OR REPLACE VIEW v_edit_rtc_hydro_data_x_connec AS
SELECT
ext_rtc_hydrometer_x_data.id,
rtc_hydrometer_x_connec.connec_id,
ext_rtc_hydrometer_x_data.hydrometer_id,
ext_rtc_hydrometer.code,
ext_rtc_hydrometer.catalog_id,
ext_rtc_hydrometer_x_data.cat_period_id,
ext_cat_period.code as cat_period_code,
ext_rtc_hydrometer_x_data.value_date,
sum,
custom_sum
FROM ext_rtc_hydrometer_x_data
JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::int8=ext_rtc_hydrometer.id::int8
LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::int8 = ext_rtc_hydrometer.catalog_id::int8
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::int8=ext_rtc_hydrometer_x_data.hydrometer_id::int8
JOIN ext_cat_period ON cat_period_id=ext_cat_period.id
ORDER BY 3, 6 DESC ;


CREATE OR REPLACE VIEW v_ui_om_event AS 
 SELECT *     
   FROM om_visit_event;
 

create OR REPLACE view v_ui_om_visit_x_doc
as 
SELECT * FROM doc_x_visit;


-- 2019/03/04
CREATE OR REPLACE VIEW v_ext_streetaxis AS SELECT
ext_streetaxis.id,
code,
type,
name,
text,
the_geom,
ext_streetaxis.expl_id,
muni_id,
CASE
    WHEN type IS NULL THEN name
    WHEN text IS NULL THEN name || ', ' || type ||'.'
    WHEN type IS NULL AND text IS NULL THEN name
    ELSE name || ', ' || type || '. ' || text
END AS descript
FROM selector_expl,ext_streetaxis
WHERE ((ext_streetaxis.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());



