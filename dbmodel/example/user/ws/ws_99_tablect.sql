/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


ALTER TABLE arc ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE arc ALTER COLUMN workcat_id SET NOT NULL;
--ALTER TABLE arc ALTER COLUMN builtdate SET NOT NULL;
ALTER TABLE arc ALTER COLUMN verified SET NOT NULL;
ALTER TABLE arc ALTER COLUMN code SET NOT NULL;
--ALTER TABLE arc ALTER COLUMN node_1 SET NOT NULL;
--ALTER TABLE arc ALTER COLUMN node_2 SET NOT NULL;
ALTER TABLE arc ALTER COLUMN the_geom SET NOT NULL;

ALTER TABLE connec ALTER COLUMN inventory SET NOT NULL;
ALTER TABLE connec ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE connec ALTER COLUMN workcat_id SET NOT NULL;
--ALTER TABLE connec ALTER COLUMN builtdate SET NOT NULL;
ALTER TABLE connec ALTER COLUMN verified SET NOT NULL;
ALTER TABLE connec ALTER COLUMN code SET NOT NULL;
ALTER TABLE connec ALTER COLUMN the_geom SET NOT NULL;

ALTER TABLE element ALTER COLUMN inventory SET NOT NULL;
ALTER TABLE element ALTER COLUMN workcat_id SET NOT NULL;
--ALTER TABLE element ALTER COLUMN builtdate SET NOT NULL;
ALTER TABLE element ALTER COLUMN verified SET NOT NULL;
ALTER TABLE element ALTER COLUMN code SET NOT NULL;



-- drop constraints
SELECT gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);

delete from cat_presszone;
INSERT INTO cat_presszone VALUES ('1', 'pzone1-1s', 1, NULL, '{1097}');
INSERT INTO cat_presszone VALUES ('2', 'pzone1-2s', 2, NULL, '{1101}');
INSERT INTO cat_presszone VALUES ('3', 'pzone1-1d', 1, NULL, '{113766}');
INSERT INTO cat_presszone VALUES ('4', 'pzone1-2d', 1, NULL, '{1083}');
INSERT INTO cat_presszone VALUES ('5', 'pzone2-1s', 2, NULL, '{111111}');
INSERT INTO cat_presszone VALUES ('6', 'pzone2-2d', 2, NULL, '{113952}');

delete from dma;
INSERT INTO dma VALUES (1, 'dma1-1d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{113766}');
INSERT INTO dma VALUES (2, 'dma1-2d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{1080}');
INSERT INTO dma VALUES (3, 'dma2-1d', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{113952}');
INSERT INTO dma VALUES (4, 'source-1', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{1097,1101}');
INSERT INTO dma VALUES (5, 'source-2', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{111111}');


delete from dqa;
INSERT INTO dqa VALUES (1, 'dqa1-1d', 1, NULL, NULL, NULL, NULL, NULL,'{113766}', 'chlorine');
INSERT INTO dqa VALUES (2, 'dqa2-1d', 2, NULL, NULL, NULL, NULL, NULL,'{113952}', 'chlorine');
INSERT INTO dqa VALUES (3, 'dqa1-1s', 1, NULL, NULL, NULL, NULL, NULL, '{1097,1101}','chlorine');
INSERT INTO dqa VALUES (4, 'dqa2-1s', 2, NULL, NULL, NULL, NULL, NULL, '{111111}','chlorine');


delete from sector;
INSERT INTO sector VALUES (1, 'sector1-1s', 1, NULL, NULL, NULL, '{1097}', 'source');
INSERT INTO sector VALUES (2, 'sector1-2s', 1, NULL, NULL, NULL, '{1101}', 'source');
INSERT INTO sector VALUES (3, 'sector1-1d', 1, NULL, NULL, NULL , '{113766}', 'distribution');
INSERT INTO sector VALUES (4, 'sector2-1s', 2, NULL, NULL, NULL, '{111111}', 'source');
INSERT INTO sector VALUES (5, 'sector2-1d', 2, NULL, NULL, NULL , '{113952}', 'distribution');

delete from inp_inlet;
INSERT INTO inp_inlet VALUES ('113766', 1.0000, 0.0000, 3.5000, 12.0000, 0.0000, NULL, NULL, '113906');
INSERT INTO inp_inlet VALUES ('113952', 1.0000, 0.0000, 3.5000, 12.0000, 0.0000, NULL, NULL, '114146');

UPDATE node SET epa_type='INLET' WHERE node_id IN ('113766', '113952');

delete from inp_reservoir;
INSERT INTO inp_reservoir  VALUES ('111111', NULL, '114025');
INSERT INTO inp_reservoir  VALUES ('1097', NULL, '2207');
INSERT INTO inp_reservoir  VALUES ('1101', NULL, '2205');

update arc set sector_id=0, dma_id=0, dqa_id=0, presszonecat_id=0;
update node set sector_id=0, dma_id=0, dqa_id=0,  presszonecat_id=0;
update connec set sector_id=0, dma_id=0, dqa_id=0, presszonecat_id=0;

INSERT INTO dma VALUES (0, 'Undefined', 0);
INSERT INTO dqa VALUES (0, 'Undefined', 0);
INSERT INTO sector VALUES (0, 'Undefined', 0);
INSERT INTO cat_presszone VALUES (0, 'Undefined',0);

-- add constraints
SELECT gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"ADD"}}$$);


-- sectorization
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"PRESSZONE","exploitation":"[1,2]",
"updateFeature":"TRUE","updateMapZone":"TRUE","concaveHullParam":0.85}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","concaveHullParam":0.85}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DQA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","concaveHullParam":0.85}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"SECTOR", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","concaveHullParam":0.85}}}');

SELECT gw_fct_grafanalytics_minsector('{"data":{"parameters":{"exploitation":"[1,2]", 
"updateFeature":"TRUE", "updateMinsectorGeom":"TRUE","concaveHullParam":0.85}}}');

-- lastprocess
UPDATE connec SET pjoint_type='VNODE', pjoint_id='478', label_rotation=24.5, label_x=3
WHERE connec_id='3014';

delete from link where link_id=197;
delete from link where link_id=211;
