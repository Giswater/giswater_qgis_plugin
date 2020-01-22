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
INSERT INTO cat_presszone VALUES ('1', 'pzone1-1s', 1, NULL, NULL,  '{"use":[{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('2', 'pzone1-2s', 2, NULL, NULL, '{"use":[{"nodeParent":"1101", "toArc":[2205]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('3', 'pzone1-1d', 1, NULL, NULL, '{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('4', 'pzone1-2d', 1, NULL, NULL, '{"use":[{"nodeParent":"1083", "toArc":[2095]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('5', 'pzone2-1s', 2, NULL, NULL, '{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('6', 'pzone2-2d', 2,  NULL, NULL, '{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');


delete from dma;
INSERT INTO dma VALUES (1, 'dma1-1d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO dma VALUES (2, 'dma1-2d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"1080", "toArc":[2092]}], "ignore":[]}');
INSERT INTO dma VALUES (3, 'dma2-1d', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');
INSERT INTO dma VALUES (4, 'source-1', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"1101", "toArc":[2205]},{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO dma VALUES (5, 'source-2', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');


delete from dqa;
INSERT INTO dqa VALUES (1, 'dqa1-1d', 1, NULL, NULL, NULL, NULL, NULL, NULL, 'chlorine','{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO dqa VALUES (2, 'dqa2-1d', 2, NULL, NULL, NULL, NULL, NULL, NULL, 'chlorine','{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');
INSERT INTO dqa VALUES (3, 'dqa1-1s', 1, NULL, NULL, NULL, NULL, NULL, NULL, 'chlorine','{"use":[{"nodeParent":"1101", "toArc":[2205]},{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO dqa VALUES (4, 'dqa2-1s', 2, NULL, NULL, NULL, NULL, NULL, NULL, 'chlorine','{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');


delete from sector;
INSERT INTO sector VALUES (1, 'sector1-1s', 1, NULL, NULL, NULL, 'source','{"use":[{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO sector VALUES (2, 'sector1-2s', 1, NULL, NULL, NULL, 'source','{"use":[{"nodeParent":"1101", "toArc":[2205]}], "ignore":[]}');
INSERT INTO sector VALUES (3, 'sector1-1d', 1, NULL, NULL, NULL , 'distribution','{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO sector VALUES (4, 'sector2-1s', 2, NULL, NULL, NULL, 'source','{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');
INSERT INTO sector VALUES (5, 'sector2-1d', 2, NULL, NULL, NULL , 'distribution','{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');

delete from inp_inlet;
INSERT INTO inp_inlet VALUES ('113766', 1.0000, 0.0000, 3.5000, 12.0000, 0.0000, NULL, NULL);
INSERT INTO inp_inlet VALUES ('113952', 1.0000, 0.0000, 3.5000, 12.0000, 0.0000, NULL, NULL);

UPDATE node SET epa_type='INLET' WHERE node_id IN ('113766', '113952');

delete from inp_reservoir;
INSERT INTO inp_reservoir  VALUES ('111111', NULL);
INSERT INTO inp_reservoir  VALUES ('1097', NULL);
INSERT INTO inp_reservoir  VALUES ('1101', NULL);

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
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"SECTOR", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","concaveHullParam":0.85}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DQA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","buffer":30}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"PRESSZONE","exploitation":"[1,2]",
"updateFeature":"TRUE","updateMapZone":"TRUE","buffer":20}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","buffer":15}}}');

SELECT gw_fct_grafanalytics_minsector('{"data":{"parameters":{"exploitation":"[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","buffer":10}}}');


-- lastprocess
delete from link where link_id=197;
delete from link where link_id=211;

select gw_fct_connect_to_network((select array_agg(connec_id)from connec where connec_id IN ('3076', '3177')), 'CONNEC');

update connec set pjoint_id = exit_id, pjoint_type='VNODE' FROM link WHERE link.feature_id=connec_id;

UPDATE connec SET label_rotation=24.5, label_x=3 WHERE connec_id='3014';

INSERT INTO inp_selector_sector (sector_id, cur_user)
SELECT sector_id, current_user FROM sector
ON CONFLICT (sector_id, cur_user) DO NOTHING;

SELECT gw_fct_pg2epa_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"iterative":"off", "resultId":"gw_check_project", "useNetworkGeom":"false"}}$$);

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'audit_project_user_control';

--deprecated fields
UPDATE arc SET _sys_length=NULL;
UPDATE anl_mincut_inlet_x_exploitation SET _to_arc= NULL;


-- adjustment of ischange
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1006';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1025';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1039';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1040';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1057';


UPDATE node SET nodecat_id='TDN63-63 PN16' WHERE node_id='1044';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1063';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1067';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1069';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1044';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1063';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1067';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1069';
UPDATE node SET nodecat_id='REDUC_200-110 PN16' WHERE node_id='113873';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='113880';
UPDATE node SET nodecat_id='REDUC_160-110 PN16' WHERE node_id='113883';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='113954';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='113955';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='113994';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='114016';

UPDATE man_valve SET closed = TRUE WHERE node_id = '1115';
UPDATE man_valve SET broken = TRUE WHERE node_id IN ('1112', '1093');

UPDATE config_param_system SET value = '{"SECTOR":true, "DMA":true, "PRESSZONE":true, "DQA":true, "MINSECTOR":true}'
WHERE parameter = 'om_dynamicmapzones_status';