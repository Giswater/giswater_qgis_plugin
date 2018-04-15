--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

-- Started on 2018-04-13 02:57:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 4802 (class 1259 OID 3416244)
-- Name: config_web_class_form; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_class_form (
    class_id text NOT NULL,
    formid text,
    formname text
);


ALTER TABLE SCHEMA_NAME.config_web_class_form OWNER TO gisadmin;

--
-- TOC entry 4804 (class 1259 OID 3416256)
-- Name: config_web_class_tab; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_class_tab (
    id integer NOT NULL,
    class_id character varying(50),
    formtab text
);


ALTER TABLE SCHEMA_NAME.config_web_class_tab OWNER TO gisadmin;

--
-- TOC entry 4792 (class 1259 OID 3416192)
-- Name: config_web_fields; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_fields (
    id integer NOT NULL,
    table_id character varying(50),
    name character varying(30),
    is_mandatory boolean,
    "dataType" text,
    field_length integer,
    num_decimals integer,
    placeholder text,
    label text,
    type text,
    dv_table text,
    dv_id_column text,
    dv_name_column text,
    sql_text text,
    is_enabled boolean,
    orderby integer
);


ALTER TABLE SCHEMA_NAME.config_web_fields OWNER TO gisadmin;

--
-- TOC entry 4793 (class 1259 OID 3416198)
-- Name: config_web_fields_cat_datatype; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_fields_cat_datatype (
    id text NOT NULL
);


ALTER TABLE SCHEMA_NAME.config_web_fields_cat_datatype OWNER TO gisadmin;

--
-- TOC entry 4794 (class 1259 OID 3416204)
-- Name: config_web_fields_cat_type; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_fields_cat_type (
    id text NOT NULL
);


ALTER TABLE SCHEMA_NAME.config_web_fields_cat_type OWNER TO gisadmin;

--
-- TOC entry 4795 (class 1259 OID 3416210)
-- Name: config_web_fields_id_seq; Type: SEQUENCE; Schema: clav; Owner: gisadmin
--

CREATE SEQUENCE SCHEMA_NAME.config_web_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE SCHEMA_NAME.config_web_fields_id_seq OWNER TO gisadmin;

--
-- TOC entry 20537 (class 0 OID 0)
-- Dependencies: 4795
-- Name: config_web_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: clav; Owner: gisadmin
--

ALTER SEQUENCE SCHEMA_NAME.config_web_fields_id_seq OWNED BY SCHEMA_NAME.config_web_fields.id;


--
-- TOC entry 4796 (class 1259 OID 3416212)
-- Name: config_web_forms; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_forms (
    id integer NOT NULL,
    table_id character varying(50),
    query_text text,
    device integer
);


ALTER TABLE SCHEMA_NAME.config_web_forms OWNER TO gisadmin;

--
-- TOC entry 4797 (class 1259 OID 3416218)
-- Name: config_web_forms_id_seq; Type: SEQUENCE; Schema: clav; Owner: gisadmin
--

CREATE SEQUENCE SCHEMA_NAME.config_web_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE SCHEMA_NAME.config_web_forms_id_seq OWNER TO gisadmin;

--
-- TOC entry 20538 (class 0 OID 0)
-- Dependencies: 4797
-- Name: config_web_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: clav; Owner: gisadmin
--

ALTER SEQUENCE SCHEMA_NAME.config_web_forms_id_seq OWNED BY SCHEMA_NAME.config_web_forms.id;


--
-- TOC entry 4799 (class 1259 OID 3416226)
-- Name: config_web_layer_cat_form; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_layer_cat_form (
    id text NOT NULL,
    name text
);


ALTER TABLE SCHEMA_NAME.config_web_layer_cat_form OWNER TO gisadmin;

--
-- TOC entry 4800 (class 1259 OID 3416232)
-- Name: config_web_layer_cat_formtab; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_layer_cat_formtab (
    id text NOT NULL
);


ALTER TABLE SCHEMA_NAME.config_web_layer_cat_formtab OWNER TO gisadmin;

--
-- TOC entry 4801 (class 1259 OID 3416238)
-- Name: config_web_layer_child; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_layer_child (
    featurecat_id character varying(30) NOT NULL,
    table_parent text,
    table_child text
);


ALTER TABLE SCHEMA_NAME.config_web_layer_child OWNER TO gisadmin;

--
-- TOC entry 4798 (class 1259 OID 3416220)
-- Name: config_web_layer_class; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_layer_class (
    layer_id text NOT NULL,
    class_id text NOT NULL,
    orderby integer
);


ALTER TABLE SCHEMA_NAME.config_web_layer_class OWNER TO gisadmin;

--
-- TOC entry 4803 (class 1259 OID 3416250)
-- Name: config_web_layer_parent; Type: TABLE; Schema: clav; Owner: gisadmin
--

CREATE TABLE SCHEMA_NAME.config_web_layer_parent (
    layer_id character varying(30) NOT NULL,
    parent_id text
);


ALTER TABLE SCHEMA_NAME.config_web_layer_parent OWNER TO gisadmin;

--
-- TOC entry 4805 (class 1259 OID 3416262)
-- Name: config_web_layer_tab_id_seq; Type: SEQUENCE; Schema: clav; Owner: gisadmin
--

CREATE SEQUENCE SCHEMA_NAME.config_web_layer_tab_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE SCHEMA_NAME.config_web_layer_tab_id_seq OWNER TO gisadmin;

--
-- TOC entry 20539 (class 0 OID 0)
-- Dependencies: 4805
-- Name: config_web_layer_tab_id_seq; Type: SEQUENCE OWNED BY; Schema: clav; Owner: gisadmin
--

ALTER SEQUENCE SCHEMA_NAME.config_web_layer_tab_id_seq OWNED BY SCHEMA_NAME.config_web_class_tab.id;


--
-- TOC entry 18618 (class 2604 OID 3416995)
-- Name: id; Type: DEFAULT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_class_tab ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.config_web_layer_tab_id_seq'::regclass);


--
-- TOC entry 18616 (class 2604 OID 3416993)
-- Name: id; Type: DEFAULT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_fields ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.config_web_fields_id_seq'::regclass);


--
-- TOC entry 18617 (class 2604 OID 3416994)
-- Name: id; Type: DEFAULT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_forms ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.config_web_forms_id_seq'::regclass);


--
-- TOC entry 20528 (class 0 OID 3416244)
-- Dependencies: 4802
-- Data for Name: config_web_class_form; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_class_form VALUES ('arc', 'F13', 'INFO_UTILS_ARC');
INSERT INTO SCHEMA_NAME.config_web_class_form VALUES ('node', 'F11', 'INFO_UD_NODE');
INSERT INTO SCHEMA_NAME.config_web_class_form VALUES ('workcat', 'F14', 'INFO_UTILS_CONNEC');
INSERT INTO SCHEMA_NAME.config_web_class_form VALUES ('risk', 'F14', 'INFO_UTILS_CONNEC');


--
-- TOC entry 20530 (class 0 OID 3416256)
-- Dependencies: 4804
-- Data for Name: config_web_class_tab; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_class_tab VALUES (1, 'arc', 'tabElement');
INSERT INTO SCHEMA_NAME.config_web_class_tab VALUES (4, 'node', 'tabElement');
INSERT INTO SCHEMA_NAME.config_web_class_tab VALUES (2, 'arc', 'tabConnect');
INSERT INTO SCHEMA_NAME.config_web_class_tab VALUES (3, 'arc', 'tabVisit');
INSERT INTO SCHEMA_NAME.config_web_class_tab VALUES (5, 'node', 'tabVisit');
INSERT INTO SCHEMA_NAME.config_web_class_tab VALUES (6, 'workcat', 'tabElement');
INSERT INTO SCHEMA_NAME.config_web_class_tab VALUES (7, 'risk', 'tabElement');


--
-- TOC entry 20518 (class 0 OID 3416192)
-- Dependencies: 4792
-- Data for Name: config_web_fields; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--



--
-- TOC entry 20519 (class 0 OID 3416198)
-- Dependencies: 4793
-- Data for Name: config_web_fields_cat_datatype; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_fields_cat_datatype VALUES ('string');
INSERT INTO SCHEMA_NAME.config_web_fields_cat_datatype VALUES ('boolean');
INSERT INTO SCHEMA_NAME.config_web_fields_cat_datatype VALUES ('double');
INSERT INTO SCHEMA_NAME.config_web_fields_cat_datatype VALUES ('date');


--
-- TOC entry 20520 (class 0 OID 3416204)
-- Dependencies: 4794
-- Data for Name: config_web_fields_cat_type; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_fields_cat_type VALUES ('text');
INSERT INTO SCHEMA_NAME.config_web_fields_cat_type VALUES ('combo');
INSERT INTO SCHEMA_NAME.config_web_fields_cat_type VALUES ('textarea');
INSERT INTO SCHEMA_NAME.config_web_fields_cat_type VALUES ('checkbox');
INSERT INTO SCHEMA_NAME.config_web_fields_cat_type VALUES ('date');


--
-- TOC entry 20540 (class 0 OID 0)
-- Dependencies: 4795
-- Name: config_web_fields_id_seq; Type: SEQUENCE SET; Schema: clav; Owner: gisadmin
--

SELECT pg_catalog.setval('SCHEMA_NAME.config_web_fields_id_seq', 1, false);


--
-- TOC entry 20522 (class 0 OID 3416212)
-- Dependencies: 4796
-- Data for Name: config_web_forms; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_forms VALUES (1, 'v_ui_element_x_arc', 'SELECT codi as sys_id, class_id as sys_class, tipus, codi, nom FROM v_ui_element_x_arc', 1);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (2, 'v_ui_element_x_arc', 'SELECT codi as sys_id, class_id as sys_class, tipus, codi, nom FROM v_ui_element_x_arc', 2);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (3, 'v_ui_element_x_arc', 'SELECT codi as sys_id, class_id as sys_class, tipus, codi, nom FROM v_ui_element_x_arc', 3);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (5, 'v_ui_arc_x_connection', 'SELECT identif as sys_id, class_id as sys_class, tipus, tipemb, x as sys_x, y as sys_y  FROM v_ui_arc_x_connection', 2);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (6, 'v_ui_arc_x_connection', 'SELECT identif as sys_id, class_id as sys_class, tipus, tipemb, x as sys_x, y as sys_y  FROM v_ui_arc_x_connection', 3);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (8, 'v_ui_element', 'SELECT * FROM v_ui_workcat', 1);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (9, 'v_ui_element', 'SELECT * FROM v_ui_workcat', 2);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (10, 'v_ui_element', 'SELECT * FROM v_ui_workcat', 3);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (11, 'v_ui_element_x_node', 'SELECT codi as sys_id, class_id AS sys_class, tipus, codi, nom FROM v_ui_element_x_node', 1);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (12, 'v_ui_element_x_node', 'SELECT codi as sys_id, class_id AS sys_class, tipus, codi, nom FROM v_ui_element_x_node', 2);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (13, 'v_ui_element_x_node', 'SELECT codi as sys_id, class_id AS sys_class, tipus, codi, nom FROM v_ui_element_x_node', 3);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (22, 'v_ui_node_x_connection_upstream', 'SELECT node_id AS sys_id, class_id as sys_class, featurecat_id as "Tipus:", arccat_id as "Tipus Secció"  FROM v_ui_node_x_connection_upstream', 1);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (23, 'v_ui_node_x_connection_upstream', 'SELECT node_id AS sys_id, class_id as sys_class, featurecat_id as "Tipus:", arccat_id as "Tipus Secció"  FROM v_ui_node_x_connection_upstream', 2);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (24, 'v_ui_node_x_connection_upstream', 'SELECT node_id AS sys_id, class_id as sys_class, featurecat_id as "Tipus:", arccat_id as "Tipus Secció"  FROM v_ui_node_x_connection_upstream', 3);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (25, 'v_ui_node_x_connection_downstream', 'SELECT node_id AS sys_id, class_id as sys_class, featurecat_id as "Tipus:", arccat_id as "Tipus Secció"  FROM v_ui_node_x_connection_downstream', 1);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (26, 'v_ui_node_x_connection_upstream', 'SELECT node_id AS sys_id, class_id as sys_class, featurecat_id as "Tipus:", arccat_id as "Tipus Secció"  FROM v_ui_node_x_connection_downstream', 2);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (27, 'v_ui_node_x_connection_upstream', 'SELECT node_id AS sys_id, class_id as sys_class, featurecat_id as "Tipus:", arccat_id as "Tipus Secció"  FROM v_ui_node_x_connection_downstream', 3);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (15, 'v_ui_element_x_workcat', 'SELECT feature_id as sys_id, class_id AS sys_class, tipus, feature_id FROM v_ui_element_x_workcat', 1);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (16, 'v_ui_element_x_workcat', 'SELECT feature_id as sys_id, class_id AS sys_class, tipus, feature_id FROM v_ui_element_x_workcat', 2);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (17, 'v_ui_element_x_workcat', 'SELECT feature_id as sys_id, class_id AS sys_class, tipus, feature_id FROM v_ui_element_x_workcat', 3);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (18, 'v_ui_om_visit_x_arc', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript FROM v_ui_om_visit_x_arc', 1);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (19, 'v_ui_om_visit_x_arc', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript FROM v_ui_om_visit_x_arc', 2);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (20, 'v_ui_om_visit_x_arc', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript FROM v_ui_om_visit_x_arc', 3);
INSERT INTO SCHEMA_NAME.config_web_forms VALUES (4, 'v_ui_arc_x_connection', 'SELECT identif as sys_id, class_id as sys_class, tipus, tipemb, x as sys_x, y as sys_y  FROM v_ui_arc_x_connection', 1);


--
-- TOC entry 20541 (class 0 OID 0)
-- Dependencies: 4797
-- Name: config_web_forms_id_seq; Type: SEQUENCE SET; Schema: clav; Owner: gisadmin
--

SELECT pg_catalog.setval('SCHEMA_NAME.config_web_forms_id_seq', 27, true);


--
-- TOC entry 20525 (class 0 OID 3416226)
-- Dependencies: 4799
-- Data for Name: config_web_layer_cat_form; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F11', 'INFO_UD_NODE');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F12', 'INFO_WS_NODE');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F13', 'INFO_UTILS_ARC');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F14', 'INFO_UTILS_CONNEC');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F15', 'INFO_UD_GULLY');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F16', 'GENERIC');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F21', 'VISIT');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F22', 'VISIT_EVENT_STANDARD');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F23', 'VISIT_EVENT_UD_ARC_STANDARD');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F24', 'VISIT_EVENT_UD_ARC_REHABIT');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F25', 'VISIT_MANAGER');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F26', 'ADD_MULTIPLE_VISIT');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F27', 'GALLERY');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F31', 'SEARCH');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F32', 'PRINT');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F33', 'FILTER');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F41', 'MINCUT_NEW');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F42', 'MINCUT_ADD_CONNEC');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F43', 'MINCUT_ADD_HYDROMETER');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F44', 'MINCUT_END');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F45', 'MINCUT_MANAGEMENT');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F51', 'REVIEW_UD_ARC');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F52', 'REVIEW_UD_NODE');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F53', 'REVIEW_UD_CONNEC');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F54', 'REVIEW_UD_GULLY');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F55', 'REVIEW_WS_ARC');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F56', 'REVIEW_WS_NODE');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_form VALUES ('F57', 'REVIEW_WS_CONNEC');


--
-- TOC entry 20526 (class 0 OID 3416232)
-- Dependencies: 4800
-- Data for Name: config_web_layer_cat_formtab; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_layer_cat_formtab VALUES ('tabConnect');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_formtab VALUES ('tabDoc');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_formtab VALUES ('tabElement');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_formtab VALUES ('tabVisit');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_formtab VALUES ('tabHydro');
INSERT INTO SCHEMA_NAME.config_web_layer_cat_formtab VALUES ('tabMincut');


--
-- TOC entry 20527 (class 0 OID 3416238)
-- Dependencies: 4801
-- Data for Name: config_web_layer_child; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('AFICTICI', 'arc', 'v_afictici');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('CAMBRA', 'node', 'v_cambra');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('CAMBRAP', 'polygon', 'v_cambra');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('CANVCIR', 'node', 'v_canvcir');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('CANVSEC', 'node', 'v_canvsec');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('CLAPETA', 'node', 'v_clapeta');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('CLAVEGUERO', 'vnode', 'v_claveg');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('COMPORTES', 'node', 'v_comportes');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('DIPOSIT', 'node', 'v_diposit');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('DIPOSITOBERT', 'polygon', 'v_dipositobert');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('DIPOSITP', 'polygon', 'v_diposit');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('DSU', 'node', 'v_dsu');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('EDAR', 'node', 'v_edar');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('EMBABAIX', 'vnode', 'v_embabaix');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('EMBORNAL', 'embornal', 'v_embornal');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('ENTRONC', 'node', 'v_entronc');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('ENVA', 'node', 'v_enva');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('FOSSED', 'node', 'v_fossed');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('FUITA', 'vnode', 'v_fuita');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('INITRAM', 'node', 'v_initram');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('NFICTICI', 'node', 'v_nfictici');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('OSINGU', 'polygon', 'v_osingu');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('POU', 'node', 'v_pou');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('RAPID', 'arc', 'v_rapid');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('REIXAL', 'embornal', 'v_reixal');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('SALT', 'node', 'v_salt');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('SIFO', 'arc', 'v_sifo');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('SINGU', 'node', 'v_singu');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('SOBREIX', 'node', 'v_sobreix');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('TANCASEG', 'node', 'v_tancaseg');
INSERT INTO SCHEMA_NAME.config_web_layer_child VALUES ('TRAM', 'arc', 'v_tram');


--
-- TOC entry 20524 (class 0 OID 3416220)
-- Dependencies: 4798
-- Data for Name: config_web_layer_class; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_layer_class VALUES ('node', 'node', 1);
INSERT INTO SCHEMA_NAME.config_web_layer_class VALUES ('arc', 'arc', 2);
INSERT INTO SCHEMA_NAME.config_web_layer_class VALUES ('gully', 'gully', 3);
INSERT INTO SCHEMA_NAME.config_web_layer_class VALUES ('v_obra', 'workcat', 4);
INSERT INTO SCHEMA_NAME.config_web_layer_class VALUES ('v_risc', 'risk', 5);


--
-- TOC entry 20529 (class 0 OID 3416250)
-- Dependencies: 4803
-- Data for Name: config_web_layer_parent; Type: TABLE DATA; Schema: clav; Owner: gisadmin
--

INSERT INTO SCHEMA_NAME.config_web_layer_parent VALUES ('arc', 'v_parent_arc');
INSERT INTO SCHEMA_NAME.config_web_layer_parent VALUES ('connec', 'v_parent_connec');
INSERT INTO SCHEMA_NAME.config_web_layer_parent VALUES ('gully', 'v_parent_gully');
INSERT INTO SCHEMA_NAME.config_web_layer_parent VALUES ('node', 'v_parent_node');
INSERT INTO SCHEMA_NAME.config_web_layer_parent VALUES ('vnode', 'v_parent_vnode');
INSERT INTO SCHEMA_NAME.config_web_layer_parent VALUES ('polygon', 'v_parent_polygon');


--
-- TOC entry 20542 (class 0 OID 0)
-- Dependencies: 4805
-- Name: config_web_layer_tab_id_seq; Type: SEQUENCE SET; Schema: clav; Owner: gisadmin
--

SELECT pg_catalog.setval('SCHEMA_NAME.config_web_layer_tab_id_seq', 7, true);


--
-- TOC entry 18626 (class 2606 OID 3417024)
-- Name: config_client_forms_web_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_forms
    ADD CONSTRAINT config_client_forms_web_pkey PRIMARY KEY (id);


--
-- TOC entry 18638 (class 2606 OID 3417028)
-- Name: config_web_class_x_form_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_class_form
    ADD CONSTRAINT config_web_class_x_form_pkey PRIMARY KEY (class_id);


--
-- TOC entry 18622 (class 2606 OID 3417030)
-- Name: config_web_fields_cat_datatype_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_fields_cat_datatype
    ADD CONSTRAINT config_web_fields_cat_datatype_pkey PRIMARY KEY (id);


--
-- TOC entry 18624 (class 2606 OID 3417032)
-- Name: config_web_fields_cat_type_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_fields_cat_type
    ADD CONSTRAINT config_web_fields_cat_type_pkey PRIMARY KEY (id);


--
-- TOC entry 18620 (class 2606 OID 3417034)
-- Name: config_web_fields_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_fields
    ADD CONSTRAINT config_web_fields_pkey PRIMARY KEY (id);


--
-- TOC entry 18630 (class 2606 OID 3417036)
-- Name: config_web_layer_cat_form_name_unique; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_layer_cat_form
    ADD CONSTRAINT config_web_layer_cat_form_name_unique UNIQUE (name);


--
-- TOC entry 18632 (class 2606 OID 3417038)
-- Name: config_web_layer_cat_form_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_layer_cat_form
    ADD CONSTRAINT config_web_layer_cat_form_pkey PRIMARY KEY (id);


--
-- TOC entry 18634 (class 2606 OID 3417040)
-- Name: config_web_layer_cat_formtab_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_layer_cat_formtab
    ADD CONSTRAINT config_web_layer_cat_formtab_pkey PRIMARY KEY (id);


--
-- TOC entry 18636 (class 2606 OID 3417042)
-- Name: config_web_layer_child_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_layer_child
    ADD CONSTRAINT config_web_layer_child_pkey PRIMARY KEY (featurecat_id);


--
-- TOC entry 18640 (class 2606 OID 3417044)
-- Name: config_web_layer_parent_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_layer_parent
    ADD CONSTRAINT config_web_layer_parent_pkey PRIMARY KEY (layer_id);


--
-- TOC entry 18628 (class 2606 OID 3417046)
-- Name: config_web_layer_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_layer_class
    ADD CONSTRAINT config_web_layer_pkey PRIMARY KEY (layer_id);


--
-- TOC entry 18642 (class 2606 OID 3417048)
-- Name: config_web_layer_tab_pkey; Type: CONSTRAINT; Schema: clav; Owner: gisadmin
--

ALTER TABLE ONLY SCHEMA_NAME.config_web_class_tab
    ADD CONSTRAINT config_web_layer_tab_pkey PRIMARY KEY (id);


-- Completed on 2018-04-13 02:57:06

--
-- PostgreSQL database dump complete
--

