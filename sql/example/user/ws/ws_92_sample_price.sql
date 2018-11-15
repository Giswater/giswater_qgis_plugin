/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO price_compost VALUES ('S_EXC', 'm3', 'Excavation of trench up to 2 m wide and up to 4 meters deep', 'Excavation of trench up to 2 m wide and up to 4 meters deep in compact ground with backhoe and large mechanical load of excavated material', NULL);
INSERT INTO price_compost VALUES ('S_NULL', 'm3', 'Filling pipe material', 'Filling pipe material', 0.0000);
INSERT INTO price_compost VALUES ('S_TRENCH', 'm3', 'Trenchlining of excavation', 'Trenchlining of excavation', 30.0000);
INSERT INTO price_compost VALUES ('S_REB', 'm3', 'Filling and bottom of ditch of more than 1.5 and up to 2 m', 'Filling and compact of ditch of more than 1.5 and up to 2 m, with selected material from the excavation itself in thick, batch of up to 25 cm, using vibrating roller to compact with 95% compaction PM.', NULL);
INSERT INTO price_compost VALUES ('S_REP', 'm3', 'Level and compact of ditch soil', 'Level and compact of ditch soil of more than 0,6 and less than 1,5m, with compact of 90% PM.', NULL);
INSERT INTO price_compost VALUES ('S_TRANS', 'm3', 'Transport of waste to authorized waste management facility', 'Transport of waste to authorized waste management facility, with 12 t truck and waiting time for loading machine, with a distance of more than 15 and up to 20 km', NULL);
INSERT INTO price_compost VALUES ('SECURITY_HEALTH', 'pa', 'Health and safety of works', 'Plan for the implementation of health and safety throughout the works according to the program and instructions of project management.', 0.3000);
INSERT INTO price_compost VALUES ('PROTEC_SERVIS', 'pa', 'Protection of extsting services', 'Location and protection of all existing services that may be affected by the works.', 0.5000);
INSERT INTO price_compost VALUES ('P_SLAB-4P', 'm2', 'Slab pavement 20x20x4 cm', 'Slab pavement 20x20x4 cm, 1st class, higher price, with sand support of 3cm, hammered on mixed mortar 1:0.5:4, made on site with cement mix 165 and concrete.', NULL);
INSERT INTO price_compost VALUES ('P_CONCRETE-20', 'm2', 'Concrete pavement HM-30/P/20/I+E, 20cm thick', 'Concrete pavement HM-30/P/20/I+E, 20cm thick, scattered from the truck, and extended vibratge mechanic, mechanical swirling, including the base of artificial ballast to 95% of PM.', NULL);
INSERT INTO price_compost VALUES ('A_FC63_PN10', 'm', 'Polyethylene pipe, with nominal diameter of 63mm, nominal pressure 10bar', 'Polyethylene pipe ,designation PE 63, with nominal diameter of 110mm, nominal pressure 10bar, series SDR 17, UNE-EN 12201-2, welded and placed on trench bottom.', NULL);
INSERT INTO price_compost VALUES ('A_FD150', 'm', 'Iron pipe with nominal interior diameter of 150mm', 'Iron pipe with nominal interior diameter of 150mm, according to the ISO 2531, bell union with elastomeric ring for water and counter flange, placed on trench bottom.', NULL);
INSERT INTO price_compost VALUES ('A_PVC110_PN16', 'm', 'PVC sewer pipe with nominal exterior diameter of 110mm, nominal pressure of 16 bar', 'PVC sewer pipe with nominal exterior diameter of 110mm, nominal pressure of 16 bar, with elastic join and elastomeric ring, according to the UNE-EN 1452-2; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('A_PVC200_PN16', 'm', 'PVC sewer pipe with nominal exterior diameter of 200mm, nominal pressure of 16 bar', 'PVC sewer pipe with nominal exterior diameter of 200mm, nominal pressure of 16 bar, with elastic join and elastomeric ring, according to the UNE-EN 1452-2; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('A_PVC160_PN16', 'm', 'PVC sewer pipe with nominal exterior diameter of 160mm, nominal pressure of 16 bar', 'PVC sewer pipe with nominal exterior diameter of 160mm, nominal pressure of 16 bar, with elastic join and elastomeric ring, according to the UNE-EN 1452-2; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('N_T63-63_PN16', 'u', 'PVC dervation of DN 63mm, nominal pressure of 16bar, 90° branches of 63mm', 'PVC dervation of DN 63mm, nominal pressure of 16bar , with two elastic unions with elastometric ring, 90° branches of 63mm;placed on the bottom trench.', 28.0000);
INSERT INTO price_compost VALUES ('A_FD200', 'm', 'Iron pipe with nominal interior diameter of 200mm', 'Iron pipe with nominal interior diameter of 200mm, according to the ISO 2531, bell union with elastomeric ring for water and counter flange, placed on trench bottom.', NULL);
INSERT INTO price_compost VALUES ('N_TANK_30x10x3', 'u', 'Construction of potable water tank of dimensions 30x10x3m.', 'Construction of potable water tank of dimensions 30x10x3m.', NULL);
INSERT INTO price_compost VALUES ('N_FLOWMETER200', 'u', 'Flow meter with connections with diameter of 200mm', 'Flow meter, designation G1600 according to UNE 60510 with connections with diameter of 200mm, 2500m3/h (n), at most, turbine, and located between the pipes.', NULL);
INSERT INTO price_compost VALUES ('N_PUMP-01', 'u', 'Group of water pressure instalations with flow of 50m3/h', 'Group of water pressure instalations with flow of 50m3/h, with minimum pressure of 5bar and maximum 6 bar with 1 pump and 1j ockey pump mounted on bench.', NULL);
INSERT INTO price_compost VALUES ('N_GREVAL110_PN16', 'u', 'Iron irigation head, with hose fitting diameter of 110mm', 'Iron irigation head, with hose fitting diameter of 110mm', 190.3600);
INSERT INTO price_compost VALUES ('N_AIRVAL_DN50', 'u', 'Iron air valve with nominal diameter of 50, nominal pressure of 16 bar', 'Iron air valve with nominal diameter of 50, nominal pressure of 16 bar, high price, mounted in a mini manhole.', NULL);
INSERT INTO price_compost VALUES ('N_CUR30_PVC110', 'u', 'Connection of DN 110mm, on the 30° angle', 'Connection of DN 110mm, on the 30° angle,  with 2 bell unions with with an elastomeric ring for water and counter flange,placed on the trench bottom.
', NULL);
INSERT INTO price_compost VALUES ('N_SOURCE-01', 'u', 'Hydraulic structure intended to derive water', 'Hydraulic structure intended to derive water', 141.0200);
INSERT INTO price_compost VALUES ('N_T63-63-110', 'u', 'PVC dervation of DN 63mm, nominal pressure of 16bar, 90° branches of 63 and 110mm', 'PVC dervation of DN 63mm, nominal pressure of 16bar , with two elastic unions with elastometric ring, 90° branches of 63 and 110mm;placed on the bottom trench.', 33.0000);
INSERT INTO price_compost VALUES ('N_SHTVAL110_PN16', 'u', 'Manual shutofff valve  with thread of nominal diameter 110mm, nominal pressure 16 bar', 'Manual shutofff valve  with thread of nominal diameter 110mm, nominal pressure 16 bar, with iron nodular body cast EN-GJS-500-7 (GGG50) and nodular iron cover EN-GJS-500-7 (GGG50) with epoxy resin coating (250 micres), iron leads+EPDM and elastic closure seatclosing, stainless steel shaft 1.4021 (AISI 420), with iron steering wheel mounted on the surface.', 98.4100);
INSERT INTO price_compost VALUES ('N_SHTVAL160_PN16', 'u', 'Manual shutofff valve  with thread of nominal diameter 160mm, nominal pressure 16 bar', 'Manual shutofff valve  with thread of nominal diameter 160mm, nominal pressure 16 bar, with iron nodular body cast EN-GJS-500-7 (GGG50) and nodular iron cover EN-GJS-500-7 (GGG50) with epoxy resin coating (250 micres), iron leads+EPDM and elastic closure seatclosing, stainless steel shaft 1.4021 (AISI 420), with iron steering wheel mounted on the surface.', 120.3200);
INSERT INTO price_compost VALUES ('N_SHTVAL63_PN16', 'u', 'Manual shutofff valve  with thread of nominal diameter 63mm, nominal pressure 16 bar', 'Manual shutofff valve  with thread of nominal diameter 63mm, nominal pressure 16 bar, with iron nodular body cast EN-GJS-500-7 (GGG50) and nodular iron cover EN-GJS-500-7 (GGG50) with epoxy resin coating (250 micres), iron leads+EPDM and elastic closure seatclosing, stainless steel shaft 1.4021 (AISI 420), with iron steering wheel mounted on the surface.', 75.3200);
INSERT INTO price_compost VALUES ('N_GREVAL50_PN16', 'u', 'Iron irigation head, with hose fitting diameter of 50mm', 'Iron irigation head, with hose fitting diameter of 50mm', 120.4500);
INSERT INTO price_compost VALUES ('N_GREVAL63_PN16', 'u', 'Iron irigation head, with hose fitting diameter of 63mm', 'Iron irigation head, with hose fitting diameter of 63mm', 145.5400);
INSERT INTO price_compost VALUES ('N_OUTVAL-01', 'u', 'Iron automatic outfall valve, with diameter nominal of 150mm', 'Iron automatic outfall valve, with diameter nominal of 150mm, placed on the pipe, with unions and accessories included fully installed.', 340.6300);
INSERT INTO price_compost VALUES ('N_PRESME110_PN16', 'u', 'Glycerine manometer DN-110mm, with stopcock', 'Glycerine manometer DN-110mm, with stopcock, including unions, auxiliary elements and accessories necessary for the operation, mounted on the pipe.', NULL);
INSERT INTO price_compost VALUES ('N_PRESME200_PN16', 'u', 'Glycerine manometer DN-200mm, with stopcock', 'Glycerine manometer DN-200mm, with stopcock, including unions, auxiliary elements and accessories necessary for the operation, mounted on the pipe.', 249.3600);
INSERT INTO price_compost VALUES ('A_FC110_PN10', 'm', 'Polyethylene pipe, with nominal diameter of 110mm, nominal pressure 10bar', 'Polyethylene pipe ,designation PE 100, with nominal diameter of 110mm, nominal pressure 10bar, series SDR 17, UNE-EN 12201-2, welded and placed on trench bottom.', NULL);
INSERT INTO price_compost VALUES ('A_FC160_PN10', 'm', 'Polyethylene pipe, with nominal diameter of 160mm, nominal pressure 10bar', 'Polyethylene pipe ,designation PE 160, with nominal diameter of 110mm, nominal pressure 10bar, series SDR 17, UNE-EN 12201-2, welded and placed on trench bottom.', NULL);
INSERT INTO price_compost VALUES ('A_PEHD110_PN16', 'm', 'Polyethylene pipe, with nominal diameter of 110mm,nominal pressure 16 bar.', 'Polyethylene pipe ,designation PE 100, with nominal diameter of 110mm, nominal pressure 16 bar, series SDR11, UNE-EN 12201-2,welded and placed on trench bottom.', NULL);
INSERT INTO price_compost VALUES ('A_PELD110_PN10', 'm', 'Polyethylene pipe, with nominal diameter of 110mm, nominal pressure 10bar', 'Polyethylene pipe ,designation PE 100, with nominal diameter of 110mm, nominal pressure 10bar, series SDR 17, UNE-EN 12201-2, welded and placed on trench bottom.', NULL);
INSERT INTO price_compost VALUES ('N_WATERWELL-01', 'u', 'Fully equipied construction of waterwell ', 'Fully equipied construction of waterwell ', 6000.0000);
INSERT INTO price_compost VALUES ('N_CHKVAL100_PN10', 'u', 'Check valve with tilting disc check, with diameter nominal 100mm, nominal pressure of 10 bar', 'Check valve with tilting disc check, according to UNE-EN 12334, with flanges, with diameter nominal 100mm, nominal pressure of 10 bar, iron nodular body cast EN-GJS-400-15 (GGG40) and epoxy resin coating (200 micres), iron nodular tilting discs EN-GJS-400-15 (GGG40), elastic closure seatclosing, mounted in a mini manhole. ', 184.2100);
INSERT INTO price_compost VALUES ('N_CHKVAL200_PN10', 'u', 'Check valve with tilting disc check, with diameter nominal 200mm, nominal pressure of 10 bar', 'Check valve with tilting disc check, according to UNE-EN 12334, with flanges, with diameter nominal 200mm, nominal pressure of 10 bar, iron nodular body cast EN-GJS-400-15 (GGG40) and epoxy resin coating (200 micres), iron nodular tilting discs EN-GJS-400-15 (GGG40), elastic closure seatclosing, mounted in a mini manhole. ', NULL);
INSERT INTO price_compost VALUES ('N_CHKVAL300_PN10', 'u', 'Check valve with tilting disc check, with diameter nominal 300mm, nominal pressure of 10 bar', 'Check valve with tilting disc check, according to UNE-EN 12334, with flanges, with diameter nominal 300mm, nominal pressure of 10 bar, iron nodular body cast EN-GJS-400-15 (GGG40) and epoxy resin coating (200 micres), iron nodular tilting discs EN-GJS-400-15 (GGG40), elastic closure seatclosing, mounted in a mini manhole. ', NULL);
INSERT INTO price_compost VALUES ('N_CHKVAL63_PN10', 'u', 'Check valve with tilting disc check, with diameter nominal 63mm, nominal pressure of 10 bar', 'Check valve with tilting disc check, according to UNE-EN 12334, with flanges, with diameter nominal 63mm, nominal pressure of 10 bar, iron nodular body cast EN-GJS-400-15 (GGG40) and epoxy resin coating (200 micres), iron nodular tilting discs EN-GJS-400-15 (GGG40), elastic closure seatclosing, mounted in a mini manhole. ', 95.3500);
INSERT INTO price_compost VALUES ('N_PRVAL100_6/16', 'u', 'Pressure reduction valve with with flanges, diametre nominal 100mm, minimum pressure 16 bar', 'Pressure reduction valve with with flanges, diametre nominal 100mm, minimum pressure 16 bar and with maximum difference of 15 bar, bronze, high price, mounted in a mini manhole.', NULL);
INSERT INTO price_compost VALUES ('N_PRVAL150_6/16', 'u', 'Pressure reduction valve with with flanges, diametre nominal 150mm, minimum pressure 16 bar', 'Pressure reduction valve with with flanges, diametre nominal 150mm, minimum pressure 16 bar and with maximum difference of 15 bar, bronze, high price, mounted in a mini manhole.', NULL);
INSERT INTO price_compost VALUES ('N_PRVAL200_6/16', 'u', 'Pressure reduction valve with with flanges, diametre nominal 200mm, minimum pressure 16 bar', 'Pressure reduction valve with with flanges, diametre nominal 200mm, minimum pressure 16 bar and with maximum difference of 15 bar, bronze, high price, mounted in a mini manhole.', NULL);
INSERT INTO price_compost VALUES ('N_HYD_1x100', 'u', 'Hydrant with output diameter of 100mm.', 'Hydrant buried with mini manhole, with output diameter of 100mm and diameter of pipe connection of 4", placed on the outside.', NULL);
INSERT INTO price_compost VALUES ('N_FILTER-01', 'u', 'Filter strainer with Y-shaped flanges, nominal diameter of 200mm', 'Filter strainer with Y-shaped flanges, nominal diameter of 200mm, nominal pressure of 16bar, gray cast iron EN-GJL-250 (GG25), mesh stainless steel 1.4301 (AISI 304) with perforations of diameter 1,5mm, mounted in a mini manhole.', 1114.2600);
INSERT INTO price_compost VALUES ('N_FLOWMETER110', 'u', 'Flow meter with connections with diameter of 110mm', 'Flow meter, designation G1600 according to UNE 60510 with connections with diameter of 110mm, 650m3/h (n), at most, turbine, and located between the pipes.', NULL);
INSERT INTO price_compost VALUES ('N_JUN160', 'u', 'Flange iron connection of DN 160mm', 'Flange iron connection of DN 160mm with 2 bell unions with with an elastomeric ring for water and counter flange,placed on the trench bottom.
', NULL);
INSERT INTO price_compost VALUES ('N_JUN200', 'u', 'Flange iron connection of DN 200mm', 'Flange iron connection of DN 200mm with 2 bell unions with with an elastomeric ring for water and counter flange,placed on the trench bottom.
', NULL);
INSERT INTO price_compost VALUES ('N_JUN63', 'u', 'Flange iron connection of DN 63mm', 'Flange iron connection of DN 63mm with 2 bell unions with with an elastomeric ring for water and counter flange,placed on the trench bottom.
', NULL);
INSERT INTO price_compost VALUES ('N_CUR45_PVC110', 'u', 'Connection of DN 110mm, on the 45° angle', 'Connection of DN 110mm, on the 45° angle,  with 2 bell unions with with an elastomeric ring for water and counter flange,placed on the trench bottom.
', NULL);
INSERT INTO price_compost VALUES ('N_JUN110', 'u', 'Flange iron connection of DN 110mm', 'Flange iron connection of DN 110mm with 2 bell unions with with an elastomeric ring for water and counter flange,placed on the trench bottom.
', NULL);
INSERT INTO price_compost VALUES ('N_ENDLINE', 'u', 'Cavity plug', 'Cavity plug', 92.5600);
INSERT INTO price_compost VALUES ('N_HYD_1x110-2x63', 'u', 'Hydrant with output diameter of 110 and 63mm.', 'Hydrant buried with mini manhole, with output diameter of 100 and 63mm and diameter of pipe connection of 4", placed on the outside.', 689.3400);
INSERT INTO price_compost VALUES ('P_ASPHALT-10', 'm2', 'Pavement of continuous hot bituminous mix 10cm thick', 'Pavement of continuous hot bituminous mix 10cm thick (6+4), including the base of artificial ballast to 95% of PM, primer and adhesion.', NULL);
INSERT INTO price_compost VALUES ('N_CHKVAL150_PN10', 'u', 'Check valve with tilting disc check, with diameter nominal 150mm, nominal pressure of 10 bar', 'Check valve with tilting disc check, according to UNE-EN 12334, with flanges, with diameter nominal 150mm, nominal pressure of 10 bar, iron nodular body cast EN-GJS-400-15 (GGG40) and epoxy resin coating (200 micres), iron nodular tilting discs EN-GJS-400-15 (GGG40), elastic closure seatclosing, mounted in a mini manhole. ', 312.5200);
INSERT INTO price_compost VALUES ('N_T160-110_PN16', 'u', 'FD derivation of DN 160 mm with 90° branches of 110mm', 'Ductile iron derivation of DN 160 mm with two bell shaped unions with an elastomeric ring for water and counter flange,90° branches of 110mm; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('N_T160-110-63', 'u', 'FD derivation of DN 160 mm with 90° branches of 110 and 63mm', 'Ductile iron derivation of DN 160 mm with two bell shaped unions with an elastomeric ring for water and counter flange,90° branches of 110 and 63mm; placed on the bottom trench.', 201.0000);
INSERT INTO price_compost VALUES ('N_T160-160_PN16', 'u', 'FD derivation of DN 160 mm with 90° branches of 160mm', 'Ductile iron derivation of DN 160 mm with two bell shaped unions with an elastomeric ring for water and counter flange,90° branches of 160mm; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('N_T160-63_PN16', 'u', 'FD derivation of DN 160 mm with 90° branches of 63mm', 'Ductile iron derivation of DN 160 mm with two bell shaped unions with an elastomeric ring for water and counter flange,90° branches of 63mm; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('N_T200-160_PN16', 'u', 'FD derivation of DN 200 mm with 90° branches of 160mm', 'Ductile iron derivation of DN 200 mm with two bell shaped unions with an elastomeric ring for water and counter flange,90° branches of 160mm; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('N_T110-110_PN16', 'u', 'FD derivation DN110mm, 90° branches of 110mm', 'Ductile iron derivation of DN 110 mm with two bell shaped unions with an elastomeric ring for water and counter flange,90° branches of 110mm; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('N_T110-63_PN16', 'u', 'PVC derivation DN110mm, 90° branches of 63mm', 'PVC dervation of DN 110mm, nominal pressure of 16bar , with two elastic unions with elastometric ring, 90° branches of 63mm;placed on the bottom trench.', 35.0000);
INSERT INTO price_compost VALUES ('A_PVC63_PN10', 'm', 'PVC sewer pipe with nominal exterior diameter of 63mm, nominal pressure of 10 bar', 'PVC sewer pipe with nominal exterior diameter of 63mm, nominal pressure of 16 bar, with elastic join and elastomeric ring, according to the UNE-EN 1452-2; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('A_PVC90_PN16', 'm', 'PVC sewer pipe with nominal exterior diameter of 90mm, nominal pressure of 16 bar', 'PVC sewer pipe with nominal exterior diameter of 90mm, nominal pressure of 16 bar, with elastic join and elastomeric ring, according to the UNE-EN 1452-2; placed on the bottom trench.', NULL);
INSERT INTO price_compost VALUES ('N_FLEXUNION', 'u', 'Flexunion, nominal pressure of 10 bar', 'Flexunion, nominal pressure of 10 bar', 15.5000);
INSERT INTO price_compost VALUES ('N_REDUC_110-90', 'u', 'Iron reduction form 110mm to 90mm, nominal pressure of 16 bar', 'Iron reduction form 110mm to 90mm, nominal pressure of 16 bar', 125.1500);
INSERT INTO price_compost VALUES ('N_REDUC_160-90', 'u', 'Iron reduction form 160mm to 90mm, nominal pressure of 16 bar', 'Iron reduction form 160mm to 90mm, nominal pressure of 16 bar', 198.5000);
INSERT INTO price_compost VALUES ('N_REGISTER', 'u', 'Register of 57x57x90cm, of brick and interior batter, with frame and cover of 60x60x5cm of ductile i', 'Register of 57x57x90cm, of brick and interior batter, with frame and cover of 60x60x5cm of ductile i', 155.5000);
INSERT INTO price_compost VALUES ('N_WATER-CONNECT', 'u', 'Connection point of connec', 'Connection point of connec', 135.5000);
INSERT INTO price_compost VALUES ('N_XDN110_PN16', 'u', 'Derivation on T, with diameter nominal 110mm, nominal pressure of 16 bar', 'Derivation on T, with diameter nominal 110mm, nominal pressure of 16 bar', 90.9500);
INSERT INTO price_compost VALUES ('N_XDN110-90_PN16', 'u', 'Derivation on T, with diameter nominal 110mm and 90mm, nominal pressure of 16 bar', 'Derivation on T, with diameter nominal 110mm and 90mm, nominal pressure of 16 bar', 85.3000);
INSERT INTO price_compost VALUES ('A_PVC25_PN10', 'm', 'PVC sewer pipe with nominal exterior diameter of 25mm, nominal pressure of 10 bar', 'PVC sewer pipe with nominal exterior diameter of 25mm, nominal pressure of 10 bar', 8.1500);
INSERT INTO price_compost VALUES ('A_PVC32_PN10', 'm', 'PVC sewer pipe with nominal exterior diameter of 32mm, nominal pressure of 10 bar', 'PVC sewer pipe with nominal exterior diameter of 32mm, nominal pressure of 10 bar', 8.9500);
INSERT INTO price_compost VALUES ('A_PVC50_PN10', 'm', 'PVC sewer pipe with nominal exterior diameter of 50mm, nominal pressure of 10 bar', 'PVC sewer pipe with nominal exterior diameter of 50mm, nominal pressure of 10 bar', 11.4300);
INSERT INTO price_compost VALUES ('N_EXPANTANK', 'u', 'Expansion tank ', 'Expansion tank ', 3950.0000);
INSERT INTO price_compost VALUES ('N_NETSAMPLEP', 'u', 'Network sampling point', 'Network sampling point', 0.0000);
INSERT INTO price_compost VALUES ('N_NETELEMENT', 'u', 'Network element', 'Network element', 0.0000);
INSERT INTO price_compost VALUES ('N_ETAP', 'u', 'Water treatment plant', 'Water treatment plant', 1950000.0000);


INSERT INTO price_cat_simple VALUES ('PRICES DB-2018');


INSERT INTO price_simple VALUES ('GF32H795','PRICES DB-2018','m', 'GF32H795', NULL, 36.5100, NULL);
INSERT INTO price_simple VALUES ('GF32L795','PRICES DB-2018', 'm', 'GF32L795', NULL, 47.6700, NULL);
INSERT INTO price_simple VALUES ('GF3A5955','PRICES DB-2018',  'u', 'GF3A5955', NULL, 156.0200, NULL);
INSERT INTO price_simple VALUES ('GF3A7925','PRICES DB-2018', 'u', 'GF3A7925', NULL, 204.3400, NULL);
INSERT INTO price_simple VALUES ('GF3A7955','PRICES DB-2018', 'u', 'GF3A7955', NULL, 209.0800, NULL);
INSERT INTO price_simple VALUES ('GF3A7975','PRICES DB-2018', 'u', 'GF3A7975', NULL, 210.6700, NULL);
INSERT INTO price_simple VALUES ('GF3A8975','PRICES DB-2018', 'u', 'GF3A8975', NULL, 260.3000, NULL);
INSERT INTO price_simple VALUES ('GFA19585','PRICES DB-2018', 'm', 'GFA19585', NULL, 12.2100, NULL);
INSERT INTO price_simple VALUES ('GFA1E585','PRICES DB-2018', 'm', 'GFA1E585', NULL, 19.4300, NULL);
INSERT INTO price_simple VALUES ('GFA1J585','PRICES DB-2018', 'm', 'GFA1J585', NULL, 27.6400, NULL);
INSERT INTO price_simple VALUES ('GFA1L585','PRICES DB-2018', 'm', 'GFA1L585', NULL, 35.1000, NULL);
INSERT INTO price_simple VALUES ('GFB19425','PRICES DB-2018', 'm', 'GFB19425', NULL, 12.0700, NULL);
INSERT INTO price_simple VALUES ('GFB1E425','PRICES DB-2018', 'm', 'GFB1E425', NULL, 20.0900, NULL);
INSERT INTO price_simple VALUES ('GFB1E625','PRICES DB-2018', 'm', 'GFB1E625', NULL, 22.4400, NULL);
INSERT INTO price_simple VALUES ('GFB1J425','PRICES DB-2018', 'm', 'GFB1J425', NULL, 31.7400, NULL);
INSERT INTO price_simple VALUES ('GJM35BE4','PRICES DB-2018', 'u', 'GJM35BE4', NULL, 192.4000, NULL);
INSERT INTO price_simple VALUES ('GJM6U020','PRICES DB-2018', 'u', 'GJM6U020', NULL, 144.5300, NULL);
INSERT INTO price_simple VALUES ('GK242QA6','PRICES DB-2018', 'u', 'GK242QA6', NULL, 2278.7700, NULL);
INSERT INTO price_simple VALUES ('GK242WK6','PRICES DB-2018', 'u', 'GK242WK6', NULL, 13639.3300, NULL);
INSERT INTO price_simple VALUES ('GF3D18B5','PRICES DB-2018', 'u', 'GF3D18B5', NULL, 235.3200, NULL);
INSERT INTO price_simple VALUES ('GF3D12B5','PRICES DB-2018', 'u', 'GF3D12B5', NULL, 103.0900, NULL);
INSERT INTO price_simple VALUES ('GN8215G4','PRICES DB-2018', 'u', 'GN8215G4', NULL, 556.9300, NULL);
INSERT INTO price_simple VALUES ('GN8215J4','PRICES DB-2018', 'u', 'GN8215J4', NULL, 998.4800, NULL);
INSERT INTO price_simple VALUES ('GN75D324','PRICES DB-2018', 'u', 'GN75D324', NULL, 4417.4800, NULL);
INSERT INTO price_simple VALUES ('GN75F324','PRICES DB-2018', 'u', 'GN75F324', NULL, 6134.3200, NULL);
INSERT INTO price_simple VALUES ('GN75G324','PRICES DB-2018', 'u', 'GN75G324', NULL, 7769.2900, NULL);
INSERT INTO price_simple VALUES ('GNXA6425','PRICES DB-2018', 'u', 'GNXA6425', NULL, 4210.7800, NULL);
INSERT INTO price_simple VALUES ('GM213628','PRICES DB-2018', 'u', 'GM213628', NULL, 501.5200, NULL);
INSERT INTO price_simple VALUES ('GF3D17B5','PRICES DB-2018', 'u', 'GF3D17B5', NULL, 186.0000, NULL);
INSERT INTO price_simple VALUES ('F2225243','PRICES DB-2018', 'm3', 'F2225243', NULL, 9.0324, NULL);
INSERT INTO price_simple VALUES ('F228FB0F','PRICES DB-2018', 'm3', 'F228FB0F', NULL, 8.9241, NULL);
INSERT INTO price_simple VALUES ('F2R5426A','PRICES DB-2018', 'm3', 'F2R5426A', NULL, 8.1164, NULL);
INSERT INTO price_simple VALUES ('F227A00A','PRICES DB-2018', 'm2', 'F227A00A', NULL, 2.5708, NULL);
INSERT INTO price_simple VALUES ('F931201F','PRICES DB-2018', 'm3', 'F931201F', NULL, 29.2250, NULL);
INSERT INTO price_simple VALUES ('F9G1A732','PRICES DB-2018', 'm3', 'F9G1A732', NULL, 105.6413, NULL);
INSERT INTO price_simple VALUES ('F9J12X40','PRICES DB-2018', 'm2', 'F9J12X40', NULL, 0.5221, NULL);
INSERT INTO price_simple VALUES ('F9H118E1','PRICES DB-2018', 't', 'F9H118E1', NULL, 57.3861, NULL);
INSERT INTO price_simple VALUES ('F9J13Y40','PRICES DB-2018', 'm2', 'F9J13Y40', NULL, 0.4334, NULL);
INSERT INTO price_simple VALUES ('F9H11251','PRICES DB-2018', 't', 'F9H11251', NULL, 55.8791, NULL);
INSERT INTO price_simple VALUES ('F9E1311N','PRICES DB-2018', 'm2', 'F9E1311N', NULL, 35.3418, NULL);
INSERT INTO price_simple VALUES ('F9265C51','PRICES DB-2018', 'm3', 'F9265C51', NULL, 87.0445, NULL);
INSERT INTO price_simple VALUES ('GF3D15B5','PRICES DB-2018', 'u', 'GF3D15B5', NULL, 103.0900, NULL);
INSERT INTO price_simple VALUES ('GFA1C585','PRICES DB-2018', 'm', 'GFA1C585', NULL, 17.6600, NULL);


INSERT INTO price_compost_value VALUES (60, 'N_PRESME110_PN16', 'GJM6U020', 1.0000);
INSERT INTO price_compost_value VALUES (45, 'N_CHKVAL200_PN10', 'GN8215G4', 1.0000);
INSERT INTO price_compost_value VALUES (46, 'N_CHKVAL300_PN10', 'GN8215J4', 1.0000);
INSERT INTO price_compost_value VALUES (80, 'N_PRVAL100_6/16', 'GN75D324', 1.0000);
INSERT INTO price_compost_value VALUES (81, 'N_PRVAL150_6/16', 'GN75F324', 1.0000);
INSERT INTO price_compost_value VALUES (82, 'N_PRVAL200_6/16', 'GN75G324', 1.0000);
INSERT INTO price_compost_value VALUES (50, 'N_FLOWMETER200', 'GK242WK6', 1.0000);
INSERT INTO price_compost_value VALUES (51, 'N_FLOWMETER110', 'GK242QA6', 1.0000);
INSERT INTO price_compost_value VALUES (34, 'S_EXC', 'F2225243', 1.0000);
INSERT INTO price_compost_value VALUES (36, 'S_REB', 'F228FB0F', 1.0000);
INSERT INTO price_compost_value VALUES (37, 'S_REP', 'F227A00A', 1.0000);
INSERT INTO price_compost_value VALUES (38, 'S_TRANS', 'F2R5426A', 1.0000);
INSERT INTO price_compost_value VALUES (42, 'P_CONCRETE-20', 'F931201F', 0.2000);
INSERT INTO price_compost_value VALUES (85, 'P_CONCRETE-20', 'F9G1A732', 0.2000);
INSERT INTO price_compost_value VALUES (22, 'P_ASPHALT-10', 'F931201F', 0.2500);
INSERT INTO price_compost_value VALUES (86, 'P_ASPHALT-10', 'F9J12X40', 1.0000);
INSERT INTO price_compost_value VALUES (87, 'P_ASPHALT-10', 'F9H118E1', 0.1440);
INSERT INTO price_compost_value VALUES (56, 'N_JUN160', 'GF3D17B5', 1.0000);
INSERT INTO price_compost_value VALUES (57, 'N_JUN200', 'GF3D18B5', 1.0000);
INSERT INTO price_compost_value VALUES (88, 'P_ASPHALT-10', 'F9J13Y40', 1.0000);
INSERT INTO price_compost_value VALUES (89, 'P_ASPHALT-10', 'F9H11251', 0.0960);
INSERT INTO price_compost_value VALUES (41, 'P_SLAB-4P', 'F9E1311N', 1.0000);
INSERT INTO price_compost_value VALUES (90, 'P_SLAB-4P', 'F9265C51', 0.1000);
INSERT INTO price_compost_value VALUES (58, 'N_JUN63', 'GF3D12B5', 1.0000);
INSERT INTO price_compost_value VALUES (92, 'N_JUN110', 'GF3D15B5', 1.0000);
INSERT INTO price_compost_value VALUES (78, 'N_CUR30_PVC110', 'GF3D15B5', 1.0000);
INSERT INTO price_compost_value VALUES (79, 'N_CUR45_PVC110', 'GF3D15B5', 1.0000);
INSERT INTO price_compost_value VALUES (83, 'N_HYD_1x100', 'GM213628', 1.0000);
INSERT INTO price_compost_value VALUES (26, 'A_FD150', 'GF32H795', 1.0000);
INSERT INTO price_compost_value VALUES (23, 'A_PVC63_PN10', 'GFA19585', 1.0000);
INSERT INTO price_compost_value VALUES (24, 'A_PVC110_PN16', 'GFA1E585', 1.0000);
INSERT INTO price_compost_value VALUES (25, 'A_PVC200_PN16', 'GFA1L585', 1.0000);
INSERT INTO price_compost_value VALUES (27, 'A_FD200', 'GF32L795', 1.0000);
INSERT INTO price_compost_value VALUES (28, 'A_PVC160_PN16', 'GFA1J585', 1.0000);
INSERT INTO price_compost_value VALUES (67, 'N_T110-110_PN16', 'GF3A5955', 1.0000);
INSERT INTO price_compost_value VALUES (68, 'N_T160-110_PN16', 'GF3A7955', 1.0000);
INSERT INTO price_compost_value VALUES (70, 'N_T160-160_PN16', 'GF3A7975', 1.0000);
INSERT INTO price_compost_value VALUES (71, 'N_T160-63_PN16', 'GF3A7925', 1.0000);
INSERT INTO price_compost_value VALUES (72, 'N_T200-160_PN16', 'GF3A8975', 1.0000);
INSERT INTO price_compost_value VALUES (44, 'N_AIRVAL_DN50', 'GJM35BE4', 1.0000);
INSERT INTO price_compost_value VALUES (29, 'A_FC63_PN10', 'GFB19425', 1.0000);
INSERT INTO price_compost_value VALUES (30, 'A_FC110_PN10', 'GFB1E425', 1.0000);
INSERT INTO price_compost_value VALUES (31, 'A_FC160_PN10', 'GFB1J425', 1.0000);
INSERT INTO price_compost_value VALUES (32, 'A_PEHD110_PN16', 'GFB1E625', 1.0000);
INSERT INTO price_compost_value VALUES (33, 'A_PELD110_PN10', 'GFB1E425', 1.0000);
INSERT INTO price_compost_value VALUES (62, 'N_PUMP-01', 'GNXA6425', 1.0000);
INSERT INTO price_compost_value VALUES (1, 'A_PVC90_PN16', 'GFA1C585', 1.0000);