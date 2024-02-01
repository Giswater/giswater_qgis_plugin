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
-- Name: v_anl_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_arc AS
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom,
    anl_arc.result_id,
    anl_arc.descript
   FROM selector_audit,
    (anl_arc
     JOIN exploitation ON ((anl_arc.expl_id = exploitation.expl_id)))
  WHERE ((anl_arc.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_arc.cur_user)::name = "current_user"()));


--
-- Name: v_anl_arc_point; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_arc_point AS
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom_p
   FROM selector_audit,
    ((anl_arc
     JOIN sys_fprocess ON ((anl_arc.fid = sys_fprocess.fid)))
     JOIN exploitation ON ((anl_arc.expl_id = exploitation.expl_id)))
  WHERE ((anl_arc.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_arc.cur_user)::name = "current_user"()));


--
-- Name: v_anl_arc_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_arc_x_node AS
 SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.state,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom
   FROM selector_audit,
    (anl_arc_x_node
     JOIN exploitation ON ((anl_arc_x_node.expl_id = exploitation.expl_id)))
  WHERE ((anl_arc_x_node.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_arc_x_node.cur_user)::name = "current_user"()));


--
-- Name: v_anl_arc_x_node_point; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_arc_x_node_point AS
 SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom_p
   FROM selector_audit,
    (anl_arc_x_node
     JOIN exploitation ON ((anl_arc_x_node.expl_id = exploitation.expl_id)))
  WHERE ((anl_arc_x_node.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_arc_x_node.cur_user)::name = "current_user"()));


--
-- Name: v_anl_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_connec AS
 SELECT anl_connec.id,
    anl_connec.connec_id,
    anl_connec.connecat_id,
    anl_connec.state,
    anl_connec.connec_id_aux,
    anl_connec.connecat_id_aux AS state_aux,
    anl_connec.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_connec.the_geom,
    anl_connec.result_id,
    anl_connec.descript
   FROM selector_audit,
    (anl_connec
     JOIN exploitation ON ((anl_connec.expl_id = exploitation.expl_id)))
  WHERE ((anl_connec.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_connec.cur_user)::name = "current_user"()));


--
-- Name: v_anl_graph; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_graph AS
 SELECT anl_graph.arc_id,
    anl_graph.node_1,
    anl_graph.node_2,
    anl_graph.flag,
    a.flag AS flagi,
    a.value
   FROM (temp_anlgraph anl_graph
     JOIN ( SELECT anl_graph_1.arc_id,
            anl_graph_1.node_1,
            anl_graph_1.node_2,
            anl_graph_1.water,
            anl_graph_1.flag,
            anl_graph_1.checkf,
            anl_graph_1.value
           FROM temp_anlgraph anl_graph_1
          WHERE (anl_graph_1.water = 1)) a ON (((anl_graph.node_1)::text = (a.node_2)::text)))
  WHERE ((anl_graph.flag < 2) AND (anl_graph.water = 0) AND (a.flag < 2));


--
-- Name: v_anl_graphanalytics_mapzones; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_graphanalytics_mapzones AS
 SELECT temp_anlgraph.arc_id,
    temp_anlgraph.node_1,
    temp_anlgraph.node_2,
    temp_anlgraph.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM (temp_anlgraph
     JOIN ( SELECT temp_anlgraph_1.arc_id,
            temp_anlgraph_1.node_1,
            temp_anlgraph_1.node_2,
            temp_anlgraph_1.water,
            temp_anlgraph_1.flag,
            temp_anlgraph_1.checkf,
            temp_anlgraph_1.value,
            temp_anlgraph_1.trace
           FROM temp_anlgraph temp_anlgraph_1
          WHERE (temp_anlgraph_1.water = 1)) a2 ON (((temp_anlgraph.node_1)::text = (a2.node_2)::text)))
  WHERE ((temp_anlgraph.flag < 2) AND (temp_anlgraph.water = 0) AND (a2.flag = 0));


--
-- Name: v_anl_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_anl_node AS
 SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.state,
    anl_node.node_id_aux,
    anl_node.nodecat_id_aux AS state_aux,
    anl_node.num_arcs,
    anl_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_node.the_geom,
    anl_node.result_id,
    anl_node.descript
   FROM selector_audit,
    (anl_node
     JOIN exploitation ON ((anl_node.expl_id = exploitation.expl_id)))
  WHERE ((anl_node.fid = selector_audit.fid) AND (selector_audit.cur_user = ("current_user"())::text) AND ((anl_node.cur_user)::name = "current_user"()));


--
-- Name: v_expl_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_expl_arc AS
 SELECT DISTINCT arc.arc_id
   FROM selector_expl,
    arc
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND ((arc.expl_id = selector_expl.expl_id) OR (arc.expl_id2 = selector_expl.expl_id)));


--
-- Name: v_ext_streetaxis; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ext_streetaxis AS
 SELECT ext_streetaxis.id,
    ext_streetaxis.code,
    ext_streetaxis.type,
    ext_streetaxis.name,
    ext_streetaxis.text,
    ext_streetaxis.the_geom,
    ext_streetaxis.expl_id,
    ext_streetaxis.muni_id,
        CASE
            WHEN (ext_streetaxis.type IS NULL) THEN (ext_streetaxis.name)::text
            WHEN (ext_streetaxis.text IS NULL) THEN ((((ext_streetaxis.name)::text || ', '::text) || (ext_streetaxis.type)::text) || '.'::text)
            WHEN ((ext_streetaxis.type IS NULL) AND (ext_streetaxis.text IS NULL)) THEN (ext_streetaxis.name)::text
            ELSE (((((ext_streetaxis.name)::text || ', '::text) || (ext_streetaxis.type)::text) || '. '::text) || ext_streetaxis.text)
        END AS descript
   FROM selector_expl,
    ext_streetaxis
  WHERE ((ext_streetaxis.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_state_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_arc AS
(
         SELECT arc.arc_id
           FROM selector_state,
            arc
          WHERE ((arc.state = selector_state.state_id) AND (selector_state.cur_user = ("current_user"())::text))
        EXCEPT
         SELECT plan_psector_x_arc.arc_id
           FROM selector_psector,
            (plan_psector_x_arc
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_arc.psector_id)))
          WHERE ((plan_psector_x_arc.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_arc.state = 0))
) UNION
 SELECT plan_psector_x_arc.arc_id
   FROM selector_psector,
    (plan_psector_x_arc
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_arc.psector_id)))
  WHERE ((plan_psector_x_arc.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_arc.state = 1));


--
-- Name: vu_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_arc AS
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    arc.elevation1,
    arc.depth1,
    arc.elevation2,
    arc.depth2,
    arc.arccat_id,
    cat_arc.arctype_id AS arc_type,
    cat_feature.system_id AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    arc.epa_type,
    arc.expl_id,
    exploitation.macroexpl_id,
    arc.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.observ,
    arc.comment,
    (public.st_length2d(arc.the_geom))::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.minsector_id,
    arc.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    arc.presszone_id,
    presszone.name AS presszone_name,
    arc.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.buildercat_id,
    arc.builtdate,
    arc.enddate,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    (c.descript)::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    (d.descript)::character varying(100) AS streetname2,
    arc.postnumber2,
    arc.postcomplement2,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    arc.num_value,
    cat_arc.arctype_id AS cat_arctype_id,
    arc.nodetype_1,
    arc.staticpress1,
    arc.nodetype_2,
    arc.staticpress2,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.depth,
    arc.adate,
    arc.adescript,
    (dma.stylesheet ->> 'featureColor'::text) AS dma_style,
    (presszone.stylesheet ->> 'featureColor'::text) AS presszone_style,
    arc.workcat_id_plan,
    arc.asset_id,
    arc.pavcat_id,
    arc.om_state,
    arc.conserv_state,
    e.flow_max,
    e.flow_min,
    e.flow_avg,
    e.vel_max,
    e.vel_min,
    e.vel_avg,
    arc.parent_id,
    arc.expl_id2
   FROM ((((((((((arc
     LEFT JOIN sector ON ((arc.sector_id = sector.sector_id)))
     LEFT JOIN exploitation ON ((arc.expl_id = exploitation.expl_id)))
     LEFT JOIN cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_arc.arctype_id)::text)))
     LEFT JOIN dma ON ((arc.dma_id = dma.dma_id)))
     LEFT JOIN dqa ON ((arc.dqa_id = dqa.dqa_id)))
     LEFT JOIN presszone ON (((presszone.presszone_id)::text = (arc.presszone_id)::text)))
     LEFT JOIN v_ext_streetaxis c ON (((c.id)::text = (arc.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis d ON (((d.id)::text = (arc.streetaxis2_id)::text)))
     LEFT JOIN arc_add e ON (((arc.arc_id)::text = (e.arc_id)::text)));


--
-- Name: v_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_arc AS
 SELECT vu_arc.arc_id,
    vu_arc.code,
    vu_arc.node_1,
    vu_arc.node_2,
    vu_arc.elevation1,
    vu_arc.depth1,
    vu_arc.elevation2,
    vu_arc.depth2,
    vu_arc.arccat_id,
    vu_arc.arc_type,
    vu_arc.sys_type,
    vu_arc.cat_matcat_id,
    vu_arc.cat_pnom,
    vu_arc.cat_dnom,
    vu_arc.epa_type,
    vu_arc.expl_id,
    vu_arc.macroexpl_id,
    vu_arc.sector_id,
    vu_arc.sector_name,
    vu_arc.macrosector_id,
    vu_arc.state,
    vu_arc.state_type,
    vu_arc.annotation,
    vu_arc.observ,
    vu_arc.comment,
    vu_arc.gis_length,
    vu_arc.custom_length,
    vu_arc.minsector_id,
    vu_arc.dma_id,
    vu_arc.dma_name,
    vu_arc.macrodma_id,
    vu_arc.presszone_id,
    vu_arc.presszone_name,
    vu_arc.dqa_id,
    vu_arc.dqa_name,
    vu_arc.macrodqa_id,
    vu_arc.soilcat_id,
    vu_arc.function_type,
    vu_arc.category_type,
    vu_arc.fluid_type,
    vu_arc.location_type,
    vu_arc.workcat_id,
    vu_arc.workcat_id_end,
    vu_arc.buildercat_id,
    vu_arc.builtdate,
    vu_arc.enddate,
    vu_arc.ownercat_id,
    vu_arc.muni_id,
    vu_arc.postcode,
    vu_arc.district_id,
    vu_arc.streetname,
    vu_arc.postnumber,
    vu_arc.postcomplement,
    vu_arc.streetname2,
    vu_arc.postnumber2,
    vu_arc.postcomplement2,
    vu_arc.descript,
    vu_arc.link,
    vu_arc.verified,
    vu_arc.undelete,
    vu_arc.label,
    vu_arc.label_x,
    vu_arc.label_y,
    vu_arc.label_rotation,
    vu_arc.publish,
    vu_arc.inventory,
    vu_arc.num_value,
    vu_arc.cat_arctype_id,
    vu_arc.nodetype_1,
    vu_arc.staticpress1,
    vu_arc.nodetype_2,
    vu_arc.staticpress2,
    vu_arc.tstamp,
    vu_arc.insert_user,
    vu_arc.lastupdate,
    vu_arc.lastupdate_user,
    vu_arc.the_geom,
    vu_arc.depth,
    vu_arc.adate,
    vu_arc.adescript,
    vu_arc.dma_style,
    vu_arc.presszone_style,
    vu_arc.workcat_id_plan,
    vu_arc.asset_id,
    vu_arc.pavcat_id,
    vu_arc.om_state,
    vu_arc.conserv_state,
    vu_arc.flow_max,
    vu_arc.flow_min,
    vu_arc.flow_avg,
    vu_arc.vel_max,
    vu_arc.vel_min,
    vu_arc.vel_avg,
    vu_arc.parent_id,
    vu_arc.expl_id2
   FROM ((vu_arc
     JOIN v_state_arc USING (arc_id))
     JOIN v_expl_arc e ON (((e.arc_id)::text = (vu_arc.arc_id)::text)));


--
-- Name: v_audit_check_project; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_audit_check_project AS
 SELECT audit_check_project.id,
    audit_check_project.table_id,
    audit_check_project.table_host,
    audit_check_project.table_dbname,
    audit_check_project.table_schema,
    audit_check_project.fid AS fprocesscat_id,
    audit_check_project.criticity,
    audit_check_project.enabled,
    audit_check_project.message,
    audit_check_project.tstamp,
    audit_check_project.cur_user AS user_name,
    audit_check_project.observ
   FROM audit_check_project
  ORDER BY audit_check_project.table_id, audit_check_project.id;


--
-- Name: v_state_link_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_link_connec AS
(
         SELECT DISTINCT link.link_id
           FROM selector_state,
            selector_expl,
            link
          WHERE ((link.state = selector_state.state_id) AND ((link.expl_id = selector_expl.expl_id) OR (link.expl_id2 = selector_expl.expl_id)) AND (selector_state.cur_user = ("current_user"())::text) AND (selector_expl.cur_user = ("current_user"())::text) AND ((link.feature_type)::text = 'CONNEC'::text))
        EXCEPT ALL
         SELECT plan_psector_x_connec.link_id
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_connec
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
          WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_connec.active IS TRUE))
) UNION ALL
 SELECT plan_psector_x_connec.link_id
   FROM selector_psector,
    selector_expl,
    (plan_psector_x_connec
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_connec.active IS TRUE));


--
-- Name: vu_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    (presszone_id)::character varying(16) AS presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    (public.st_length2d(l.the_geom))::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    d.name AS dma_name,
    q.name AS dqa_name,
    p.name AS presszone_name,
    s.macrosector_id,
    d.macrodma_id,
    q.macrodqa_id,
    l.expl_id2
   FROM ((((link l
     LEFT JOIN sector s USING (sector_id))
     LEFT JOIN presszone p USING (presszone_id))
     LEFT JOIN dma d USING (dma_id))
     LEFT JOIN dqa q USING (dqa_id));


--
-- Name: v_link_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_link_connec AS
 SELECT DISTINCT ON (vu_link.link_id) vu_link.link_id,
    vu_link.feature_type,
    vu_link.feature_id,
    vu_link.exit_type,
    vu_link.exit_id,
    vu_link.state,
    vu_link.expl_id,
    vu_link.sector_id,
    vu_link.dma_id,
    vu_link.presszone_id,
    vu_link.dqa_id,
    vu_link.minsector_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.dma_name,
    vu_link.dqa_name,
    vu_link.presszone_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.macrodqa_id,
    vu_link.expl_id2
   FROM (vu_link
     JOIN v_state_link_connec USING (link_id));


--
-- Name: v_state_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_connec AS
 SELECT DISTINCT ON (a.connec_id) a.connec_id,
    a.arc_id
   FROM ((
                 SELECT connec.connec_id,
                    connec.arc_id,
                    1 AS flag
                   FROM selector_state,
                    selector_expl,
                    connec
                  WHERE ((connec.state = selector_state.state_id) AND ((connec.expl_id = selector_expl.expl_id) OR (connec.expl_id2 = selector_expl.expl_id)) AND (selector_state.cur_user = ("current_user"())::text) AND (selector_expl.cur_user = ("current_user"())::text))
                EXCEPT
                 SELECT plan_psector_x_connec.connec_id,
                    plan_psector_x_connec.arc_id,
                    1 AS flag
                   FROM selector_psector,
                    selector_expl,
                    (plan_psector_x_connec
                     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
                  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text))
        ) UNION
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.arc_id,
            2 AS flag
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_connec
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
          WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text))
  ORDER BY 1, 3 DESC) a;


--
-- Name: vu_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_connec AS
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id AS connec_type,
    cat_feature.system_id AS sys_type,
    connec.connecat_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    connec.customer_code,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.connec_length,
    connec.state,
    connec.state_type,
    a.n_hydrometer,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.minsector_id,
    connec.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    connec.presszone_id,
    presszone.name AS presszone_name,
    connec.staticpressure,
    connec.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    (c.descript)::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    (b.descript)::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.publish,
    connec.inventory,
    connec.num_value,
    cat_connec.connectype_id,
    connec.pjoint_id,
    connec.pjoint_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    connec.adate,
    connec.adescript,
    connec.accessibility,
    (dma.stylesheet ->> 'featureColor'::text) AS dma_style,
    (presszone.stylesheet ->> 'featureColor'::text) AS presszone_style,
    connec.workcat_id_plan,
    connec.asset_id,
    connec.epa_type,
    connec.om_state,
    connec.conserv_state,
    connec.priority,
    connec.valve_location,
    connec.valve_type,
    connec.shutoff_valve,
    connec.access_type,
    connec.placement_type,
    connec.crmzone_id,
    crm_zone.name AS crmzone_name,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.demand,
    connec.expl_id2,
    e.quality_max,
    e.quality_min,
    e.quality_avg
   FROM ((((((((((((connec
     LEFT JOIN ( SELECT connec_1.connec_id,
            (count(ext_rtc_hydrometer.id))::integer AS n_hydrometer
           FROM selector_hydrometer,
            (ext_rtc_hydrometer
             JOIN connec connec_1 ON (((ext_rtc_hydrometer.connec_id)::text = (connec_1.customer_code)::text)))
          WHERE ((selector_hydrometer.state_id = ext_rtc_hydrometer.state_id) AND (selector_hydrometer.cur_user = ("current_user"())::text))
          GROUP BY connec_1.connec_id) a USING (connec_id))
     JOIN cat_connec ON (((connec.connecat_id)::text = (cat_connec.id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_connec.connectype_id)::text)))
     LEFT JOIN dma ON ((connec.dma_id = dma.dma_id)))
     LEFT JOIN sector ON ((connec.sector_id = sector.sector_id)))
     LEFT JOIN exploitation ON ((connec.expl_id = exploitation.expl_id)))
     LEFT JOIN dqa ON ((connec.dqa_id = dqa.dqa_id)))
     LEFT JOIN presszone ON (((presszone.presszone_id)::text = (connec.presszone_id)::text)))
     LEFT JOIN crm_zone ON (((crm_zone.id)::text = (connec.crmzone_id)::text)))
     LEFT JOIN v_ext_streetaxis c ON (((c.id)::text = (connec.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis b ON (((b.id)::text = (connec.streetaxis2_id)::text)))
     LEFT JOIN connec_add e ON (((e.connec_id)::text = (connec.connec_id)::text)));


--
-- Name: v_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_connec AS
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.elevation,
    vu_connec.depth,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.connecat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN (a.sector_id IS NULL) THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
    vu_connec.sector_name,
    vu_connec.macrosector_id,
    vu_connec.customer_code,
    vu_connec.cat_matcat_id,
    vu_connec.cat_pnom,
    vu_connec.cat_dnom,
    vu_connec.connec_length,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.n_hydrometer,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN (a.minsector_id IS NULL) THEN vu_connec.minsector_id
            ELSE a.minsector_id
        END AS minsector_id,
        CASE
            WHEN (a.dma_id IS NULL) THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN (a.dma_name IS NULL) THEN vu_connec.dma_name
            ELSE a.dma_name
        END AS dma_name,
        CASE
            WHEN (a.macrodma_id IS NULL) THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
        CASE
            WHEN (a.presszone_id IS NULL) THEN vu_connec.presszone_id
            ELSE (a.presszone_id)::character varying(30)
        END AS presszone_id,
        CASE
            WHEN (a.presszone_name IS NULL) THEN vu_connec.presszone_name
            ELSE a.presszone_name
        END AS presszone_name,
    vu_connec.staticpressure,
        CASE
            WHEN (a.dqa_id IS NULL) THEN vu_connec.dqa_id
            ELSE a.dqa_id
        END AS dqa_id,
        CASE
            WHEN (a.dqa_name IS NULL) THEN vu_connec.dqa_name
            ELSE a.dqa_name
        END AS dqa_name,
        CASE
            WHEN (a.macrodqa_id IS NULL) THEN vu_connec.macrodqa_id
            ELSE a.macrodqa_id
        END AS macrodqa_id,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.num_value,
    vu_connec.connectype_id,
        CASE
            WHEN (a.exit_id IS NULL) THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN (a.exit_type IS NULL) THEN vu_connec.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.adate,
    vu_connec.adescript,
    vu_connec.accessibility,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.dma_style,
    vu_connec.presszone_style,
    vu_connec.epa_type,
    vu_connec.priority,
    vu_connec.valve_location,
    vu_connec.valve_type,
    vu_connec.shutoff_valve,
    vu_connec.access_type,
    vu_connec.placement_type,
    vu_connec.press_max,
    vu_connec.press_min,
    vu_connec.press_avg,
    vu_connec.demand,
    vu_connec.om_state,
    vu_connec.conserv_state,
    vu_connec.crmzone_id,
    vu_connec.crmzone_name,
    vu_connec.expl_id2,
    vu_connec.quality_max,
    vu_connec.quality_min,
    vu_connec.quality_avg
   FROM ((vu_connec
     JOIN v_state_connec USING (connec_id))
     LEFT JOIN ( SELECT DISTINCT ON (v_link_connec.feature_id) v_link_connec.link_id,
            v_link_connec.feature_type,
            v_link_connec.feature_id,
            v_link_connec.exit_type,
            v_link_connec.exit_id,
            v_link_connec.state,
            v_link_connec.expl_id,
            v_link_connec.sector_id,
            v_link_connec.dma_id,
            v_link_connec.presszone_id,
            v_link_connec.dqa_id,
            v_link_connec.minsector_id,
            v_link_connec.exit_topelev,
            v_link_connec.exit_elev,
            v_link_connec.fluid_type,
            v_link_connec.gis_length,
            v_link_connec.the_geom,
            v_link_connec.sector_name,
            v_link_connec.dma_name,
            v_link_connec.dqa_name,
            v_link_connec.presszone_name,
            v_link_connec.macrosector_id,
            v_link_connec.macrodma_id,
            v_link_connec.macrodqa_id,
            v_link_connec.expl_id2
           FROM v_link_connec
          WHERE (v_link_connec.state = 2)) a ON (((a.feature_id)::text = (vu_connec.connec_id)::text)));


--
-- Name: v_edit_anl_hydrant; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_anl_hydrant AS
 SELECT anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.expl_id,
    anl_node.the_geom
   FROM anl_node
  WHERE ((anl_node.fid = 468) AND ((anl_node.cur_user)::name = "current_user"()));


--
-- Name: v_edit_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.arccat_id,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.cat_matcat_id,
    v_arc.cat_pnom,
    v_arc.cat_dnom,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.sector_name,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.minsector_id,
    v_arc.dma_id,
    v_arc.dma_name,
    v_arc.macrodma_id,
    v_arc.presszone_id,
    v_arc.presszone_name,
    v_arc.dqa_id,
    v_arc.dqa_name,
    v_arc.macrodqa_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.district_id,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.undelete,
    v_arc.label,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.num_value,
    v_arc.cat_arctype_id,
    v_arc.nodetype_1,
    v_arc.staticpress1,
    v_arc.nodetype_2,
    v_arc.staticpress2,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom,
    v_arc.depth,
    v_arc.adate,
    v_arc.adescript,
    v_arc.dma_style,
    v_arc.presszone_style,
    v_arc.workcat_id_plan,
    v_arc.asset_id,
    v_arc.pavcat_id,
    v_arc.om_state,
    v_arc.conserv_state,
    v_arc.flow_max,
    v_arc.flow_min,
    v_arc.flow_avg,
    v_arc.vel_max,
    v_arc.vel_min,
    v_arc.vel_avg,
    v_arc.parent_id,
    v_arc.expl_id2
   FROM v_arc;


--
-- Name: v_edit_cad_auxcircle; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cad_auxcircle AS
 SELECT temp_table.id,
    temp_table.geom_polygon
   FROM temp_table
  WHERE ((temp_table.cur_user = ("current_user"())::text) AND (temp_table.fid = 361));


--
-- Name: v_edit_cad_auxline; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cad_auxline AS
 SELECT temp_table.id,
    temp_table.geom_line
   FROM temp_table
  WHERE ((temp_table.cur_user = ("current_user"())::text) AND (temp_table.fid = 362));


--
-- Name: v_edit_cad_auxpoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cad_auxpoint AS
 SELECT temp_table.id,
    temp_table.geom_point
   FROM temp_table
  WHERE ((temp_table.cur_user = ("current_user"())::text) AND (temp_table.fid = 127));


--
-- Name: v_edit_cat_dscenario; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_dscenario AS
 SELECT DISTINCT ON (c.dscenario_id) c.dscenario_id,
    c.name,
    c.descript,
    c.dscenario_type,
    c.parent_id,
    c.expl_id,
    c.active,
    c.log
   FROM cat_dscenario c,
    selector_expl s
  WHERE (((s.expl_id = c.expl_id) AND (s.cur_user = CURRENT_USER)) OR (c.expl_id IS NULL));


--
-- Name: v_edit_cat_feature_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_feature_arc AS
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_arc.epa_default,
    cat_feature.code_autofill,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_arc USING (id));


--
-- Name: v_edit_cat_feature_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_feature_connec AS
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_connec.epa_default,
    cat_feature.code_autofill,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_connec USING (id));


--
-- Name: v_edit_cat_feature_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_cat_feature_node AS
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_node.epa_default,
    cat_feature_node.isarcdivide,
    cat_feature_node.isprofilesurface,
    cat_feature_node.choose_hemisphere,
    cat_feature.code_autofill,
    (cat_feature_node.double_geom)::text AS double_geom,
    cat_feature_node.num_arcs,
    cat_feature_node.graph_delimiter,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM (cat_feature
     JOIN cat_feature_node USING (id));


--
-- Name: v_edit_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_connec AS
 SELECT v_connec.connec_id,
    v_connec.code,
    v_connec.elevation,
    v_connec.depth,
    v_connec.connec_type,
    v_connec.sys_type,
    v_connec.connecat_id,
    v_connec.expl_id,
    v_connec.macroexpl_id,
    v_connec.sector_id,
    v_connec.sector_name,
    v_connec.macrosector_id,
    v_connec.customer_code,
    v_connec.cat_matcat_id,
    v_connec.cat_pnom,
    v_connec.cat_dnom,
    v_connec.connec_length,
    v_connec.state,
    v_connec.state_type,
    v_connec.n_hydrometer,
    v_connec.arc_id,
    v_connec.annotation,
    v_connec.observ,
    v_connec.comment,
    v_connec.minsector_id,
    v_connec.dma_id,
    v_connec.dma_name,
    v_connec.macrodma_id,
    v_connec.presszone_id,
    v_connec.presszone_name,
    v_connec.staticpressure,
    v_connec.dqa_id,
    v_connec.dqa_name,
    v_connec.macrodqa_id,
    v_connec.soilcat_id,
    v_connec.function_type,
    v_connec.category_type,
    v_connec.fluid_type,
    v_connec.location_type,
    v_connec.workcat_id,
    v_connec.workcat_id_end,
    v_connec.buildercat_id,
    v_connec.builtdate,
    v_connec.enddate,
    v_connec.ownercat_id,
    v_connec.muni_id,
    v_connec.postcode,
    v_connec.district_id,
    v_connec.streetname,
    v_connec.postnumber,
    v_connec.postcomplement,
    v_connec.streetname2,
    v_connec.postnumber2,
    v_connec.postcomplement2,
    v_connec.descript,
    v_connec.svg,
    v_connec.rotation,
    v_connec.link,
    v_connec.verified,
    v_connec.undelete,
    v_connec.label,
    v_connec.label_x,
    v_connec.label_y,
    v_connec.label_rotation,
    v_connec.publish,
    v_connec.inventory,
    v_connec.num_value,
    v_connec.connectype_id,
    v_connec.pjoint_id,
    v_connec.pjoint_type,
    v_connec.tstamp,
    v_connec.insert_user,
    v_connec.lastupdate,
    v_connec.lastupdate_user,
    v_connec.the_geom,
    v_connec.adate,
    v_connec.adescript,
    v_connec.accessibility,
    v_connec.workcat_id_plan,
    v_connec.asset_id,
    v_connec.dma_style,
    v_connec.presszone_style,
    v_connec.epa_type,
    v_connec.priority,
    v_connec.valve_location,
    v_connec.valve_type,
    v_connec.shutoff_valve,
    v_connec.access_type,
    v_connec.placement_type,
    v_connec.press_max,
    v_connec.press_min,
    v_connec.press_avg,
    v_connec.demand,
    v_connec.om_state,
    v_connec.conserv_state,
    v_connec.crmzone_id,
    v_connec.crmzone_name,
    v_connec.expl_id2,
    v_connec.quality_max,
    v_connec.quality_min,
    v_connec.quality_avg
   FROM v_connec;


--
-- Name: v_state_dimensions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_dimensions AS
 SELECT dimensions.id
   FROM selector_state,
    dimensions
  WHERE ((dimensions.state = selector_state.state_id) AND (selector_state.cur_user = CURRENT_USER));


--
-- Name: v_edit_dimensions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_dimensions AS
 SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.x_label,
    dimensions.y_label,
    dimensions.rotation_label,
    dimensions.offset_label,
    dimensions.direction_arrow,
    dimensions.x_symbol,
    dimensions.y_symbol,
    dimensions.feature_id,
    dimensions.feature_type,
    dimensions.state,
    dimensions.expl_id,
    dimensions.observ,
    dimensions.comment
   FROM selector_expl,
    (dimensions
     JOIN v_state_dimensions ON ((dimensions.id = v_state_dimensions.id)))
  WHERE ((dimensions.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_dma; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_dma AS
 SELECT dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.descript,
    dma.the_geom,
    dma.undelete,
    dma.expl_id,
    dma.pattern_id,
    dma.link,
    dma.minc,
    dma.maxc,
    dma.effc,
    (dma.graphconfig)::text AS graphconfig,
    (dma.stylesheet)::text AS stylesheet,
    dma.active,
    dma.avg_press
   FROM selector_expl,
    dma
  WHERE ((dma.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_dqa; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_dqa AS
 SELECT dqa.dqa_id,
    dqa.name,
    dqa.expl_id,
    dqa.macrodqa_id,
    dqa.descript,
    dqa.undelete,
    dqa.the_geom,
    dqa.pattern_id,
    dqa.dqa_type,
    dqa.link,
    (dqa.graphconfig)::text AS graphconfig,
    (dqa.stylesheet)::text AS stylesheet,
    dqa.active
   FROM selector_expl,
    dqa
  WHERE ((dqa.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_state_element; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_element AS
 SELECT element.element_id
   FROM selector_state,
    element
  WHERE ((element.state = selector_state.state_id) AND (selector_state.cur_user = CURRENT_USER));


--
-- Name: v_edit_element; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_element AS
 SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.elementtype_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id
   FROM selector_expl,
    (((element
     JOIN v_state_element ON (((element.element_id)::text = (v_state_element.element_id)::text)))
     JOIN cat_element ON (((element.elementcat_id)::text = (cat_element.id)::text)))
     JOIN element_type ON (((element_type.id)::text = (cat_element.elementtype_id)::text)))
  WHERE ((element.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_exploitation; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_exploitation AS
 SELECT exploitation.expl_id,
    exploitation.name,
    exploitation.macroexpl_id,
    exploitation.descript,
    exploitation.undelete,
    exploitation.the_geom,
    exploitation.tstamp,
    exploitation.active
   FROM selector_expl,
    exploitation
  WHERE ((exploitation.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_expl_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_expl_node AS
 SELECT DISTINCT node.node_id
   FROM selector_expl,
    node
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND ((node.expl_id = selector_expl.expl_id) OR (node.expl_id2 = selector_expl.expl_id)));


--
-- Name: v_state_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_node AS
(
         SELECT node.node_id
           FROM selector_state,
            node
          WHERE ((node.state = selector_state.state_id) AND (selector_state.cur_user = ("current_user"())::text))
        EXCEPT
         SELECT plan_psector_x_node.node_id
           FROM selector_psector,
            plan_psector_x_node
          WHERE ((plan_psector_x_node.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_node.state = 0))
) UNION
 SELECT plan_psector_x_node.node_id
   FROM selector_psector,
    plan_psector_x_node
  WHERE ((plan_psector_x_node.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_node.state = 1));


--
-- Name: vu_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vu_node AS
 SELECT node.node_id,
    node.code,
    node.elevation,
    node.depth,
    cat_node.nodetype_id AS node_type,
    cat_feature.system_id AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.expl_id,
    exploitation.macroexpl_id,
    node.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    node.arc_id,
    node.parent_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.minsector_id,
    node.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    node.presszone_id,
    presszone.name AS presszone_name,
    node.staticpressure,
    node.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.workcat_id_end,
    node.builtdate,
    node.enddate,
    node.buildercat_id,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.district_id,
    (a.descript)::character varying(100) AS streetname,
    node.postnumber,
    node.postcomplement,
    (b.descript)::character varying(100) AS streetname2,
    node.postnumber2,
    node.postcomplement2,
    node.descript,
    cat_node.svg,
    node.rotation,
    concat(cat_feature.link_path, node.link) AS link,
    node.verified,
    node.undelete,
    cat_node.label,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.publish,
    node.inventory,
    node.hemisphere,
    node.num_value,
    cat_node.nodetype_id,
    date_trunc('second'::text, node.tstamp) AS tstamp,
    node.insert_user,
    date_trunc('second'::text, node.lastupdate) AS lastupdate,
    node.lastupdate_user,
    node.the_geom,
    node.adate,
    node.adescript,
    node.accessibility,
    (dma.stylesheet ->> 'featureColor'::text) AS dma_style,
    (presszone.stylesheet ->> 'featureColor'::text) AS presszone_style,
    node.workcat_id_plan,
    node.asset_id,
    node.om_state,
    node.conserv_state,
    node.access_type,
    node.placement_type,
    e.demand_max,
    e.demand_min,
    e.demand_avg,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.head_max,
    e.head_min,
    e.head_avg,
    e.quality_max,
    e.quality_min,
    e.quality_avg,
    node.expl_id2
   FROM ((((((((((node
     LEFT JOIN cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_node.nodetype_id)::text)))
     LEFT JOIN dma ON ((node.dma_id = dma.dma_id)))
     LEFT JOIN sector ON ((node.sector_id = sector.sector_id)))
     LEFT JOIN exploitation ON ((node.expl_id = exploitation.expl_id)))
     LEFT JOIN dqa ON ((node.dqa_id = dqa.dqa_id)))
     LEFT JOIN presszone ON (((presszone.presszone_id)::text = (node.presszone_id)::text)))
     LEFT JOIN v_ext_streetaxis a ON (((a.id)::text = (node.streetaxis_id)::text)))
     LEFT JOIN v_ext_streetaxis b ON (((b.id)::text = (node.streetaxis2_id)::text)))
     LEFT JOIN node_add e ON (((e.node_id)::text = (node.node_id)::text)));


--
-- Name: v_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_node AS
 SELECT vu_node.node_id,
    vu_node.code,
    vu_node.elevation,
    vu_node.depth,
    vu_node.node_type,
    vu_node.sys_type,
    vu_node.nodecat_id,
    vu_node.cat_matcat_id,
    vu_node.cat_pnom,
    vu_node.cat_dnom,
    vu_node.epa_type,
    vu_node.expl_id,
    vu_node.macroexpl_id,
    vu_node.sector_id,
    vu_node.sector_name,
    vu_node.macrosector_id,
    vu_node.arc_id,
    vu_node.parent_id,
    vu_node.state,
    vu_node.state_type,
    vu_node.annotation,
    vu_node.observ,
    vu_node.comment,
    vu_node.minsector_id,
    vu_node.dma_id,
    vu_node.dma_name,
    vu_node.macrodma_id,
    vu_node.presszone_id,
    vu_node.presszone_name,
    vu_node.staticpressure,
    vu_node.dqa_id,
    vu_node.dqa_name,
    vu_node.macrodqa_id,
    vu_node.soilcat_id,
    vu_node.function_type,
    vu_node.category_type,
    vu_node.fluid_type,
    vu_node.location_type,
    vu_node.workcat_id,
    vu_node.workcat_id_end,
    vu_node.builtdate,
    vu_node.enddate,
    vu_node.buildercat_id,
    vu_node.ownercat_id,
    vu_node.muni_id,
    vu_node.postcode,
    vu_node.district_id,
    vu_node.streetname,
    vu_node.postnumber,
    vu_node.postcomplement,
    vu_node.streetname2,
    vu_node.postnumber2,
    vu_node.postcomplement2,
    vu_node.descript,
    vu_node.svg,
    vu_node.rotation,
    vu_node.link,
    vu_node.verified,
    vu_node.undelete,
    vu_node.label,
    vu_node.label_x,
    vu_node.label_y,
    vu_node.label_rotation,
    vu_node.publish,
    vu_node.inventory,
    vu_node.hemisphere,
    vu_node.num_value,
    vu_node.nodetype_id,
    vu_node.tstamp,
    vu_node.insert_user,
    vu_node.lastupdate,
    vu_node.lastupdate_user,
    vu_node.the_geom,
    vu_node.adate,
    vu_node.adescript,
    vu_node.accessibility,
    vu_node.dma_style,
    vu_node.presszone_style,
    vu_node.workcat_id_plan,
    vu_node.asset_id,
    vu_node.om_state,
    vu_node.conserv_state,
    vu_node.access_type,
    vu_node.placement_type,
    vu_node.demand_max,
    vu_node.demand_min,
    vu_node.demand_avg,
    vu_node.press_max,
    vu_node.press_min,
    vu_node.press_avg,
    vu_node.head_max,
    vu_node.head_min,
    vu_node.head_avg,
    vu_node.quality_max,
    vu_node.quality_min,
    vu_node.quality_avg,
    vu_node.expl_id2
   FROM ((vu_node
     JOIN v_state_node USING (node_id))
     JOIN v_expl_node e ON (((e.node_id)::text = (vu_node.node_id)::text)));


--
-- Name: v_edit_field_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_field_valve AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszone_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    v_node.the_geom,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    man_valve.ordinarystatus
   FROM (v_node
     JOIN man_valve ON (((man_valve.node_id)::text = (v_node.node_id)::text)));


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
-- Name: v_edit_inp_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_connec AS
 SELECT connec.connec_id,
    connec.elevation,
    connec.depth,
    connec.connecat_id,
    connec.arc_id,
    connec.sector_id,
    connec.dma_id,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.expl_id,
    connec.pjoint_type,
    connec.pjoint_id,
    inp_connec.demand,
    inp_connec.pattern_id,
    connec.the_geom,
    inp_connec.peak_factor,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    connec.epa_type,
    inp_connec.status,
    inp_connec.minorloss
   FROM selector_sector,
    ((v_connec connec
     JOIN inp_connec USING (connec_id))
     JOIN value_state_type vs ON ((vs.id = connec.state_type)))
  WHERE ((connec.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (vs.is_operative IS TRUE));


--
-- Name: v_edit_inp_controls; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_controls AS
 SELECT DISTINCT c.id,
    c.sector_id,
    c.text,
    c.active
   FROM selector_sector,
    inp_controls c
  WHERE ((c.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_curve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_curve AS
 SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.expl_id,
    c.log
   FROM selector_expl s,
    inp_curve c
  WHERE (((c.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (c.expl_id IS NULL))
  ORDER BY c.id;


--
-- Name: v_edit_inp_curve_value; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_curve_value AS
 SELECT DISTINCT cv.id,
    cv.curve_id,
    cv.x_value,
    cv.y_value
   FROM selector_expl s,
    (inp_curve c
     JOIN inp_curve_value cv ON (((c.id)::text = (cv.curve_id)::text)))
  WHERE (((c.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (c.expl_id IS NULL))
  ORDER BY cv.id;


--
-- Name: v_edit_inp_dscenario_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_connec AS
 SELECT d.dscenario_id,
    connec.connec_id,
    connec.pjoint_type,
    connec.pjoint_id,
    c.demand,
    c.pattern_id,
    c.peak_factor,
    c.status,
    c.minorloss,
    c.custom_roughness,
    c.custom_length,
    c.custom_dint,
    connec.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_connec connec
     JOIN inp_dscenario_connec c USING (connec_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((c.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_dscenario_controls; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_controls AS
 SELECT i.id,
    d.dscenario_id,
    i.sector_id,
    i.text,
    i.active
   FROM selector_inp_dscenario,
    (inp_dscenario_controls i
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((i.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_dscenario_demand; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_demand AS
 SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    node.sector_id,
    node.expl_id,
    node.presszone_id,
    node.dma_id,
    node.the_geom
   FROM (((inp_dscenario_demand
     JOIN node ON (((node.node_id)::text = (inp_dscenario_demand.feature_id)::text)))
     JOIN selector_sector s ON ((s.sector_id = node.sector_id)))
     JOIN selector_inp_dscenario d USING (dscenario_id))
  WHERE ((s.cur_user = CURRENT_USER) AND (d.cur_user = CURRENT_USER))
UNION
 SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    connec.sector_id,
    connec.expl_id,
    connec.presszone_id,
    connec.dma_id,
    connec.the_geom
   FROM (((inp_dscenario_demand
     JOIN connec ON (((connec.connec_id)::text = (inp_dscenario_demand.feature_id)::text)))
     JOIN selector_sector s ON ((s.sector_id = connec.sector_id)))
     JOIN selector_inp_dscenario d USING (dscenario_id))
  WHERE ((s.cur_user = CURRENT_USER) AND (d.cur_user = CURRENT_USER));


--
-- Name: v_edit_inp_dscenario_inlet; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_inlet AS
 SELECT d.dscenario_id,
    n.node_id,
    i.initlevel,
    i.minlevel,
    i.maxlevel,
    i.diameter,
    i.minvol,
    i.curve_id,
    i.pattern_id,
    i.overflow,
    i.head,
    n.the_geom
   FROM selector_inp_dscenario,
    ((node n
     JOIN inp_dscenario_inlet i USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((i.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text) AND ((n.epa_type)::text = 'INLET'::text));


--
-- Name: v_edit_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_node AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.expl_id,
    v_node.macroexpl_id,
    v_node.sector_id,
    v_node.sector_name,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.minsector_id,
    v_node.dma_id,
    v_node.dma_name,
    v_node.macrodma_id,
    v_node.presszone_id,
    v_node.presszone_name,
    v_node.staticpressure,
    v_node.dqa_id,
    v_node.dqa_name,
    v_node.macrodqa_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.buildercat_id,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.undelete,
    v_node.label,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.hemisphere,
    v_node.num_value,
    v_node.nodetype_id,
    v_node.tstamp,
    v_node.insert_user,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.the_geom,
    v_node.adate,
    v_node.adescript,
    v_node.accessibility,
    v_node.dma_style,
    v_node.presszone_style,
    man_valve.closed AS closed_valve,
    man_valve.broken AS broken_valve,
    v_node.workcat_id_plan,
    v_node.asset_id,
    v_node.om_state,
    v_node.conserv_state,
    v_node.access_type,
    v_node.placement_type,
    v_node.demand_max,
    v_node.demand_min,
    v_node.demand_avg,
    v_node.press_max,
    v_node.press_min,
    v_node.press_avg,
    v_node.head_max,
    v_node.head_min,
    v_node.head_avg,
    v_node.quality_max,
    v_node.quality_min,
    v_node.quality_avg,
    v_node.expl_id2
   FROM (v_node
     LEFT JOIN man_valve USING (node_id));


--
-- Name: v_sector_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_sector_node AS
 SELECT node.node_id
   FROM selector_sector,
    node
  WHERE ((selector_sector.cur_user = ("current_user"())::text) AND (node.sector_id = selector_sector.sector_id))
UNION
 SELECT node_border_sector.node_id
   FROM selector_sector,
    node_border_sector
  WHERE ((selector_sector.cur_user = ("current_user"())::text) AND (node_border_sector.sector_id = selector_sector.sector_id));


--
-- Name: v_edit_inp_junction; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_junction AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    n.the_geom,
    inp_junction.peak_factor,
    n.expl_id
   FROM (((v_sector_node sn
     JOIN v_edit_node n USING (node_id))
     JOIN inp_junction USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_junction; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_junction AS
 SELECT d.dscenario_id,
    n.node_id,
    j.demand,
    j.pattern_id,
    j.peak_factor,
    n.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_junction n
     JOIN inp_dscenario_junction j USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((j.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_pipe; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pipe AS
 SELECT arc.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    arc.sector_id,
    arc.macrosector_id,
    arc.dma_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.expl_id,
    arc.custom_length,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint,
    arc.the_geom
   FROM selector_sector,
    ((v_arc arc
     JOIN inp_pipe USING (arc_id))
     JOIN value_state_type vs ON ((vs.id = arc.state_type)))
  WHERE ((arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (vs.is_operative IS TRUE));


--
-- Name: v_edit_inp_dscenario_pipe; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_pipe AS
 SELECT d.dscenario_id,
    p.arc_id,
    p.minorloss,
    p.status,
    p.roughness,
    p.dint,
    v_edit_inp_pipe.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_pipe
     JOIN inp_dscenario_pipe p USING (arc_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_pump; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pump AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    n.dma_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type,
    n.the_geom
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_pump USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_pump; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_pump AS
 SELECT d.dscenario_id,
    p.node_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status,
    v_edit_inp_pump.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_pump
     JOIN inp_dscenario_pump p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_dscenario_pump_additional; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_pump_additional AS
 SELECT d.dscenario_id,
    p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status,
    v_edit_inp_pump.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_pump
     JOIN inp_dscenario_pump_additional p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_reservoir; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_reservoir AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    n.the_geom
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_reservoir USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_reservoir; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_reservoir AS
 SELECT d.dscenario_id,
    p.node_id,
    p.pattern_id,
    p.head,
    v_edit_inp_reservoir.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_reservoir
     JOIN inp_dscenario_reservoir p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_dscenario_rules; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_rules AS
 SELECT i.id,
    d.dscenario_id,
    i.sector_id,
    i.text,
    i.active
   FROM selector_inp_dscenario,
    (inp_dscenario_rules i
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((i.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_shortpipe; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_shortpipe AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status,
    n.the_geom
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_shortpipe USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_shortpipe; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_shortpipe AS
 SELECT d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status,
    v.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_shortpipe v
     JOIN inp_dscenario_shortpipe p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_dscenario_tank; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_tank AS
 SELECT d.dscenario_id,
    p.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    v.the_geom
   FROM selector_inp_dscenario,
    ((node v
     JOIN inp_dscenario_tank p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text) AND ((v.epa_type)::text = 'TANK'::text));


--
-- Name: v_edit_inp_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_valve AS
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status,
    v_node.the_geom,
    inp_valve.custom_dint,
    inp_valve.add_settings
   FROM (((v_sector_node sn
     JOIN v_node USING (node_id))
     JOIN inp_valve USING (node_id))
     JOIN value_state_type vs ON ((vs.id = v_node.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_dscenario_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_valve AS
 SELECT d.dscenario_id,
    p.node_id,
    p.valv_type,
    p.pressure,
    p.flow,
    p.coef_loss,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    v.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_valve v
     JOIN inp_dscenario_valve p USING (node_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((p.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_virtualvalve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_virtualvalve AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    ((v_arc.elevation1 + v_arc.elevation2) / (2)::numeric) AS elevation,
    ((v_arc.depth1 + v_arc.depth2) / (2)::numeric) AS depth,
    v_arc.arccat_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.dma_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.expl_id,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.status,
    v_arc.the_geom
   FROM selector_sector,
    ((v_arc
     JOIN inp_virtualvalve USING (arc_id))
     JOIN value_state_type vs ON ((vs.id = v_arc.state_type)))
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (vs.is_operative IS TRUE));


--
-- Name: v_edit_inp_dscenario_virtualvalve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_dscenario_virtualvalve AS
 SELECT d.dscenario_id,
    v_edit_inp_virtualvalve.arc_id,
    v.valv_type,
    v.pressure,
    v.diameter,
    v.flow,
    v.coef_loss,
    v.curve_id,
    v.minorloss,
    v.status,
    v_edit_inp_virtualvalve.the_geom
   FROM selector_inp_dscenario,
    ((v_edit_inp_virtualvalve
     JOIN inp_dscenario_virtualvalve v USING (arc_id))
     JOIN cat_dscenario d USING (dscenario_id))
  WHERE ((v.dscenario_id = selector_inp_dscenario.dscenario_id) AND (selector_inp_dscenario.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_inlet; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_inlet AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
    n.the_geom,
    inp_inlet.overflow,
    inp_inlet.head
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_inlet USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_edit_inp_pattern; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pattern AS
 SELECT DISTINCT p.pattern_id,
    p.observ,
    p.tscode,
    (p.tsparameters)::text AS tsparameters,
    p.expl_id,
    p.log
   FROM selector_expl s,
    inp_pattern p
  WHERE (((p.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (p.expl_id IS NULL))
  ORDER BY p.pattern_id;


--
-- Name: v_edit_inp_pattern_value; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pattern_value AS
 SELECT DISTINCT inp_pattern_value.id,
    p.pattern_id,
    p.observ,
    p.tscode,
    (p.tsparameters)::text AS tsparameters,
    p.expl_id,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18
   FROM selector_expl s,
    (inp_pattern p
     JOIN inp_pattern_value USING (pattern_id))
  WHERE (((p.expl_id = s.expl_id) AND (s.cur_user = ("current_user"())::text)) OR (p.expl_id IS NULL))
  ORDER BY inp_pattern_value.id;


--
-- Name: v_edit_inp_pump_additional; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_pump_additional AS
 SELECT p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status
   FROM (inp_pump_additional p
     JOIN v_edit_inp_pump USING (node_id));


--
-- Name: v_edit_inp_rules; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_rules AS
 SELECT DISTINCT rules.id,
    rules.sector_id,
    rules.text,
    rules.active
   FROM selector_sector,
    inp_rules rules
  WHERE ((rules.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: v_edit_inp_tank; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_inp_tank AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    n.the_geom,
    inp_tank.overflow
   FROM (((v_sector_node sn
     JOIN v_node n USING (node_id))
     JOIN inp_tank USING (node_id))
     JOIN value_state_type vs ON ((vs.id = n.state_type)))
  WHERE (vs.is_operative IS TRUE);


--
-- Name: v_state_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_link AS
(
         SELECT DISTINCT link.link_id
           FROM selector_state,
            selector_expl,
            link
          WHERE ((link.state = selector_state.state_id) AND ((link.expl_id = selector_expl.expl_id) OR (link.expl_id2 = selector_expl.expl_id)) AND (selector_state.cur_user = ("current_user"())::text) AND (selector_expl.cur_user = ("current_user"())::text))
        EXCEPT ALL
         SELECT plan_psector_x_connec.link_id
           FROM selector_psector,
            selector_expl,
            (plan_psector_x_connec
             JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
          WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 0) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_connec.active IS TRUE))
) UNION ALL
 SELECT plan_psector_x_connec.link_id
   FROM selector_psector,
    selector_expl,
    (plan_psector_x_connec
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_connec.psector_id)))
  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text) AND (plan_psector_x_connec.state = 1) AND (plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = (CURRENT_USER)::text) AND (plan_psector_x_connec.active IS TRUE));


--
-- Name: v_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_link AS
 SELECT DISTINCT ON (vu_link.link_id) vu_link.link_id,
    vu_link.feature_type,
    vu_link.feature_id,
    vu_link.exit_type,
    vu_link.exit_id,
    vu_link.state,
    vu_link.expl_id,
    vu_link.sector_id,
    vu_link.dma_id,
    vu_link.presszone_id,
    vu_link.dqa_id,
    vu_link.minsector_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.dma_name,
    vu_link.dqa_name,
    vu_link.presszone_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.macrodqa_id,
    vu_link.expl_id2
   FROM (vu_link
     JOIN v_state_link USING (link_id));


--
-- Name: v_edit_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    l.gis_length,
    l.the_geom,
    l.sector_name,
    l.dma_name,
    l.dqa_name,
    l.presszone_name,
    l.macrosector_id,
    l.macrodma_id,
    l.macrodqa_id,
    l.expl_id2
   FROM v_link l;


--
-- Name: v_edit_macrodma; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_macrodma AS
 SELECT macrodma.macrodma_id,
    macrodma.name,
    macrodma.descript,
    macrodma.the_geom,
    macrodma.undelete,
    macrodma.expl_id,
    macrodma.active
   FROM selector_expl,
    macrodma
  WHERE ((macrodma.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_macrodqa; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_macrodqa AS
 SELECT macrodqa.macrodqa_id,
    macrodqa.name,
    macrodqa.expl_id,
    macrodqa.descript,
    macrodqa.undelete,
    macrodqa.the_geom,
    macrodqa.active
   FROM selector_expl,
    macrodqa
  WHERE ((macrodqa.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_macrosector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_macrosector AS
 SELECT macrosector.macrosector_id,
    macrosector.name,
    macrosector.descript,
    macrosector.the_geom,
    macrosector.undelete,
    macrosector.active
   FROM macrosector
  WHERE (macrosector.active IS TRUE);


--
-- Name: v_edit_om_visit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_om_visit AS
 SELECT om_visit.id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.the_geom,
    om_visit.webclient_id,
    om_visit.expl_id
   FROM selector_expl,
    om_visit
  WHERE ((om_visit.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_edit_plan_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_plan_psector AS
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active,
    plan_psector.ext_code,
    plan_psector.status,
    plan_psector.text3,
    plan_psector.text4,
    plan_psector.text5,
    plan_psector.text6,
    plan_psector.num_value,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    plan_psector
  WHERE ((plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_plan_psector_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_plan_psector_x_connec AS
 SELECT plan_psector_x_connec.id,
    plan_psector_x_connec.connec_id,
    plan_psector_x_connec.arc_id,
    plan_psector_x_connec.psector_id,
    plan_psector_x_connec.state,
    plan_psector_x_connec.doable,
    plan_psector_x_connec.descript,
    plan_psector_x_connec.link_id,
    plan_psector_x_connec.active,
    plan_psector_x_connec.insert_tstamp,
    plan_psector_x_connec.insert_user
   FROM plan_psector_x_connec;


--
-- Name: v_price_compost; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_compost AS
SELECT
    NULL::character varying(16) AS id,
    NULL::character varying(5) AS unit,
    NULL::character varying(100) AS descript,
    NULL::numeric(14,2) AS price;


--
-- Name: v_edit_plan_psector_x_other; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_plan_psector_x_other AS
 SELECT plan_psector_x_other.id,
    plan_psector_x_other.psector_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    rpad((v_price_compost.descript)::text, 125) AS price_descript,
    v_price_compost.price,
    plan_psector_x_other.measurement,
    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget,
    plan_psector_x_other.observ,
    plan_psector.atlas_id
   FROM ((plan_psector_x_other
     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_other.psector_id)))
  ORDER BY plan_psector_x_other.psector_id;


--
-- Name: v_edit_pond; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_pond AS
 SELECT pond.pond_id,
    pond.connec_id,
    pond.dma_id,
    dma.macrodma_id,
    pond.state,
    pond.the_geom,
    pond.expl_id
   FROM selector_expl,
    (pond
     LEFT JOIN dma ON ((pond.dma_id = dma.dma_id)))
  WHERE ((pond.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_edit_pool; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_pool AS
 SELECT pool.pool_id,
    pool.connec_id,
    pool.dma_id,
    dma.macrodma_id,
    pool.state,
    pool.the_geom,
    pool.expl_id
   FROM selector_expl,
    (pool
     LEFT JOIN dma ON ((pool.dma_id = dma.dma_id)))
  WHERE ((pool.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_edit_presszone; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_presszone AS
 SELECT presszone.presszone_id,
    presszone.name,
    presszone.expl_id,
    presszone.the_geom,
    (presszone.graphconfig)::text AS graphconfig,
    presszone.head,
    (presszone.stylesheet)::text AS stylesheet,
    presszone.active,
    presszone.descript
   FROM selector_expl,
    presszone
  WHERE ((presszone.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_review_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_arc AS
 SELECT review_arc.arc_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.review_obs,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_date,
    review_arc.field_checked,
    review_arc.is_validated
   FROM review_arc,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_arc.expl_id = selector_expl.expl_id));


--
-- Name: v_edit_review_audit_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_arc AS
 SELECT review_audit_arc.id,
    review_audit_arc.arc_id,
    review_audit_arc.old_arccat_id,
    review_audit_arc.new_arccat_id,
    review_audit_arc.old_annotation,
    review_audit_arc.new_annotation,
    review_audit_arc.old_observ,
    review_audit_arc.new_observ,
    review_audit_arc.review_obs,
    review_audit_arc.expl_id,
    review_audit_arc.the_geom,
    review_audit_arc.review_status_id,
    review_audit_arc.field_date,
    review_audit_arc.field_user,
    review_audit_arc.is_validated
   FROM review_audit_arc,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_audit_arc.expl_id = selector_expl.expl_id) AND (review_audit_arc.review_status_id <> 0) AND (review_audit_arc.is_validated IS NULL));


--
-- Name: v_edit_review_audit_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_connec AS
 SELECT review_audit_connec.id,
    review_audit_connec.connec_id,
    review_audit_connec.old_connecat_id,
    review_audit_connec.new_connecat_id,
    review_audit_connec.old_annotation,
    review_audit_connec.new_annotation,
    review_audit_connec.old_observ,
    review_audit_connec.new_observ,
    review_audit_connec.review_obs,
    review_audit_connec.expl_id,
    review_audit_connec.the_geom,
    review_audit_connec.review_status_id,
    review_audit_connec.field_date,
    review_audit_connec.field_user,
    review_audit_connec.is_validated
   FROM review_audit_connec,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_audit_connec.expl_id = selector_expl.expl_id) AND (review_audit_connec.review_status_id <> 0) AND (review_audit_connec.is_validated IS NULL));


--
-- Name: v_edit_review_audit_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_audit_node AS
 SELECT review_audit_node.id,
    review_audit_node.node_id,
    review_audit_node.old_elevation,
    review_audit_node.new_elevation,
    review_audit_node.old_depth,
    review_audit_node.new_depth,
    review_audit_node.old_nodecat_id,
    review_audit_node.new_nodecat_id,
    review_audit_node.old_annotation,
    review_audit_node.new_annotation,
    review_audit_node.old_observ,
    review_audit_node.new_observ,
    review_audit_node.review_obs,
    review_audit_node.expl_id,
    review_audit_node.the_geom,
    review_audit_node.review_status_id,
    review_audit_node.field_date,
    review_audit_node.field_user,
    review_audit_node.is_validated
   FROM review_audit_node,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_audit_node.expl_id = selector_expl.expl_id) AND (review_audit_node.review_status_id <> 0) AND (review_audit_node.is_validated IS NULL));


--
-- Name: v_edit_review_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_connec AS
 SELECT review_connec.connec_id,
    review_connec.connecat_id,
    review_connec.annotation,
    review_connec.observ,
    review_connec.review_obs,
    review_connec.expl_id,
    review_connec.the_geom,
    review_connec.field_date,
    review_connec.field_checked,
    review_connec.is_validated
   FROM review_connec,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_connec.expl_id = selector_expl.expl_id));


--
-- Name: v_edit_review_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_review_node AS
 SELECT review_node.node_id,
    review_node.elevation,
    review_node.depth,
    review_node.nodecat_id,
    review_node.annotation,
    review_node.observ,
    review_node.review_obs,
    review_node.expl_id,
    review_node.the_geom,
    review_node.field_date,
    review_node.field_checked,
    review_node.is_validated
   FROM review_node,
    selector_expl
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (review_node.expl_id = selector_expl.expl_id));


--
-- Name: v_edit_rtc_hydro_data_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_rtc_hydro_data_x_connec AS
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_cat_period.code AS cat_period_code,
    ext_rtc_hydrometer_x_data.value_date,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum
   FROM ((((ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     LEFT JOIN ext_cat_hydrometer ON (((ext_cat_hydrometer.id)::bigint = (ext_rtc_hydrometer.catalog_id)::bigint)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (ext_rtc_hydrometer_x_data.hydrometer_id)::bigint)))
     JOIN ext_cat_period ON (((ext_rtc_hydrometer_x_data.cat_period_id)::text = (ext_cat_period.id)::text)))
  ORDER BY ext_rtc_hydrometer_x_data.hydrometer_id, ext_rtc_hydrometer_x_data.cat_period_id DESC;


--
-- Name: v_state_samplepoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_state_samplepoint AS
 SELECT samplepoint.sample_id
   FROM selector_state,
    samplepoint
  WHERE ((samplepoint.state = selector_state.state_id) AND (selector_state.cur_user = CURRENT_USER));


--
-- Name: v_edit_samplepoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_samplepoint AS
 SELECT samplepoint.sample_id,
    samplepoint.code,
    samplepoint.lab_code,
    samplepoint.feature_id,
    samplepoint.featurecat_id,
    samplepoint.dma_id,
    dma.macrodma_id,
    samplepoint.presszone_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.muni_id,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcode,
    samplepoint.district_id,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement,
    samplepoint.postcomplement2,
    samplepoint.place_name,
    samplepoint.cabinet,
    samplepoint.observations,
    samplepoint.verified,
    samplepoint.the_geom,
    samplepoint.expl_id,
    samplepoint.link
   FROM selector_expl,
    ((samplepoint
     JOIN v_state_samplepoint ON (((samplepoint.sample_id)::text = (v_state_samplepoint.sample_id)::text)))
     LEFT JOIN dma ON ((dma.dma_id = samplepoint.dma_id)))
  WHERE ((samplepoint.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_edit_sector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_edit_sector AS
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    (sector.graphconfig)::text AS graphconfig,
    (sector.stylesheet)::text AS stylesheet,
    sector.active,
    sector.parent_id,
    sector.pattern_id
   FROM selector_sector,
    sector
  WHERE ((sector.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: v_expl_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_expl_connec AS
 SELECT connec.connec_id
   FROM selector_expl,
    connec
  WHERE ((selector_expl.cur_user = ("current_user"())::text) AND (connec.expl_id = selector_expl.expl_id));


--
-- Name: v_ext_address; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ext_address AS
 SELECT ext_address.id,
    ext_address.muni_id,
    ext_address.postcode,
    ext_address.streetaxis_id,
    ext_address.postnumber,
    ext_address.plot_id,
    ext_address.expl_id,
    ext_streetaxis.name,
    ext_address.the_geom
   FROM selector_expl,
    (ext_address
     LEFT JOIN ext_streetaxis ON (((ext_streetaxis.id)::text = (ext_address.streetaxis_id)::text)))
  WHERE ((ext_address.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_ext_plot; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ext_plot AS
 SELECT ext_plot.id,
    ext_plot.plot_code,
    ext_plot.muni_id,
    ext_plot.postcode,
    ext_plot.streetaxis_id,
    ext_plot.postnumber,
    ext_plot.complement,
    ext_plot.placement,
    ext_plot.square,
    ext_plot.observ,
    ext_plot.text,
    ext_plot.the_geom,
    ext_plot.expl_id
   FROM selector_expl,
    ext_plot
  WHERE ((ext_plot.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = "current_user"()));


--
-- Name: v_ext_raster_dem; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ext_raster_dem AS
 SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
   FROM v_edit_exploitation a,
    (ext_raster_dem r
     JOIN ext_cat_raster c ON ((c.id = r.rastercat_id)))
  WHERE public.st_dwithin(r.envelope, a.the_geom, (0)::double precision);


--
-- Name: v_inp_pjointpattern; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_inp_pjointpattern AS
 SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
    a.idrow,
        CASE
            WHEN ((a.pjoint_type)::text = 'VNODE'::text) THEN (concat('VN', a.pattern_id))::character varying
            ELSE a.pattern_id
        END AS pattern_id,
    a.pjoint_type,
    (sum(a.factor_1))::numeric(10,8) AS factor_1,
    (sum(a.factor_2))::numeric(10,8) AS factor_2,
    (sum(a.factor_3))::numeric(10,8) AS factor_3,
    (sum(a.factor_4))::numeric(10,8) AS factor_4,
    (sum(a.factor_5))::numeric(10,8) AS factor_5,
    (sum(a.factor_6))::numeric(10,8) AS factor_6,
    (sum(a.factor_7))::numeric(10,8) AS factor_7,
    (sum(a.factor_8))::numeric(10,8) AS factor_8,
    (sum(a.factor_9))::numeric(10,8) AS factor_9,
    (sum(a.factor_10))::numeric(10,8) AS factor_10,
    (sum(a.factor_11))::numeric(10,8) AS factor_11,
    (sum(a.factor_12))::numeric(10,8) AS factor_12,
    (sum(a.factor_13))::numeric(10,8) AS factor_13,
    (sum(a.factor_14))::numeric(10,8) AS factor_14,
    (sum(a.factor_15))::numeric(10,8) AS factor_15,
    (sum(a.factor_16))::numeric(10,8) AS factor_16,
    (sum(a.factor_17))::numeric(10,8) AS factor_17,
    (sum(a.factor_18))::numeric(10,8) AS factor_18
   FROM ( SELECT c.pjoint_type,
                CASE
                    WHEN (b.id = ( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 1
                    WHEN (b.id = ( SELECT (min(sub.id) + 1)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 2
                    WHEN (b.id = ( SELECT (min(sub.id) + 2)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 3
                    WHEN (b.id = ( SELECT (min(sub.id) + 3)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 4
                    WHEN (b.id = ( SELECT (min(sub.id) + 4)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 5
                    WHEN (b.id = ( SELECT (min(sub.id) + 5)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 6
                    WHEN (b.id = ( SELECT (min(sub.id) + 6)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 7
                    WHEN (b.id = ( SELECT (min(sub.id) + 7)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 8
                    WHEN (b.id = ( SELECT (min(sub.id) + 8)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 9
                    WHEN (b.id = ( SELECT (min(sub.id) + 9)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 10
                    WHEN (b.id = ( SELECT (min(sub.id) + 10)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 11
                    WHEN (b.id = ( SELECT (min(sub.id) + 11)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 12
                    WHEN (b.id = ( SELECT (min(sub.id) + 12)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 13
                    WHEN (b.id = ( SELECT (min(sub.id) + 13)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 14
                    WHEN (b.id = ( SELECT (min(sub.id) + 14)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 15
                    WHEN (b.id = ( SELECT (min(sub.id) + 15)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 16
                    WHEN (b.id = ( SELECT (min(sub.id) + 16)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 17
                    WHEN (b.id = ( SELECT (min(sub.id) + 17)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 18
                    WHEN (b.id = ( SELECT (min(sub.id) + 18)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 19
                    WHEN (b.id = ( SELECT (min(sub.id) + 19)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 20
                    WHEN (b.id = ( SELECT (min(sub.id) + 20)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 21
                    WHEN (b.id = ( SELECT (min(sub.id) + 21)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 22
                    WHEN (b.id = ( SELECT (min(sub.id) + 22)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 23
                    WHEN (b.id = ( SELECT (min(sub.id) + 23)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 24
                    WHEN (b.id = ( SELECT (min(sub.id) + 24)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 25
                    WHEN (b.id = ( SELECT (min(sub.id) + 25)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 26
                    WHEN (b.id = ( SELECT (min(sub.id) + 26)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 27
                    WHEN (b.id = ( SELECT (min(sub.id) + 27)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 28
                    WHEN (b.id = ( SELECT (min(sub.id) + 28)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 29
                    WHEN (b.id = ( SELECT (min(sub.id) + 29)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 30
                    ELSE NULL::integer
                END AS idrow,
            c.pjoint_id AS pattern_id,
            sum(((c.demand)::double precision * (b.factor_1)::double precision)) AS factor_1,
            sum(((c.demand)::double precision * (b.factor_2)::double precision)) AS factor_2,
            sum(((c.demand)::double precision * (b.factor_3)::double precision)) AS factor_3,
            sum(((c.demand)::double precision * (b.factor_4)::double precision)) AS factor_4,
            sum(((c.demand)::double precision * (b.factor_5)::double precision)) AS factor_5,
            sum(((c.demand)::double precision * (b.factor_6)::double precision)) AS factor_6,
            sum(((c.demand)::double precision * (b.factor_7)::double precision)) AS factor_7,
            sum(((c.demand)::double precision * (b.factor_8)::double precision)) AS factor_8,
            sum(((c.demand)::double precision * (b.factor_9)::double precision)) AS factor_9,
            sum(((c.demand)::double precision * (b.factor_10)::double precision)) AS factor_10,
            sum(((c.demand)::double precision * (b.factor_11)::double precision)) AS factor_11,
            sum(((c.demand)::double precision * (b.factor_12)::double precision)) AS factor_12,
            sum(((c.demand)::double precision * (b.factor_13)::double precision)) AS factor_13,
            sum(((c.demand)::double precision * (b.factor_14)::double precision)) AS factor_14,
            sum(((c.demand)::double precision * (b.factor_15)::double precision)) AS factor_15,
            sum(((c.demand)::double precision * (b.factor_16)::double precision)) AS factor_16,
            sum(((c.demand)::double precision * (b.factor_17)::double precision)) AS factor_17,
            sum(((c.demand)::double precision * (b.factor_18)::double precision)) AS factor_18
           FROM (( SELECT inp_connec.connec_id,
                    inp_connec.demand,
                    inp_connec.pattern_id,
                    connec.pjoint_id,
                    connec.pjoint_type
                   FROM (inp_connec
                     JOIN connec USING (connec_id))) c
             JOIN inp_pattern_value b USING (pattern_id))
          GROUP BY c.pjoint_type, c.pjoint_id,
                CASE
                    WHEN (b.id = ( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 1
                    WHEN (b.id = ( SELECT (min(sub.id) + 1)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 2
                    WHEN (b.id = ( SELECT (min(sub.id) + 2)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 3
                    WHEN (b.id = ( SELECT (min(sub.id) + 3)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 4
                    WHEN (b.id = ( SELECT (min(sub.id) + 4)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 5
                    WHEN (b.id = ( SELECT (min(sub.id) + 5)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 6
                    WHEN (b.id = ( SELECT (min(sub.id) + 6)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 7
                    WHEN (b.id = ( SELECT (min(sub.id) + 7)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 8
                    WHEN (b.id = ( SELECT (min(sub.id) + 8)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 9
                    WHEN (b.id = ( SELECT (min(sub.id) + 9)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 10
                    WHEN (b.id = ( SELECT (min(sub.id) + 10)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 11
                    WHEN (b.id = ( SELECT (min(sub.id) + 11)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 12
                    WHEN (b.id = ( SELECT (min(sub.id) + 12)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 13
                    WHEN (b.id = ( SELECT (min(sub.id) + 13)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 14
                    WHEN (b.id = ( SELECT (min(sub.id) + 14)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 15
                    WHEN (b.id = ( SELECT (min(sub.id) + 15)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 16
                    WHEN (b.id = ( SELECT (min(sub.id) + 16)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 17
                    WHEN (b.id = ( SELECT (min(sub.id) + 17)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 18
                    WHEN (b.id = ( SELECT (min(sub.id) + 18)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 19
                    WHEN (b.id = ( SELECT (min(sub.id) + 19)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 20
                    WHEN (b.id = ( SELECT (min(sub.id) + 20)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 21
                    WHEN (b.id = ( SELECT (min(sub.id) + 21)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 22
                    WHEN (b.id = ( SELECT (min(sub.id) + 22)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 23
                    WHEN (b.id = ( SELECT (min(sub.id) + 23)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 24
                    WHEN (b.id = ( SELECT (min(sub.id) + 24)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 25
                    WHEN (b.id = ( SELECT (min(sub.id) + 25)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 26
                    WHEN (b.id = ( SELECT (min(sub.id) + 26)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 27
                    WHEN (b.id = ( SELECT (min(sub.id) + 27)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 28
                    WHEN (b.id = ( SELECT (min(sub.id) + 28)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 29
                    WHEN (b.id = ( SELECT (min(sub.id) + 29)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 30
                    ELSE NULL::integer
                END) a
  GROUP BY a.idrow, a.pattern_id, a.pjoint_type;


--
-- Name: v_minsector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_minsector AS
 SELECT m.minsector_id,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.sector_id,
    m.expl_id,
    m.the_geom,
    m.num_border,
    m.num_connec,
    m.num_hydro,
    m.length,
    m.addparam
   FROM selector_expl s,
    minsector m
  WHERE ((m.expl_id = s.expl_id) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_om_mincut; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut AS
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output
   FROM selector_mincut_result,
    (((((((om_mincut
     LEFT JOIN om_typevalue a ON ((((a.id)::integer = om_mincut.mincut_state) AND (a.typevalue = 'mincut_state'::text))))
     LEFT JOIN om_typevalue b ON ((((b.id)::integer = om_mincut.mincut_class) AND (b.typevalue = 'mincut_class'::text))))
     LEFT JOIN om_typevalue c ON ((((c.id)::integer = (om_mincut.anl_cause)::integer) AND (c.typevalue = 'mincut_cause'::text))))
     LEFT JOIN exploitation ON ((om_mincut.expl_id = exploitation.expl_id)))
     LEFT JOIN ext_streetaxis ON (((om_mincut.streetaxis_id)::text = (ext_streetaxis.id)::text)))
     LEFT JOIN macroexploitation ON ((om_mincut.macroexpl_id = macroexploitation.macroexpl_id)))
     LEFT JOIN ext_municipality ON ((om_mincut.muni_id = ext_municipality.muni_id)))
  WHERE ((selector_mincut_result.result_id = om_mincut.id) AND (selector_mincut_result.cur_user = ("current_user"())::text) AND (om_mincut.id > 0));


--
-- Name: v_om_mincut_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_arc AS
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    om_mincut_arc.the_geom
   FROM selector_mincut_result,
    (om_mincut_arc
     JOIN om_mincut ON ((om_mincut_arc.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_arc.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text))
  ORDER BY om_mincut_arc.arc_id;


--
-- Name: v_om_mincut_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_connec AS
 SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    om_mincut_connec.customer_code,
    om_mincut_connec.the_geom
   FROM selector_mincut_result,
    (om_mincut_connec
     JOIN om_mincut ON ((om_mincut_connec.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_connec.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_mincut_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_hydrometer AS
 SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS connec_code
   FROM selector_mincut_result,
    ((((om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON (((om_mincut_hydrometer.hydrometer_id)::text = (ext_rtc_hydrometer.id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((om_mincut_hydrometer.hydrometer_id)::text = (rtc_hydrometer_x_connec.hydrometer_id)::text)))
     JOIN connec ON (((rtc_hydrometer_x_connec.connec_id)::text = (connec.connec_id)::text)))
     JOIN om_mincut ON ((om_mincut_hydrometer.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_hydrometer.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_mincut_initpoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_initpoint AS
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.notified,
    om_mincut.output
   FROM selector_mincut_result,
    (((((((om_mincut
     LEFT JOIN om_typevalue a ON ((((a.id)::integer = om_mincut.mincut_state) AND (a.typevalue = 'mincut_state'::text))))
     LEFT JOIN om_typevalue b ON ((((b.id)::integer = om_mincut.mincut_class) AND (b.typevalue = 'mincut_class'::text))))
     LEFT JOIN om_typevalue c ON ((((c.id)::integer = (om_mincut.anl_cause)::integer) AND (c.typevalue = 'mincut_cause'::text))))
     LEFT JOIN exploitation ON ((om_mincut.expl_id = exploitation.expl_id)))
     LEFT JOIN ext_streetaxis ON (((om_mincut.streetaxis_id)::text = (ext_streetaxis.id)::text)))
     LEFT JOIN macroexploitation ON ((om_mincut.macroexpl_id = macroexploitation.macroexpl_id)))
     LEFT JOIN ext_municipality ON ((om_mincut.muni_id = ext_municipality.muni_id)))
  WHERE ((selector_mincut_result.result_id = om_mincut.id) AND (selector_mincut_result.cur_user = ("current_user"())::text) AND (om_mincut.id > 0));


--
-- Name: v_om_mincut_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_node AS
 SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    om_mincut_node.node_type,
    om_mincut_node.the_geom
   FROM selector_mincut_result,
    (om_mincut_node
     JOIN om_mincut ON ((om_mincut_node.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_node.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_mincut_planned_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_planned_arc AS
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut_arc.arc_id,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_arc.the_geom
   FROM (om_mincut_arc
     JOIN om_mincut ON ((om_mincut.id = om_mincut_arc.result_id)))
  WHERE (om_mincut.mincut_state < 2);


--
-- Name: v_om_mincut_planned_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_planned_valve AS
 SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_valve.the_geom
   FROM (om_mincut_valve
     JOIN om_mincut ON ((om_mincut.id = om_mincut_valve.result_id)))
  WHERE ((om_mincut.mincut_state < 2) AND (om_mincut_valve.proposed = true));


--
-- Name: v_om_mincut_polygon; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_polygon AS
 SELECT om_mincut_polygon.id,
    om_mincut_polygon.result_id,
    om_mincut.work_order,
    om_mincut_polygon.polygon_id,
    om_mincut_polygon.the_geom
   FROM selector_mincut_result,
    (om_mincut_polygon
     JOIN om_mincut ON ((om_mincut_polygon.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_polygon.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_mincut_selected_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_selected_valve AS
 SELECT v_node.node_id,
    v_node.nodetype_id,
    man_valve.closed,
    man_valve.broken,
    v_node.the_geom
   FROM ((v_node
     JOIN man_valve ON (((v_node.node_id)::text = (man_valve.node_id)::text)))
     JOIN config_graph_valve ON (((v_node.nodetype_id)::text = (config_graph_valve.id)::text)))
  WHERE (config_graph_valve.active IS TRUE);


--
-- Name: v_om_mincut_valve; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_mincut_valve AS
 SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut.work_order,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.broken,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut_valve.the_geom
   FROM selector_mincut_result,
    (om_mincut_valve
     JOIN om_mincut ON ((om_mincut_valve.result_id = om_mincut.id)))
  WHERE (((selector_mincut_result.result_id)::text = (om_mincut_valve.result_id)::text) AND (selector_mincut_result.cur_user = ("current_user"())::text));


--
-- Name: v_om_visit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_visit AS
 SELECT DISTINCT ON (a.visit_id) a.visit_id,
    a.code,
    a.visitcat_id,
    a.name,
    a.visit_start,
    a.visit_end,
    a.user_name,
    a.is_done,
    a.feature_id,
    a.feature_type,
    a.the_geom
   FROM ( SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_node.node_id AS feature_id,
            'NODE'::text AS feature_type,
                CASE
                    WHEN (om_visit.the_geom IS NULL) THEN node.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state,
            (((om_visit
             JOIN om_visit_x_node ON ((om_visit_x_node.visit_id = om_visit.id)))
             JOIN node ON (((node.node_id)::text = (om_visit_x_node.node_id)::text)))
             JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
          WHERE ((selector_state.state_id = node.state) AND (selector_state.cur_user = ("current_user"())::text))
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_arc.arc_id AS feature_id,
            'ARC'::text AS feature_type,
                CASE
                    WHEN (om_visit.the_geom IS NULL) THEN public.st_lineinterpolatepoint(arc.the_geom, (0.5)::double precision)
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state,
            (((om_visit
             JOIN om_visit_x_arc ON ((om_visit_x_arc.visit_id = om_visit.id)))
             JOIN arc ON (((arc.arc_id)::text = (om_visit_x_arc.arc_id)::text)))
             JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
          WHERE ((selector_state.state_id = arc.state) AND (selector_state.cur_user = ("current_user"())::text))
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_connec.connec_id AS feature_id,
            'CONNEC'::text AS feature_type,
                CASE
                    WHEN (om_visit.the_geom IS NULL) THEN connec.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state,
            (((om_visit
             JOIN om_visit_x_connec ON ((om_visit_x_connec.visit_id = om_visit.id)))
             JOIN connec ON (((connec.connec_id)::text = (om_visit_x_connec.connec_id)::text)))
             JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
          WHERE ((selector_state.state_id = connec.state) AND (selector_state.cur_user = ("current_user"())::text))) a;


--
-- Name: v_om_waterbalance; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_waterbalance AS
 SELECT e.name AS exploitation,
    d.name AS dma,
    p.code AS period,
    om_waterbalance.auth_bill,
    om_waterbalance.auth_unbill,
    om_waterbalance.loss_app,
    om_waterbalance.loss_real,
    om_waterbalance.total_in,
    om_waterbalance.total_out,
    om_waterbalance.total,
    (p.start_date)::date AS crm_startdate,
    (p.end_date)::date AS crm_enddate,
    om_waterbalance.startdate AS wbal_startdate,
    om_waterbalance.enddate AS wbal_enddate,
    om_waterbalance.ili,
    om_waterbalance.auth,
    om_waterbalance.loss,
        CASE
            WHEN (om_waterbalance.total > (0)::double precision) THEN (((((100)::numeric)::double precision * (om_waterbalance.auth_bill + om_waterbalance.auth_unbill)) / om_waterbalance.total))::numeric(12,2)
            ELSE (0)::numeric(12,2)
        END AS loss_eff,
    om_waterbalance.auth_bill AS rw,
    ((om_waterbalance.total - om_waterbalance.auth_bill))::numeric(12,2) AS nrw,
        CASE
            WHEN (om_waterbalance.total > (0)::double precision) THEN (((((100)::numeric)::double precision * om_waterbalance.auth_bill) / om_waterbalance.total))::numeric(12,2)
            ELSE (0)::numeric(12,2)
        END AS nrw_eff,
    d.the_geom
   FROM (((om_waterbalance
     JOIN exploitation e USING (expl_id))
     JOIN dma d USING (dma_id))
     JOIN ext_cat_period p ON (((p.id)::text = (om_waterbalance.cat_period_id)::text)));


--
-- Name: v_om_waterbalance_report; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_om_waterbalance_report AS
 WITH expl_data AS (
         SELECT (sum(w_1.auth) / sum(w_1.total)) AS expl_rw_eff,
            ((1)::double precision - (sum(w_1.auth) / sum(w_1.total))) AS expl_nrw_eff,
            NULL::text AS expl_nightvol,
                CASE
                    WHEN (sum(w_1.arc_length) = (0)::double precision) THEN NULL::double precision
                    ELSE ((sum(w_1.nrw) / sum(w_1.arc_length)) / ((EXTRACT(epoch FROM age(p_1.end_date, p_1.start_date)) / (3600)::numeric))::double precision)
                END AS expl_m4day,
                CASE
                    WHEN ((sum(w_1.arc_length) = (0)::double precision) AND (sum(w_1.n_connec) = 0) AND (sum(w_1.link_length) = (0)::double precision)) THEN NULL::double precision
                    ELSE ((sum(w_1.loss) * (((365)::numeric / EXTRACT(day FROM (p_1.end_date - p_1.start_date))))::double precision) / ((((6.57)::double precision * sum(w_1.arc_length)) + ((9.13)::double precision * sum(w_1.link_length))) + (((0.256 * (sum(w_1.n_connec))::numeric) * avg(d_1.avg_press)))::double precision))
                END AS expl_ili,
            w_1.expl_id,
            w_1.cat_period_id,
            p_1.start_date
           FROM ((om_waterbalance w_1
             JOIN ext_cat_period p_1 ON (((w_1.cat_period_id)::text = (p_1.id)::text)))
             JOIN dma d_1 ON ((d_1.dma_id = w_1.dma_id)))
          GROUP BY w_1.expl_id, w_1.cat_period_id, p_1.end_date, p_1.start_date
        )
 SELECT DISTINCT e.name AS exploitation,
    w.expl_id,
    d.name AS dma,
    w.dma_id,
    w.cat_period_id,
    p.code AS period,
    p.start_date,
    p.end_date,
    w.meters_in,
    w.meters_out,
    w.n_connec,
    w.n_hydro,
    w.arc_length,
    w.link_length,
    w.total_in,
    w.total_out,
    w.total,
    w.auth,
    w.nrw,
        CASE
            WHEN (w.total <> (0)::double precision) THEN (w.auth / w.total)
            ELSE NULL::double precision
        END AS dma_rw_eff,
        CASE
            WHEN (w.total <> (0)::double precision) THEN ((1)::double precision - (w.auth / w.total))
            ELSE NULL::double precision
        END AS dma_nrw_eff,
    w.ili AS dma_ili,
    NULL::text AS dma_nightvol,
    ((w.nrw / w.arc_length) / ((EXTRACT(epoch FROM age(p.end_date, p.start_date)) / (3600)::numeric))::double precision) AS dma_m4day,
    ed.expl_rw_eff,
    ed.expl_nrw_eff,
    ed.expl_nightvol,
    ed.expl_ili,
    ed.expl_m4day
   FROM ((((om_waterbalance w
     JOIN exploitation e USING (expl_id))
     JOIN dma d USING (dma_id))
     JOIN ext_cat_period p ON (((w.cat_period_id)::text = (p.id)::text)))
     JOIN expl_data ed ON (((ed.expl_id = w.expl_id) AND ((w.cat_period_id)::text = (p.id)::text))))
  WHERE (ed.start_date = p.start_date);


--
-- Name: v_price_x_catpavement; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catpavement AS
 SELECT cat_pavement.id AS pavcat_id,
    cat_pavement.thickness,
    v_price_compost.price AS m2pav_cost
   FROM (cat_pavement
     JOIN v_price_compost ON (((cat_pavement.m2_cost)::text = (v_price_compost.id)::text)));


--
-- Name: v_plan_aux_arc_pavement; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_aux_arc_pavement AS
 SELECT plan_arc_x_pavement.arc_id,
    (sum((v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)))::numeric(12,2) AS thickness,
    (sum((v_price_x_catpavement.m2pav_cost * plan_arc_x_pavement.percent)))::numeric(12,2) AS m2pav_cost,
    'Various pavements'::character varying AS pavcat_id,
    1 AS percent,
    'VARIOUS'::character varying AS price_id
   FROM (plan_arc_x_pavement
     JOIN v_price_x_catpavement USING (pavcat_id))
  GROUP BY plan_arc_x_pavement.arc_id
UNION
 SELECT v_edit_arc.arc_id,
    c.thickness,
    v_price_x_catpavement.m2pav_cost,
    v_edit_arc.pavcat_id,
    1 AS percent,
    p.id AS price_id
   FROM ((((v_edit_arc
     JOIN cat_pavement c ON (((c.id)::text = (v_edit_arc.pavcat_id)::text)))
     JOIN v_price_x_catpavement USING (pavcat_id))
     LEFT JOIN v_price_compost p ON (((c.m2_cost)::text = (p.id)::text)))
     LEFT JOIN ( SELECT plan_arc_x_pavement.arc_id
           FROM plan_arc_x_pavement) a USING (arc_id))
  WHERE (a.arc_id IS NULL);


--
-- Name: v_price_x_catarc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catarc AS
 SELECT cat_arc.id,
    cat_arc.dint,
    cat_arc.z1,
    cat_arc.z2,
    cat_arc.width,
    cat_arc.area,
    cat_arc.bulk,
    cat_arc.estimated_depth,
    cat_arc.cost_unit,
    price_cost.price AS cost,
    price_m2bottom.price AS m2bottom_cost,
    price_m3protec.price AS m3protec_cost
   FROM (((cat_arc
     JOIN v_price_compost price_cost ON (((cat_arc.cost)::text = (price_cost.id)::text)))
     JOIN v_price_compost price_m2bottom ON (((cat_arc.m2bottom_cost)::text = (price_m2bottom.id)::text)))
     JOIN v_price_compost price_m3protec ON (((cat_arc.m3protec_cost)::text = (price_m3protec.id)::text)));


--
-- Name: v_price_x_catsoil; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catsoil AS
 SELECT cat_soil.id,
    cat_soil.y_param,
    cat_soil.b,
    cat_soil.trenchlining,
    price_m3exc.price AS m3exc_cost,
    price_m3fill.price AS m3fill_cost,
    price_m3excess.price AS m3excess_cost,
        CASE
            WHEN (price_m2trenchl.price IS NULL) THEN (0)::numeric(14,2)
            ELSE price_m2trenchl.price
        END AS m2trenchl_cost
   FROM ((((cat_soil
     JOIN v_price_compost price_m3exc ON (((cat_soil.m3exc_cost)::text = (price_m3exc.id)::text)))
     JOIN v_price_compost price_m3fill ON (((cat_soil.m3fill_cost)::text = (price_m3fill.id)::text)))
     JOIN v_price_compost price_m3excess ON (((cat_soil.m3excess_cost)::text = (price_m3excess.id)::text)))
     LEFT JOIN v_price_compost price_m2trenchl ON (((cat_soil.m2trenchl_cost)::text = (price_m2trenchl.id)::text)));


--
-- Name: v_plan_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_arc AS
 SELECT d.arc_id,
    d.node_1,
    d.node_2,
    d.arc_type,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.sector_id,
    d.expl_id,
    d.annotation,
    d.soilcat_id,
    d.y1,
    d.y2,
    d.mean_y,
    d.z1,
    d.z2,
    d.thickness,
    d.width,
    d.b,
    d.bulk,
    d.geom1,
    d.area,
    d.y_param,
    d.total_y,
    d.rec_y,
    d.geom1_ext,
    d.calculed_y,
    d.m3mlexc,
    d.m2mltrenchl,
    d.m2mlbottom,
    d.m2mlpav,
    d.m3mlprotec,
    d.m3mlfill,
    d.m3mlexcess,
    d.m3exc_cost,
    d.m2trenchl_cost,
    d.m2bottom_cost,
    d.m2pav_cost,
    d.m3protec_cost,
    d.m3fill_cost,
    d.m3excess_cost,
    d.cost_unit,
    d.pav_cost,
    d.exc_cost,
    d.trenchl_cost,
    d.base_cost,
    d.protec_cost,
    d.fill_cost,
    d.excess_cost,
    d.arc_cost,
    d.cost,
    d.length,
    d.budget,
    d.other_budget,
    d.total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_arc.arc_id,
                            v_arc.depth1,
                            v_arc.depth2,
                                CASE
                                    WHEN (((v_arc.depth1 * v_arc.depth2) = (0)::numeric) OR ((v_arc.depth1 * v_arc.depth2) IS NULL)) THEN v_price_x_catarc.estimated_depth
                                    ELSE (((v_arc.depth1 + v_arc.depth2) / (2)::numeric))::numeric(12,2)
                                END AS mean_depth,
                            v_arc.arccat_id,
                            (COALESCE((v_price_x_catarc.dint / (1000)::numeric), (0)::numeric))::numeric(12,4) AS dint,
                            (COALESCE(v_price_x_catarc.z1, (0)::numeric))::numeric(12,2) AS z1,
                            (COALESCE(v_price_x_catarc.z2, (0)::numeric))::numeric(12,2) AS z2,
                            (COALESCE(v_price_x_catarc.area, (0)::numeric))::numeric(12,4) AS area,
                            (COALESCE(v_price_x_catarc.width, (0)::numeric))::numeric(12,2) AS width,
                            (COALESCE((v_price_x_catarc.bulk / (1000)::numeric), (0)::numeric))::numeric(12,4) AS bulk,
                            v_price_x_catarc.cost_unit,
                            (COALESCE(v_price_x_catarc.cost, (0)::numeric))::numeric(12,2) AS arc_cost,
                            (COALESCE(v_price_x_catarc.m2bottom_cost, (0)::numeric))::numeric(12,2) AS m2bottom_cost,
                            (COALESCE(v_price_x_catarc.m3protec_cost, (0)::numeric))::numeric(12,2) AS m3protec_cost,
                            v_price_x_catsoil.id AS soilcat_id,
                            (COALESCE(v_price_x_catsoil.y_param, (10)::numeric))::numeric(5,2) AS y_param,
                            (COALESCE(v_price_x_catsoil.b, (0)::numeric))::numeric(5,2) AS b,
                            COALESCE(v_price_x_catsoil.trenchlining, (0)::numeric) AS trenchlining,
                            (COALESCE(v_price_x_catsoil.m3exc_cost, (0)::numeric))::numeric(12,2) AS m3exc_cost,
                            (COALESCE(v_price_x_catsoil.m3fill_cost, (0)::numeric))::numeric(12,2) AS m3fill_cost,
                            (COALESCE(v_price_x_catsoil.m3excess_cost, (0)::numeric))::numeric(12,2) AS m3excess_cost,
                            (COALESCE(v_price_x_catsoil.m2trenchl_cost, (0)::numeric))::numeric(12,2) AS m2trenchl_cost,
                            (COALESCE(v_plan_aux_arc_pavement.thickness, (0)::numeric))::numeric(12,2) AS thickness,
                            COALESCE(v_plan_aux_arc_pavement.m2pav_cost, (0)::numeric) AS m2pav_cost,
                            v_arc.state,
                            v_arc.expl_id,
                            v_arc.the_geom
                           FROM (((v_arc
                             LEFT JOIN v_price_x_catarc ON (((v_arc.arccat_id)::text = (v_price_x_catarc.id)::text)))
                             LEFT JOIN v_price_x_catsoil ON (((v_arc.soilcat_id)::text = (v_price_x_catsoil.id)::text)))
                             LEFT JOIN v_plan_aux_arc_pavement ON (((v_plan_aux_arc_pavement.arc_id)::text = (v_arc.arc_id)::text)))
                          WHERE (v_plan_aux_arc_pavement.arc_id IS NOT NULL)
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.depth1,
                    v_plan_aux_arc_ml.depth2,
                    v_plan_aux_arc_ml.mean_depth,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.dint,
                    v_plan_aux_arc_ml.z1,
                    v_plan_aux_arc_ml.z2,
                    v_plan_aux_arc_ml.area,
                    v_plan_aux_arc_ml.width,
                    v_plan_aux_arc_ml.bulk,
                    v_plan_aux_arc_ml.cost_unit,
                    v_plan_aux_arc_ml.arc_cost,
                    v_plan_aux_arc_ml.m2bottom_cost,
                    v_plan_aux_arc_ml.m3protec_cost,
                    v_plan_aux_arc_ml.soilcat_id,
                    v_plan_aux_arc_ml.y_param,
                    v_plan_aux_arc_ml.b,
                    v_plan_aux_arc_ml.trenchlining,
                    v_plan_aux_arc_ml.m3exc_cost,
                    v_plan_aux_arc_ml.m3fill_cost,
                    v_plan_aux_arc_ml.m3excess_cost,
                    v_plan_aux_arc_ml.m2trenchl_cost,
                    v_plan_aux_arc_ml.thickness,
                    v_plan_aux_arc_ml.m2pav_cost,
                    v_plan_aux_arc_ml.state,
                    v_plan_aux_arc_ml.expl_id,
                    (((((2)::numeric * (((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)))::numeric(12,3) AS m2mlpavement,
                    ((((2)::numeric * v_plan_aux_arc_ml.b) + v_plan_aux_arc_ml.width))::numeric(12,3) AS m2mlbase,
                    ((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS calculed_depth,
                    (((v_plan_aux_arc_ml.trenchlining * (2)::numeric) * (((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness)))::numeric(12,3) AS m2mltrenchl,
                    ((((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + (v_plan_aux_arc_ml.b * (2)::numeric)) + v_plan_aux_arc_ml.width)) / (2)::numeric))::numeric(12,3) AS m3mlexc,
                    ((((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric)) - v_plan_aux_arc_ml.area))::numeric(12,3) AS m3mlprotec,
                    (((((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1) + v_plan_aux_arc_ml.bulk) - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + (v_plan_aux_arc_ml.b * (2)::numeric)) + v_plan_aux_arc_ml.width)) / (2)::numeric) - ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric))))::numeric(12,3) AS m3mlfill,
                    (((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) * ((((((2)::numeric * ((((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint) + (v_plan_aux_arc_ml.bulk * (2)::numeric)) + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param)) + v_plan_aux_arc_ml.width) + (v_plan_aux_arc_ml.b * (2)::numeric)) + ((v_plan_aux_arc_ml.b * (2)::numeric) + v_plan_aux_arc_ml.width)) / (2)::numeric)))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE (v_plan_aux_arc_ml.arc_id IS NOT NULL)
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            v_plan_aux_arc_cost.arccat_id AS arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            arc.sector_id,
            v_plan_aux_arc_cost.expl_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.depth1 AS y1,
            v_plan_aux_arc_cost.depth2 AS y2,
            v_plan_aux_arc_cost.mean_depth AS mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.dint AS geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            ((v_plan_aux_arc_cost.calculed_depth + v_plan_aux_arc_cost.thickness))::numeric(12,2) AS total_y,
            (((((v_plan_aux_arc_cost.calculed_depth - ((2)::numeric * v_plan_aux_arc_cost.bulk)) - v_plan_aux_arc_cost.z1) - v_plan_aux_arc_cost.z2) - v_plan_aux_arc_cost.dint))::numeric(12,2) AS rec_y,
            ((v_plan_aux_arc_cost.dint + ((2)::numeric * v_plan_aux_arc_cost.bulk)))::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_depth AS calculed_y,
            v_plan_aux_arc_cost.m3mlexc,
            v_plan_aux_arc_cost.m2mltrenchl,
            v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
            v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
            v_plan_aux_arc_cost.m3mlprotec,
            v_plan_aux_arc_cost.m3mlfill,
            v_plan_aux_arc_cost.m3mlexcess,
            v_plan_aux_arc_cost.m3exc_cost,
            v_plan_aux_arc_cost.m2trenchl_cost,
            v_plan_aux_arc_cost.m2bottom_cost,
            (v_plan_aux_arc_cost.m2pav_cost)::numeric(12,2) AS m2pav_cost,
            v_plan_aux_arc_cost.m3protec_cost,
            v_plan_aux_arc_cost.m3fill_cost,
            v_plan_aux_arc_cost.m3excess_cost,
            v_plan_aux_arc_cost.cost_unit,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost)
                END)::numeric(12,3) AS pav_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost)
                END)::numeric(12,3) AS exc_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost)
                END)::numeric(12,3) AS trenchl_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost)
                END)::numeric(12,3) AS base_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost)
                END)::numeric(12,3) AS protec_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost)
                END)::numeric(12,3) AS fill_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::numeric
                    ELSE (v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost)
                END)::numeric(12,3) AS excess_cost,
            (v_plan_aux_arc_cost.arc_cost)::numeric(12,3) AS arc_cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN v_plan_aux_arc_cost.arc_cost
                    ELSE ((((((((v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost) + (v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost)) + (v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost)) + (v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost)) + (v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost)) + (v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost)) + (v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost)) + v_plan_aux_arc_cost.arc_cost)
                END)::numeric(12,2) AS cost,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN NULL::double precision
                    ELSE public.st_length2d(v_plan_aux_arc_cost.the_geom)
                END)::numeric(12,2) AS length,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN v_plan_aux_arc_cost.arc_cost
                    ELSE ((public.st_length2d(v_plan_aux_arc_cost.the_geom))::numeric(12,2) * (((((((((v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost) + (v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost)) + (v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost)) + (v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost)) + (v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost)) + (v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost)) + (v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost)) + v_plan_aux_arc_cost.arc_cost))::numeric(14,2))
                END)::numeric(14,2) AS budget,
            v_plan_aux_arc_connec.connec_total_cost AS other_budget,
            (
                CASE
                    WHEN ((v_plan_aux_arc_cost.cost_unit)::text = 'u'::text) THEN (v_plan_aux_arc_cost.arc_cost +
                    CASE
                        WHEN (v_plan_aux_arc_connec.connec_total_cost IS NULL) THEN (0)::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END)
                    ELSE (((public.st_length2d(v_plan_aux_arc_cost.the_geom))::numeric(12,2) * (((((((((v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost) + (v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost)) + (v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost)) + (v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost)) + (v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost)) + (v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost)) + (v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost)) + v_plan_aux_arc_cost.arc_cost))::numeric(14,2)) +
                    CASE
                        WHEN (v_plan_aux_arc_connec.connec_total_cost IS NULL) THEN (0)::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END)
                END)::numeric(14,2) AS total_budget,
            v_plan_aux_arc_cost.the_geom
           FROM ((v_plan_aux_arc_cost
             JOIN arc ON (((arc.arc_id)::text = (v_plan_aux_arc_cost.arc_id)::text)))
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    ((p.price * (count(*))::numeric))::numeric(12,2) AS connec_total_cost
                   FROM (((v_edit_connec c
                     JOIN arc arc_1 USING (arc_id))
                     JOIN cat_arc ON (((cat_arc.id)::text = (arc_1.arccat_id)::text)))
                     LEFT JOIN v_price_compost p ON ((cat_arc.connect_cost = (p.id)::text)))
                  WHERE (c.arc_id IS NOT NULL)
                  GROUP BY c.arc_id, p.price) v_plan_aux_arc_connec ON (((v_plan_aux_arc_connec.arc_id)::text = (v_plan_aux_arc_cost.arc_id)::text)))) d
  WHERE (d.arc_id IS NOT NULL);


--
-- Name: v_price_x_catnode; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_catnode AS
 SELECT cat_node.id,
    cat_node.estimated_depth,
    cat_node.cost_unit,
    v_price_compost.price AS cost
   FROM (cat_node
     JOIN v_price_compost ON (((cat_node.cost)::text = (v_price_compost.id)::text)));


--
-- Name: v_plan_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_node AS
 SELECT a.node_id,
    a.nodecat_id,
    a.node_type,
    a.top_elev,
    a.elev,
    a.epa_type,
    a.state,
    a.sector_id,
    a.expl_id,
    a.annotation,
    a.cost_unit,
    a.descript,
    a.cost,
    a.measurement,
    a.budget,
    a.the_geom
   FROM ( SELECT v_node.node_id,
            v_node.nodecat_id,
            v_node.sys_type AS node_type,
            v_node.elevation AS top_elev,
            (v_node.elevation - v_node.depth) AS elev,
            v_node.epa_type,
            v_node.state,
            v_node.sector_id,
            v_node.expl_id,
            v_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
            (
                CASE
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'u'::text) THEN (
                    CASE
                        WHEN ((v_node.sys_type)::text = 'PUMP'::text) THEN
                        CASE
                            WHEN (man_pump.pump_number IS NOT NULL) THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END)::numeric
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm3'::text) THEN
                    CASE
                        WHEN ((v_node.sys_type)::text = 'TANK'::text) THEN man_tank.vmax
                        ELSE NULL::numeric
                    END
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm'::text) THEN
                    CASE
                        WHEN (v_node.depth = (0)::numeric) THEN v_price_x_catnode.estimated_depth
                        WHEN (v_node.depth IS NULL) THEN v_price_x_catnode.estimated_depth
                        ELSE v_node.depth
                    END
                    ELSE NULL::numeric
                END)::numeric(12,2) AS measurement,
            (
                CASE
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'u'::text) THEN ((
                    CASE
                        WHEN ((v_node.sys_type)::text = 'PUMP'::text) THEN
                        CASE
                            WHEN (man_pump.pump_number IS NOT NULL) THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END)::numeric * v_price_x_catnode.cost)
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm3'::text) THEN (
                    CASE
                        WHEN ((v_node.sys_type)::text = 'TANK'::text) THEN man_tank.vmax
                        ELSE NULL::numeric
                    END * v_price_x_catnode.cost)
                    WHEN ((v_price_x_catnode.cost_unit)::text = 'm'::text) THEN (
                    CASE
                        WHEN (v_node.depth = (0)::numeric) THEN v_price_x_catnode.estimated_depth
                        WHEN (v_node.depth IS NULL) THEN v_price_x_catnode.estimated_depth
                        ELSE v_node.depth
                    END * v_price_x_catnode.cost)
                    ELSE NULL::numeric
                END)::numeric(12,2) AS budget,
            v_node.the_geom
           FROM (((((v_node
             LEFT JOIN v_price_x_catnode ON (((v_node.nodecat_id)::text = (v_price_x_catnode.id)::text)))
             LEFT JOIN man_tank ON (((man_tank.node_id)::text = (v_node.node_id)::text)))
             LEFT JOIN man_pump ON (((man_pump.node_id)::text = (v_node.node_id)::text)))
             LEFT JOIN cat_node ON (((cat_node.id)::text = (v_node.nodecat_id)::text)))
             LEFT JOIN v_price_compost ON (((v_price_compost.id)::text = (cat_node.cost)::text)))) a;


--
-- Name: v_plan_current_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_current_psector AS
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    (a.suma)::numeric(14,2) AS total_arc,
    (b.suma)::numeric(14,2) AS total_node,
    (c.suma)::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((((100)::numeric + plan_psector.gexpenses) / (100)::numeric))::numeric(14,2) * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2)) AS pec,
    plan_psector.vat,
    ((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)))::numeric(14,2) * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2)) AS pec_vat,
    plan_psector.other,
    (((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)) * (((100)::numeric + plan_psector.other) / (100)::numeric)))::numeric(14,2) * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2)) AS pca,
    plan_psector.the_geom
   FROM config_param_user,
    (((plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM ((v_plan_arc
                     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_arc.psector_id)))
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON ((a.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM ((v_plan_node
                     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_node.psector_id)))
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON ((b.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget
                   FROM ((plan_psector_x_other
                     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_other.psector_id)))
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON ((c.psector_id = plan_psector.psector_id)))
  WHERE (((config_param_user.cur_user)::text = ("current_user"())::text) AND ((config_param_user.parameter)::text = 'plan_psector_vdefault'::text) AND ((config_param_user.value)::integer = plan_psector.psector_id));


--
-- Name: v_plan_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector AS
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    (a.suma)::numeric(14,2) AS total_arc,
    (b.suma)::numeric(14,2) AS total_node,
    (c.suma)::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pec,
    plan_psector.vat,
    (((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)) * (((100)::numeric + plan_psector.other) / (100)::numeric)))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    (((plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM ((v_plan_arc
                     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_arc.psector_id)))
                  WHERE (plan_psector_x_arc.doable IS TRUE)
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON ((a.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM ((v_plan_node
                     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_node.psector_id)))
                  WHERE (plan_psector_x_node.doable IS TRUE)
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON ((b.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget
                   FROM ((plan_psector_x_other
                     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_other.psector_id)))
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON ((c.psector_id = plan_psector.psector_id)))
  WHERE ((plan_psector.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_all AS
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    (a.suma)::numeric(14,2) AS total_arc,
    (b.suma)::numeric(14,2) AS total_node,
    (c.suma)::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pec,
    plan_psector.vat,
    (((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((((((100)::numeric + plan_psector.gexpenses) / (100)::numeric) * (((100)::numeric + plan_psector.vat) / (100)::numeric)) * (((100)::numeric + plan_psector.other) / (100)::numeric)))::double precision * (((
        CASE
            WHEN (a.suma IS NULL) THEN (0)::numeric
            ELSE a.suma
        END +
        CASE
            WHEN (b.suma IS NULL) THEN (0)::numeric
            ELSE b.suma
        END) +
        CASE
            WHEN (c.suma IS NULL) THEN (0)::numeric
            ELSE c.suma
        END))::double precision))::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    (((plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM ((v_plan_arc
                     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_arc.psector_id)))
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON ((a.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM ((v_plan_node
                     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_node.psector_id)))
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON ((b.psector_id = plan_psector.psector_id)))
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget
                   FROM ((plan_psector_x_other
                     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
                     JOIN plan_psector plan_psector_1 ON ((plan_psector_1.psector_id = plan_psector_x_other.psector_id)))
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON ((c.psector_id = plan_psector.psector_id)));


--
-- Name: v_plan_psector_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_arc AS
 SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    cat_arc.arctype_id,
    cat_feature.system_id,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    (plan_psector_x_arc.addparam)::text AS addparam,
    arc.the_geom
   FROM selector_psector,
    (((arc
     JOIN plan_psector_x_arc USING (arc_id))
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_arc.arctype_id)::text)))
  WHERE ((plan_psector_x_arc.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_budget; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget AS
 SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    'arc'::text AS feature_type,
    v_plan_arc.arccat_id AS featurecat_id,
    v_plan_arc.arc_id AS feature_id,
    v_plan_arc.length,
    ((v_plan_arc.total_budget / v_plan_arc.length))::numeric(14,2) AS unitary_cost,
    v_plan_arc.total_budget
   FROM (v_plan_arc
     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
  WHERE (plan_psector_x_arc.doable = true)
UNION
 SELECT (row_number() OVER (ORDER BY v_plan_node.node_id) + 9999) AS rid,
    plan_psector_x_node.psector_id,
    'node'::text AS feature_type,
    v_plan_node.nodecat_id AS featurecat_id,
    v_plan_node.node_id AS feature_id,
    1 AS length,
    v_plan_node.budget AS unitary_cost,
    v_plan_node.budget AS total_budget
   FROM (v_plan_node
     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
  WHERE (plan_psector_x_node.doable = true)
UNION
 SELECT (row_number() OVER (ORDER BY v_edit_plan_psector_x_other.id) + 19999) AS rid,
    v_edit_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    v_edit_plan_psector_x_other.price_id AS featurecat_id,
    v_edit_plan_psector_x_other.observ AS feature_id,
    v_edit_plan_psector_x_other.measurement AS length,
    v_edit_plan_psector_x_other.price AS unitary_cost,
    v_edit_plan_psector_x_other.total_budget
   FROM v_edit_plan_psector_x_other
  ORDER BY 1, 2, 4;


--
-- Name: v_plan_psector_budget_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget_arc AS
 SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    (v_plan_arc.cost)::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_arc.doable,
    plan_psector.priority,
    v_plan_arc.the_geom
   FROM ((v_plan_arc
     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_arc.psector_id)))
  WHERE (plan_psector_x_arc.doable = true)
  ORDER BY plan_psector_x_arc.psector_id;


--
-- Name: v_plan_psector_budget_detail; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget_detail AS
 SELECT v_plan_arc.arc_id,
    plan_psector_x_arc.psector_id,
    v_plan_arc.arccat_id,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.arc_cost AS mlarc_cost,
    v_plan_arc.m3mlexc,
    v_plan_arc.exc_cost AS mlexc_cost,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.trenchl_cost AS mltrench_cost,
    v_plan_arc.m2mlbottom AS m2mlbase,
    v_plan_arc.base_cost AS mlbase_cost,
    v_plan_arc.m2mlpav,
    v_plan_arc.pav_cost AS mlpav_cost,
    v_plan_arc.m3mlprotec,
    v_plan_arc.protec_cost AS mlprotec_cost,
    v_plan_arc.m3mlfill,
    v_plan_arc.fill_cost AS mlfill_cost,
    v_plan_arc.m3mlexcess,
    v_plan_arc.excess_cost AS mlexcess_cost,
    v_plan_arc.cost AS mltotal_cost,
    v_plan_arc.length,
    v_plan_arc.budget AS other_budget,
    v_plan_arc.total_budget
   FROM (v_plan_arc
     JOIN plan_psector_x_arc ON (((plan_psector_x_arc.arc_id)::text = (v_plan_arc.arc_id)::text)))
  WHERE (plan_psector_x_arc.doable = true)
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


--
-- Name: v_plan_psector_budget_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget_node AS
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
    plan_psector_x_node.psector_id,
    plan_psector.psector_type,
    v_plan_node.node_id,
    v_plan_node.nodecat_id,
    (v_plan_node.cost)::numeric(12,2) AS cost,
    v_plan_node.measurement,
    v_plan_node.budget AS total_budget,
    v_plan_node.state,
    v_plan_node.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_node.doable,
    plan_psector.priority,
    v_plan_node.the_geom
   FROM ((v_plan_node
     JOIN plan_psector_x_node ON (((plan_psector_x_node.node_id)::text = (v_plan_node.node_id)::text)))
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_node.psector_id)))
  WHERE (plan_psector_x_node.doable = true)
  ORDER BY plan_psector_x_node.psector_id;


--
-- Name: v_plan_psector_budget_other; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_budget_other AS
 SELECT plan_psector_x_other.id,
    plan_psector_x_other.psector_id,
    plan_psector.psector_type,
    v_price_compost.id AS price_id,
    v_price_compost.descript,
    v_price_compost.price,
    plan_psector_x_other.measurement,
    ((plan_psector_x_other.measurement * v_price_compost.price))::numeric(14,2) AS total_budget,
    plan_psector.priority
   FROM ((plan_psector_x_other
     JOIN v_price_compost ON (((v_price_compost.id)::text = (plan_psector_x_other.price_id)::text)))
     JOIN plan_psector ON ((plan_psector.psector_id = plan_psector_x_other.psector_id)))
  ORDER BY plan_psector_x_other.psector_id;


--
-- Name: v_plan_psector_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_connec AS
 SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.connecat_id,
    cat_connec.connectype_id,
    cat_feature.system_id,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    connec.the_geom
   FROM selector_psector,
    (((connec
     JOIN plan_psector_x_connec USING (connec_id))
     JOIN cat_connec ON (((cat_connec.id)::text = (connec.connecat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_connec.connectype_id)::text)))
  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_link; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_link AS
 SELECT row_number() OVER () AS rid,
    link.link_id,
    plan_psector_x_connec.psector_id,
    connec.connec_id,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    link.the_geom
   FROM selector_psector,
    ((connec
     JOIN plan_psector_x_connec USING (connec_id))
     JOIN link ON (((link.feature_id)::text = (connec.connec_id)::text)))
  WHERE ((plan_psector_x_connec.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_psector_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_psector_node AS
 SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    cat_node.nodetype_id,
    cat_feature.system_id,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    node.the_geom
   FROM selector_psector,
    (((node
     JOIN plan_psector_x_node USING (node_id))
     JOIN cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
     JOIN cat_feature ON (((cat_feature.id)::text = (cat_node.nodetype_id)::text)))
  WHERE ((plan_psector_x_node.psector_id = selector_psector.psector_id) AND (selector_psector.cur_user = ("current_user"())::text));


--
-- Name: v_plan_result_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_result_arc AS
 SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.state,
    plan_rec_result_arc.annotation,
    plan_rec_result_arc.soilcat_id,
    plan_rec_result_arc.y1,
    plan_rec_result_arc.y2,
    plan_rec_result_arc.mean_y,
    plan_rec_result_arc.z1,
    plan_rec_result_arc.z2,
    plan_rec_result_arc.thickness,
    plan_rec_result_arc.width,
    plan_rec_result_arc.b,
    plan_rec_result_arc.bulk,
    plan_rec_result_arc.geom1,
    plan_rec_result_arc.area,
    plan_rec_result_arc.y_param,
    plan_rec_result_arc.total_y,
    plan_rec_result_arc.rec_y,
    plan_rec_result_arc.geom1_ext,
    plan_rec_result_arc.calculed_y,
    plan_rec_result_arc.m3mlexc,
    plan_rec_result_arc.m2mltrenchl,
    plan_rec_result_arc.m2mlbottom,
    plan_rec_result_arc.m2mlpav,
    plan_rec_result_arc.m3mlprotec,
    plan_rec_result_arc.m3mlfill,
    plan_rec_result_arc.m3mlexcess,
    plan_rec_result_arc.m3exc_cost,
    plan_rec_result_arc.m2trenchl_cost,
    plan_rec_result_arc.m2bottom_cost,
    plan_rec_result_arc.m2pav_cost,
    plan_rec_result_arc.m3protec_cost,
    plan_rec_result_arc.m3fill_cost,
    plan_rec_result_arc.m3excess_cost,
    plan_rec_result_arc.cost_unit,
    plan_rec_result_arc.pav_cost,
    plan_rec_result_arc.exc_cost,
    plan_rec_result_arc.trenchl_cost,
    plan_rec_result_arc.base_cost,
    plan_rec_result_arc.protec_cost,
    plan_rec_result_arc.fill_cost,
    plan_rec_result_arc.excess_cost,
    plan_rec_result_arc.arc_cost,
    plan_rec_result_arc.cost,
    plan_rec_result_arc.length,
    plan_rec_result_arc.budget,
    plan_rec_result_arc.other_budget,
    plan_rec_result_arc.total_budget,
    plan_rec_result_arc.the_geom,
    plan_rec_result_arc.builtcost,
    plan_rec_result_arc.builtdate,
    plan_rec_result_arc.age,
    plan_rec_result_arc.acoeff,
    plan_rec_result_arc.aperiod,
    plan_rec_result_arc.arate,
    plan_rec_result_arc.amortized,
    plan_rec_result_arc.pending
   FROM selector_plan_result,
    plan_rec_result_arc
  WHERE (((plan_rec_result_arc.result_id)::text = (selector_plan_result.result_id)::text) AND (selector_plan_result.cur_user = ("current_user"())::text) AND (plan_rec_result_arc.state = 1))
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.state,
    v_plan_arc.annotation,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.mean_y,
    v_plan_arc.z1,
    v_plan_arc.z2,
    v_plan_arc.thickness,
    v_plan_arc.width,
    v_plan_arc.b,
    v_plan_arc.bulk,
    v_plan_arc.geom1,
    v_plan_arc.area,
    v_plan_arc.y_param,
    v_plan_arc.total_y,
    v_plan_arc.rec_y,
    v_plan_arc.geom1_ext,
    v_plan_arc.calculed_y,
    v_plan_arc.m3mlexc,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.m2mlbottom,
    v_plan_arc.m2mlpav,
    v_plan_arc.m3mlprotec,
    v_plan_arc.m3mlfill,
    v_plan_arc.m3mlexcess,
    v_plan_arc.m3exc_cost,
    v_plan_arc.m2trenchl_cost,
    v_plan_arc.m2bottom_cost,
    v_plan_arc.m2pav_cost,
    v_plan_arc.m3protec_cost,
    v_plan_arc.m3fill_cost,
    v_plan_arc.m3excess_cost,
    v_plan_arc.cost_unit,
    v_plan_arc.pav_cost,
    v_plan_arc.exc_cost,
    v_plan_arc.trenchl_cost,
    v_plan_arc.base_cost,
    v_plan_arc.protec_cost,
    v_plan_arc.fill_cost,
    v_plan_arc.excess_cost,
    v_plan_arc.arc_cost,
    v_plan_arc.cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_arc
  WHERE (v_plan_arc.state = 2);


--
-- Name: v_plan_result_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_plan_result_node AS
 SELECT plan_rec_result_node.node_id,
    plan_rec_result_node.nodecat_id,
    plan_rec_result_node.node_type,
    plan_rec_result_node.top_elev,
    plan_rec_result_node.elev,
    plan_rec_result_node.epa_type,
    plan_rec_result_node.state,
    plan_rec_result_node.sector_id,
    plan_rec_result_node.expl_id,
    plan_rec_result_node.cost_unit,
    plan_rec_result_node.descript,
    plan_rec_result_node.measurement,
    plan_rec_result_node.cost,
    plan_rec_result_node.budget,
    plan_rec_result_node.the_geom,
    plan_rec_result_node.builtcost,
    plan_rec_result_node.builtdate,
    plan_rec_result_node.age,
    plan_rec_result_node.acoeff,
    plan_rec_result_node.aperiod,
    plan_rec_result_node.arate,
    plan_rec_result_node.amortized,
    plan_rec_result_node.pending
   FROM selector_expl,
    selector_plan_result,
    plan_rec_result_node
  WHERE ((plan_rec_result_node.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text) AND ((plan_rec_result_node.result_id)::text = (selector_plan_result.result_id)::text) AND (selector_plan_result.cur_user = ("current_user"())::text) AND (plan_rec_result_node.state = 1))
UNION
 SELECT v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.node_type,
    v_plan_node.top_elev,
    v_plan_node.elev,
    v_plan_node.epa_type,
    v_plan_node.state,
    v_plan_node.sector_id,
    v_plan_node.expl_id,
    v_plan_node.cost_unit,
    v_plan_node.descript,
    v_plan_node.measurement,
    v_plan_node.cost,
    v_plan_node.budget,
    v_plan_node.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_node
  WHERE (v_plan_node.state = 2);


--
-- Name: v_polygon; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_polygon AS
 SELECT p.pol_id,
    p.state,
    p.feature_id,
    p.sys_type,
    p.featurecat_id,
    p.the_geom
   FROM selector_state s,
    polygon p
  WHERE ((s.state_id = p.state) AND (s.cur_user = CURRENT_USER));


--
-- Name: v_price_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_price_x_arc AS
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'element'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm2bottom'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.m2bottom_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3protec'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.m3protec_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3exc'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3exc_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3fill'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3fill_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3excess'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3excess_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm2trenchl'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m2trenchl_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_pavement.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'pavement'::text AS identif
   FROM (((arc
     JOIN plan_arc_x_pavement ON (((plan_arc_x_pavement.arc_id)::text = (arc.arc_id)::text)))
     JOIN cat_pavement ON (((cat_pavement.id)::text = (plan_arc_x_pavement.pavcat_id)::text)))
     JOIN v_price_compost ON (((cat_pavement.m2_cost)::text = (v_price_compost.id)::text)))
  ORDER BY 1, 2;


--
-- Name: v_rpt_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc AS
 SELECT arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.sector_id,
    arc.arccat_id,
    max(rpt_arc.flow) AS flow_max,
    min(rpt_arc.flow) AS flow_min,
    avg(rpt_arc.flow) AS flow_avg,
    max(rpt_arc.vel) AS vel_max,
    min(rpt_arc.vel) AS vel_min,
    avg(rpt_arc.vel) AS vel_avg,
    max(rpt_arc.headloss) AS headloss_max,
    min(rpt_arc.headloss) AS headloss_min,
    (max(((rpt_arc.headloss)::double precision / ((public.st_length2d(arc.the_geom) * (10)::double precision) + (0.1)::double precision))))::numeric(12,2) AS uheadloss_max,
    (min(((rpt_arc.headloss)::double precision / ((public.st_length2d(arc.the_geom) * (10)::double precision) + (0.1)::double precision))))::numeric(12,2) AS uheadloss_min,
    max(rpt_arc.setting) AS setting_max,
    min(rpt_arc.setting) AS setting_min,
    max(rpt_arc.reaction) AS reaction_max,
    min(rpt_arc.reaction) AS reaction_min,
    max(rpt_arc.ffactor) AS ffactor_max,
    min(rpt_arc.ffactor) AS ffactor_min,
    arc.the_geom
   FROM selector_rpt_main,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_main.result_id)::text))
  GROUP BY arc.arc_id, arc.arc_type, arc.sector_id, arc.arccat_id, selector_rpt_main.result_id, arc.the_geom
  ORDER BY arc.arc_id;


--
-- Name: v_rpt_arc_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc_all AS
 SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.sector_id,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    ((now())::date + (rpt_arc."time")::interval) AS "time",
    arc.the_geom
   FROM selector_rpt_main,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_arc.setting, arc.arc_id;


--
-- Name: v_rpt_arc_hourly; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_arc_hourly AS
 SELECT rpt_arc.id,
    arc.arc_id,
    arc.sector_id,
    selector_rpt_main.result_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    rpt_arc."time",
    arc.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_main.result_id)::text) AND ((rpt_arc."time")::text = (selector_rpt_main_tstep.timestep)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_arc."time", arc.arc_id;


--
-- Name: v_rpt_comp_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_arc AS
 SELECT arc.arc_id,
    arc.sector_id,
    selector_rpt_compare.result_id,
    max(rpt_arc.flow) AS max_flow,
    min(rpt_arc.flow) AS min_flow,
    max(rpt_arc.vel) AS max_vel,
    min(rpt_arc.vel) AS min_vel,
    max(rpt_arc.headloss) AS max_headloss,
    min(rpt_arc.headloss) AS min_headloss,
    (max(((rpt_arc.headloss)::double precision / ((public.st_length2d(arc.the_geom) * (10)::double precision) + (0.1)::double precision))))::numeric(12,2) AS max_uheadloss,
    (min(((rpt_arc.headloss)::double precision / ((public.st_length2d(arc.the_geom) * (10)::double precision) + (0.1)::double precision))))::numeric(12,2) AS min_uheadloss,
    max(rpt_arc.setting) AS max_setting,
    min(rpt_arc.setting) AS min_setting,
    max(rpt_arc.reaction) AS max_reaction,
    min(rpt_arc.reaction) AS min_reaction,
    max(rpt_arc.ffactor) AS max_ffactor,
    min(rpt_arc.ffactor) AS min_ffactor,
    arc.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_compare.result_id)::text))
  GROUP BY arc.arc_id, arc.sector_id, arc.arc_type, arc.arccat_id, selector_rpt_compare.result_id, arc.the_geom
  ORDER BY arc.arc_id;


--
-- Name: v_rpt_comp_arc_hourly; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_arc_hourly AS
 SELECT rpt_arc.id,
    arc.arc_id,
    arc.sector_id,
    selector_rpt_compare.result_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    rpt_arc."time",
    arc.the_geom
   FROM selector_rpt_compare,
    selector_rpt_main_tstep,
    (rpt_inp_arc arc
     JOIN rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text)))
  WHERE (((rpt_arc.result_id)::text = (selector_rpt_compare.result_id)::text) AND ((rpt_arc."time")::text = (selector_rpt_main_tstep.timestep)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((arc.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_comp_energy_usage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_energy_usage AS
 SELECT rpt_energy_usage.id,
    rpt_energy_usage.result_id,
    rpt_energy_usage.nodarc_id,
    rpt_energy_usage.usage_fact,
    rpt_energy_usage.avg_effic,
    rpt_energy_usage.kwhr_mgal,
    rpt_energy_usage.avg_kw,
    rpt_energy_usage.peak_kw,
    rpt_energy_usage.cost_day
   FROM rpt_energy_usage,
    selector_rpt_compare
  WHERE (((selector_rpt_compare.result_id)::text = (rpt_energy_usage.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_hydraulic_status; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_hydraulic_status AS
 SELECT rpt_hydraulic_status.id,
    rpt_hydraulic_status.result_id,
    rpt_hydraulic_status."time",
    rpt_hydraulic_status.text
   FROM rpt_hydraulic_status,
    selector_rpt_compare
  WHERE (((selector_rpt_compare.result_id)::text = (rpt_hydraulic_status.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));


--
-- Name: v_rpt_comp_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_node AS
 SELECT node.node_id,
    selector_rpt_compare.result_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS max_demand,
    min(rpt_node.demand) AS min_demand,
    max(rpt_node.head) AS max_head,
    min(rpt_node.head) AS min_head,
    max(rpt_node.press) AS max_pressure,
    min(rpt_node.press) AS min_pressure,
    avg(rpt_node.press) AS avg_pressure,
    max(rpt_node.quality) AS max_quality,
    min(rpt_node.quality) AS min_quality,
    node.the_geom
   FROM selector_rpt_compare,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_compare.result_id)::text))
  GROUP BY node.node_id, node.node_type, node.sector_id, node.nodecat_id, selector_rpt_compare.result_id, node.the_geom
  ORDER BY node.node_id;


--
-- Name: v_rpt_comp_node_hourly; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_comp_node_hourly AS
 SELECT rpt_node.id,
    node.node_id,
    node.sector_id,
    selector_rpt_compare.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    rpt_node."time",
    node.the_geom
   FROM selector_rpt_compare,
    selector_rpt_main_tstep,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_compare.result_id)::text) AND ((rpt_node."time")::text = (selector_rpt_main_tstep.timestep)::text) AND (selector_rpt_compare.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_compare.result_id)::text));


--
-- Name: v_rpt_energy_usage; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_energy_usage AS
SELECT
    NULL::integer AS id,
    NULL::character varying(30) AS result_id,
    NULL::character varying(16) AS nodarc_id,
    NULL::numeric AS usage_fact,
    NULL::numeric AS avg_effic,
    NULL::numeric AS kwhr_mgal,
    NULL::numeric AS avg_kw,
    NULL::numeric AS peak_kw,
    NULL::numeric AS cost_day;


--
-- Name: v_rpt_hydraulic_status; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_hydraulic_status AS
SELECT
    NULL::integer AS id,
    NULL::character varying(30) AS result_id,
    NULL::character varying(20) AS "time",
    NULL::text AS text;


--
-- Name: v_rpt_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node AS
 SELECT node.node_id,
    selector_rpt_main.result_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS demand_max,
    min(rpt_node.demand) AS demand_min,
    avg(rpt_node.demand) AS demand_avg,
    max(rpt_node.head) AS head_max,
    min(rpt_node.head) AS head_min,
    avg(rpt_node.head) AS head_avg,
    max(rpt_node.press) AS press_max,
    min(rpt_node.press) AS press_min,
    avg(rpt_node.press) AS press_avg,
    max(rpt_node.quality) AS quality_max,
    min(rpt_node.quality) AS quality_min,
    avg(rpt_node.quality) AS quality_avg,
    node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_main.result_id)::text))
  GROUP BY node.node_id, node.node_type, node.sector_id, node.nodecat_id, selector_rpt_main.result_id, node.the_geom
  ORDER BY node.node_id;


--
-- Name: v_rpt_node_all; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node_all AS
 SELECT rpt_node.id,
    node.node_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    selector_rpt_main.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    ((now())::date + (rpt_node."time")::interval) AS "time",
    node.the_geom
   FROM selector_rpt_main,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_node.press, node.node_id;


--
-- Name: v_rpt_node_hourly; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rpt_node_hourly AS
 SELECT rpt_node.id,
    node.node_id,
    node.sector_id,
    selector_rpt_main.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    rpt_node."time",
    node.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    (rpt_inp_node node
     JOIN rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text)))
  WHERE (((rpt_node.result_id)::text = (selector_rpt_main.result_id)::text) AND ((rpt_node."time")::text = (selector_rpt_main_tstep.timestep)::text) AND (selector_rpt_main.cur_user = ("current_user"())::text) AND (selector_rpt_main_tstep.cur_user = ("current_user"())::text) AND ((node.result_id)::text = (selector_rpt_main.result_id)::text))
  ORDER BY rpt_node."time", node.node_id;


--
-- Name: v_rtc_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_hydrometer AS
 SELECT (ext_rtc_hydrometer.id)::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN (connec.connec_id IS NULL) THEN 'XXXX'::character varying
            ELSE connec.connec_id
        END AS connec_id,
        CASE
            WHEN ((ext_rtc_hydrometer.connec_id)::text IS NULL) THEN 'XXXX'::text
            ELSE (ext_rtc_hydrometer.connec_id)::text
        END AS connec_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE ((config_param_system.parameter)::text = 'edit_hydro_link_absolute_path'::text)) IS NULL) THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE ((config_param_system.parameter)::text = 'edit_hydro_link_absolute_path'::text)), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    (((((rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON (((ext_rtc_hydrometer.id)::text = (rtc_hydrometer.hydrometer_id)::text)))
     JOIN ext_rtc_hydrometer_state ON ((ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id)))
     JOIN connec ON (((connec.customer_code)::text = (ext_rtc_hydrometer.connec_id)::text)))
     LEFT JOIN ext_municipality ON ((ext_municipality.muni_id = connec.muni_id)))
     LEFT JOIN exploitation ON ((exploitation.expl_id = connec.expl_id)))
  WHERE ((selector_hydrometer.state_id = ext_rtc_hydrometer.state_id) AND (selector_hydrometer.cur_user = ("current_user"())::text) AND (selector_expl.expl_id = connec.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_rtc_hydrometer_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_hydrometer_x_connec AS
 SELECT rtc_hydrometer_x_connec.connec_id,
    (count(v_rtc_hydrometer.hydrometer_id))::integer AS n_hydrometer
   FROM (rtc_hydrometer_x_connec
     JOIN v_rtc_hydrometer ON ((v_rtc_hydrometer.hydrometer_id = (rtc_hydrometer_x_connec.hydrometer_id)::text)))
  GROUP BY rtc_hydrometer_x_connec.connec_id;


--
-- Name: v_rtc_period_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_rtc_period_hydrometer AS
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    temp_arc.node_1,
    temp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    (c.effc)::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ((ext_rtc_hydrometer_x_data.custom_sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
            ELSE ((ext_rtc_hydrometer_x_data.sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ((((((ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     JOIN ext_cat_period ON (((ext_rtc_hydrometer_x_data.cat_period_id)::text = (ext_cat_period.id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     JOIN v_connec ON (((v_connec.connec_id)::text = (rtc_hydrometer_x_connec.connec_id)::text)))
     JOIN temp_arc ON (((v_connec.arc_id)::text = (temp_arc.arc_id)::text)))
     JOIN ext_rtc_dma_period c ON ((((c.cat_period_id)::text = (ext_cat_period.id)::text) AND ((c.dma_id)::integer = v_connec.dma_id))))
  WHERE ((ext_cat_period.id)::text = ( SELECT config_param_user.value
           FROM config_param_user
          WHERE (((config_param_user.cur_user)::name = "current_user"()) AND ((config_param_user.parameter)::text = 'inp_options_rtc_period_id'::text))))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    (c.effc)::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ((ext_rtc_hydrometer_x_data.custom_sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
            ELSE ((ext_rtc_hydrometer_x_data.sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ((((((ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     JOIN ext_cat_period ON (((ext_rtc_hydrometer_x_data.cat_period_id)::text = (ext_cat_period.id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     LEFT JOIN v_connec ON (((v_connec.connec_id)::text = (rtc_hydrometer_x_connec.connec_id)::text)))
     JOIN temp_node ON ((concat('VN', v_connec.pjoint_id) = (temp_node.node_id)::text)))
     JOIN ext_rtc_dma_period c ON ((((c.cat_period_id)::text = (ext_cat_period.id)::text) AND ((v_connec.dma_id)::text = (c.dma_id)::text))))
  WHERE (((v_connec.pjoint_type)::text = 'VNODE'::text) AND ((ext_cat_period.id)::text = ( SELECT config_param_user.value
           FROM config_param_user
          WHERE (((config_param_user.cur_user)::name = "current_user"()) AND ((config_param_user.parameter)::text = 'inp_options_rtc_period_id'::text)))))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    (c.effc)::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN (ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL) THEN ((ext_rtc_hydrometer_x_data.custom_sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
            ELSE ((ext_rtc_hydrometer_x_data.sum * (1000)::double precision) / (ext_cat_period.period_seconds)::double precision)
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ((((((ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     JOIN ext_cat_period ON (((ext_rtc_hydrometer_x_data.cat_period_id)::text = (ext_cat_period.id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (ext_rtc_hydrometer.id)::bigint)))
     LEFT JOIN v_connec ON (((v_connec.connec_id)::text = (rtc_hydrometer_x_connec.connec_id)::text)))
     JOIN temp_node ON (((v_connec.pjoint_id)::text = (temp_node.node_id)::text)))
     JOIN ext_rtc_dma_period c ON ((((c.cat_period_id)::text = (ext_cat_period.id)::text) AND ((v_connec.dma_id)::text = (c.dma_id)::text))))
  WHERE (((v_connec.pjoint_type)::text = 'NODE'::text) AND ((ext_cat_period.id)::text = ( SELECT config_param_user.value
           FROM config_param_user
          WHERE (((config_param_user.cur_user)::name = "current_user"()) AND ((config_param_user.parameter)::text = 'inp_options_rtc_period_id'::text)))));


--
-- Name: v_ui_arc_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_arc_x_node AS
 SELECT v_arc.arc_id,
    v_arc.node_1,
    public.st_x(a.the_geom) AS x1,
    public.st_y(a.the_geom) AS y1,
    v_arc.node_2,
    public.st_x(b.the_geom) AS x2,
    public.st_y(b.the_geom) AS y2
   FROM ((v_arc
     LEFT JOIN node a ON (((a.node_id)::text = (v_arc.node_1)::text)))
     LEFT JOIN node b ON (((b.node_id)::text = (v_arc.node_2)::text)));


--
-- Name: v_ui_arc_x_relations; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_arc_x_relations AS
 SELECT (row_number() OVER (ORDER BY v_node.node_id) + 1000000) AS rid,
    v_node.arc_id,
    v_node.nodetype_id AS featurecat_id,
    v_node.nodecat_id AS catalog,
    v_node.node_id AS feature_id,
    v_node.code AS feature_code,
    v_node.sys_type,
    v_arc.state AS arc_state,
    v_node.state AS feature_state,
    public.st_x(v_node.the_geom) AS x,
    public.st_y(v_node.the_geom) AS y,
    'v_edit_node'::text AS sys_table_id
   FROM (v_node
     JOIN v_arc ON (((v_arc.arc_id)::text = (v_node.arc_id)::text)))
  WHERE (v_node.arc_id IS NOT NULL)
UNION
 SELECT (row_number() OVER () + 2000000) AS rid,
    v_arc.arc_id,
    v_connec.connectype_id AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    v_arc.state AS arc_state,
    v_connec.state AS feature_state,
    public.st_x(v_connec.the_geom) AS x,
    public.st_y(v_connec.the_geom) AS y,
    'v_edit_connec'::text AS sys_table_id
   FROM (v_connec
     JOIN v_arc ON (((v_arc.arc_id)::text = (v_connec.arc_id)::text)))
  WHERE (v_connec.arc_id IS NOT NULL);


--
-- Name: v_ui_cat_dscenario; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_cat_dscenario AS
 SELECT DISTINCT ON (c.dscenario_id) c.dscenario_id,
    c.name,
    c.descript,
    c.dscenario_type,
    c.parent_id,
    c.expl_id,
    c.active,
    c.log
   FROM cat_dscenario c,
    selector_expl s
  WHERE (((s.expl_id = c.expl_id) AND (s.cur_user = (CURRENT_USER)::text)) OR (c.expl_id IS NULL));


--
-- Name: v_ui_doc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc AS
 SELECT doc.id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;


--
-- Name: v_ui_doc_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_arc AS
 SELECT doc_x_arc.id,
    doc_x_arc.arc_id,
    doc_x_arc.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_arc
     JOIN doc ON (((doc.id)::text = (doc_x_arc.doc_id)::text)));


--
-- Name: v_ui_doc_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_connec AS
 SELECT doc_x_connec.id,
    doc_x_connec.connec_id,
    doc_x_connec.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_connec
     JOIN doc ON (((doc.id)::text = (doc_x_connec.doc_id)::text)));


--
-- Name: v_ui_doc_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_node AS
 SELECT doc_x_node.id,
    doc_x_node.node_id,
    doc_x_node.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_node
     JOIN doc ON (((doc.id)::text = (doc_x_node.doc_id)::text)));


--
-- Name: v_ui_doc_x_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_psector AS
 SELECT doc_x_psector.id,
    doc_x_psector.psector_id,
    doc_x_psector.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_psector
     JOIN doc ON (((doc.id)::text = (doc_x_psector.doc_id)::text)));


--
-- Name: v_ui_doc_x_visit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_visit AS
 SELECT doc_x_visit.id,
    doc_x_visit.visit_id,
    doc_x_visit.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_visit
     JOIN doc ON (((doc.id)::text = (doc_x_visit.doc_id)::text)));


--
-- Name: v_ui_doc_x_workcat; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_doc_x_workcat AS
 SELECT doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc_x_workcat.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM (doc_x_workcat
     JOIN doc ON (((doc.id)::text = (doc_x_workcat.doc_id)::text)));


--
-- Name: v_ui_document; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_document AS
 SELECT doc.id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;


--
-- Name: v_ui_element; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element AS
 SELECT element.element_id AS id,
    element.code,
    element.elementcat_id,
    element.serial_number,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.fluid_type,
    element.location_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.undelete,
    element.publish,
    element.inventory,
    element.expl_id,
    element.feature_type,
    element.tstamp
   FROM element;


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
-- Name: v_ui_element_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element_x_arc AS
 SELECT element_x_arc.id,
    element_x_arc.arc_id,
    element_x_arc.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM (((((element_x_arc
     JOIN v_edit_element ON (((v_edit_element.element_id)::text = (element_x_arc.element_id)::text)))
     JOIN value_state ON ((v_edit_element.state = value_state.id)))
     LEFT JOIN value_state_type ON ((v_edit_element.state_type = value_state_type.id)))
     LEFT JOIN man_type_location ON ((((man_type_location.location_type)::text = (v_edit_element.location_type)::text) AND ((man_type_location.feature_type)::text = 'ELEMENT'::text))))
     LEFT JOIN cat_element ON (((cat_element.id)::text = (v_edit_element.elementcat_id)::text)));


--
-- Name: v_ui_element_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element_x_connec AS
 SELECT element_x_connec.id,
    element_x_connec.connec_id,
    element_x_connec.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM (((((element_x_connec
     JOIN v_edit_element ON (((v_edit_element.element_id)::text = (element_x_connec.element_id)::text)))
     JOIN value_state ON ((v_edit_element.state = value_state.id)))
     LEFT JOIN value_state_type ON ((v_edit_element.state_type = value_state_type.id)))
     LEFT JOIN man_type_location ON ((((man_type_location.location_type)::text = (v_edit_element.location_type)::text) AND ((man_type_location.feature_type)::text = 'ELEMENT'::text))))
     LEFT JOIN cat_element ON (((cat_element.id)::text = (v_edit_element.elementcat_id)::text)));


--
-- Name: v_ui_element_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_element_x_node AS
 SELECT element_x_node.id,
    element_x_node.node_id,
    element_x_node.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM (((((element_x_node
     JOIN v_edit_element ON (((v_edit_element.element_id)::text = (element_x_node.element_id)::text)))
     JOIN value_state ON ((v_edit_element.state = value_state.id)))
     LEFT JOIN value_state_type ON ((v_edit_element.state_type = value_state_type.id)))
     LEFT JOIN man_type_location ON ((((man_type_location.location_type)::text = (v_edit_element.location_type)::text) AND ((man_type_location.feature_type)::text = 'ELEMENT'::text))))
     LEFT JOIN cat_element ON (((cat_element.id)::text = (v_edit_element.elementcat_id)::text)));


--
-- Name: v_ui_event_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_event_x_arc AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_arc ON ((om_visit_x_arc.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     JOIN arc ON (((arc.arc_id)::text = (om_visit_x_arc.arc_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_arc.arc_id;


--
-- Name: v_ui_event_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_event_x_connec AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_connec ON ((om_visit_x_connec.visit_id = om_visit.id)))
     JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN connec ON (((connec.connec_id)::text = (om_visit_x_connec.connec_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_connec.connec_id;


--
-- Name: v_ui_event_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_event_x_node AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document
   FROM (((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_node ON ((om_visit_x_node.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_node.node_id;


--
-- Name: v_ui_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_hydrometer AS
 SELECT v_rtc_hydrometer.hydrometer_id,
    v_rtc_hydrometer.connec_id,
    v_rtc_hydrometer.hydrometer_customer_code,
    v_rtc_hydrometer.connec_customer_code,
    v_rtc_hydrometer.state,
    v_rtc_hydrometer.expl_name,
    v_rtc_hydrometer.hydrometer_link
   FROM v_rtc_hydrometer;


--
-- Name: v_ui_hydroval_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_hydroval_x_connec AS
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM (((((((ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON (((ext_rtc_hydrometer_x_data.hydrometer_id)::text = (ext_rtc_hydrometer.id)::text)))
     LEFT JOIN ext_cat_hydrometer ON (((ext_cat_hydrometer.id)::text = (ext_rtc_hydrometer.catalog_id)::text)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::text = (ext_rtc_hydrometer_x_data.hydrometer_id)::text)))
     JOIN connec ON (((rtc_hydrometer_x_connec.connec_id)::text = (connec.connec_id)::text)))
     LEFT JOIN crm_typevalue crmtype ON (((ext_rtc_hydrometer_x_data.value_type = (crmtype.id)::integer) AND ((crmtype.typevalue)::text = 'crm_value_type'::text))))
     LEFT JOIN crm_typevalue crmstatus ON (((ext_rtc_hydrometer_x_data.value_status = (crmstatus.id)::integer) AND ((crmstatus.typevalue)::text = 'crm_value_status'::text))))
     LEFT JOIN crm_typevalue crmstate ON (((ext_rtc_hydrometer_x_data.value_state = (crmstate.id)::integer) AND ((crmstate.typevalue)::text = 'crm_value_state'::text))))
  ORDER BY ext_rtc_hydrometer_x_data.id;


--
-- Name: v_ui_mincut; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_mincut AS
 SELECT om_mincut.id,
    om_mincut.id AS name,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    exploitation.name AS exploitation,
    ext_municipality.name AS municipality,
    om_mincut.postcode,
    ext_streetaxis.name AS streetaxis,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    cat_users.name AS assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output
   FROM ((((((((om_mincut
     LEFT JOIN om_typevalue a ON ((((a.id)::integer = om_mincut.mincut_state) AND (a.typevalue = 'mincut_state'::text))))
     LEFT JOIN om_typevalue b ON ((((b.id)::integer = om_mincut.mincut_class) AND (b.typevalue = 'mincut_class'::text))))
     LEFT JOIN om_typevalue c ON ((((c.id)::integer = (om_mincut.anl_cause)::integer) AND (c.typevalue = 'mincut_cause'::text))))
     LEFT JOIN exploitation ON ((exploitation.expl_id = om_mincut.expl_id)))
     LEFT JOIN macroexploitation ON ((macroexploitation.macroexpl_id = om_mincut.macroexpl_id)))
     LEFT JOIN ext_municipality ON ((ext_municipality.muni_id = om_mincut.muni_id)))
     LEFT JOIN ext_streetaxis ON (((ext_streetaxis.id)::text = (om_mincut.streetaxis_id)::text)))
     LEFT JOIN cat_users ON (((cat_users.id)::text = (om_mincut.assigned_to)::text)))
  WHERE (om_mincut.id > 0);


--
-- Name: v_ui_mincut_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_mincut_connec AS
 SELECT om_mincut_connec.id,
    om_mincut_connec.connec_id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut_cat_type.virtual,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN (om_mincut.mincut_state = 0) THEN (om_mincut.forecast_start)::timestamp with time zone
            WHEN (om_mincut.mincut_state = 1) THEN now()
            WHEN (om_mincut.mincut_state = 2) THEN (om_mincut.exec_start)::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN (om_mincut.mincut_state = 0) THEN (om_mincut.forecast_end)::timestamp with time zone
            WHEN (om_mincut.mincut_state = 1) THEN now()
            WHEN (om_mincut.mincut_state = 2) THEN (om_mincut.exec_end)::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date
   FROM ((om_mincut_connec
     JOIN om_mincut ON ((om_mincut_connec.result_id = om_mincut.id)))
     JOIN om_mincut_cat_type ON (((om_mincut.mincut_type)::text = (om_mincut_cat_type.id)::text)));


--
-- Name: v_ui_mincut_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_mincut_hydrometer AS
 SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.hydrometer_id,
    rtc_hydrometer_x_connec.connec_id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN (om_mincut.mincut_state = 0) THEN (om_mincut.forecast_start)::timestamp with time zone
            WHEN (om_mincut.mincut_state = 1) THEN now()
            WHEN (om_mincut.mincut_state = 2) THEN (om_mincut.exec_start)::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN (om_mincut.mincut_state = 0) THEN (om_mincut.forecast_end)::timestamp with time zone
            WHEN (om_mincut.mincut_state = 1) THEN now()
            WHEN (om_mincut.mincut_state = 2) THEN (om_mincut.exec_end)::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date
   FROM ((om_mincut_hydrometer
     JOIN om_mincut ON ((om_mincut_hydrometer.result_id = om_mincut.id)))
     JOIN rtc_hydrometer_x_connec ON (((rtc_hydrometer_x_connec.hydrometer_id)::bigint = (om_mincut_hydrometer.hydrometer_id)::bigint)));


--
-- Name: v_ui_node_x_relations; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_node_x_relations AS
 SELECT row_number() OVER (ORDER BY v_node.node_id) AS rid,
    v_node.parent_id AS node_id,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.node_id AS child_id,
    v_node.code,
    v_node.sys_type,
    'v_edit_node'::text AS sys_table_id
   FROM v_node
  WHERE (v_node.parent_id IS NOT NULL);


--
-- Name: v_ui_om_event; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_event AS
 SELECT om_visit_event.id,
    om_visit_event.event_code,
    om_visit_event.visit_id,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit_event;


--
-- Name: v_ui_om_visit; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit AS
 SELECT om_visit.id,
    om_visit_cat.name AS visit_catalog,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    exploitation.name AS exploitation,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done
   FROM ((om_visit
     JOIN om_visit_cat ON ((om_visit.visitcat_id = om_visit_cat.id)))
     LEFT JOIN exploitation ON ((exploitation.expl_id = om_visit.expl_id)));


--
-- Name: v_ui_om_visit_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_arc AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_arc ON ((om_visit_x_arc.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     JOIN arc ON (((arc.arc_id)::text = (om_visit_x_arc.arc_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_arc.arc_id;


--
-- Name: v_ui_om_visit_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_connec AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM ((((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_connec ON ((om_visit_x_connec.visit_id = om_visit.id)))
     JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN connec ON (((connec.connec_id)::text = (om_visit_x_connec.connec_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_connec.connec_id;


--
-- Name: v_ui_om_visit_x_doc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_doc AS
 SELECT doc_x_visit.id,
    doc_x_visit.doc_id,
    doc_x_visit.visit_id
   FROM doc_x_visit;


--
-- Name: v_ui_om_visit_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visit_x_node AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN (a.event_id IS NULL) THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN (b.visit_id IS NULL) THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM (((((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_node ON ((om_visit_x_node.visit_id = om_visit.id)))
     LEFT JOIN config_visit_parameter ON (((config_visit_parameter.id)::text = (om_visit_event.parameter_id)::text)))
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON ((a.event_id = om_visit_event.id)))
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON ((b.visit_id = om_visit.id)))
  ORDER BY om_visit_x_node.node_id;


--
-- Name: v_ui_om_visitman_x_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visitman_x_arc AS
 SELECT DISTINCT ON (v_ui_om_visit_x_arc.visit_id) v_ui_om_visit_x_arc.visit_id,
    v_ui_om_visit_x_arc.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_arc.arc_id,
    date_trunc('second'::text, v_ui_om_visit_x_arc.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_arc.visit_end) AS visit_end,
    v_ui_om_visit_x_arc.user_name,
    v_ui_om_visit_x_arc.is_done,
    v_ui_om_visit_x_arc.feature_type,
    v_ui_om_visit_x_arc.form_type
   FROM (v_ui_om_visit_x_arc
     LEFT JOIN om_visit_cat ON ((om_visit_cat.id = v_ui_om_visit_x_arc.visitcat_id)));


--
-- Name: v_ui_om_visitman_x_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visitman_x_connec AS
 SELECT DISTINCT ON (v_ui_om_visit_x_connec.visit_id) v_ui_om_visit_x_connec.visit_id,
    v_ui_om_visit_x_connec.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_connec.connec_id,
    date_trunc('second'::text, v_ui_om_visit_x_connec.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_connec.visit_end) AS visit_end,
    v_ui_om_visit_x_connec.user_name,
    v_ui_om_visit_x_connec.is_done,
    v_ui_om_visit_x_connec.feature_type,
    v_ui_om_visit_x_connec.form_type
   FROM (v_ui_om_visit_x_connec
     LEFT JOIN om_visit_cat ON ((om_visit_cat.id = v_ui_om_visit_x_connec.visitcat_id)));


--
-- Name: v_ui_om_visitman_x_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_om_visitman_x_node AS
 SELECT DISTINCT ON (v_ui_om_visit_x_node.visit_id) v_ui_om_visit_x_node.visit_id,
    v_ui_om_visit_x_node.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_node.node_id,
    date_trunc('second'::text, v_ui_om_visit_x_node.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_node.visit_end) AS visit_end,
    v_ui_om_visit_x_node.user_name,
    v_ui_om_visit_x_node.is_done,
    v_ui_om_visit_x_node.feature_type,
    v_ui_om_visit_x_node.form_type
   FROM (v_ui_om_visit_x_node
     LEFT JOIN om_visit_cat ON ((om_visit_cat.id = v_ui_om_visit_x_node.visitcat_id)));


--
-- Name: v_ui_plan_arc_cost; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_plan_arc_cost AS
 WITH p AS (
         SELECT v_plan_arc.arc_id,
            v_plan_arc.node_1,
            v_plan_arc.node_2,
            v_plan_arc.arc_type,
            v_plan_arc.arccat_id,
            v_plan_arc.epa_type,
            v_plan_arc.state,
            v_plan_arc.sector_id,
            v_plan_arc.expl_id,
            v_plan_arc.annotation,
            v_plan_arc.soilcat_id,
            v_plan_arc.y1,
            v_plan_arc.y2,
            v_plan_arc.mean_y,
            v_plan_arc.z1,
            v_plan_arc.z2,
            v_plan_arc.thickness,
            v_plan_arc.width,
            v_plan_arc.b,
            v_plan_arc.bulk,
            v_plan_arc.geom1,
            v_plan_arc.area,
            v_plan_arc.y_param,
            v_plan_arc.total_y,
            v_plan_arc.rec_y,
            v_plan_arc.geom1_ext,
            v_plan_arc.calculed_y,
            v_plan_arc.m3mlexc,
            v_plan_arc.m2mltrenchl,
            v_plan_arc.m2mlbottom,
            v_plan_arc.m2mlpav,
            v_plan_arc.m3mlprotec,
            v_plan_arc.m3mlfill,
            v_plan_arc.m3mlexcess,
            v_plan_arc.m3exc_cost,
            v_plan_arc.m2trenchl_cost,
            v_plan_arc.m2bottom_cost,
            v_plan_arc.m2pav_cost,
            v_plan_arc.m3protec_cost,
            v_plan_arc.m3fill_cost,
            v_plan_arc.m3excess_cost,
            v_plan_arc.cost_unit,
            v_plan_arc.pav_cost,
            v_plan_arc.exc_cost,
            v_plan_arc.trenchl_cost,
            v_plan_arc.base_cost,
            v_plan_arc.protec_cost,
            v_plan_arc.fill_cost,
            v_plan_arc.excess_cost,
            v_plan_arc.arc_cost,
            v_plan_arc.cost,
            v_plan_arc.length,
            v_plan_arc.budget,
            v_plan_arc.other_budget,
            v_plan_arc.total_budget,
            v_plan_arc.the_geom,
            a.id,
            a.arctype_id,
            a.matcat_id,
            a.pnom,
            a.dnom,
            a.dint,
            a.dext,
            a.descript,
            a.link,
            a.brand,
            a.model,
            a.svg,
            a.z1,
            a.z2,
            a.width,
            a.area,
            a.estimated_depth,
            a.bulk,
            a.cost_unit,
            a.cost,
            a.m2bottom_cost,
            a.m3protec_cost,
            a.active,
            a.label,
            a.shape,
            a.acoeff,
            a.connect_cost,
            s.id,
            s.descript,
            s.link,
            s.y_param,
            s.b,
            s.trenchlining,
            s.m3exc_cost,
            s.m3fill_cost,
            s.m3excess_cost,
            s.m2trenchl_cost,
            s.active,
            a.cost AS cat_cost,
            a.m2bottom_cost AS cat_m2bottom_cost,
            a.connect_cost AS cat_connect_cost,
            a.m3protec_cost AS cat_m3_protec_cost,
            s.m3exc_cost AS cat_m3exc_cost,
            s.m3fill_cost AS cat_m3fill_cost,
            s.m3excess_cost AS cat_m3excess_cost,
            s.m2trenchl_cost AS cat_m2trenchl_cost
           FROM ((v_plan_arc
             JOIN cat_arc a ON (((a.id)::text = (v_plan_arc.arccat_id)::text)))
             JOIN cat_soil s ON (((s.id)::text = (v_plan_arc.soilcat_id)::text)))
        )
 SELECT p.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    ((1)::numeric * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mlbottom AS measurement,
    (p.m2mlbottom * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m2bottom_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlprotec AS measurement,
    (p.m3mlprotec * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m3_protec_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexc AS measurement,
    (p.m3mlexc * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m3exc_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlfill AS measurement,
    (p.m3mlfill * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m3fill_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexcess AS measurement,
    (p.m3mlexcess * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m3excess_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mltrenchl AS measurement,
    (p.m2mltrenchl * v_price_compost.price) AS total_cost,
    p.length
   FROM (p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON (((p.cat_m2trenchl_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT p.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
        CASE
            WHEN (a.price_id IS NULL) THEN 'Various pavements'::character varying
            ELSE a.pavcat_id
        END AS catalog_id,
        CASE
            WHEN (a.price_id IS NULL) THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS price_id,
    'm2'::character varying AS unit,
        CASE
            WHEN (a.price_id IS NULL) THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS descript,
    a.m2pav_cost AS cost,
    1 AS measurement,
    a.m2pav_cost AS total_cost,
    p.length
   FROM (((p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON (((a.arc_id)::text = (p.arc_id)::text)))
     JOIN cat_pavement c ON (((a.pavcat_id)::text = (c.id)::text)))
     LEFT JOIN v_price_compost r ON (((a.price_id)::text = (c.m2_cost)::text)))
UNION
 SELECT p.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of connec connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_connec.connec_id) AS measurement,
    (((min(v.price) * (count(v_edit_connec.connec_id))::numeric) / COALESCE(min(p.length), (1)::numeric)))::numeric(12,2) AS total_cost,
    (min(p.length))::numeric(12,2) AS length
   FROM ((p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id))
     JOIN v_price_compost v ON ((p.cat_connect_cost = (v.id)::text)))
  GROUP BY p.arc_id
  ORDER BY 1, 2;


--
-- Name: v_ui_plan_node_cost; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_plan_node_cost AS
 SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    ((1)::numeric * v_price_compost.price) AS total_cost,
    NULL::double precision AS length
   FROM (((node
     JOIN cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
     JOIN v_price_compost ON (((cat_node.cost)::text = (v_price_compost.id)::text)))
     JOIN v_plan_node ON (((node.node_id)::text = (v_plan_node.node_id)::text)));


--
-- Name: v_ui_plan_psector; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_plan_psector AS
 SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    ((((plan_psector
     JOIN exploitation USING (expl_id))
     LEFT JOIN plan_typevalue p ON ((((p.id)::text = (plan_psector.priority)::text) AND (p.typevalue = 'value_priority'::text))))
     LEFT JOIN plan_typevalue s ON ((((s.id)::text = (plan_psector.status)::text) AND (s.typevalue = 'psector_status'::text))))
     LEFT JOIN plan_typevalue t ON ((((t.id)::integer = plan_psector.psector_type) AND (t.typevalue = 'psector_type'::text))))
  WHERE ((plan_psector.expl_id = selector_expl.expl_id) AND (selector_expl.cur_user = ("current_user"())::text));


--
-- Name: v_ui_rpt_cat_result; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_rpt_cat_result AS
 SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.cur_user,
    rpt_cat_result.exec_date,
    inp_typevalue.idval AS status,
    rpt_cat_result.iscorporate,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats
   FROM selector_expl s,
    (rpt_cat_result
     JOIN inp_typevalue ON (((rpt_cat_result.status)::text = (inp_typevalue.id)::text)))
  WHERE (((inp_typevalue.typevalue)::text = 'inp_result_status'::text) AND (((s.expl_id = rpt_cat_result.expl_id) AND (s.cur_user = CURRENT_USER)) OR (rpt_cat_result.expl_id IS NULL)));


--
-- Name: v_ui_workcat_x_feature; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_workcat_x_feature AS
 SELECT (row_number() OVER (ORDER BY arc.arc_id) + 1000000) AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
    exploitation.expl_id
   FROM (arc
     JOIN exploitation ON ((exploitation.expl_id = arc.expl_id)))
  WHERE ((arc.state = 1) AND (arc.workcat_id IS NOT NULL))
UNION
 SELECT (row_number() OVER (ORDER BY node.node_id) + 2000000) AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
    exploitation.expl_id
   FROM (node
     JOIN exploitation ON ((exploitation.expl_id = node.expl_id)))
  WHERE ((node.state = 1) AND (node.workcat_id IS NOT NULL))
UNION
 SELECT (row_number() OVER (ORDER BY connec.connec_id) + 3000000) AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
    exploitation.expl_id
   FROM (connec
     JOIN exploitation ON ((exploitation.expl_id = connec.expl_id)))
  WHERE ((connec.state = 1) AND (connec.workcat_id IS NOT NULL))
UNION
 SELECT (row_number() OVER (ORDER BY element.element_id) + 4000000) AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM (element
     JOIN exploitation ON ((exploitation.expl_id = element.expl_id)))
  WHERE ((element.state = 1) AND (element.workcat_id IS NOT NULL));


--
-- Name: v_ui_workcat_x_feature_end; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_workcat_x_feature_end AS
 SELECT (row_number() OVER (ORDER BY v_arc.arc_id) + 1000000) AS rid,
    'ARC'::character varying AS feature_type,
    v_arc.arccat_id AS featurecat_id,
    v_arc.arc_id AS feature_id,
    v_arc.code,
    exploitation.name AS expl_name,
    v_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_arc
     JOIN exploitation ON ((exploitation.expl_id = v_arc.expl_id)))
  WHERE (v_arc.state = 0)
UNION
 SELECT (row_number() OVER (ORDER BY v_node.node_id) + 2000000) AS rid,
    'NODE'::character varying AS feature_type,
    v_node.nodecat_id AS featurecat_id,
    v_node.node_id AS feature_id,
    v_node.code,
    exploitation.name AS expl_name,
    v_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_node
     JOIN exploitation ON ((exploitation.expl_id = v_node.expl_id)))
  WHERE (v_node.state = 0)
UNION
 SELECT (row_number() OVER (ORDER BY v_connec.connec_id) + 3000000) AS rid,
    'CONNEC'::character varying AS feature_type,
    v_connec.connecat_id AS featurecat_id,
    v_connec.connec_id AS feature_id,
    v_connec.code,
    exploitation.name AS expl_name,
    v_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_connec
     JOIN exploitation ON ((exploitation.expl_id = v_connec.expl_id)))
  WHERE (v_connec.state = 0)
UNION
 SELECT (row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000) AS rid,
    'ELEMENT'::character varying AS feature_type,
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM (v_edit_element
     JOIN exploitation ON ((exploitation.expl_id = v_edit_element.expl_id)))
  WHERE (v_edit_element.state = 0);


--
-- Name: v_ui_workspace; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_ui_workspace AS
 SELECT cat_workspace.id,
    cat_workspace.name,
    cat_workspace.private,
    cat_workspace.descript,
    cat_workspace.config
   FROM cat_workspace
  WHERE ((cat_workspace.private IS FALSE) OR ((cat_workspace.private IS TRUE) AND (cat_workspace.cur_user = (CURRENT_USER)::text)));


--
-- Name: v_value_cat_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_value_cat_connec AS
 SELECT cat_connec.id,
    cat_connec.connectype_id AS connec_type,
    cat_feature_connec.type
   FROM (cat_connec
     JOIN cat_feature_connec ON (((cat_feature_connec.id)::text = (cat_connec.connectype_id)::text)));


--
-- Name: v_value_cat_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW v_value_cat_node AS
 SELECT cat_node.id,
    cat_node.nodetype_id,
    cat_feature_node.type
   FROM (cat_node
     JOIN cat_feature_node ON (((cat_feature_node.id)::text = (cat_node.nodetype_id)::text)));


--
-- Name: ve_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.arccat_id,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.cat_matcat_id,
    v_arc.cat_pnom,
    v_arc.cat_dnom,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.sector_name,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.minsector_id,
    v_arc.dma_id,
    v_arc.dma_name,
    v_arc.macrodma_id,
    v_arc.presszone_id,
    v_arc.presszone_name,
    v_arc.dqa_id,
    v_arc.dqa_name,
    v_arc.macrodqa_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.district_id,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.undelete,
    v_arc.label,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.num_value,
    v_arc.cat_arctype_id,
    v_arc.nodetype_1,
    v_arc.staticpress1,
    v_arc.nodetype_2,
    v_arc.staticpress2,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom,
    v_arc.depth,
    v_arc.adate,
    v_arc.adescript,
    v_arc.dma_style,
    v_arc.presszone_style,
    v_arc.workcat_id_plan,
    v_arc.asset_id,
    v_arc.pavcat_id,
    v_arc.om_state,
    v_arc.conserv_state,
    v_arc.flow_max,
    v_arc.flow_min,
    v_arc.flow_avg,
    v_arc.vel_max,
    v_arc.vel_min,
    v_arc.vel_avg,
    v_arc.parent_id,
    v_arc.expl_id2
   FROM v_arc;


--
-- Name: ve_config_addfields; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_config_addfields AS
 SELECT sys_addfields.param_name AS columnname,
    config_form_fields.datatype,
    config_form_fields.widgettype,
    config_form_fields.label,
    config_form_fields.hidden,
    config_form_fields.layoutname,
    config_form_fields.layoutorder AS layout_order,
    sys_addfields.orderby AS addfield_order,
    sys_addfields.active,
    config_form_fields.tooltip,
    config_form_fields.placeholder,
    config_form_fields.ismandatory,
    config_form_fields.isparent,
    config_form_fields.iseditable,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    config_form_fields.widgetfunction,
    config_form_fields.linkedobject,
    config_form_fields.stylesheet,
    config_form_fields.widgetcontrols,
        CASE
            WHEN (sys_addfields.cat_feature_id IS NOT NULL) THEN config_form_fields.formname
            ELSE NULL::character varying
        END AS formname,
    sys_addfields.id AS param_id,
    sys_addfields.cat_feature_id
   FROM ((sys_addfields
     LEFT JOIN cat_feature ON (((cat_feature.id)::text = (sys_addfields.cat_feature_id)::text)))
     LEFT JOIN config_form_fields ON (((config_form_fields.columnname)::text = (sys_addfields.param_name)::text)));


--
-- Name: ve_config_sysfields; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_config_sysfields AS
 SELECT row_number() OVER () AS rid,
    config_form_fields.formname,
    config_form_fields.formtype,
    config_form_fields.columnname,
    config_form_fields.label,
    config_form_fields.hidden,
    config_form_fields.layoutname,
    config_form_fields.layoutorder,
    config_form_fields.iseditable,
    config_form_fields.ismandatory,
    config_form_fields.datatype,
    config_form_fields.widgettype,
    config_form_fields.tooltip,
    config_form_fields.placeholder,
    (config_form_fields.stylesheet)::text AS stylesheet,
    config_form_fields.isparent,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    (config_form_fields.widgetcontrols)::text AS widgetcontrols,
    config_form_fields.widgetfunction,
    config_form_fields.linkedobject,
    cat_feature.id AS cat_feature_id
   FROM (config_form_fields
     LEFT JOIN cat_feature ON (((cat_feature.child_layer)::text = (config_form_fields.formname)::text)))
  WHERE (((config_form_fields.formtype)::text = 'form_feature'::text) AND ((config_form_fields.formname)::text <> 've_arc'::text) AND ((config_form_fields.formname)::text <> 've_node'::text) AND ((config_form_fields.formname)::text <> 've_connec'::text) AND ((config_form_fields.formname)::text <> 've_gully'::text));


--
-- Name: ve_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_connec AS
 SELECT v_connec.connec_id,
    v_connec.code,
    v_connec.elevation,
    v_connec.depth,
    v_connec.connec_type,
    v_connec.sys_type,
    v_connec.connecat_id,
    v_connec.expl_id,
    v_connec.macroexpl_id,
    v_connec.sector_id,
    v_connec.sector_name,
    v_connec.macrosector_id,
    v_connec.customer_code,
    v_connec.cat_matcat_id,
    v_connec.cat_pnom,
    v_connec.cat_dnom,
    v_connec.connec_length,
    v_connec.state,
    v_connec.state_type,
    v_connec.n_hydrometer,
    v_connec.arc_id,
    v_connec.annotation,
    v_connec.observ,
    v_connec.comment,
    v_connec.minsector_id,
    v_connec.dma_id,
    v_connec.dma_name,
    v_connec.macrodma_id,
    v_connec.presszone_id,
    v_connec.presszone_name,
    v_connec.staticpressure,
    v_connec.dqa_id,
    v_connec.dqa_name,
    v_connec.macrodqa_id,
    v_connec.soilcat_id,
    v_connec.function_type,
    v_connec.category_type,
    v_connec.fluid_type,
    v_connec.location_type,
    v_connec.workcat_id,
    v_connec.workcat_id_end,
    v_connec.buildercat_id,
    v_connec.builtdate,
    v_connec.enddate,
    v_connec.ownercat_id,
    v_connec.muni_id,
    v_connec.postcode,
    v_connec.district_id,
    v_connec.streetname,
    v_connec.postnumber,
    v_connec.postcomplement,
    v_connec.streetname2,
    v_connec.postnumber2,
    v_connec.postcomplement2,
    v_connec.descript,
    v_connec.svg,
    v_connec.rotation,
    v_connec.link,
    v_connec.verified,
    v_connec.undelete,
    v_connec.label,
    v_connec.label_x,
    v_connec.label_y,
    v_connec.label_rotation,
    v_connec.publish,
    v_connec.inventory,
    v_connec.num_value,
    v_connec.connectype_id,
    v_connec.pjoint_id,
    v_connec.pjoint_type,
    v_connec.tstamp,
    v_connec.insert_user,
    v_connec.lastupdate,
    v_connec.lastupdate_user,
    v_connec.the_geom,
    v_connec.adate,
    v_connec.adescript,
    v_connec.accessibility,
    v_connec.workcat_id_plan,
    v_connec.asset_id,
    v_connec.dma_style,
    v_connec.presszone_style,
    v_connec.epa_type,
    v_connec.priority,
    v_connec.valve_location,
    v_connec.valve_type,
    v_connec.shutoff_valve,
    v_connec.access_type,
    v_connec.placement_type,
    v_connec.press_max,
    v_connec.press_min,
    v_connec.press_avg,
    v_connec.demand,
    v_connec.om_state,
    v_connec.conserv_state,
    v_connec.crmzone_id,
    v_connec.crmzone_name,
    v_connec.expl_id2,
    v_connec.quality_max,
    v_connec.quality_min,
    v_connec.quality_avg
   FROM v_connec;


--
-- Name: ve_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_node AS
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.expl_id,
    v_node.macroexpl_id,
    v_node.sector_id,
    v_node.sector_name,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.minsector_id,
    v_node.dma_id,
    v_node.dma_name,
    v_node.macrodma_id,
    v_node.presszone_id,
    v_node.presszone_name,
    v_node.staticpressure,
    v_node.dqa_id,
    v_node.dqa_name,
    v_node.macrodqa_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.buildercat_id,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.undelete,
    v_node.label,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.hemisphere,
    v_node.num_value,
    v_node.nodetype_id,
    v_node.tstamp,
    v_node.insert_user,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.the_geom,
    v_node.adate,
    v_node.adescript,
    v_node.accessibility,
    v_node.dma_style,
    v_node.presszone_style,
    v_node.workcat_id_plan,
    v_node.asset_id,
    v_node.om_state,
    v_node.conserv_state,
    v_node.access_type,
    v_node.placement_type,
    v_node.demand_max,
    v_node.demand_min,
    v_node.demand_avg,
    v_node.press_max,
    v_node.press_min,
    v_node.press_avg,
    v_node.head_max,
    v_node.head_min,
    v_node.head_avg,
    v_node.quality_max,
    v_node.quality_min,
    v_node.quality_avg,
    v_node.expl_id2
   FROM v_node;


--
-- Name: ve_pol_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_connec AS
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom
   FROM ((connec
     JOIN v_state_connec USING (connec_id))
     JOIN polygon ON (((polygon.feature_id)::text = (connec.connec_id)::text)));


--
-- Name: ve_pol_element; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_element AS
 SELECT e.pol_id,
    e.element_id,
    polygon.the_geom
   FROM (v_edit_element e
     JOIN polygon USING (pol_id));


--
-- Name: ve_pol_fountain; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_fountain AS
 SELECT polygon.pol_id,
    polygon.feature_id AS connec_id,
    polygon.the_geom
   FROM (v_connec
     JOIN polygon ON (((polygon.feature_id)::text = (v_connec.connec_id)::text)))
  WHERE ((polygon.sys_type)::text = 'FOUNTAIN'::text);


--
-- Name: ve_pol_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_node AS
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom
   FROM (((node
     JOIN v_state_node USING (node_id))
     JOIN v_expl_node USING (node_id))
     JOIN polygon ON (((polygon.feature_id)::text = (node.node_id)::text)));


--
-- Name: ve_pol_register; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_register AS
 SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM (v_node
     JOIN polygon ON (((polygon.feature_id)::text = (v_node.node_id)::text)))
  WHERE ((polygon.sys_type)::text = 'REGISTER'::text);


--
-- Name: ve_pol_tank; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_pol_tank AS
 SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM (v_node
     JOIN polygon ON (((polygon.feature_id)::text = (v_node.node_id)::text)))
  WHERE ((polygon.sys_type)::text = 'TANK'::text);


--
-- Name: ve_visit_arc_singlevent; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_visit_arc_singlevent AS
 SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    ("left"((date_trunc('second'::text, om_visit.startdate))::text, 19))::timestamp without time zone AS startdate,
    ("left"((date_trunc('second'::text, om_visit.enddate))::text, 19))::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.id AS event_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM (((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_arc ON ((om_visit.id = om_visit_x_arc.visit_id)))
     JOIN config_visit_class ON ((config_visit_class.id = om_visit.class_id)))
  WHERE (config_visit_class.ismultievent = false);


--
-- Name: ve_visit_connec_singlevent; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_visit_connec_singlevent AS
 SELECT om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    ("left"((date_trunc('second'::text, om_visit.startdate))::text, 19))::timestamp without time zone AS startdate,
    ("left"((date_trunc('second'::text, om_visit.enddate))::text, 19))::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM (((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_connec ON ((om_visit.id = om_visit_x_connec.visit_id)))
     JOIN config_visit_class ON ((config_visit_class.id = om_visit.class_id)))
  WHERE (config_visit_class.ismultievent = false);


--
-- Name: ve_visit_node_singlevent; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW ve_visit_node_singlevent AS
 SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    ("left"((date_trunc('second'::text, om_visit.startdate))::text, 19))::timestamp without time zone AS startdate,
    ("left"((date_trunc('second'::text, om_visit.enddate))::text, 19))::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM (((om_visit
     JOIN om_visit_event ON ((om_visit.id = om_visit_event.visit_id)))
     JOIN om_visit_x_node ON ((om_visit.id = om_visit_x_node.visit_id)))
     JOIN config_visit_class ON ((config_visit_class.id = om_visit.class_id)))
  WHERE (config_visit_class.ismultievent = false);


--
-- Name: vi_backdrop; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_backdrop AS
 SELECT inp_backdrop.text
   FROM inp_backdrop;


--
-- Name: vi_controls; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_controls AS
 SELECT c.text
   FROM ( SELECT inp_controls.id,
            inp_controls.text
           FROM selector_sector,
            inp_controls
          WHERE ((selector_sector.sector_id = inp_controls.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (inp_controls.active IS NOT FALSE))
        UNION
         SELECT d.id,
            d.text
           FROM selector_sector s,
            v_edit_inp_dscenario_controls d
          WHERE ((s.sector_id = d.sector_id) AND (s.cur_user = ("current_user"())::text) AND (d.active IS NOT FALSE))
  ORDER BY 1) c
  ORDER BY c.id;


--
-- Name: vi_coordinates; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_coordinates AS
 SELECT rpt_inp_node.node_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    rpt_inp_node.the_geom
   FROM rpt_inp_node,
    selector_inp_result a
  WHERE (((a.result_id)::text = (rpt_inp_node.result_id)::text) AND (a.cur_user = ("current_user"())::text));


--
-- Name: vi_curves; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_curves AS
 SELECT
        CASE
            WHEN (a.x_value IS NULL) THEN (a.curve_type)::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    (a.x_value)::numeric(12,4) AS x_value,
    (a.y_value)::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( SELECT row_number() OVER (ORDER BY a_1.id) AS rid,
            a_1.id,
            a_1.curve_id,
            a_1.curve_type,
            a_1.x_value,
            a_1.y_value
           FROM ( SELECT DISTINCT ON (inp_curve_value.curve_id) ( SELECT min(sub.id) AS min
                           FROM inp_curve_value sub
                          WHERE ((sub.curve_id)::text = (inp_curve_value.curve_id)::text)) AS id,
                    inp_curve_value.curve_id,
                    concat(';', inp_curve.curve_type, ':', inp_curve.descript) AS curve_type,
                    NULL::numeric AS x_value,
                    NULL::numeric AS y_value
                   FROM (inp_curve
                     JOIN inp_curve_value ON (((inp_curve_value.curve_id)::text = (inp_curve.id)::text)))
                UNION
                 SELECT inp_curve_value.id,
                    inp_curve_value.curve_id,
                    inp_curve.curve_type,
                    inp_curve_value.x_value,
                    inp_curve_value.y_value
                   FROM (inp_curve_value
                     JOIN inp_curve ON (((inp_curve_value.curve_id)::text = (inp_curve.id)::text)))
          ORDER BY 1, 4 DESC) a_1) a
  WHERE ((a.curve_id)::text IN ( SELECT ((temp_node.addparam)::json ->> 'curve_id'::text)
           FROM temp_node
        UNION
         SELECT ((temp_arc.addparam)::json ->> 'curve_id'::text)
           FROM temp_arc))
  ORDER BY a.rid, NULL::text;


--
-- Name: vi_demands; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_demands AS
 SELECT temp_demand.feature_id,
    temp_demand.demand,
    temp_demand.pattern_id,
    concat(';', temp_demand.dscenario_id, ' ', temp_demand.source, ' ', temp_demand.demand_type) AS other
   FROM (temp_demand
     JOIN temp_node ON (((temp_demand.feature_id)::text = (temp_node.node_id)::text)))
  ORDER BY temp_demand.feature_id, (concat(';', temp_demand.dscenario_id, ' ', temp_demand.source, ' ', temp_demand.demand_type));


--
-- Name: vi_emitters; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_emitters AS
 SELECT inp_emitter.node_id,
    inp_emitter.coef
   FROM (inp_emitter
     JOIN temp_node t USING (node_id))
  WHERE (NOT ((t.node_id)::text IN ( SELECT anl_node.node_id
           FROM anl_node
          WHERE ((anl_node.fid = 232) AND ((anl_node.cur_user)::text = CURRENT_USER)))));


--
-- Name: vi_energy; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_energy AS
 SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
    inp_typevalue.idval,
    inp_pump.energyvalue
   FROM selector_inp_result,
    ((inp_pump
     JOIN rpt_inp_arc ON ((concat(inp_pump.node_id, '_n2a') = (rpt_inp_arc.arc_id)::text)))
     LEFT JOIN inp_typevalue ON ((((inp_pump.energyparam)::text = (inp_typevalue.id)::text) AND ((inp_typevalue.typevalue)::text = 'inp_value_param_energy'::text))))
  WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND (inp_pump.energyparam IS NOT NULL))
UNION
 SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
    inp_pump_additional.energyparam AS idval,
    inp_pump_additional.energyvalue
   FROM selector_inp_result,
    (inp_pump_additional
     JOIN rpt_inp_arc ON ((concat(inp_pump_additional.node_id, '_n2a') = (rpt_inp_arc.arc_id)::text)))
  WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND (inp_pump_additional.energyparam IS NOT NULL))
UNION
 SELECT inp_energy.descript AS pump_id,
    NULL::character varying AS idval,
    NULL::character varying AS energyvalue
   FROM inp_energy;


--
-- Name: vi_junctions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_junctions AS
 SELECT temp_node.node_id,
        CASE
            WHEN (temp_node.elev IS NOT NULL) THEN temp_node.elev
            ELSE temp_node.elevation
        END AS elevation,
    temp_node.demand,
    temp_node.pattern_id,
    concat(';', temp_node.sector_id, ' ', COALESCE(temp_node.presszone_id, '0'::text), ' ', COALESCE(temp_node.dma_id, 0), ' ', COALESCE(temp_node.dqa_id, 0), ' ', COALESCE(temp_node.minsector_id, 0), ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE ((temp_node.epa_type)::text <> ALL (ARRAY[('RESERVOIR'::character varying)::text, ('TANK'::character varying)::text]))
  ORDER BY temp_node.node_id;


--
-- Name: vi_labels; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_labels AS
 SELECT inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.node_id
   FROM inp_label;


--
-- Name: vi_mixing; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_mixing AS
 SELECT inp_mixing.node_id,
    inp_mixing.mix_type,
    inp_mixing.value
   FROM selector_inp_result,
    (inp_mixing
     JOIN rpt_inp_node ON (((inp_mixing.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_inp_node.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text));


--
-- Name: vi_options; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_options AS
 SELECT a.parameter,
    a.value
   FROM ( SELECT a_1.parameter,
            a_1.value,
                CASE
                    WHEN (a_1.parameter = 'UNITS'::text) THEN 1
                    ELSE 2
                END AS t
           FROM ( SELECT a_1_1.idval AS parameter,
                        CASE
                            WHEN ((a_1_1.idval = 'UNBALANCED'::text) AND (b.value = 'CONTINUE'::text)) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE (((config_param_user.parameter)::text = 'inp_options_unbalanced_n'::text) AND ((config_param_user.cur_user)::name = "current_user"()))))
                            WHEN ((a_1_1.idval = 'QUALITY'::text) AND (b.value = 'TRACE'::text)) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE (((config_param_user.parameter)::text = 'inp_options_node_id'::text) AND ((config_param_user.cur_user)::name = "current_user"()))))
                            WHEN ((a_1_1.idval = 'HYDRAULICS'::text) AND ((b.value = 'USE'::text) OR (b.value = 'SAVE'::text))) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE (((config_param_user.parameter)::text = 'inp_options_hydraulics_fname'::text) AND ((config_param_user.cur_user)::name = "current_user"()))))
                            WHEN ((a_1_1.idval = 'HYDRAULICS'::text) AND (b.value = 'NONE'::text)) THEN NULL::text
                            ELSE b.value
                        END AS value
                   FROM (sys_param_user a_1_1
                     JOIN config_param_user b ON ((a_1_1.id = (b.parameter)::text)))
                  WHERE ((a_1_1.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text])) AND (a_1_1.idval <> ALL (ARRAY['UNBALANCED_N'::text, 'NODE_ID'::text, 'HYDRAULICS_FNAME'::text])) AND ((b.cur_user)::name = "current_user"()) AND (b.value IS NOT NULL) AND (a_1_1.idval <> 'VALVE_MODE_MINCUT_RESULT'::text) AND ((b.parameter)::text <> 'PATTERN'::text) AND (b.value <> 'NULLVALUE'::text))) a_1
          WHERE ((a_1.parameter <> 'HYDRAULICS'::text) OR ((a_1.parameter = 'HYDRAULICS'::text) AND (a_1.value IS NOT NULL)))) a
  ORDER BY a.t;


--
-- Name: vi_parent_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_arc AS
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.arccat_id,
    v_arc.arc_type,
    v_arc.sys_type,
    v_arc.cat_matcat_id,
    v_arc.cat_pnom,
    v_arc.cat_dnom,
    v_arc.epa_type,
    v_arc.expl_id,
    v_arc.macroexpl_id,
    v_arc.sector_id,
    v_arc.sector_name,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.minsector_id,
    v_arc.dma_id,
    v_arc.dma_name,
    v_arc.macrodma_id,
    v_arc.presszone_id,
    v_arc.presszone_name,
    v_arc.dqa_id,
    v_arc.dqa_name,
    v_arc.macrodqa_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.district_id,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.undelete,
    v_arc.label,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.num_value,
    v_arc.cat_arctype_id,
    v_arc.nodetype_1,
    v_arc.staticpress1,
    v_arc.nodetype_2,
    v_arc.staticpress2,
    v_arc.tstamp,
    v_arc.insert_user,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.the_geom
   FROM v_arc,
    selector_sector
  WHERE ((v_arc.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: vi_parent_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_connec AS
 SELECT ve_connec.connec_id,
    ve_connec.code,
    ve_connec.elevation,
    ve_connec.depth,
    ve_connec.connec_type,
    ve_connec.sys_type,
    ve_connec.connecat_id,
    ve_connec.expl_id,
    ve_connec.macroexpl_id,
    ve_connec.sector_id,
    ve_connec.sector_name,
    ve_connec.macrosector_id,
    ve_connec.customer_code,
    ve_connec.cat_matcat_id,
    ve_connec.cat_pnom,
    ve_connec.cat_dnom,
    ve_connec.connec_length,
    ve_connec.state,
    ve_connec.state_type,
    ve_connec.n_hydrometer,
    ve_connec.arc_id,
    ve_connec.annotation,
    ve_connec.observ,
    ve_connec.comment,
    ve_connec.minsector_id,
    ve_connec.dma_id,
    ve_connec.dma_name,
    ve_connec.macrodma_id,
    ve_connec.presszone_id,
    ve_connec.presszone_name,
    ve_connec.staticpressure,
    ve_connec.dqa_id,
    ve_connec.dqa_name,
    ve_connec.macrodqa_id,
    ve_connec.soilcat_id,
    ve_connec.function_type,
    ve_connec.category_type,
    ve_connec.fluid_type,
    ve_connec.location_type,
    ve_connec.workcat_id,
    ve_connec.workcat_id_end,
    ve_connec.buildercat_id,
    ve_connec.builtdate,
    ve_connec.enddate,
    ve_connec.ownercat_id,
    ve_connec.muni_id,
    ve_connec.postcode,
    ve_connec.district_id,
    ve_connec.streetname,
    ve_connec.postnumber,
    ve_connec.postcomplement,
    ve_connec.streetname2,
    ve_connec.postnumber2,
    ve_connec.postcomplement2,
    ve_connec.descript,
    ve_connec.svg,
    ve_connec.rotation,
    ve_connec.link,
    ve_connec.verified,
    ve_connec.undelete,
    ve_connec.label,
    ve_connec.label_x,
    ve_connec.label_y,
    ve_connec.label_rotation,
    ve_connec.publish,
    ve_connec.inventory,
    ve_connec.num_value,
    ve_connec.connectype_id,
    ve_connec.pjoint_id,
    ve_connec.pjoint_type,
    ve_connec.tstamp,
    ve_connec.insert_user,
    ve_connec.lastupdate,
    ve_connec.lastupdate_user,
    ve_connec.the_geom
   FROM ve_connec,
    selector_sector
  WHERE ((ve_connec.sector_id = selector_sector.sector_id) AND (selector_sector.cur_user = ("current_user"())::text));


--
-- Name: vi_parent_dma; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_dma AS
 SELECT DISTINCT ON (dma.dma_id) dma.dma_id,
    dma.name,
    dma.expl_id,
    dma.macrodma_id,
    dma.descript,
    dma.undelete,
    dma.minc,
    dma.maxc,
    dma.effc,
    dma.pattern_id,
    dma.link,
    dma.graphconfig,
    dma.the_geom
   FROM (dma
     JOIN vi_parent_arc USING (dma_id));


--
-- Name: vi_parent_hydrometer; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_parent_hydrometer AS
 SELECT v_rtc_hydrometer.hydrometer_id,
    v_rtc_hydrometer.hydrometer_customer_code,
    v_rtc_hydrometer.connec_id,
    v_rtc_hydrometer.connec_customer_code,
    v_rtc_hydrometer.state,
    v_rtc_hydrometer.muni_name,
    v_rtc_hydrometer.expl_id,
    v_rtc_hydrometer.expl_name,
    v_rtc_hydrometer.plot_code,
    v_rtc_hydrometer.priority_id,
    v_rtc_hydrometer.catalog_id,
    v_rtc_hydrometer.category_id,
    v_rtc_hydrometer.hydro_number,
    v_rtc_hydrometer.hydro_man_date,
    v_rtc_hydrometer.crm_number,
    v_rtc_hydrometer.customer_name,
    v_rtc_hydrometer.address1,
    v_rtc_hydrometer.address2,
    v_rtc_hydrometer.address3,
    v_rtc_hydrometer.address2_1,
    v_rtc_hydrometer.address2_2,
    v_rtc_hydrometer.address2_3,
    v_rtc_hydrometer.m3_volume,
    v_rtc_hydrometer.start_date,
    v_rtc_hydrometer.end_date,
    v_rtc_hydrometer.update_date,
    v_rtc_hydrometer.hydrometer_link
   FROM (v_rtc_hydrometer
     JOIN ve_connec USING (connec_id));


--
-- Name: vi_patterns; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_patterns AS
 SELECT a.pattern_id,
    a.factor_1,
    a.factor_2,
    a.factor_3,
    a.factor_4,
    a.factor_5,
    a.factor_6,
    a.factor_7,
    a.factor_8,
    a.factor_9,
    a.factor_10,
    a.factor_11,
    a.factor_12,
    a.factor_13,
    a.factor_14,
    a.factor_15,
    a.factor_16,
    a.factor_17,
    a.factor_18
   FROM rpt_inp_pattern_value a,
    selector_inp_result b
  WHERE (((a.result_id)::text = (b.result_id)::text) AND (b.cur_user = ("current_user"())::text))
  ORDER BY a.id;


--
-- Name: vi_pipes; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pipes AS
 SELECT temp_arc.arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
    temp_arc.length,
    temp_arc.diameter,
    temp_arc.roughness,
    temp_arc.minorloss,
    (temp_arc.status)::character varying(30) AS status,
    concat(';', temp_arc.sector_id, ' ', COALESCE(temp_arc.presszone_id, '0'::text), ' ', COALESCE(temp_arc.dma_id, 0), ' ', COALESCE(temp_arc.dqa_id, 0), ' ', COALESCE(temp_arc.minsector_id, 0), ' ', temp_arc.arccat_id) AS other
   FROM temp_arc
  WHERE ((temp_arc.epa_type)::text = ANY (ARRAY[('PIPE'::character varying)::text, ('SHORTPIPE'::character varying)::text, ('NODE2NODE'::character varying)::text]));


--
-- Name: vi_pjoint; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pjoint AS
 SELECT v_edit_inp_connec.pjoint_id,
    v_edit_inp_connec.pjoint_type,
    sum(v_edit_inp_connec.demand) AS sum
   FROM v_edit_inp_connec
  WHERE (v_edit_inp_connec.pjoint_id IS NOT NULL)
  GROUP BY v_edit_inp_connec.pjoint_id, v_edit_inp_connec.pjoint_type;


--
-- Name: vi_pjointpattern; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pjointpattern AS
 SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
    a.idrow,
    a.pattern_id,
    (sum(a.factor_1))::numeric(10,8) AS factor_1,
    (sum(a.factor_2))::numeric(10,8) AS factor_2,
    (sum(a.factor_3))::numeric(10,8) AS factor_3,
    (sum(a.factor_4))::numeric(10,8) AS factor_4,
    (sum(a.factor_5))::numeric(10,8) AS factor_5,
    (sum(a.factor_6))::numeric(10,8) AS factor_6,
    (sum(a.factor_7))::numeric(10,8) AS factor_7,
    (sum(a.factor_8))::numeric(10,8) AS factor_8,
    (sum(a.factor_9))::numeric(10,8) AS factor_9,
    (sum(a.factor_10))::numeric(10,8) AS factor_10,
    (sum(a.factor_11))::numeric(10,8) AS factor_11,
    (sum(a.factor_12))::numeric(10,8) AS factor_12,
    (sum(a.factor_13))::numeric(10,8) AS factor_13,
    (sum(a.factor_14))::numeric(10,8) AS factor_14,
    (sum(a.factor_15))::numeric(10,8) AS factor_15,
    (sum(a.factor_16))::numeric(10,8) AS factor_16,
    (sum(a.factor_17))::numeric(10,8) AS factor_17,
    (sum(a.factor_18))::numeric(10,8) AS factor_18
   FROM ( SELECT
                CASE
                    WHEN (b.id = ( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 1
                    WHEN (b.id = ( SELECT (min(sub.id) + 1)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 2
                    WHEN (b.id = ( SELECT (min(sub.id) + 2)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 3
                    WHEN (b.id = ( SELECT (min(sub.id) + 3)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 4
                    WHEN (b.id = ( SELECT (min(sub.id) + 4)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 5
                    WHEN (b.id = ( SELECT (min(sub.id) + 5)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 6
                    WHEN (b.id = ( SELECT (min(sub.id) + 6)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 7
                    WHEN (b.id = ( SELECT (min(sub.id) + 7)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 8
                    WHEN (b.id = ( SELECT (min(sub.id) + 8)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 9
                    WHEN (b.id = ( SELECT (min(sub.id) + 9)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 10
                    WHEN (b.id = ( SELECT (min(sub.id) + 10)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 11
                    WHEN (b.id = ( SELECT (min(sub.id) + 11)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 12
                    WHEN (b.id = ( SELECT (min(sub.id) + 12)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 13
                    WHEN (b.id = ( SELECT (min(sub.id) + 13)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 14
                    WHEN (b.id = ( SELECT (min(sub.id) + 14)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 15
                    WHEN (b.id = ( SELECT (min(sub.id) + 15)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 16
                    WHEN (b.id = ( SELECT (min(sub.id) + 16)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 17
                    WHEN (b.id = ( SELECT (min(sub.id) + 17)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 18
                    WHEN (b.id = ( SELECT (min(sub.id) + 18)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 19
                    WHEN (b.id = ( SELECT (min(sub.id) + 19)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 20
                    WHEN (b.id = ( SELECT (min(sub.id) + 20)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 21
                    WHEN (b.id = ( SELECT (min(sub.id) + 21)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 22
                    WHEN (b.id = ( SELECT (min(sub.id) + 22)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 23
                    WHEN (b.id = ( SELECT (min(sub.id) + 23)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 24
                    WHEN (b.id = ( SELECT (min(sub.id) + 24)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 25
                    WHEN (b.id = ( SELECT (min(sub.id) + 25)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 26
                    WHEN (b.id = ( SELECT (min(sub.id) + 26)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 27
                    WHEN (b.id = ( SELECT (min(sub.id) + 27)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 28
                    WHEN (b.id = ( SELECT (min(sub.id) + 28)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 29
                    WHEN (b.id = ( SELECT (min(sub.id) + 29)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 30
                    ELSE NULL::integer
                END AS idrow,
            c.pjoint_id AS pattern_id,
            sum(((c.demand)::double precision * (b.factor_1)::double precision)) AS factor_1,
            sum(((c.demand)::double precision * (b.factor_2)::double precision)) AS factor_2,
            sum(((c.demand)::double precision * (b.factor_3)::double precision)) AS factor_3,
            sum(((c.demand)::double precision * (b.factor_4)::double precision)) AS factor_4,
            sum(((c.demand)::double precision * (b.factor_5)::double precision)) AS factor_5,
            sum(((c.demand)::double precision * (b.factor_6)::double precision)) AS factor_6,
            sum(((c.demand)::double precision * (b.factor_7)::double precision)) AS factor_7,
            sum(((c.demand)::double precision * (b.factor_8)::double precision)) AS factor_8,
            sum(((c.demand)::double precision * (b.factor_9)::double precision)) AS factor_9,
            sum(((c.demand)::double precision * (b.factor_10)::double precision)) AS factor_10,
            sum(((c.demand)::double precision * (b.factor_11)::double precision)) AS factor_11,
            sum(((c.demand)::double precision * (b.factor_12)::double precision)) AS factor_12,
            sum(((c.demand)::double precision * (b.factor_13)::double precision)) AS factor_13,
            sum(((c.demand)::double precision * (b.factor_14)::double precision)) AS factor_14,
            sum(((c.demand)::double precision * (b.factor_15)::double precision)) AS factor_15,
            sum(((c.demand)::double precision * (b.factor_16)::double precision)) AS factor_16,
            sum(((c.demand)::double precision * (b.factor_17)::double precision)) AS factor_17,
            sum(((c.demand)::double precision * (b.factor_18)::double precision)) AS factor_18
           FROM (( SELECT inp_connec.connec_id,
                    inp_connec.demand,
                    inp_connec.pattern_id,
                    connec.pjoint_id
                   FROM (inp_connec
                     JOIN connec USING (connec_id))) c
             JOIN inp_pattern_value b USING (pattern_id))
          GROUP BY c.pjoint_id,
                CASE
                    WHEN (b.id = ( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 1
                    WHEN (b.id = ( SELECT (min(sub.id) + 1)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 2
                    WHEN (b.id = ( SELECT (min(sub.id) + 2)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 3
                    WHEN (b.id = ( SELECT (min(sub.id) + 3)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 4
                    WHEN (b.id = ( SELECT (min(sub.id) + 4)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 5
                    WHEN (b.id = ( SELECT (min(sub.id) + 5)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 6
                    WHEN (b.id = ( SELECT (min(sub.id) + 6)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 7
                    WHEN (b.id = ( SELECT (min(sub.id) + 7)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 8
                    WHEN (b.id = ( SELECT (min(sub.id) + 8)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 9
                    WHEN (b.id = ( SELECT (min(sub.id) + 9)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 10
                    WHEN (b.id = ( SELECT (min(sub.id) + 10)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 11
                    WHEN (b.id = ( SELECT (min(sub.id) + 11)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 12
                    WHEN (b.id = ( SELECT (min(sub.id) + 12)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 13
                    WHEN (b.id = ( SELECT (min(sub.id) + 13)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 14
                    WHEN (b.id = ( SELECT (min(sub.id) + 14)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 15
                    WHEN (b.id = ( SELECT (min(sub.id) + 15)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 16
                    WHEN (b.id = ( SELECT (min(sub.id) + 16)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 17
                    WHEN (b.id = ( SELECT (min(sub.id) + 17)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 18
                    WHEN (b.id = ( SELECT (min(sub.id) + 18)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 19
                    WHEN (b.id = ( SELECT (min(sub.id) + 19)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 20
                    WHEN (b.id = ( SELECT (min(sub.id) + 20)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 21
                    WHEN (b.id = ( SELECT (min(sub.id) + 21)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 22
                    WHEN (b.id = ( SELECT (min(sub.id) + 22)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 23
                    WHEN (b.id = ( SELECT (min(sub.id) + 23)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 24
                    WHEN (b.id = ( SELECT (min(sub.id) + 24)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 25
                    WHEN (b.id = ( SELECT (min(sub.id) + 25)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 26
                    WHEN (b.id = ( SELECT (min(sub.id) + 26)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 27
                    WHEN (b.id = ( SELECT (min(sub.id) + 27)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 28
                    WHEN (b.id = ( SELECT (min(sub.id) + 28)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 29
                    WHEN (b.id = ( SELECT (min(sub.id) + 29)
                       FROM inp_pattern_value sub
                      WHERE ((sub.pattern_id)::text = (b.pattern_id)::text))) THEN 30
                    ELSE NULL::integer
                END) a
  GROUP BY a.idrow, a.pattern_id;


--
-- Name: vi_valves; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_valves AS
 SELECT DISTINCT ON (a.arc_id) a.arc_id,
    a.node_1,
    a.node_2,
    a.diameter,
    a.valv_type,
    a.setting,
    a.minorloss,
    concat(';', a.sector_id, ' ', COALESCE(a.presszone_id, '0'::text), ' ', COALESCE(a.dma_id, 0), ' ', COALESCE(a.dqa_id, 0), ' ', COALESCE(a.minsector_id, 0), ' ', a.arccat_id) AS other
   FROM ( SELECT (temp_arc.arc_id)::text AS arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            (((temp_arc.addparam)::json ->> 'valv_type'::text))::character varying(18) AS valv_type,
            ((temp_arc.addparam)::json ->> 'pressure'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM temp_arc
          WHERE ((((temp_arc.addparam)::json ->> 'valv_type'::text) = 'PRV'::text) OR (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'PSV'::text) OR (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'PBV'::text))
        UNION
         SELECT temp_arc.arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            ((temp_arc.addparam)::json ->> 'valv_type'::text) AS valv_type,
            ((temp_arc.addparam)::json ->> 'flow'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM temp_arc
          WHERE (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'FCV'::text)
        UNION
         SELECT temp_arc.arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            ((temp_arc.addparam)::json ->> 'valv_type'::text) AS valv_type,
            ((temp_arc.addparam)::json ->> 'coef_loss'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM temp_arc
          WHERE (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'TCV'::text)
        UNION
         SELECT temp_arc.arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            ((temp_arc.addparam)::json ->> 'valv_type'::text) AS valv_type,
            ((temp_arc.addparam)::json ->> 'curve_id'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM temp_arc
          WHERE (((temp_arc.addparam)::json ->> 'valv_type'::text) = 'GPV'::text)
        UNION
         SELECT temp_arc.arc_id,
            temp_arc.node_1,
            temp_arc.node_2,
            temp_arc.diameter,
            'PRV'::character varying(18) AS valv_type,
            ((temp_arc.addparam)::json ->> 'pressure'::text) AS setting,
            temp_arc.minorloss,
            temp_arc.sector_id,
            temp_arc.dma_id,
            temp_arc.presszone_id,
            temp_arc.dqa_id,
            temp_arc.minsector_id,
            temp_arc.arccat_id
           FROM (temp_arc
             JOIN inp_pump ON (((temp_arc.arc_id)::text = concat(inp_pump.node_id, '_n2a_4'))))) a;


--
-- Name: vi_pumps; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_pumps AS
 SELECT temp_arc.arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
        CASE
            WHEN (((temp_arc.addparam)::json ->> 'power'::text) <> ''::text) THEN (('POWER'::text || ' '::text) || ((temp_arc.addparam)::json ->> 'power'::text))
            ELSE NULL::text
        END AS power,
        CASE
            WHEN (((temp_arc.addparam)::json ->> 'curve_id'::text) <> ''::text) THEN (('HEAD'::text || ' '::text) || ((temp_arc.addparam)::json ->> 'curve_id'::text))
            ELSE NULL::text
        END AS head,
        CASE
            WHEN (((temp_arc.addparam)::json ->> 'speed'::text) <> ''::text) THEN (('SPEED'::text || ' '::text) || ((temp_arc.addparam)::json ->> 'speed'::text))
            ELSE NULL::text
        END AS speed,
        CASE
            WHEN (((temp_arc.addparam)::json ->> 'pattern'::text) <> ''::text) THEN (('PATTERN'::text || ' '::text) || ((temp_arc.addparam)::json ->> 'pattern'::text))
            ELSE NULL::text
        END AS pattern,
    concat(';', temp_arc.sector_id, ' ', COALESCE(temp_arc.presszone_id, '0'::text), ' ', COALESCE(temp_arc.dma_id, 0), ' ', COALESCE(temp_arc.dqa_id, 0), ' ', COALESCE(temp_arc.minsector_id, 0), ' ', temp_arc.arccat_id) AS other
   FROM temp_arc
  WHERE (((temp_arc.epa_type)::text = 'PUMP'::text) AND (NOT ((temp_arc.arc_id)::text IN ( SELECT vi_valves.arc_id
           FROM vi_valves))))
  ORDER BY temp_arc.arc_id;


--
-- Name: vi_quality; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_quality AS
 SELECT inp_quality.node_id,
    inp_quality.initqual
   FROM inp_quality
  ORDER BY inp_quality.node_id;


--
-- Name: vi_reactions; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_reactions AS
 SELECT inp_typevalue.idval,
    inp_pipe.arc_id,
    inp_pipe.reactionvalue
   FROM selector_inp_result,
    ((inp_pipe
     JOIN rpt_inp_arc ON (((inp_pipe.arc_id)::text = (rpt_inp_arc.arc_id)::text)))
     LEFT JOIN inp_typevalue ON (((upper((inp_pipe.reactionparam)::text) = (inp_typevalue.id)::text) AND ((inp_typevalue.typevalue)::text = 'inp_value_reactions'::text))))
  WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND (inp_typevalue.idval IS NOT NULL))
UNION
 SELECT upper(inp_reactions.descript) AS idval,
    NULL::character varying AS arc_id,
    NULL::character varying AS reactionvalue
   FROM inp_reactions
  ORDER BY 1;


--
-- Name: vi_report; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_report AS
 SELECT a.idval AS parameter,
    b.value
   FROM (sys_param_user a
     JOIN config_param_user b ON ((a.id = (b.parameter)::text)))
  WHERE ((a.layoutname = ANY (ARRAY['lyt_reports_1'::text, 'lyt_reports_2'::text])) AND ((b.cur_user)::name = "current_user"()) AND (b.value IS NOT NULL));


--
-- Name: vi_reservoirs; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_reservoirs AS
 SELECT temp_node.node_id,
        CASE
            WHEN (temp_node.elev IS NOT NULL) THEN temp_node.elev
            ELSE temp_node.elevation
        END AS head,
    temp_node.pattern_id,
    concat(';', temp_node.sector_id, ' ', temp_node.dma_id, ' ', temp_node.presszone_id, ' ', temp_node.dqa_id, ' ', temp_node.minsector_id, ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE ((temp_node.epa_type)::text = 'RESERVOIR'::text)
  ORDER BY temp_node.node_id;


--
-- Name: vi_rules; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_rules AS
 SELECT c.text
   FROM ( SELECT inp_rules.id,
            inp_rules.text
           FROM selector_sector,
            inp_rules
          WHERE ((selector_sector.sector_id = inp_rules.sector_id) AND (selector_sector.cur_user = ("current_user"())::text) AND (inp_rules.active IS NOT FALSE))
        UNION
         SELECT d.id,
            d.text
           FROM selector_sector s,
            v_edit_inp_dscenario_rules d
          WHERE ((s.sector_id = d.sector_id) AND (s.cur_user = ("current_user"())::text) AND (d.active IS NOT FALSE))
  ORDER BY 1) c
  ORDER BY c.id;


--
-- Name: vi_sources; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_sources AS
 SELECT inp_source.node_id,
    inp_source.sourc_type,
    inp_source.quality,
    inp_source.pattern_id
   FROM selector_inp_result,
    (inp_source
     JOIN rpt_inp_node ON (((inp_source.node_id)::text = (rpt_inp_node.node_id)::text)))
  WHERE (((rpt_inp_node.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text));


--
-- Name: vi_status; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_status AS
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE ((((rpt_inp_arc.status)::text = 'CLOSED'::text) OR ((rpt_inp_arc.status)::text = 'OPEN'::text)) AND ((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.epa_type)::text = 'VALVE'::text))
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (((rpt_inp_arc.status)::text = 'CLOSED'::text) AND ((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.epa_type)::text = 'PUMP'::text))
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (((rpt_inp_arc.status)::text = 'CLOSED'::text) AND ((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text) AND ((rpt_inp_arc.epa_type)::text = 'PUMP'::text));


--
-- Name: vi_tags; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_tags AS
 SELECT inp_tags.feature_type,
    inp_tags.feature_id,
    inp_tags.tag
   FROM inp_tags
  ORDER BY inp_tags.feature_type;


--
-- Name: vi_tanks; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_tanks AS
 SELECT temp_node.node_id,
        CASE
            WHEN (temp_node.elev IS NOT NULL) THEN temp_node.elev
            ELSE temp_node.elevation
        END AS elevation,
    (((temp_node.addparam)::json ->> 'initlevel'::text))::numeric AS initlevel,
    (((temp_node.addparam)::json ->> 'minlevel'::text))::numeric AS minlevel,
    (((temp_node.addparam)::json ->> 'maxlevel'::text))::numeric AS maxlevel,
    (((temp_node.addparam)::json ->> 'diameter'::text))::numeric AS diameter,
    (((temp_node.addparam)::json ->> 'minvol'::text))::numeric AS minvol,
        CASE
            WHEN (((temp_node.addparam)::json ->> 'curve_id'::text) IS NULL) THEN '*'::text
            ELSE ((temp_node.addparam)::json ->> 'curve_id'::text)
        END AS curve_id,
    ((temp_node.addparam)::json ->> 'overflow'::text) AS overflow,
    concat(';', temp_node.sector_id, ' ', temp_node.dma_id, ' ', temp_node.presszone_id, ' ', temp_node.dqa_id, ' ', temp_node.minsector_id, ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE ((temp_node.epa_type)::text = 'TANK'::text)
  ORDER BY temp_node.node_id;


--
-- Name: vi_times; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_times AS
 SELECT a.idval AS parameter,
    b.value
   FROM (sys_param_user a
     JOIN config_param_user b ON ((a.id = (b.parameter)::text)))
  WHERE ((a.layoutname = ANY (ARRAY['lyt_date_1'::text, 'lyt_date_2'::text])) AND ((b.cur_user)::name = "current_user"()) AND (b.value IS NOT NULL));


--
-- Name: vi_title; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_title AS
 SELECT inp_project_id.title,
    inp_project_id.date
   FROM inp_project_id
  ORDER BY inp_project_id.title;


--
-- Name: vi_vertices; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vi_vertices AS
 SELECT arc.arc_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    arc.point AS the_geom
   FROM ( SELECT (public.st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
            public.st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            public.st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.arc_id
           FROM selector_inp_result,
            rpt_inp_arc
          WHERE (((rpt_inp_arc.result_id)::text = (selector_inp_result.result_id)::text) AND (selector_inp_result.cur_user = ("current_user"())::text))) arc
  WHERE (((arc.point OPERATOR(public.<) arc.startpoint) OR (arc.point OPERATOR(public.>) arc.startpoint)) AND ((arc.point OPERATOR(public.<) arc.endpoint) OR (arc.point OPERATOR(public.>) arc.endpoint)));


--
-- Name: vp_basic_arc; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_arc AS
 SELECT arc.arc_id AS nid,
    cat_arc.arctype_id AS custom_type
   FROM (arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)));


--
-- Name: vp_basic_connec; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_connec AS
 SELECT connec.connec_id AS nid,
    cat_connec.connectype_id AS custom_type
   FROM (connec
     JOIN cat_connec ON (((cat_connec.id)::text = (connec.connecat_id)::text)));


--
-- Name: vp_basic_node; Type: VIEW; Schema: Schema; Owner: -
--

CREATE VIEW vp_basic_node AS
 SELECT node.node_id AS nid,
    cat_node.nodetype_id AS custom_type
   FROM (node
     JOIN cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)));

