/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE om_visit_lot_x_gully DROP CONSTRAINT IF EXISTS om_visit_lot_x_gully_lot_id_fkey;
ALTER TABLE om_visit_lot_x_gully ADD CONSTRAINT om_visit_lot_x_gully_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE cat_grate DROP CONSTRAINT cat_grate_matcat_id_fkey;

ALTER TABLE cat_grate  ADD CONSTRAINT cat_grate_matcat_id_fkey FOREIGN KEY (matcat_id)
REFERENCES cat_mat_grate (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully ADD CONSTRAINT gully_pjoint_type_fkey FOREIGN KEY (pjoint_type)
REFERENCES sys_feature_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_connec ADD CONSTRAINT cat_connec_cost_ut_fkey FOREIGN KEY (cost_ut) 
REFERENCES price_compost (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE cat_connec ADD CONSTRAINT cat_connec_cost_ml_fkey FOREIGN KEY (cost_ml) 
REFERENCES price_compost (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE cat_connec ADD CONSTRAINT cat_connec_cost_m3_fkey FOREIGN KEY (cost_m3) 
REFERENCES price_compost (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE cat_grate ADD CONSTRAINT cat_connec_cost_ut_fkey FOREIGN KEY (cost_ut) 
REFERENCES price_compost (id) ON DELETE CASCADE ON UPDATE CASCADE;