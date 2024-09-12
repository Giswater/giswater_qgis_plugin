/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

alter table doc_x_workcat add constraint unique_doc_id_workcat_id unique (doc_id, workcat_id);

ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;