/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE INDEX connec_plot_code ON connec USING btree (code);
ALTER TABLE connec ADD CONSTRAINT connec_plot_id_fkey FOREIGN KEY (plot_id) REFERENCES ext_plot(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_feature_node ALTER COLUMN graph_delimiter SET DEFAULT '{NONE}';

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON link
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');