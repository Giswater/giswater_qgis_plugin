/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN label text;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN dv_querytext text;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN dv_parent_id text;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN isenabled boolean;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN layout_id integer;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN layout_order integer;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN project_type character varying;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN isparent boolean;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN dv_querytext_filterc text;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN feature_field_id text;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN feature_dv_parent_value text;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN isautoupdate boolean;
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN datatype character varying(30);
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN widgettype character varying(30);
ALTER TABLE SCHEMA_NAME.audit_cat_param_user ADD COLUMN vdefault text;
