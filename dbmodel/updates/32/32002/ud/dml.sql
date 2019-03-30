/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



INSERT INTO audit_cat_table VALUES ('rpt_warning_summary','Hydraulic result data', 'Used to store swmm warning results', 'role_epa', 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_coordinates', 'Hydraulic input data', 'Used to export to SWMM the information about coordinates', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_xsections', 'Hydraulic input data', 'Used to export to SWMM the information about xsections', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_polygons', 'Hydraulic input data', 'Used to export to SWMM information about polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_subareas', 'Hydraulic input data', 'Used to export to SWMM information about subareas', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_title', 'Hydraulic input data', 'Used to export to SWMM information about project', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_symbols', 'Hydraulic input data', 'Used to export to SWMM informationa about symbols', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_evaporation', 'Hydraulic input data', 'Used to export to SWMM the information about the evaporation with the constant format type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_hydrographs', 'Hydraulic input data', 'Used to export to SWMM information about inp_hydrograph', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_patterns', 'Hydraulic input data', 'Used to export to SWMM the daily time pattern', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_temperature', 'Hydraulic input data', 'Used to export to SWMM the information about the temperature data of the project (if user has defined it)', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_lid_controls', 'Hydraulic input data', 'Used to export to SWMM the information about LID controls', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_snowpacks', 'Hydraulic input data', 'Used to export to SWMM the information about snow layer', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_files', 'Hydraulic input data', 'Used to export to SWMM information about the work files of SWMM', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_groundwater', 'Hydraulic input data', 'Used to export to SWMM the information about groundwaters', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_infiltration', 'Hydraulic input data', 'Used to export to SWMM the information about the infiltration using Curve-Number method', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_gwf', 'Hydraulic input data', 'Used to export to SWMM the information about gwf', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_dividers', 'Hydraulic input data', 'Used to export to SWMM the information about dividers type tabular', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_controls', 'Hydraulic input data', 'Used to export to SWMM information about controls that modify links based on a single condition.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_coverages', 'Hydraulic input data', 'Used to export to SWMM the information about the relation between subcatchments and landuses', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_curves', 'Hydraulic input data', 'Used to export to SWMM the information about definition of the curve', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_dwf', 'Hydraulic input data', 'Used to export to SWMM the information about flow during the dry period', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_conduits', 'Hydraulic input data', 'Used to export to SWMM the information about special conduits', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_buildup', 'Hydraulic input data', 'Used to export to SWMM the information about velocity of the pollutants that accumulate on the surface', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_backdrop', 'Hydraulic input data', 'Used to export to SWMM information about backdrop images and dimensions for the network SWMM map.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_adjustments', 'Hydraulic input data', 'Used to export to SWMM information about adjustments', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_aquifers', 'Hydraulic input data', 'Used to export to SWMM information about aquifers', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_pollutants', 'Hydraulic input data', 'Used to export to SWMM information about the pollutant', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_labels', 'Hydraulic input data', 'Used to export to SWMM the information about coordinates of map labels on SWMM', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_storage', 'Hydraulic input data', 'Used to export to SWMM the information about the reservoirs', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_timeseries', 'Hydraulic input data', 'Used to export to SWMM the information about time series with absolute type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_transects', 'Hydraulic input data', 'Used to export to SWMM the information about transects', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_treatment', 'Hydraulic input data', 'Used to export to SWMM the information about the treatment of deposits', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_washoff', 'Hydraulic input data', 'Used to export to SWMM the information about the washoff.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_weirs', 'Hydraulic input data', 'Used to export to SWMM the information about arcs type weir', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_pumps', 'Hydraulic input data', 'Used to export to SWMM the information about node type pump', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_rdii', 'Hydraulic input data', 'Used to export to SWMM the information about rainfall-dependent infiltration/inflow (RDII).', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_report', 'Hydraulic input data', 'Used to export to SWMM the information about the output simulation report.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_raingage', 'Hydraulic input data', 'Used to export to SWMM the information about the raingage', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_options', 'Hydraulic input data', 'Used to export to SWMM the general information with the simulation options', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_subcatchments', 'Hydraulic input data', 'Used to export to SWMM the information about the poligons with subcatchment type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_vertices', 'Hydraulic input data', 'Used to export to SWMM the information about the pipelines'' vertexes geometry', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_outfalls', 'Hydraulic input data', 'Used to export to SWMM the information about outfalls with fixed format type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_outlets', 'Hydraulic input data', 'Used to export to SWMM the information about outlet with tabular/head format type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_orifices', 'Hydraulic input data', 'Show the information about arcs type orifice', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_map', 'Hydraulic input data', 'Used to export to SWMM the information about map units', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_losses', 'Hydraulic input data', 'Used to export to SWMM the information about the coefficiency of losses and conduits behaviour', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_loadings', 'Hydraulic input data', 'Used to export to SWMM the information about loadings.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_lid_usage', 'Hydraulic input data', 'Used to export to SWMM the information about LID usage.', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_landuses', 'Hydraulic input data', 'Used to export to SWMM the information about land use', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_junctions', 'Hydraulic input data', 'Used to export to SWMM the information about node type junction', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('vi_inflows', 'Hydraulic input data', 'Used to export to SWMM the information about the inflows related in terms of pollutants to nodes (if the user has defined it)', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, false);

