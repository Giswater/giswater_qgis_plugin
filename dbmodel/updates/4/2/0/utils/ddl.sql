/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"crm_number", "dataType":"text"}}$$);

-- 05/08/2025
ALTER TABLE plan_psector ADD COLUMN workcat_id_plan text;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_workcat_id_plan_fkey FOREIGN KEY (workcat_id_plan) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE;
CREATE INDEX idx_plan_psector_workcat_id_plan ON plan_psector(workcat_id_plan);

ALTER TABLE config_form_fields ADD COLUMN field_layoutorder int4 NULL;

DROP RULE insert_plan_psector_x_node ON node;
DROP RULE insert_plan_psector_x_arc ON arc;

ALTER TABLE archived_psector_connec_traceability RENAME COLUMN tstamp TO created_at;
ALTER TABLE archived_psector_connec_traceability RENAME COLUMN insert_user TO created_by;
ALTER TABLE archived_psector_connec_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_connec_traceability RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE archived_psector_arc_traceability RENAME COLUMN tstamp TO created_at;
ALTER TABLE archived_psector_arc_traceability RENAME COLUMN insert_user TO created_by;
ALTER TABLE archived_psector_arc_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_arc_traceability RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE archived_psector_node_traceability RENAME COLUMN tstamp TO created_at;
ALTER TABLE archived_psector_node_traceability RENAME column insert_user TO created_by;
ALTER TABLE archived_psector_node_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_node_traceability RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE archived_psector_link_traceability RENAME column insert_user TO created_by;
ALTER TABLE archived_psector_link_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_link_traceability RENAME COLUMN lastupdate_user TO updated_by;
ALTER TABLE archived_psector_link_traceability RENAME COLUMN exit_topelev TO top_elev2;
ALTER TABLE archived_psector_link_traceability RENAME COLUMN exit_elev TO depth2;
ALTER TABLE archived_psector_link_traceability RENAME column staticpressure TO staticpressure1;
ALTER TABLE archived_psector_link_traceability RENAME column conneccat_id TO linkcat_id;

ALTER TABLE archived_psector_link_traceability add column created_at varchar(50);
ALTER TABLE archived_psector_link_traceability add column staticpressure2 numeric(12,3);

ALTER TABLE archived_psector_node_traceability RENAME to archived_psector_node;
ALTER TABLE archived_psector_arc_traceability RENAME to archived_psector_arc;
ALTER TABLE archived_psector_connec_traceability RENAME to archived_psector_connec;
ALTER TABLE archived_psector_link_traceability RENAME to archived_psector_link;

ALTER TABLE plan_psector RENAME COLUMN tstamp TO created_at;
ALTER TABLE plan_psector RENAME column insert_user TO created_by;
ALTER TABLE plan_psector RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE plan_psector RENAME COLUMN lastupdate_user TO updated_by;

ALTER SEQUENCE archived_psector_arc_traceability_id_seq RENAME TO archived_psector_arc_id_seq;
ALTER SEQUENCE archived_psector_node_traceability_id_seq RENAME TO archived_psector_node_id_seq;
ALTER SEQUENCE archived_psector_connec_traceability_id_seq RENAME TO archived_psector_connec_id_seq;
ALTER SEQUENCE archived_psector_link_traceability_id_seq RENAME TO archived_psector_link_id_seq;

ALTER TABLE archived_psector_arc RENAME CONSTRAINT audit_psector_arc_traceability_pkey TO archived_psector_arc_pkey;
ALTER TABLE archived_psector_connec RENAME CONSTRAINT audit_psector_connec_traceability_pkey TO archived_psector_connec_pkey;
ALTER TABLE archived_psector_node RENAME CONSTRAINT audit_psector_node_traceability_pkey TO archived_psector_node_pkey;
ALTER TABLE archived_psector_link RENAME CONSTRAINT archived_psector_link_traceability_pkey TO archived_psector_link_pkey;


ALTER TABLE archived_psector_node drop column streetname;
ALTER TABLE archived_psector_arc drop column streetname;
ALTER TABLE archived_psector_connec drop column streetname;

ALTER TABLE archived_psector_node drop column streetname2;
ALTER TABLE archived_psector_arc drop column streetname2;
ALTER TABLE archived_psector_connec drop column streetname2;

update sys_param_user set dv_querytext= 'SELECT cat_link.id, cat_link.id AS idval FROM cat_link' where id ='edit_linkcat_vdefault';
delete from sys_param_user where id = 'edit_connec_linkcat_vdefault';
update sys_param_user set id = 'edit_connec_linkcat_vdefault' where id = 'edit_linkcat_vdefault';

ALTER TABLE link DROP COLUMN IF EXISTS epa_type CASCADE;

DELETE FROM config_form_fields WHERE formname ilike '%link%' AND columnname = 'epa_type';

DROP TABLE IF EXISTS man_link;


UPDATE sys_foreignkey SET target_table='archived_psector_arc' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_arc_traceability' AND target_field='fluid_type';
UPDATE sys_foreignkey SET target_table='archived_psector_connec' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_connec_traceability' AND target_field='fluid_type';
UPDATE sys_foreignkey SET target_table='archived_psector_link' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_link_traceability' AND target_field='fluid_type';
UPDATE sys_foreignkey SET target_table='archived_psector_node' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_node_traceability' AND target_field='fluid_type';

UPDATE sys_table SET descript='archived_psector_arc', id='archived_psector_arc' WHERE id='archived_psector_arc_traceability';
UPDATE sys_table SET descript='archived_psector_node', id='archived_psector_node' WHERE id='archived_psector_node_traceability';
UPDATE sys_table SET descript='archived_psector_connec', id='archived_psector_connec' WHERE id='archived_psector_connec_traceability';
UPDATE sys_table SET descript='archived_psector_link', id='archived_psector_link' WHERE id='archived_psector_link_traceability';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"flowsetting", "dataType":"numeric(12,3)"}}$$);
