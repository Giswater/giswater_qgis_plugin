/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TABLE config_api_form_fields(
  id serial NOT NULL,
  formname character varying(50) NOT NULL,
  formtype character varying(50) NOT NULL,
  column_id character varying(30) NOT NULL,
  layout_id integer,
  layout_order integer,
  isenabled boolean,
  datatype character varying(30),
  widgettype character varying(30),
  label text,
  widgetdim integer,
  tooltip text,
  placeholder text,
  field_length integer,
  num_decimals integer,
  ismandatory boolean,
  isparent boolean,
  iseditable boolean,
  isautoupdate boolean,
  dv_querytext text,
  dv_orderby_id boolean,
  dv_isnullvalue boolean,
  dv_parent_id text,
  dv_querytext_filterc text,
  widgetfunction text,
  action_function text,
  isreload boolean,
  stylesheet json,
  isnotupdate boolean,
  typeahead json,
  listfilterparam json,
  CONSTRAINT config_api_form_fields_pkey PRIMARY KEY (id),
  CONSTRAINT config_api_form_fields_pkey2 UNIQUE (formname, formtype, column_id)
);
