/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

/*
delete from rtc_scada;
delete from rtc_scada_x_data;
*/

INSERT INTO ext_rtc_scada VALUES ('113873', 'SCD-0001', 'SCD-0001','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('1080', 'SCD-0002', 'SCD-0002','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('113952', 'SCD-0003', 'SCD-0003','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('1101', 'SCD-0004', 'SCD-0004','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('111111', 'SCD-0005', 'SCD-0005','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('1097', 'SCD-0006', 'SCD-0006','FLOWMETER');

-- dma1 (in)
INSERT INTO ext_rtc_scada_x_data VALUES ('113873', '5', 10120.5, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('113873', '6', 10112.2, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('113873', '7', 9734.9, 1,1,1);

-- dma2 (in)
INSERT INTO ext_rtc_scada_x_data VALUES ('1080', '5', 9999.5, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('1080', '6', 9945.4, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('1080', '7', 9215.3, 1,1,1);

-- dma3 (in)
INSERT INTO ext_rtc_scada_x_data VALUES ('113952', '5', 9315.2, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('113952', '6', 9454.4, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('113952', '7', 9321.3, 1,1,1);

-- dm4 (in)
INSERT INTO ext_rtc_scada_x_data VALUES ('1101', '5', 5000, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('1101', '6', 5000, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('1101', '7', 5000, 1,1,1);

INSERT INTO ext_rtc_scada_x_data VALUES ('1097', '5', 5120.5, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('1097', '6', 5112.2, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('1097', '7', 4734.9, 1,1,1);

-- dma5 (in)
INSERT INTO ext_rtc_scada_x_data VALUES ('111111', '5', 9315.2, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('111111', '6', 9454.4, 1,1,1);
INSERT INTO ext_rtc_scada_x_data VALUES ('111111', '7', 9321.3, 1,1,1);





