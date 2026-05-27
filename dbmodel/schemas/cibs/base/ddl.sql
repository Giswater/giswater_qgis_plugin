/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "cibs", public, pg_catalog;

SET ROLE role_admin;

CREATE SCHEMA IF NOT EXISTS cibs AUTHORIZATION role_admin;

GRANT ALL ON SCHEMA cibs TO role_admin;
GRANT ALL ON SCHEMA cibs TO role_basic;
ALTER DEFAULT PRIVILEGES IN SCHEMA cibs GRANT SELECT ON TABLES TO role_basic;

CREATE SEQUENCE cibs.cat_hydrometer_state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE cibs.hydrometer_hydrometer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE cibs.hydrometer_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE cibs.cat_hydrometer (
    id character varying(16) NOT NULL,
    hydrometer_type character varying(100),
    madeby character varying(100),
    class character varying(100),
    ulmc character varying(100),
    type character varying(100),
    flownom character varying(100),
    dnom character varying(100),
    link character varying(512),
    url character varying(512),
    picture character varying(512),
    svg character varying(50),
    code text,
    observ text,
    CONSTRAINT cat_hydrometer_pkey PRIMARY KEY (id)
);

CREATE TABLE cibs.cat_hydrometer_priority (
    id integer NOT NULL,
    code text NOT NULL,
    observ character varying(100),
    CONSTRAINT cat_hydrometer_priority_pkey PRIMARY KEY (id)
);

CREATE TABLE cibs.cat_hydrometer_type (
    id integer NOT NULL,
    code text NOT NULL,
    observ character varying(100),
    CONSTRAINT cat_hydrometer_type_pkey PRIMARY KEY (id)
);

CREATE TABLE cibs.cat_hydrometer_category (
    id character varying(16) NOT NULL,
    observ character varying(100),
    code text,
    pattern_id character varying(16),
    CONSTRAINT cat_hydrometer_category_pkey PRIMARY KEY (id)
);

CREATE TABLE cibs.cat_hydrometer_state (
    id integer NOT NULL DEFAULT nextval('cibs.cat_hydrometer_state_id_seq'::regclass),
    name text NOT NULL,
    observ text,
    is_operative boolean DEFAULT true,
    CONSTRAINT cat_hydrometer_state_pkey PRIMARY KEY (id)
);

CREATE TABLE cibs.hydrometer (
    hydrometer_id integer NOT NULL DEFAULT nextval('cibs.hydrometer_hydrometer_id_seq'::regclass),
    code text,
    customer_name text,
    address text,
    house_number text,
    id_number text,
    start_date date,
    hydro_number text,
    identif text,
    state_id smallint,
    expl_id integer,
    hydrometer_customer_code character varying(30),
    plot_code character varying(100),
    priority_id integer,
    catalog_id integer,
    category_id integer,
    crm_number integer,
    muni_id integer,
    address1 text,
    address2 text,
    address3 text,
    address2_1 text,
    address2_2 text,
    address2_3 text,
    m3_volume double precision,
    hydro_man_date date,
    end_date date,
    update_date date,
    shutdown_date date,
    is_waterbal boolean DEFAULT true,
    link text,
    customer_code character varying(30),
    CONSTRAINT hydrometer_pkey PRIMARY KEY (hydrometer_id),
    CONSTRAINT hydrometer_code_unique UNIQUE (code),
	CONSTRAINT hydrometer_cat_hydrometer_priority_fk FOREIGN KEY (priority_id) REFERENCES cat_hydrometer_priority(id),
	CONSTRAINT hydrometer_cat_hydrometer_state_fk FOREIGN KEY (state_id) REFERENCES cat_hydrometer_state(id)
);

CREATE TABLE cibs.hydrometer_data (
    id bigint NOT NULL DEFAULT nextval('cibs.hydrometer_data_id_seq'::regclass),
    hydrometer_id integer,
    min double precision,
    max double precision,
    avg double precision,
    sum double precision,
    custom_sum double precision,
    cat_period_id character varying(16),
    value_date date,
    pattern_id character varying(16),
    value_type integer,
    value_status integer,
    value_state integer,
    crm_number text,
    CONSTRAINT hydrometer_data_pkey PRIMARY KEY (id),
    CONSTRAINT hydrometer_data_hydrometer_id_cat_period_id_unique UNIQUE (hydrometer_id, cat_period_id),
	CONSTRAINT hydrometer_data_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES hydrometer(hydrometer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE cibs.cat_hydrometer_category_x_pattern (
    category_id character varying(16) NOT NULL,
    period_type integer NOT NULL,
    pattern_id character varying(16) NOT NULL,
    observ text,
    CONSTRAINT cat_hydrometer_category_x_pattern_pkey PRIMARY KEY (category_id)
);

ALTER SEQUENCE cibs.cat_hydrometer_state_id_seq OWNED BY cibs.cat_hydrometer_state.id;
ALTER SEQUENCE cibs.hydrometer_hydrometer_id_seq OWNED BY cibs.hydrometer.hydrometer_id;
ALTER SEQUENCE cibs.hydrometer_data_id_seq OWNED BY cibs.hydrometer_data.id;

CREATE INDEX hydrometer_customer_code_idx ON cibs.hydrometer USING btree (customer_code);
CREATE INDEX hydrometer_data_index_cat_period_id ON cibs.hydrometer_data USING btree (cat_period_id);
CREATE INDEX hydrometer_data_index_hydrometer_id ON cibs.hydrometer_data USING btree (hydrometer_id);
