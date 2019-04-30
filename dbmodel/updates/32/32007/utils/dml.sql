/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- parametrize gw_fct_anl_connec_duplicated
DELETE FROM audit_cat_function WHERE id=2106;
INSERT INTO audit_cat_function VALUES (2106, 'gw_fct_anl_connec_duplicated', 'utils', 'function', '{"featureType":"connec"}', '[{"widgetname":"connecTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layout_name":"grl_option_parameters","layout_order":1,"value":0.01}]', NULL, 'Check topology assistant. To review how many connecs are duplicated', 'role_edit', false, true, 'Check connecs duplicated', true);


ALTER TABLE sys_role DROP CONSTRAINT sys_role_check;
ALTER TABLE sys_role
ADD CONSTRAINT sys_role_check CHECK (id::text = ANY (ARRAY['role_admin'::character varying, 'role_basic'::character varying, 
'role_edit'::character varying, 'role_epa'::character varying, 'role_master'::character varying, 'role_om'::character varying, 'role_crm'::character varying]::text[]));


INSERT INTO sys_role VALUES ('role_crm', 'crm');

UPDATE audit_cat_table SET sys_role_id='role_basic' where id='selector_psector';

