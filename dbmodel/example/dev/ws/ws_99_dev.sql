/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;




--how filter rules & controls in f() of planification????
---------------------------------------------------------

INSERT INTO ws_sample.inp_emitter (node_id, coef) VALUES ('1001', 0.5);
INSERT INTO ws_sample.inp_emitter (node_id, coef) VALUES ('1002', 0.1);
INSERT INTO ws_sample.inp_emitter (node_id, coef) VALUES ('1003', 0.2);
INSERT INTO ws_sample.inp_emitter (node_id, coef) VALUES ('1004', 0.4);


INSERT INTO ws_sample.inp_energy (id, pump_id, parameter, value) VALUES (1, '1105', 'EFFIC', '1');
INSERT INTO ws_sample.inp_energy (id, pump_id, parameter, value) VALUES (2, '113951', 'PATTERN', '1');


INSERT INTO ws_sample.inp_quality (node_id, initqual) VALUES ('1001', 0.12);
INSERT INTO ws_sample.inp_quality (node_id, initqual) VALUES ('1002', 0.25);
INSERT INTO ws_sample.inp_quality (node_id, initqual) VALUES ('1003', 0.27);
INSERT INTO ws_sample.inp_quality (node_id, initqual) VALUES ('1004', 0.125);


INSERT INTO ws_sample.inp_mixing (node_id, mix_type, value) VALUES ('113766', '2COMP', 1);


INSERT INTO ws_sample.inp_reactions (id, parameter, arc_id, value) VALUES (7, 'WALL_EL', '2001', -0.5);
INSERT INTO ws_sample.inp_reactions (id, parameter, arc_id, value) VALUES (8, 'WALL_EL', '2002', -0.7);
INSERT INTO ws_sample.inp_reactions (id, parameter, arc_id, value) VALUES (11, 'WALL_EL', '2003', -0.2);


INSERT INTO ws_sample.inp_rules (id, node_id, text) VALUES (1, '113766', 'RULE 1');
INSERT INTO ws_sample.inp_rules (id, node_id, text) VALUES (3, '113766', 'THEN PUMP 1105_n2a STATUS IS CLOSED');
INSERT INTO ws_sample.inp_rules (id, node_id, text) VALUES (4, '113766', 'RULE 2');
INSERT INTO ws_sample.inp_rules (id, node_id, text) VALUES (6, '113766', 'THEN PUMP 1105_n2a STATUS IS OPEN');
INSERT INTO ws_sample.inp_rules (id, node_id, text) VALUES (2, '113766', 'IF TANK 113766 LEVEL ABOVE 3');
INSERT INTO ws_sample.inp_rules (id, node_id, text) VALUES (5, '113766', 'IF TANK 113766 LEVEL BELOW 0.75');

INSERT INTO ws_sample.inp_controls (id, node_id, text) VALUES (5, '113766', 'IF TANK 113766 LEVEL BELOW 0.75');


INSERT INTO ws_sample.inp_source (node_id, sourc_type, quality, pattern_id) VALUES ('1001', 'CONCEN', 1.200000, 'pattern_01');
INSERT INTO ws_sample.inp_source (node_id, sourc_type, quality, pattern_id) VALUES ('1002', 'MASS', 17.000000, 'pattern_02');
INSERT INTO ws_sample.inp_source (node_id, sourc_type, quality, pattern_id) VALUES ('1003', 'CONCEN', 1.500000, 'pattern_01');

