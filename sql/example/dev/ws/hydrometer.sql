-- hydrometer multiplier
------------------------

-- TABLE ext_rtc_hydrometer
INSERT INTO SCHEMA_NAME.ext_rtc_hydrometer (id, code, hydrometer_category, state_id, connec_id, catalog_id)
SELECT concat(11,row_number() over (order by sys_feature_cat.id) ,ext_rtc_hydrometer.id), code, hydrometer_category, state_id, connec_id, catalog_id
FROM SCHEMA_NAME.ext_rtc_hydrometer, SCHEMA_NAME.sys_feature_cat

-- TABLE rtc_hydrometer
DELETE from SCHEMA_NAME.rtc_hydrometer
INSERT INTO SCHEMA_NAME.rtc_hydrometer
SELECT id FROM SCHEMA_NAME.ext_rtc_hydrometer

-- TABLE rtc_hydrometer_x_connec
DELETE from SCHEMA_NAME.rtc_hydrometer_x_connec
INSERT INTO SCHEMA_NAME.rtc_hydrometer_x_connec
SELECT id, connec.connec_id FROM SCHEMA_NAME.ext_rtc_hydrometer join SCHEMA_NAME.connec on customer_code=ext_rtc_hydrometer.connec_id