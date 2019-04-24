
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


ALTER TABLE inp_rules_x_sector ADD CONSTRAINT inp_rules_x_sector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector (sector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

--ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_energyparam_fkey FOREIGN KEY (energyparam) REFERENCES inp_typevalue (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE inp_pump_importinp ADD CONSTRAINT inp_pump_importinp_energyparam_fkey FOREIGN KEY (energyparam) REFERENCES inp_typevalue (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_energyparam_fkey FOREIGN KEY (energyparam) REFERENCES inp_typevalue (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE inp_pipe ADD CONSTRAINT inp_pipe_energyparam_fkey FOREIGN KEY (reactionparam) REFERENCES inp_typevalue (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;