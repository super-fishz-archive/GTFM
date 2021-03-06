--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.4
-- Dumped by pg_dump version 9.4.4
-- Started on 2015-07-22 13:17:52

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

DROP DATABASE "GTFM";
--
-- TOC entry 2109 (class 1262 OID 16393)
-- Name: GTFM; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "GTFM" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Korean_Korea.949' LC_CTYPE = 'Korean_Korea.949';


ALTER DATABASE "GTFM" OWNER TO postgres;

\connect "GTFM"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2110 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 190 (class 3079 OID 11855)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2112 (class 0 OID 0)
-- Dependencies: 190
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 177 (class 1259 OID 16417)
-- Name: pc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pc (
    seq integer NOT NULL,
    room_seq integer,
    name text
);


ALTER TABLE pc OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 16470)
-- Name: port; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE port (
    seq integer NOT NULL,
    switch_seq integer,
    ip text,
    subnet_mask text,
    default_gateway text,
    dns_server text,
    sub_dns_server text,
    pc_seq integer,
    memo character varying(100)
);


ALTER TABLE port OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 16404)
-- Name: room; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE room (
    seq integer NOT NULL,
    room_name character varying(15),
    building_seq integer,
    memo character varying(100)
);


ALTER TABLE room OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 16531)
-- Name: pc_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW pc_list AS
 SELECT pc.seq,
    pc.name,
    room.room_name,
    port.ip
   FROM ((pc
     JOIN room ON ((pc.room_seq = room.seq)))
     JOIN port ON ((port.pc_seq = pc.seq)));


ALTER TABLE pc_list OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 16535)
-- Name: building_pc_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION building_pc_list(integer) RETURNS SETOF pc_list
    LANGUAGE sql
    AS $_$
	select pc_list.seq, pc_list.name, pc_list.room_name, pc_list.ip
	from pc_list join pc
	on pc_list.seq = pc.seq
	join room
	on pc.room_seq = room.seq
	where room.building_seq = $1;
$_$;


ALTER FUNCTION public.building_pc_list(integer) OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 16433)
-- Name: router; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE router (
    seq integer NOT NULL,
    ip text,
    network text,
    subnet_mask text,
    dns_server text,
    sub_dns_server text,
    building_seq integer,
    room_seq integer,
    name text
);


ALTER TABLE router OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 16521)
-- Name: router_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW router_list AS
 SELECT router.seq,
    router.name,
    router.ip,
    router.subnet_mask,
    room.room_name
   FROM (router
     JOIN room ON ((router.room_seq = room.seq)));


ALTER TABLE router_list OWNER TO postgres;

--
-- TOC entry 203 (class 1255 OID 16525)
-- Name: building_router_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION building_router_list(integer) RETURNS SETOF router_list
    LANGUAGE sql
    AS $_$
	select router_list.seq, router_list.name,router_list.ip, router_list.subnet_mask, router_list.room_name
	from router_list join router on router_list.seq = router.seq
	where router.building_seq = $1;
$_$;


ALTER FUNCTION public.building_router_list(integer) OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 16454)
-- Name: switch; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE switch (
    seq integer NOT NULL,
    router_seq integer,
    ip text,
    subnet_mask text,
    room_seq integer,
    name text
);


ALTER TABLE switch OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 16569)
-- Name: switch_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW switch_list AS
 SELECT switch.seq AS switch_seq,
    switch.name AS switch_name,
    switch.ip,
    router.seq AS router_seq,
    router.name AS router_name,
    room.room_name
   FROM ((switch
     JOIN router ON ((switch.router_seq = router.seq)))
     JOIN room ON ((switch.room_seq = room.seq)));


ALTER TABLE switch_list OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 16573)
-- Name: building_switch_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION building_switch_list(integer) RETURNS SETOF switch_list
    LANGUAGE sql
    AS $_$
	select switch_list.switch_seq, switch_list.switch_name, switch_list.ip, switch_list.router_seq, switch_list.router_name, switch_list.room_name
	from switch_list join switch on switch_list.switch_seq = switch.seq
	join router on switch.router_seq = router.seq
	where router.building_seq = $1;
$_$;


ALTER FUNCTION public.building_switch_list(integer) OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 16536)
-- Name: count_pc(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_pc(integer) RETURNS bigint
    LANGUAGE sql
    AS $_$
	select count(*) from pc
	where room_seq = $1;
$_$;


ALTER FUNCTION public.count_pc(integer) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 16553)
-- Name: count_port(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_port(integer) RETURNS bigint
    LANGUAGE sql
    AS $_$
	select count(*) from port
	where switch_seq = $1;
$_$;


ALTER FUNCTION public.count_port(integer) OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 16544)
-- Name: delete_pc(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_pc(a integer) RETURNS void
    LANGUAGE sql
    AS $$
	update port
	set pc_seq = null
	where pc_seq = a;
	delete from pc
	where seq = a;
$$;


ALTER FUNCTION public.delete_pc(a integer) OWNER TO postgres;

--
-- TOC entry 208 (class 1255 OID 16543)
-- Name: insert_pc(integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_pc(a integer, b integer, c character varying, d integer) RETURNS void
    LANGUAGE sql
    AS $$
	insert into pc(seq, room_seq, name)
	values (a, b, c);
	update port
	set pc_seq = a
	where seq = d;	
$$;


ALTER FUNCTION public.insert_pc(a integer, b integer, c character varying, d integer) OWNER TO postgres;

--
-- TOC entry 211 (class 1255 OID 16546)
-- Name: not_using_ip(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION not_using_ip() RETURNS SETOF text
    LANGUAGE sql
    AS $$
	select ip
	from port
	where pc_seq is null;
$$;


ALTER FUNCTION public.not_using_ip() OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 16538)
-- Name: pc_info_vu; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW pc_info_vu AS
 SELECT pc.seq,
    pc.name,
    port.ip,
    port.subnet_mask,
    port.default_gateway,
    port.dns_server,
    port.sub_dns_server
   FROM (pc
     JOIN port ON ((pc.seq = port.pc_seq)));


ALTER TABLE pc_info_vu OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 16542)
-- Name: pc_info(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pc_info(integer) RETURNS SETOF pc_info_vu
    LANGUAGE sql
    AS $_$
	select *
	from pc_info_vu
	where seq = $1;
$_$;


ALTER FUNCTION public.pc_info(integer) OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 16537)
-- Name: room_pc_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION room_pc_list(integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	select seq from pc
	where pc.room_seq = $1
$_$;


ALTER FUNCTION public.room_pc_list(integer) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 16575)
-- Name: router_info(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION router_info(integer) RETURNS TABLE(name text, ip text, subnet_mask text, location text)
    LANGUAGE sql
    AS $_$
	select router.name, router.ip, router.subnet_mask, building.building_name ||' '|| room.room_name as location
	from router join building
	on router.building_seq = building.seq
	join room
	on router.room_seq = room.seq
	where router.seq = $1;
$_$;


ALTER FUNCTION public.router_info(integer) OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16547)
-- Name: searched_ip; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW searched_ip AS
 SELECT port.ip,
    room.room_name,
    room.seq
   FROM ((port
     FULL JOIN pc ON ((port.pc_seq = pc.seq)))
     FULL JOIN room ON ((pc.room_seq = room.seq)));


ALTER TABLE searched_ip OWNER TO postgres;

--
-- TOC entry 212 (class 1255 OID 16551)
-- Name: search_ip(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_ip(text) RETURNS SETOF searched_ip
    LANGUAGE sql
    AS $_$
	select *
	from searched_ip
	where ip like '%'||$1||'%';
$_$;


ALTER FUNCTION public.search_ip(text) OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 16554)
-- Name: port_info_vu; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW port_info_vu AS
 SELECT port.seq,
    port.ip,
    port.subnet_mask,
    port.default_gateway,
    port.dns_server,
    port.sub_dns_server,
    port.pc_seq,
    pc.room_seq
   FROM (port
     JOIN pc ON ((port.pc_seq = port.pc_seq)));


ALTER TABLE port_info_vu OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 16558)
-- Name: switch_port_info(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION switch_port_info(integer) RETURNS port_info_vu
    LANGUAGE sql
    AS $_$
	select * from port_info_vu
	where seq = $1;
$_$;


ALTER FUNCTION public.switch_port_info(integer) OWNER TO postgres;

--
-- TOC entry 210 (class 1255 OID 16545)
-- Name: using_ip(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION using_ip() RETURNS SETOF text
    LANGUAGE sql
    AS $$
	select ip
	from port
	where pc_seq is not null;
$$;


ALTER FUNCTION public.using_ip() OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 16396)
-- Name: building; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE building (
    seq integer NOT NULL,
    building_name character varying(15)
);


ALTER TABLE building OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 16394)
-- Name: building_seq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE building_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE building_seq_seq OWNER TO postgres;

--
-- TOC entry 2113 (class 0 OID 0)
-- Dependencies: 172
-- Name: building_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE building_seq_seq OWNED BY building.seq;


--
-- TOC entry 176 (class 1259 OID 16415)
-- Name: pc_seq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pc_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pc_seq_seq OWNER TO postgres;

--
-- TOC entry 2114 (class 0 OID 0)
-- Dependencies: 176
-- Name: pc_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pc_seq_seq OWNED BY pc.seq;


--
-- TOC entry 182 (class 1259 OID 16468)
-- Name: port_seq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE port_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE port_seq_seq OWNER TO postgres;

--
-- TOC entry 2115 (class 0 OID 0)
-- Dependencies: 182
-- Name: port_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE port_seq_seq OWNED BY port.seq;


--
-- TOC entry 174 (class 1259 OID 16402)
-- Name: room_seq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE room_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE room_seq_seq OWNER TO postgres;

--
-- TOC entry 2116 (class 0 OID 0)
-- Dependencies: 174
-- Name: room_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE room_seq_seq OWNED BY room.seq;


--
-- TOC entry 178 (class 1259 OID 16431)
-- Name: router_seq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE router_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE router_seq_seq OWNER TO postgres;

--
-- TOC entry 2117 (class 0 OID 0)
-- Dependencies: 178
-- Name: router_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE router_seq_seq OWNED BY router.seq;


--
-- TOC entry 180 (class 1259 OID 16452)
-- Name: switch_seq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE switch_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE switch_seq_seq OWNER TO postgres;

--
-- TOC entry 2118 (class 0 OID 0)
-- Dependencies: 180
-- Name: switch_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE switch_seq_seq OWNED BY switch.seq;


--
-- TOC entry 1953 (class 2604 OID 16399)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY building ALTER COLUMN seq SET DEFAULT nextval('building_seq_seq'::regclass);


--
-- TOC entry 1955 (class 2604 OID 16420)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc ALTER COLUMN seq SET DEFAULT nextval('pc_seq_seq'::regclass);


--
-- TOC entry 1958 (class 2604 OID 16473)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port ALTER COLUMN seq SET DEFAULT nextval('port_seq_seq'::regclass);


--
-- TOC entry 1954 (class 2604 OID 16407)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY room ALTER COLUMN seq SET DEFAULT nextval('room_seq_seq'::regclass);


--
-- TOC entry 1956 (class 2604 OID 16436)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router ALTER COLUMN seq SET DEFAULT nextval('router_seq_seq'::regclass);


--
-- TOC entry 1957 (class 2604 OID 16457)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY switch ALTER COLUMN seq SET DEFAULT nextval('switch_seq_seq'::regclass);


--
-- TOC entry 2094 (class 0 OID 16396)
-- Dependencies: 173
-- Data for Name: building; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO building VALUES (1, '자연과학대');
INSERT INTO building VALUES (2, '상허연구동');
INSERT INTO building VALUES (3, '사회과학대');
INSERT INTO building VALUES (4, '종합강의동');


--
-- TOC entry 2119 (class 0 OID 0)
-- Dependencies: 172
-- Name: building_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('building_seq_seq', 1, false);


--
-- TOC entry 2098 (class 0 OID 16417)
-- Dependencies: 177
-- Data for Name: pc; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO pc VALUES (1, 1, 'Ja101_1	');
INSERT INTO pc VALUES (2, 1, 'Ja101_2	');
INSERT INTO pc VALUES (3, 1, 'Ja101_3	');
INSERT INTO pc VALUES (4, 1, 'Ja101_4	');
INSERT INTO pc VALUES (5, 1, 'Ja101_5	');
INSERT INTO pc VALUES (6, 1, 'Ja101_6	');
INSERT INTO pc VALUES (7, 1, 'Ja101_7	');
INSERT INTO pc VALUES (8, 1, 'Ja101_8	');
INSERT INTO pc VALUES (9, 1, 'Ja101_9	');
INSERT INTO pc VALUES (10, 1, 'Ja101_10	');
INSERT INTO pc VALUES (11, 1, 'Ja101_11	');
INSERT INTO pc VALUES (12, 1, 'Ja101_12	');
INSERT INTO pc VALUES (13, 1, 'Ja101_13	');
INSERT INTO pc VALUES (14, 1, 'Ja101_14	');
INSERT INTO pc VALUES (15, 1, 'Ja101_15	');
INSERT INTO pc VALUES (16, 1, 'Ja101_16	');
INSERT INTO pc VALUES (17, 1, 'Ja101_17	');
INSERT INTO pc VALUES (18, 1, 'Ja101_18	');
INSERT INTO pc VALUES (19, 1, 'Ja101_19	');
INSERT INTO pc VALUES (20, 1, 'Ja101_20	');
INSERT INTO pc VALUES (21, 1, 'Ja101_21	');
INSERT INTO pc VALUES (22, 1, 'Ja101_22	');
INSERT INTO pc VALUES (23, 1, 'Ja101_23	');
INSERT INTO pc VALUES (24, 1, 'Ja101_24	');
INSERT INTO pc VALUES (25, 1, 'Ja101_25	');
INSERT INTO pc VALUES (26, 1, 'Ja101_26	');
INSERT INTO pc VALUES (27, 1, 'Ja101_27	');
INSERT INTO pc VALUES (28, 1, 'Ja101_28	');
INSERT INTO pc VALUES (29, 1, 'Ja101_29	');
INSERT INTO pc VALUES (30, 1, 'Ja101_30	');
INSERT INTO pc VALUES (31, 1, 'Ja101_31	');
INSERT INTO pc VALUES (32, 1, 'Ja101_32	');
INSERT INTO pc VALUES (33, 1, 'Ja101_33	');
INSERT INTO pc VALUES (34, 1, 'Ja101_34	');
INSERT INTO pc VALUES (35, 1, 'Ja101_35	');
INSERT INTO pc VALUES (36, 1, 'Ja101_36	');
INSERT INTO pc VALUES (37, 1, 'Ja101_37	');
INSERT INTO pc VALUES (38, 1, 'Ja101_38	');
INSERT INTO pc VALUES (39, 1, 'Ja101_39	');
INSERT INTO pc VALUES (40, 1, 'Ja101_40	');
INSERT INTO pc VALUES (41, 2, 'JA202_1	');
INSERT INTO pc VALUES (42, 2, 'JA202_2	');
INSERT INTO pc VALUES (43, 2, 'JA202_3	');
INSERT INTO pc VALUES (44, 2, 'JA202_4	');
INSERT INTO pc VALUES (45, 2, 'JA202_5	');
INSERT INTO pc VALUES (46, 2, 'JA202_6	');
INSERT INTO pc VALUES (47, 2, 'JA202_7	');
INSERT INTO pc VALUES (48, 2, 'JA202_8	');
INSERT INTO pc VALUES (49, 2, 'JA202_9	');
INSERT INTO pc VALUES (50, 2, 'JA202_10	');
INSERT INTO pc VALUES (51, 2, 'JA202_11	');
INSERT INTO pc VALUES (52, 2, 'JA202_12	');
INSERT INTO pc VALUES (53, 2, 'JA202_13	');
INSERT INTO pc VALUES (54, 2, 'JA202_14	');
INSERT INTO pc VALUES (55, 2, 'JA202_15	');
INSERT INTO pc VALUES (56, 2, 'JA202_16	');
INSERT INTO pc VALUES (57, 2, 'JA202_17	');
INSERT INTO pc VALUES (58, 2, 'JA202_18	');
INSERT INTO pc VALUES (59, 2, 'JA202_19	');
INSERT INTO pc VALUES (60, 2, 'JA202_20	');
INSERT INTO pc VALUES (61, 2, 'JA202_21	');
INSERT INTO pc VALUES (62, 2, 'JA202_22	');
INSERT INTO pc VALUES (63, 2, 'JA202_23	');
INSERT INTO pc VALUES (64, 2, 'JA202_24	');
INSERT INTO pc VALUES (65, 2, 'JA202_25	');
INSERT INTO pc VALUES (66, 2, 'JA202_26	');
INSERT INTO pc VALUES (67, 2, 'JA202_27	');
INSERT INTO pc VALUES (68, 2, 'JA202_28	');
INSERT INTO pc VALUES (69, 2, 'JA202_29	');
INSERT INTO pc VALUES (70, 2, 'JA202_30	');
INSERT INTO pc VALUES (71, 2, 'JA202_31	');
INSERT INTO pc VALUES (72, 2, 'JA202_32	');
INSERT INTO pc VALUES (73, 2, 'JA202_33	');
INSERT INTO pc VALUES (74, 2, 'JA202_34	');
INSERT INTO pc VALUES (75, 2, 'JA202_35	');
INSERT INTO pc VALUES (76, 2, 'JA202_36	');
INSERT INTO pc VALUES (77, 2, 'JA202_37	');
INSERT INTO pc VALUES (78, 2, 'JA202_38	');
INSERT INTO pc VALUES (79, 2, 'JA202_39	');
INSERT INTO pc VALUES (80, 2, 'JA202_40	');
INSERT INTO pc VALUES (81, 3, '	S101_1');
INSERT INTO pc VALUES (82, 3, '	S101_2');
INSERT INTO pc VALUES (83, 3, '	S101_3');
INSERT INTO pc VALUES (84, 3, '	S101_4');
INSERT INTO pc VALUES (85, 3, '	S101_5');
INSERT INTO pc VALUES (86, 3, '	S101_6');
INSERT INTO pc VALUES (87, 3, '	S101_7');
INSERT INTO pc VALUES (88, 3, '	S101_8');
INSERT INTO pc VALUES (89, 3, '	S101_9');
INSERT INTO pc VALUES (90, 3, '	S101_10');
INSERT INTO pc VALUES (91, 3, '	S101_11');
INSERT INTO pc VALUES (92, 3, '	S101_12');
INSERT INTO pc VALUES (93, 3, '	S101_13');
INSERT INTO pc VALUES (94, 3, '	S101_14');
INSERT INTO pc VALUES (95, 3, '	S101_15');
INSERT INTO pc VALUES (96, 3, '	S101_16');
INSERT INTO pc VALUES (97, 3, '	S101_17');
INSERT INTO pc VALUES (98, 3, '	S101_18');
INSERT INTO pc VALUES (99, 3, '	S101_19');
INSERT INTO pc VALUES (100, 3, '	S101_20');
INSERT INTO pc VALUES (101, 3, '	S101_21');
INSERT INTO pc VALUES (102, 3, '	S101_22');
INSERT INTO pc VALUES (103, 3, '	S101_23');
INSERT INTO pc VALUES (104, 3, '	S101_24');
INSERT INTO pc VALUES (105, 3, '	S101_25');
INSERT INTO pc VALUES (106, 3, '	S101_26');
INSERT INTO pc VALUES (107, 3, '	S101_27');
INSERT INTO pc VALUES (108, 3, '	S101_28');
INSERT INTO pc VALUES (109, 3, '	S101_29');
INSERT INTO pc VALUES (110, 3, '	S101_30');
INSERT INTO pc VALUES (111, 3, '	S101_31');
INSERT INTO pc VALUES (112, 3, '	S101_32');
INSERT INTO pc VALUES (113, 3, '	S101_33');
INSERT INTO pc VALUES (114, 3, '	S101_34');
INSERT INTO pc VALUES (115, 3, '	S101_35');
INSERT INTO pc VALUES (116, 3, '	S101_36');
INSERT INTO pc VALUES (117, 3, '	S101_37');
INSERT INTO pc VALUES (118, 3, '	S101_38');
INSERT INTO pc VALUES (119, 3, '	S101_39');
INSERT INTO pc VALUES (120, 3, '	S101_40');
INSERT INTO pc VALUES (121, 4, '	S202_1');
INSERT INTO pc VALUES (122, 4, '	S202_2');
INSERT INTO pc VALUES (123, 4, '	S202_3');
INSERT INTO pc VALUES (124, 4, '	S202_4');
INSERT INTO pc VALUES (125, 4, '	S202_5');
INSERT INTO pc VALUES (126, 4, '	S202_6');
INSERT INTO pc VALUES (127, 4, '	S202_7');
INSERT INTO pc VALUES (128, 4, '	S202_8');
INSERT INTO pc VALUES (129, 4, '	S202_9');
INSERT INTO pc VALUES (130, 4, '	S202_10');
INSERT INTO pc VALUES (131, 4, '	S202_11');
INSERT INTO pc VALUES (132, 4, '	S202_12');
INSERT INTO pc VALUES (133, 4, '	S202_13');
INSERT INTO pc VALUES (134, 4, '	S202_14');
INSERT INTO pc VALUES (135, 4, '	S202_15');
INSERT INTO pc VALUES (136, 4, '	S202_16');
INSERT INTO pc VALUES (137, 4, '	S202_17');
INSERT INTO pc VALUES (138, 4, '	S202_18');
INSERT INTO pc VALUES (139, 4, '	S202_19');
INSERT INTO pc VALUES (140, 4, '	S202_20');
INSERT INTO pc VALUES (141, 4, '	S202_21');
INSERT INTO pc VALUES (142, 4, '	S202_22');
INSERT INTO pc VALUES (143, 4, '	S202_23');
INSERT INTO pc VALUES (144, 4, '	S202_24');
INSERT INTO pc VALUES (145, 4, '	S202_25');
INSERT INTO pc VALUES (146, 4, '	S202_26');
INSERT INTO pc VALUES (147, 4, '	S202_27');
INSERT INTO pc VALUES (148, 4, '	S202_28');
INSERT INTO pc VALUES (149, 4, '	S202_29');
INSERT INTO pc VALUES (150, 4, '	S202_30');
INSERT INTO pc VALUES (151, 4, '	S202_31');
INSERT INTO pc VALUES (152, 4, '	S202_32');
INSERT INTO pc VALUES (153, 4, '	S202_33');
INSERT INTO pc VALUES (154, 4, '	S202_34');
INSERT INTO pc VALUES (155, 4, '	S202_35');
INSERT INTO pc VALUES (156, 4, '	S202_36');
INSERT INTO pc VALUES (157, 4, '	S202_37');
INSERT INTO pc VALUES (158, 4, '	S202_38');
INSERT INTO pc VALUES (159, 4, '	S202_39');
INSERT INTO pc VALUES (160, 4, '	S202_40');
INSERT INTO pc VALUES (161, 5, '	SH101_1');
INSERT INTO pc VALUES (162, 5, '	SH101_2');
INSERT INTO pc VALUES (163, 5, '	SH101_3');
INSERT INTO pc VALUES (164, 5, '	SH101_4');
INSERT INTO pc VALUES (165, 5, '	SH101_5');
INSERT INTO pc VALUES (166, 5, '	SH101_6');
INSERT INTO pc VALUES (167, 5, '	SH101_7');
INSERT INTO pc VALUES (168, 5, '	SH101_8');
INSERT INTO pc VALUES (169, 5, '	SH101_9');
INSERT INTO pc VALUES (170, 5, '	SH101_10');
INSERT INTO pc VALUES (171, 5, '	SH101_11');
INSERT INTO pc VALUES (172, 5, '	SH101_12');
INSERT INTO pc VALUES (173, 5, '	SH101_13');
INSERT INTO pc VALUES (174, 5, '	SH101_14');
INSERT INTO pc VALUES (175, 5, '	SH101_15');
INSERT INTO pc VALUES (176, 5, '	SH101_16');
INSERT INTO pc VALUES (177, 5, '	SH101_17');
INSERT INTO pc VALUES (178, 5, '	SH101_18');
INSERT INTO pc VALUES (179, 5, '	SH101_19');
INSERT INTO pc VALUES (180, 5, '	SH101_20');
INSERT INTO pc VALUES (181, 5, '	SH101_21');
INSERT INTO pc VALUES (182, 5, '	SH101_22');
INSERT INTO pc VALUES (183, 5, '	SH101_23');
INSERT INTO pc VALUES (184, 5, '	SH101_24');
INSERT INTO pc VALUES (185, 5, '	SH101_25');
INSERT INTO pc VALUES (186, 5, '	SH101_26');
INSERT INTO pc VALUES (187, 5, '	SH101_27');
INSERT INTO pc VALUES (188, 5, '	SH101_28');
INSERT INTO pc VALUES (189, 5, '	SH101_29');
INSERT INTO pc VALUES (190, 5, '	SH101_30');
INSERT INTO pc VALUES (191, 5, '	SH101_31');
INSERT INTO pc VALUES (192, 5, '	SH101_32');
INSERT INTO pc VALUES (193, 5, '	SH101_33');
INSERT INTO pc VALUES (194, 5, '	SH101_34');
INSERT INTO pc VALUES (195, 5, '	SH101_35');
INSERT INTO pc VALUES (196, 5, '	SH101_36');
INSERT INTO pc VALUES (197, 5, '	SH101_37');
INSERT INTO pc VALUES (198, 5, '	SH101_38');
INSERT INTO pc VALUES (199, 5, '	SH101_39');
INSERT INTO pc VALUES (200, 5, '	SH101_40');
INSERT INTO pc VALUES (201, 6, '	SH202_1');
INSERT INTO pc VALUES (202, 6, '	SH202_2');
INSERT INTO pc VALUES (203, 6, '	SH202_3');
INSERT INTO pc VALUES (204, 6, '	SH202_4');
INSERT INTO pc VALUES (205, 6, '	SH202_5');
INSERT INTO pc VALUES (206, 6, '	SH202_6');
INSERT INTO pc VALUES (207, 6, '	SH202_7');
INSERT INTO pc VALUES (208, 6, '	SH202_8');
INSERT INTO pc VALUES (209, 6, '	SH202_9');
INSERT INTO pc VALUES (210, 6, '	SH202_10');
INSERT INTO pc VALUES (211, 6, '	SH202_11');
INSERT INTO pc VALUES (212, 6, '	SH202_12');
INSERT INTO pc VALUES (213, 6, '	SH202_13');
INSERT INTO pc VALUES (214, 6, '	SH202_14');
INSERT INTO pc VALUES (215, 6, '	SH202_15');
INSERT INTO pc VALUES (216, 6, '	SH202_16');
INSERT INTO pc VALUES (217, 6, '	SH202_17');
INSERT INTO pc VALUES (218, 6, '	SH202_18');
INSERT INTO pc VALUES (219, 6, '	SH202_19');
INSERT INTO pc VALUES (220, 6, '	SH202_20');
INSERT INTO pc VALUES (221, 6, '	SH202_21');
INSERT INTO pc VALUES (222, 6, '	SH202_22');
INSERT INTO pc VALUES (223, 6, '	SH202_23');
INSERT INTO pc VALUES (224, 6, '	SH202_24');
INSERT INTO pc VALUES (225, 6, '	SH202_25');
INSERT INTO pc VALUES (226, 6, '	SH202_26');
INSERT INTO pc VALUES (227, 6, '	SH202_27');
INSERT INTO pc VALUES (228, 6, '	SH202_28');
INSERT INTO pc VALUES (229, 6, '	SH202_29');
INSERT INTO pc VALUES (230, 6, '	SH202_30');
INSERT INTO pc VALUES (231, 6, '	SH202_31');
INSERT INTO pc VALUES (232, 6, '	SH202_32');
INSERT INTO pc VALUES (233, 6, '	SH202_33');
INSERT INTO pc VALUES (234, 6, '	SH202_34');
INSERT INTO pc VALUES (235, 6, '	SH202_35');
INSERT INTO pc VALUES (236, 6, '	SH202_36');
INSERT INTO pc VALUES (237, 6, '	SH202_37');
INSERT INTO pc VALUES (238, 6, '	SH202_38');
INSERT INTO pc VALUES (239, 6, '	SH202_39');
INSERT INTO pc VALUES (240, 6, '	SH202_40');
INSERT INTO pc VALUES (241, 7, '	Jong101_1');
INSERT INTO pc VALUES (242, 7, '	Jong101_2');
INSERT INTO pc VALUES (243, 7, '	Jong101_3');
INSERT INTO pc VALUES (244, 7, '	Jong101_4');
INSERT INTO pc VALUES (245, 7, '	Jong101_5');
INSERT INTO pc VALUES (246, 7, '	Jong101_6');
INSERT INTO pc VALUES (247, 7, '	Jong101_7');
INSERT INTO pc VALUES (248, 7, '	Jong101_8');
INSERT INTO pc VALUES (249, 7, '	Jong101_9');
INSERT INTO pc VALUES (250, 7, '	Jong101_10');
INSERT INTO pc VALUES (251, 7, '	Jong101_11');
INSERT INTO pc VALUES (252, 7, '	Jong101_12');
INSERT INTO pc VALUES (253, 7, '	Jong101_13');
INSERT INTO pc VALUES (254, 7, '	Jong101_14');
INSERT INTO pc VALUES (255, 7, '	Jong101_15');
INSERT INTO pc VALUES (256, 7, '	Jong101_16');
INSERT INTO pc VALUES (257, 7, '	Jong101_17');
INSERT INTO pc VALUES (258, 7, '	Jong101_18');
INSERT INTO pc VALUES (259, 7, '	Jong101_19');
INSERT INTO pc VALUES (260, 7, '	Jong101_20');
INSERT INTO pc VALUES (261, 7, '	Jong101_21');
INSERT INTO pc VALUES (262, 7, '	Jong101_22');
INSERT INTO pc VALUES (263, 7, '	Jong101_23');
INSERT INTO pc VALUES (264, 7, '	Jong101_24');
INSERT INTO pc VALUES (265, 7, '	Jong101_25');
INSERT INTO pc VALUES (266, 7, '	Jong101_26');
INSERT INTO pc VALUES (267, 7, '	Jong101_27');
INSERT INTO pc VALUES (268, 7, '	Jong101_28');
INSERT INTO pc VALUES (269, 7, '	Jong101_29');
INSERT INTO pc VALUES (270, 7, '	Jong101_30');
INSERT INTO pc VALUES (271, 7, '	Jong101_31');
INSERT INTO pc VALUES (272, 7, '	Jong101_32');
INSERT INTO pc VALUES (273, 7, '	Jong101_33');
INSERT INTO pc VALUES (274, 7, '	Jong101_34');
INSERT INTO pc VALUES (275, 7, '	Jong101_35');
INSERT INTO pc VALUES (276, 7, '	Jong101_36');
INSERT INTO pc VALUES (277, 7, '	Jong101_37');
INSERT INTO pc VALUES (278, 7, '	Jong101_38');
INSERT INTO pc VALUES (279, 7, '	Jong101_39');
INSERT INTO pc VALUES (280, 7, '	Jong101_40');
INSERT INTO pc VALUES (281, 8, '	Jong202_1');
INSERT INTO pc VALUES (282, 8, '	Jong202_2');
INSERT INTO pc VALUES (283, 8, '	Jong202_3');
INSERT INTO pc VALUES (284, 8, '	Jong202_4');
INSERT INTO pc VALUES (285, 8, '	Jong202_5');
INSERT INTO pc VALUES (286, 8, '	Jong202_6');
INSERT INTO pc VALUES (287, 8, '	Jong202_7');
INSERT INTO pc VALUES (288, 8, '	Jong202_8');
INSERT INTO pc VALUES (289, 8, '	Jong202_9');
INSERT INTO pc VALUES (290, 8, '	Jong202_10');
INSERT INTO pc VALUES (291, 8, '	Jong202_11');
INSERT INTO pc VALUES (292, 8, '	Jong202_12');
INSERT INTO pc VALUES (293, 8, '	Jong202_13');
INSERT INTO pc VALUES (294, 8, '	Jong202_14');
INSERT INTO pc VALUES (295, 8, '	Jong202_15');
INSERT INTO pc VALUES (296, 8, '	Jong202_16');
INSERT INTO pc VALUES (297, 8, '	Jong202_17');
INSERT INTO pc VALUES (298, 8, '	Jong202_18');
INSERT INTO pc VALUES (299, 8, '	Jong202_19');
INSERT INTO pc VALUES (300, 8, '	Jong202_20');
INSERT INTO pc VALUES (301, 8, '	Jong202_21');
INSERT INTO pc VALUES (302, 8, '	Jong202_22');
INSERT INTO pc VALUES (303, 8, '	Jong202_23');
INSERT INTO pc VALUES (304, 8, '	Jong202_24');
INSERT INTO pc VALUES (305, 8, '	Jong202_25');
INSERT INTO pc VALUES (306, 8, '	Jong202_26');
INSERT INTO pc VALUES (307, 8, '	Jong202_27');
INSERT INTO pc VALUES (308, 8, '	Jong202_28');
INSERT INTO pc VALUES (309, 8, '	Jong202_29');
INSERT INTO pc VALUES (310, 8, '	Jong202_30');
INSERT INTO pc VALUES (311, 8, '	Jong202_31');
INSERT INTO pc VALUES (312, 8, '	Jong202_32');
INSERT INTO pc VALUES (313, 8, '	Jong202_33');
INSERT INTO pc VALUES (314, 8, '	Jong202_34');
INSERT INTO pc VALUES (315, 8, '	Jong202_35');
INSERT INTO pc VALUES (316, 8, '	Jong202_36');
INSERT INTO pc VALUES (317, 8, '	Jong202_37');
INSERT INTO pc VALUES (318, 8, '	Jong202_38');
INSERT INTO pc VALUES (319, 8, '	Jong202_39');
INSERT INTO pc VALUES (320, 8, '	Jong202_40');


--
-- TOC entry 2120 (class 0 OID 0)
-- Dependencies: 176
-- Name: pc_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_seq_seq', 1, false);


--
-- TOC entry 2104 (class 0 OID 16470)
-- Dependencies: 183
-- Data for Name: port; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO port VALUES (1, 1, '	192.168.1.1', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 1, NULL);
INSERT INTO port VALUES (2, 1, '	192.168.1.2', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 2, NULL);
INSERT INTO port VALUES (3, 1, '	192.168.1.3', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 3, NULL);
INSERT INTO port VALUES (4, 1, '	192.168.1.4', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 4, NULL);
INSERT INTO port VALUES (5, 1, '	192.168.1.5', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 5, NULL);
INSERT INTO port VALUES (6, 1, '	192.168.1.6', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 6, NULL);
INSERT INTO port VALUES (7, 1, '	192.168.1.7', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 7, NULL);
INSERT INTO port VALUES (8, 1, '	192.168.1.8', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 8, NULL);
INSERT INTO port VALUES (9, 1, '	192.168.1.9', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 9, NULL);
INSERT INTO port VALUES (10, 1, '	192.168.1.10', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 10, NULL);
INSERT INTO port VALUES (11, 1, '	192.168.1.11', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 11, NULL);
INSERT INTO port VALUES (12, 1, '	192.168.1.12', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 12, NULL);
INSERT INTO port VALUES (13, 1, '	192.168.1.13', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 13, NULL);
INSERT INTO port VALUES (14, 1, '	192.168.1.14', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 14, NULL);
INSERT INTO port VALUES (15, 1, '	192.168.1.15', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 15, NULL);
INSERT INTO port VALUES (16, 1, '	192.168.1.16', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 16, NULL);
INSERT INTO port VALUES (17, 1, '	192.168.1.17', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 17, NULL);
INSERT INTO port VALUES (18, 1, '	192.168.1.18', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 18, NULL);
INSERT INTO port VALUES (19, 1, '	192.168.1.19', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 19, NULL);
INSERT INTO port VALUES (20, 1, '	192.168.1.20', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 20, NULL);
INSERT INTO port VALUES (21, 1, '	192.168.1.21', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 21, NULL);
INSERT INTO port VALUES (22, 1, '	192.168.1.22', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 22, NULL);
INSERT INTO port VALUES (23, 1, '	192.168.1.23', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 23, NULL);
INSERT INTO port VALUES (24, 1, '	192.168.1.24', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 24, NULL);
INSERT INTO port VALUES (25, 1, '	192.168.1.25', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 25, NULL);
INSERT INTO port VALUES (26, 1, '	192.168.1.26', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 26, NULL);
INSERT INTO port VALUES (27, 1, '	192.168.1.27', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 27, NULL);
INSERT INTO port VALUES (28, 1, '	192.168.1.28', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 28, NULL);
INSERT INTO port VALUES (29, 1, '	192.168.1.29', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 29, NULL);
INSERT INTO port VALUES (30, 1, '	192.168.1.30', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 30, NULL);
INSERT INTO port VALUES (31, 1, '	192.168.1.31', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 31, NULL);
INSERT INTO port VALUES (32, 1, '	192.168.1.32', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 32, NULL);
INSERT INTO port VALUES (33, 1, '	192.168.1.33', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 33, NULL);
INSERT INTO port VALUES (34, 1, '	192.168.1.34', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 34, NULL);
INSERT INTO port VALUES (35, 1, '	192.168.1.35', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 35, NULL);
INSERT INTO port VALUES (36, 1, '	192.168.1.36', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 36, NULL);
INSERT INTO port VALUES (37, 1, '	192.168.1.37', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 37, NULL);
INSERT INTO port VALUES (38, 1, '	192.168.1.38', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 38, NULL);
INSERT INTO port VALUES (39, 1, '	192.168.1.39', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 39, NULL);
INSERT INTO port VALUES (40, 1, '	192.168.1.40', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 40, NULL);
INSERT INTO port VALUES (41, 2, '	192.168.1.80', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 41, NULL);
INSERT INTO port VALUES (42, 2, '	192.168.1.81', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 42, NULL);
INSERT INTO port VALUES (43, 2, '	192.168.1.82', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 43, NULL);
INSERT INTO port VALUES (44, 2, '	192.168.1.83', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 44, NULL);
INSERT INTO port VALUES (45, 2, '	192.168.1.84', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 45, NULL);
INSERT INTO port VALUES (46, 2, '	192.168.1.85', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 46, NULL);
INSERT INTO port VALUES (47, 2, '	192.168.1.86', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 47, NULL);
INSERT INTO port VALUES (48, 2, '	192.168.1.87', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 48, NULL);
INSERT INTO port VALUES (49, 2, '	192.168.1.88', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 49, NULL);
INSERT INTO port VALUES (50, 2, '	192.168.1.89', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 50, NULL);
INSERT INTO port VALUES (51, 2, '	192.168.1.90', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 51, NULL);
INSERT INTO port VALUES (52, 2, '	192.168.1.91', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 52, NULL);
INSERT INTO port VALUES (53, 2, '	192.168.1.92', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 53, NULL);
INSERT INTO port VALUES (54, 2, '	192.168.1.93', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 54, NULL);
INSERT INTO port VALUES (55, 2, '	192.168.1.94', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 55, NULL);
INSERT INTO port VALUES (56, 2, '	192.168.1.95', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 56, NULL);
INSERT INTO port VALUES (57, 2, '	192.168.1.96', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 57, NULL);
INSERT INTO port VALUES (58, 2, '	192.168.1.97', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 58, NULL);
INSERT INTO port VALUES (59, 2, '	192.168.1.98', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 59, NULL);
INSERT INTO port VALUES (60, 2, '	192.168.1.99', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 60, NULL);
INSERT INTO port VALUES (61, 2, '	192.168.1.100', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 61, NULL);
INSERT INTO port VALUES (62, 2, '	192.168.1.101', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 62, NULL);
INSERT INTO port VALUES (63, 2, '	192.168.1.102', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 63, NULL);
INSERT INTO port VALUES (64, 2, '	192.168.1.103', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 64, NULL);
INSERT INTO port VALUES (65, 2, '	192.168.1.104', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 65, NULL);
INSERT INTO port VALUES (66, 2, '	192.168.1.105', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 66, NULL);
INSERT INTO port VALUES (67, 2, '	192.168.1.106', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 67, NULL);
INSERT INTO port VALUES (68, 2, '	192.168.1.107', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 68, NULL);
INSERT INTO port VALUES (69, 2, '	192.168.1.108', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 69, NULL);
INSERT INTO port VALUES (70, 2, '	192.168.1.109', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 70, NULL);
INSERT INTO port VALUES (71, 2, '	192.168.1.110', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 71, NULL);
INSERT INTO port VALUES (72, 2, '	192.168.1.111', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 72, NULL);
INSERT INTO port VALUES (73, 2, '	192.168.1.112', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 73, NULL);
INSERT INTO port VALUES (74, 2, '	192.168.1.113', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 74, NULL);
INSERT INTO port VALUES (75, 2, '	192.168.1.114', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 75, NULL);
INSERT INTO port VALUES (76, 2, '	192.168.1.115', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 76, NULL);
INSERT INTO port VALUES (77, 2, '	192.168.1.116', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 77, NULL);
INSERT INTO port VALUES (78, 2, '	192.168.1.117', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 78, NULL);
INSERT INTO port VALUES (79, 2, '	192.168.1.118', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 79, NULL);
INSERT INTO port VALUES (80, 2, '	192.168.1.119', '	255.255.255.0', '	192.168.1.254', '	152.23.142.27', '	152.23.142.28', 80, NULL);
INSERT INTO port VALUES (81, 3, '	192.168.2.1', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 81, NULL);
INSERT INTO port VALUES (82, 3, '	192.168.2.2', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 82, NULL);
INSERT INTO port VALUES (83, 3, '	192.168.2.3', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 83, NULL);
INSERT INTO port VALUES (84, 3, '	192.168.2.4', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 84, NULL);
INSERT INTO port VALUES (85, 3, '	192.168.2.5', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 85, NULL);
INSERT INTO port VALUES (86, 3, '	192.168.2.6', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 86, NULL);
INSERT INTO port VALUES (87, 3, '	192.168.2.7', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 87, NULL);
INSERT INTO port VALUES (88, 3, '	192.168.2.8', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 88, NULL);
INSERT INTO port VALUES (89, 3, '	192.168.2.9', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 89, NULL);
INSERT INTO port VALUES (90, 3, '	192.168.2.10', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 90, NULL);
INSERT INTO port VALUES (91, 3, '	192.168.2.11', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 91, NULL);
INSERT INTO port VALUES (92, 3, '	192.168.2.12', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 92, NULL);
INSERT INTO port VALUES (93, 3, '	192.168.2.13', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 93, NULL);
INSERT INTO port VALUES (94, 3, '	192.168.2.14', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 94, NULL);
INSERT INTO port VALUES (95, 3, '	192.168.2.15', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 95, NULL);
INSERT INTO port VALUES (96, 3, '	192.168.2.16', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 96, NULL);
INSERT INTO port VALUES (97, 3, '	192.168.2.17', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 97, NULL);
INSERT INTO port VALUES (98, 3, '	192.168.2.18', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 98, NULL);
INSERT INTO port VALUES (99, 3, '	192.168.2.19', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 99, NULL);
INSERT INTO port VALUES (100, 3, '	192.168.2.20', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 100, NULL);
INSERT INTO port VALUES (101, 3, '	192.168.2.21', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 101, NULL);
INSERT INTO port VALUES (102, 3, '	192.168.2.22', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 102, NULL);
INSERT INTO port VALUES (103, 3, '	192.168.2.23', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 103, NULL);
INSERT INTO port VALUES (104, 3, '	192.168.2.24', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 104, NULL);
INSERT INTO port VALUES (105, 3, '	192.168.2.25', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 105, NULL);
INSERT INTO port VALUES (106, 3, '	192.168.2.26', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 106, NULL);
INSERT INTO port VALUES (107, 3, '	192.168.2.27', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 107, NULL);
INSERT INTO port VALUES (108, 3, '	192.168.2.28', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 108, NULL);
INSERT INTO port VALUES (109, 3, '	192.168.2.29', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 109, NULL);
INSERT INTO port VALUES (110, 3, '	192.168.2.30', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 110, NULL);
INSERT INTO port VALUES (111, 3, '	192.168.2.31', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 111, NULL);
INSERT INTO port VALUES (112, 3, '	192.168.2.32', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 112, NULL);
INSERT INTO port VALUES (113, 3, '	192.168.2.33', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 113, NULL);
INSERT INTO port VALUES (114, 3, '	192.168.2.34', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 114, NULL);
INSERT INTO port VALUES (115, 3, '	192.168.2.35', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 115, NULL);
INSERT INTO port VALUES (116, 3, '	192.168.2.36', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 116, NULL);
INSERT INTO port VALUES (117, 3, '	192.168.2.37', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 117, NULL);
INSERT INTO port VALUES (118, 3, '	192.168.2.38', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 118, NULL);
INSERT INTO port VALUES (119, 3, '	192.168.2.39', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 119, NULL);
INSERT INTO port VALUES (120, 3, '	192.168.2.40', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 120, NULL);
INSERT INTO port VALUES (121, 4, '	192.168.2.80', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 121, NULL);
INSERT INTO port VALUES (122, 4, '	192.168.2.81', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 122, NULL);
INSERT INTO port VALUES (123, 4, '	192.168.2.82', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 123, NULL);
INSERT INTO port VALUES (124, 4, '	192.168.2.83', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 124, NULL);
INSERT INTO port VALUES (125, 4, '	192.168.2.84', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 125, NULL);
INSERT INTO port VALUES (126, 4, '	192.168.2.85', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 126, NULL);
INSERT INTO port VALUES (127, 4, '	192.168.2.86', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 127, NULL);
INSERT INTO port VALUES (128, 4, '	192.168.2.87', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 128, NULL);
INSERT INTO port VALUES (129, 4, '	192.168.2.88', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 129, NULL);
INSERT INTO port VALUES (130, 4, '	192.168.2.89', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 130, NULL);
INSERT INTO port VALUES (131, 4, '	192.168.2.90', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 131, NULL);
INSERT INTO port VALUES (132, 4, '	192.168.2.91', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 132, NULL);
INSERT INTO port VALUES (133, 4, '	192.168.2.92', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 133, NULL);
INSERT INTO port VALUES (134, 4, '	192.168.2.93', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 134, NULL);
INSERT INTO port VALUES (135, 4, '	192.168.2.94', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 135, NULL);
INSERT INTO port VALUES (136, 4, '	192.168.2.95', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 136, NULL);
INSERT INTO port VALUES (137, 4, '	192.168.2.96', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 137, NULL);
INSERT INTO port VALUES (138, 4, '	192.168.2.97', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 138, NULL);
INSERT INTO port VALUES (139, 4, '	192.168.2.98', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 139, NULL);
INSERT INTO port VALUES (140, 4, '	192.168.2.99', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 140, NULL);
INSERT INTO port VALUES (141, 4, '	192.168.2.100', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 141, NULL);
INSERT INTO port VALUES (142, 4, '	192.168.2.101', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 142, NULL);
INSERT INTO port VALUES (143, 4, '	192.168.2.102', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 143, NULL);
INSERT INTO port VALUES (144, 4, '	192.168.2.103', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 144, NULL);
INSERT INTO port VALUES (145, 4, '	192.168.2.104', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 145, NULL);
INSERT INTO port VALUES (146, 4, '	192.168.2.105', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 146, NULL);
INSERT INTO port VALUES (147, 4, '	192.168.2.106', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 147, NULL);
INSERT INTO port VALUES (148, 4, '	192.168.2.107', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 148, NULL);
INSERT INTO port VALUES (149, 4, '	192.168.2.108', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 149, NULL);
INSERT INTO port VALUES (150, 4, '	192.168.2.109', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 150, NULL);
INSERT INTO port VALUES (151, 4, '	192.168.2.110', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 151, NULL);
INSERT INTO port VALUES (152, 4, '	192.168.2.111', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 152, NULL);
INSERT INTO port VALUES (153, 4, '	192.168.2.112', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 153, NULL);
INSERT INTO port VALUES (154, 4, '	192.168.2.113', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 154, NULL);
INSERT INTO port VALUES (155, 4, '	192.168.2.114', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 155, NULL);
INSERT INTO port VALUES (156, 4, '	192.168.2.115', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 156, NULL);
INSERT INTO port VALUES (157, 4, '	192.168.2.116', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 157, NULL);
INSERT INTO port VALUES (158, 4, '	192.168.2.117', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 158, NULL);
INSERT INTO port VALUES (159, 4, '	192.168.2.118', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 159, NULL);
INSERT INTO port VALUES (160, 4, '	192.168.2.119', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 160, NULL);
INSERT INTO port VALUES (161, 5, '	192.168.4.1', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 161, NULL);
INSERT INTO port VALUES (162, 5, '	192.168.4.2', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 162, NULL);
INSERT INTO port VALUES (163, 5, '	192.168.4.3', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 163, NULL);
INSERT INTO port VALUES (164, 5, '	192.168.4.4', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 164, NULL);
INSERT INTO port VALUES (165, 5, '	192.168.4.5', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 165, NULL);
INSERT INTO port VALUES (166, 5, '	192.168.4.6', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 166, NULL);
INSERT INTO port VALUES (167, 5, '	192.168.4.7', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 167, NULL);
INSERT INTO port VALUES (168, 5, '	192.168.4.8', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 168, NULL);
INSERT INTO port VALUES (169, 5, '	192.168.4.9', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 169, NULL);
INSERT INTO port VALUES (170, 5, '	192.168.4.10', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 170, NULL);
INSERT INTO port VALUES (171, 5, '	192.168.4.11', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 171, NULL);
INSERT INTO port VALUES (172, 5, '	192.168.4.12', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 172, NULL);
INSERT INTO port VALUES (173, 5, '	192.168.4.13', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 173, NULL);
INSERT INTO port VALUES (174, 5, '	192.168.4.14', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 174, NULL);
INSERT INTO port VALUES (175, 5, '	192.168.4.15', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 175, NULL);
INSERT INTO port VALUES (176, 5, '	192.168.4.16', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 176, NULL);
INSERT INTO port VALUES (177, 5, '	192.168.4.17', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 177, NULL);
INSERT INTO port VALUES (178, 5, '	192.168.4.18', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 178, NULL);
INSERT INTO port VALUES (179, 5, '	192.168.4.19', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 179, NULL);
INSERT INTO port VALUES (180, 5, '	192.168.4.20', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 180, NULL);
INSERT INTO port VALUES (181, 5, '	192.168.4.21', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 181, NULL);
INSERT INTO port VALUES (182, 5, '	192.168.4.22', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 182, NULL);
INSERT INTO port VALUES (183, 5, '	192.168.4.23', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 183, NULL);
INSERT INTO port VALUES (184, 5, '	192.168.4.24', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 184, NULL);
INSERT INTO port VALUES (185, 5, '	192.168.4.25', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 185, NULL);
INSERT INTO port VALUES (186, 5, '	192.168.4.26', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 186, NULL);
INSERT INTO port VALUES (187, 5, '	192.168.4.27', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 187, NULL);
INSERT INTO port VALUES (188, 5, '	192.168.4.28', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 188, NULL);
INSERT INTO port VALUES (189, 5, '	192.168.4.29', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 189, NULL);
INSERT INTO port VALUES (190, 5, '	192.168.4.30', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 190, NULL);
INSERT INTO port VALUES (191, 5, '	192.168.4.31', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 191, NULL);
INSERT INTO port VALUES (192, 5, '	192.168.4.32', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 192, NULL);
INSERT INTO port VALUES (193, 5, '	192.168.4.33', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 193, NULL);
INSERT INTO port VALUES (194, 5, '	192.168.4.34', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 194, NULL);
INSERT INTO port VALUES (195, 5, '	192.168.4.35', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 195, NULL);
INSERT INTO port VALUES (196, 5, '	192.168.4.36', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 196, NULL);
INSERT INTO port VALUES (197, 5, '	192.168.4.37', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 197, NULL);
INSERT INTO port VALUES (198, 5, '	192.168.4.38', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 198, NULL);
INSERT INTO port VALUES (199, 5, '	192.168.4.39', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 199, NULL);
INSERT INTO port VALUES (200, 5, '	192.168.4.40', '	255.255.255.0', '	192.168.4.254', '	152.23.142.27', '	152.23.142.28', 200, NULL);
INSERT INTO port VALUES (201, 6, '	192.168.4.80', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 201, NULL);
INSERT INTO port VALUES (202, 6, '	192.168.4.81', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 202, NULL);
INSERT INTO port VALUES (203, 6, '	192.168.4.82', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 203, NULL);
INSERT INTO port VALUES (204, 6, '	192.168.4.83', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 204, NULL);
INSERT INTO port VALUES (205, 6, '	192.168.4.84', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 205, NULL);
INSERT INTO port VALUES (206, 6, '	192.168.4.85', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 206, NULL);
INSERT INTO port VALUES (207, 6, '	192.168.4.86', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 207, NULL);
INSERT INTO port VALUES (208, 6, '	192.168.4.87', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 208, NULL);
INSERT INTO port VALUES (209, 6, '	192.168.4.88', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 209, NULL);
INSERT INTO port VALUES (210, 6, '	192.168.4.89', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 210, NULL);
INSERT INTO port VALUES (211, 6, '	192.168.4.90', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 211, NULL);
INSERT INTO port VALUES (212, 6, '	192.168.4.91', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 212, NULL);
INSERT INTO port VALUES (213, 6, '	192.168.4.92', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 213, NULL);
INSERT INTO port VALUES (214, 6, '	192.168.4.93', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 214, NULL);
INSERT INTO port VALUES (215, 6, '	192.168.4.94', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 215, NULL);
INSERT INTO port VALUES (216, 6, '	192.168.4.95', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 216, NULL);
INSERT INTO port VALUES (217, 6, '	192.168.4.96', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 217, NULL);
INSERT INTO port VALUES (218, 6, '	192.168.4.97', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 218, NULL);
INSERT INTO port VALUES (219, 6, '	192.168.4.98', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 219, NULL);
INSERT INTO port VALUES (220, 6, '	192.168.4.99', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 220, NULL);
INSERT INTO port VALUES (221, 6, '	192.168.4.100', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 221, NULL);
INSERT INTO port VALUES (222, 6, '	192.168.4.101', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 222, NULL);
INSERT INTO port VALUES (223, 6, '	192.168.4.102', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 223, NULL);
INSERT INTO port VALUES (224, 6, '	192.168.4.103', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 224, NULL);
INSERT INTO port VALUES (225, 6, '	192.168.4.104', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 225, NULL);
INSERT INTO port VALUES (226, 6, '	192.168.4.105', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 226, NULL);
INSERT INTO port VALUES (227, 6, '	192.168.4.106', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 227, NULL);
INSERT INTO port VALUES (228, 6, '	192.168.4.107', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 228, NULL);
INSERT INTO port VALUES (229, 6, '	192.168.4.108', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 229, NULL);
INSERT INTO port VALUES (230, 6, '	192.168.4.109', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 230, NULL);
INSERT INTO port VALUES (231, 6, '	192.168.4.110', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 231, NULL);
INSERT INTO port VALUES (232, 6, '	192.168.4.111', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 232, NULL);
INSERT INTO port VALUES (233, 6, '	192.168.4.112', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 233, NULL);
INSERT INTO port VALUES (234, 6, '	192.168.4.113', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 234, NULL);
INSERT INTO port VALUES (235, 6, '	192.168.4.114', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 235, NULL);
INSERT INTO port VALUES (236, 6, '	192.168.4.115', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 236, NULL);
INSERT INTO port VALUES (237, 6, '	192.168.4.116', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 237, NULL);
INSERT INTO port VALUES (238, 6, '	192.168.4.117', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 238, NULL);
INSERT INTO port VALUES (239, 6, '	192.168.4.118', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 239, NULL);
INSERT INTO port VALUES (240, 6, '	192.168.4.119', '	255.255.255.0', '	192.168.2.254', '	152.23.142.27', '	152.23.142.28', 240, NULL);
INSERT INTO port VALUES (241, 7, '	192.168.3.1', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 241, NULL);
INSERT INTO port VALUES (242, 7, '	192.168.3.2', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 242, NULL);
INSERT INTO port VALUES (243, 7, '	192.168.3.3', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 243, NULL);
INSERT INTO port VALUES (244, 7, '	192.168.3.4', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 244, NULL);
INSERT INTO port VALUES (245, 7, '	192.168.3.5', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 245, NULL);
INSERT INTO port VALUES (246, 7, '	192.168.3.6', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 246, NULL);
INSERT INTO port VALUES (247, 7, '	192.168.3.7', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 247, NULL);
INSERT INTO port VALUES (248, 7, '	192.168.3.8', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 248, NULL);
INSERT INTO port VALUES (249, 7, '	192.168.3.9', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 249, NULL);
INSERT INTO port VALUES (250, 7, '	192.168.3.10', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 250, NULL);
INSERT INTO port VALUES (251, 7, '	192.168.3.11', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 251, NULL);
INSERT INTO port VALUES (252, 7, '	192.168.3.12', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 252, NULL);
INSERT INTO port VALUES (253, 7, '	192.168.3.13', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 253, NULL);
INSERT INTO port VALUES (254, 7, '	192.168.3.14', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 254, NULL);
INSERT INTO port VALUES (255, 7, '	192.168.3.15', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 255, NULL);
INSERT INTO port VALUES (256, 7, '	192.168.3.16', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 256, NULL);
INSERT INTO port VALUES (257, 7, '	192.168.3.17', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 257, NULL);
INSERT INTO port VALUES (258, 7, '	192.168.3.18', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 258, NULL);
INSERT INTO port VALUES (259, 7, '	192.168.3.19', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 259, NULL);
INSERT INTO port VALUES (260, 7, '	192.168.3.20', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 260, NULL);
INSERT INTO port VALUES (261, 7, '	192.168.3.21', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 261, NULL);
INSERT INTO port VALUES (262, 7, '	192.168.3.22', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 262, NULL);
INSERT INTO port VALUES (263, 7, '	192.168.3.23', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 263, NULL);
INSERT INTO port VALUES (264, 7, '	192.168.3.24', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 264, NULL);
INSERT INTO port VALUES (265, 7, '	192.168.3.25', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 265, NULL);
INSERT INTO port VALUES (266, 7, '	192.168.3.26', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 266, NULL);
INSERT INTO port VALUES (267, 7, '	192.168.3.27', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 267, NULL);
INSERT INTO port VALUES (268, 7, '	192.168.3.28', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 268, NULL);
INSERT INTO port VALUES (269, 7, '	192.168.3.29', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 269, NULL);
INSERT INTO port VALUES (270, 7, '	192.168.3.30', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 270, NULL);
INSERT INTO port VALUES (271, 7, '	192.168.3.31', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 271, NULL);
INSERT INTO port VALUES (272, 7, '	192.168.3.32', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 272, NULL);
INSERT INTO port VALUES (273, 7, '	192.168.3.33', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 273, NULL);
INSERT INTO port VALUES (274, 7, '	192.168.3.34', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 274, NULL);
INSERT INTO port VALUES (275, 7, '	192.168.3.35', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 275, NULL);
INSERT INTO port VALUES (276, 7, '	192.168.3.36', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 276, NULL);
INSERT INTO port VALUES (277, 7, '	192.168.3.37', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 277, NULL);
INSERT INTO port VALUES (278, 7, '	192.168.3.38', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 278, NULL);
INSERT INTO port VALUES (279, 7, '	192.168.3.39', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 279, NULL);
INSERT INTO port VALUES (280, 7, '	192.168.3.40', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 280, NULL);
INSERT INTO port VALUES (281, 8, '	192.168.3.80', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 281, NULL);
INSERT INTO port VALUES (282, 8, '	192.168.3.81', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 282, NULL);
INSERT INTO port VALUES (283, 8, '	192.168.3.82', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 283, NULL);
INSERT INTO port VALUES (284, 8, '	192.168.3.83', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 284, NULL);
INSERT INTO port VALUES (285, 8, '	192.168.3.84', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 285, NULL);
INSERT INTO port VALUES (286, 8, '	192.168.3.85', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 286, NULL);
INSERT INTO port VALUES (287, 8, '	192.168.3.86', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 287, NULL);
INSERT INTO port VALUES (288, 8, '	192.168.3.87', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 288, NULL);
INSERT INTO port VALUES (289, 8, '	192.168.3.88', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 289, NULL);
INSERT INTO port VALUES (290, 8, '	192.168.3.89', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 290, NULL);
INSERT INTO port VALUES (291, 8, '	192.168.3.90', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 291, NULL);
INSERT INTO port VALUES (292, 8, '	192.168.3.91', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 292, NULL);
INSERT INTO port VALUES (293, 8, '	192.168.3.92', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 293, NULL);
INSERT INTO port VALUES (294, 8, '	192.168.3.93', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 294, NULL);
INSERT INTO port VALUES (295, 8, '	192.168.3.94', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 295, NULL);
INSERT INTO port VALUES (296, 8, '	192.168.3.95', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 296, NULL);
INSERT INTO port VALUES (297, 8, '	192.168.3.96', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 297, NULL);
INSERT INTO port VALUES (298, 8, '	192.168.3.97', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 298, NULL);
INSERT INTO port VALUES (299, 8, '	192.168.3.98', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 299, NULL);
INSERT INTO port VALUES (300, 8, '	192.168.3.99', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 300, NULL);
INSERT INTO port VALUES (301, 8, '	192.168.3.100', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 301, NULL);
INSERT INTO port VALUES (302, 8, '	192.168.3.101', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 302, NULL);
INSERT INTO port VALUES (303, 8, '	192.168.3.102', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 303, NULL);
INSERT INTO port VALUES (304, 8, '	192.168.3.103', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 304, NULL);
INSERT INTO port VALUES (305, 8, '	192.168.3.104', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 305, NULL);
INSERT INTO port VALUES (306, 8, '	192.168.3.105', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 306, NULL);
INSERT INTO port VALUES (307, 8, '	192.168.3.106', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 307, NULL);
INSERT INTO port VALUES (308, 8, '	192.168.3.107', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 308, NULL);
INSERT INTO port VALUES (309, 8, '	192.168.3.108', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 309, NULL);
INSERT INTO port VALUES (310, 8, '	192.168.3.109', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 310, NULL);
INSERT INTO port VALUES (311, 8, '	192.168.3.110', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 311, NULL);
INSERT INTO port VALUES (312, 8, '	192.168.3.111', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 312, NULL);
INSERT INTO port VALUES (313, 8, '	192.168.3.112', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 313, NULL);
INSERT INTO port VALUES (314, 8, '	192.168.3.113', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 314, NULL);
INSERT INTO port VALUES (315, 8, '	192.168.3.114', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 315, NULL);
INSERT INTO port VALUES (316, 8, '	192.168.3.115', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 316, NULL);
INSERT INTO port VALUES (317, 8, '	192.168.3.116', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 317, NULL);
INSERT INTO port VALUES (318, 8, '	192.168.3.117', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 318, NULL);
INSERT INTO port VALUES (319, 8, '	192.168.3.118', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 319, NULL);
INSERT INTO port VALUES (320, 8, '	192.168.3.119', '	255.255.255.0', '	192.168.3.254', '	152.23.142.27', '	152.23.142.28', 320, NULL);


--
-- TOC entry 2121 (class 0 OID 0)
-- Dependencies: 182
-- Name: port_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('port_seq_seq', 1, false);


--
-- TOC entry 2096 (class 0 OID 16404)
-- Dependencies: 175
-- Data for Name: room; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO room VALUES (1, '자101', 1, NULL);
INSERT INTO room VALUES (2, '자202', 1, NULL);
INSERT INTO room VALUES (3, '상101', 2, NULL);
INSERT INTO room VALUES (4, '상202', 2, NULL);
INSERT INTO room VALUES (5, '사101', 3, NULL);
INSERT INTO room VALUES (6, '사202', 3, NULL);
INSERT INTO room VALUES (7, '종101', 4, NULL);
INSERT INTO room VALUES (8, '종202', 4, NULL);


--
-- TOC entry 2122 (class 0 OID 0)
-- Dependencies: 174
-- Name: room_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('room_seq_seq', 1, false);


--
-- TOC entry 2100 (class 0 OID 16433)
-- Dependencies: 179
-- Data for Name: router; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO router VALUES (1, '	192.168.1.254', '	192.168.1.0', '	255.255.255.0', '	152.23.142.27', '	152.23.142.28', 1, 1, '	Ja1_Router');
INSERT INTO router VALUES (2, '	192.168.2.254', '	192.168.2.0', '	255.255.255.0', '	152.23.142.27', '	152.23.142.28', 2, 3, '	S1_Router');
INSERT INTO router VALUES (3, '	192.168.3.254', '	192.168.3.0', '	255.255.255.0', '	152.23.142.27', '	152.23.142.28', 3, 5, '	SH1_Router');
INSERT INTO router VALUES (4, '	192.168.4.254', '	192.168.4.0', '	255.255.255.0', '	152.23.142.27', '	152.23.142.28', 4, 7, '	Jong1_Router');


--
-- TOC entry 2123 (class 0 OID 0)
-- Dependencies: 178
-- Name: router_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('router_seq_seq', 1, false);


--
-- TOC entry 2102 (class 0 OID 16454)
-- Dependencies: 181
-- Data for Name: switch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO switch VALUES (1, 1, '	192.168.1.252', '	255.255.255.0', 1, '	Ja1_Switch');
INSERT INTO switch VALUES (2, 1, '	192.168.1.253', '	255.255.255.0', 2, '	Ja2_Switch');
INSERT INTO switch VALUES (3, 2, '	192.168.2.252', '	255.255.255.0', 3, '	S1_Switch');
INSERT INTO switch VALUES (4, 2, '	192.168.2.253', '	255.255.255.0', 4, '	S2_Switch');
INSERT INTO switch VALUES (5, 3, '	192.168.3.252', '	255.255.255.0', 5, '	SH1_Switch');
INSERT INTO switch VALUES (6, 3, '	192.168.3.253', '	255.255.255.0', 6, '	SH2_Switch');
INSERT INTO switch VALUES (7, 4, '	192.168.4.252', '	255.255.255.0', 7, '	Jong1_Switch');
INSERT INTO switch VALUES (8, 4, '	192.168.4.253', '	255.255.255.0', 8, '	Jong2_Switch');


--
-- TOC entry 2124 (class 0 OID 0)
-- Dependencies: 180
-- Name: switch_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('switch_seq_seq', 1, false);


--
-- TOC entry 1960 (class 2606 OID 16401)
-- Name: building_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY building
    ADD CONSTRAINT building_pkey PRIMARY KEY (seq);


--
-- TOC entry 1964 (class 2606 OID 16425)
-- Name: pc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pc
    ADD CONSTRAINT pc_pkey PRIMARY KEY (seq);


--
-- TOC entry 1970 (class 2606 OID 16478)
-- Name: port_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_pkey PRIMARY KEY (seq);


--
-- TOC entry 1962 (class 2606 OID 16409)
-- Name: room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY room
    ADD CONSTRAINT room_pkey PRIMARY KEY (seq);


--
-- TOC entry 1966 (class 2606 OID 16441)
-- Name: router_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_pkey PRIMARY KEY (seq);


--
-- TOC entry 1968 (class 2606 OID 16462)
-- Name: switch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY switch
    ADD CONSTRAINT switch_pkey PRIMARY KEY (seq);


--
-- TOC entry 1972 (class 2606 OID 16426)
-- Name: pc_room_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc
    ADD CONSTRAINT pc_room_seq_fkey FOREIGN KEY (room_seq) REFERENCES room(seq);


--
-- TOC entry 1977 (class 2606 OID 16484)
-- Name: port_pc_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_pc_seq_fkey FOREIGN KEY (pc_seq) REFERENCES pc(seq);


--
-- TOC entry 1976 (class 2606 OID 16479)
-- Name: port_switch_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_switch_seq_fkey FOREIGN KEY (switch_seq) REFERENCES switch(seq);


--
-- TOC entry 1971 (class 2606 OID 16410)
-- Name: room_building_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY room
    ADD CONSTRAINT room_building_seq_fkey FOREIGN KEY (building_seq) REFERENCES building(seq);


--
-- TOC entry 1973 (class 2606 OID 16442)
-- Name: router_building_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_building_seq_fkey FOREIGN KEY (building_seq) REFERENCES building(seq);


--
-- TOC entry 1974 (class 2606 OID 16447)
-- Name: router_room_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_room_seq_fkey FOREIGN KEY (room_seq) REFERENCES room(seq);


--
-- TOC entry 1975 (class 2606 OID 16463)
-- Name: switch_router_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY switch
    ADD CONSTRAINT switch_router_seq_fkey FOREIGN KEY (router_seq) REFERENCES router(seq);


--
-- TOC entry 2111 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-07-22 13:17:52

--
-- PostgreSQL database dump complete
--

