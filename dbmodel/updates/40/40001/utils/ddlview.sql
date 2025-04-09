/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS vp_basic_arc;
DROP VIEW IF EXISTS vp_basic_node;
DROP VIEW IF EXISTS vp_basic_connec;
DROP VIEW IF EXISTS vp_basic_gully;
DROP VIEW IF EXISTS v_edit_exploitation;
DROP VIEW IF EXISTS v_edit_macrodqa;
DROP VIEW IF EXISTS v_edit_macrodma;
DROP VIEW IF EXISTS v_edit_macrosector;
DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS v_ui_sector;

CREATE OR REPLACE VIEW v_edit_cat_feature_link
AS SELECT cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature.code_autofill,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_link USING (id);