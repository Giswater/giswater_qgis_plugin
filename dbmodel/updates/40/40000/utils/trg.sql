/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 18/10/2024
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON man_type_category FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_category');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON man_type_fluid FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_fluid');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON man_type_function FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_function');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON man_type_location FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_location');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON cat_brand FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('cat_brand');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON cat_brand_model FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('cat_brand_model');

-- 12/11/2024
CREATE TRIGGER gw_trg_edit_config_addfields INSTEAD OF UPDATE ON
ve_config_addfields FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_config_addfields();

CREATE TRIGGER gw_trg_edit_config_sysfields INSTEAD OF UPDATE ON ve_config_sysfields
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_config_sysfields();


-- 19/11/2024
CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT
    ON
    arc FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER
UPDATE
    OF function_type,
    category_type,
    fluid_type,
    location_type ON
    arc FOR EACH ROW
    WHEN (((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
    OR ((OLD.category_type)::TEXT IS DISTINCT FROM (NEW.category_type)::TEXT)
    OR ((OLD.fluid_type)::TEXT IS DISTINCT FROM (NEW.fluid_type)::TEXT)
    OR ((OLD.location_type)::TEXT IS DISTINCT FROM (NEW.location_type)::TEXT))
    EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');


CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT
    ON
    node FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('node');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER
UPDATE
    OF function_type,
    category_type,
    fluid_type,
    location_type ON
    node FOR EACH ROW
    WHEN (((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
    OR ((OLD.category_type)::TEXT IS DISTINCT FROM (NEW.category_type)::TEXT)
    OR ((OLD.fluid_type)::TEXT IS DISTINCT FROM (NEW.fluid_type)::TEXT)
    OR ((OLD.location_type)::TEXT IS DISTINCT FROM (NEW.location_type)::TEXT))
    EXECUTE FUNCTION gw_trg_mantypevalue_fk('node');


CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT
    ON
    connec FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('connec');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER
UPDATE
    OF function_type,
    category_type,
    fluid_type,
    location_type ON
    connec FOR EACH ROW
    WHEN (((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
    OR ((OLD.category_type)::TEXT IS DISTINCT FROM (NEW.category_type)::TEXT)
    OR ((OLD.fluid_type)::TEXT IS DISTINCT FROM (NEW.fluid_type)::TEXT)
    OR ((OLD.location_type)::TEXT IS DISTINCT FROM (NEW.location_type)::TEXT))
    EXECUTE FUNCTION gw_trg_mantypevalue_fk('connec');

-- 04/12/2024
CREATE TRIGGER gw_trg_doc BEFORE INSERT OR UPDATE ON doc
FOR EACH ROW EXECUTE FUNCTION gw_trg_doc();


-- 05/12/2024
CREATE TRIGGER gw_trg_edit_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_psector('plan');

CREATE TRIGGER gw_trg_ui_plan_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_plan_psector();

-- 12/12/2024
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON cat_material
FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('cat_material');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('arc');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_arc
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('arc');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('node');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_node
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('node');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('connec');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_connec
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('connec');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('element');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_element
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('element');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('sector_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON macrosector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrosector_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('dma_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON macrodma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrodma_id');

CREATE TRIGGER gw_trg_edit_psector_x_other INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_plan_psector_x_other FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_psector_x_other('plan');

-- 11/03/2025
DROP TRIGGER gw_trg_cat_manager ON cat_manager;

CREATE TRIGGER gw_trg_om_visit AFTER INSERT ON om_visit_x_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit('link');

CREATE TRIGGER gw_trg_ui_doc_x_link INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('link');
