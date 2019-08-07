/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO macroexploitation VALUES (0, 'Undefined');
INSERT INTO exploitation VALUES (0, 'Undefined',0);
INSERT INTO macrodqa VALUES (0, 'Undefined', 0);
INSERT INTO macrodma VALUES (0, 'Undefined',0);
INSERT INTO macrosector VALUES (0, 'Undefined');

INSERT INTO dma VALUES (0, 'Undefined', 0);
INSERT INTO dqa VALUES (0, 'Undefined', 0);
INSERT INTO sector VALUES (0, 'Undefined', 0);
INSERT INTO cat_presszone VALUES (0, 'Undefined',0);

INSERT INTO inp_typevalue VALUES ('inp_iterative_function', '1', 'NODES COUPLE CAPACITY', null, '{"functionName":"gw_fct_pg2epa_nodescouplecapacity", "systemParameters":{"storeAllResults":"false", "steps":"4"}}');