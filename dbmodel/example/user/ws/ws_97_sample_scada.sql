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

INSERT INTO ext_rtc_scada VALUES ('S01E00001', 'S01', 'E00001', '113873', '113873','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('S01E00002', 'S01', 'E00002', '1080', '1080','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('S01E00003', 'S01', 'E00003', '113952', '113952','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('S01E00004', 'S01', 'E00004', '1101', '1101','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('S01E00005', 'S01', 'E00005', '111111', '111111','FLOWMETER');
INSERT INTO ext_rtc_scada VALUES ('S01E00006', 'S01', 'E00006', '1097', '1097','FLOWMETER');


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





