/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/09/30

ALTER TABLE cat_mat_roughness DROP CONSTRAINT IF EXISTS inp_cat_mat_roughness_unique;
ALTER TABLE cat_mat_roughness
  ADD CONSTRAINT cat_mat_roughness_unique UNIQUE(matcat_id, init_age, end_age);

ALTER TABLE cat_mat_roughness DROP CONSTRAINT IF EXISTS inp_cat_mat_roughness_matcat_id_fkey;
ALTER TABLE cat_mat_roughness
  ADD CONSTRAINT cat_mat_roughness_matcat_id_fkey FOREIGN KEY (matcat_id)
      REFERENCES cat_mat_arc (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE cat_mat_roughness DROP CONSTRAINT IF EXISTS inp_cat_mat_roughness_pkey;

ALTER TABLE cat_mat_roughness ADD CONSTRAINT cat_mat_roughness_pkey PRIMARY KEY(id);

-- 2020/01/07
ALTER TABLE om_mincut_cat_type RENAME CONSTRAINT anl_mincut_cat_type_pkey TO om_mincut_cat_type_pkey;
ALTER TABLE om_mincut RENAME CONSTRAINT anl_mincut_result_cat_pkey TO om_mincut_pkey;

ALTER TABLE om_mincut DROP CONSTRAINT IF EXISTS anl_mincut_result_cat_anl_assigned_to_fkey;
ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_assigned_to_fkey FOREIGN KEY (assigned_to)
REFERENCES cat_users (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_mincut DROP CONSTRAINT IF EXISTS anl_mincut_result_cat_feature_type_fkey;
ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_feature_type_fkey FOREIGN KEY (anl_feature_type)
REFERENCES sys_feature_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_mincut DROP CONSTRAINT IF EXISTS anl_mincut_result_cat_mincut_type_fkey;
ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_mincut_type_fkey FOREIGN KEY (mincut_type)
REFERENCES om_mincut_cat_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE om_mincut_arc DROP CONSTRAINT IF EXISTS anl_mincut_result_arc_pkey;
ALTER TABLE om_mincut_arc ADD CONSTRAINT om_mincut_arc_pkey PRIMARY KEY(id);

ALTER TABLE om_mincut_arc DROP CONSTRAINT IF EXISTS anl_mincut_result_arc_result_id_fkey;
ALTER TABLE om_mincut_arc ADD CONSTRAINT om_mincut_arc_result_id_fkey FOREIGN KEY (result_id)
REFERENCES om_mincut (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_mincut_arc DROP CONSTRAINT IF EXISTS anl_mincut_result_arc_unique_result_arc;
ALTER TABLE om_mincut_arc ADD CONSTRAINT om_mincut_arc_unique_result_arc UNIQUE(result_id, arc_id);


ALTER TABLE om_mincut_node DROP CONSTRAINT IF EXISTS anl_mincut_result_node_pkey;
ALTER TABLE om_mincut_node ADD CONSTRAINT om_mincut_node_pkey PRIMARY KEY(id);

ALTER TABLE om_mincut_node DROP CONSTRAINT IF EXISTS anl_mincut_result_node_result_id_fkey;
ALTER TABLE om_mincut_node ADD CONSTRAINT om_mincut_node_result_id_fkey FOREIGN KEY (result_id)
REFERENCES om_mincut (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_mincut_node DROP CONSTRAINT IF EXISTS anl_mincut_result_arc_unique_result_node;
ALTER TABLE om_mincut_node ADD CONSTRAINT om_mincut_node_unique_result_node UNIQUE(result_id, node_id);


ALTER TABLE om_mincut_hydrometer DROP CONSTRAINT IF EXISTS anl_mincut_result_hydrometer_pkey;
ALTER TABLE om_mincut_hydrometer ADD CONSTRAINT om_mincut_hydrometer_pkey PRIMARY KEY(id);

ALTER TABLE om_mincut_hydrometer DROP CONSTRAINT IF EXISTS anl_mincut_result_hydrometer_result_id_fkey;
ALTER TABLE om_mincut_hydrometer ADD CONSTRAINT om_mincut_hydrometer_result_id_fkey FOREIGN KEY (result_id)
REFERENCES om_mincut (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_mincut_hydrometer DROP CONSTRAINT IF EXISTS anl_mincut_result_hydrometer_unique_result_hydrometer;
ALTER TABLE om_mincut_hydrometer ADD CONSTRAINT om_mincut_hydrometer_unique_result_hydrometer UNIQUE(result_id, hydrometer_id);


ALTER TABLE om_mincut_polygon DROP CONSTRAINT IF EXISTS anl_mincut_result_polygon_pkey;
ALTER TABLE om_mincut_polygon ADD CONSTRAINT om_mincut_polygon_pkey PRIMARY KEY(id);

ALTER TABLE om_mincut_polygon DROP CONSTRAINT IF EXISTS anl_mincut_result_polygon_result_id_fkey;
ALTER TABLE om_mincut_polygon ADD CONSTRAINT om_mincut_polygon_result_id_fkey FOREIGN KEY (result_id)
REFERENCES om_mincut (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE om_mincut_valve DROP CONSTRAINT IF EXISTS anl_mincut_result_valve_pkey;
ALTER TABLE om_mincut_valve ADD CONSTRAINT om_mincut_valve_pkey PRIMARY KEY(id);

ALTER TABLE om_mincut_valve DROP CONSTRAINT IF EXISTS anl_mincut_result_valve_result_id_fkey;
ALTER TABLE om_mincut_valve ADD CONSTRAINT om_mincut_valve_result_id_fkey FOREIGN KEY (result_id)
REFERENCES om_mincut (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_mincut_valve DROP CONSTRAINT IF EXISTS anl_mincut_result_valve_unique_result_node;
ALTER TABLE om_mincut_valve ADD CONSTRAINT om_mincut_valve_unique_result_node UNIQUE(result_id, node_id);


ALTER TABLE om_mincut_valve_unaccess DROP CONSTRAINT IF EXISTS anl_mincut_result_valve_unaccess_pkey;
ALTER TABLE om_mincut_valve_unaccess ADD CONSTRAINT om_mincut_valve_unaccess_pkey PRIMARY KEY(id);

ALTER TABLE om_mincut_valve_unaccess DROP CONSTRAINT IF EXISTS anl_mincut_result_valve_unaccess_result_id_fkey;
ALTER TABLE om_mincut_valve_unaccess ADD CONSTRAINT om_mincut_valve_unaccess_result_id_fkey FOREIGN KEY (result_id)
REFERENCES om_mincut (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
