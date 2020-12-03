/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_junction ON "SCHEMA_NAME".ve_inp_junction;
CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_divider ON "SCHEMA_NAME".ve_inp_divider;
CREATE TRIGGER gw_trg_edit_inp_node_divider INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_divider
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_divider', 'DIVIDER');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_outfall ON "SCHEMA_NAME".ve_inp_outfall;
CREATE TRIGGER gw_trg_edit_inp_node_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_outfall
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_outfall', 'OUTFALL');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_storage ON "SCHEMA_NAME".ve_inp_storage;
CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_storage', 'STORAGE');

DROP TRIGGER IF EXISTS gw_trg_edit_raingage ON "SCHEMA_NAME".ve_raingage;
CREATE TRIGGER gw_trg_edit_raingage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_raingage
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_raingage(raingage);

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_conduit ON "SCHEMA_NAME".ve_inp_conduit;
CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_conduit
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_conduit', 'CONDUIT');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_pump ON "SCHEMA_NAME".ve_inp_pump;
CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_pump
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_pump', 'PUMP');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_orifice ON "SCHEMA_NAME".ve_inp_orifice;
CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_orifice
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_orifice', 'ORIFICE');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_outlet ON "SCHEMA_NAME".ve_inp_outlet;
CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_outlet
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_outlet', 'OUTLET');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_weir ON "SCHEMA_NAME".ve_inp_weir;
CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_weir
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_weir', 'WEIR');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_virtual ON "SCHEMA_NAME".ve_inp_virtual;
CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_virtual
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_virtual', 'VIRTUAL');   


-- trigger deleted on 3.4.010
--DROP TRIGGER IF EXISTS gw_trg_edit_subcatchment ON "SCHEMA_NAME".ve_subcatchment;
--CREATE TRIGGER gw_trg_edit_subcatchment INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_subcatchment
--FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_subcatchment(subcatchment);

DROP TRIGGER IF EXISTS gw_trg_vi_coordinates ON SCHEMA_NAME.vi_coordinates;
CREATE TRIGGER gw_trg_vi_coordinates INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_coordinates FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_coordinates');

DROP TRIGGER IF EXISTS gw_trg_vi_options ON SCHEMA_NAME.vi_options;
CREATE TRIGGER gw_trg_vi_options INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_options FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_options');

DROP TRIGGER IF EXISTS gw_trg_vi_report ON SCHEMA_NAME.vi_report;
CREATE TRIGGER gw_trg_vi_report INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_report FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_report');

DROP TRIGGER IF EXISTS gw_trg_vi_files ON SCHEMA_NAME.vi_files;
CREATE TRIGGER gw_trg_vi_files INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_files FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_files');

DROP TRIGGER IF EXISTS gw_trg_vi_evaporation ON SCHEMA_NAME.vi_evaporation;
CREATE TRIGGER gw_trg_vi_evaporation INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_evaporation FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_evaporation');

DROP TRIGGER IF EXISTS gw_trg_vi_raingages ON SCHEMA_NAME.vi_raingages;
CREATE TRIGGER gw_trg_vi_raingages INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_raingages FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_raingages');

DROP TRIGGER IF EXISTS gw_trg_vi_temperature ON SCHEMA_NAME.vi_temperature;
CREATE TRIGGER gw_trg_vi_temperature INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_temperature FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_temperature');

DROP TRIGGER IF EXISTS gw_trg_vi_subcatchments ON SCHEMA_NAME.vi_subcatchments;
CREATE TRIGGER gw_trg_vi_subcatchments INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_subcatchments FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_subcatchments');

DROP TRIGGER IF EXISTS gw_trg_vi_subareas ON SCHEMA_NAME.vi_subareas;
CREATE TRIGGER gw_trg_vi_subareas INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_subareas FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_subareas');

DROP TRIGGER IF EXISTS gw_trg_vi_infiltration ON SCHEMA_NAME.vi_infiltration;
CREATE TRIGGER gw_trg_vi_infiltration INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_infiltration FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_infiltration');

DROP TRIGGER IF EXISTS gw_trg_vi_aquifers ON SCHEMA_NAME.vi_aquifers;
CREATE TRIGGER gw_trg_vi_aquifers INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_aquifers FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_aquifers');

DROP TRIGGER IF EXISTS gw_trg_vi_groundwater ON SCHEMA_NAME.vi_groundwater;
CREATE TRIGGER gw_trg_vi_groundwater INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_groundwater FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_groundwater');

DROP TRIGGER IF EXISTS gw_trg_vi_snowpacks ON SCHEMA_NAME.vi_snowpacks;
CREATE TRIGGER gw_trg_vi_snowpacks INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_snowpacks FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_snowpacks');

DROP TRIGGER IF EXISTS gw_trg_vi_gwf ON SCHEMA_NAME.vi_gwf;
CREATE TRIGGER gw_trg_vi_gwf INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_gwf FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_gwf');

DROP TRIGGER IF EXISTS gw_trg_vi_snowpacks ON SCHEMA_NAME.vi_snowpacks;
CREATE TRIGGER gw_trg_vi_snowpacks INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_snowpacks FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_snowpacks');

DROP TRIGGER IF EXISTS gw_trg_vi_junction ON SCHEMA_NAME.vi_junction;
CREATE TRIGGER gw_trg_vi_junction INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_junction FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_junction');

DROP TRIGGER IF EXISTS gw_trg_vi_outfalls ON SCHEMA_NAME.vi_outfalls;
CREATE TRIGGER gw_trg_vi_outfalls INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_outfalls FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_outfalls');

DROP TRIGGER IF EXISTS gw_trg_vi_dividers ON SCHEMA_NAME.vi_dividers;
CREATE TRIGGER gw_trg_vi_dividers INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_dividers FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_dividers');

DROP TRIGGER IF EXISTS gw_trg_vi_storage ON SCHEMA_NAME.vi_storage;
CREATE TRIGGER gw_trg_vi_storage INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_storage FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_storage');

DROP TRIGGER IF EXISTS gw_trg_vi_conduits ON SCHEMA_NAME.vi_conduits;
CREATE TRIGGER gw_trg_vi_conduits INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_conduits FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_conduits');

DROP TRIGGER IF EXISTS gw_trg_vi_pumps ON SCHEMA_NAME.vi_pumps;
CREATE TRIGGER gw_trg_vi_pumps INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_pumps FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_pumps');

DROP TRIGGER IF EXISTS gw_trg_vi_orifices ON SCHEMA_NAME.vi_orifices;
CREATE TRIGGER gw_trg_vi_orifices INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_orifices FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_orifices');

DROP TRIGGER IF EXISTS gw_trg_vi_weirs ON SCHEMA_NAME.vi_weirs;
CREATE TRIGGER gw_trg_vi_weirs INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_weirs FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_weirs');

DROP TRIGGER IF EXISTS gw_trg_vi_outlets ON SCHEMA_NAME.vi_outlets;
CREATE TRIGGER gw_trg_vi_outlets INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_outlets FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_outlets');

DROP TRIGGER IF EXISTS gw_trg_vi_xsections ON SCHEMA_NAME.vi_xsections;
CREATE TRIGGER gw_trg_vi_xsections INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_xsections FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_xsections');

DROP TRIGGER IF EXISTS gw_trg_vi_losses ON SCHEMA_NAME.vi_losses;
CREATE TRIGGER gw_trg_vi_losses INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_losses FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_losses');

DROP TRIGGER IF EXISTS gw_trg_vi_transects ON SCHEMA_NAME.vi_transects;
CREATE TRIGGER gw_trg_vi_transects INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_transects FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_transects');

DROP TRIGGER IF EXISTS gw_trg_vi_controls ON SCHEMA_NAME.vi_controls;
CREATE TRIGGER gw_trg_vi_controls INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_controls FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_controls');

DROP TRIGGER IF EXISTS gw_trg_vi_coverages ON SCHEMA_NAME.vi_coverages;
CREATE TRIGGER gw_trg_vi_coverages INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_coverages FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_coverages');

DROP TRIGGER IF EXISTS gw_trg_vi_buildup ON SCHEMA_NAME.vi_buildup;
CREATE TRIGGER gw_trg_vi_buildup INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_buildup FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_buildup');

DROP TRIGGER IF EXISTS gw_trg_vi_washoff ON SCHEMA_NAME.vi_washoff;
CREATE TRIGGER gw_trg_vi_washoff INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_washoff FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_washoff');

DROP TRIGGER IF EXISTS gw_trg_vi_treatment ON SCHEMA_NAME.vi_treatment;
CREATE TRIGGER gw_trg_vi_treatment INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_treatment FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_treatment');

DROP TRIGGER IF EXISTS gw_trg_vi_dwf ON SCHEMA_NAME.vi_dwf;
CREATE TRIGGER gw_trg_vi_dwf INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_dwf FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_dwf');

DROP TRIGGER IF EXISTS gw_trg_vi_rdii ON SCHEMA_NAME.vi_rdii;
CREATE TRIGGER gw_trg_vi_rdii INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_rdii FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_rdii');

DROP TRIGGER IF EXISTS gw_trg_vi_patterns ON SCHEMA_NAME.vi_patterns;
CREATE TRIGGER gw_trg_vi_patterns INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_patterns FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_patterns');

DROP TRIGGER IF EXISTS gw_trg_vi_loadings ON SCHEMA_NAME.vi_loadings;
CREATE TRIGGER gw_trg_vi_loadings INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_loadings FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_loadings');

DROP TRIGGER IF EXISTS gw_trg_vi_hydrographs ON SCHEMA_NAME.vi_hydrographs;
CREATE TRIGGER gw_trg_vi_hydrographs INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_hydrographs FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_hydrographs');

DROP TRIGGER IF EXISTS gw_trg_vi_curves ON SCHEMA_NAME.vi_curves;
CREATE TRIGGER gw_trg_vi_curves INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_curves FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_curves');

DROP TRIGGER IF EXISTS gw_trg_vi_timeseries ON SCHEMA_NAME.vi_timeseries;
CREATE TRIGGER gw_trg_vi_timeseries INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_timeseries FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_timeseries');

DROP TRIGGER IF EXISTS gw_trg_vi_lid_controls ON SCHEMA_NAME.vi_lid_controls;
CREATE TRIGGER gw_trg_vi_lid_controls INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_lid_controls FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_lid_controls');

DROP TRIGGER IF EXISTS gw_trg_vi_lid_usage ON SCHEMA_NAME.vi_lid_usage;
CREATE TRIGGER gw_trg_vi_lid_usage INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_lid_usage FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_lid_usage');

DROP TRIGGER IF EXISTS gw_trg_vi_adjustments ON SCHEMA_NAME.vi_adjustments;
CREATE TRIGGER gw_trg_vi_adjustments INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_adjustments FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_adjustments');

DROP TRIGGER IF EXISTS gw_trg_vi_map ON SCHEMA_NAME.vi_map;
CREATE TRIGGER gw_trg_vi_map INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_map FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_map');

DROP TRIGGER IF EXISTS gw_trg_vi_backdrop ON SCHEMA_NAME.vi_backdrop;
CREATE TRIGGER gw_trg_vi_backdrop INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_backdrop FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_backdrop');

DROP TRIGGER IF EXISTS gw_trg_vi_symbols ON SCHEMA_NAME.vi_symbols;
CREATE TRIGGER gw_trg_vi_symbols INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_symbols FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_symbols');

DROP TRIGGER IF EXISTS gw_trg_vi_labels ON SCHEMA_NAME.vi_labels;
CREATE TRIGGER gw_trg_vi_labels INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_labels FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_labels');

DROP TRIGGER IF EXISTS gw_trg_vi_inflows ON SCHEMA_NAME.vi_inflows;
CREATE TRIGGER gw_trg_vi_inflows INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_inflows FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_inflows');

DROP TRIGGER IF EXISTS gw_trg_vi_coordinates ON SCHEMA_NAME.vi_coordinates;
CREATE TRIGGER gw_trg_vi_coordinates INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_coordinates FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_coordinates');

DROP TRIGGER IF EXISTS gw_trg_vi_vertices ON SCHEMA_NAME.vi_vertices;
CREATE TRIGGER gw_trg_vi_vertices INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_vertices FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_vertices');

DROP TRIGGER IF EXISTS gw_trg_vi_polygons ON SCHEMA_NAME.vi_polygons;
CREATE TRIGGER gw_trg_vi_polygons INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_polygons FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_polygons');