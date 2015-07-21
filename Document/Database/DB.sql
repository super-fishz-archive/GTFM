--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.4
-- Dumped by pg_dump version 9.4.4
-- Started on 2015-07-21 19:39:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 189 (class 3079 OID 11855)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2104 (class 0 OID 0)
-- Dependencies: 189
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 177 (class 1259 OID 24828)
-- Name: pc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pc (
    seq integer NOT NULL,
    room_seq integer,
    memo character varying(100)
);


ALTER TABLE pc OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 24878)
-- Name: port; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE port (
    seq integer NOT NULL,
    switch_seq integer,
    ip cidr,
    subnet_mask cidr,
    default_gateway cidr,
    dns_server cidr,
    sub_dns_server cidr,
    pc_seq integer,
    memo character varying(100)
);


ALTER TABLE port OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 24815)
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
-- TOC entry 186 (class 1259 OID 24932)
-- Name: pc_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW pc_list AS
 SELECT pc.seq,
    room.room_name,
    port.ip
   FROM ((pc
     JOIN room ON ((pc.room_seq = room.seq)))
     JOIN port ON ((port.pc_seq = pc.seq)));


ALTER TABLE pc_list OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 24936)
-- Name: building_pc_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION building_pc_list(integer) RETURNS SETOF pc_list
    LANGUAGE sql
    AS $_$
	select pc_list.seq, pc_list.room_name, pc_list.ip
	from pc_list join pc
	on pc_list.seq = pc.seq
	join room
	on pc.room_seq = room.seq
	where room.building_seq = $1;
$_$;


ALTER FUNCTION public.building_pc_list(integer) OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 24841)
-- Name: router; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE router (
    seq integer NOT NULL,
    ip cidr,
    default_gateway cidr,
    dns_server cidr,
    subnet_mask cidr,
    physical_range character varying(40),
    building_seq integer,
    room_seq integer,
    memo character varying(100)
);


ALTER TABLE router OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 24922)
-- Name: router_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW router_list AS
 SELECT router.seq,
    router.ip,
    router.subnet_mask,
    room.room_name
   FROM (router
     JOIN room ON ((router.room_seq = room.seq)));


ALTER TABLE router_list OWNER TO postgres;

--
-- TOC entry 202 (class 1255 OID 24926)
-- Name: building_router_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION building_router_list(integer) RETURNS SETOF router_list
    LANGUAGE sql
    AS $_$
	select router_list.seq, router_list.ip, router_list.subnet_mask, router_list.room_name
	from router_list join router on router_list.seq = router.seq
	where router.building_seq = $1;
$_$;


ALTER FUNCTION public.building_router_list(integer) OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 24862)
-- Name: switch; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE switch (
    seq integer NOT NULL,
    router_seq integer,
    ip cidr,
    memo character varying(100)
);


ALTER TABLE switch OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 24927)
-- Name: switch_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW switch_list AS
 SELECT switch.seq,
    switch.ip,
    room.room_name
   FROM ((switch
     JOIN router ON ((switch.router_seq = router.seq)))
     JOIN room ON ((router.room_seq = room.seq)));


ALTER TABLE switch_list OWNER TO postgres;

--
-- TOC entry 203 (class 1255 OID 24931)
-- Name: building_switch_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION building_switch_list(integer) RETURNS SETOF switch_list
    LANGUAGE sql
    AS $_$
	select switch_list.seq, switch_list.ip, switch_list.room_name
	from switch_list join switch on switch_list.seq = switch.seq
	join router on switch.router_seq = router.seq
	where router.building_seq = $1;
$_$;


ALTER FUNCTION public.building_switch_list(integer) OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 24937)
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
-- TOC entry 210 (class 1255 OID 24948)
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
-- TOC entry 212 (class 1255 OID 24939)
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
-- TOC entry 206 (class 1255 OID 24938)
-- Name: insert_pc(integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_pc(a integer, b integer, c character varying, d integer) RETURNS void
    LANGUAGE sql
    AS $$
	insert into pc(seq, room_seq, memo)
	values (a, b, c);
	update port
	set pc_seq = a
	where seq = d;	
$$;


ALTER FUNCTION public.insert_pc(a integer, b integer, c character varying, d integer) OWNER TO postgres;

--
-- TOC entry 208 (class 1255 OID 24941)
-- Name: not_using_ip(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION not_using_ip() RETURNS SETOF cidr
    LANGUAGE sql
    AS $$
	select ip
	from port
	where pc_seq is null;
$$;


ALTER FUNCTION public.not_using_ip() OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 24947)
-- Name: router_info(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION router_info(integer) RETURNS TABLE(ip cidr, default_gateway cidr, subnet_mask cidr, location text)
    LANGUAGE sql
    AS $_$
	select router.ip, router.default_gateway, router.subnet_mask, building.building_name ||' '|| room.room_name as location
	from router join building
	on router.building_seq = building.seq
	join room
	on router.room_seq = room.seq
	where router.seq = $1;
$_$;


ALTER FUNCTION public.router_info(integer) OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 24970)
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
-- TOC entry 213 (class 1255 OID 24974)
-- Name: search_ip(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_ip(text) RETURNS SETOF searched_ip
    LANGUAGE sql
    AS $_$
	select *
	from searched_ip
	where abbrev(ip) like '%'||$1||'%';
$_$;


ALTER FUNCTION public.search_ip(text) OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 24949)
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
-- TOC entry 211 (class 1255 OID 24953)
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
-- TOC entry 207 (class 1255 OID 24940)
-- Name: using_ip(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION using_ip() RETURNS SETOF cidr
    LANGUAGE sql
    AS $$
	select ip
	from port
	where pc_seq is not null;
$$;


ALTER FUNCTION public.using_ip() OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 24807)
-- Name: building; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE building (
    seq integer NOT NULL,
    building_name character varying(15)
);


ALTER TABLE building OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 24805)
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
-- TOC entry 2105 (class 0 OID 0)
-- Dependencies: 172
-- Name: building_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE building_seq_seq OWNED BY building.seq;


--
-- TOC entry 176 (class 1259 OID 24826)
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
-- TOC entry 2106 (class 0 OID 0)
-- Dependencies: 176
-- Name: pc_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pc_seq_seq OWNED BY pc.seq;


--
-- TOC entry 182 (class 1259 OID 24876)
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
-- TOC entry 2107 (class 0 OID 0)
-- Dependencies: 182
-- Name: port_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE port_seq_seq OWNED BY port.seq;


--
-- TOC entry 174 (class 1259 OID 24813)
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
-- TOC entry 2108 (class 0 OID 0)
-- Dependencies: 174
-- Name: room_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE room_seq_seq OWNED BY room.seq;


--
-- TOC entry 178 (class 1259 OID 24839)
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
-- TOC entry 2109 (class 0 OID 0)
-- Dependencies: 178
-- Name: router_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE router_seq_seq OWNED BY router.seq;


--
-- TOC entry 180 (class 1259 OID 24860)
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
-- TOC entry 2110 (class 0 OID 0)
-- Dependencies: 180
-- Name: switch_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE switch_seq_seq OWNED BY switch.seq;


--
-- TOC entry 1946 (class 2604 OID 24810)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY building ALTER COLUMN seq SET DEFAULT nextval('building_seq_seq'::regclass);


--
-- TOC entry 1948 (class 2604 OID 24831)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc ALTER COLUMN seq SET DEFAULT nextval('pc_seq_seq'::regclass);


--
-- TOC entry 1951 (class 2604 OID 24881)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port ALTER COLUMN seq SET DEFAULT nextval('port_seq_seq'::regclass);


--
-- TOC entry 1947 (class 2604 OID 24818)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY room ALTER COLUMN seq SET DEFAULT nextval('room_seq_seq'::regclass);


--
-- TOC entry 1949 (class 2604 OID 24844)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router ALTER COLUMN seq SET DEFAULT nextval('router_seq_seq'::regclass);


--
-- TOC entry 1950 (class 2604 OID 24865)
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY switch ALTER COLUMN seq SET DEFAULT nextval('switch_seq_seq'::regclass);


--
-- TOC entry 2086 (class 0 OID 24807)
-- Dependencies: 173
-- Data for Name: building; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY building (seq, building_name) FROM stdin;
1	자연과학대
2	상허연구동
\.


--
-- TOC entry 2111 (class 0 OID 0)
-- Dependencies: 172
-- Name: building_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('building_seq_seq', 1, false);


--
-- TOC entry 2090 (class 0 OID 24828)
-- Dependencies: 177
-- Data for Name: pc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pc (seq, room_seq, memo) FROM stdin;
1	1	\N
2	1	\N
3	2	\N
4	2	\N
5	3	\N
6	3	\N
7	4	\N
8	4	\N
\.


--
-- TOC entry 2112 (class 0 OID 0)
-- Dependencies: 176
-- Name: pc_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_seq_seq', 1, false);


--
-- TOC entry 2096 (class 0 OID 24878)
-- Dependencies: 183
-- Data for Name: port; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY port (seq, switch_seq, ip, subnet_mask, default_gateway, dns_server, sub_dns_server, pc_seq, memo) FROM stdin;
1	1	100.100.102.101/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	1	\N
2	1	100.100.102.102/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	2	\N
3	1	100.100.102.103/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	\N	\N
4	2	100.100.102.104/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	3	\N
5	2	100.100.102.105/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	4	\N
6	2	100.100.102.106/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	\N	\N
7	3	100.100.102.107/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	5	\N
8	3	100.100.102.108/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	6	\N
9	3	100.100.102.109/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	\N	\N
10	4	100.100.102.110/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	7	\N
11	4	100.100.102.111/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	8	\N
12	4	100.100.102.112/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	\N	\N
\.


--
-- TOC entry 2113 (class 0 OID 0)
-- Dependencies: 182
-- Name: port_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('port_seq_seq', 1, false);


--
-- TOC entry 2088 (class 0 OID 24815)
-- Dependencies: 175
-- Data for Name: room; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY room (seq, room_name, building_seq, memo) FROM stdin;
1	101호	1	\N
2	201호	1	\N
3	101호	2	\N
4	201호	2	\N
\.


--
-- TOC entry 2114 (class 0 OID 0)
-- Dependencies: 174
-- Name: room_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('room_seq_seq', 1, false);


--
-- TOC entry 2092 (class 0 OID 24841)
-- Dependencies: 179
-- Data for Name: router; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY router (seq, ip, default_gateway, dns_server, subnet_mask, physical_range, building_seq, room_seq, memo) FROM stdin;
1	100.100.100.101/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	자연과학대 1층	1	1	\N
2	100.100.100.102/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	자연과학대 2층	1	2	\N
3	100.100.100.103/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	상허연구동 1층	2	3	\N
4	100.100.100.104/32	255.255.255.0/32	255.255.255.0/32	255.255.255.0/32	상허연구동 2층	2	4	\N
\.


--
-- TOC entry 2115 (class 0 OID 0)
-- Dependencies: 178
-- Name: router_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('router_seq_seq', 1, false);


--
-- TOC entry 2094 (class 0 OID 24862)
-- Dependencies: 181
-- Data for Name: switch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY switch (seq, router_seq, ip, memo) FROM stdin;
1	1	100.100.101.101/32	\N
2	1	100.100.101.102/32	\N
3	2	100.100.101.103/32	\N
4	2	100.100.101.104/32	\N
5	3	100.100.101.105/32	\N
6	3	100.100.101.106/32	\N
7	4	100.100.101.107/32	\N
8	4	100.100.101.108/32	\N
\.


--
-- TOC entry 2116 (class 0 OID 0)
-- Dependencies: 180
-- Name: switch_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('switch_seq_seq', 1, false);


--
-- TOC entry 1953 (class 2606 OID 24812)
-- Name: building_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY building
    ADD CONSTRAINT building_pkey PRIMARY KEY (seq);


--
-- TOC entry 1957 (class 2606 OID 24833)
-- Name: pc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pc
    ADD CONSTRAINT pc_pkey PRIMARY KEY (seq);


--
-- TOC entry 1963 (class 2606 OID 24886)
-- Name: port_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_pkey PRIMARY KEY (seq);


--
-- TOC entry 1955 (class 2606 OID 24820)
-- Name: room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY room
    ADD CONSTRAINT room_pkey PRIMARY KEY (seq);


--
-- TOC entry 1959 (class 2606 OID 24849)
-- Name: router_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_pkey PRIMARY KEY (seq);


--
-- TOC entry 1961 (class 2606 OID 24870)
-- Name: switch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY switch
    ADD CONSTRAINT switch_pkey PRIMARY KEY (seq);


--
-- TOC entry 1965 (class 2606 OID 24834)
-- Name: pc_room_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc
    ADD CONSTRAINT pc_room_seq_fkey FOREIGN KEY (room_seq) REFERENCES room(seq);


--
-- TOC entry 1970 (class 2606 OID 24892)
-- Name: port_pc_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_pc_seq_fkey FOREIGN KEY (pc_seq) REFERENCES pc(seq);


--
-- TOC entry 1969 (class 2606 OID 24887)
-- Name: port_switch_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_switch_seq_fkey FOREIGN KEY (switch_seq) REFERENCES switch(seq);


--
-- TOC entry 1964 (class 2606 OID 24821)
-- Name: room_building_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY room
    ADD CONSTRAINT room_building_seq_fkey FOREIGN KEY (building_seq) REFERENCES building(seq);


--
-- TOC entry 1966 (class 2606 OID 24850)
-- Name: router_building_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_building_seq_fkey FOREIGN KEY (building_seq) REFERENCES building(seq);


--
-- TOC entry 1967 (class 2606 OID 24855)
-- Name: router_room_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_room_seq_fkey FOREIGN KEY (room_seq) REFERENCES room(seq);


--
-- TOC entry 1968 (class 2606 OID 24871)
-- Name: switch_router_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY switch
    ADD CONSTRAINT switch_router_seq_fkey FOREIGN KEY (router_seq) REFERENCES router(seq);


--
-- TOC entry 2103 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-07-21 19:39:09

--
-- PostgreSQL database dump complete
--

