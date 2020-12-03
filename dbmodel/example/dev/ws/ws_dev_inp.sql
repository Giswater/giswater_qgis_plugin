/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- controls
INSERT INTO inp_controls_x_arc (id, arc_id, text) VALUES (1, '2005', 'LINK 2005 CLOSED IF 1001 BELOW 4', true);
INSERT INTO inp_controls_x_arc (id, arc_id, text) VALUES (2, '2002', 'LINK 2002 CLOSED IF 1001 ABOVE 3', true);


-- emiteers
INSERT INTO inp_emitter (node_id, coef) VALUES ('1001', 0.5);
INSERT INTO inp_emitter (node_id, coef) VALUES ('1002', 0.1);
INSERT INTO inp_emitter (node_id, coef) VALUES ('1003', 0.2);
INSERT INTO inp_emitter (node_id, coef) VALUES ('1004', 0.4);


-- energy
INSERT INTO inp_energy (descript) VALUES ('GLOBAL PRICE 0.5');
INSERT INTO inp_energy (descript) VALUES ('GLOBAL PATTERN pattern_01');
INSERT INTO inp_energy (descript) VALUES ('GLOBAL EFFIC 0.8');

UPDATE inp_pump SET energyparam = 'PRICE', energyvalue='0.5';

UPDATE inp_pump_additional SET energyparam = 'PRICE', energyvalue='0.5';


--quality
INSERT INTO inp_source (node_id, sourc_type, quality, pattern_id) VALUES ('1001', 'CONCEN', 1.200000, 'pattern_01');
INSERT INTO inp_source (node_id, sourc_type, quality, pattern_id) VALUES ('1002', 'MASS', 17.000000, 'pattern_02');
INSERT INTO inp_source (node_id, sourc_type, quality, pattern_id) VALUES ('1003', 'CONCEN', 1.500000, 'pattern_01');

INSERT INTO inp_quality (node_id, initqual) VALUES ('1001', 0.12);
INSERT INTO inp_quality (node_id, initqual) VALUES ('1002', 0.25);
INSERT INTO inp_quality (node_id, initqual) VALUES ('1003', 0.27);
INSERT INTO inp_quality (node_id, initqual) VALUES ('1004', 0.125);

INSERT INTO inp_mixing (node_id, mix_type, value) VALUES ('113766', '2COMP', 1);

INSERT INTO inp_reactions (descript) VALUES ('GLOBAL BULK -0.5');
INSERT INTO inp_reactions (descript) VALUES ('GLOBAL WALL -1.0');
INSERT INTO inp_reactions (descript) VALUES ('LIMITING POTENTIAL 1');
INSERT INTO inp_reactions (descript) VALUES ('ROUGHNESS CORRELATION 1.8');

UPDATE inp_pipe SET reactionparam='WALL', reactionvalue='0.3';

UPDATE inp_curve SET descript ='curve demo for pumps';



