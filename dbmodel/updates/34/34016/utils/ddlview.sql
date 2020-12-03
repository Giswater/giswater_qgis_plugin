/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/07/06

DROP VIEW IF EXISTS v_ui_plan_psector;
CREATE OR REPLACE VIEW v_ui_plan_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.sector_id,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active
   FROM selector_expl,
    plan_psector
     JOIN exploitation USING (expl_id)
     LEFT JOIN plan_typevalue p ON p.id::text = plan_psector.priority::text AND p.typevalue = 'value_priority'::text
     LEFT JOIN plan_typevalue s ON s.id::text = plan_psector.status::text AND s.typevalue = 'psector_status'::text
     LEFT JOIN plan_typevalue t ON t.id::integer = plan_psector.psector_type AND t.typevalue = 'psector_type'::text
     WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;