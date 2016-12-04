/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


--Insert demo values on doc tables
SELECT gw_fct_fill_doc_tables();

-- Insert demo values on om tables
SELECT gw_fct_fill_om_tables();


-- ----------------------------
-- Default values of sector selection
-- ----------------------------
INSERT INTO inp_selector_sector VALUES ('sector_01');


-- ----------------------------
-- Default values of plan psector
-- ----------------------------
-- INSERT INTO plan_selector_psector VALUES ('psector_01');