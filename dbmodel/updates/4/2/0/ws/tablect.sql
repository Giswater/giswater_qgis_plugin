/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE element DROP CONSTRAINT IF EXISTS element_epa_type_check;
ALTER TABLE "element" ADD CONSTRAINT element_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['FRPUMP'::text, 'FRVALVE'::text, 'UNDEFINED'::text, 'FRSHORTPIPE'::text])));

-- 31/07/2025
ALTER TABLE "element" ADD CONSTRAINT element_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id);
ALTER TABLE man_frelem ADD CONSTRAINT man_frelem_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id);

ALTER TABLE rpt_arc_stats ADD CONSTRAINT rpt_arc_stats_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;

-- 06/08/2025
ALTER TABLE om_waterbalance_dma_graph ADD CONSTRAINT om_waterbalance_dma_graph_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE arc ADD CONSTRAINT arc_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id);
ALTER TABLE connec ADD CONSTRAINT connec_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id);
ALTER TABLE node ADD CONSTRAINT node_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id);
ALTER TABLE "element" ADD CONSTRAINT element_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id);

ALTER TABLE arc ADD CONSTRAINT arc_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id);
ALTER TABLE connec ADD CONSTRAINT connec_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id);
ALTER TABLE node ADD CONSTRAINT node_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id);
ALTER TABLE "element" ADD CONSTRAINT element_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id);