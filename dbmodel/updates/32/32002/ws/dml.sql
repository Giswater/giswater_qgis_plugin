/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



INSERT INTO audit_cat_table VALUES ('vi_patterns', 'Hydraulic input data', 'Used to export to EPANET information about time patterns.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_coordinates', 'Hydraulic input data', 'Used to export to EPANET informations about coordinates', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_demands', 'Hydraulic input data', 'Used to export to EPANET the information about node''s demand', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_curves', 'Hydraulic input data', 'Used to export to EPANET the information about definition of the curve', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_controls', 'Hydraulic input data', 'Used to export to EPANET information about controls that modify links based on a single condition.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_backdrop', 'Hydraulic input data', 'Used to export to EPANET information about backdrop images and dimensions for the network EPANET map.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_reactions', 'Hydraulic input data', 'Used to export to EPANET information about parameters related to chemical reactions occurring in the network.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_valves', 'Hydraulic input data', 'Used to export to EPANET the information about the valves', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_title', 'Hydraulic input data', 'Used to export to EPANET information about the project.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_times', 'Hydraulic input data', 'Used to export to EPANET the information about weather parameters', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_tanks', 'Hydraulic input data', 'Used to export to EPANET the information about node type tank', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_tags', 'Hydraulic input data', 'Used to export to EPANET information about tags with specific nodes and links on EPANET user inferface.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_status', 'Hydraulic input data', 'Used to export to EPANET the information about the pipelines'' state', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_sources', 'Hydraulic input data', 'Used to export to EPANET the information about contamination sources', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_rules', 'Hydraulic input data', 'Used to export to EPANET the information about the control rules.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_reservoirs', 'Hydraulic input data', 'Used to export to EPANET the information about node type reservoir', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_report', 'Hydraulic input data', 'Used to export to EPANET the information about the output simulation report.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_quality', 'Hydraulic input data', 'Used to export to EPANET information about the output report produced from ma simulation.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_pumps', 'Hydraulic input data', 'Used to export to EPANET the information about node type pump', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_pipes', 'Hydraulic input data', 'Used to export to EPANET the information about arc type pipe.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_options', 'Hydraulic input data', 'Used to export to EPANET the general information with the simulation options', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_mixing', 'Hydraulic input data', 'Used to export to EPANET the information about mixing type inside tanks', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_labels', 'Hydraulic input data', 'Used to export to EPANET the information about coordinates of map labels on EPANET', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_junctions', 'Hydraulic input data', 'Used to export to EPANET the information about node type junction', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_energy', 'Hydraulic input data', 'Used to export to EPANET the information about global energy elements', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_emitters', 'Hydraulic input data', 'Used to export to EPANET the information about transmitters', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_vertices', 'Hydraulic input data', 'Used to export to EPANET the information about the pipelines'' vertexes geometry', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);


INSERT INTO inp_arc_type VALUES ('VALVE');
INSERT INTO inp_arc_type VALUES ('PUMP');