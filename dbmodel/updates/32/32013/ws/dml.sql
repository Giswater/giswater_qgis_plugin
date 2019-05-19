/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO inp_typevalue VALUES ('inp_value_class','1','ESTIMATED');
INSERT INTO inp_typevalue VALUES ('inp_value_class','2','VOLUME CRM');
INSERT INTO inp_typevalue VALUES ('inp_value_class','3','UNITARY CRM');


INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','1','UNIQUE ESTIMATED PATTERN', '1');
INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','2','DMA ESTIMATED PATTERN', '1');
INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','3','NODE ESTIMATED PATTERN', '1');
INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','4','DMA PERIOD MIN VALUE', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','5','DMA PERIOD MAX VALUE', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','6','DMA PERIOD UNITARY PATTERN', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','7','DMA CUSTOM UNITARY PATTERN', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','8','DMA CUSTOM VOLUME PATTERN', '3');
INSERT INTO inp_typevalue VALUES ('inp_value_patterntype','9','NODE CUSTOM VOLUME PATTERN', '3');

