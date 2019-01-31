/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE  om_visit_class_x_parameter  DROP CONSTRAINT IF EXISTS om_visit_class_x_parameter_class_fkey;
ALTER TABLE  om_visit_class_x_parameter DROP CONSTRAINT IF EXISTS om_visit_class_x_parameter_parameter_fkey;
ALTER TABLE  om_visit_file DROP CONSTRAINT IF EXISTS om_visit_file_visit_id_fkey;
ALTER TABLE  selector_lot DROP CONSTRAINT IF EXISTS selector_workcat_workcat_id_fkey;

ALTER TABLE ONLY om_visit_class_x_parameter ADD CONSTRAINT om_visit_class_x_parameter_class_fkey 
FOREIGN KEY (class_id) REFERENCES om_visit_class(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY om_visit_class_x_parameter ADD CONSTRAINT om_visit_class_x_parameter_parameter_fkey 
FOREIGN KEY (parameter_id) REFERENCES om_visit_parameter(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY om_visit_file ADD CONSTRAINT om_visit_file_visit_id_fkey 
FOREIGN KEY (visit_id) REFERENCES om_visit (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE selector_lot ADD CONSTRAINT selector_workcat_workcat_id_fkey 
FOREIGN KEY (lot_id) REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_file ADD CONSTRAINT selector_workcat_workcat_id_fkey 
FOREIGN KEY (filetype, fextension) REFERENCES om_visit_lot (filetype, fextension) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
