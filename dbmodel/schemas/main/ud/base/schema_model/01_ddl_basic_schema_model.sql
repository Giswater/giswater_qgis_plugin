/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Name: anl_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE anl_arc (
    id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    arccat_id character varying(30),
    state integer,
    arc_id_aux character varying(16),
    expl_id integer,
    fid integer NOT NULL,
    cur_user character varying(30) DEFAULT "current_user"() NOT NULL,
    the_geom public.geometry(LineString,SRID_VALUE),
    the_geom_p public.geometry(Point,SRID_VALUE),
    descript text,
    result_id character varying(16),
    node_1 character varying(16),
    node_2 character varying(16),
    sys_type character varying(30),
    code character varying(30),
    cat_geom1 double precision,
    length double precision,
    slope double precision,
    total_length numeric(12,3),
    z1 double precision,
    z2 double precision,
    y1 double precision,
    y2 double precision,
    elev1 double precision,
    elev2 double precision,
    dma_id integer,
    addparam text,
    sector_id integer,
    drainzone_id integer
);


--
-- Name: anl_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE anl_arc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anl_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE anl_arc_id_seq OWNED BY anl_arc.id;


--
-- Name: anl_arc_x_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE anl_arc_x_node (
    id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    node_id character varying(16),
    arccat_id character varying(30),
    state integer,
    expl_id integer,
    fid integer NOT NULL,
    cur_user character varying(30) DEFAULT "current_user"() NOT NULL,
    the_geom public.geometry(LineString,SRID_VALUE),
    the_geom_p public.geometry(Point,SRID_VALUE),
    descript text,
    result_id character varying(16)
);


--
-- Name: anl_arc_x_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE anl_arc_x_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anl_arc_x_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE anl_arc_x_node_id_seq OWNED BY anl_arc_x_node.id;


--
-- Name: anl_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE anl_connec (
    id integer NOT NULL,
    connec_id character varying(16) NOT NULL,
    connecat_id character varying(30),
    state integer,
    connec_id_aux character varying(16),
    connecat_id_aux character varying(30),
    state_aux integer,
    expl_id integer,
    fid integer NOT NULL,
    cur_user character varying(30) DEFAULT "current_user"() NOT NULL,
    the_geom public.geometry(Point,SRID_VALUE),
    descript text,
    result_id character varying(16),
    dma_id text,
    addparam text
);


--
-- Name: anl_connec_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE anl_connec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anl_connec_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE anl_connec_id_seq OWNED BY anl_connec.id;


--
-- Name: anl_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE anl_gully (
    id integer NOT NULL,
    gully_id character varying(16) NOT NULL,
    gratecat_id character varying(30),
    state integer,
    gully_id_aux character varying(16),
    gratecat_id_aux character varying(30),
    state_aux integer,
    expl_id integer,
    fid integer NOT NULL,
    cur_user character varying(30) DEFAULT "current_user"() NOT NULL,
    the_geom public.geometry(Point,SRID_VALUE),
    descript text,
    result_id character varying(16),
    dma_id text,
    addparam text
);


--
-- Name: anl_gully_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE anl_gully_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anl_gully_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE anl_gully_id_seq OWNED BY anl_gully.id;


--
-- Name: urn_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE urn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anl_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE anl_node (
    id integer NOT NULL,
    node_id character varying(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
    nodecat_id character varying(30),
    state integer,
    num_arcs integer,
    node_id_aux character varying(16),
    nodecat_id_aux character varying(30),
    state_aux integer,
    expl_id integer,
    fid integer NOT NULL,
    cur_user character varying(30) DEFAULT "current_user"() NOT NULL,
    the_geom public.geometry(Point,SRID_VALUE),
    arc_distance numeric(12,3),
    arc_id character varying(16),
    descript text,
    result_id character varying(16),
    total_distance numeric(12,3),
    sys_type character varying(30),
    code character varying(30),
    cat_geom1 double precision,
    top_elev double precision,
    elev double precision,
    ymax double precision,
    state_type integer,
    sector_id integer,
    addparam text,
    drainzone_id integer
);


--
-- Name: anl_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE anl_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anl_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE anl_node_id_seq OWNED BY anl_node.id;


--
-- Name: anl_polygon; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE anl_polygon (
    id integer NOT NULL,
    pol_id character varying(16) NOT NULL,
    pol_type character varying(30),
    state integer,
    expl_id integer,
    fid integer NOT NULL,
    cur_user character varying(30) DEFAULT "current_user"() NOT NULL,
    the_geom public.geometry(MultiPolygon),
    result_id character varying(16),
    descript text
);


--
-- Name: anl_polygon_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE anl_polygon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anl_polygon_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE anl_polygon_id_seq OWNED BY anl_polygon.id;


--
-- Name: arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE arc (
    arc_id character varying(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
    code character varying(30),
    node_1 character varying(16),
    node_2 character varying(16),
    y1 numeric(12,3),
    y2 numeric(12,3),
    elev1 numeric(12,3),
    elev2 numeric(12,3),
    custom_y1 numeric(12,3),
    custom_y2 numeric(12,3),
    custom_elev1 numeric(12,3),
    custom_elev2 numeric(12,3),
    sys_elev1 numeric(12,3),
    sys_elev2 numeric(12,3),
    arc_type character varying(18) NOT NULL,
    arccat_id character varying(30) NOT NULL,
    matcat_id character varying(30),
    epa_type character varying(16) NOT NULL,
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    annotation text,
    observ text,
    comment text,
    sys_slope numeric(12,4),
    inverted_slope boolean DEFAULT false,
    custom_length numeric(12,2),
    dma_id integer NOT NULL,
    soilcat_id character varying(16),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    descript text,
    link character varying(512),
    verified character varying(20),
    the_geom public.geometry(LineString,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    uncertain boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16) DEFAULT 'ARC'::character varying,
    tstamp timestamp without time zone DEFAULT now(),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50) DEFAULT CURRENT_USER,
    district_id integer,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    pavcat_id character varying(30),
    drainzone_id integer,
    nodetype_1 character varying(30),
    node_sys_top_elev_1 numeric(12,3),
    node_sys_elev_1 numeric(12,3),
    nodetype_2 character varying(30),
    node_sys_top_elev_2 numeric(12,3),
    node_sys_elev_2 numeric(12,3),
    parent_id character varying(16),
    expl_id2 integer,
    CONSTRAINT arc_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['CONDUIT'::text, 'WEIR'::text, 'ORIFICE'::text, 'VIRTUAL'::text, 'PUMP'::text, 'OUTLET'::text, 'UNDEFINED'::text])))
);


--
-- Name: TABLE arc; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE arc IS 'FIELDS _sys_y1, _sys_y2 ARE IS NOT USED. Values are calculated on the fly on views (3.3.021)';


--
-- Name: arc_border_expl; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE arc_border_expl (
    arc_id character varying(16) NOT NULL,
    expl_id integer NOT NULL
);


--
-- Name: audit_arc_traceability; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_arc_traceability (
    id integer NOT NULL,
    type character varying(50) NOT NULL,
    arc_id character varying(16) NOT NULL,
    arc_id1 character varying(16) NOT NULL,
    arc_id2 character varying(16) NOT NULL,
    node_id character varying(16) NOT NULL,
    tstamp timestamp(6) without time zone,
    cur_user character varying(50),
    code character varying(30)
);


--
-- Name: audit_arc_traceability_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_arc_traceability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_arc_traceability_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_arc_traceability_id_seq OWNED BY audit_arc_traceability.id;


--
-- Name: audit_check_data; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_check_data (
    id integer NOT NULL,
    fid smallint,
    result_id character varying(30),
    table_id text,
    column_id text,
    criticity smallint,
    enabled boolean,
    error_message text,
    tstamp timestamp without time zone DEFAULT now(),
    cur_user text DEFAULT "current_user"(),
    feature_type text,
    feature_id text,
    addparam json,
    fcount integer
);


--
-- Name: audit_check_data_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_check_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_check_data_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_check_data_id_seq OWNED BY audit_check_data.id;


--
-- Name: audit_check_project; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_check_project (
    id integer NOT NULL,
    table_id text,
    table_host text,
    table_dbname text,
    table_schema text,
    fid integer,
    criticity smallint,
    enabled boolean,
    message text,
    tstamp timestamp without time zone DEFAULT now(),
    cur_user text DEFAULT "current_user"(),
    observ text,
    table_user text
);


--
-- Name: audit_check_project_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_check_project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_check_project_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_check_project_id_seq OWNED BY audit_check_project.id;


--
-- Name: audit_fid_log; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_fid_log (
    id integer NOT NULL,
    fid smallint,
    fcount integer,
    groupby text,
    criticity integer,
    tstamp timestamp without time zone DEFAULT now()
);


--
-- Name: audit_fid_log_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_fid_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_fid_log_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_fid_log_id_seq OWNED BY audit_fid_log.id;


--
-- Name: audit_log_data; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_log_data (
    id integer NOT NULL,
    fid smallint,
    feature_type character varying(16),
    feature_id character varying(16),
    enabled boolean,
    log_message text,
    tstamp timestamp without time zone DEFAULT now(),
    cur_user text DEFAULT "current_user"(),
    addparam json
);


--
-- Name: audit_log_data_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_log_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_log_data_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_log_data_id_seq OWNED BY audit_log_data.id;


--
-- Name: audit_psector_arc_traceability; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_psector_arc_traceability (
    id integer NOT NULL,
    psector_id integer NOT NULL,
    psector_state smallint NOT NULL,
    doable boolean NOT NULL,
    addparam json,
    audit_tstamp timestamp without time zone DEFAULT now(),
    audit_user text DEFAULT CURRENT_USER,
    action character varying(16) NOT NULL,
    arc_id character varying(16) NOT NULL,
    code character varying(30),
    node_1 character varying(16),
    node_2 character varying(16),
    y1 numeric(12,3),
    y2 numeric(12,3),
    elev1 numeric(12,3),
    elev2 numeric(12,3),
    custom_y1 numeric(12,3),
    custom_y2 numeric(12,3),
    custom_elev1 numeric(12,3),
    custom_elev2 numeric(12,3),
    sys_elev1 numeric(12,3),
    sys_elev2 numeric(12,3),
    arc_type character varying(18) NOT NULL,
    arccat_id character varying(30) NOT NULL,
    matcat_id character varying(30),
    epa_type character varying(16) NOT NULL,
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    annotation text,
    observ text,
    comment text,
    sys_slope numeric(12,4),
    inverted_slope boolean,
    custom_length numeric(12,2),
    dma_id integer NOT NULL,
    soilcat_id character varying(16),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    descript text,
    link character varying(512),
    verified character varying(20),
    the_geom public.geometry(LineString,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    uncertain boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16),
    tstamp timestamp without time zone,
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50),
    district_id integer,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    pavcat_id character varying(30),
    drainzone_id integer,
    nodetype_1 character varying(30),
    node_sys_top_elev_1 numeric(12,3),
    node_sys_elev_1 numeric(12,3),
    nodetype_2 character varying(30),
    node_sys_top_elev_2 numeric(12,3),
    node_sys_elev_2 numeric(12,3),
    parent_id character varying(16),
    expl_id2 integer
);


--
-- Name: audit_psector_arc_traceability_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_psector_arc_traceability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_psector_arc_traceability_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_psector_arc_traceability_id_seq OWNED BY audit_psector_arc_traceability.id;


--
-- Name: audit_psector_connec_traceability; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_psector_connec_traceability (
    id integer NOT NULL,
    psector_id integer NOT NULL,
    psector_state smallint NOT NULL,
    doable boolean NOT NULL,
    psector_arc_id character varying(16),
    link_id integer,
    link_the_geom public.geometry(LineString,SRID_VALUE),
    audit_tstamp timestamp without time zone DEFAULT now(),
    audit_user text DEFAULT CURRENT_USER,
    action character varying(16) NOT NULL,
    connec_id character varying(16) NOT NULL,
    code character varying(30),
    top_elev numeric(12,4),
    y1 numeric(12,4),
    y2 numeric(12,4),
    connec_type character varying(30) NOT NULL,
    connecat_id character varying(30) NOT NULL,
    sector_id integer NOT NULL,
    customer_code character varying(30),
    private_connecat_id character varying(30),
    demand numeric(12,8),
    state smallint NOT NULL,
    state_type smallint,
    connec_depth numeric(12,3),
    connec_length numeric(12,3),
    arc_id character varying(16),
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    soilcat_id character varying(16),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    descript text,
    link character varying(512),
    verified character varying(20),
    rotation numeric(6,3),
    the_geom public.geometry(Point,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    accessibility boolean,
    diagonal character varying(50),
    publish boolean,
    inventory boolean,
    uncertain boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16),
    tstamp timestamp without time zone,
    pjoint_type character varying(16),
    pjoint_id character varying(16),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50),
    matcat_id character varying(16),
    district_id integer,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    drainzone_id integer,
    expl_id2 integer
);


--
-- Name: audit_psector_connec_traceability_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_psector_connec_traceability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_psector_connec_traceability_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_psector_connec_traceability_id_seq OWNED BY audit_psector_connec_traceability.id;


--
-- Name: audit_psector_gully_traceability; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_psector_gully_traceability (
    id integer NOT NULL,
    psector_id integer NOT NULL,
    psector_state smallint NOT NULL,
    doable boolean NOT NULL,
    psector_arc_id character varying(16),
    link_id integer,
    link_the_geom public.geometry(LineString,SRID_VALUE),
    audit_tstamp timestamp without time zone DEFAULT now(),
    audit_user text DEFAULT CURRENT_USER,
    action character varying(16) NOT NULL,
    gully_id character varying(16) NOT NULL,
    code character varying(30),
    top_elev numeric(12,4),
    ymax numeric(12,4),
    sandbox numeric(12,4),
    matcat_id character varying(18),
    gully_type character varying(30) NOT NULL,
    gratecat_id character varying(30),
    units smallint,
    groove boolean,
    siphon boolean,
    connec_arccat_id character varying(18),
    connec_length numeric(12,3),
    connec_depth numeric(12,3),
    arc_id character varying(16),
    _pol_id_ character varying(16),
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    soilcat_id character varying(16),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    descript text,
    link character varying(512),
    verified character varying(20),
    rotation numeric(6,3),
    the_geom public.geometry(Point,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    uncertain boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16),
    tstamp timestamp without time zone,
    pjoint_type character varying(16),
    pjoint_id character varying(16),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50),
    district_id integer,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    connec_matcat_id text,
    connec_y2 numeric(12,3),
    gratecat2_id text,
    epa_type character varying(16) NOT NULL,
    groove_height double precision,
    groove_length double precision,
    units_placement character varying(16),
    drainzone_id integer,
    expl_id2 integer
);


--
-- Name: audit_psector_gully_traceability_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_psector_gully_traceability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_psector_gully_traceability_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_psector_gully_traceability_id_seq OWNED BY audit_psector_gully_traceability.id;


--
-- Name: audit_psector_node_traceability; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE audit_psector_node_traceability (
    id integer NOT NULL,
    psector_id integer NOT NULL,
    psector_state smallint NOT NULL,
    doable boolean NOT NULL,
    addparam json,
    audit_tstamp timestamp without time zone DEFAULT now(),
    audit_user text DEFAULT CURRENT_USER,
    action character varying(16) NOT NULL,
    node_id character varying(16) NOT NULL,
    code character varying(30),
    top_elev numeric(12,3),
    ymax numeric(12,3),
    elev numeric(12,3),
    custom_top_elev numeric(12,3),
    custom_ymax numeric(12,3),
    custom_elev numeric(12,3),
    node_type character varying(30) NOT NULL,
    nodecat_id character varying(30) NOT NULL,
    epa_type character varying(16) NOT NULL,
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint,
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    soilcat_id character varying(16),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    descript text,
    rotation numeric(6,3),
    link character varying(512),
    verified character varying(20),
    the_geom public.geometry(Point,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    xyz_date date,
    uncertain boolean,
    unconnected boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16),
    tstamp timestamp without time zone,
    arc_id character varying(16),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50),
    matcat_id character varying(16),
    district_id integer,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    drainzone_id integer,
    parent_id character varying(16),
    expl_id2 integer
);


--
-- Name: audit_psector_node_traceability_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE audit_psector_node_traceability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_psector_node_traceability_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE audit_psector_node_traceability_id_seq OWNED BY audit_psector_node_traceability.id;


--
-- Name: cat_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_arc (
    id character varying(30) NOT NULL,
    matcat_id character varying(16),
    shape character varying(16),
    geom1 numeric(12,4),
    geom2 numeric(12,4) DEFAULT 0.00,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    geom5 numeric(12,4),
    geom6 numeric(12,4),
    geom7 numeric(12,4),
    geom8 numeric(12,4),
    geom_r character varying(20),
    descript character varying(255),
    link character varying(512),
    brand character varying(30),
    model character varying(30),
    svg character varying(50),
    z1 numeric(12,2),
    z2 numeric(12,2),
    width numeric(12,2),
    area numeric(12,4),
    estimated_depth numeric(12,2),
    bulk numeric(12,2),
    cost_unit character varying(3) DEFAULT 'm'::character varying,
    cost character varying(16),
    m2bottom_cost character varying(16),
    m3protec_cost character varying(16),
    active boolean DEFAULT true,
    label character varying(255),
    tsect_id character varying(16),
    curve_id character varying(16),
    arc_type text,
    acoeff double precision,
    connect_cost text
);


--
-- Name: cat_arc_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE cat_arc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cat_arc_shape; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_arc_shape (
    id character varying(30) NOT NULL,
    epa character varying(30) NOT NULL,
    image character varying(50),
    descript text,
    active boolean DEFAULT true,
    CONSTRAINT cat_arc_shape_check CHECK (((epa)::text = ANY (ARRAY[('VERT_ELLIPSE'::character varying)::text, ('ARCH'::character varying)::text, ('BASKETHANDLE'::character varying)::text, ('CIRCULAR'::character varying)::text, ('CUSTOM'::character varying)::text, ('DUMMY'::character varying)::text, ('EGG'::character varying)::text, ('FILLED_CIRCULAR'::character varying)::text, ('FORCE_MAIN'::character varying)::text, ('HORIZ_ELLIPSE'::character varying)::text, ('HORSESHOE'::character varying)::text, ('IRREGULAR'::character varying)::text, ('MODBASKETHANDLE'::character varying)::text, ('PARABOLIC'::character varying)::text, ('POWER'::character varying)::text, ('RECT_CLOSED'::character varying)::text, ('RECT_OPEN'::character varying)::text, ('RECT_ROUND'::character varying)::text, ('RECT_TRIANGULAR'::character varying)::text, ('SEMICIRCULAR'::character varying)::text, ('SEMIELLIPTICAL'::character varying)::text, ('TRAPEZOIDAL'::character varying)::text, ('TRIANGULAR'::character varying)::text, ('VIRTUAL'::character varying)::text])))
);


--
-- Name: TABLE cat_arc_shape; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE cat_arc_shape IS 'FIELDS _tsect_id, _curve_id ARE NOT USED. Values are stored on cat_arc table (3.3.021)';


--
-- Name: cat_brand; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_brand (
    id character varying(30) NOT NULL,
    descript text,
    link character varying(512),
    active boolean DEFAULT true,
    featurecat_id character varying(300)
);


--
-- Name: cat_brand_model; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_brand_model (
    id character varying(30) NOT NULL,
    catbrand_id character varying(30),
    descript text,
    link character varying(512),
    active boolean DEFAULT true,
    featurecat_id character varying(300)
);


--
-- Name: cat_builder; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_builder (
    id character varying(30) NOT NULL,
    descript character varying(512),
    link character varying(512),
    active boolean DEFAULT true
);


--
-- Name: cat_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_connec (
    id character varying(30) NOT NULL,
    matcat_id character varying(16),
    shape character varying(16),
    geom1 numeric(12,4) DEFAULT 0,
    geom2 numeric(12,4) DEFAULT 0.00,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    geom_r character varying(20),
    descript character varying(255),
    link character varying(512),
    brand character varying(30),
    model character varying(30),
    svg character varying(50),
    active boolean DEFAULT true,
    label character varying(255),
    connec_type text
);


--
-- Name: cat_dscenario; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_dscenario (
    dscenario_id integer NOT NULL,
    name character varying(30),
    descript text,
    parent_id integer,
    dscenario_type text,
    active boolean DEFAULT true,
    expl_id integer,
    log text
);


--
-- Name: cat_dscenario_dscenario_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE cat_dscenario_dscenario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cat_dscenario_dscenario_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE cat_dscenario_dscenario_id_seq OWNED BY cat_dscenario.dscenario_id;


--
-- Name: cat_dwf_scenario; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_dwf_scenario (
    id integer NOT NULL,
    idval character varying(30),
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    observ text,
    active boolean DEFAULT true,
    expl_id integer,
    log text
);


--
-- Name: cat_dwf_scenario_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE cat_dwf_scenario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cat_dwf_scenario_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE cat_dwf_scenario_id_seq OWNED BY cat_dwf_scenario.id;


--
-- Name: cat_element; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_element (
    id character varying(30) NOT NULL,
    elementtype_id character varying(30),
    matcat_id character varying(30),
    geometry character varying(30),
    descript character varying(512),
    link character varying(512),
    brand character varying(30),
    type character varying(30),
    model character varying(30),
    svg character varying(50),
    active boolean DEFAULT true,
    geom1 numeric(12,3),
    geom2 numeric(12,3),
    isdoublegeom boolean
);


--
-- Name: cat_feature; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_feature (
    id character varying(30) NOT NULL,
    system_id character varying(30),
    feature_type character varying(30),
    shortcut_key character varying(100),
    parent_layer character varying(100),
    child_layer character varying(100),
    descript text,
    link_path text,
    code_autofill boolean DEFAULT true,
    active boolean DEFAULT true,
    config json
);


--
-- Name: cat_feature_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_feature_arc (
    id character varying(30) NOT NULL,
    type character varying(30) NOT NULL,
    epa_default character varying(30) NOT NULL,
    CONSTRAINT cat_feature_arc_inp_check CHECK (((epa_default)::text = ANY (ARRAY['CONDUIT'::text, 'WEIR'::text, 'ORIFICE'::text, 'VIRTUAL'::text, 'PUMP'::text, 'OUTLET'::text, 'UNDEFINED'::text])))
);


--
-- Name: cat_feature_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_feature_connec (
    id character varying(30) NOT NULL,
    type character varying(30) NOT NULL,
    double_geom json DEFAULT '{"activated":false,"value":1}'::json
);


--
-- Name: cat_feature_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_feature_gully (
    id character varying(30) NOT NULL,
    type character varying(30) NOT NULL,
    double_geom json,
    epa_default character varying(30) DEFAULT 'GULLY'::character varying NOT NULL,
    CONSTRAINT cat_feature_gully_inp_check CHECK (((epa_default)::text = ANY (ARRAY['GULLY'::text, 'UNDEFINED'::text])))
);


--
-- Name: cat_feature_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_feature_node (
    id character varying(30) NOT NULL,
    type character varying(30) NOT NULL,
    epa_default character varying(30) NOT NULL,
    num_arcs integer,
    choose_hemisphere boolean DEFAULT false NOT NULL,
    isarcdivide boolean DEFAULT true NOT NULL,
    isprofilesurface boolean DEFAULT true,
    isexitupperintro smallint,
    double_geom json DEFAULT '{"activated":false,"value":1}'::json,
    CONSTRAINT cat_feature_node_inp_check CHECK (((epa_default)::text = ANY (ARRAY['JUNCTION'::text, 'STORAGE'::text, 'DIVIDER'::text, 'OUTFALL'::text, 'NETGULLY'::text, 'UNDEFINED'::text]))),
    CONSTRAINT cat_feature_node_isextiupperintro_check CHECK ((isexitupperintro = ANY (ARRAY[0, 1, 2, 3])))
);


--
-- Name: TABLE cat_feature_node; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE cat_feature_node IS 'FIELD isexitupperintro has three values 0-false (by default), 1-true, 2-maybe';


--
-- Name: cat_grate; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_grate (
    id character varying(30) NOT NULL,
    matcat_id character varying(16),
    length numeric(12,4) DEFAULT 0,
    width numeric(12,4) DEFAULT 0.00,
    total_area numeric(12,4) DEFAULT 0.00,
    effective_area numeric(12,4) DEFAULT 0.00,
    n_barr_l numeric(12,4) DEFAULT 0.00,
    n_barr_w numeric(12,4) DEFAULT 0.00,
    n_barr_diag numeric(12,4) DEFAULT 0.00,
    a_param numeric(12,4) DEFAULT 0.00,
    b_param numeric(12,4) DEFAULT 0.00,
    descript character varying(255),
    link character varying(512),
    brand character varying(30),
    model character varying(30),
    svg character varying(50),
    active boolean DEFAULT true,
    label character varying(255),
    gully_type text
);


--
-- Name: cat_hydrology; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_hydrology (
    hydrology_id integer NOT NULL,
    name character varying(30),
    infiltration character varying(20) NOT NULL,
    text character varying(255),
    active boolean DEFAULT true,
    expl_id integer,
    log text
);


--
-- Name: cat_hydrology_hydrology_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE cat_hydrology_hydrology_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cat_hydrology_hydrology_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE cat_hydrology_hydrology_id_seq OWNED BY cat_hydrology.hydrology_id;


--
-- Name: cat_manager; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_manager (
    id integer NOT NULL,
    idval text,
    expl_id integer[],
    username text[],
    active boolean DEFAULT true,
    sector_id integer[]
);


--
-- Name: cat_manager_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE cat_manager_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cat_manager_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE cat_manager_id_seq OWNED BY cat_manager.id;


--
-- Name: cat_mat_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_mat_arc (
    id character varying(30) NOT NULL,
    descript character varying(512),
    n numeric(12,4),
    link character varying(512),
    active boolean DEFAULT true
);


--
-- Name: cat_mat_element; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_mat_element (
    id character varying(30) NOT NULL,
    descript character varying(512),
    link character varying(512),
    active boolean DEFAULT true
);


--
-- Name: cat_mat_grate; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_mat_grate (
    id character varying(30) NOT NULL,
    descript character varying(512),
    link character varying(512),
    active boolean DEFAULT true
);


--
-- Name: cat_mat_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_mat_gully (
    id character varying(30) NOT NULL,
    descript character varying(512),
    link character varying(512),
    active boolean DEFAULT true
);


--
-- Name: cat_mat_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_mat_node (
    id character varying(30) NOT NULL,
    descript character varying(512),
    link character varying(512),
    active boolean DEFAULT true
);


--
-- Name: cat_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_node (
    id character varying(30) NOT NULL,
    matcat_id character varying(16),
    shape character varying(50),
    geom1 numeric(12,2) DEFAULT 0,
    geom2 numeric(12,2) DEFAULT 0,
    geom3 numeric(12,2) DEFAULT 0,
    descript character varying(255),
    link character varying(512),
    brand character varying(30),
    model character varying(30),
    svg character varying(50),
    estimated_y numeric(12,2),
    cost_unit character varying(3) DEFAULT 'u'::character varying,
    cost character varying(16),
    active boolean DEFAULT true,
    label character varying(255),
    node_type text,
    acoeff double precision
);


--
-- Name: cat_node_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE cat_node_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cat_node_shape; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_node_shape (
    id character varying(30) NOT NULL,
    descript text,
    active boolean DEFAULT true
);


--
-- Name: cat_owner; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_owner (
    id character varying(30) NOT NULL,
    descript character varying(512),
    link character varying(512),
    active boolean DEFAULT true
);


--
-- Name: cat_pavement; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_pavement (
    id character varying(30) NOT NULL,
    descript text,
    link character varying(512),
    thickness numeric(12,2) DEFAULT 0.00,
    m2_cost character varying(16),
    active boolean DEFAULT true
);


--
-- Name: cat_soil; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_soil (
    id character varying(30) NOT NULL,
    descript character varying(512),
    link character varying(512),
    y_param numeric(5,2),
    b numeric(5,2),
    trenchlining numeric(3,2),
    m3exc_cost character varying(16),
    m3fill_cost character varying(16),
    m3excess_cost character varying(16),
    m2trenchl_cost character varying(16),
    active boolean DEFAULT true
);


--
-- Name: cat_users; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_users (
    id character varying(50) NOT NULL,
    name character varying(150),
    context character varying(50),
    sys_role character varying(30),
    active boolean DEFAULT true,
    external boolean
);


--
-- Name: cat_work; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_work (
    id character varying(255) NOT NULL,
    descript character varying(512),
    link character varying(512),
    workid_key1 character varying(30),
    workid_key2 character varying(30),
    builtdate date,
    workcost double precision,
    active boolean DEFAULT true
);


--
-- Name: cat_workspace; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_workspace (
    id integer NOT NULL,
    name character varying(50),
    descript text,
    config json,
    cur_user text DEFAULT "current_user"(),
    private boolean,
    active boolean DEFAULT true,
    iseditable boolean DEFAULT true
);


--
-- Name: cat_workspace_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE cat_workspace_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cat_workspace_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE cat_workspace_id_seq OWNED BY cat_workspace.id;


--
-- Name: config_csv; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_csv (
    fid integer NOT NULL,
    alias text,
    descript text,
    functionname character varying(50),
    active boolean DEFAULT true,
    orderby integer,
    addparam json
);


--
-- Name: config_csv_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE config_csv_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: config_csv_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE config_csv_id_seq OWNED BY config_csv.fid;


--
-- Name: config_file; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_file (
    filetype character varying(30) NOT NULL,
    fextension character varying(16) NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: config_form_fields; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_form_fields (
    formname character varying(50) NOT NULL,
    formtype character varying(50) NOT NULL,
    tabname character varying(30) NOT NULL,
    columnname character varying(30) NOT NULL,
    layoutname character varying(16),
    layoutorder integer,
    datatype character varying(30),
    widgettype character varying(30),
    label text,
    tooltip text,
    placeholder text,
    ismandatory boolean,
    isparent boolean,
    iseditable boolean,
    isautoupdate boolean,
    isfilter boolean,
    dv_querytext text,
    dv_orderby_id boolean,
    dv_isnullvalue boolean,
    dv_parent_id text,
    dv_querytext_filterc text,
    stylesheet json,
    widgetcontrols json,
    widgetfunction json,
    linkedobject text,
    hidden boolean DEFAULT false NOT NULL,
    web_layoutorder integer
);


--
-- Name: TABLE config_form_fields; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE config_form_fields IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table form fields are configured:
The function gw_api_get_formfields is called to build widget forms using this table.
formname: warning with formname. If it is used to work with listFilter fields tablename of an existing relation on database must be mandatory to put here
formtype: There are diferent formtypes:
	feature: the standard one. Used to show fields from feature tables
	info: used to build the infoplan widget
	visit: used on visit forms
	form: used on specific forms (search, mincut)
	catalog: used on catalog forms (workcat and featurecatalog)
	listfilter: used to filter list
	editbuttons:  buttons on form bottom used to edit (accept, cancel)
	navbuttons: buttons on form bottom used to navigate (goback....)
layout_id and layout_order, used to define the position';


--
-- Name: config_form_layout_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE config_form_layout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: config_form_list; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_form_list (
    listname character varying(50) NOT NULL,
    query_text text,
    device smallint NOT NULL,
    listtype character varying(30),
    listclass character varying(30),
    vdefault json
);


--
-- Name: TABLE config_form_list; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE config_form_list IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table lists are configured. There are two types of lists: List on tabs and lists on attribute table
tablename must be mandatory to use a name of an existing relation on database. Code needs to identify the datatype of filter to work with
The field actionfields is required only for list on attribute table (listtype attributeTable). 
In case of different listtype actions must be defined on config_api_form_tabs';


--
-- Name: config_form_tableview; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_form_tableview (
    location_type character varying(50) NOT NULL,
    project_type character varying(50) NOT NULL,
    tablename character varying(50) NOT NULL,
    columnname character varying(50) NOT NULL,
    columnindex smallint,
    visible boolean,
    width integer,
    alias character varying(50),
    style json
);


--
-- Name: config_form_tabs; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_form_tabs (
    formname character varying(50) NOT NULL,
    tabname text NOT NULL,
    label text,
    tooltip text,
    sys_role text,
    tabfunction json,
    tabactions json,
    device integer NOT NULL,
    orderby integer
);


--
-- Name: TABLE config_form_tabs; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE config_form_tabs IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table tabs on form are configured
Field actions is mandatory in exception of attributeTable. In case of attribute table actions must be defined on config_api_list';


--
-- Name: config_fprocess; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_fprocess (
    fid integer NOT NULL,
    tablename text NOT NULL,
    target text NOT NULL,
    querytext text,
    orderby integer,
    addparam json,
    active boolean DEFAULT true
);


--
-- Name: config_function; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_function (
    id integer NOT NULL,
    function_name text NOT NULL,
    style json,
    layermanager json,
    actions json
);


--
-- Name: config_info_layer; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_info_layer (
    layer_id text NOT NULL,
    is_parent boolean,
    tableparent_id text,
    is_editable boolean,
    formtemplate text,
    headertext text,
    orderby integer,
    tableparentepa_id text,
    addparam json
);


--
-- Name: config_info_layer_x_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_info_layer_x_type (
    tableinfo_id character varying(50) NOT NULL,
    infotype_id integer NOT NULL,
    tableinfotype_id text
);


--
-- Name: config_info_layer_x_type_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE config_info_layer_x_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: config_param_system; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_param_system (
    parameter character varying(50) NOT NULL,
    value text,
    descript text,
    label text,
    dv_querytext text,
    dv_filterbyfield text,
    isenabled boolean,
    layoutorder integer,
    project_type character varying,
    dv_isparent boolean,
    isautoupdate boolean,
    datatype character varying,
    widgettype character varying,
    ismandatory boolean,
    iseditable boolean,
    dv_orderby_id boolean,
    dv_isnullvalue boolean,
    stylesheet json,
    widgetcontrols json,
    placeholder text,
    standardvalue text,
    layoutname text
);


--
-- Name: config_param_user; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_param_user (
    parameter character varying(50) NOT NULL,
    value text,
    cur_user character varying(30) NOT NULL
);


--
-- Name: config_report; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_report (
    id integer NOT NULL,
    alias text,
    query_text text,
    addparam json DEFAULT '{"orderBy":"1", "orderType": "DESC"}'::json,
    filterparam json,
    sys_role text,
    descript text,
    active boolean DEFAULT true
);


--
-- Name: config_report_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE config_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: config_report_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE config_report_id_seq OWNED BY config_report.id;


--
-- Name: config_table; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_table (
    id text NOT NULL,
    style integer NOT NULL,
    group_layer text
);


--
-- Name: config_toolbox; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_toolbox (
    id integer NOT NULL,
    alias text,
    functionparams json,
    inputparams json,
    observ text,
    active boolean DEFAULT true
);


--
-- Name: config_typevalue; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_typevalue (
    typevalue character varying(50) NOT NULL,
    id character varying(100) NOT NULL,
    idval character varying(100),
    camelstyle text,
    addparam json
);


--
-- Name: config_user_x_expl; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_user_x_expl (
    expl_id integer NOT NULL,
    username character varying(50) NOT NULL,
    manager_id integer,
    active boolean DEFAULT true
);


--
-- Name: config_user_x_sector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_user_x_sector (
    sector_id integer NOT NULL,
    username character varying(50) NOT NULL,
    manager_id integer,
    active boolean DEFAULT true
);


--
-- Name: config_visit_class; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_visit_class (
    id integer NOT NULL,
    idval character varying(30),
    descript text,
    active boolean DEFAULT true,
    ismultifeature boolean,
    ismultievent boolean,
    feature_type text,
    sys_role character varying(30),
    visit_type integer,
    param_options json,
    formname text,
    tablename text,
    ui_tablename text,
    parent_id integer,
    inherit_values json
);


--
-- Name: COLUMN config_visit_class.ui_tablename; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON COLUMN config_visit_class.ui_tablename IS 'When configure a ui view, this columns are required: *_id, startdate, enddate, class_id::integer';


--
-- Name: config_visit_class_x_feature; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_visit_class_x_feature (
    tablename character varying(30) NOT NULL,
    visitclass_id integer NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: TABLE config_visit_class_x_feature; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE config_visit_class_x_feature IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is mandatory to relate table with visitclass. In case of offline funcionality client devices needs projects with tables related only with one visitclass, 
because on the previous download process only one visitclass form per layer stored on project will be downloaded. 
In case of only online projects more than one visitclass must be related to layer.';


--
-- Name: config_visit_class_x_parameter; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_visit_class_x_parameter (
    class_id integer NOT NULL,
    parameter_id character varying(50) NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: config_visit_parameter; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_visit_parameter (
    id character varying(50) NOT NULL,
    code character varying(30),
    parameter_type character varying(30) NOT NULL,
    feature_type character varying(30),
    data_type character varying(16),
    criticity smallint,
    descript character varying(100),
    form_type character varying(30) NOT NULL,
    vdefault text,
    ismultifeature boolean,
    short_descript character varying(30),
    active boolean DEFAULT true NOT NULL,
    CONSTRAINT config_visit_parameter_feature_type_check CHECK (((feature_type)::text = ANY (ARRAY['ARC'::text, 'NODE'::text, 'CONNEC'::text, 'GULLY'::text, 'ALL'::text])))
);


--
-- Name: config_visit_parameter_action; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_visit_parameter_action (
    parameter_id1 character varying(50) NOT NULL,
    parameter_id2 character varying(50) NOT NULL,
    action_type integer NOT NULL,
    action_value text,
    active boolean DEFAULT true
);


--
-- Name: connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE connec (
    connec_id character varying(30) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
    code character varying(30),
    top_elev numeric(12,4),
    y1 numeric(12,4),
    y2 numeric(12,4),
    connec_type character varying(30) NOT NULL,
    connecat_id character varying(30) NOT NULL,
    sector_id integer NOT NULL,
    customer_code character varying(30),
    private_connecat_id character varying(30),
    demand numeric(12,8),
    state smallint NOT NULL,
    state_type smallint,
    connec_depth numeric(12,3),
    connec_length numeric(12,3),
    arc_id character varying(16),
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    soilcat_id character varying(16),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    descript text,
    link character varying(512),
    verified character varying(20),
    rotation numeric(6,3),
    the_geom public.geometry(Point,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    accessibility boolean,
    diagonal character varying(50),
    publish boolean,
    inventory boolean,
    uncertain boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16) DEFAULT 'CONNEC'::character varying,
    tstamp timestamp without time zone DEFAULT now(),
    pjoint_type character varying(16),
    pjoint_id character varying(16),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50) DEFAULT CURRENT_USER,
    matcat_id character varying(16),
    district_id integer,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    drainzone_id integer,
    expl_id2 integer,
    CONSTRAINT connec_pjoint_type_check CHECK (((pjoint_type)::text = ANY (ARRAY['NODE'::text, 'ARC'::text, 'CONNEC'::text, 'GULLY'::text])))
);


--
-- Name: crm_typevalue; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE crm_typevalue (
    typevalue character varying(50) NOT NULL,
    id character varying(30) NOT NULL,
    idval character varying(100),
    descript text,
    addparam json
);


--
-- Name: dimensions; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE dimensions (
    id bigint NOT NULL,
    distance numeric(12,4),
    depth numeric(12,4),
    the_geom public.geometry(LineString,SRID_VALUE),
    x_label double precision,
    y_label double precision,
    rotation_label double precision,
    offset_label double precision,
    direction_arrow boolean,
    x_symbol double precision,
    y_symbol double precision,
    feature_id character varying,
    feature_type character varying,
    state smallint NOT NULL,
    expl_id integer NOT NULL,
    observ text,
    comment text
);


--
-- Name: dimensions_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE dimensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dimensions_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE dimensions_id_seq OWNED BY dimensions.id;


--
-- Name: dma; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE dma (
    dma_id integer NOT NULL,
    name character varying(30),
    expl_id integer,
    macrodma_id integer,
    descript text,
    undelete boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    minc double precision,
    maxc double precision,
    effc double precision,
    pattern_id character varying(16),
    link text,
    active boolean DEFAULT true,
    tstamp timestamp without time zone DEFAULT now(),
    insert_user character varying(15) DEFAULT CURRENT_USER,
    lastupdate timestamp without time zone,
    lastupdate_user character varying(15)
);


--
-- Name: dma_dma_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE dma_dma_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dma_dma_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE dma_dma_id_seq OWNED BY dma.dma_id;


--
-- Name: doc_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE doc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc (
    id character varying(30) DEFAULT nextval('doc_seq'::regclass) NOT NULL,
    doc_type character varying(30) NOT NULL,
    path character varying(512) NOT NULL,
    observ character varying(512),
    date timestamp(6) without time zone DEFAULT now(),
    user_name character varying(50) DEFAULT USER,
    tstamp timestamp without time zone DEFAULT now()
);


--
-- Name: doc_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc_type (
    id character varying(30) NOT NULL,
    comment character varying(512)
);


--
-- Name: doc_x_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc_x_arc (
    id integer NOT NULL,
    doc_id character varying(30) NOT NULL,
    arc_id character varying(16) NOT NULL
);


--
-- Name: doc_x_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE doc_x_arc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doc_x_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE doc_x_arc_id_seq OWNED BY doc_x_arc.id;


--
-- Name: doc_x_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc_x_connec (
    id integer NOT NULL,
    doc_id character varying(30) NOT NULL,
    connec_id character varying(16) NOT NULL
);


--
-- Name: doc_x_connec_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE doc_x_connec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doc_x_connec_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE doc_x_connec_id_seq OWNED BY doc_x_connec.id;


--
-- Name: doc_x_gully_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE doc_x_gully_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doc_x_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc_x_gully (
    id bigint DEFAULT nextval('doc_x_gully_seq'::regclass) NOT NULL,
    doc_id character varying(30) NOT NULL,
    gully_id character varying(16) NOT NULL
);


--
-- Name: doc_x_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc_x_node (
    id integer NOT NULL,
    doc_id character varying(30) NOT NULL,
    node_id character varying(16) NOT NULL
);


--
-- Name: doc_x_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE doc_x_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doc_x_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE doc_x_node_id_seq OWNED BY doc_x_node.id;


--
-- Name: doc_x_psector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc_x_psector (
    id integer NOT NULL,
    doc_id character varying(30),
    psector_id integer
);


--
-- Name: doc_x_psector_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE doc_x_psector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doc_x_psector_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE doc_x_psector_id_seq OWNED BY doc_x_psector.id;


--
-- Name: doc_x_visit; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc_x_visit (
    id integer NOT NULL,
    doc_id character varying(30) NOT NULL,
    visit_id integer NOT NULL
);


--
-- Name: doc_x_visit_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE doc_x_visit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doc_x_visit_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE doc_x_visit_id_seq OWNED BY doc_x_visit.id;


--
-- Name: doc_x_workcat; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE doc_x_workcat (
    id integer NOT NULL,
    doc_id character varying(30),
    workcat_id character varying(30)
);


--
-- Name: doc_x_workcat_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE doc_x_workcat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doc_x_workcat_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE doc_x_workcat_id_seq OWNED BY doc_x_workcat.id;


--
-- Name: drainzone; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE drainzone (
    drainzone_id integer NOT NULL,
    name character varying(30),
    expl_id INT4 NULL,
    descript text,
    undelete boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    link text,
    graphconfig json DEFAULT '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json,
    stylesheet json,
    active boolean DEFAULT true
);


--
-- Name: drainzone_drainzone_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE drainzone_drainzone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drainzone_drainzone_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE drainzone_drainzone_id_seq OWNED BY drainzone.drainzone_id;


--
-- Name: edit_typevalue; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE edit_typevalue (
    typevalue character varying(50) NOT NULL,
    id character varying(30) NOT NULL,
    idval character varying(100),
    descript text,
    addparam json
);


--
-- Name: element; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE element (
    element_id character varying(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
    code character varying(30),
    elementcat_id character varying(30) NOT NULL,
    serial_number character varying(30),
    num_elements integer,
    state smallint NOT NULL,
    state_type smallint,
    observ character varying(254),
    comment character varying(254),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(30),
    workcat_id_end character varying(30),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    rotation numeric(6,3),
    link character varying(512),
    verified character varying(20),
    the_geom public.geometry(Point,SRID_VALUE),
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    undelete boolean,
    publish boolean,
    inventory boolean,
    expl_id integer,
    feature_type character varying(16) DEFAULT 'ELEMENT'::character varying,
    tstamp timestamp without time zone DEFAULT now(),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50) DEFAULT CURRENT_USER,
    pol_id character varying(16)
);


--
-- Name: element_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE element_type (
    id character varying(30) NOT NULL,
    active boolean,
    code_autofill boolean,
    descript text,
    link_path character varying(254)
);


--
-- Name: element_x_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE element_x_arc (
    id bigint NOT NULL,
    element_id character varying(16) NOT NULL,
    arc_id character varying(16) NOT NULL
);


--
-- Name: element_x_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE element_x_arc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: element_x_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE element_x_arc_id_seq OWNED BY element_x_arc.id;


--
-- Name: element_x_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE element_x_connec (
    id bigint NOT NULL,
    element_id character varying(16) NOT NULL,
    connec_id character varying(16) NOT NULL
);


--
-- Name: element_x_connec_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE element_x_connec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: element_x_connec_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE element_x_connec_id_seq OWNED BY element_x_connec.id;


--
-- Name: element_x_gully_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE element_x_gully_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: element_x_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE element_x_gully (
    id character varying(16) DEFAULT nextval('element_x_gully_seq'::regclass) NOT NULL,
    element_id character varying(16) NOT NULL,
    gully_id character varying(16) NOT NULL
);


--
-- Name: element_x_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE element_x_node (
    id bigint NOT NULL,
    element_id character varying(16) NOT NULL,
    node_id character varying(16) NOT NULL
);


--
-- Name: element_x_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE element_x_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: element_x_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE element_x_node_id_seq OWNED BY element_x_node.id;


--
-- Name: exploitation; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE exploitation (
    expl_id integer NOT NULL,
    name character varying(50) NOT NULL,
    macroexpl_id integer NOT NULL,
    descript text,
    undelete boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    tstamp timestamp without time zone DEFAULT now(),
    active boolean DEFAULT true
);


--
-- Name: ext_address; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_address (
    id character varying(16) NOT NULL,
    muni_id integer NOT NULL,
    postcode character varying(16),
    streetaxis_id character varying(16) NOT NULL,
    postnumber character varying(16) NOT NULL,
    plot_id character varying(16),
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer NOT NULL
);


--
-- Name: ext_address_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


--
-- Name: ext_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_arc (
    id bigint NOT NULL,
    fid integer,
    arc_id character varying(16),
    val double precision,
    tstamp timestamp without time zone,
    observ text,
    cur_user text
);


--
-- Name: ext_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_arc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE ext_arc_id_seq OWNED BY ext_arc.id;


--
-- Name: ext_cat_hydrometer; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_cat_hydrometer (
    id character varying(16) NOT NULL,
    hydrometer_type character varying(100),
    madeby character varying(100),
    class character varying(100),
    ulmc character varying(100),
    voltman_flow character varying(100),
    multi_jet_flow character varying(100),
    dnom character varying(100),
    link character varying(512),
    url character varying(512),
    picture character varying(512),
    svg character varying(50),
    code text,
    observ text
);


--
-- Name: ext_cat_hydrometer_priority; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_cat_hydrometer_priority (
    id integer NOT NULL,
    code character varying(16) NOT NULL,
    observ character varying(100)
);


--
-- Name: ext_cat_hydrometer_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_cat_hydrometer_type (
    id integer NOT NULL,
    code character varying(16) NOT NULL,
    observ character varying(100)
);


--
-- Name: ext_cat_period; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_cat_period (
    id character varying(16) NOT NULL,
    start_date timestamp(6) without time zone,
    end_date timestamp(6) without time zone,
    period_seconds integer,
    comment character varying(100),
    code text,
    period_type integer,
    period_year integer,
    period_name character varying(16),
    expl_id integer[]
);


--
-- Name: ext_cat_period_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_cat_period_type (
    id integer NOT NULL,
    idval character varying(16) NOT NULL,
    descript text
);


--
-- Name: ext_cat_period_type_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_cat_period_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_cat_period_type_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE ext_cat_period_type_id_seq OWNED BY ext_cat_period_type.id;


--
-- Name: ext_cat_raster; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_cat_raster (
    id text NOT NULL,
    code character varying(30),
    alias character varying(50),
    raster_type character varying(30),
    descript text,
    source text,
    provider character varying(30),
    year character varying(4),
    tstamp timestamp without time zone DEFAULT now(),
    insert_user character varying(50) DEFAULT "current_user"()
);


--
-- Name: ext_district; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_district (
    district_id integer NOT NULL,
    name text,
    muni_id integer NOT NULL,
    observ text,
    active boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE)
);


--
-- Name: ext_hydrometer_category; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_hydrometer_category (
    id character varying(16) NOT NULL,
    observ character varying(100),
    code text
);


--
-- Name: ext_hydrometer_category_x_pattern; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_hydrometer_category_x_pattern (
    category_id character varying(16) NOT NULL,
    period_type integer NOT NULL,
    pattern_id character varying(16) NOT NULL,
    observ text
);


--
-- Name: ext_municipality; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_municipality (
    muni_id integer NOT NULL,
    name text NOT NULL,
    expl_id INT4[] NULL,
    sector_id INT4[] NULL,
    observ text,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    active boolean DEFAULT true
);


--
-- Name: ext_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_node (
    id bigint NOT NULL,
    fid integer,
    node_id character varying(16),
    val double precision,
    tstamp timestamp without time zone,
    observ text,
    cur_user text
);


--
-- Name: ext_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE ext_node_id_seq OWNED BY ext_node.id;


--
-- Name: ext_plot; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_plot (
    id character varying(16) NOT NULL,
    plot_code character varying(30),
    muni_id integer NOT NULL,
    postcode character varying(16),
    streetaxis_id character varying(16) NOT NULL,
    postnumber character varying(16),
    complement character varying(16),
    placement character varying(16),
    square character varying(16),
    observ text,
    text text,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    expl_id integer NOT NULL
);


--
-- Name: ext_raster_dem; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_raster_dem (
    id integer NOT NULL,
    rast public.raster,
    rastercat_id text,
    envelope public.geometry(Polygon,SRID_VALUE)
);


--
-- Name: ext_rtc_scada_dma_period_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_rtc_scada_dma_period_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_rtc_dma_period; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_dma_period (
    id bigint DEFAULT nextval('ext_rtc_scada_dma_period_seq'::regclass) NOT NULL,
    dma_id character varying(16),
    m3_total_period double precision,
    cat_period_id character varying(16),
    m3_total_period_hydro double precision,
    effc double precision,
    minc double precision,
    maxc double precision,
    pattern_id character varying(16),
    pattern_volume double precision
);


--
-- Name: ext_rtc_hydrometer; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_hydrometer (
    id character varying(16) NOT NULL,
    code text,
    hydrometer_category text,
    customer_name text,
    address text,
    house_number text,
    id_number text,
    cat_hydrometer_id text,
    start_date date,
    hydro_number text,
    identif text,
    state_id smallint,
    expl_id integer,
    connec_id character varying(30),
    hydrometer_customer_code character varying(30),
    plot_code integer,
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
    m3_volume integer,
    hydro_man_date date,
    end_date date,
    update_date date,
    shutdown_date date
);


--
-- Name: ext_rtc_hydrometer_state; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_hydrometer_state (
    id integer NOT NULL,
    name text NOT NULL,
    observ text
);


--
-- Name: ext_rtc_hydrometer_state_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_rtc_hydrometer_state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_rtc_hydrometer_state_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE ext_rtc_hydrometer_state_id_seq OWNED BY ext_rtc_hydrometer_state.id;


--
-- Name: ext_rtc_hydrometer_x_data_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_rtc_hydrometer_x_data_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_rtc_hydrometer_x_data; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_hydrometer_x_data (
    id bigint DEFAULT nextval('ext_rtc_hydrometer_x_data_seq'::regclass) NOT NULL,
    hydrometer_id character varying(16),
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
    value_state integer
);


--
-- Name: ext_rtc_hydrometer_x_value_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_rtc_hydrometer_x_value_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_rtc_scada_x_data; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_scada_x_data (
    node_id character varying(16) NOT NULL,
    value_date timestamp without time zone NOT NULL,
    value double precision,
    value_type integer,
    value_status integer,
    value_state integer,
    data_type text
);


--
-- Name: ext_rtc_scada_x_data_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_rtc_scada_x_data_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_rtc_scada_x_value_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_rtc_scada_x_value_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_streetaxis; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_streetaxis (
    id character varying(16) NOT NULL,
    code character varying(16),
    type character varying(18),
    name character varying(100) NOT NULL,
    text text,
    the_geom public.geometry(MultiLineString,SRID_VALUE),
    expl_id integer NOT NULL,
    muni_id integer NOT NULL
);


--
-- Name: ext_streetaxis_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_streetaxis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


--
-- Name: ext_timeseries; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_timeseries (
    id integer NOT NULL,
    code text,
    operator_id integer,
    catalog_id text,
    element json,
    param json,
    period json,
    timestep json,
    val double precision[],
    descript text
);


--
-- Name: TABLE ext_timeseries; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE ext_timeseries IS 'INSTRUCIONS TO WORK WITH THIS TABLE:
code: external code or internal identifier....
operator_id, to indetify different operators
catalog_id, imdp, t15, t85, fireindex, sworksindex, treeindex, qualhead, pressure, flow, inflow
element, {"type":"exploitation", 
	    "id":[1,2,3,4]} -- expl_id, muni_id, arc_id, node_id, dma_id, sector_id, dqa_id
param, {"isUnitary":false, it means if sumatory of all values of ts is 1 (true) or not
	"units":"BAR"  in case of no units put any value you want (adimensional, nounits...). WARNING: use CMH or LPS in case of VOLUME patterns for EPANET
 	"epa":{"projectType":"WS", "class":"pattern", "id":"test1", "type":"UNITARY", "dmaRtcParameters":{"dmaId":"", "periodId":""} 
		If this timeseries is used for EPA, please fill this projectType and PatterType. Use ''UNITARY'', for sum of values = 1 or ''VOLUME'', when are real volume values
			If pattern is related to dma x rtc period please fill dmaRtcParameters parameters
	"source":{"type":"flowmeter", "id":"V2323", "import":{"type":"file", "id":"test.csv"}},
period {"type":"monthly", "id":201903", "start":"2019-01-01", "end":"2019-01-02"} 
timestep {"units":"minute", "value":"15", "number":2345}};
val, {1,2,3,4,5,6}
descript text';


--
-- Name: ext_timeseries_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE ext_timeseries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ext_timeseries_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE ext_timeseries_id_seq OWNED BY ext_timeseries.id;


--
-- Name: ext_type_street; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_type_street (
    id character varying(20) NOT NULL,
    observ character varying(50)
);


--
-- Name: gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE gully (
    gully_id character varying(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
    code character varying(30),
    top_elev numeric(12,4),
    ymax numeric(12,4),
    sandbox numeric(12,4),
    matcat_id character varying(18),
    gully_type character varying(30) NOT NULL,
    gratecat_id character varying(30),
    units smallint,
    groove boolean,
    siphon boolean,
    connec_arccat_id character varying(18),
    connec_length numeric(12,3),
    connec_depth numeric(12,3),
    arc_id character varying(16),
    _pol_id_ character varying(16),
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    soilcat_id character varying(16),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    descript text,
    link character varying(512),
    verified character varying(20),
    rotation numeric(6,3),
    the_geom public.geometry(Point,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    uncertain boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16) DEFAULT 'GULLY'::character varying,
    tstamp timestamp without time zone DEFAULT now(),
    pjoint_type character varying(16),
    pjoint_id character varying(16),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50) DEFAULT CURRENT_USER,
    district_id integer,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    connec_matcat_id text,
    connec_y2 numeric(12,3),
    gratecat2_id text,
    epa_type character varying(16) NOT NULL,
    groove_height double precision,
    groove_length double precision,
    units_placement character varying(16),
    drainzone_id integer,
    expl_id2 integer,
    CONSTRAINT gully_pjoint_type_check CHECK (((pjoint_type)::text = ANY (ARRAY['NODE'::text, 'ARC'::text, 'CONNEC'::text, 'GULLY'::text])))
);


--
-- Name: inp_adjustments_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_adjustments_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_adjustments; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_adjustments (
    id character varying(16) DEFAULT nextval('inp_adjustments_seq'::regclass) NOT NULL,
    adj_type character varying(16),
    value_1 numeric(12,4),
    value_2 numeric(12,4),
    value_3 numeric(12,4),
    value_4 numeric(12,4),
    value_5 numeric(12,4),
    value_6 numeric(12,4),
    value_7 numeric(12,4),
    value_8 numeric(12,4),
    value_9 numeric(12,4),
    value_10 numeric(12,4),
    value_11 numeric(12,4),
    value_12 numeric(12,4)
);


--
-- Name: inp_aquifer_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_aquifer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_aquifer; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_aquifer (
    aquif_id character varying(16) DEFAULT nextval('inp_aquifer_seq'::regclass) NOT NULL,
    por numeric(12,4),
    wp numeric(12,4),
    fc numeric(12,4),
    k numeric(12,4),
    ks numeric(12,4),
    ps numeric(12,4),
    uef numeric(12,4),
    led numeric(12,4),
    gwr numeric(12,4),
    be numeric(12,4),
    wte numeric(12,4),
    umc numeric(12,4),
    pattern_id character varying(16)
);


--
-- Name: inp_backdrop_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_backdrop_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_backdrop; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_backdrop (
    id integer DEFAULT nextval('inp_backdrop_seq'::regclass) NOT NULL,
    text character varying(254)
);


--
-- Name: inp_buildup; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_buildup (
    landus_id character varying(16) NOT NULL,
    poll_id character varying(16) NOT NULL,
    funcb_type character varying(18),
    c1 numeric(12,4),
    c2 numeric(12,4),
    c3 numeric(12,4),
    perunit character varying(10)
);


--
-- Name: inp_conduit; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_conduit (
    arc_id character varying(50) NOT NULL,
    barrels smallint,
    culvert character varying(10),
    kentry numeric(12,4),
    kexit numeric(12,4),
    kavg numeric(12,4),
    flap character varying(3),
    q0 numeric(12,4),
    qmax numeric(12,4),
    seepage numeric(12,4),
    custom_n numeric(12,4)
);


--
-- Name: inp_controls; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_controls (
    id integer NOT NULL,
    sector_id integer NOT NULL,
    text text NOT NULL,
    active boolean
);


--
-- Name: inp_controls_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_controls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_controls_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_controls_id_seq OWNED BY inp_controls.id;


--
-- Name: inp_coverage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_coverage (
    subc_id character varying(16) NOT NULL,
    landus_id character varying(16) NOT NULL,
    percent numeric(12,4) NOT NULL,
    hydrology_id integer NOT NULL
);


--
-- Name: inp_curve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_curve (
    id character varying(16) NOT NULL,
    curve_type character varying(20) NOT NULL,
    descript text,
    expl_id integer,
    log text
);


--
-- Name: inp_curve_value_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_curve_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_curve_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_curve_value (
    id integer DEFAULT nextval('inp_curve_value_id_seq'::regclass) NOT NULL,
    curve_id character varying(16) NOT NULL,
    x_value numeric(18,6) NOT NULL,
    y_value numeric(18,6) NOT NULL
);


--
-- Name: inp_divider; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_divider (
    node_id character varying(50) NOT NULL,
    divider_type character varying(18),
    arc_id character varying(50),
    curve_id character varying(16),
    qmin numeric(16,6),
    ht numeric(12,4),
    cd numeric(12,4),
    y0 numeric(12,4),
    ysur numeric(12,4),
    apond numeric(12,4)
);


--
-- Name: inp_dscenario_conduit; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_conduit (
    dscenario_id integer NOT NULL,
    arc_id character varying(50) NOT NULL,
    arccat_id character varying(30),
    matcat_id character varying(30),
    custom_n numeric(12,4),
    barrels smallint,
    culvert character varying(10),
    kentry numeric(12,4),
    kexit numeric(12,4),
    kavg numeric(12,4),
    flap character varying(3),
    q0 numeric(12,4),
    qmax numeric(12,4),
    seepage numeric(12,4),
    elev1 numeric(12,3),
    elev2 numeric(12,3)
);


--
-- Name: inp_dscenario_controls; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_controls (
    id integer NOT NULL,
    dscenario_id integer NOT NULL,
    sector_id integer NOT NULL,
    text text NOT NULL,
    active boolean
);


--
-- Name: inp_dscenario_controls_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_dscenario_controls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_dscenario_controls_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_dscenario_controls_id_seq OWNED BY inp_dscenario_controls.id;


--
-- Name: inp_dscenario_flwreg_orifice; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_flwreg_orifice (
    dscenario_id integer NOT NULL,
    nodarc_id character varying(20) NOT NULL,
    ori_type character varying(18),
    offsetval numeric(12,4),
    cd numeric(12,4) NOT NULL,
    orate numeric(12,4),
    flap character varying(3) NOT NULL,
    shape character varying(18) NOT NULL,
    geom1 numeric(12,4) NOT NULL,
    geom2 numeric(12,4) DEFAULT 0.00 NOT NULL,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    close_time integer DEFAULT 0,
    CONSTRAINT inp_dscenario_flwreg_orifice_check_ory_type CHECK (((ori_type)::text = ANY (ARRAY[('SIDE'::character varying)::text, ('BOTTOM'::character varying)::text]))),
    CONSTRAINT inp_dscenario_flwreg_orifice_check_shape CHECK (((shape)::text = ANY (ARRAY[('CIRCULAR'::character varying)::text, ('RECT_CLOSED'::character varying)::text])))
);


--
-- Name: inp_dscenario_flwreg_outlet; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_flwreg_outlet (
    dscenario_id integer NOT NULL,
    nodarc_id character varying(20) NOT NULL,
    outlet_type character varying(16),
    offsetval numeric(12,4),
    curve_id character varying(16),
    cd1 numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    CONSTRAINT inp_dscenario_flwreg_outlet_check_type CHECK (((outlet_type)::text = ANY (ARRAY[('FUNCTIONAL/DEPTH'::character varying)::text, ('FUNCTIONAL/HEAD'::character varying)::text, ('TABULAR/DEPTH'::character varying)::text, ('TABULAR/HEAD'::character varying)::text])))
);


--
-- Name: inp_dscenario_flwreg_pump; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_flwreg_pump (
    dscenario_id integer NOT NULL,
    nodarc_id character varying(20) NOT NULL,
    curve_id character varying(16) NOT NULL,
    status character varying(3),
    startup numeric(12,4),
    shutoff numeric(12,4),
    CONSTRAINT inp_dscenario_flwreg_pump_check_status CHECK (((status)::text = ANY (ARRAY[('ON'::character varying)::text, ('OFF'::character varying)::text])))
);


--
-- Name: inp_dscenario_flwreg_weir; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_flwreg_weir (
    dscenario_id integer NOT NULL,
    nodarc_id character varying(20) NOT NULL,
    weir_type character varying(18),
    offsetval numeric(12,4),
    cd numeric(12,4),
    ec numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    geom1 numeric(12,4),
    geom2 numeric(12,4) DEFAULT 0.00,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    surcharge character varying(3),
    road_width double precision,
    road_surf character varying(16),
    coef_curve double precision,
    CONSTRAINT inp_dscenario_flwreg_weir_check_type CHECK (((weir_type)::text = ANY (ARRAY['SIDEFLOW'::text, 'TRANSVERSE'::text, 'V-NOTCH'::text, 'TRAPEZOIDAL_WEIR'::text])))
);


--
-- Name: inp_dscenario_inflows; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_inflows (
    dscenario_id integer NOT NULL,
    node_id character varying(50) NOT NULL,
    order_id integer NOT NULL,
    timser_id character varying(16),
    sfactor numeric(12,4),
    base numeric(12,4),
    pattern_id character varying(16)
);


--
-- Name: inp_dscenario_inflows_poll; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_inflows_poll (
    dscenario_id integer NOT NULL,
    node_id character varying(50) NOT NULL,
    poll_id character varying(16) NOT NULL,
    timser_id character varying(16),
    form_type character varying(18),
    mfactor numeric(12,4),
    sfactor numeric(12,4),
    base numeric(12,4),
    pattern_id character varying(16)
);


--
-- Name: inp_dscenario_junction; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_junction (
    dscenario_id integer NOT NULL,
    node_id character varying(50) NOT NULL,
    y0 numeric(12,4),
    ysur numeric(12,4),
    apond numeric(12,4),
    outfallparam json,
    elev double precision,
    ymax double precision
);


--
-- Name: inp_dscenario_lid_usage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_lid_usage (
    dscenario_id integer NOT NULL,
    subc_id character varying(16) NOT NULL,
    lidco_id character varying(16) NOT NULL,
    numelem smallint,
    area numeric(16,6),
    width numeric(12,4),
    initsat numeric(12,4),
    fromimp numeric(12,4),
    toperv smallint,
    rptfile character varying(10),
    descript text
);


--
-- Name: inp_dscenario_outfall; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_outfall (
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    elev numeric(12,3),
    ymax numeric(12,3),
    outfall_type character varying(16),
    stage numeric(12,4),
    curve_id character varying(16),
    timser_id character varying(16),
    gate character varying(3)
);


--
-- Name: inp_dscenario_raingage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_raingage (
    dscenario_id integer NOT NULL,
    rg_id character varying(16) NOT NULL,
    form_type character varying(12),
    intvl character varying(10),
    scf numeric(12,4) DEFAULT 1.00,
    rgage_type character varying(18),
    timser_id character varying(16),
    fname character varying(254),
    sta character varying(12),
    units character varying(3)
);


--
-- Name: inp_dscenario_storage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_storage (
    dscenario_id integer NOT NULL,
    node_id character varying(50) NOT NULL,
    elev numeric(12,3),
    ymax numeric(12,3),
    storage_type character varying(18),
    curve_id character varying(16),
    a1 numeric(12,4),
    a2 numeric(12,4),
    a0 numeric(12,4),
    fevap numeric(12,4),
    sh numeric(12,4),
    hc numeric(12,4),
    imd numeric(12,4),
    y0 numeric(12,4),
    ysur numeric(12,4),
    apond numeric(12,4)
);


--
-- Name: inp_dscenario_treatment; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_treatment (
    dscenario_id integer NOT NULL,
    node_id character varying(50) NOT NULL,
    poll_id character varying(16) NOT NULL,
    function character varying(100)
);


--
-- Name: inp_dwf; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dwf (
    node_id character varying(50) NOT NULL,
    value numeric(12,7),
    pat1 character varying(16),
    pat2 character varying(16),
    pat3 character varying(16),
    pat4 character varying(16),
    dwfscenario_id integer NOT NULL
);


--
-- Name: inp_dwf_pol_x_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dwf_pol_x_node (
    poll_id character varying(16) NOT NULL,
    node_id character varying(50) NOT NULL,
    value numeric(12,4),
    pat1 character varying(16),
    pat2 character varying(16),
    pat3 character varying(16),
    pat4 character varying(16),
    dwfscenario_id integer NOT NULL
);


--
-- Name: inp_dwf_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_dwf_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_evaporation; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_evaporation (
    evap_type character varying(16) NOT NULL,
    value text
);


--
-- Name: inp_files_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_files_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_files; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_files (
    id integer DEFAULT nextval('inp_files_seq'::regclass) NOT NULL,
    actio_type character varying(18),
    file_type character varying(18),
    fname character varying(254),
    active boolean
);


--
-- Name: inp_flwreg_orifice; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_flwreg_orifice (
    id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    to_arc character varying(16) NOT NULL,
    order_id smallint NOT NULL,
    flwreg_length double precision NOT NULL,
    ori_type character varying(18) NOT NULL,
    offsetval numeric(12,4),
    cd numeric(12,4) NOT NULL,
    orate numeric(12,4),
    flap character varying(3) NOT NULL,
    shape character varying(18) NOT NULL,
    geom1 numeric(12,4) NOT NULL,
    geom2 numeric(12,4) DEFAULT 0.00 NOT NULL,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    close_time integer,
    nodarc_id character varying(20),
    CONSTRAINT inp_flwreg_orifice_check CHECK ((order_id = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9]))),
    CONSTRAINT inp_flwreg_orifice_check_ory_type CHECK (((ori_type)::text = ANY ((ARRAY['SIDE'::character varying, 'BOTTOM'::character varying])::text[]))),
    CONSTRAINT inp_flwreg_orifice_check_shape CHECK (((shape)::text = ANY (ARRAY[('CIRCULAR'::character varying)::text, ('RECT_CLOSED'::character varying)::text])))
);


--
-- Name: inp_flwreg_orifice_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_flwreg_orifice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_flwreg_orifice_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_flwreg_orifice_id_seq OWNED BY inp_flwreg_orifice.id;


--
-- Name: inp_flwreg_outlet; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_flwreg_outlet (
    id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    to_arc character varying(16) NOT NULL,
    order_id smallint NOT NULL,
    flwreg_length double precision NOT NULL,
    outlet_type character varying(16) NOT NULL,
    offsetval numeric(12,4),
    curve_id character varying(16),
    cd1 numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    nodarc_id character varying(20),
    CONSTRAINT inp_flwreg_outlet_check CHECK ((order_id = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9]))),
    CONSTRAINT inp_flwreg_outlet_check_type CHECK (((outlet_type)::text = ANY ((ARRAY['FUNCTIONAL/DEPTH'::character varying, 'FUNCTIONAL/HEAD'::character varying, 'TABULAR/DEPTH'::character varying, 'TABULAR/HEAD'::character varying])::text[])))
);


--
-- Name: inp_flwreg_outlet_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_flwreg_outlet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_flwreg_outlet_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_flwreg_outlet_id_seq OWNED BY inp_flwreg_outlet.id;


--
-- Name: inp_flwreg_pump; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_flwreg_pump (
    id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    to_arc character varying(16) NOT NULL,
    order_id smallint NOT NULL,
    flwreg_length double precision NOT NULL,
    curve_id character varying(16) NOT NULL,
    status character varying(3),
    startup numeric(12,4),
    shutoff numeric(12,4),
    nodarc_id character varying(20),
    CONSTRAINT inp_flwreg_pump_check CHECK ((order_id = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9]))),
    CONSTRAINT inp_flwreg_pump_check_status CHECK (((status)::text = ANY ((ARRAY['ON'::character varying, 'OFF'::character varying])::text[])))
);


--
-- Name: inp_flwreg_pump_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_flwreg_pump_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_flwreg_pump_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_flwreg_pump_id_seq OWNED BY inp_flwreg_pump.id;


--
-- Name: inp_flwreg_weir; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_flwreg_weir (
    id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    to_arc character varying(16) NOT NULL,
    order_id smallint NOT NULL,
    flwreg_length double precision NOT NULL,
    weir_type character varying(18) NOT NULL,
    offsetval numeric(12,4),
    cd numeric(12,4),
    ec numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    geom1 numeric(12,4),
    geom2 numeric(12,4) DEFAULT 0.00,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    surcharge character varying(3),
    road_width double precision,
    road_surf character varying(16),
    coef_curve double precision,
    nodarc_id character varying(20),
    CONSTRAINT inp_flwreg_weir_check CHECK ((order_id = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9]))),
    CONSTRAINT inp_flwreg_weir_check_type CHECK (((weir_type)::text = ANY (ARRAY['SIDEFLOW'::text, 'TRANSVERSE'::text, 'V-NOTCH'::text, 'TRAPEZOIDAL'::text])))
);


--
-- Name: inp_flwreg_weir_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_flwreg_weir_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_flwreg_weir_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_flwreg_weir_id_seq OWNED BY inp_flwreg_weir.id;


--
-- Name: inp_groundwater; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_groundwater (
    subc_id character varying(16) NOT NULL,
    aquif_id character varying(16) NOT NULL,
    node_id character varying(50),
    surfel numeric(10,4),
    a1 numeric(10,4),
    b1 numeric(10,4),
    a2 numeric(10,4),
    b2 numeric(10,4),
    a3 numeric(10,4),
    tw numeric(10,4),
    h numeric(10,4),
    fl_eq_lat character varying(50),
    fl_eq_deep character varying(50),
    hydrology_id integer NOT NULL
);


--
-- Name: inp_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_gully (
    gully_id character varying(16) NOT NULL,
    outlet_type character varying(30),
    custom_top_elev double precision,
    custom_width double precision,
    custom_length double precision,
    custom_depth double precision,
    method character varying(30),
    weir_cd double precision,
    orifice_cd double precision,
    custom_a_param double precision,
    custom_b_param double precision,
    efficiency double precision
);


--
-- Name: inp_hydrograph; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_hydrograph (
    id character varying(16) NOT NULL
);


--
-- Name: inp_hydrograph_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_hydrograph_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_hydrograph_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_hydrograph_value (
    id integer DEFAULT nextval('inp_hydrograph_seq'::regclass) NOT NULL,
    text character varying(254)
);


--
-- Name: inp_inflows_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_inflows_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_inflows; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_inflows (
    order_id integer DEFAULT nextval('inp_inflows_seq'::regclass) NOT NULL,
    node_id character varying(50),
    timser_id character varying(16),
    sfactor numeric(12,4),
    base numeric(12,4),
    pattern_id character varying(16)
);


--
-- Name: inp_inflows_poll; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_inflows_poll (
    poll_id character varying(16) NOT NULL,
    node_id character varying(50) NOT NULL,
    timser_id character varying(16),
    form_type character varying(18),
    mfactor numeric(12,4),
    sfactor numeric(12,4),
    base numeric(12,4),
    pattern_id character varying(16)
);


--
-- Name: inp_junction; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_junction (
    node_id character varying(50) NOT NULL,
    y0 numeric(12,4),
    ysur numeric(12,4),
    apond numeric(12,4),
    outfallparam json
);


--
-- Name: inp_label; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_label (
    label text NOT NULL,
    xcoord numeric(18,6),
    ycoord numeric(18,6),
    anchor character varying(16),
    font character varying(50),
    size integer,
    bold character varying(3),
    italic character varying(3)
);


--
-- Name: inp_landuses; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_landuses (
    landus_id character varying(16) NOT NULL,
    sweepint numeric(12,4),
    availab numeric(12,4),
    lastsweep numeric(12,4)
);


--
-- Name: inp_lid; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_lid (
    lidco_id character varying(16) NOT NULL,
    lidco_type character varying(10) NOT NULL,
    observ text,
    log text
);


--
-- Name: inp_lid_control_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_lid_control_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_lid_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_lid_value (
    id integer NOT NULL,
    lidco_id character varying(16) NOT NULL,
    lidlayer character varying(10) NOT NULL,
    value_2 numeric(12,4),
    value_3 numeric(12,4),
    value_4 numeric(12,4),
    value_5 numeric(12,4),
    value_6 text,
    value_7 text,
    value_8 text
);


--
-- Name: inp_lid_value_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_lid_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_lid_value_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_lid_value_id_seq OWNED BY inp_lid_value.id;


--
-- Name: inp_loadings; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_loadings (
    poll_id character varying(16) NOT NULL,
    subc_id character varying(16) NOT NULL,
    ibuildup numeric(12,4),
    hydrology_id integer NOT NULL
);


--
-- Name: inp_mapdim; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_mapdim (
    type_dim character varying(18) NOT NULL,
    x1 numeric(18,6),
    y1 numeric(18,6),
    x2 numeric(18,6),
    y2 numeric(18,6)
);


--
-- Name: inp_mapdim_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_mapdim_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_mapunits; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_mapunits (
    type_units character varying(18) NOT NULL,
    map_type character varying(18)
);


--
-- Name: inp_mapunits_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_mapunits_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_netgully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_netgully (
    node_id character varying(16) NOT NULL,
    y0 numeric(12,4),
    ysur numeric(12,4),
    apond numeric(12,4),
    outlet_type character varying(30),
    custom_width double precision,
    custom_length double precision,
    custom_depth double precision,
    method character varying(30),
    weir_cd double precision,
    orifice_cd double precision,
    custom_a_param double precision,
    custom_b_param double precision,
    efficiency double precision
);


--
-- Name: inp_options_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_options_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_orifice; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_orifice (
    arc_id character varying(16) NOT NULL,
    ori_type character varying(18),
    offsetval numeric(12,4),
    cd numeric(12,4),
    orate numeric(12,4),
    flap character varying(3),
    shape character varying(18),
    geom1 numeric(12,4),
    geom2 numeric(12,4) DEFAULT 0.00,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    close_time integer
);


--
-- Name: inp_outfall; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_outfall (
    node_id character varying(16) NOT NULL,
    outfall_type character varying(16),
    stage numeric(12,4),
    curve_id character varying(16),
    timser_id character varying(16),
    gate character varying(3)
);


--
-- Name: inp_outlet; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_outlet (
    arc_id character varying(16) NOT NULL,
    outlet_type character varying(16),
    offsetval numeric(12,4),
    curve_id character varying(16),
    cd1 numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3)
);


--
-- Name: inp_pattern; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pattern (
    pattern_id character varying(16) NOT NULL,
    pattern_type character varying(30),
    observ text,
    tsparameters json,
    expl_id integer,
    log text
);


--
-- Name: inp_pattern_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pattern_value (
    pattern_id character varying(16) NOT NULL,
    factor_1 numeric(12,4),
    factor_2 numeric(12,4),
    factor_3 numeric(12,4),
    factor_4 numeric(12,4),
    factor_5 numeric(12,4),
    factor_6 numeric(12,4),
    factor_7 numeric(12,4),
    factor_8 numeric(12,4),
    factor_9 numeric(12,4),
    factor_10 numeric(12,4),
    factor_11 numeric(12,4),
    factor_12 numeric(12,4),
    factor_13 numeric(12,4),
    factor_14 numeric(12,4),
    factor_15 numeric(12,4),
    factor_16 numeric(12,4),
    factor_17 numeric(12,4),
    factor_18 numeric(12,4),
    factor_19 numeric(12,4),
    factor_20 numeric(12,4),
    factor_21 numeric(12,4),
    factor_22 numeric(12,4),
    factor_23 numeric(12,4),
    factor_24 numeric(12,4)
);


--
-- Name: inp_pollutant; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pollutant (
    poll_id character varying(16) NOT NULL,
    units_type character varying(18),
    crain numeric(12,4),
    cgw numeric(12,4),
    cii numeric(12,4),
    kd numeric(12,4),
    sflag character varying(3),
    copoll_id character varying(16),
    cofract numeric(12,4),
    cdwf numeric(12,4),
    cinit numeric(12,4)
);


--
-- Name: inp_project_id; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_project_id (
    title character varying(254) NOT NULL,
    author character varying(50),
    date character varying(12)
);


--
-- Name: inp_project_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_project_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_pump; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pump (
    arc_id character varying(16) NOT NULL,
    curve_id character varying(16),
    status character varying(3),
    startup numeric(12,4),
    shutoff numeric(12,4)
);


--
-- Name: inp_rdii; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_rdii (
    node_id character varying(50) NOT NULL,
    hydro_id character varying(16),
    sewerarea numeric(16,6)
);


--
-- Name: inp_report_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_report_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_sector_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_sector_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_snowmelt; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_snowmelt (
    stemp numeric(12,4) NOT NULL,
    atiwt numeric(12,4),
    rnm numeric(12,4),
    elev numeric(12,4),
    lat numeric(12,4),
    dtlong numeric(12,4),
    i_f0 numeric(12,4),
    i_f1 numeric(12,4),
    i_f2 numeric(12,4),
    i_f3 numeric(12,4),
    i_f4 numeric(12,4),
    i_f5 numeric(12,4),
    i_f6 numeric(12,4),
    i_f7 numeric(12,4),
    i_f8 numeric(12,4),
    i_f9 numeric(12,4),
    p_f0 numeric(12,4),
    p_f1 numeric(12,4),
    p_f2 numeric(12,4),
    p_f3 numeric(12,4),
    p_f4 numeric(12,4),
    p_f5 numeric(12,4),
    p_f6 numeric(12,4),
    p_f7 numeric(12,4),
    p_f8 numeric(12,4),
    p_f9 numeric(12,4)
);


--
-- Name: inp_snowpack; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_snowpack (
    snow_id character varying(16) NOT NULL,
    observ text
);


--
-- Name: inp_snowpack_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_snowpack_value (
    id integer NOT NULL,
    snow_id character varying(16) NOT NULL,
    snow_type character varying(16),
    value_1 numeric(12,3),
    value_2 numeric(12,3),
    value_3 numeric(12,3),
    value_4 numeric(12,3),
    value_5 numeric(12,3),
    value_6 numeric(12,3),
    value_7 numeric(12,3)
);


--
-- Name: inp_snowpack_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_snowpack_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_snowpack_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_snowpack_id_seq OWNED BY inp_snowpack_value.id;


--
-- Name: inp_storage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_storage (
    node_id character varying(50) NOT NULL,
    storage_type character varying(18),
    curve_id character varying(16),
    a1 numeric(12,4),
    a2 numeric(12,4),
    a0 numeric(12,4),
    fevap numeric(12,4),
    sh numeric(12,4),
    hc numeric(12,4),
    imd numeric(12,4),
    y0 numeric(12,4),
    ysur numeric(12,4),
    apond numeric(12,4)
);


--
-- Name: inp_subcatchment; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_subcatchment (
    subc_id character varying(16) NOT NULL,
    outlet_id character varying(100),
    rg_id character varying(16),
    area numeric(16,6),
    imperv numeric(12,4) DEFAULT 90,
    width numeric(12,4),
    slope numeric(12,4),
    clength numeric(12,4),
    snow_id character varying(16),
    nimp numeric(12,4) DEFAULT 0.01,
    nperv numeric(12,4) DEFAULT 0.1,
    simp numeric(12,4) DEFAULT 0.05,
    sperv numeric(12,4) DEFAULT 0.05,
    zero numeric(12,4) DEFAULT 25,
    routeto character varying(20),
    rted numeric(12,4) DEFAULT 100,
    maxrate numeric(12,4),
    minrate numeric(12,4),
    decay numeric(12,4),
    drytime numeric(12,4),
    maxinfil numeric(12,4),
    suction numeric(12,4),
    conduct numeric(12,4),
    initdef numeric(12,4),
    curveno numeric(12,4),
    conduct_2 numeric(12,4) DEFAULT 0,
    drytime_2 numeric(12,4) DEFAULT 10,
    sector_id integer,
    hydrology_id integer DEFAULT 1 NOT NULL,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    descript text,
    nperv_pattern_id character varying(16),
    dstore_pattern_id character varying(16),
    infil_pattern_id character varying(16)
);


--
-- Name: inp_subcatchment_subc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_subcatchment_subc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_temperature; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_temperature (
    id integer NOT NULL,
    temp_type character varying(60),
    value text
);


--
-- Name: inp_temperature_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_temperature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_temperature_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_temperature_id_seq OWNED BY inp_temperature.id;


--
-- Name: inp_timeseries; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_timeseries (
    id character varying(16) NOT NULL,
    timser_type character varying(20),
    times_type character varying(16),
    idval character varying(50),
    descript text,
    fname character varying(254),
    expl_id integer,
    log text,
    active boolean DEFAULT true
);


--
-- Name: inp_timeseries_value_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_timeseries_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_timeseries_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_timeseries_value (
    id integer DEFAULT nextval('inp_timeseries_value_id_seq'::regclass) NOT NULL,
    timser_id character varying(16),
    date character varying(12),
    hour character varying(10),
    "time" character varying(10),
    value numeric(12,4)
);


--
-- Name: inp_transects; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_transects (
    id character varying(16) NOT NULL
);


--
-- Name: inp_transects_value_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_transects_value_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_transects_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_transects_value (
    id integer DEFAULT nextval('inp_transects_value_seq'::regclass) NOT NULL,
    tsect_id character varying(16),
    text text
);


--
-- Name: inp_treatment; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_treatment (
    node_id character varying(50) NOT NULL,
    poll_id character varying(16),
    function character varying(100)
);


--
-- Name: inp_typevalue; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_typevalue (
    typevalue character varying(50) NOT NULL,
    id character varying(30) NOT NULL,
    idval character varying(30),
    descript text,
    addparam json
);


--
-- Name: inp_virtual; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_virtual (
    arc_id character varying(16) NOT NULL,
    fusion_node character varying(16),
    add_length boolean
);


--
-- Name: inp_washoff; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_washoff (
    landus_id character varying(16) NOT NULL,
    poll_id character varying(16) NOT NULL,
    funcw_type character varying(18),
    c1 numeric(12,4),
    c2 numeric(12,4),
    sweepeffic numeric(12,4),
    bmpeffic numeric(12,4)
);


--
-- Name: inp_weir; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_weir (
    arc_id character varying(16) NOT NULL,
    weir_type character varying(18),
    offsetval numeric(12,4),
    cd numeric(12,4),
    ec numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    geom1 numeric(12,4),
    geom2 numeric(12,4) DEFAULT 0.00,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    surcharge character varying(3),
    road_width double precision,
    road_surf character varying(16),
    coef_curve double precision
);


--
-- Name: link; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE link (
    link_id integer NOT NULL,
    feature_id character varying(16),
    feature_type character varying(16),
    exit_id character varying(16),
    exit_type character varying(16),
    userdefined_geom boolean,
    state smallint NOT NULL,
    expl_id integer NOT NULL,
    the_geom public.geometry(LineString,SRID_VALUE),
    tstamp timestamp without time zone DEFAULT now(),
    exit_topelev double precision,
    sector_id integer,
    dma_id integer,
    fluid_type character varying(16),
    exit_elev numeric(12,3),
    expl_id2 integer
);


--
-- Name: link_link_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE link_link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: link_link_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE link_link_id_seq OWNED BY link.link_id;


--
-- Name: macrodma; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE macrodma (
    macrodma_id integer NOT NULL,
    name character varying(50) NOT NULL,
    expl_id integer NOT NULL,
    descript text,
    undelete boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    active boolean DEFAULT true
);


--
-- Name: macrodma_macrodma_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE macrodma_macrodma_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: macrodma_macrodma_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE macrodma_macrodma_id_seq OWNED BY macrodma.macrodma_id;


--
-- Name: macroexploitation; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE macroexploitation (
    macroexpl_id integer NOT NULL,
    name character varying(50) NOT NULL,
    descript character varying(100),
    undelete boolean,
    active boolean DEFAULT true
);


--
-- Name: macrosector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE macrosector (
    macrosector_id integer NOT NULL,
    name character varying(50) NOT NULL,
    descript text,
    undelete boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    active boolean DEFAULT true
);


--
-- Name: macrosector_macrosector_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE macrosector_macrosector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: macrosector_macrosector_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE macrosector_macrosector_id_seq OWNED BY macrosector.macrosector_id;


--
-- Name: man_addfields_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_addfields_value (
    id bigint NOT NULL,
    feature_id character varying(16) NOT NULL,
    parameter_id integer NOT NULL,
    value_param text
);


--
-- Name: man_addfields_value_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE man_addfields_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: man_addfields_value_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE man_addfields_value_id_seq OWNED BY man_addfields_value.id;


--
-- Name: man_chamber; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_chamber (
    node_id character varying(16) NOT NULL,
    _pol_id_ character varying(16),
    length numeric(12,3) DEFAULT 0,
    width numeric(12,3) DEFAULT 0,
    sander_depth numeric(12,3),
    max_volume numeric(12,3),
    util_volume numeric(12,3),
    inlet boolean,
    bottom_channel boolean,
    accessibility character varying(16),
    name character varying(255)
);


--
-- Name: man_conduit; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_conduit (
    arc_id character varying(16) NOT NULL,
    inlet_offset double precision
);


--
-- Name: man_junction; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_junction (
    node_id character varying(16) NOT NULL
);


--
-- Name: man_manhole; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_manhole (
    node_id character varying(16) NOT NULL,
    length numeric(12,3) DEFAULT 0,
    width numeric(12,3) DEFAULT 0,
    sander_depth numeric(12,3),
    prot_surface boolean,
    inlet boolean,
    bottom_channel boolean,
    accessibility character varying(16),
    step_pp integer,
    step_fe integer,
    step_replace integer,
    cover text
);


--
-- Name: man_netelement; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_netelement (
    node_id character varying(16) NOT NULL,
    serial_number character varying(30)
);


--
-- Name: man_netgully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_netgully (
    node_id character varying(16) NOT NULL,
    _pol_id_ character varying(16),
    sander_depth numeric(12,4),
    gratecat_id character varying(18),
    units smallint,
    groove boolean,
    siphon boolean,
    gratecat2_id text,
    groove_height double precision,
    groove_length double precision,
    units_placement character varying(16)
);


--
-- Name: man_netinit; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_netinit (
    node_id character varying(16) NOT NULL,
    length numeric(12,3) DEFAULT 0,
    width numeric(12,3) DEFAULT 0,
    inlet boolean,
    bottom_channel boolean,
    accessibility character varying(16),
    name character varying(50),
    sander_depth numeric(12,3)
);


--
-- Name: man_outfall; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_outfall (
    node_id character varying(16) NOT NULL,
    name character varying(255)
);


--
-- Name: man_siphon; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_siphon (
    arc_id character varying(16) NOT NULL,
    name character varying(255)
);


--
-- Name: man_storage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_storage (
    node_id character varying(16) NOT NULL,
    _pol_id_ character varying(16),
    length numeric(12,3) DEFAULT 0,
    width numeric(12,3) DEFAULT 0,
    custom_area numeric(12,3),
    max_volume numeric(12,3),
    util_volume numeric(12,3),
    min_height numeric(12,3),
    accessibility character varying(16),
    name character varying(255)
);


--
-- Name: man_type_category; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_type_category (
    id integer NOT NULL,
    category_type character varying(50) NOT NULL,
    feature_type character varying(30),
    featurecat_id character varying(300),
    observ character varying(150),
    active boolean DEFAULT true
);


--
-- Name: man_type_category_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE man_type_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: man_type_category_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE man_type_category_id_seq OWNED BY man_type_category.id;


--
-- Name: man_type_fluid; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_type_fluid (
    id integer NOT NULL,
    fluid_type character varying(50) NOT NULL,
    feature_type character varying(30),
    featurecat_id character varying(300),
    observ character varying(150),
    active boolean DEFAULT true
);


--
-- Name: man_type_fluid_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE man_type_fluid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: man_type_fluid_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE man_type_fluid_id_seq OWNED BY man_type_fluid.id;


--
-- Name: man_type_function; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_type_function (
    id integer NOT NULL,
    function_type character varying(50) NOT NULL,
    feature_type character varying(30),
    featurecat_id character varying(300),
    observ character varying(150),
    active boolean DEFAULT true
);


--
-- Name: man_type_function_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE man_type_function_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: man_type_function_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE man_type_function_id_seq OWNED BY man_type_function.id;


--
-- Name: man_type_location; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_type_location (
    id integer NOT NULL,
    location_type character varying(50) NOT NULL,
    feature_type character varying(30),
    featurecat_id character varying(300),
    observ character varying(150),
    active boolean DEFAULT true
);


--
-- Name: man_type_location_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE man_type_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: man_type_location_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE man_type_location_id_seq OWNED BY man_type_location.id;


--
-- Name: man_valve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_valve (
    node_id character varying(16) NOT NULL,
    name character varying(255)
);


--
-- Name: man_varc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_varc (
    arc_id character varying(16) NOT NULL
);


--
-- Name: man_waccel; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_waccel (
    arc_id character varying(16) NOT NULL,
    sander_length numeric(12,3),
    sander_depth numeric(12,3),
    prot_surface boolean,
    accessibility character varying(16),
    name character varying(255)
);


--
-- Name: man_wjump; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_wjump (
    node_id character varying(16) NOT NULL,
    length numeric(12,3) DEFAULT 0,
    width numeric(12,3) DEFAULT 0,
    sander_depth numeric(12,3),
    prot_surface boolean,
    accessibility character varying(16),
    name character varying(255)
);


--
-- Name: man_wwtp; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_wwtp (
    node_id character varying(16) NOT NULL,
    _pol_id_ character varying(16),
    name character varying(255)
);


--
-- Name: node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE node (
    node_id character varying(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
    code character varying(30),
    top_elev numeric(12,3),
    ymax numeric(12,3),
    elev numeric(12,3),
    custom_top_elev numeric(12,3),
    custom_ymax numeric(12,3),
    custom_elev numeric(12,3),
    node_type character varying(30) NOT NULL,
    nodecat_id character varying(30) NOT NULL,
    epa_type character varying(16) NOT NULL,
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint,
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    soilcat_id character varying(16),
    function_type character varying(50),
    category_type character varying(50),
    fluid_type character varying(50),
    location_type character varying(50),
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    buildercat_id character varying(30),
    builtdate date,
    enddate date,
    ownercat_id character varying(30),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    descript text,
    rotation numeric(6,3),
    link character varying(512),
    verified character varying(20),
    the_geom public.geometry(Point,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    xyz_date date,
    uncertain boolean,
    unconnected boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16) DEFAULT 'NODE'::character varying,
    tstamp timestamp without time zone DEFAULT now(),
    arc_id character varying(16),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50) DEFAULT CURRENT_USER,
    matcat_id character varying(16),
    district_id integer,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    drainzone_id integer,
    parent_id character varying(16),
    expl_id2 integer,
    CONSTRAINT node_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['JUNCTION'::text, 'STORAGE'::text, 'DIVIDER'::text, 'OUTFALL'::text, 'NETGULLY'::text, 'UNDEFINED'::text])))
);


--
-- Name: TABLE node; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE node IS 'FIELD _sys_elev IS NOT USED. Value is calculated on the fly on views (3.3.021)';


--
-- Name: node_border_sector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE node_border_sector (
    node_id character varying(16) NOT NULL,
    sector_id integer NOT NULL
);


--
-- Name: om_profile; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_profile (
    profile_id text NOT NULL,
    "values" json
);


--
-- Name: om_psector_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_psector_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_reh_cat_works; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_reh_cat_works (
    id character varying(30) NOT NULL,
    descript text,
    observ text
);


--
-- Name: om_reh_parameter_x_works; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_reh_parameter_x_works (
    id integer NOT NULL,
    parameter_id character varying(50),
    init_condition integer,
    end_condition integer,
    arccat_id character varying(30),
    loc_condition_id character varying(30),
    catwork_id character varying(30)
);


--
-- Name: om_reh_parameter_x_works_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_reh_parameter_x_works_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_reh_parameter_x_works_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_reh_parameter_x_works_id_seq OWNED BY om_reh_parameter_x_works.id;


--
-- Name: om_reh_value_loc_condition; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_reh_value_loc_condition (
    id character varying(30) NOT NULL,
    descript text
);


--
-- Name: om_reh_works_x_pcompost; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_reh_works_x_pcompost (
    id integer NOT NULL,
    work_id character varying(30),
    sql_condition text,
    pcompost_id character varying(16)
);


--
-- Name: om_reh_works_x_pcompost_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_reh_works_x_pcompost_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_reh_works_x_pcompost_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_reh_works_x_pcompost_id_seq OWNED BY om_reh_works_x_pcompost.id;


--
-- Name: plan_result_cat; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_result_cat (
    result_id integer NOT NULL,
    name character varying(30),
    result_type integer,
    coefficient double precision,
    tstamp timestamp without time zone DEFAULT now(),
    cur_user text,
    descript text,
    pricecat_id character varying(30)
);


--
-- Name: om_result_cat_result_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_result_cat_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_result_cat_result_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_result_cat_result_id_seq OWNED BY plan_result_cat.result_id;


--
-- Name: om_typevalue; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_typevalue (
    typevalue text NOT NULL,
    id character varying(30) NOT NULL,
    idval text,
    descript text,
    addparam json
);


--
-- Name: om_visit; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_visit (
    id bigint NOT NULL,
    visitcat_id integer,
    ext_code character varying(30),
    startdate timestamp(6) without time zone DEFAULT ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone,
    enddate timestamp(6) without time zone,
    user_name character varying(50) DEFAULT USER,
    webclient_id character varying(50),
    expl_id integer,
    the_geom public.geometry(Point,SRID_VALUE),
    descript text,
    is_done boolean DEFAULT true,
    lot_id integer,
    class_id integer,
    status integer,
    visit_type integer,
    publish boolean,
    unit_id integer,
    vehicle_id integer
);


--
-- Name: om_visit_cat; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_visit_cat (
    id integer NOT NULL,
    name character varying(30),
    startdate date DEFAULT now(),
    enddate date,
    descript text,
    active boolean DEFAULT true,
    extusercat_id integer,
    duration text
);


--
-- Name: om_visit_cat_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_cat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_cat_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_cat_id_seq OWNED BY om_visit_cat.id;


--
-- Name: om_visit_class_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_class_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_class_id_seq OWNED BY config_visit_class.id;


--
-- Name: om_visit_event; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_visit_event (
    id bigint NOT NULL,
    event_code character varying(16),
    visit_id bigint NOT NULL,
    position_id character varying(50),
    position_value double precision,
    parameter_id character varying(50) NOT NULL,
    value text,
    value1 integer,
    value2 integer,
    geom1 double precision,
    geom2 double precision,
    geom3 double precision,
    xcoord double precision,
    ycoord double precision,
    compass double precision,
    tstamp timestamp(6) without time zone DEFAULT now(),
    text text,
    index_val smallint,
    is_last boolean
);


--
-- Name: om_visit_event_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_event_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_event_id_seq OWNED BY om_visit_event.id;


--
-- Name: om_visit_event_photo; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_visit_event_photo (
    id bigint NOT NULL,
    visit_id bigint NOT NULL,
    event_id bigint,
    tstamp timestamp(6) without time zone DEFAULT now(),
    value text,
    text text,
    compass double precision,
    hash text,
    filetype text,
    xcoord double precision,
    ycoord double precision,
    fextension character varying(16)
);


--
-- Name: om_visit_event_photo_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_event_photo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_event_photo_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_event_photo_id_seq OWNED BY om_visit_event_photo.id;


--
-- Name: om_visit_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_id_seq OWNED BY om_visit.id;


--
-- Name: om_visit_x_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_visit_x_arc (
    id bigint NOT NULL,
    visit_id bigint NOT NULL,
    arc_id character varying(16) NOT NULL,
    is_last boolean DEFAULT true
);


--
-- Name: om_visit_x_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_x_arc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_x_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_x_arc_id_seq OWNED BY om_visit_x_arc.id;


--
-- Name: om_visit_x_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_visit_x_connec (
    id bigint NOT NULL,
    visit_id bigint NOT NULL,
    connec_id character varying(16) NOT NULL,
    is_last boolean DEFAULT true
);


--
-- Name: om_visit_x_connec_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_x_connec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_x_connec_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_x_connec_id_seq OWNED BY om_visit_x_connec.id;


--
-- Name: om_visit_x_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_visit_x_gully (
    id bigint NOT NULL,
    visit_id bigint NOT NULL,
    gully_id character varying(16) NOT NULL,
    is_last boolean DEFAULT true
);


--
-- Name: om_visit_x_gully_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_x_gully_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_x_gully_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_x_gully_id_seq OWNED BY om_visit_x_gully.id;


--
-- Name: om_visit_x_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_visit_x_node (
    id bigint NOT NULL,
    visit_id bigint NOT NULL,
    node_id character varying(16) NOT NULL,
    is_last boolean DEFAULT true
);


--
-- Name: om_visit_x_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_visit_x_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_visit_x_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_visit_x_node_id_seq OWNED BY om_visit_x_node.id;


--
-- Name: plan_arc_x_pavement; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_arc_x_pavement (
    id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    pavcat_id character varying(16),
    percent numeric(3,2) NOT NULL
);


--
-- Name: plan_arc_x_pavement_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE plan_arc_x_pavement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_arc_x_pavement_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE plan_arc_x_pavement_id_seq OWNED BY plan_arc_x_pavement.id;


--
-- Name: plan_price; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_price (
    id character varying(16) NOT NULL,
    unit character varying(5) NOT NULL,
    descript character varying(100) NOT NULL,
    text text,
    price numeric(12,4),
    pricecat_id character varying(16)
);


--
-- Name: plan_price_cat; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_price_cat (
    id character varying(30) NOT NULL,
    descript text,
    tstamp timestamp without time zone DEFAULT now(),
    cur_user text DEFAULT "current_user"()
);


--
-- Name: plan_price_compost; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_price_compost (
    id integer NOT NULL,
    compost_id character varying(16) NOT NULL,
    simple_id character varying(16) NOT NULL,
    value numeric(16,4)
);


--
-- Name: plan_psector_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE plan_psector_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_psector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_psector (
    psector_id integer DEFAULT nextval('plan_psector_id_seq'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    psector_type integer,
    descript text,
    expl_id integer NOT NULL,
    priority character varying(16),
    text1 text,
    text2 text,
    observ text,
    rotation numeric(8,4),
    scale numeric(8,2),
    atlas_id character varying(16),
    gexpenses numeric(4,2),
    vat numeric(4,2),
    other numeric(4,2),
    active boolean DEFAULT true,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    enable_all boolean DEFAULT false NOT NULL,
    status integer,
    ext_code character varying(50),
    text3 text,
    text4 text,
    text5 text,
    text6 text,
    num_value numeric,
    workcat_id text,
    parent_id integer
);


--
-- Name: plan_psector_x_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_psector_x_arc (
    id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    psector_id integer NOT NULL,
    state smallint NOT NULL,
    doable boolean NOT NULL,
    descript character varying(254),
    addparam json,
    active boolean DEFAULT true,
    insert_tstamp timestamp without time zone DEFAULT now(),
    insert_user text DEFAULT CURRENT_USER,
    CONSTRAINT plan_psector_x_arc_state_check CHECK ((state = ANY (ARRAY[0, 1])))
);


--
-- Name: plan_psector_x_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE plan_psector_x_arc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_psector_x_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE plan_psector_x_arc_id_seq OWNED BY plan_psector_x_arc.id;


--
-- Name: plan_psector_x_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_psector_x_connec (
    id integer NOT NULL,
    connec_id character varying(16) NOT NULL,
    arc_id character varying(16),
    psector_id integer NOT NULL,
    state smallint NOT NULL,
    doable boolean NOT NULL,
    descript character varying(254),
    _link_geom_ public.geometry(LineString,SRID_VALUE),
    _userdefined_geom_ boolean,
    link_id integer,
    active boolean DEFAULT true,
    insert_tstamp timestamp without time zone DEFAULT now(),
    insert_user text DEFAULT CURRENT_USER,
    CONSTRAINT plan_psector_x_connec_state_check CHECK ((state = ANY (ARRAY[0, 1])))
);


--
-- Name: plan_psector_x_connec_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE plan_psector_x_connec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_psector_x_connec_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE plan_psector_x_connec_id_seq OWNED BY plan_psector_x_connec.id;


--
-- Name: plan_psector_x_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_psector_x_gully (
    id integer NOT NULL,
    gully_id character varying(16) NOT NULL,
    arc_id character varying(16),
    psector_id integer NOT NULL,
    state smallint NOT NULL,
    doable boolean NOT NULL,
    descript character varying(254),
    _link_geom_ public.geometry(LineString,SRID_VALUE),
    _userdefined_geom_ boolean,
    link_id integer,
    active boolean DEFAULT true,
    insert_tstamp timestamp without time zone DEFAULT now(),
    insert_user text DEFAULT CURRENT_USER,
    CONSTRAINT plan_psector_x_gully_state_check CHECK ((state = ANY (ARRAY[0, 1])))
);


--
-- Name: plan_psector_x_gully_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE plan_psector_x_gully_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_psector_x_gully_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE plan_psector_x_gully_id_seq OWNED BY plan_psector_x_gully.id;


--
-- Name: plan_psector_x_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_psector_x_node (
    id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    psector_id integer NOT NULL,
    state smallint NOT NULL,
    doable boolean NOT NULL,
    descript character varying(254),
    addparam json,
    active boolean DEFAULT true,
    insert_tstamp timestamp without time zone DEFAULT now(),
    insert_user text DEFAULT CURRENT_USER,
    CONSTRAINT plan_psector_x_node_state_check CHECK ((state = ANY (ARRAY[0, 1])))
);


--
-- Name: plan_psector_x_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE plan_psector_x_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_psector_x_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE plan_psector_x_node_id_seq OWNED BY plan_psector_x_node.id;


--
-- Name: plan_psector_x_other; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_psector_x_other (
    id integer NOT NULL,
    price_id character varying(16) NOT NULL,
    measurement numeric(12,2),
    psector_id integer NOT NULL,
    observ character varying(254),
    insert_tstamp timestamp without time zone DEFAULT now(),
    insert_user text DEFAULT CURRENT_USER
);


--
-- Name: plan_psector_x_other_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE plan_psector_x_other_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_psector_x_other_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE plan_psector_x_other_id_seq OWNED BY plan_psector_x_other.id;


--
-- Name: plan_rec_result_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_rec_result_arc (
    result_id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    node_1 character varying(16),
    node_2 character varying(16),
    arc_type character varying(18),
    arccat_id character varying(30),
    epa_type character varying(16),
    sector_id integer,
    state smallint,
    annotation character varying(254),
    soilcat_id character varying(30),
    y1 numeric(12,2),
    y2 numeric(12,2),
    mean_y numeric(12,2),
    z1 numeric(12,2),
    z2 numeric(12,2),
    thickness numeric(12,2),
    width numeric(12,2),
    b numeric(12,2),
    bulk numeric(12,2),
    geom1 numeric(12,2),
    area numeric(12,2),
    y_param numeric(12,2),
    total_y numeric(12,2),
    rec_y numeric(12,2),
    geom1_ext numeric(12,2),
    calculed_y numeric(12,2),
    m3mlexc numeric(12,2),
    m2mltrenchl numeric(12,2),
    m2mlbottom numeric(12,2),
    m2mlpav numeric(12,2),
    m3mlprotec numeric(12,2),
    m3mlfill numeric(12,2),
    m3mlexcess numeric(12,2),
    m3exc_cost numeric(12,2),
    m2trenchl_cost numeric(12,2),
    m2bottom_cost numeric(12,2),
    m2pav_cost numeric(12,2),
    m3protec_cost numeric(12,2),
    m3fill_cost numeric(12,2),
    m3excess_cost numeric(12,2),
    cost_unit character varying(16),
    pav_cost numeric(12,2),
    exc_cost numeric(12,2),
    trenchl_cost numeric(12,2),
    base_cost numeric(12,2),
    protec_cost numeric(12,2),
    fill_cost numeric(12,2),
    excess_cost numeric(12,2),
    arc_cost numeric(12,2),
    cost numeric(12,2),
    length numeric(12,3),
    budget numeric(12,2),
    other_budget numeric(12,2),
    total_budget numeric(12,2),
    the_geom public.geometry(LineString,SRID_VALUE),
    expl_id integer,
    builtcost double precision,
    builtdate timestamp without time zone,
    age double precision,
    acoeff double precision,
    aperiod text,
    arate double precision,
    amortized double precision,
    pending double precision
);


--
-- Name: plan_rec_result_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_rec_result_node (
    result_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    node_type character varying(18),
    nodecat_id character varying(30),
    top_elev numeric(12,3),
    elev numeric(12,3),
    epa_type character varying(16),
    sector_id integer,
    state smallint,
    annotation character varying(254),
    the_geom public.geometry(Point,SRID_VALUE),
    cost_unit character varying(3),
    descript text,
    measurement numeric(12,2),
    cost numeric(12,3),
    budget numeric(12,2),
    expl_id integer,
    builtcost double precision,
    builtdate timestamp without time zone,
    age double precision,
    acoeff double precision,
    aperiod text,
    arate double precision,
    amortized double precision,
    pending double precision
);


--
-- Name: plan_reh_result_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_reh_result_arc (
    result_id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    node_1 character varying(16),
    node_2 character varying(16),
    arc_type character varying(18) NOT NULL,
    arccat_id character varying(30) NOT NULL,
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    expl_id integer,
    parameter_id character varying(30),
    work_id character varying(30),
    init_condition double precision,
    end_condition double precision,
    loc_condition text,
    pcompost_id character varying(16),
    cost double precision,
    ymax double precision,
    length double precision,
    measurement double precision,
    budget double precision,
    the_geom public.geometry(LineString,SRID_VALUE)
);


--
-- Name: plan_reh_result_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_reh_result_node (
    result_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    node_type character varying(18) NOT NULL,
    nodecat_id character varying(30) NOT NULL,
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    expl_id integer,
    parameter_id character varying(30),
    work_id character varying(30),
    pcompost_id character varying(16),
    cost double precision,
    ymax double precision,
    measurement double precision,
    budget double precision,
    the_geom public.geometry(Point,SRID_VALUE)
);


--
-- Name: plan_typevalue; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE plan_typevalue (
    typevalue text NOT NULL,
    id character varying(30) NOT NULL,
    idval text,
    descript text,
    addparam json
);


--
-- Name: pol_pol_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE pol_pol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


--
-- Name: polygon; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE polygon (
    pol_id character varying(16) DEFAULT nextval('pol_pol_id_seq'::regclass) NOT NULL,
    sys_type character varying(30),
    text text,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    undelete boolean,
    tstamp timestamp without time zone DEFAULT now(),
    featurecat_id character varying(50),
    feature_id character varying(16),
    state smallint DEFAULT 1
);


--
-- Name: price_compost_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE price_compost_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_compost_value_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE price_compost_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_compost_value_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE price_compost_value_id_seq OWNED BY plan_price_compost.id;


--
-- Name: price_simple_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE price_simple_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_simple_value_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE price_simple_value_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: raingage_rg_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE raingage_rg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: raingage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE raingage (
    rg_id character varying(16) DEFAULT nextval('raingage_rg_id_seq'::regclass) NOT NULL,
    form_type character varying(12) NOT NULL,
    intvl character varying(10),
    scf numeric(12,4) DEFAULT 1.00,
    rgage_type character varying(18) NOT NULL,
    timser_id character varying(16),
    fname character varying(254),
    sta character varying(12),
    units character varying(3),
    expl_id integer NOT NULL,
    the_geom public.geometry(Point,SRID_VALUE) NOT NULL
);


--
-- Name: raster_dem_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE raster_dem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: raster_dem_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE raster_dem_id_seq OWNED BY ext_raster_dem.id;


--
-- Name: review_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_arc (
    arc_id character varying(16) NOT NULL,
    y1 numeric(12,3),
    y2 numeric(12,3),
    arc_type character varying(18),
    matcat_id character varying(30),
    arccat_id character varying(30),
    annotation text,
    observ text,
    review_obs text,
    expl_id integer,
    the_geom public.geometry(LineString,SRID_VALUE),
    field_checked boolean,
    is_validated integer,
    field_date timestamp(6) without time zone
);


--
-- Name: review_audit_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_audit_arc (
    id integer NOT NULL,
    arc_id character varying(16),
    old_y1 double precision,
    new_y1 double precision,
    old_y2 double precision,
    new_y2 double precision,
    old_arc_type character varying(18),
    new_arc_type character varying(18),
    old_matcat_id character varying(30),
    new_matcat_id character varying(30),
    old_arccat_id character varying(30),
    new_arccat_id character varying(30),
    old_annotation text,
    new_annotation text,
    old_observ text,
    new_observ text,
    review_obs text,
    expl_id integer,
    the_geom public.geometry(LineString,SRID_VALUE),
    review_status_id smallint,
    field_date timestamp(6) without time zone,
    field_user text,
    is_validated integer
);


--
-- Name: review_audit_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE review_audit_arc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_audit_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE review_audit_arc_id_seq OWNED BY review_audit_arc.id;


--
-- Name: review_audit_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_audit_connec (
    id integer NOT NULL,
    connec_id character varying(16) NOT NULL,
    old_y1 numeric(12,3),
    new_y1 numeric(12,3),
    old_y2 numeric(12,3),
    new_y2 numeric(12,3),
    old_connec_type character varying(18),
    new_connec_type character varying(18),
    old_matcat_id character varying(30),
    new_matcat_id character varying(30),
    old_connecat_id character varying(30),
    new_connecat_id character varying(30),
    old_annotation text,
    new_annotation text,
    old_observ text,
    new_observ text,
    review_obs text,
    expl_id integer,
    the_geom public.geometry(Point,SRID_VALUE),
    review_status_id smallint,
    field_date timestamp(6) without time zone,
    field_user text,
    is_validated integer
);


--
-- Name: review_audit_connec_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE review_audit_connec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_audit_connec_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE review_audit_connec_id_seq OWNED BY review_audit_connec.id;


--
-- Name: review_audit_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_audit_gully (
    id integer NOT NULL,
    gully_id character varying(16) NOT NULL,
    old_top_elev numeric(12,3),
    new_top_elev numeric(12,3),
    old_ymax numeric(12,3),
    new_ymax numeric(12,3),
    old_sandbox numeric(12,3),
    new_sandbox numeric(12,3),
    new_gully_type character varying(30),
    old_gully_type character varying(30),
    old_matcat_id character varying(30),
    new_matcat_id character varying(30),
    old_gratecat_id character varying(30),
    new_gratecat_id character varying(30),
    old_units smallint,
    new_units smallint,
    old_groove boolean,
    new_groove boolean,
    old_siphon boolean,
    new_siphon boolean,
    old_connec_arccat_id character varying(18),
    new_connec_arccat_id character varying(18),
    old_annotation text,
    new_annotation text,
    old_observ text,
    new_observ text,
    review_obs text,
    expl_id integer,
    the_geom public.geometry(Point,SRID_VALUE),
    review_status_id smallint,
    field_date timestamp(6) without time zone,
    field_user text,
    is_validated integer
);


--
-- Name: review_audit_gully_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE review_audit_gully_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_audit_gully_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE review_audit_gully_id_seq OWNED BY review_audit_gully.id;


--
-- Name: review_audit_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_audit_node (
    id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    old_top_elev numeric(12,3),
    new_top_elev numeric(12,3),
    old_ymax numeric(12,3),
    new_ymax numeric(12,3),
    old_node_type character varying(18),
    new_node_type character varying(18),
    old_matcat_id character varying(30),
    new_matcat_id character varying(30),
    old_nodecat_id character varying(30),
    new_nodecat_id character varying(30),
    old_annotation text,
    new_annotation text,
    old_observ text,
    new_observ text,
    review_obs text,
    expl_id integer,
    the_geom public.geometry(Point,SRID_VALUE),
    review_status_id smallint,
    field_date timestamp(6) without time zone,
    field_user text,
    is_validated integer,
    old_step_pp integer,
    new_step_pp integer,
    old_step_fe integer,
    new_step_fe integer,
    old_step_replace integer,
    new_step_replace integer,
    old_cover text,
    new_cover text
);


--
-- Name: review_audit_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE review_audit_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_audit_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE review_audit_node_id_seq OWNED BY review_audit_node.id;


--
-- Name: review_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_connec (
    connec_id character varying(16) NOT NULL,
    y1 numeric(12,3),
    y2 numeric(12,3),
    connec_type character varying(18),
    matcat_id character varying(30),
    connecat_id character varying(30),
    annotation text,
    observ text,
    review_obs text,
    expl_id integer,
    the_geom public.geometry(Point,SRID_VALUE),
    field_checked boolean,
    is_validated integer,
    field_date timestamp(6) without time zone
);


--
-- Name: review_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_gully (
    gully_id character varying(16) NOT NULL,
    top_elev numeric(12,3),
    ymax numeric(12,3),
    sandbox numeric(12,3),
    gully_type character varying(30),
    matcat_id character varying(30),
    gratecat_id character varying(30),
    units smallint,
    groove boolean,
    siphon boolean,
    connec_arccat_id character varying(18),
    annotation text,
    observ text,
    review_obs text,
    expl_id integer,
    the_geom public.geometry(Point,SRID_VALUE),
    field_checked boolean,
    is_validated integer,
    field_date timestamp(6) without time zone
);


--
-- Name: review_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_node (
    node_id character varying(16) NOT NULL,
    top_elev numeric(12,3),
    ymax numeric(12,3),
    node_type character varying(18),
    matcat_id character varying(30),
    nodecat_id character varying(30),
    annotation text,
    observ text,
    review_obs text,
    expl_id integer,
    the_geom public.geometry(Point,SRID_VALUE),
    field_checked boolean,
    is_validated integer,
    field_date timestamp(6) without time zone,
    step_pp integer,
    step_fe integer,
    step_replace integer,
    cover text
);


--
-- Name: rpt_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_arc (
    id bigint NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(16),
    resultdate character varying(16),
    resulttime character varying(12),
    flow double precision,
    velocity double precision,
    fullpercent double precision
);


--
-- Name: rpt_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_arc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_arc_id_seq OWNED BY rpt_arc.id;


--
-- Name: rpt_arcflow_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_arcflow_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_arcflow_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_arcflow_sum (
    id integer DEFAULT nextval('rpt_arcflow_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(50),
    arc_type character varying(18),
    max_flow numeric(12,4),
    time_days character varying(10),
    time_hour character varying(10),
    max_veloc numeric(12,4),
    mfull_flow numeric(12,4),
    mfull_dept numeric(12,4),
    max_shear numeric(12,4),
    max_hr numeric(12,4),
    max_slope numeric(12,4),
    day_max character varying(10),
    time_max character varying(10),
    min_shear numeric(12,4),
    day_min character varying(10),
    time_min character varying(10)
);


--
-- Name: rpt_arcpolload_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_arcpolload_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_arcpolload_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_arcpolload_sum (
    id integer DEFAULT nextval('rpt_arcpolload_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(16),
    poll_id character varying(16)
);


--
-- Name: rpt_arcpollutant_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_arcpollutant_sum (
    id integer NOT NULL,
    result_id character varying(30),
    poll_id character varying(16),
    arc_id character varying(50),
    value numeric(12,4)
);


--
-- Name: rpt_arcpollutant_sum_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_arcpollutant_sum_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_arcpollutant_sum_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_arcpollutant_sum_id_seq OWNED BY rpt_arcpollutant_sum.id;


--
-- Name: rpt_cat_result; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_cat_result (
    result_id character varying(30) NOT NULL,
    flow_units character varying(3),
    rain_runof character varying(3),
    snowmelt character varying(3),
    groundw character varying(3),
    flow_rout character varying(3),
    pond_all character varying(3),
    water_q character varying(3),
    infil_m character varying(18),
    flowrout_m character varying(18),
    start_date character varying(25),
    end_date character varying(25),
    dry_days numeric(12,4),
    rep_tstep character varying(10),
    wet_tstep character varying(10),
    dry_tstep character varying(10),
    rout_tstep character varying(10),
    var_time_step character varying(3),
    max_trials numeric(4,2),
    head_tolerance character varying(12),
    exec_date timestamp(6) without time zone DEFAULT now(),
    cur_user text DEFAULT CURRENT_USER,
    inp_options json,
    rpt_stats json,
    export_options json,
    network_stats json,
    status smallint,
    expl_id integer,
    CONSTRAINT rpt_cat_result_status_check CHECK ((status = ANY (ARRAY[0, 1, 2])))
);


--
-- Name: rpt_cat_result_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_cat_result_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_condsurcharge_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_condsurcharge_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_condsurcharge_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_condsurcharge_sum (
    id integer DEFAULT nextval('rpt_condsurcharge_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(50),
    both_ends numeric(12,4),
    upstream numeric(12,4),
    dnstream numeric(12,4),
    hour_nflow numeric(12,4),
    hour_limit numeric(12,4)
);


--
-- Name: rpt_continuity_errors_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_continuity_errors_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_continuity_errors; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_continuity_errors (
    id integer DEFAULT nextval('rpt_continuity_errors_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    text character varying(255)
);


--
-- Name: rpt_control_actions_taken; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_control_actions_taken (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    text character varying(255)
);


--
-- Name: rpt_control_actions_taken_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_control_actions_taken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_control_actions_taken_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_control_actions_taken_id_seq OWNED BY rpt_control_actions_taken.id;


--
-- Name: rpt_critical_elements_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_critical_elements_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_critical_elements; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_critical_elements (
    id integer DEFAULT nextval('rpt_critical_elements_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    text character varying(255)
);


--
-- Name: rpt_flowclass_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_flowclass_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_flowclass_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_flowclass_sum (
    id integer DEFAULT nextval('rpt_flowclass_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(50),
    length numeric(12,4),
    dry numeric(12,4),
    up_dry numeric(12,4),
    down_dry numeric(12,4),
    sub_crit numeric(12,4),
    sub_crit_1 numeric(12,4),
    up_crit numeric(12,4),
    down_crit numeric(12,4),
    froud_numb numeric(12,4),
    flow_chang numeric(12,4)
);


--
-- Name: rpt_flowrouting_cont_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_flowrouting_cont_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_flowrouting_cont; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_flowrouting_cont (
    id integer DEFAULT nextval('rpt_flowrouting_cont_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    dryw_inf numeric(12,4),
    wetw_inf numeric(12,4),
    ground_inf numeric(12,4),
    rdii_inf numeric(12,4),
    ext_inf numeric(12,4),
    ext_out numeric(12,4),
    int_out numeric(12,4),
    stor_loss numeric(12,4),
    initst_vol numeric(12,4),
    finst_vol numeric(12,4),
    cont_error numeric(12,4),
    evap_losses numeric(6,4),
    seepage_losses numeric(6,4)
);


--
-- Name: rpt_groundwater_cont_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_groundwater_cont_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_groundwater_cont; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_groundwater_cont (
    id integer DEFAULT nextval('rpt_groundwater_cont_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    init_stor numeric(12,4),
    infilt numeric(12,4),
    upzone_et numeric(12,4),
    lowzone_et numeric(12,4),
    deep_perc numeric(12,4),
    groundw_fl numeric(12,4),
    final_stor numeric(12,4),
    cont_error numeric(12,4)
);


--
-- Name: rpt_high_conterrors_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_high_conterrors_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_high_conterrors; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_high_conterrors (
    id integer DEFAULT nextval('rpt_high_conterrors_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    text character varying(255)
);


--
-- Name: rpt_high_flowinest_ind_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_high_flowinest_ind_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_high_flowinest_ind; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_high_flowinest_ind (
    id integer DEFAULT nextval('rpt_high_flowinest_ind_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    text character varying(255)
);


--
-- Name: rpt_inp_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_inp_arc (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(16) NOT NULL,
    node_1 character varying(16),
    node_2 character varying(16),
    elevmax1 numeric(12,3),
    elevmax2 numeric(12,3),
    arc_type character varying(30),
    arccat_id character varying(30),
    epa_type character varying(16),
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint,
    annotation character varying(254),
    length numeric(12,3),
    n numeric(12,3),
    the_geom public.geometry(LineString,SRID_VALUE),
    expl_id integer,
    addparam text,
    arcparent character varying(16),
    q0 double precision,
    qmax double precision,
    barrels integer,
    slope double precision,
    culvert character varying(10),
    kentry numeric(12,4),
    kexit numeric(12,4),
    kavg numeric(12,4),
    flap character varying(3),
    seepage numeric(12,4),
    age integer
);


--
-- Name: rpt_inp_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_inp_arc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_inp_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_inp_arc_id_seq OWNED BY rpt_inp_arc.id;


--
-- Name: rpt_inp_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_inp_node (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(16) NOT NULL,
    top_elev numeric(12,3),
    ymax numeric(12,3),
    elev numeric(12,3),
    node_type character varying(30),
    nodecat_id character varying(30),
    epa_type character varying(16),
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint,
    annotation character varying(254),
    y0 numeric(12,4),
    ysur numeric(12,4),
    apond numeric(12,4),
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer,
    addparam text,
    parent character varying(16),
    arcposition smallint,
    fusioned_node text,
    age integer
);


--
-- Name: rpt_inp_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_inp_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_inp_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_inp_node_id_seq OWNED BY rpt_inp_node.id;


--
-- Name: rpt_inp_raingage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_inp_raingage (
    result_id character varying(30) NOT NULL,
    rg_id character varying(16) NOT NULL,
    form_type character varying(12) NOT NULL,
    intvl character varying(10),
    scf numeric(12,4) DEFAULT 1.00,
    rgage_type character varying(18) NOT NULL,
    timser_id character varying(16),
    fname character varying(254),
    sta character varying(12),
    units character varying(3),
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer NOT NULL
);


--
-- Name: rpt_instability_index_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_instability_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_instability_index; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_instability_index (
    id integer DEFAULT nextval('rpt_instability_index_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    text character varying(255)
);


--
-- Name: rpt_lidperformance_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_lidperformance_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_lidperformance_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_lidperformance_sum (
    id integer DEFAULT nextval('rpt_lidperformance_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    subc_id character varying(16),
    lidco_id character varying(16),
    tot_inflow numeric(12,4),
    evap_loss numeric(12,4),
    infil_loss numeric(12,4),
    surf_outf numeric(12,4),
    drain_outf numeric(12,4),
    init_stor numeric(12,4),
    final_stor numeric(12,4),
    per_error numeric(12,4)
);


--
-- Name: rpt_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_node (
    id bigint NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(16),
    resultdate character varying(16),
    resulttime character varying(12),
    flooding double precision,
    depth double precision,
    head double precision,
    inflow numeric(12,3)
);


--
-- Name: rpt_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_node_id_seq OWNED BY rpt_node.id;


--
-- Name: rpt_nodedepth_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_nodedepth_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_nodedepth_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_nodedepth_sum (
    id integer DEFAULT nextval('rpt_nodedepth_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(50),
    swnod_type character varying(18),
    aver_depth numeric(12,4),
    max_depth numeric(12,4),
    max_hgl numeric(12,4),
    time_days character varying(10),
    time_hour character varying(10)
);


--
-- Name: rpt_nodeflooding_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_nodeflooding_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_nodeflooding_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_nodeflooding_sum (
    id integer DEFAULT nextval('rpt_nodeflooding_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(50),
    hour_flood numeric(12,4),
    max_rate numeric(12,4),
    time_days character varying(10),
    time_hour character varying(10),
    tot_flood numeric(12,4),
    max_ponded numeric(12,4)
);


--
-- Name: rpt_nodeinflow_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_nodeinflow_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_nodeinflow_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_nodeinflow_sum (
    id integer DEFAULT nextval('rpt_nodeinflow_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(50),
    swnod_type character varying(18),
    max_latinf numeric(12,4),
    max_totinf numeric(12,4),
    time_days character varying(10),
    time_hour character varying(10),
    latinf_vol numeric(12,4),
    totinf_vol numeric(12,4),
    flow_balance_error numeric(12,2),
    other_info character varying(12)
);


--
-- Name: rpt_nodesurcharge_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_nodesurcharge_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_nodesurcharge_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_nodesurcharge_sum (
    id integer DEFAULT nextval('rpt_nodesurcharge_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(50),
    swnod_type character varying(18),
    hour_surch numeric(12,4),
    max_height numeric(12,4),
    min_depth numeric(12,4)
);


--
-- Name: rpt_outfallflow_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_outfallflow_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_outfallflow_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_outfallflow_sum (
    id integer DEFAULT nextval('rpt_outfallflow_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(50),
    flow_freq numeric(12,4),
    avg_flow numeric(12,4),
    max_flow numeric(12,4),
    total_vol numeric(12,4)
);


--
-- Name: rpt_outfallload_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_outfallload_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_outfallload_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_outfallload_sum (
    id integer DEFAULT nextval('rpt_outfallload_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    poll_id character varying(16),
    node_id character varying(50),
    value numeric(12,4)
);


--
-- Name: rpt_pumping_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_pumping_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_pumping_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_pumping_sum (
    id integer DEFAULT nextval('rpt_pumping_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(50),
    percent numeric(12,4),
    num_startup integer,
    min_flow numeric(12,4),
    avg_flow numeric(12,4),
    max_flow numeric(12,4),
    vol_ltr numeric(12,4),
    powus_kwh numeric(12,4),
    timoff_min numeric(12,4),
    timoff_max numeric(12,4)
);


--
-- Name: rpt_qualrouting_cont_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_qualrouting_cont_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_qualrouting_cont; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_qualrouting_cont (
    id integer DEFAULT nextval('rpt_qualrouting_cont_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    poll_id character varying(16),
    dryw_inf numeric(12,4),
    wetw_inf numeric(12,4),
    ground_inf numeric(12,4),
    rdii_inf numeric(12,4),
    ext_inf numeric(12,4),
    int_inf numeric(12,4),
    ext_out numeric(12,4),
    mass_reac numeric(12,4),
    initst_mas numeric(12,4),
    finst_mas numeric(12,4),
    cont_error numeric(12,4)
);


--
-- Name: rpt_rainfall_dep_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_rainfall_dep_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_rainfall_dep; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_rainfall_dep (
    id integer DEFAULT nextval('rpt_rainfall_dep_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    sewer_rain numeric(12,4),
    rdiip_prod numeric(12,4),
    rdiir_rat numeric(12,4)
);


--
-- Name: rpt_routing_timestep_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_routing_timestep_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_routing_timestep; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_routing_timestep (
    id integer DEFAULT nextval('rpt_routing_timestep_seq'::regclass) NOT NULL,
    result_id character varying(254) NOT NULL,
    text character varying(255)
);


--
-- Name: rpt_runoff_qual_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_runoff_qual_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_runoff_qual; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_runoff_qual (
    id integer DEFAULT nextval('rpt_runoff_qual_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    poll_id character varying(16),
    init_buil numeric(12,4),
    surf_buil numeric(12,4),
    wet_dep numeric(12,4),
    sweep_re numeric(12,4),
    infil_loss numeric(12,4),
    bmp_re numeric(12,4),
    surf_runof numeric(12,4),
    rem_buil numeric(12,4),
    cont_error numeric(12,4)
);


--
-- Name: rpt_runoff_quant_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_runoff_quant_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_runoff_quant; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_runoff_quant (
    id integer DEFAULT nextval('rpt_runoff_quant_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    initsw_co numeric(12,4),
    total_prec numeric(12,4),
    evap_loss numeric(12,4),
    infil_loss numeric(12,4),
    surf_runof numeric(12,4),
    snow_re numeric(12,4),
    finalsw_co numeric(12,4),
    finals_sto numeric(12,4),
    cont_error numeric(16,4),
    initlid_sto numeric(12,4)
);


--
-- Name: rpt_storagevol_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_storagevol_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_storagevol_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_storagevol_sum (
    id integer DEFAULT nextval('rpt_storagevol_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(50),
    aver_vol numeric(12,4),
    avg_full numeric(12,4),
    ei_loss numeric(12,4),
    max_vol numeric(12,4),
    max_full numeric(12,4),
    time_days character varying(10),
    time_hour character varying(10),
    max_out numeric(12,4)
);


--
-- Name: rpt_subcatchment; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_subcatchment (
    id bigint NOT NULL,
    result_id character varying(30) NOT NULL,
    subc_id character varying(16),
    resultdate character varying(16),
    resulttime character varying(12),
    precip double precision,
    losses double precision,
    runoff double precision
);


--
-- Name: rpt_subcatchment_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_subcatchment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_subcatchment_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_subcatchment_id_seq OWNED BY rpt_subcatchment.id;


--
-- Name: rpt_subcathrunoff_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_subcathrunoff_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_subcatchrunoff_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_subcatchrunoff_sum (
    id integer DEFAULT nextval('rpt_subcathrunoff_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    subc_id character varying(16),
    tot_precip numeric(12,4),
    tot_runon numeric(12,4),
    tot_evap numeric(12,4),
    tot_infil numeric(12,4),
    tot_runoff numeric(12,4),
    tot_runofl numeric(12,4),
    peak_runof numeric(12,4),
    runoff_coe numeric(12,4),
    vxmax numeric(12,4),
    vymax numeric(12,4),
    depth numeric(12,4),
    vel numeric(12,4),
    vhmax numeric(12,6)
);


--
-- Name: rpt_subcatchwashoff_sum_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_subcatchwashoff_sum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_subcatchwashoff_sum; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_subcatchwashoff_sum (
    id integer DEFAULT nextval('rpt_subcatchwashoff_sum_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    subc_id character varying(16) NOT NULL,
    poll_id character varying(16) NOT NULL,
    value numeric
);


--
-- Name: rpt_summary_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_summary_arc (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(16) NOT NULL,
    node_1 character varying(16) NOT NULL,
    node_2 character varying(16) NOT NULL,
    epa_type character varying(16) NOT NULL,
    length double precision,
    slope double precision,
    roughness double precision
);


--
-- Name: rpt_summary_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_summary_arc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_summary_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_summary_arc_id_seq OWNED BY rpt_summary_arc.id;


--
-- Name: rpt_summary_crossection; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_summary_crossection (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(16) NOT NULL,
    shape character varying(16) NOT NULL,
    fulldepth double precision,
    fullarea double precision,
    hydrad double precision,
    maxwidth double precision,
    barrels integer,
    fullflow double precision
);


--
-- Name: rpt_summary_crossection_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_summary_crossection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_summary_crossection_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_summary_crossection_id_seq OWNED BY rpt_summary_crossection.id;


--
-- Name: rpt_summary_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_summary_node (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(16) NOT NULL,
    epa_type character varying(16) NOT NULL,
    elevation double precision,
    maxdepth double precision,
    pondedarea double precision,
    externalinf character varying(16) NOT NULL
);


--
-- Name: rpt_summary_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_summary_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_summary_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_summary_node_id_seq OWNED BY rpt_summary_node.id;


--
-- Name: rpt_summary_raingage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_summary_raingage (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    rg_id character varying(16) NOT NULL,
    data_source character varying(16),
    data_type character varying(16),
    "interval" character varying(16)
);


--
-- Name: rpt_summary_raingage_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_summary_raingage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_summary_raingage_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_summary_raingage_id_seq OWNED BY rpt_summary_raingage.id;


--
-- Name: rpt_summary_subcatchment; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_summary_subcatchment (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    subc_id character varying(16) NOT NULL,
    area double precision,
    width double precision,
    imperv double precision,
    slope double precision,
    rg_id character varying(16) NOT NULL,
    outlet character varying(16) NOT NULL
);


--
-- Name: rpt_summary_subcatchment_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_summary_subcatchment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_summary_subcatchment_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_summary_subcatchment_id_seq OWNED BY rpt_summary_subcatchment.id;


--
-- Name: rpt_timestep_critelem_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_timestep_critelem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_timestep_critelem; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_timestep_critelem (
    id integer DEFAULT nextval('rpt_timestep_critelem_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    text character varying(255)
);


--
-- Name: rpt_warning_summary; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_warning_summary (
    id integer NOT NULL,
    result_id character varying(30),
    warning_number character varying(30),
    text text
);


--
-- Name: rpt_warning_summary_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_warning_summary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_warning_summary_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_warning_summary_id_seq OWNED BY rpt_warning_summary.id;


--
-- Name: rtc_hydrometer; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rtc_hydrometer (
    hydrometer_id character varying(16) NOT NULL,
    link text
);


--
-- Name: rtc_hydrometer_x_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rtc_hydrometer_x_connec (
    hydrometer_id character varying(16) NOT NULL,
    connec_id character varying(16)
);


--
-- Name: rtc_scada_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rtc_scada_node (
    scada_id character varying(16) NOT NULL,
    node_id character varying(16)
);


--
-- Name: rtc_scada_x_dma; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rtc_scada_x_dma (
    id integer NOT NULL,
    scada_id character varying(16),
    dma_id character varying(16),
    flow_sign smallint
);


--
-- Name: rtc_scada_x_dma_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rtc_scada_x_dma_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rtc_scada_x_dma_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rtc_scada_x_dma_id_seq OWNED BY rtc_scada_x_dma.id;


--
-- Name: rtc_scada_x_sector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rtc_scada_x_sector (
    id integer NOT NULL,
    scada_id character varying(16) NOT NULL,
    sector_id character varying(16),
    flow_sign smallint
);


--
-- Name: rtc_scada_x_sector_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rtc_scada_x_sector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rtc_scada_x_sector_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rtc_scada_x_sector_id_seq OWNED BY rtc_scada_x_sector.id;


--
-- Name: samplepoint_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE samplepoint_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: samplepoint; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE samplepoint (
    sample_id character varying(16) DEFAULT nextval('samplepoint_id_seq'::regclass) NOT NULL,
    code character varying(30),
    lab_code character varying(30),
    feature_id character varying(16),
    featurecat_id character varying(30),
    dma_id integer,
    state smallint NOT NULL,
    builtdate date,
    enddate date,
    workcat_id character varying(255),
    workcat_id_end character varying(255),
    rotation numeric(12,3),
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(16),
    postnumber integer,
    postcomplement character varying(100),
    streetaxis2_id character varying(16),
    postnumber2 integer,
    postcomplement2 character varying(100),
    place_name character varying(254),
    cabinet character varying(150),
    observations character varying(254),
    verified character varying(30),
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer NOT NULL,
    tstamp timestamp without time zone DEFAULT now(),
    link character varying(512),
    district_id integer
);


--
-- Name: sector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sector (
    sector_id integer NOT NULL,
    name character varying(50) NOT NULL,
    macrosector_id integer,
    descript text,
    undelete boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    active boolean DEFAULT true,
    parent_id integer,
    tstamp timestamp without time zone DEFAULT now(),
    insert_user character varying(15) DEFAULT CURRENT_USER,
    lastupdate timestamp without time zone,
    lastupdate_user character varying(15)
);


--
-- Name: sector_sector_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE sector_sector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sector_sector_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE sector_sector_id_seq OWNED BY sector.sector_id;


--
-- Name: selector_audit; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_audit (
    fid integer NOT NULL,
    cur_user text DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: selector_date; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_date (
    from_date date,
    to_date date,
    context character varying(30) NOT NULL,
    cur_user text DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: selector_expl; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_expl (
    expl_id integer NOT NULL,
    cur_user text DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: selector_hydrometer; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_hydrometer (
    state_id integer NOT NULL,
    cur_user text DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: selector_inp_dscenario; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_inp_dscenario (
    dscenario_id integer NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_inp_result; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_inp_result (
    result_id character varying(30) NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_plan_psector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_plan_psector (
    psector_id integer NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_plan_result; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_plan_result (
    result_id integer NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_psector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_psector (
    psector_id integer NOT NULL,
    cur_user text DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: selector_rpt_compare; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_rpt_compare (
    result_id character varying(30) NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_rpt_compare_tstep; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_rpt_compare_tstep (
    resultdate character varying(16) NOT NULL,
    resulttime character varying(12) NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_rpt_main; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_rpt_main (
    result_id character varying(30) NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_rpt_main_tstep; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_rpt_main_tstep (
    resultdate character varying(16) NOT NULL,
    resulttime character varying(12) NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_sector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_sector (
    sector_id integer NOT NULL,
    cur_user text DEFAULT "current_user"() NOT NULL
);


--
-- Name: selector_state; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_state (
    state_id integer NOT NULL,
    cur_user text DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: selector_workcat; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_workcat (
    workcat_id text NOT NULL,
    cur_user text DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: sys_addfields; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_addfields (
    id integer NOT NULL,
    param_name character varying(50) NOT NULL,
    cat_feature_id character varying(30),
    is_mandatory boolean NOT NULL,
    datatype_id text NOT NULL,
    orderby integer,
    active boolean DEFAULT true,
    iseditable boolean
);


--
-- Name: sys_addfields_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE sys_addfields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_addfields_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE sys_addfields_id_seq OWNED BY sys_addfields.id;


--
-- Name: sys_feature_cat; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_feature_cat (
    id character varying(30) NOT NULL,
    type character varying(30),
    epa_default character varying(16),
    man_table character varying(30),
    CONSTRAINT sys_feature_cat_check CHECK (((id)::text = ANY (ARRAY[('CHAMBER'::character varying)::text, ('CONDUIT'::character varying)::text, ('CONNEC'::character varying)::text, ('GULLY'::character varying)::text, ('JUNCTION'::character varying)::text, ('MANHOLE'::character varying)::text, ('NETELEMENT'::character varying)::text, ('NETGULLY'::character varying)::text, ('NETINIT'::character varying)::text, ('OUTFALL'::character varying)::text, ('SIPHON'::character varying)::text, ('STORAGE'::character varying)::text, ('VALVE'::character varying)::text, ('VARC'::character varying)::text, ('WACCEL'::character varying)::text, ('WJUMP'::character varying)::text, ('WWTP'::character varying)::text, ('ELEMENT'::character varying)::text, ('LINK'::character varying)::text])))
);


--
-- Name: sys_feature_epa_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_feature_epa_type (
    id character varying(30) NOT NULL,
    feature_type character varying(30) NOT NULL,
    epa_table character varying(50),
    descript text,
    active boolean
);


--
-- Name: sys_feature_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_feature_type (
    id character varying(30) NOT NULL,
    classlevel smallint,
    CONSTRAINT sys_feature_type_check CHECK (((id)::text = ANY ((ARRAY['ARC'::character varying, 'CONNEC'::character varying, 'ELEMENT'::character varying, 'GULLY'::character varying, 'LINK'::character varying, 'NODE'::character varying, 'VNODE'::character varying])::text[])))
);


--
-- Name: sys_foreignkey; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_foreignkey (
    id integer NOT NULL,
    typevalue_table character varying(50),
    typevalue_name character varying(50),
    target_table character varying(50),
    target_field character varying(50),
    parameter_id integer,
    active boolean DEFAULT true
);


--
-- Name: sys_foreingkey_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE sys_foreingkey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_foreingkey_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE sys_foreingkey_id_seq OWNED BY sys_foreignkey.id;


--
-- Name: sys_fprocess; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_fprocess (
    fid integer NOT NULL,
    fprocess_name character varying(100),
    project_type character varying(6),
    parameters json,
    source text,
    isaudit boolean,
    fprocess_type text,
    addparam json
);


--
-- Name: TABLE sys_fprocess; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE sys_fprocess IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is possible to create own process. Ids starting by 9 are reserved to work with';


--
-- Name: sys_function; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_function (
    id integer NOT NULL,
    function_name text NOT NULL,
    project_type text,
    function_type text,
    input_params text,
    return_type text,
    descript text,
    sys_role text,
    sample_query text,
    source text
);


--
-- Name: TABLE sys_function; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE sys_function IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is possible to create own functions. Ids starting by 9 are reserved to work with';


--
-- Name: sys_image; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_image (
    id integer NOT NULL,
    idval text,
    image bytea
);


--
-- Name: TABLE sys_image; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE sys_image IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table images on forms are configured:
To load a new image into this table use:
INSERT INTO config_api_images (idval, image) VALUES (''imagename'', pg_read_binary_file(''imagename.png'')::bytea)
Image must be located on the server (folder data of postgres instalation path. On linux /var/lib/postgresql/x.x/main, on windows postrgreSQL/x.x/data )';


--
-- Name: sys_image_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE sys_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_image_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE sys_image_id_seq OWNED BY sys_image.id;


--
-- Name: sys_message; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_message (
    id integer NOT NULL,
    error_message text,
    hint_message text,
    log_level smallint DEFAULT 1,
    show_user boolean DEFAULT true,
    project_type text DEFAULT 'utils'::text,
    source text,
    CONSTRAINT sys_message_log_level_check CHECK ((log_level = ANY (ARRAY[0, 1, 2, 3])))
);


--
-- Name: sys_param_user; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_param_user (
    id text NOT NULL,
    formname text,
    descript text,
    sys_role character varying(30),
    idval text,
    label text,
    dv_querytext text,
    dv_parent_id text,
    isenabled boolean,
    layoutorder integer,
    project_type character varying,
    isparent boolean,
    dv_querytext_filterc text,
    feature_field_id text,
    feature_dv_parent_value text,
    isautoupdate boolean,
    datatype character varying(30),
    widgettype character varying(30),
    ismandatory boolean,
    widgetcontrols json,
    vdefault text,
    layoutname text,
    iseditable boolean,
    dv_orderby_id boolean,
    dv_isnullvalue boolean,
    stylesheet json,
    placeholder text,
    source text
);


--
-- Name: sys_role; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_role (
    id character varying(30) NOT NULL,
    context character varying(30),
    descript text,
    CONSTRAINT sys_role_check CHECK (((id)::text = ANY (ARRAY[('role_admin'::character varying)::text, ('role_basic'::character varying)::text, ('role_edit'::character varying)::text, ('role_epa'::character varying)::text, ('role_master'::character varying)::text, ('role_om'::character varying)::text, ('role_crm'::character varying)::text])))
);


--
-- Name: sys_style; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_style (
    id integer NOT NULL,
    idval text,
    styletype character varying(30),
    stylevalue text,
    active boolean DEFAULT true
);


--
-- Name: sys_style_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE sys_style_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_style_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE sys_style_id_seq OWNED BY sys_style.id;


--
-- Name: sys_table; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_table (
    id text NOT NULL,
    descript text,
    sys_role character varying(30),
    criticity smallint,
    context character varying(500),
    orderby smallint,
    alias text,
    notify_action json,
    isaudit boolean,
    keepauditdays integer,
    source text,
    style_id integer,
    addparam json
);


--
-- Name: sys_typevalue; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_typevalue (
    typevalue_table character varying(50) NOT NULL,
    typevalue_name character varying(50) NOT NULL
);


--
-- Name: sys_version; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE sys_version (
    id integer NOT NULL,
    giswater character varying(16) NOT NULL,
    project_type character varying(16) NOT NULL,
    postgres character varying(512) NOT NULL,
    postgis character varying(512) NOT NULL,
    date timestamp(6) without time zone DEFAULT now() NOT NULL,
    language character varying(50) NOT NULL,
    epsg integer NOT NULL
);


--
-- Name: sys_version_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE sys_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_version_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE sys_version_id_seq OWNED BY sys_version.id;


--
-- Name: temp_anlgraph; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_anlgraph (
    id integer NOT NULL,
    arc_id character varying(20),
    node_1 character varying(20),
    node_2 character varying(20),
    water smallint,
    flag smallint,
    checkf smallint,
    length numeric(12,4),
    cost numeric(12,4),
    value numeric(12,4),
    trace integer,
    isheader boolean,
    orderby integer
);


--
-- Name: temp_anlgraph_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_anlgraph_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_anlgraph_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_anlgraph_id_seq OWNED BY temp_anlgraph.id;


--
-- Name: temp_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_arc (
    id integer NOT NULL,
    result_id character varying(30),
    arc_id character varying(16) NOT NULL,
    node_1 character varying(16),
    node_2 character varying(16),
    elevmax1 numeric(12,3),
    elevmax2 numeric(12,3),
    arc_type character varying(30),
    arccat_id character varying(30),
    epa_type character varying(16),
    sector_id integer,
    state smallint,
    state_type smallint,
    annotation character varying(254),
    length numeric(12,3),
    n numeric(12,3),
    the_geom public.geometry(LineString,SRID_VALUE),
    expl_id integer,
    addparam text,
    arcparent character varying(16),
    q0 double precision,
    qmax double precision,
    barrels integer,
    slope double precision,
    flag boolean,
    culvert character varying(10),
    kentry numeric(12,4),
    kexit numeric(12,4),
    kavg numeric(12,4),
    flap character varying(3),
    seepage numeric(12,4),
    age integer
);


--
-- Name: temp_arc_flowregulator; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_arc_flowregulator (
    arc_id character varying(18) NOT NULL,
    type character varying(18),
    weir_type character varying(18),
    offsetval numeric(12,4),
    cd numeric(12,4),
    ec numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    geom1 numeric(12,4),
    geom2 numeric(12,4) DEFAULT 0.00,
    geom3 numeric(12,4) DEFAULT 0.00,
    geom4 numeric(12,4) DEFAULT 0.00,
    surcharge character varying(3),
    road_width double precision,
    road_surf character varying(16),
    coef_curve double precision,
    curve_id character varying(16),
    status character varying(3),
    startup numeric(12,4),
    shutoff numeric(12,4),
    ori_type character varying(18),
    orate numeric(12,4),
    shape character varying(18),
    close_time integer DEFAULT 0,
    outlet_type character varying(16),
    cd1 numeric(12,4)
);


--
-- Name: temp_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_arc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_arc_id_seq OWNED BY temp_arc.id;


--
-- Name: temp_csv; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_csv (
    id integer NOT NULL,
    fid integer,
    cur_user text DEFAULT "current_user"(),
    source text,
    csv1 text,
    csv2 text,
    csv3 text,
    csv4 text,
    csv5 text,
    csv6 text,
    csv7 text,
    csv8 text,
    csv9 text,
    csv10 text,
    csv11 text,
    csv12 text,
    csv13 text,
    csv14 text,
    csv15 text,
    csv16 text,
    csv17 text,
    csv18 text,
    csv19 text,
    csv20 text,
    csv21 text,
    csv22 text,
    csv23 text,
    csv24 text,
    csv25 text,
    csv26 text,
    csv27 text,
    csv28 text,
    csv29 text,
    csv30 text,
    csv31 text,
    csv32 text,
    csv33 text,
    csv34 text,
    csv35 text,
    csv36 text,
    csv37 text,
    csv38 text,
    csv39 text,
    csv40 text,
    tstamp timestamp without time zone DEFAULT now()
);


--
-- Name: temp_csv_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_csv_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_csv_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_csv_id_seq OWNED BY temp_csv.id;


--
-- Name: temp_data; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_data (
    id integer NOT NULL,
    fid smallint,
    feature_type character varying(16),
    feature_id character varying(16),
    enabled boolean,
    log_message text,
    tstamp timestamp without time zone DEFAULT now(),
    cur_user text DEFAULT "current_user"(),
    addparam json,
    float_value double precision,
    int_value integer,
    flag boolean
);


--
-- Name: temp_data_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_data_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_data_id_seq OWNED BY temp_data.id;


--
-- Name: temp_go2epa; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_go2epa (
    id integer NOT NULL,
    arc_id character varying(20),
    vnode_id character varying(20),
    locate double precision,
    top_elev double precision,
    ymax double precision,
    idmin integer
);


--
-- Name: temp_go2epa_id_seq1; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_go2epa_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_go2epa_id_seq1; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_go2epa_id_seq1 OWNED BY temp_go2epa.id;


--
-- Name: temp_gully; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_gully (
    gully_id character varying(16) NOT NULL,
    gully_type character varying(30),
    gratecat_id character varying(30),
    arc_id character varying(16),
    node_id character varying(16),
    sector_id integer,
    state smallint,
    state_type smallint,
    top_elev double precision,
    units integer,
    units_placement character varying(16),
    outlet_type character varying(30),
    width double precision,
    length double precision,
    depth double precision,
    method character varying(30),
    weir_cd double precision,
    orifice_cd double precision,
    a_param double precision,
    b_param double precision,
    efficiency integer,
    the_geom public.geometry(Point,SRID_VALUE)
);


--
-- Name: temp_lid_usage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_lid_usage (
    subc_id character varying(16) NOT NULL,
    lidco_id character varying(16) NOT NULL,
    numelem smallint,
    area numeric(16,6),
    width numeric(12,4),
    initsat numeric(12,4),
    fromimp numeric(12,4),
    toperv smallint,
    rptfile character varying(10)
);


--
-- Name: temp_link; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_link (
    link_id integer NOT NULL,
    vnode_id integer,
    vnode_type text,
    feature_id character varying(16),
    feature_type character varying(16),
    exit_id character varying(16),
    exit_type character varying(16),
    state smallint,
    expl_id integer,
    sector_id integer,
    dma_id integer,
    exit_topelev double precision,
    exit_elev double precision,
    the_geom public.geometry(LineString,SRID_VALUE),
    the_geom_endpoint public.geometry(Point,SRID_VALUE),
    flag boolean
);


--
-- Name: temp_link_x_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_link_x_arc (
    link_id integer NOT NULL,
    vnode_id integer,
    arc_id character varying(16),
    feature_type character varying(16),
    feature_id character varying(16),
    node_1 character varying(16),
    node_2 character varying(16),
    vnode_distfromnode1 numeric(12,3),
    vnode_distfromnode2 numeric(12,3),
    exit_topelev double precision,
    exit_ymax numeric(12,3),
    exit_elev numeric(12,3)
);


--
-- Name: temp_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_node (
    id integer NOT NULL,
    result_id character varying(30),
    node_id character varying(16) NOT NULL,
    top_elev numeric(12,3),
    ymax numeric(12,3),
    elev numeric(12,3),
    node_type character varying(30),
    nodecat_id character varying(30),
    epa_type character varying(16),
    sector_id integer,
    state smallint,
    state_type smallint,
    annotation character varying(254),
    y0 numeric(12,4),
    ysur numeric(12,4),
    apond numeric(12,4),
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer,
    addparam text,
    parent character varying(16),
    arcposition smallint,
    fusioned_node text,
    age integer
);


--
-- Name: temp_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_node_id_seq OWNED BY temp_node.id;


--
-- Name: temp_node_other; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_node_other (
    id integer NOT NULL,
    node_id character varying(16),
    type character varying(16),
    poll_id character varying(16),
    timser_id character varying(16),
    other character varying(30),
    mfactor numeric(12,4),
    sfactor numeric(12,4),
    base numeric(12,4),
    pattern_id character varying(16)
);


--
-- Name: temp_node_other_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_node_other_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_node_other_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_node_other_id_seq OWNED BY temp_node_other.id;


--
-- Name: temp_table; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_table (
    id integer NOT NULL,
    fid smallint,
    text_column text,
    geom_point public.geometry(Point,SRID_VALUE),
    geom_line public.geometry(LineString,SRID_VALUE),
    geom_polygon public.geometry(MultiPolygon,SRID_VALUE),
    cur_user text DEFAULT CURRENT_USER,
    addparam json,
    expl_id integer,
    macroexpl_id integer,
    sector_id integer,
    macrosector_id integer
);


--
-- Name: temp_table_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_table_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_table_id_seq OWNED BY temp_table.id;


--
-- Name: temp_vnode; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_vnode (
    id integer NOT NULL,
    l1 integer,
    v1 integer,
    l2 integer,
    v2 integer
);


--
-- Name: temp_vnode_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_vnode_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_vnode_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_vnode_id_seq OWNED BY temp_vnode.id;


--
-- Name: value_state_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE value_state_type (
    id smallint NOT NULL,
    state smallint,
    name character varying(30) NOT NULL,
    is_operative boolean DEFAULT true,
    is_doable boolean DEFAULT true
);


--
-- Name: value_state; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE value_state (
    id smallint NOT NULL,
    name character varying(30) NOT NULL,
    observ text,
    CONSTRAINT value_state_check CHECK ((id = ANY (ARRAY[0, 1, 2])))
);


--
-- Name: anl_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_arc ALTER COLUMN id SET DEFAULT nextval('anl_arc_id_seq'::regclass);


--
-- Name: anl_arc_x_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_arc_x_node ALTER COLUMN id SET DEFAULT nextval('anl_arc_x_node_id_seq'::regclass);


--
-- Name: anl_connec id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_connec ALTER COLUMN id SET DEFAULT nextval('anl_connec_id_seq'::regclass);


--
-- Name: anl_gully id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_gully ALTER COLUMN id SET DEFAULT nextval('anl_gully_id_seq'::regclass);


--
-- Name: anl_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_node ALTER COLUMN id SET DEFAULT nextval('anl_node_id_seq'::regclass);


--
-- Name: anl_polygon id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_polygon ALTER COLUMN id SET DEFAULT nextval('anl_polygon_id_seq'::regclass);


--
-- Name: audit_arc_traceability id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_arc_traceability ALTER COLUMN id SET DEFAULT nextval('audit_arc_traceability_id_seq'::regclass);


--
-- Name: audit_check_data id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_check_data ALTER COLUMN id SET DEFAULT nextval('audit_check_data_id_seq'::regclass);


--
-- Name: audit_check_project id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_check_project ALTER COLUMN id SET DEFAULT nextval('audit_check_project_id_seq'::regclass);


--
-- Name: audit_fid_log id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_fid_log ALTER COLUMN id SET DEFAULT nextval('audit_fid_log_id_seq'::regclass);


--
-- Name: audit_log_data id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_log_data ALTER COLUMN id SET DEFAULT nextval('audit_log_data_id_seq'::regclass);


--
-- Name: audit_psector_arc_traceability id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_arc_traceability ALTER COLUMN id SET DEFAULT nextval('audit_psector_arc_traceability_id_seq'::regclass);


--
-- Name: audit_psector_connec_traceability id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_connec_traceability ALTER COLUMN id SET DEFAULT nextval('audit_psector_connec_traceability_id_seq'::regclass);


--
-- Name: audit_psector_gully_traceability id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_gully_traceability ALTER COLUMN id SET DEFAULT nextval('audit_psector_gully_traceability_id_seq'::regclass);


--
-- Name: audit_psector_node_traceability id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_node_traceability ALTER COLUMN id SET DEFAULT nextval('audit_psector_node_traceability_id_seq'::regclass);


--
-- Name: cat_dscenario dscenario_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dscenario ALTER COLUMN dscenario_id SET DEFAULT nextval('cat_dscenario_dscenario_id_seq'::regclass);


--
-- Name: cat_dwf_scenario id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dwf_scenario ALTER COLUMN id SET DEFAULT nextval('cat_dwf_scenario_id_seq'::regclass);


--
-- Name: cat_hydrology hydrology_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_hydrology ALTER COLUMN hydrology_id SET DEFAULT nextval('cat_hydrology_hydrology_id_seq'::regclass);


--
-- Name: cat_manager id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_manager ALTER COLUMN id SET DEFAULT nextval('cat_manager_id_seq'::regclass);


--
-- Name: cat_workspace id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_workspace ALTER COLUMN id SET DEFAULT nextval('cat_workspace_id_seq'::regclass);


--
-- Name: config_csv fid; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_csv ALTER COLUMN fid SET DEFAULT nextval('config_csv_id_seq'::regclass);


--
-- Name: config_report id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_report ALTER COLUMN id SET DEFAULT nextval('config_report_id_seq'::regclass);


--
-- Name: config_visit_class id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_class ALTER COLUMN id SET DEFAULT nextval('om_visit_class_id_seq'::regclass);


--
-- Name: dimensions id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dimensions ALTER COLUMN id SET DEFAULT nextval('dimensions_id_seq'::regclass);


--
-- Name: dma dma_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dma ALTER COLUMN dma_id SET DEFAULT nextval('dma_dma_id_seq'::regclass);


--
-- Name: doc_x_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_arc ALTER COLUMN id SET DEFAULT nextval('doc_x_arc_id_seq'::regclass);


--
-- Name: doc_x_connec id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_connec ALTER COLUMN id SET DEFAULT nextval('doc_x_connec_id_seq'::regclass);


--
-- Name: doc_x_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_node ALTER COLUMN id SET DEFAULT nextval('doc_x_node_id_seq'::regclass);


--
-- Name: doc_x_psector id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_psector ALTER COLUMN id SET DEFAULT nextval('doc_x_psector_id_seq'::regclass);


--
-- Name: doc_x_visit id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_visit ALTER COLUMN id SET DEFAULT nextval('doc_x_visit_id_seq'::regclass);


--
-- Name: doc_x_workcat id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_workcat ALTER COLUMN id SET DEFAULT nextval('doc_x_workcat_id_seq'::regclass);


--
-- Name: drainzone drainzone_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY drainzone ALTER COLUMN drainzone_id SET DEFAULT nextval('drainzone_drainzone_id_seq'::regclass);


--
-- Name: element_x_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_arc ALTER COLUMN id SET DEFAULT nextval('element_x_arc_id_seq'::regclass);


--
-- Name: element_x_connec id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_connec ALTER COLUMN id SET DEFAULT nextval('element_x_connec_id_seq'::regclass);


--
-- Name: element_x_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_node ALTER COLUMN id SET DEFAULT nextval('element_x_node_id_seq'::regclass);


--
-- Name: ext_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_arc ALTER COLUMN id SET DEFAULT nextval('ext_arc_id_seq'::regclass);


--
-- Name: ext_cat_period_type id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_cat_period_type ALTER COLUMN id SET DEFAULT nextval('ext_cat_period_type_id_seq'::regclass);


--
-- Name: ext_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_node ALTER COLUMN id SET DEFAULT nextval('ext_node_id_seq'::regclass);


--
-- Name: ext_raster_dem id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_raster_dem ALTER COLUMN id SET DEFAULT nextval('raster_dem_id_seq'::regclass);


--
-- Name: ext_rtc_hydrometer_state id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_hydrometer_state ALTER COLUMN id SET DEFAULT nextval('ext_rtc_hydrometer_state_id_seq'::regclass);


--
-- Name: ext_timeseries id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_timeseries ALTER COLUMN id SET DEFAULT nextval('ext_timeseries_id_seq'::regclass);


--
-- Name: inp_controls id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_controls ALTER COLUMN id SET DEFAULT nextval('inp_controls_id_seq'::regclass);


--
-- Name: inp_dscenario_controls id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_controls ALTER COLUMN id SET DEFAULT nextval('inp_dscenario_controls_id_seq'::regclass);


--
-- Name: inp_flwreg_orifice id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_orifice ALTER COLUMN id SET DEFAULT nextval('inp_flwreg_orifice_id_seq'::regclass);


--
-- Name: inp_flwreg_outlet id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_outlet ALTER COLUMN id SET DEFAULT nextval('inp_flwreg_outlet_id_seq'::regclass);


--
-- Name: inp_flwreg_pump id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_pump ALTER COLUMN id SET DEFAULT nextval('inp_flwreg_pump_id_seq'::regclass);


--
-- Name: inp_flwreg_weir id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_weir ALTER COLUMN id SET DEFAULT nextval('inp_flwreg_weir_id_seq'::regclass);


--
-- Name: inp_lid_value id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_lid_value ALTER COLUMN id SET DEFAULT nextval('inp_lid_value_id_seq'::regclass);


--
-- Name: inp_snowpack_value id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_snowpack_value ALTER COLUMN id SET DEFAULT nextval('inp_snowpack_id_seq'::regclass);


--
-- Name: inp_temperature id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_temperature ALTER COLUMN id SET DEFAULT nextval('inp_temperature_id_seq'::regclass);


--
-- Name: link link_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY link ALTER COLUMN link_id SET DEFAULT nextval('link_link_id_seq'::regclass);


--
-- Name: macrodma macrodma_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrodma ALTER COLUMN macrodma_id SET DEFAULT nextval('macrodma_macrodma_id_seq'::regclass);


--
-- Name: macrosector macrosector_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrosector ALTER COLUMN macrosector_id SET DEFAULT nextval('macrosector_macrosector_id_seq'::regclass);


--
-- Name: man_addfields_value id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_addfields_value ALTER COLUMN id SET DEFAULT nextval('man_addfields_value_id_seq'::regclass);


--
-- Name: man_type_category id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_category ALTER COLUMN id SET DEFAULT nextval('man_type_category_id_seq'::regclass);


--
-- Name: man_type_fluid id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_fluid ALTER COLUMN id SET DEFAULT nextval('man_type_fluid_id_seq'::regclass);


--
-- Name: man_type_function id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_function ALTER COLUMN id SET DEFAULT nextval('man_type_function_id_seq'::regclass);


--
-- Name: man_type_location id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_location ALTER COLUMN id SET DEFAULT nextval('man_type_location_id_seq'::regclass);


--
-- Name: om_reh_parameter_x_works id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_reh_parameter_x_works ALTER COLUMN id SET DEFAULT nextval('om_reh_parameter_x_works_id_seq'::regclass);


--
-- Name: om_reh_works_x_pcompost id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_reh_works_x_pcompost ALTER COLUMN id SET DEFAULT nextval('om_reh_works_x_pcompost_id_seq'::regclass);


--
-- Name: om_visit id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit ALTER COLUMN id SET DEFAULT nextval('om_visit_id_seq'::regclass);


--
-- Name: om_visit_cat id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_cat ALTER COLUMN id SET DEFAULT nextval('om_visit_cat_id_seq'::regclass);


--
-- Name: om_visit_event id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event ALTER COLUMN id SET DEFAULT nextval('om_visit_event_id_seq'::regclass);


--
-- Name: om_visit_event_photo id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event_photo ALTER COLUMN id SET DEFAULT nextval('om_visit_event_photo_id_seq'::regclass);


--
-- Name: om_visit_x_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_arc ALTER COLUMN id SET DEFAULT nextval('om_visit_x_arc_id_seq'::regclass);


--
-- Name: om_visit_x_connec id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_connec ALTER COLUMN id SET DEFAULT nextval('om_visit_x_connec_id_seq'::regclass);


--
-- Name: om_visit_x_gully id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_gully ALTER COLUMN id SET DEFAULT nextval('om_visit_x_gully_id_seq'::regclass);


--
-- Name: om_visit_x_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_node ALTER COLUMN id SET DEFAULT nextval('om_visit_x_node_id_seq'::regclass);


--
-- Name: plan_arc_x_pavement id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_arc_x_pavement ALTER COLUMN id SET DEFAULT nextval('plan_arc_x_pavement_id_seq'::regclass);


--
-- Name: plan_price_compost id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_price_compost ALTER COLUMN id SET DEFAULT nextval('price_compost_value_id_seq'::regclass);


--
-- Name: plan_psector_x_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_arc ALTER COLUMN id SET DEFAULT nextval('plan_psector_x_arc_id_seq'::regclass);


--
-- Name: plan_psector_x_connec id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_connec ALTER COLUMN id SET DEFAULT nextval('plan_psector_x_connec_id_seq'::regclass);


--
-- Name: plan_psector_x_gully id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_gully ALTER COLUMN id SET DEFAULT nextval('plan_psector_x_gully_id_seq'::regclass);


--
-- Name: plan_psector_x_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_node ALTER COLUMN id SET DEFAULT nextval('plan_psector_x_node_id_seq'::regclass);


--
-- Name: plan_psector_x_other id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_other ALTER COLUMN id SET DEFAULT nextval('plan_psector_x_other_id_seq'::regclass);


--
-- Name: plan_result_cat result_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_result_cat ALTER COLUMN result_id SET DEFAULT nextval('om_result_cat_result_id_seq'::regclass);


--
-- Name: review_audit_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_arc ALTER COLUMN id SET DEFAULT nextval('review_audit_arc_id_seq'::regclass);


--
-- Name: review_audit_connec id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_connec ALTER COLUMN id SET DEFAULT nextval('review_audit_connec_id_seq'::regclass);


--
-- Name: review_audit_gully id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_gully ALTER COLUMN id SET DEFAULT nextval('review_audit_gully_id_seq'::regclass);


--
-- Name: review_audit_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_node ALTER COLUMN id SET DEFAULT nextval('review_audit_node_id_seq'::regclass);


--
-- Name: rpt_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arc ALTER COLUMN id SET DEFAULT nextval('rpt_arc_id_seq'::regclass);


--
-- Name: rpt_arcpollutant_sum id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arcpollutant_sum ALTER COLUMN id SET DEFAULT nextval('rpt_arcpollutant_sum_id_seq'::regclass);


--
-- Name: rpt_control_actions_taken id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_control_actions_taken ALTER COLUMN id SET DEFAULT nextval('rpt_control_actions_taken_id_seq'::regclass);


--
-- Name: rpt_inp_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_arc ALTER COLUMN id SET DEFAULT nextval('rpt_inp_arc_id_seq'::regclass);


--
-- Name: rpt_inp_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_node ALTER COLUMN id SET DEFAULT nextval('rpt_inp_node_id_seq'::regclass);


--
-- Name: rpt_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_node ALTER COLUMN id SET DEFAULT nextval('rpt_node_id_seq'::regclass);


--
-- Name: rpt_subcatchment id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_subcatchment ALTER COLUMN id SET DEFAULT nextval('rpt_subcatchment_id_seq'::regclass);


--
-- Name: rpt_summary_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_arc ALTER COLUMN id SET DEFAULT nextval('rpt_summary_arc_id_seq'::regclass);


--
-- Name: rpt_summary_crossection id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_crossection ALTER COLUMN id SET DEFAULT nextval('rpt_summary_crossection_id_seq'::regclass);


--
-- Name: rpt_summary_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_node ALTER COLUMN id SET DEFAULT nextval('rpt_summary_node_id_seq'::regclass);


--
-- Name: rpt_summary_raingage id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_raingage ALTER COLUMN id SET DEFAULT nextval('rpt_summary_raingage_id_seq'::regclass);


--
-- Name: rpt_summary_subcatchment id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_subcatchment ALTER COLUMN id SET DEFAULT nextval('rpt_summary_subcatchment_id_seq'::regclass);


--
-- Name: rpt_warning_summary id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_warning_summary ALTER COLUMN id SET DEFAULT nextval('rpt_warning_summary_id_seq'::regclass);


--
-- Name: rtc_scada_x_dma id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_scada_x_dma ALTER COLUMN id SET DEFAULT nextval('rtc_scada_x_dma_id_seq'::regclass);


--
-- Name: rtc_scada_x_sector id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_scada_x_sector ALTER COLUMN id SET DEFAULT nextval('rtc_scada_x_sector_id_seq'::regclass);


--
-- Name: sector sector_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sector ALTER COLUMN sector_id SET DEFAULT nextval('sector_sector_id_seq'::regclass);


--
-- Name: sys_addfields id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_addfields ALTER COLUMN id SET DEFAULT nextval('sys_addfields_id_seq'::regclass);


--
-- Name: sys_foreignkey id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_foreignkey ALTER COLUMN id SET DEFAULT nextval('sys_foreingkey_id_seq'::regclass);


--
-- Name: sys_image id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_image ALTER COLUMN id SET DEFAULT nextval('sys_image_id_seq'::regclass);


--
-- Name: sys_style id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_style ALTER COLUMN id SET DEFAULT nextval('sys_style_id_seq'::regclass);


--
-- Name: sys_version id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_version ALTER COLUMN id SET DEFAULT nextval('sys_version_id_seq'::regclass);


--
-- Name: temp_anlgraph id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_anlgraph ALTER COLUMN id SET DEFAULT nextval('temp_anlgraph_id_seq'::regclass);


--
-- Name: temp_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_arc ALTER COLUMN id SET DEFAULT nextval('temp_arc_id_seq'::regclass);


--
-- Name: temp_csv id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_csv ALTER COLUMN id SET DEFAULT nextval('temp_csv_id_seq'::regclass);


--
-- Name: temp_data id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_data ALTER COLUMN id SET DEFAULT nextval('temp_data_id_seq'::regclass);


--
-- Name: temp_go2epa id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_go2epa ALTER COLUMN id SET DEFAULT nextval('temp_go2epa_id_seq1'::regclass);


--
-- Name: temp_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_node ALTER COLUMN id SET DEFAULT nextval('temp_node_id_seq'::regclass);


--
-- Name: temp_node_other id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_node_other ALTER COLUMN id SET DEFAULT nextval('temp_node_other_id_seq'::regclass);


--
-- Name: temp_table id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_table ALTER COLUMN id SET DEFAULT nextval('temp_table_id_seq'::regclass);


--
-- Name: temp_vnode id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_vnode ALTER COLUMN id SET DEFAULT nextval('temp_vnode_id_seq'::regclass);