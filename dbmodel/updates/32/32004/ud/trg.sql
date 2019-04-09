/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_vi_xsections INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_xsections  
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_xsections');

CREATE TRIGGER gw_trg_vi_xsections INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_report  
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_report');

CREATE TRIGGER gw_trg_vi_xsections INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_options  
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_options');

CREATE TRIGGER gw_trg_vi_dividers INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_dividers
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_dividers');

CREATE TRIGGER gw_trg_vi_outfalls INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_outfalls
FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_outfalls');

CREATE TRIGGER gw_trg_vi_storage INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_storage
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_storage');

CREATE TRIGGER gw_trg_vi_outlets INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_outlets
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_outlets');

CREATE TRIGGER gw_trg_vi_patterns INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_patterns
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_patterns');

CREATE TRIGGER gw_trg_vi_infiltration INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_infiltration
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_infiltration');

CREATE TRIGGER gw_trg_vi_timeseries INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_timeseries
FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_timeseries');

CREATE TRIGGER gw_trg_vi_raingages INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_raingages
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_raingages');

CREATE TRIGGER gw_trg_vi_lid_controls INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_lid_controls
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_lid_controls');

CREATE TRIGGER gw_trg_vi_snowpacks INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_snowpacks
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_snowpacks');

CREATE TRIGGER gw_trg_vi_hydrographs INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_hydrographs
FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_hydrographs');

CREATE TRIGGER gw_trg_vi_hydrographs INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_controls
FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_controls');

CREATE TRIGGER gw_trg_vi_inflows INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_inflows
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_inflows');

CREATE TRIGGER gw_trg_vi_inflows INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_treatment
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_treatment');

CREATE TRIGGER gw_trg_vi_inflows INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_transects
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_transects');


CREATE TRIGGER gw_trg_vi_inflows INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_temperature
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_temperature');


CREATE TRIGGER gw_trg_vi_inflows INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_evaporation
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_evaporation');