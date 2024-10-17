/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Recreate the constraints that were previously deleted
ALTER TABLE arc ADD CONSTRAINT arc_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node ADD CONSTRAINT node_nodecat_id_fkey FOREIGN KEY (nodecat_id) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec ADD CONSTRAINT connec_connecat_id_fkey FOREIGN KEY (connecat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_private_connecat_id_fkey FOREIGN KEY (private_connecat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_connec_arccat_id_fkey FOREIGN KEY (connec_arccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_connecat_id_fkey FOREIGN KEY (connecat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully ADD CONSTRAINT gully_gratecat2_id_fkey FOREIGN KEY (gratecat2_id) REFERENCES cat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_gratecat_id_fkey FOREIGN KEY (gratecat_id) REFERENCES cat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gratecat2_id_fkey FOREIGN KEY (gratecat2_id) REFERENCES cat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gratecat_id_fkey FOREIGN KEY (gratecat_id) REFERENCES cat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;
