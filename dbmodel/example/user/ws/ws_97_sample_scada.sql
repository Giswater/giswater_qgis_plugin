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



