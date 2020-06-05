/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/06/04
UPDATE arc SET feature_type='ARC' WHERE feature_type IS NULL;
UPDATE connec SET feature_type='CONNEC' WHERE feature_type IS NULL;
UPDATE element SET feature_type='ELEMENT' WHERE feature_type IS NULL;
UPDATE node SET feature_type='NODE' WHERE feature_type IS NULL;

DELETE FROM audit_cat_table WHERE id IN ('v_plan_psector_arc_affect', 'v_plan_psector_arc_current', 'v_plan_psector_arc_planif');