/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 26/03/2024
ALTER TABLE man_addfields_value RENAME TO _man_addfields_value_;

DROP FUNCTION IF EXISTS gw_fct_admin_manage_fix_i18n_36008;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_table", "column":"geom_multicurve", "dataType":"geometry(MULTICURVE, SRID_VALUE)"}}$$);

-- 15/05/2024
ALTER TABLE sys_addfields ADD COLUMN feature_type text;
ALTER TABLE sys_addfields ADD CONSTRAINT sys_feature_type_check CHECK ((feature_type = ANY (ARRAY[('ALL'::character varying)::text, ('NODE'::character varying)::text, ('ARC'::character varying)::text, ('CONNEC'::character varying)::text, ('GULLY'::character varying)::text, ('LINK'::character varying)::text, ('CHILD'::character varying)::text])));
