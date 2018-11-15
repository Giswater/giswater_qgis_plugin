DROP VIEW SCHEMA_NAME.v_ui_hydrometer ;

CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_hydrometer AS 
 SELECT v_rtc_hydrometer.hydrometer_id AS sys_hydrometer_id,
    v_rtc_hydrometer.connec_id AS sys_connec_id,
    v_rtc_hydrometer.hydrometer_customer_code AS "Codi abonat:",
    v_rtc_hydrometer.connec_customer_code AS "Codi escomesa:",
    v_rtc_hydrometer.plot_code AS "Codi finca:",
    v_rtc_hydrometer.hydro_number AS "Núm. comptador:",
    v_rtc_hydrometer.state AS "Estat:",
    v_rtc_hydrometer.expl_name AS "Explotació:",
    v_rtc_hydrometer.customer_name AS "Titular:",
    v_rtc_hydrometer.address1 AS "Adreça 1",
    v_rtc_hydrometer.address2 AS "Adreça 2",
    v_rtc_hydrometer.address3 AS "Adreça 3",
    v_rtc_hydrometer.address2_1 AS "Adreça 2-1",
    v_rtc_hydrometer.address2_2 AS "Adreça 2-2",
    v_rtc_hydrometer.address2_3 AS "Adreça 2-3"
   FROM SCHEMA_NAME.v_rtc_hydrometer;
   
   
GRANT SELECT ON TABLE SCHEMA_NAME.v_ui_hydrometer TO role_basic;
GRANT SELECT ON TABLE SCHEMA_NAME.v_ui_hydrometer TO role_edit;
GRANT SELECT ON TABLE SCHEMA_NAME.v_ui_hydrometer TO role_om;
GRANT SELECT ON TABLE SCHEMA_NAME.v_ui_hydrometer TO role_epa;
GRANT SELECT ON TABLE SCHEMA_NAME.v_ui_hydrometer TO role_master;
GRANT SELECT ON TABLE SCHEMA_NAME.v_ui_hydrometer TO role_admin;