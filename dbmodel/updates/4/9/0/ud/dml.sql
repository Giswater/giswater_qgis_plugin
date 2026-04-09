/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''GULLY''=ANY(feature_type))' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''GULLY''=ANY(feature_type))' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''GULLY''=ANY(feature_type))' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';

DELETE FROM config_param_user WHERE "parameter"='edit_insert_show_elevation_from_dem' AND cur_user='postgres';

INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('dwfzone_graph','Table to manage graph for dwfzone','role_edit','core');

-- 09/04/2026
WITH connec_customer AS (
    SELECT rxc.hydrometer_id,
        MIN(c.customer_code) AS customer_code
    FROM rtc_hydrometer_x_connec rxc
    JOIN connec c ON c.connec_id = rxc.connec_id
    WHERE c.customer_code IS NOT NULL
    GROUP BY rxc.hydrometer_id
)
UPDATE ext_rtc_hydrometer h
SET customer_code = cc.customer_code
FROM connec_customer cc
WHERE h.hydrometer_id = cc.hydrometer_id;

DROP TABLE IF EXISTS rtc_hydrometer_x_connec;
