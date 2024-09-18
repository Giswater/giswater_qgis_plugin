/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 20/12/2023
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_cat", "column":"feature_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_cat", "column":"alias", "dataType":"text"}}$$);

--22/01/23
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"plot_code", "dataType":"varchar"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"plot_code", "dataType":"varchar"}}$$);

--24/01/23
CREATE TABLE selector_period(
  period_id text NOT NULL,
  cur_user text NOT NULL DEFAULT CURRENT_USER,
  CONSTRAINT selector_period_pkey PRIMARY KEY (period_id, cur_user),
  CONSTRAINT selector_period_id_fkey FOREIGN KEY (period_id)
      REFERENCES ext_cat_period (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);
      
ALTER TABLE anl_node ALTER COLUMN node_id DROP DEFAULT;

--18/09/24
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"uncertain", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"muni_id", "dataType":"integer"}}$$);
