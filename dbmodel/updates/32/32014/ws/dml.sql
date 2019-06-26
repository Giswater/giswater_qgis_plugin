/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE node_type SET graf_delimiter = 'NONE';
UPDATE node_type SET graf_delimiter = 'MINSECTOR' WHERE type='VALVE';
UPDATE node_type SET graf_delimiter = 'PRESSZONE' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'DQA' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'DMA' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'SECTOR' WHERE type IN ('TANK', 'WATERWELL', 'WTP', 'SOURCE');


INSERT INTO macroexploitation VALUES (-1, 'Undefined marcroexploitation');
INSERT INTO exploitation VALUES (-1, 'Undefined exploitation',-1);
INSERT INTO dma VALUES (-1, 'Undefined dma');
INSERT INTO sector VALUES (-1, 'Undefined sector');
INSERT INTO cat_presszone VALUES (-1, 'Undefined presszone',-1);

INSERT INTO inp_typevalue VALUES ('inp_recursive_function', '1', 'SINGLE NODE CAPACITY', null, '{"functionName":"gw_fct_pg2epa_singlenodecapacity", "sytemParameters":{"storeAllResults":"false", "steps":"999"}, "userParameters":{"demand":{"min":"10", "max":"280", "increase":"1"}}}');
INSERT INTO inp_typevalue VALUES ('inp_recursive_function', '2', 'NODES COUPLE CAPACITY', null, '{"functionName":"gw_fct_pg2epa_nodescouplecapacity", "sytemParameters":{"storeAllResults":"false", "steps":"5"}, "userParameters":{"demand":{"single":"60"}}');
