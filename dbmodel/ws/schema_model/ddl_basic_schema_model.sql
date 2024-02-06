/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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
    losses numeric(12,4),
    dma_id integer,
    presszone_id text,
    dqa_id integer,
    minsector_id integer,
    addparam text,
    sector_id integer
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
    elevation double precision,
    elev double precision,
    depth double precision,
    state_type integer,
    sector_id integer,
    losses numeric(12,4),
    dma_id integer,
    presszone_id text,
    dqa_id integer,
    minsector_id integer,
    demand double precision,
    addparam text
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
    arccat_id character varying(30) NOT NULL,
    epa_type character varying(16) NOT NULL,
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    annotation text,
    observ text,
    comment text,
    _sys_length numeric(12,2),
    custom_length numeric(12,2),
    dma_id integer NOT NULL,
    presszone_id character varying(30),
    soilcat_id character varying(30),
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
    descript character varying(254),
    link character varying(512),
    verified character varying(30),
    the_geom public.geometry(LineString,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16) DEFAULT 'ARC'::character varying,
    tstamp timestamp without time zone DEFAULT now(),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50) DEFAULT CURRENT_USER,
    minsector_id integer,
    dqa_id integer,
    staticpressure numeric(12,3),
    district_id integer,
    depth numeric(12,3),
    adate text,
    adescript text,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    pavcat_id character varying(30),
    nodetype_1 character varying(30),
    elevation1 numeric(12,4),
    depth1 numeric(12,4),
    staticpress1 numeric(12,3),
    nodetype_2 character varying(30),
    elevation2 numeric(12,4),
    depth2 numeric(12,4),
    staticpress2 numeric(12,3),
    om_state text,
    conserv_state text,
    parent_id character varying(16),
    expl_id2 integer,
    CONSTRAINT arc_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['PIPE'::text, 'UNDEFINED'::text, 'PUMP-IMPORTINP'::text, 'VALVE-IMPORTINP'::text, 'VIRTUALVALVE'::text])))
);


--
-- Name: TABLE arc; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE arc IS 'FIELD _sys_length IS NOT USED. Value is calculated on the fly on views (3.3.021)';


--
-- Name: arc_add; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE arc_add (
    arc_id character varying(16) NOT NULL,
    flow_max numeric(12,2),
    flow_min numeric(12,2),
    flow_avg numeric(12,2),
    vel_max numeric(12,2),
    vel_min numeric(12,2),
    vel_avg numeric(12,2),
    result_id text
);


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
    arccat_id character varying(30) NOT NULL,
    epa_type character varying(16) NOT NULL,
    sector_id integer NOT NULL,
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    annotation text,
    observ text,
    comment text,
    _sys_length numeric(12,2),
    custom_length numeric(12,2),
    dma_id integer NOT NULL,
    presszone_id character varying(30),
    soilcat_id character varying(30),
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
    descript character varying(254),
    link character varying(512),
    verified character varying(30),
    the_geom public.geometry(LineString,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16),
    tstamp timestamp without time zone,
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50),
    minsector_id integer,
    dqa_id integer,
    staticpressure numeric(12,3),
    district_id integer,
    depth numeric(12,3),
    adate text,
    adescript text,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    pavcat_id character varying(30),
    nodetype_1 character varying(30),
    elevation1 numeric(12,4),
    depth1 numeric(12,4),
    staticpress1 numeric(12,3),
    nodetype_2 character varying(30),
    elevation2 numeric(12,4),
    depth2 numeric(12,4),
    staticpress2 numeric(12,3),
    om_state text,
    conserv_state text,
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
    elevation numeric(12,4),
    depth numeric(12,4),
    connecat_id character varying(30) NOT NULL,
    sector_id integer NOT NULL,
    customer_code character varying(30),
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    arc_id character varying(16),
    connec_length numeric(12,3),
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    presszone_id character varying(30),
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
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16),
    tstamp timestamp without time zone,
    pjoint_type character varying(16),
    pjoint_id character varying(16),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50),
    minsector_id integer,
    dqa_id integer,
    staticpressure numeric(12,3),
    district_id integer,
    adate text,
    adescript text,
    accessibility smallint,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    epa_type text,
    om_state text,
    conserv_state text,
    priority text,
    valve_location text,
    valve_type text,
    shutoff_valve text,
    access_type text,
    placement_type text,
    crmzone_id integer,
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
    elevation numeric(12,4),
    depth numeric(12,4),
    nodecat_id character varying(30) NOT NULL,
    epa_type character varying(16) NOT NULL,
    sector_id integer NOT NULL,
    arc_id character varying(16),
    parent_id character varying(16),
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    presszone_id character varying(30),
    soilcat_id character varying(30),
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
    descript character varying(254),
    link character varying(512),
    verified character varying(30),
    rotation numeric(6,3),
    the_geom public.geometry(Point,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    hemisphere double precision,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16),
    tstamp timestamp without time zone,
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50),
    minsector_id integer,
    dqa_id integer,
    staticpressure numeric(12,3),
    district_id integer,
    adate text,
    adescript text,
    accessibility smallint,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    om_state text,
    conserv_state text,
    access_type text,
    placement_type text,
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
    arctype_id character varying(30) NOT NULL,
    matcat_id character varying(30),
    pnom character varying(16),
    dnom character varying(16),
    dint numeric(12,5),
    dext numeric(12,5),
    descript character varying(512),
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
    shape character varying(30) DEFAULT 'CIRCULAR'::character varying,
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
    active boolean DEFAULT true
);


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
    connectype_id character varying(18) NOT NULL,
    matcat_id character varying(16),
    pnom character varying(16),
    dnom character varying(16),
    dint numeric(12,5),
    dext numeric(12,5),
    descript character varying(512),
    link character varying(512),
    brand character varying(30),
    model character varying(30),
    svg character varying(50),
    active boolean DEFAULT true,
    label character varying(255)
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
    CONSTRAINT cat_feature_arc_inp_check CHECK (((epa_default)::text = ANY (ARRAY['PIPE'::text, 'UNDEFINED'::text, 'PUMP-IMPORTINP'::text, 'VALVE-IMPORTINP'::text, 'VIRTUALVALVE'::text])))
);


--
-- Name: cat_feature_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_feature_connec (
    id character varying(30) NOT NULL,
    type character varying(30) NOT NULL,
    double_geom json DEFAULT '{"activated":false,"value":1}'::json,
    epa_default character varying(30) DEFAULT 'JUNCTION'::character varying NOT NULL
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
    graph_delimiter character varying(20) DEFAULT 'NONE'::character varying,
    isprofilesurface boolean DEFAULT true,
    double_geom json DEFAULT '{"activated":false,"value":1}'::json,
    CONSTRAINT cat_feature_node_inp_check CHECK (((epa_default)::text = ANY (ARRAY['JUNCTION'::text, 'RESERVOIR'::text, 'TANK'::text, 'INLET'::text, 'UNDEFINED'::text, 'SHORTPIPE'::text, 'VALVE'::text, 'PUMP'::text]))),
    CONSTRAINT node_type_graph_delimiter_check CHECK (((graph_delimiter)::text = ANY (ARRAY['NONE'::text, 'MINSECTOR'::text, 'PRESSZONE'::text, 'DQA'::text, 'DMA'::text, 'SECTOR'::text, 'CHECKVALVE'::text])))
);


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
-- Name: cat_mat_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_mat_node (
    id character varying(30) NOT NULL,
    descript character varying(512),
    link character varying(512),
    active boolean DEFAULT true
);


--
-- Name: cat_mat_roughness; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_mat_roughness (
    id integer NOT NULL,
    matcat_id character varying(30) NOT NULL,
    period_id character varying(30) DEFAULT 'Default'::character varying NOT NULL,
    init_age integer DEFAULT 0 NOT NULL,
    end_age integer DEFAULT 999 NOT NULL,
    roughness numeric(12,4),
    descript text,
    active boolean DEFAULT true
);


--
-- Name: cat_mat_roughness_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE cat_mat_roughness_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cat_mat_roughness_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE cat_mat_roughness_id_seq OWNED BY cat_mat_roughness.id;


--
-- Name: cat_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE cat_node (
    id character varying(30) NOT NULL,
    nodetype_id character varying(30) NOT NULL,
    matcat_id character varying(30),
    pnom character varying(16),
    dnom character varying(16),
    dint numeric(12,5),
    dext numeric(12,5),
    shape character varying(50),
    descript character varying(512),
    link character varying(512),
    brand character varying(30),
    model character varying(30),
    svg character varying(50),
    estimated_depth numeric(12,2),
    cost_unit character varying(3) DEFAULT 'u'::character varying,
    cost character varying(16),
    active boolean DEFAULT true,
    label character varying(255),
    ischange smallint DEFAULT 2,
    acoeff double precision,
    CONSTRAINT cat_node_ischange_check CHECK ((ischange = ANY (ARRAY[0, 1, 2])))
);


--
-- Name: TABLE cat_node; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE cat_node IS 'FIELD ischange has three values 0-false, 1-true, 2-maybe (by default)';


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
-- Name: config_graph_checkvalve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_graph_checkvalve (
    node_id character varying(16) NOT NULL,
    to_arc character varying(16) NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: config_graph_inlet; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_graph_inlet (
    node_id character varying(16) NOT NULL,
    expl_id integer NOT NULL,
    parameters json,
    active boolean DEFAULT true
);


--
-- Name: TABLE config_graph_inlet; Type: COMMENT; Schema: Schema; Owner: -
--

COMMENT ON TABLE config_graph_inlet IS 'FIELD _toarc IS DEPRECATED';


--
-- Name: config_graph_valve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE config_graph_valve (
    id character varying(50) NOT NULL,
    active boolean DEFAULT true
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
    connec_id character varying(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
    code character varying(30),
    elevation numeric(12,4),
    depth numeric(12,4),
    connecat_id character varying(30) NOT NULL,
    sector_id integer NOT NULL,
    customer_code character varying(30),
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    arc_id character varying(16),
    connec_length numeric(12,3),
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    presszone_id character varying(30),
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
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16) DEFAULT 'CONNEC'::character varying,
    tstamp timestamp without time zone DEFAULT now(),
    pjoint_type character varying(16),
    pjoint_id character varying(16),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50) DEFAULT CURRENT_USER,
    minsector_id integer,
    dqa_id integer,
    staticpressure numeric(12,3),
    district_id integer,
    adate text,
    adescript text,
    accessibility smallint,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    epa_type text,
    om_state text,
    conserv_state text,
    priority text,
    valve_location text,
    valve_type text,
    shutoff_valve text,
    access_type text,
    placement_type text,
    crmzone_id integer,
    expl_id2 integer,
    CONSTRAINT connec_epa_type_check CHECK ((epa_type = ANY (ARRAY['JUNCTION'::text, 'UNDEFINED'::text]))),
    CONSTRAINT connec_pjoint_type_check CHECK (((pjoint_type)::text = ANY (ARRAY['NODE'::text, 'ARC'::text, 'CONNEC'::text])))
);


--
-- Name: connec_add; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE connec_add (
    connec_id character varying(16) NOT NULL,
    press_max numeric(12,2),
    press_min numeric(12,2),
    press_avg numeric(12,2),
    demand numeric(12,2),
    quality_max numeric(12,4),
    quality_avg numeric(12,4),
    quality_min numeric(12,4),
    result_id text
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
-- Name: crm_zone; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE crm_zone (
    id integer NOT NULL,
    name text,
    descript text,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    active boolean DEFAULT true
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
    graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json,
    stylesheet json,
    active boolean DEFAULT true,
    avg_press numeric,
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
-- Name: dqa; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE dqa (
    dqa_id integer NOT NULL,
    name character varying(30),
    expl_id integer,
    macrodqa_id integer,
    descript text,
    undelete boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    pattern_id character varying(16),
    dqa_type character varying(16),
    link text,
    graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json,
    stylesheet json,
    active boolean DEFAULT true,
    tstamp timestamp without time zone DEFAULT now(),
    insert_user character varying(15) DEFAULT CURRENT_USER,
    lastupdate timestamp without time zone,
    lastupdate_user character varying(15)
);


--
-- Name: dqa_dqa_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE dqa_dqa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dqa_dqa_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE dqa_dqa_id_seq OWNED BY dqa.dqa_id;


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
    state_type smallint NOT NULL,
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
    code text,
    pattern_id character varying(16)
);


--
-- Name: ext_municipality; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_municipality (
    muni_id integer NOT NULL,
    name text NOT NULL,
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
    cat_period_id character varying(16),
    effc double precision,
    minc double precision,
    maxc double precision,
    pattern_id character varying(16),
    pattern_volume double precision,
    avg_press numeric
);


--
-- Name: ext_rtc_hydrometer; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_hydrometer (
    id character varying(16) NOT NULL,
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
    connec_id character varying(30),
    hydrometer_customer_code character varying(30),
    plot_code character varying(30),
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
    shutdown_date date
);


--
-- Name: ext_rtc_hydrometer_state; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_hydrometer_state (
    id integer NOT NULL,
    name text NOT NULL,
    observ text,
    is_operative boolean
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
-- Name: ext_rtc_scada; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_scada (
    scada_id character varying(30) NOT NULL,
    source character varying(30),
    source_id character varying(30),
    node_id character varying(16),
    code character varying(50),
    type_id character varying(50),
    class_id character varying(50),
    category_id character varying(50),
    catalog_id character varying(50),
    descript text
);


--
-- Name: ext_rtc_scada_x_data; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE ext_rtc_scada_x_data (
    node_id character varying(16) NOT NULL,
    value_date timestamp without time zone NOT NULL,
    value double precision,
    value_type integer,
    value_status integer,
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
-- Name: inp_backdrop_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_backdrop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_backdrop; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_backdrop (
    id integer DEFAULT nextval('inp_backdrop_id_seq'::regclass) NOT NULL,
    text character varying(254)
);


--
-- Name: inp_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_connec (
    connec_id character varying(16) NOT NULL,
    demand numeric(12,6),
    pattern_id character varying(16),
    peak_factor numeric(12,4),
    custom_roughness double precision,
    custom_length double precision,
    custom_dint double precision,
    status character varying(16),
    minorloss double precision
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
    x_value numeric(12,4) NOT NULL,
    y_value numeric(12,4) NOT NULL
);


--
-- Name: inp_dscenario_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_connec (
    dscenario_id integer NOT NULL,
    connec_id character varying(16) NOT NULL,
    demand numeric(12,6),
    pattern_id character varying(16),
    peak_factor numeric(12,4),
    status character varying(16),
    minorloss double precision,
    custom_roughness double precision,
    custom_length double precision,
    custom_dint double precision
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
-- Name: inp_dscenario_demand; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_demand (
    id integer NOT NULL,
    dscenario_id integer NOT NULL,
    feature_id character varying(16) NOT NULL,
    feature_type character varying(16),
    demand numeric(12,6),
    pattern_id character varying(16),
    demand_type character varying(18),
    source text
);


--
-- Name: inp_dscenario_demand_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_dscenario_demand_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_dscenario_demand_id_seq1; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_dscenario_demand_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_dscenario_demand_id_seq1; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_dscenario_demand_id_seq1 OWNED BY inp_dscenario_demand.id;


--
-- Name: inp_dscenario_inlet; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_inlet (
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    initlevel numeric(12,4),
    minlevel numeric(12,4),
    maxlevel numeric(12,4),
    diameter numeric(12,4),
    minvol numeric(12,4),
    curve_id character varying(16),
    head double precision,
    pattern_id character varying(16),
    overflow character varying(3)
);


--
-- Name: inp_dscenario_junction; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_junction (
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    demand numeric(12,6),
    pattern_id character varying(16),
    peak_factor numeric(12,4)
);


--
-- Name: inp_dscenario_pipe; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_pipe (
    dscenario_id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    minorloss numeric(12,6),
    status character varying(12),
    roughness numeric(12,4),
    dint numeric(12,3),
    CONSTRAINT inp_dscenario_pipe_status_check CHECK (((status)::text = ANY (ARRAY[('CLOSED'::character varying)::text, ('CV'::character varying)::text, ('OPEN'::character varying)::text])))
);


--
-- Name: inp_dscenario_pump; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_pump (
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    power character varying,
    curve_id character varying,
    speed numeric(12,6),
    pattern character varying,
    status character varying(12),
    CONSTRAINT inp_dscenario_pump_status_check CHECK (((status)::text = ANY (ARRAY[('CLOSED'::character varying)::text, ('OPEN'::character varying)::text])))
);


--
-- Name: inp_dscenario_pump_additional; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_pump_additional (
    id integer NOT NULL,
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    order_id smallint,
    power character varying,
    curve_id character varying,
    speed numeric(12,6),
    pattern character varying,
    status character varying(12),
    energyparam character varying(30),
    energyvalue character varying(30),
    CONSTRAINT inp_dscenario_pump_additional_pattern_check CHECK (((status)::text = ANY (ARRAY[('CLOSED'::character varying)::text, ('OPEN'::character varying)::text])))
);


--
-- Name: inp_dscenario_pump_additional_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_dscenario_pump_additional_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_dscenario_pump_additional_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_dscenario_pump_additional_id_seq OWNED BY inp_dscenario_pump_additional.id;


--
-- Name: inp_dscenario_reservoir; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_reservoir (
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    pattern_id character varying(16),
    head double precision
);


--
-- Name: inp_dscenario_rules; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_rules (
    id integer NOT NULL,
    dscenario_id integer NOT NULL,
    sector_id integer NOT NULL,
    text text NOT NULL,
    active boolean
);


--
-- Name: inp_dscenario_rules_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_dscenario_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_dscenario_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_dscenario_rules_id_seq OWNED BY inp_dscenario_rules.id;


--
-- Name: inp_dscenario_shortpipe; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_shortpipe (
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    minorloss numeric(12,6),
    status character varying(12),
    CONSTRAINT inp_dscenario_shortpipe_status_check CHECK (((status)::text = ANY (ARRAY[('CLOSED'::character varying)::text, ('CV'::character varying)::text, ('OPEN'::character varying)::text])))
);


--
-- Name: inp_dscenario_tank; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_tank (
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    initlevel numeric(12,4),
    minlevel numeric(12,4),
    maxlevel numeric(12,4),
    diameter numeric(12,4),
    minvol numeric(12,4),
    curve_id character varying(16),
    overflow character varying(3)
);


--
-- Name: inp_dscenario_valve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_valve (
    dscenario_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    valv_type character varying(18),
    pressure numeric(12,4),
    flow numeric(12,4),
    coef_loss numeric(12,4),
    curve_id character varying(16),
    minorloss numeric(12,4),
    status character varying(12) DEFAULT 'ACTIVE'::character varying,
    add_settings double precision,
    CONSTRAINT inp_dscenario_valve_status_check CHECK (((status)::text = ANY (ARRAY[('ACTIVE'::character varying)::text, ('CLOSED'::character varying)::text, ('OPEN'::character varying)::text]))),
    CONSTRAINT inp_dscenario_valve_valv_type_check CHECK (((valv_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text])))
);


--
-- Name: inp_dscenario_virtualvalve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_dscenario_virtualvalve (
    dscenario_id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    valv_type character varying(18),
    pressure numeric(12,4),
    diameter numeric(12,4),
    flow numeric(12,4),
    coef_loss numeric(12,4),
    curve_id character varying(16),
    minorloss numeric(12,4),
    status character varying(12)
);


--
-- Name: inp_emitter; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_emitter (
    node_id character varying(16) NOT NULL,
    coef numeric
);


--
-- Name: inp_energy; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_energy (
    id integer NOT NULL,
    descript text
);


--
-- Name: inp_energy_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_energy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_energy_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_energy_id_seq OWNED BY inp_energy.id;


--
-- Name: inp_inlet; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_inlet (
    node_id character varying(16) NOT NULL,
    initlevel numeric(12,4),
    minlevel numeric(12,4),
    maxlevel numeric(12,4),
    diameter numeric(12,4),
    minvol numeric(12,4),
    curve_id character varying(16),
    pattern_id character varying(16),
    overflow character varying(3),
    head double precision
);


--
-- Name: inp_junction; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_junction (
    node_id character varying(16) NOT NULL,
    demand numeric(12,6),
    pattern_id character varying(16),
    peak_factor numeric(12,4)
);


--
-- Name: inp_labels_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_label; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_label (
    id integer DEFAULT nextval('inp_labels_id_seq'::regclass) NOT NULL,
    xcoord numeric(18,6),
    ycoord numeric(18,6),
    label character varying(50),
    node_id character varying(16)
);


--
-- Name: inp_mixing; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_mixing (
    node_id character varying(16) NOT NULL,
    mix_type character varying(18),
    value numeric,
    CONSTRAINT inp_mixing_mix_type_check CHECK (((mix_type)::text = ANY ((ARRAY['2COMP'::character varying, 'FIFO'::character varying, 'LIFO'::character varying, 'MIXED'::character varying])::text[])))
);


--
-- Name: inp_pattern; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pattern (
    pattern_id character varying(16) NOT NULL,
    observ text,
    tscode text,
    tsparameters json,
    expl_id integer,
    log text
);


--
-- Name: inp_pattern_value_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_pattern_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_pattern_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pattern_value (
    id integer DEFAULT nextval('inp_pattern_value_id_seq'::regclass) NOT NULL,
    pattern_id character varying(16) NOT NULL,
    factor_1 numeric(12,4) DEFAULT 1,
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
    factor_18 numeric(12,4)
);


--
-- Name: inp_pipe; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pipe (
    arc_id character varying(16) NOT NULL,
    minorloss numeric(12,6) DEFAULT 0,
    status character varying(12),
    custom_roughness numeric(12,4),
    custom_dint numeric(12,3),
    reactionparam character varying(30),
    reactionvalue character varying(30),
    CONSTRAINT inp_pipe_status_check CHECK (((status)::text = ANY ((ARRAY['CLOSED'::character varying, 'CV'::character varying, 'OPEN'::character varying])::text[])))
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
-- Name: inp_pump; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pump (
    node_id character varying(16) NOT NULL,
    power character varying,
    curve_id character varying,
    speed numeric(12,6),
    pattern character varying,
    status character varying(12),
    to_arc character varying(16),
    energyparam character varying(30),
    energyvalue character varying(30),
    pump_type character varying(16) DEFAULT 'FLOWPUMP'::character varying,
    CONSTRAINT inp_pump_status_check CHECK (((status)::text = ANY ((ARRAY['CLOSED'::character varying, 'OPEN'::character varying])::text[])))
);


--
-- Name: inp_pump_additional; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pump_additional (
    id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    order_id smallint,
    power character varying,
    curve_id character varying,
    speed numeric(12,6),
    pattern character varying,
    status character varying(12),
    energyparam character varying(30),
    energyvalue character varying(30),
    CONSTRAINT inp_pump_additional_pattern_check CHECK (((status)::text = ANY ((ARRAY['CLOSED'::character varying, 'OPEN'::character varying])::text[])))
);


--
-- Name: inp_pump_additional_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_pump_additional_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_pump_additional_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_pump_additional_id_seq OWNED BY inp_pump_additional.id;


--
-- Name: inp_pump_importinp; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_pump_importinp (
    arc_id character varying(16) NOT NULL,
    power character varying,
    curve_id character varying,
    speed numeric(12,6),
    pattern character varying,
    status character varying(12),
    energyparam character varying(30),
    energyvalue character varying(30),
    to_arc character varying(16)
);


--
-- Name: inp_quality; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_quality (
    node_id character varying(16) NOT NULL,
    initqual numeric
);


--
-- Name: inp_reactions; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_reactions (
    id integer NOT NULL,
    descript text
);


--
-- Name: inp_reactions_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_reactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_reactions_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_reactions_id_seq OWNED BY inp_reactions.id;


--
-- Name: inp_reservoir; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_reservoir (
    node_id character varying(16) NOT NULL,
    pattern_id character varying(16),
    head double precision
);


--
-- Name: inp_rules; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_rules (
    id integer NOT NULL,
    sector_id integer NOT NULL,
    text text NOT NULL,
    active boolean
);


--
-- Name: inp_rules_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE inp_rules_id_seq OWNED BY inp_rules.id;


--
-- Name: inp_sector_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE inp_sector_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inp_shortpipe; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_shortpipe (
    node_id character varying(16) NOT NULL,
    minorloss numeric(12,6) DEFAULT 0,
    to_arc character varying(16),
    status character varying(12),
    CONSTRAINT inp_shortpipe_status_check CHECK (((status)::text = ANY ((ARRAY['CLOSED'::character varying, 'CV'::character varying, 'OPEN'::character varying])::text[])))
);


--
-- Name: inp_source; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_source (
    node_id character varying(16) NOT NULL,
    sourc_type character varying(18),
    quality numeric(12,6),
    pattern_id character varying(16),
    CONSTRAINT inp_source_sourc_type_check CHECK (((sourc_type)::text = ANY ((ARRAY['CONCEN'::character varying, 'FLOWPACED'::character varying, 'MASS'::character varying, 'SETPOINT'::character varying])::text[])))
);


--
-- Name: inp_tags; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_tags (
    feature_type character varying(18) NOT NULL,
    feature_id character varying(16) NOT NULL,
    tag character varying(50)
);


--
-- Name: inp_tank; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_tank (
    node_id character varying(16) NOT NULL,
    initlevel numeric(12,4),
    minlevel numeric(12,4),
    maxlevel numeric(12,4),
    diameter numeric(12,4),
    minvol numeric(12,4),
    curve_id character varying(16),
    overflow character varying(3)
);


--
-- Name: inp_times; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_times (
    id integer NOT NULL,
    duration integer,
    hydraulic_timestep character varying(10),
    quality_timestep character varying(10),
    rule_timestep character varying(10),
    pattern_timestep character varying(10),
    pattern_start character varying(10),
    report_timestep character varying(10),
    report_start character varying(10),
    start_clocktime character varying(10),
    statistic character varying(18)
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
-- Name: inp_value_yesnofull; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_value_yesnofull (
    id character varying(18) NOT NULL,
    CONSTRAINT inp_value_yesnofull_check CHECK (((id)::text = ANY ((ARRAY['FULL'::character varying, 'NO'::character varying, 'YES'::character varying])::text[])))
);


--
-- Name: inp_valve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_valve (
    node_id character varying(16) NOT NULL,
    valv_type character varying(18),
    pressure numeric(12,4),
    custom_dint numeric(12,4),
    flow numeric(12,4),
    coef_loss numeric(12,4),
    curve_id character varying(16),
    minorloss numeric(12,4) DEFAULT 0,
    status character varying(12) DEFAULT 'ACTIVE'::character varying,
    to_arc character varying(16),
    add_settings double precision,
    CONSTRAINT inp_valve_status_check CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'CLOSED'::character varying, 'OPEN'::character varying])::text[]))),
    CONSTRAINT inp_valve_valv_type_check CHECK (((valv_type)::text = ANY ((ARRAY['FCV'::character varying, 'GPV'::character varying, 'PBV'::character varying, 'PRV'::character varying, 'PSV'::character varying, 'TCV'::character varying, 'PSRV'::character varying])::text[])))
);


--
-- Name: inp_valve_importinp; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_valve_importinp (
    arc_id character varying(16) NOT NULL,
    valv_type character varying(18),
    pressure numeric(12,4),
    diameter numeric(12,4),
    flow numeric(12,4),
    coef_loss numeric(12,4),
    curve_id character varying(16),
    minorloss numeric(12,4),
    status character varying(12),
    to_arc character varying(16)
);


--
-- Name: inp_virtualvalve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE inp_virtualvalve (
    arc_id character varying(16) NOT NULL,
    valv_type character varying(18),
    pressure numeric(12,4),
    diameter numeric(12,4),
    flow numeric(12,4),
    coef_loss numeric(12,4),
    curve_id character varying(16),
    minorloss numeric(12,4),
    status character varying(12),
    _to_arc_ character varying(16),
    CONSTRAINT inp_virtualvalve_status_check CHECK (((status)::text = ANY (ARRAY[('ACTIVE'::character varying)::text, ('CLOSED'::character varying)::text, ('OPEN'::character varying)::text]))),
    CONSTRAINT inp_virtualvalve_valv_type_check CHECK (((valv_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text])))
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
    exit_elev numeric(12,3),
    sector_id integer,
    dma_id integer,
    fluid_type character varying(16),
    presszone_id character varying(16),
    dqa_id integer,
    minsector_id integer,
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
-- Name: macrodqa; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE macrodqa (
    macrodqa_id integer NOT NULL,
    name character varying(50) NOT NULL,
    expl_id integer NOT NULL,
    descript text,
    undelete boolean,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    active boolean DEFAULT true
);


--
-- Name: macrodqa_macrodqa_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE macrodqa_macrodqa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: macrodqa_macrodqa_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE macrodqa_macrodqa_id_seq OWNED BY macrodqa.macrodqa_id;


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
-- Name: man_expansiontank; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_expansiontank (
    node_id character varying(16) NOT NULL
);


--
-- Name: man_filter; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_filter (
    node_id character varying(16) NOT NULL
);


--
-- Name: man_flexunion; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_flexunion (
    node_id character varying(16) NOT NULL
);


--
-- Name: man_fountain; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_fountain (
    connec_id character varying(16) NOT NULL,
    _pol_id_ character varying(16),
    linked_connec character varying(16),
    vmax numeric(12,3),
    vtotal numeric(12,3),
    container_number integer,
    pump_number integer,
    power numeric(12,3),
    regulation_tank character varying(150),
    chlorinator character varying(100),
    arq_patrimony boolean,
    name character varying(254)
);


--
-- Name: man_greentap; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_greentap (
    connec_id character varying(16) NOT NULL,
    linked_connec character varying(16),
    brand text,
    model text,
    greentap_type text,
    cat_valve text
);


--
-- Name: man_hydrant; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_hydrant (
    node_id character varying(16) NOT NULL,
    fire_code character varying(30),
    communication character varying(254),
    valve character varying(100),
    geom1 double precision,
    geom2 double precision,
    brand text,
    model text,
    hydrant_type text
);


--
-- Name: man_hydrant_fire_code_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE man_hydrant_fire_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


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
    name character varying(50)
);


--
-- Name: man_meter; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_meter (
    node_id character varying(16) NOT NULL,
    brand text,
    model text,
    real_press_max numeric(12,2),
    real_press_min numeric(12,2),
    real_press_avg numeric(12,2)
);


--
-- Name: man_netelement; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_netelement (
    node_id character varying(16) NOT NULL,
    serial_number character varying(30),
    brand text,
    model text
);


--
-- Name: man_netsamplepoint; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_netsamplepoint (
    node_id character varying(16) NOT NULL,
    lab_code character varying(30)
);


--
-- Name: man_netwjoin; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_netwjoin (
    node_id character varying(16) NOT NULL,
    customer_code character varying(30),
    top_floor integer,
    cat_valve character varying(30),
    brand text,
    model text,
    wjoin_type text
);


--
-- Name: man_pipe; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_pipe (
    arc_id character varying(16) NOT NULL
);


--
-- Name: man_pump; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_pump (
    node_id character varying(16) NOT NULL,
    max_flow numeric(12,4),
    min_flow numeric(12,4),
    nom_flow numeric(12,4),
    power numeric(12,4),
    pressure numeric(12,4),
    elev_height numeric(12,4),
    name character varying(50),
    pump_number integer,
    brand text,
    model text
);


--
-- Name: man_reduction; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_reduction (
    node_id character varying(16) NOT NULL,
    diam1 numeric(12,3),
    diam2 numeric(12,3)
);


--
-- Name: man_register; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_register (
    node_id character varying(16) NOT NULL,
    _pol_id_ character varying(16)
);


--
-- Name: man_source; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_source (
    node_id character varying(16) NOT NULL,
    name character varying(50)
);


--
-- Name: man_tank; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_tank (
    node_id character varying(16) NOT NULL,
    _pol_id_ character varying(16),
    vmax numeric(12,4),
    vutil numeric(12,4),
    area numeric(12,4),
    chlorination character varying(255),
    name character varying(50),
    hmax numeric(12,3)
);


--
-- Name: man_tap; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_tap (
    connec_id character varying(16) NOT NULL,
    linked_connec character varying(16),
    cat_valve character varying(30),
    drain_diam numeric(12,3),
    drain_exit character varying(100),
    drain_gully character varying(100),
    drain_distance numeric(12,3),
    arq_patrimony boolean,
    com_state character varying(254)
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
    closed boolean DEFAULT false,
    broken boolean DEFAULT false,
    buried character varying(16),
    irrigation_indicator character varying(16),
    pression_entry numeric(12,3),
    pression_exit numeric(12,3),
    depth_valveshaft numeric(12,3),
    regulator_situation character varying(150),
    regulator_location character varying(150),
    regulator_observ character varying(254),
    lin_meters numeric(12,3),
    exit_type character varying(100),
    exit_code integer,
    drive_type character varying(100),
    cat_valve2 character varying(30),
    ordinarystatus smallint,
    shutter text,
    brand text,
    model text,
    brand2 text,
    model2 text,
    valve_type text
);


--
-- Name: man_varc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_varc (
    arc_id character varying(16) NOT NULL
);


--
-- Name: man_waterwell; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_waterwell (
    node_id character varying(16) NOT NULL,
    name character varying(50)
);


--
-- Name: man_wjoin; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_wjoin (
    connec_id character varying(16) NOT NULL,
    top_floor integer,
    cat_valve character varying(30),
    brand text,
    model text,
    wjoin_type text
);


--
-- Name: man_wtp; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE man_wtp (
    node_id character varying(16) NOT NULL,
    name character varying(50)
);


--
-- Name: minsector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE minsector (
    minsector_id integer NOT NULL,
    dma_id integer,
    dqa_id integer,
    presszone_id character varying(30),
    sector_id integer,
    expl_id integer,
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    num_border integer,
    num_connec integer,
    num_hydro integer,
    length numeric(12,3),
    addparam json
);


--
-- Name: minsector_graph; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE minsector_graph (
    node_id character varying(16) NOT NULL,
    nodecat_id character varying(30),
    minsector_1 integer,
    minsector_2 integer
);


--
-- Name: minsector_minsector_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE minsector_minsector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: minsector_minsector_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE minsector_minsector_id_seq OWNED BY minsector.minsector_id;


--
-- Name: node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE node (
    node_id character varying(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
    code character varying(30),
    elevation numeric(12,4),
    depth numeric(12,4),
    nodecat_id character varying(30) NOT NULL,
    epa_type character varying(16) NOT NULL,
    sector_id integer NOT NULL,
    arc_id character varying(16),
    parent_id character varying(16),
    state smallint NOT NULL,
    state_type smallint NOT NULL,
    annotation text,
    observ text,
    comment text,
    dma_id integer NOT NULL,
    presszone_id character varying(30),
    soilcat_id character varying(30),
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
    descript character varying(254),
    link character varying(512),
    verified character varying(30),
    rotation numeric(6,3),
    the_geom public.geometry(Point,SRID_VALUE),
    undelete boolean,
    label_x character varying(30),
    label_y character varying(30),
    label_rotation numeric(6,3),
    publish boolean,
    inventory boolean,
    hemisphere double precision,
    expl_id integer NOT NULL,
    num_value numeric(12,3),
    feature_type character varying(16) DEFAULT 'NODE'::character varying,
    tstamp timestamp without time zone DEFAULT now(),
    lastupdate timestamp without time zone,
    lastupdate_user character varying(50),
    insert_user character varying(50) DEFAULT CURRENT_USER,
    minsector_id integer,
    dqa_id integer,
    staticpressure numeric(12,3),
    district_id integer,
    adate text,
    adescript text,
    accessibility smallint,
    workcat_id_plan character varying(255),
    asset_id character varying(50),
    om_state text,
    conserv_state text,
    access_type text,
    placement_type text,
    expl_id2 integer,
    CONSTRAINT node_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['JUNCTION'::text, 'RESERVOIR'::text, 'TANK'::text, 'INLET'::text, 'UNDEFINED'::text, 'SHORTPIPE'::text, 'VALVE'::text, 'PUMP'::text])))
);


--
-- Name: node_add; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE node_add (
    node_id character varying(16) NOT NULL,
    demand_max numeric(12,2),
    demand_min numeric(12,2),
    demand_avg numeric(12,2),
    press_max numeric(12,2),
    press_min numeric(12,2),
    press_avg numeric(12,2),
    head_max numeric(12,2),
    head_min numeric(12,2),
    head_avg numeric(12,2),
    quality_max numeric(12,2),
    quality_min numeric(12,2),
    quality_avg numeric(12,2),
    result_id text
);


--
-- Name: node_border_sector; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE node_border_sector (
    node_id character varying(16) NOT NULL,
    sector_id integer NOT NULL
);


--
-- Name: om_mincut_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE -1
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut (
    id integer DEFAULT nextval('om_mincut_seq'::regclass) NOT NULL,
    work_order character varying(50),
    mincut_state smallint,
    mincut_class smallint,
    mincut_type character varying(30),
    received_date date,
    expl_id integer,
    macroexpl_id integer,
    muni_id integer,
    postcode character varying(16),
    streetaxis_id character varying(250),
    postnumber character varying(16),
    anl_cause character varying(30),
    anl_tstamp timestamp without time zone DEFAULT now(),
    anl_user character varying(30),
    anl_descript text,
    anl_feature_id character varying(16),
    anl_feature_type character varying(16),
    anl_the_geom public.geometry(Point,SRID_VALUE),
    forecast_start timestamp without time zone,
    forecast_end timestamp without time zone,
    assigned_to character varying(50),
    exec_start timestamp without time zone,
    exec_end timestamp without time zone,
    exec_user character varying(30),
    exec_descript text,
    exec_the_geom public.geometry(Point,SRID_VALUE),
    exec_from_plot double precision,
    exec_depth double precision,
    exec_appropiate boolean,
    notified json,
    output json,
    modification_date date,
    chlorine character varying(30),
    turbidity character varying(30)
);


--
-- Name: om_mincut_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut_arc (
    id integer NOT NULL,
    result_id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    the_geom public.geometry(LineString,SRID_VALUE)
);


--
-- Name: om_mincut_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_arc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut_arc_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_mincut_arc_id_seq OWNED BY om_mincut_arc.id;


--
-- Name: om_mincut_cat_type; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut_cat_type (
    id character varying(30) NOT NULL,
    virtual boolean DEFAULT true NOT NULL,
    descript text
);


--
-- Name: om_mincut_connec; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut_connec (
    id integer NOT NULL,
    result_id integer NOT NULL,
    connec_id character varying(16) NOT NULL,
    the_geom public.geometry(Point,SRID_VALUE),
    customer_code character varying(30)
);


--
-- Name: om_mincut_connec_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_connec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut_connec_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_mincut_connec_id_seq OWNED BY om_mincut_connec.id;


--
-- Name: om_mincut_hydrometer; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut_hydrometer (
    id integer NOT NULL,
    result_id integer NOT NULL,
    hydrometer_id character varying(16) NOT NULL
);


--
-- Name: om_mincut_hydrometer_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_hydrometer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut_hydrometer_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_mincut_hydrometer_id_seq OWNED BY om_mincut_hydrometer.id;


--
-- Name: om_mincut_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut_node (
    id integer NOT NULL,
    result_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    the_geom public.geometry(Point,SRID_VALUE),
    node_type character varying(30)
);


--
-- Name: om_mincut_node_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut_node_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_mincut_node_id_seq OWNED BY om_mincut_node.id;


--
-- Name: om_mincut_polygon; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut_polygon (
    id integer NOT NULL,
    result_id integer NOT NULL,
    polygon_id character varying(16) NOT NULL,
    the_geom public.geometry(MultiPolygon,SRID_VALUE)
);


--
-- Name: om_mincut_polygon_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_polygon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut_polygon_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_mincut_polygon_id_seq OWNED BY om_mincut_polygon.id;


--
-- Name: om_mincut_polygon_polygon_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_polygon_polygon_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut_valve; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut_valve (
    id integer NOT NULL,
    result_id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    closed boolean,
    broken boolean,
    unaccess boolean,
    proposed boolean,
    the_geom public.geometry(Point,SRID_VALUE)
);


--
-- Name: om_mincut_valve_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_valve_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut_valve_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_mincut_valve_id_seq OWNED BY om_mincut_valve.id;


--
-- Name: om_mincut_valve_unaccess; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_mincut_valve_unaccess (
    id integer NOT NULL,
    result_id integer NOT NULL,
    node_id character varying(16) NOT NULL
);


--
-- Name: om_mincut_valve_unaccess_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE om_mincut_valve_unaccess_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: om_mincut_valve_unaccess_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE om_mincut_valve_unaccess_id_seq OWNED BY om_mincut_valve_unaccess.id;


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
-- Name: om_streetaxis; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_streetaxis (
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
-- Name: om_waterbalance; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_waterbalance (
    expl_id integer,
    dma_id integer NOT NULL,
    cat_period_id character varying(16) NOT NULL,
    total_sys_input double precision,
    auth_bill_met_export double precision,
    auth_bill_met_hydro double precision,
    auth_bill_unmet double precision,
    auth_unbill_met double precision,
    auth_unbill_unmet double precision,
    loss_app_unath double precision,
    loss_app_met_error double precision,
    loss_app_data_error double precision,
    loss_real_leak_main double precision,
    loss_real_leak_service double precision,
    loss_real_storage double precision,
    type character varying(50),
    descript text,
    startdate date,
    enddate date,
    total_in numeric,
    total_out numeric,
    ili numeric,
    auth_bill double precision,
    auth_unbill double precision,
    loss_app double precision,
    loss_real double precision,
    total double precision,
    auth double precision,
    nrw double precision,
    nrw_eff double precision,
    loss double precision,
    meters_in text,
    meters_out text,
    n_connec integer,
    n_hydro integer,
    arc_length double precision,
    link_length double precision
);


--
-- Name: om_waterbalance_dma_graph; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE om_waterbalance_dma_graph (
    node_id character varying(16) NOT NULL,
    dma_id integer NOT NULL,
    flow_sign smallint
);


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
-- Name: pond; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE pond (
    pond_id character varying(16) NOT NULL,
    connec_id character varying(16),
    dma_id integer NOT NULL,
    state smallint NOT NULL,
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer NOT NULL,
    tstamp timestamp without time zone DEFAULT now()
);


--
-- Name: pond_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE pond_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pool; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE pool (
    pool_id character varying(16) NOT NULL,
    connec_id character varying(16),
    dma_id integer NOT NULL,
    state smallint NOT NULL,
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer NOT NULL,
    tstamp timestamp without time zone DEFAULT now()
);


--
-- Name: pool_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE pool_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: presszone; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE presszone (
    presszone_id character varying(30) NOT NULL,
    name text NOT NULL,
    expl_id integer NOT NULL,
    link character varying(512),
    the_geom public.geometry(MultiPolygon,SRID_VALUE),
    graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json,
    stylesheet json,
    head numeric(12,2),
    active boolean DEFAULT true,
    descript text,
    tstamp timestamp without time zone DEFAULT now(),
    insert_user character varying(15) DEFAULT CURRENT_USER,
    lastupdate timestamp without time zone,
    lastupdate_user character varying(15)
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
    arc_id character varying(16) NOT NULL,
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
-- Name: review_audit_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_audit_node (
    id integer NOT NULL,
    node_id character varying(16) NOT NULL,
    old_elevation numeric(12,3),
    new_elevation numeric(12,3),
    old_depth numeric(12,3),
    new_depth numeric(12,3),
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
    is_validated integer
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
-- Name: review_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE review_node (
    node_id character varying(16) NOT NULL,
    elevation numeric(12,3),
    depth numeric(12,3),
    nodecat_id character varying(30),
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
-- Name: rpt_arc_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_arc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_arc (
    id integer DEFAULT nextval('rpt_arc_id_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(16),
    length numeric,
    diameter numeric,
    flow numeric,
    vel numeric,
    headloss numeric,
    setting numeric,
    reaction numeric,
    ffactor numeric,
    other character varying(100),
    "time" character varying(100),
    status character varying(16)
);


--
-- Name: rpt_cat_result; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_cat_result (
    result_id character varying(30) NOT NULL,
    n_junction numeric,
    n_reservoir numeric,
    n_tank numeric,
    n_pipe numeric,
    n_pump numeric,
    n_valve numeric,
    head_form text,
    hydra_time text,
    hydra_acc numeric,
    st_ch_freq numeric,
    max_tr_ch numeric,
    dam_li_thr numeric,
    max_trials numeric,
    q_analysis character varying(20),
    spec_grav numeric,
    r_kin_visc numeric,
    r_che_diff numeric,
    dem_multi numeric,
    total_dura text,
    exec_date timestamp(6) without time zone DEFAULT now(),
    q_timestep character varying(16),
    q_tolerance character varying(16),
    cur_user text DEFAULT CURRENT_USER,
    inp_options json,
    rpt_stats json,
    export_options json,
    network_stats json,
    status smallint,
    expl_id integer,
    iscorporate boolean,
    CONSTRAINT rpt_cat_result_status_check CHECK ((status = ANY (ARRAY[0, 1, 2])))
);


--
-- Name: rpt_cat_result_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_cat_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_energy_usage_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_energy_usage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_energy_usage; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_energy_usage (
    id integer DEFAULT nextval('rpt_energy_usage_id_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    nodarc_id character varying(16),
    usage_fact numeric,
    avg_effic numeric,
    kwhr_mgal numeric,
    avg_kw numeric,
    peak_kw numeric,
    cost_day numeric
);


--
-- Name: rpt_hydraulic_status_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_hydraulic_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_hydraulic_status; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_hydraulic_status (
    id integer DEFAULT nextval('rpt_hydraulic_status_id_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    "time" character varying(20),
    text text
);


--
-- Name: rpt_inp_arc; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_inp_arc (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    arc_id character varying(16),
    node_1 character varying(16),
    node_2 character varying(16),
    arc_type character varying(30),
    arccat_id character varying(30),
    epa_type character varying(16),
    sector_id integer,
    state smallint,
    state_type smallint,
    annotation character varying(254),
    diameter numeric(12,3),
    roughness numeric(12,6),
    length numeric(12,3),
    status character varying(18),
    the_geom public.geometry(LineString,SRID_VALUE),
    expl_id integer,
    flw_code text,
    minorloss numeric(12,6),
    addparam text,
    arcparent character varying(16),
    dma_id integer,
    presszone_id text,
    dqa_id integer,
    minsector_id integer,
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
-- Name: rpt_inp_arc_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_inp_arc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_inp_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_inp_node (
    id integer NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(16),
    elevation numeric(12,3),
    elev numeric(12,3),
    node_type character varying(30),
    nodecat_id character varying(30),
    epa_type character varying(16),
    sector_id integer,
    state smallint,
    state_type smallint,
    annotation character varying(254),
    demand double precision,
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer,
    pattern_id character varying(16),
    addparam text,
    nodeparent character varying(16),
    arcposition smallint,
    dma_id integer,
    presszone_id text,
    dqa_id integer,
    minsector_id integer,
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
-- Name: rpt_inp_node_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_inp_node_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_inp_pattern_value; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_inp_pattern_value (
    id integer NOT NULL,
    result_id character varying(16) NOT NULL,
    dma_id integer,
    pattern_id character varying(16) NOT NULL,
    idrow integer,
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
    user_name text DEFAULT CURRENT_USER
);


--
-- Name: rpt_inp_pattern_value_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE rpt_inp_pattern_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpt_inp_pattern_value_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE rpt_inp_pattern_value_id_seq OWNED BY rpt_inp_pattern_value.id;


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
-- Name: rpt_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE rpt_node (
    id integer DEFAULT nextval('rpt_node_id_seq'::regclass) NOT NULL,
    result_id character varying(30) NOT NULL,
    node_id character varying(16),
    elevation numeric,
    demand numeric,
    head numeric,
    press numeric,
    other character varying(100),
    "time" character varying(100),
    quality numeric(12,4)
);


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
    connec_id character varying(16) NOT NULL
);


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
    presszone_id character varying(30),
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
    sector_type character varying(16),
    graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json,
    stylesheet json,
    active boolean DEFAULT true,
    parent_id integer,
    pattern_id character varying(20),
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
-- Name: selector_mincut_result; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE selector_mincut_result (
    result_id integer NOT NULL,
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
    timestep character varying(100) NOT NULL,
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
    timestep character varying(100) NOT NULL,
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
    CONSTRAINT sys_feature_cat_check CHECK (((id)::text = ANY (ARRAY[('ELEMENT'::character varying)::text, ('EXPANSIONTANK'::character varying)::text, ('FILTER'::character varying)::text, ('FLEXUNION'::character varying)::text, ('FOUNTAIN'::character varying)::text, ('GREENTAP'::character varying)::text, ('HYDRANT'::character varying)::text, ('JUNCTION'::character varying)::text, ('MANHOLE'::character varying)::text, ('METER'::character varying)::text, ('NETELEMENT'::character varying)::text, ('NETSAMPLEPOINT'::character varying)::text, ('NETWJOIN'::character varying)::text, ('PIPE'::character varying)::text, ('PUMP'::character varying)::text, ('REDUCTION'::character varying)::text, ('REGISTER'::character varying)::text, ('SOURCE'::character varying)::text, ('TANK'::character varying)::text, ('TAP'::character varying)::text, ('VALVE'::character varying)::text, ('VARC'::character varying)::text, ('WATERWELL'::character varying)::text, ('WJOIN'::character varying)::text, ('WTP'::character varying)::text, ('LINK'::character varying)::text])))
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
    CONSTRAINT sys_feature_type_check CHECK (((id)::text = ANY ((ARRAY['ARC'::character varying, 'CONNEC'::character varying, 'ELEMENT'::character varying, 'LINK'::character varying, 'NODE'::character varying, 'VNODE'::character varying])::text[])))
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
    arc_id character varying(16),
    node_1 character varying(16),
    node_2 character varying(16),
    arc_type character varying(30),
    arccat_id character varying(30),
    epa_type character varying(16),
    sector_id integer,
    state smallint,
    state_type smallint,
    annotation character varying(254),
    diameter numeric(12,3),
    roughness numeric(12,6),
    length numeric(12,3),
    status character varying(18),
    the_geom public.geometry(LineString,SRID_VALUE),
    expl_id integer,
    flw_code character varying(512),
    minorloss numeric(12,6),
    addparam text,
    arcparent character varying(16),
    flag boolean,
    dma_id integer,
    presszone_id text,
    dqa_id integer,
    minsector_id integer,
    age integer
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
-- Name: temp_demand; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_demand (
    id integer NOT NULL,
    feature_id character varying(16) NOT NULL,
    demand numeric(12,6),
    pattern_id character varying(16),
    demand_type character varying(18),
    dscenario_id integer,
    source text
);


--
-- Name: temp_demand_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_demand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_demand_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_demand_id_seq OWNED BY temp_demand.id;


--
-- Name: temp_go2epa; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_go2epa (
    id integer NOT NULL,
    arc_id character varying(20),
    vnode_id character varying(20),
    locate double precision,
    elevation double precision,
    depth double precision,
    idmin integer
);


--
-- Name: temp_go2epa_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_go2epa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_go2epa_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_go2epa_id_seq OWNED BY temp_go2epa.id;


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
-- Name: temp_mincut; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_mincut (
    id bigint NOT NULL,
    source bigint,
    target bigint,
    cost smallint,
    reverse_cost smallint
);


--
-- Name: temp_mincut_id_seq; Type: SEQUENCE; Schema: Schema; Owner: -
--

CREATE SEQUENCE temp_mincut_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_mincut_id_seq; Type: SEQUENCE OWNED BY; Schema: Schema; Owner: -
--

ALTER SEQUENCE temp_mincut_id_seq OWNED BY temp_mincut.id;


--
-- Name: temp_node; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE temp_node (
    id integer NOT NULL,
    result_id character varying(30),
    node_id character varying(16),
    elevation numeric(12,3),
    elev numeric(12,3),
    node_type character varying(30),
    nodecat_id character varying(30),
    epa_type character varying(16),
    sector_id integer,
    state smallint,
    state_type smallint,
    annotation character varying(254),
    demand double precision,
    the_geom public.geometry(Point,SRID_VALUE),
    expl_id integer,
    pattern_id character varying(16),
    addparam text,
    nodeparent character varying(16),
    arcposition smallint,
    dma_id integer,
    presszone_id text,
    dqa_id integer,
    minsector_id integer,
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
-- Name: value_state; Type: TABLE; Schema: Schema; Owner: -
--

CREATE TABLE value_state (
    id smallint NOT NULL,
    name character varying(30) NOT NULL,
    observ text,
    CONSTRAINT value_state_check CHECK ((id = ANY (ARRAY[0, 1, 2])))
);


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
-- Name: audit_psector_node_traceability id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_node_traceability ALTER COLUMN id SET DEFAULT nextval('audit_psector_node_traceability_id_seq'::regclass);


--
-- Name: cat_dscenario dscenario_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dscenario ALTER COLUMN dscenario_id SET DEFAULT nextval('cat_dscenario_dscenario_id_seq'::regclass);


--
-- Name: cat_manager id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_manager ALTER COLUMN id SET DEFAULT nextval('cat_manager_id_seq'::regclass);


--
-- Name: cat_mat_roughness id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_roughness ALTER COLUMN id SET DEFAULT nextval('cat_mat_roughness_id_seq'::regclass);


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
-- Name: dqa dqa_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dqa ALTER COLUMN dqa_id SET DEFAULT nextval('dqa_dqa_id_seq'::regclass);


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
-- Name: inp_dscenario_demand id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_demand ALTER COLUMN id SET DEFAULT nextval('inp_dscenario_demand_id_seq1'::regclass);


--
-- Name: inp_dscenario_pump_additional id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump_additional ALTER COLUMN id SET DEFAULT nextval('inp_dscenario_pump_additional_id_seq'::regclass);


--
-- Name: inp_dscenario_rules id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_rules ALTER COLUMN id SET DEFAULT nextval('inp_dscenario_rules_id_seq'::regclass);


--
-- Name: inp_energy id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_energy ALTER COLUMN id SET DEFAULT nextval('inp_energy_id_seq'::regclass);


--
-- Name: inp_pump_additional id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump_additional ALTER COLUMN id SET DEFAULT nextval('inp_pump_additional_id_seq'::regclass);


--
-- Name: inp_reactions id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_reactions ALTER COLUMN id SET DEFAULT nextval('inp_reactions_id_seq'::regclass);


--
-- Name: inp_rules id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_rules ALTER COLUMN id SET DEFAULT nextval('inp_rules_id_seq'::regclass);


--
-- Name: link link_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY link ALTER COLUMN link_id SET DEFAULT nextval('link_link_id_seq'::regclass);


--
-- Name: macrodma macrodma_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrodma ALTER COLUMN macrodma_id SET DEFAULT nextval('macrodma_macrodma_id_seq'::regclass);


--
-- Name: macrodqa macrodqa_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrodqa ALTER COLUMN macrodqa_id SET DEFAULT nextval('macrodqa_macrodqa_id_seq'::regclass);


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
-- Name: minsector minsector_id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY minsector ALTER COLUMN minsector_id SET DEFAULT nextval('minsector_minsector_id_seq'::regclass);


--
-- Name: om_mincut_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_arc ALTER COLUMN id SET DEFAULT nextval('om_mincut_arc_id_seq'::regclass);


--
-- Name: om_mincut_connec id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_connec ALTER COLUMN id SET DEFAULT nextval('om_mincut_connec_id_seq'::regclass);


--
-- Name: om_mincut_hydrometer id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_hydrometer ALTER COLUMN id SET DEFAULT nextval('om_mincut_hydrometer_id_seq'::regclass);


--
-- Name: om_mincut_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_node ALTER COLUMN id SET DEFAULT nextval('om_mincut_node_id_seq'::regclass);


--
-- Name: om_mincut_polygon id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_polygon ALTER COLUMN id SET DEFAULT nextval('om_mincut_polygon_id_seq'::regclass);


--
-- Name: om_mincut_valve id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_valve ALTER COLUMN id SET DEFAULT nextval('om_mincut_valve_id_seq'::regclass);


--
-- Name: om_mincut_valve_unaccess id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_valve_unaccess ALTER COLUMN id SET DEFAULT nextval('om_mincut_valve_unaccess_id_seq'::regclass);


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
-- Name: review_audit_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_node ALTER COLUMN id SET DEFAULT nextval('review_audit_node_id_seq'::regclass);


--
-- Name: rpt_inp_arc id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_arc ALTER COLUMN id SET DEFAULT nextval('rpt_inp_arc_id_seq'::regclass);


--
-- Name: rpt_inp_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_node ALTER COLUMN id SET DEFAULT nextval('rpt_inp_node_id_seq'::regclass);


--
-- Name: rpt_inp_pattern_value id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_pattern_value ALTER COLUMN id SET DEFAULT nextval('rpt_inp_pattern_value_id_seq'::regclass);


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
-- Name: temp_demand id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_demand ALTER COLUMN id SET DEFAULT nextval('temp_demand_id_seq'::regclass);


--
-- Name: temp_go2epa id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_go2epa ALTER COLUMN id SET DEFAULT nextval('temp_go2epa_id_seq'::regclass);


--
-- Name: temp_mincut id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_mincut ALTER COLUMN id SET DEFAULT nextval('temp_mincut_id_seq'::regclass);


--
-- Name: temp_node id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_node ALTER COLUMN id SET DEFAULT nextval('temp_node_id_seq'::regclass);


--
-- Name: temp_table id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_table ALTER COLUMN id SET DEFAULT nextval('temp_table_id_seq'::regclass);


--
-- Name: temp_vnode id; Type: DEFAULT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_vnode ALTER COLUMN id SET DEFAULT nextval('temp_vnode_id_seq'::regclass);

