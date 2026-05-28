/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_other", "column":"the_geom", "dataType":"geometry(POINT, SRID_VALUE)"}}$$);

CREATE OR REPLACE VIEW v_edit_plan_psector_x_other
AS SELECT plan_psector_x_other.id,
    plan_psector_x_other.psector_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    rpad(v_price_compost.descript::text, 125) AS price_descript,
    v_price_compost.price,
    plan_psector_x_other.measurement,
    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget,
    plan_psector_x_other.observ,
    plan_psector.atlas_id,
    plan_psector_x_other.the_geom
   FROM plan_psector_x_other
     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_other.psector_id
  ORDER BY plan_psector_x_other.psector_id;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3256, 'It is not possible to upgrade the arc to state planified because it has operative gullies associated', NULL, 2, true, 'utils', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3254, 'It is not possible to upgrade the arc to state planified because it has operative connecs associated', NULL, 2, true, 'utils', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3258, 'It is not possible to upgrade the node to state planified because node has operative arcs associated', NULL, 2, true, 'utils', 'core') ON CONFLICT DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
SELECT SUBSTRING(formname FROM 8) AS formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
WHERE formname like 'v_edit_inp_dscenario_%' and formname not like 'v_edit_inp_dscenario_flwreg_%'
ON CONFLICT DO NOTHING;

UPDATE config_form_fields
	SET layoutorder=1
	WHERE formname in ('inp_dscenario_controls', 'inp_dscenario_rules') AND columnname='id';
UPDATE config_form_fields
	SET layoutorder=2
	WHERE formname in ('inp_dscenario_controls', 'inp_dscenario_rules') AND columnname='dscenario_id';
UPDATE config_form_fields
	SET layoutorder=3
	WHERE formname in ('inp_dscenario_controls', 'inp_dscenario_rules') AND columnname='sector_id';

UPDATE sys_function SET descript='NO input parameters needed.
The function allows the possibility to find errors and data inconsistency for prices checking catalog elements.' WHERE id=2436 and function_name='gw_fct_plan_check_data';

INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('graphdelimiter_type', 'CHECKVALVE', 'CHECKVALVE', NULL, NULL);

UPDATE config_toolbox SET active = FALSE WHERE alias='Import epanet file' AND id=2522;

ALTER TABLE anl_node ALTER COLUMN node_id DROP NOT NULL;

CREATE TRIGGER gw_trg_plan_psector_x_other_geom AFTER INSERT OR UPDATE OR DELETE  ON plan_psector_x_other
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('plan');
