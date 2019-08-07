/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- drop constraints
SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);

delete from cat_presszone;
INSERT INTO cat_presszone VALUES ('1', 'pzone1-1s', 1, NULL, '[1097]');
INSERT INTO cat_presszone VALUES ('2', 'pzone1-2s', 2, NULL, '[1101]');
INSERT INTO cat_presszone VALUES ('3', 'pzone1-1d', 1, NULL, '[113766]');
INSERT INTO cat_presszone VALUES ('4', 'pzone1-2d', 1, NULL, '[1083]');
INSERT INTO cat_presszone VALUES ('5', 'pzone2-1s', 2, NULL, '[111111]');
INSERT INTO cat_presszone VALUES ('6', 'pzone2-2d', 2, NULL, '[113952]');

delete from dma;
INSERT INTO dma VALUES (1, 'dma1-1d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[113766]');
INSERT INTO dma VALUES (2, 'dma1-2d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[1080]');
INSERT INTO dma VALUES (3, 'dma2-1d', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[113952]');

delete from dqa;
INSERT INTO dqa  VALUES (1, 'dqa1-1d', NULL, NULL, NULL, NULL, NULL, NULL,'[113766]', NULL);
INSERT INTO dqa  VALUES (2, 'dqa2-1d', NULL, NULL, NULL, NULL, NULL, NULL,'[113952]', NULL);

delete from sector;
INSERT INTO sector VALUES (1, 'sector1-1s', 1, NULL, NULL, NULL, '[1097]', 'source');
INSERT INTO sector VALUES (2, 'sector1-2s', 1, NULL, NULL, NULL, '[1101]', 'source');
INSERT INTO sector VALUES (3, 'sector1-1d', 1, NULL, NULL, NULL , '[113766]', 'distribution');
INSERT INTO sector VALUES (4, 'sector2-1s', 2, NULL, NULL, NULL, '[111111]', 'source');
INSERT INTO sector VALUES (5, 'sector2-1d', 2, NULL, NULL, NULL , '[113952]', 'distribution');

delete from inp_inlet;
INSERT INTO inp_inlet VALUES ('113766', 1.0000, 0.0000, 3.5000, 12.0000, 0.0000, NULL, NULL, '113906');
INSERT INTO inp_inlet VALUES ('113952', 1.0000, 0.0000, 3.5000, 12.0000, 0.0000, NULL, NULL, '114146');

delete from inp_reservoir;
INSERT INTO inp_reservoir  VALUES ('111111', NULL, '114025');
INSERT INTO inp_reservoir  VALUES ('1097', NULL, '2207');
INSERT INTO inp_reservoir  VALUES ('1101', NULL, '2205');


-- recover constraints
SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"ADD"}}$$);

-- dynamic sectorization
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"presszone", "exploitation": "[1,2]", "upsertFeature":"TRUE"}}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"dma", "exploitation": "[1,2]", "upsertFeature":TRUE}}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"dqa", "exploitation": "[1,2]", "upsertFeature":TRUE}}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"sector", "exploitation": "[1,2]", "upsertFeature":TRUE}}}');






