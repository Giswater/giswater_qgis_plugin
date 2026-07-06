/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = multilang, public, pg_catalog;

CREATE TABLE sys_version (
    id serial4 NOT NULL,
    giswater varchar(16) NOT NULL,
    project_type varchar(16) NOT NULL,
    postgres varchar(512) NOT NULL,
    postgis varchar(512) NOT NULL,
    "date" timestamp(6) DEFAULT now() NOT NULL,
    "language" varchar(50) NOT NULL,
    epsg int4 NOT NULL,
    addparam jsonb NULL,
    CONSTRAINT sys_version_pkey PRIMARY KEY (id)
);

CREATE TABLE cat_language (
	id text NOT NULL,
	idval text NULL,
    CONSTRAINT cat_language_idval_key UNIQUE (idval),
    CONSTRAINT cat_language_pkey PRIMARY KEY (id)
);


CREATE TABLE dbconfig_csv (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    al text NULL,
    ds text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_csv_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_csv_pkey PRIMARY KEY ("source", schema_name, context, lang),
    CONSTRAINT dbconfig_csv_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_engine (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "parameter" text NOT NULL,
    "method" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    lb text NULL,
    ds text NULL,
    pl text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_engine_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_engine_pkey PRIMARY KEY (schema_name, context, "parameter", "method", lang),
    CONSTRAINT dbconfig_engine_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_form_fields (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    formname text NOT NULL,
    formtype text NOT NULL,
    tabname text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    lb text NULL,
    tt text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_form_fields_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_form_fields_pkey PRIMARY KEY (tabname, context, formname, formtype, schema_name, "source", lang),
    CONSTRAINT dbconfig_form_fields_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_form_fields_feat (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    feature_type text NOT NULL,
    formtype text NOT NULL,
    tabname text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    lb text NULL,
    tt text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_form_fields_feat_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_form_fields_feat_pkey PRIMARY KEY (tabname, context, feature_type, formtype, schema_name, "source", lang),
    CONSTRAINT dbconfig_form_fields_feat_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_form_fields_json (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    formname text NOT NULL,
    formtype text NOT NULL,
    tabname text NOT NULL,
    "source" text NOT NULL,
    hint text NOT NULL,
    "text" json NULL,
    lang text NOT NULL DEFAULT 'en_us',
    lb text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_form_fields_json_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_form_fields_json_pkey PRIMARY KEY (schema_name, context, hint, "source", formname, formtype, tabname, lang),
    CONSTRAINT dbconfig_form_fields_json_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_form_tableview (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    columnname text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    al text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_form_tableview_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_form_tableview_pkey PRIMARY KEY ("source", schema_name, context, columnname, lang),
    CONSTRAINT dbconfig_form_tableview_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_form_tabs (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    formname text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    lb text NULL,
    tt text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_form_tabs_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_form_tabs_pkey PRIMARY KEY (schema_name, context, formname, "source", lang),
    CONSTRAINT dbconfig_form_tabs_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_param_system (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    lb text NULL,
    tt text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_param_system_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_param_system_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbconfig_param_system_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_report (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    al text NULL,
    ds text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_report_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_report_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbconfig_report_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_toolbox (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    al text NULL,
    ob text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_toolbox_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_toolbox_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbconfig_toolbox_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_typevalue (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    formname text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    tt text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_typevalue_id_uniq UNIQUE (id),
    CONSTRAINT dbconfig_typevalue_pkey PRIMARY KEY (schema_name, context, formname, "source", lang),
    CONSTRAINT dbconfig_typevalue_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbconfig_visit_parameter (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    ds text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbconfig_visit_parameter_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbconfig_visit_parameter_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE INDEX idx_dbconfig_form_fields_lang ON dbconfig_form_fields USING btree (lang);
CREATE INDEX idx_dbconfig_param_system_lang ON dbconfig_param_system USING btree (lang);


CREATE TABLE dbfprocess (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    ex text NULL,
    "in" text NULL,
    na text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbfprocess_id_uniq UNIQUE (id),
    CONSTRAINT dbfprocess_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbfprocess_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbfunction (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    ds text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbfunction_id_uniq UNIQUE (id),
    CONSTRAINT dbfunction_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbfunction_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbjson (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    hint text NOT NULL,
    "text" json NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    lb text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbjson_id_uniq UNIQUE (id),
    CONSTRAINT dbjson_pkey PRIMARY KEY (schema_name, context, hint, "source", lang),
    CONSTRAINT dbjson_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dblabel (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    vl text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dblabel_id_uniq UNIQUE (id),
    CONSTRAINT dblabel_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dblabel_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbmessage (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    ms text NULL,
    ht text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbmessage_id_uniq UNIQUE (id),
    CONSTRAINT dbmessage_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbmessage_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbparam_user (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    lb text NULL,
    tt text NULL,
    CONSTRAINT dbparam_user_id_uniq UNIQUE (id),
    CONSTRAINT dbparam_user_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbparam_user_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbplan_price (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    ds text NULL,
    tx text NULL,
    pr text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbplan_price_id_uniq UNIQUE (id),
    CONSTRAINT dbplan_price_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbplan_price_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbstyle (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    layername text NOT NULL,
    "source" text NOT NULL,
    org_text text NOT NULL,
    hint text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    lb text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbstyle_id_uniq UNIQUE (id),
    CONSTRAINT dbstyle_pkey PRIMARY KEY (schema_name, context, hint, layername, "source", lang),
    CONSTRAINT dbstyle_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbtable (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    ds text NULL,
    al text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbtable_id_uniq UNIQUE (id),
    CONSTRAINT dbtable_pkey PRIMARY KEY (schema_name, context, "source", lang),
    CONSTRAINT dbtable_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);

CREATE TABLE dbtypevalue (
    id serial4 NOT NULL,
    schema_name text NOT NULL,
    context text NOT NULL,
    typevalue text NOT NULL,
    "source" text NOT NULL,
    lang text NOT NULL DEFAULT 'en_us',
    vl text NULL,
    ds text NULL,
    updated_by text DEFAULT CURRENT_USER NULL,
    updated_on timestamptz DEFAULT now() NULL,
    CONSTRAINT dbtypevalue_id_uniq UNIQUE (id),
    CONSTRAINT dbtypevalue_pkey PRIMARY KEY (schema_name, context, typevalue, "source", lang),
    CONSTRAINT dbtypevalue_lang_fkey FOREIGN KEY (lang) REFERENCES cat_language(id)
);


GRANT ALL ON SCHEMA multilang TO role_basic;
GRANT SELECT ON ALL TABLES IN SCHEMA multilang TO role_basic;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA multilang TO role_basic;
