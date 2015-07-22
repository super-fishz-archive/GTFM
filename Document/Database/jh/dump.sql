--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: pc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pc (
    seq integer NOT NULL,
    room_seq integer,
    name text
);


ALTER TABLE pc OWNER TO postgres;

--
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
-- Name: building; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE building (
    seq integer NOT NULL,
    building_name character varying(15)
);


ALTER TABLE building OWNER TO postgres;

--
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
-- Name: building_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE building_seq_seq OWNED BY building.seq;


--
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
-- Name: pc_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pc_seq_seq OWNED BY pc.seq;


--
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
-- Name: port_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE port_seq_seq OWNED BY port.seq;


--
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
-- Name: room_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE room_seq_seq OWNED BY room.seq;


--
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
-- Name: router_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE router_seq_seq OWNED BY router.seq;


--
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
-- Name: switch_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE switch_seq_seq OWNED BY switch.seq;


--
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY building ALTER COLUMN seq SET DEFAULT nextval('building_seq_seq'::regclass);


--
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc ALTER COLUMN seq SET DEFAULT nextval('pc_seq_seq'::regclass);


--
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port ALTER COLUMN seq SET DEFAULT nextval('port_seq_seq'::regclass);


--
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY room ALTER COLUMN seq SET DEFAULT nextval('room_seq_seq'::regclass);


--
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router ALTER COLUMN seq SET DEFAULT nextval('router_seq_seq'::regclass);


--
-- Name: seq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY switch ALTER COLUMN seq SET DEFAULT nextval('switch_seq_seq'::regclass);


--
-- Data for Name: building; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY building (seq, building_name) FROM stdin;
1	자연과학대
2	상허연구동
3	사회과학대
4	종합강의동
\.


--
-- Name: building_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('building_seq_seq', 1, false);


--
-- Data for Name: pc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pc (seq, room_seq, name) FROM stdin;
1	1	Ja101_1\t
2	1	Ja101_2\t
3	1	Ja101_3\t
4	1	Ja101_4\t
5	1	Ja101_5\t
6	1	Ja101_6\t
7	1	Ja101_7\t
8	1	Ja101_8\t
9	1	Ja101_9\t
10	1	Ja101_10\t
11	1	Ja101_11\t
12	1	Ja101_12\t
13	1	Ja101_13\t
14	1	Ja101_14\t
15	1	Ja101_15\t
16	1	Ja101_16\t
17	1	Ja101_17\t
18	1	Ja101_18\t
19	1	Ja101_19\t
20	1	Ja101_20\t
21	1	Ja101_21\t
22	1	Ja101_22\t
23	1	Ja101_23\t
24	1	Ja101_24\t
25	1	Ja101_25\t
26	1	Ja101_26\t
27	1	Ja101_27\t
28	1	Ja101_28\t
29	1	Ja101_29\t
30	1	Ja101_30\t
31	1	Ja101_31\t
32	1	Ja101_32\t
33	1	Ja101_33\t
34	1	Ja101_34\t
35	1	Ja101_35\t
36	1	Ja101_36\t
37	1	Ja101_37\t
38	1	Ja101_38\t
39	1	Ja101_39\t
40	1	Ja101_40\t
41	2	JA202_1\t
42	2	JA202_2\t
43	2	JA202_3\t
44	2	JA202_4\t
45	2	JA202_5\t
46	2	JA202_6\t
47	2	JA202_7\t
48	2	JA202_8\t
49	2	JA202_9\t
50	2	JA202_10\t
51	2	JA202_11\t
52	2	JA202_12\t
53	2	JA202_13\t
54	2	JA202_14\t
55	2	JA202_15\t
56	2	JA202_16\t
57	2	JA202_17\t
58	2	JA202_18\t
59	2	JA202_19\t
60	2	JA202_20\t
61	2	JA202_21\t
62	2	JA202_22\t
63	2	JA202_23\t
64	2	JA202_24\t
65	2	JA202_25\t
66	2	JA202_26\t
67	2	JA202_27\t
68	2	JA202_28\t
69	2	JA202_29\t
70	2	JA202_30\t
71	2	JA202_31\t
72	2	JA202_32\t
73	2	JA202_33\t
74	2	JA202_34\t
75	2	JA202_35\t
76	2	JA202_36\t
77	2	JA202_37\t
78	2	JA202_38\t
79	2	JA202_39\t
80	2	JA202_40\t
81	3	\tS101_1
82	3	\tS101_2
83	3	\tS101_3
84	3	\tS101_4
85	3	\tS101_5
86	3	\tS101_6
87	3	\tS101_7
88	3	\tS101_8
89	3	\tS101_9
90	3	\tS101_10
91	3	\tS101_11
92	3	\tS101_12
93	3	\tS101_13
94	3	\tS101_14
95	3	\tS101_15
96	3	\tS101_16
97	3	\tS101_17
98	3	\tS101_18
99	3	\tS101_19
100	3	\tS101_20
101	3	\tS101_21
102	3	\tS101_22
103	3	\tS101_23
104	3	\tS101_24
105	3	\tS101_25
106	3	\tS101_26
107	3	\tS101_27
108	3	\tS101_28
109	3	\tS101_29
110	3	\tS101_30
111	3	\tS101_31
112	3	\tS101_32
113	3	\tS101_33
114	3	\tS101_34
115	3	\tS101_35
116	3	\tS101_36
117	3	\tS101_37
118	3	\tS101_38
119	3	\tS101_39
120	3	\tS101_40
121	4	\tS202_1
122	4	\tS202_2
123	4	\tS202_3
124	4	\tS202_4
125	4	\tS202_5
126	4	\tS202_6
127	4	\tS202_7
128	4	\tS202_8
129	4	\tS202_9
130	4	\tS202_10
131	4	\tS202_11
132	4	\tS202_12
133	4	\tS202_13
134	4	\tS202_14
135	4	\tS202_15
136	4	\tS202_16
137	4	\tS202_17
138	4	\tS202_18
139	4	\tS202_19
140	4	\tS202_20
141	4	\tS202_21
142	4	\tS202_22
143	4	\tS202_23
144	4	\tS202_24
145	4	\tS202_25
146	4	\tS202_26
147	4	\tS202_27
148	4	\tS202_28
149	4	\tS202_29
150	4	\tS202_30
151	4	\tS202_31
152	4	\tS202_32
153	4	\tS202_33
154	4	\tS202_34
155	4	\tS202_35
156	4	\tS202_36
157	4	\tS202_37
158	4	\tS202_38
159	4	\tS202_39
160	4	\tS202_40
161	5	\tSH101_1
162	5	\tSH101_2
163	5	\tSH101_3
164	5	\tSH101_4
165	5	\tSH101_5
166	5	\tSH101_6
167	5	\tSH101_7
168	5	\tSH101_8
169	5	\tSH101_9
170	5	\tSH101_10
171	5	\tSH101_11
172	5	\tSH101_12
173	5	\tSH101_13
174	5	\tSH101_14
175	5	\tSH101_15
176	5	\tSH101_16
177	5	\tSH101_17
178	5	\tSH101_18
179	5	\tSH101_19
180	5	\tSH101_20
181	5	\tSH101_21
182	5	\tSH101_22
183	5	\tSH101_23
184	5	\tSH101_24
185	5	\tSH101_25
186	5	\tSH101_26
187	5	\tSH101_27
188	5	\tSH101_28
189	5	\tSH101_29
190	5	\tSH101_30
191	5	\tSH101_31
192	5	\tSH101_32
193	5	\tSH101_33
194	5	\tSH101_34
195	5	\tSH101_35
196	5	\tSH101_36
197	5	\tSH101_37
198	5	\tSH101_38
199	5	\tSH101_39
200	5	\tSH101_40
201	6	\tSH202_1
202	6	\tSH202_2
203	6	\tSH202_3
204	6	\tSH202_4
205	6	\tSH202_5
206	6	\tSH202_6
207	6	\tSH202_7
208	6	\tSH202_8
209	6	\tSH202_9
210	6	\tSH202_10
211	6	\tSH202_11
212	6	\tSH202_12
213	6	\tSH202_13
214	6	\tSH202_14
215	6	\tSH202_15
216	6	\tSH202_16
217	6	\tSH202_17
218	6	\tSH202_18
219	6	\tSH202_19
220	6	\tSH202_20
221	6	\tSH202_21
222	6	\tSH202_22
223	6	\tSH202_23
224	6	\tSH202_24
225	6	\tSH202_25
226	6	\tSH202_26
227	6	\tSH202_27
228	6	\tSH202_28
229	6	\tSH202_29
230	6	\tSH202_30
231	6	\tSH202_31
232	6	\tSH202_32
233	6	\tSH202_33
234	6	\tSH202_34
235	6	\tSH202_35
236	6	\tSH202_36
237	6	\tSH202_37
238	6	\tSH202_38
239	6	\tSH202_39
240	6	\tSH202_40
241	7	\tJong101_1
242	7	\tJong101_2
243	7	\tJong101_3
244	7	\tJong101_4
245	7	\tJong101_5
246	7	\tJong101_6
247	7	\tJong101_7
248	7	\tJong101_8
249	7	\tJong101_9
250	7	\tJong101_10
251	7	\tJong101_11
252	7	\tJong101_12
253	7	\tJong101_13
254	7	\tJong101_14
255	7	\tJong101_15
256	7	\tJong101_16
257	7	\tJong101_17
258	7	\tJong101_18
259	7	\tJong101_19
260	7	\tJong101_20
261	7	\tJong101_21
262	7	\tJong101_22
263	7	\tJong101_23
264	7	\tJong101_24
265	7	\tJong101_25
266	7	\tJong101_26
267	7	\tJong101_27
268	7	\tJong101_28
269	7	\tJong101_29
270	7	\tJong101_30
271	7	\tJong101_31
272	7	\tJong101_32
273	7	\tJong101_33
274	7	\tJong101_34
275	7	\tJong101_35
276	7	\tJong101_36
277	7	\tJong101_37
278	7	\tJong101_38
279	7	\tJong101_39
280	7	\tJong101_40
281	8	\tJong202_1
282	8	\tJong202_2
283	8	\tJong202_3
284	8	\tJong202_4
285	8	\tJong202_5
286	8	\tJong202_6
287	8	\tJong202_7
288	8	\tJong202_8
289	8	\tJong202_9
290	8	\tJong202_10
291	8	\tJong202_11
292	8	\tJong202_12
293	8	\tJong202_13
294	8	\tJong202_14
295	8	\tJong202_15
296	8	\tJong202_16
297	8	\tJong202_17
298	8	\tJong202_18
299	8	\tJong202_19
300	8	\tJong202_20
301	8	\tJong202_21
302	8	\tJong202_22
303	8	\tJong202_23
304	8	\tJong202_24
305	8	\tJong202_25
306	8	\tJong202_26
307	8	\tJong202_27
308	8	\tJong202_28
309	8	\tJong202_29
310	8	\tJong202_30
311	8	\tJong202_31
312	8	\tJong202_32
313	8	\tJong202_33
314	8	\tJong202_34
315	8	\tJong202_35
316	8	\tJong202_36
317	8	\tJong202_37
318	8	\tJong202_38
319	8	\tJong202_39
320	8	\tJong202_40
\.


--
-- Name: pc_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_seq_seq', 1, false);


--
-- Data for Name: port; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY port (seq, switch_seq, ip, subnet_mask, default_gateway, dns_server, sub_dns_server, pc_seq, memo) FROM stdin;
1	1	\t192.168.1.1	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	1	\N
2	1	\t192.168.1.2	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	2	\N
3	1	\t192.168.1.3	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	3	\N
4	1	\t192.168.1.4	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	4	\N
5	1	\t192.168.1.5	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	5	\N
6	1	\t192.168.1.6	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	6	\N
7	1	\t192.168.1.7	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	7	\N
8	1	\t192.168.1.8	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	8	\N
9	1	\t192.168.1.9	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	9	\N
10	1	\t192.168.1.10	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	10	\N
11	1	\t192.168.1.11	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	11	\N
12	1	\t192.168.1.12	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	12	\N
13	1	\t192.168.1.13	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	13	\N
14	1	\t192.168.1.14	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	14	\N
15	1	\t192.168.1.15	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	15	\N
16	1	\t192.168.1.16	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	16	\N
17	1	\t192.168.1.17	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	17	\N
18	1	\t192.168.1.18	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	18	\N
19	1	\t192.168.1.19	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	19	\N
20	1	\t192.168.1.20	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	20	\N
21	1	\t192.168.1.21	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	21	\N
22	1	\t192.168.1.22	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	22	\N
23	1	\t192.168.1.23	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	23	\N
24	1	\t192.168.1.24	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	24	\N
25	1	\t192.168.1.25	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	25	\N
26	1	\t192.168.1.26	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	26	\N
27	1	\t192.168.1.27	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	27	\N
28	1	\t192.168.1.28	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	28	\N
29	1	\t192.168.1.29	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	29	\N
30	1	\t192.168.1.30	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	30	\N
31	1	\t192.168.1.31	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	31	\N
32	1	\t192.168.1.32	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	32	\N
33	1	\t192.168.1.33	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	33	\N
34	1	\t192.168.1.34	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	34	\N
35	1	\t192.168.1.35	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	35	\N
36	1	\t192.168.1.36	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	36	\N
37	1	\t192.168.1.37	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	37	\N
38	1	\t192.168.1.38	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	38	\N
39	1	\t192.168.1.39	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	39	\N
40	1	\t192.168.1.40	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	40	\N
41	2	\t192.168.1.80	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	41	\N
42	2	\t192.168.1.81	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	42	\N
43	2	\t192.168.1.82	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	43	\N
44	2	\t192.168.1.83	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	44	\N
45	2	\t192.168.1.84	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	45	\N
46	2	\t192.168.1.85	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	46	\N
47	2	\t192.168.1.86	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	47	\N
48	2	\t192.168.1.87	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	48	\N
49	2	\t192.168.1.88	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	49	\N
50	2	\t192.168.1.89	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	50	\N
51	2	\t192.168.1.90	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	51	\N
52	2	\t192.168.1.91	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	52	\N
53	2	\t192.168.1.92	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	53	\N
54	2	\t192.168.1.93	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	54	\N
55	2	\t192.168.1.94	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	55	\N
56	2	\t192.168.1.95	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	56	\N
57	2	\t192.168.1.96	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	57	\N
58	2	\t192.168.1.97	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	58	\N
59	2	\t192.168.1.98	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	59	\N
60	2	\t192.168.1.99	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	60	\N
61	2	\t192.168.1.100	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	61	\N
62	2	\t192.168.1.101	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	62	\N
63	2	\t192.168.1.102	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	63	\N
64	2	\t192.168.1.103	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	64	\N
65	2	\t192.168.1.104	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	65	\N
66	2	\t192.168.1.105	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	66	\N
67	2	\t192.168.1.106	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	67	\N
68	2	\t192.168.1.107	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	68	\N
69	2	\t192.168.1.108	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	69	\N
70	2	\t192.168.1.109	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	70	\N
71	2	\t192.168.1.110	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	71	\N
72	2	\t192.168.1.111	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	72	\N
73	2	\t192.168.1.112	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	73	\N
74	2	\t192.168.1.113	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	74	\N
75	2	\t192.168.1.114	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	75	\N
76	2	\t192.168.1.115	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	76	\N
77	2	\t192.168.1.116	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	77	\N
78	2	\t192.168.1.117	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	78	\N
79	2	\t192.168.1.118	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	79	\N
80	2	\t192.168.1.119	\t255.255.255.0	\t192.168.1.254	\t152.23.142.27	\t152.23.142.28	80	\N
81	3	\t192.168.2.1	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	81	\N
82	3	\t192.168.2.2	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	82	\N
83	3	\t192.168.2.3	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	83	\N
84	3	\t192.168.2.4	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	84	\N
85	3	\t192.168.2.5	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	85	\N
86	3	\t192.168.2.6	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	86	\N
87	3	\t192.168.2.7	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	87	\N
88	3	\t192.168.2.8	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	88	\N
89	3	\t192.168.2.9	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	89	\N
90	3	\t192.168.2.10	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	90	\N
91	3	\t192.168.2.11	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	91	\N
92	3	\t192.168.2.12	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	92	\N
93	3	\t192.168.2.13	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	93	\N
94	3	\t192.168.2.14	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	94	\N
95	3	\t192.168.2.15	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	95	\N
96	3	\t192.168.2.16	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	96	\N
97	3	\t192.168.2.17	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	97	\N
98	3	\t192.168.2.18	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	98	\N
99	3	\t192.168.2.19	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	99	\N
100	3	\t192.168.2.20	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	100	\N
101	3	\t192.168.2.21	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	101	\N
102	3	\t192.168.2.22	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	102	\N
103	3	\t192.168.2.23	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	103	\N
104	3	\t192.168.2.24	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	104	\N
105	3	\t192.168.2.25	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	105	\N
106	3	\t192.168.2.26	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	106	\N
107	3	\t192.168.2.27	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	107	\N
108	3	\t192.168.2.28	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	108	\N
109	3	\t192.168.2.29	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	109	\N
110	3	\t192.168.2.30	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	110	\N
111	3	\t192.168.2.31	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	111	\N
112	3	\t192.168.2.32	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	112	\N
113	3	\t192.168.2.33	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	113	\N
114	3	\t192.168.2.34	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	114	\N
115	3	\t192.168.2.35	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	115	\N
116	3	\t192.168.2.36	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	116	\N
117	3	\t192.168.2.37	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	117	\N
118	3	\t192.168.2.38	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	118	\N
119	3	\t192.168.2.39	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	119	\N
120	3	\t192.168.2.40	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	120	\N
121	4	\t192.168.2.80	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	121	\N
122	4	\t192.168.2.81	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	122	\N
123	4	\t192.168.2.82	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	123	\N
124	4	\t192.168.2.83	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	124	\N
125	4	\t192.168.2.84	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	125	\N
126	4	\t192.168.2.85	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	126	\N
127	4	\t192.168.2.86	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	127	\N
128	4	\t192.168.2.87	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	128	\N
129	4	\t192.168.2.88	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	129	\N
130	4	\t192.168.2.89	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	130	\N
131	4	\t192.168.2.90	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	131	\N
132	4	\t192.168.2.91	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	132	\N
133	4	\t192.168.2.92	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	133	\N
134	4	\t192.168.2.93	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	134	\N
135	4	\t192.168.2.94	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	135	\N
136	4	\t192.168.2.95	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	136	\N
137	4	\t192.168.2.96	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	137	\N
138	4	\t192.168.2.97	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	138	\N
139	4	\t192.168.2.98	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	139	\N
140	4	\t192.168.2.99	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	140	\N
141	4	\t192.168.2.100	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	141	\N
142	4	\t192.168.2.101	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	142	\N
143	4	\t192.168.2.102	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	143	\N
144	4	\t192.168.2.103	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	144	\N
145	4	\t192.168.2.104	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	145	\N
146	4	\t192.168.2.105	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	146	\N
147	4	\t192.168.2.106	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	147	\N
148	4	\t192.168.2.107	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	148	\N
149	4	\t192.168.2.108	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	149	\N
150	4	\t192.168.2.109	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	150	\N
151	4	\t192.168.2.110	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	151	\N
152	4	\t192.168.2.111	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	152	\N
153	4	\t192.168.2.112	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	153	\N
154	4	\t192.168.2.113	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	154	\N
155	4	\t192.168.2.114	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	155	\N
156	4	\t192.168.2.115	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	156	\N
157	4	\t192.168.2.116	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	157	\N
158	4	\t192.168.2.117	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	158	\N
159	4	\t192.168.2.118	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	159	\N
160	4	\t192.168.2.119	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	160	\N
161	5	\t192.168.4.1	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	161	\N
162	5	\t192.168.4.2	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	162	\N
163	5	\t192.168.4.3	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	163	\N
164	5	\t192.168.4.4	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	164	\N
165	5	\t192.168.4.5	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	165	\N
166	5	\t192.168.4.6	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	166	\N
167	5	\t192.168.4.7	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	167	\N
168	5	\t192.168.4.8	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	168	\N
169	5	\t192.168.4.9	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	169	\N
170	5	\t192.168.4.10	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	170	\N
171	5	\t192.168.4.11	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	171	\N
172	5	\t192.168.4.12	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	172	\N
173	5	\t192.168.4.13	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	173	\N
174	5	\t192.168.4.14	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	174	\N
175	5	\t192.168.4.15	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	175	\N
176	5	\t192.168.4.16	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	176	\N
177	5	\t192.168.4.17	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	177	\N
178	5	\t192.168.4.18	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	178	\N
179	5	\t192.168.4.19	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	179	\N
180	5	\t192.168.4.20	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	180	\N
181	5	\t192.168.4.21	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	181	\N
182	5	\t192.168.4.22	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	182	\N
183	5	\t192.168.4.23	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	183	\N
184	5	\t192.168.4.24	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	184	\N
185	5	\t192.168.4.25	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	185	\N
186	5	\t192.168.4.26	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	186	\N
187	5	\t192.168.4.27	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	187	\N
188	5	\t192.168.4.28	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	188	\N
189	5	\t192.168.4.29	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	189	\N
190	5	\t192.168.4.30	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	190	\N
191	5	\t192.168.4.31	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	191	\N
192	5	\t192.168.4.32	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	192	\N
193	5	\t192.168.4.33	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	193	\N
194	5	\t192.168.4.34	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	194	\N
195	5	\t192.168.4.35	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	195	\N
196	5	\t192.168.4.36	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	196	\N
197	5	\t192.168.4.37	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	197	\N
198	5	\t192.168.4.38	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	198	\N
199	5	\t192.168.4.39	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	199	\N
200	5	\t192.168.4.40	\t255.255.255.0	\t192.168.4.254	\t152.23.142.27	\t152.23.142.28	200	\N
201	6	\t192.168.4.80	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	201	\N
202	6	\t192.168.4.81	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	202	\N
203	6	\t192.168.4.82	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	203	\N
204	6	\t192.168.4.83	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	204	\N
205	6	\t192.168.4.84	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	205	\N
206	6	\t192.168.4.85	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	206	\N
207	6	\t192.168.4.86	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	207	\N
208	6	\t192.168.4.87	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	208	\N
209	6	\t192.168.4.88	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	209	\N
210	6	\t192.168.4.89	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	210	\N
211	6	\t192.168.4.90	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	211	\N
212	6	\t192.168.4.91	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	212	\N
213	6	\t192.168.4.92	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	213	\N
214	6	\t192.168.4.93	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	214	\N
215	6	\t192.168.4.94	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	215	\N
216	6	\t192.168.4.95	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	216	\N
217	6	\t192.168.4.96	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	217	\N
218	6	\t192.168.4.97	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	218	\N
219	6	\t192.168.4.98	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	219	\N
220	6	\t192.168.4.99	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	220	\N
221	6	\t192.168.4.100	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	221	\N
222	6	\t192.168.4.101	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	222	\N
223	6	\t192.168.4.102	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	223	\N
224	6	\t192.168.4.103	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	224	\N
225	6	\t192.168.4.104	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	225	\N
226	6	\t192.168.4.105	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	226	\N
227	6	\t192.168.4.106	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	227	\N
228	6	\t192.168.4.107	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	228	\N
229	6	\t192.168.4.108	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	229	\N
230	6	\t192.168.4.109	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	230	\N
231	6	\t192.168.4.110	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	231	\N
232	6	\t192.168.4.111	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	232	\N
233	6	\t192.168.4.112	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	233	\N
234	6	\t192.168.4.113	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	234	\N
235	6	\t192.168.4.114	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	235	\N
236	6	\t192.168.4.115	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	236	\N
237	6	\t192.168.4.116	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	237	\N
238	6	\t192.168.4.117	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	238	\N
239	6	\t192.168.4.118	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	239	\N
240	6	\t192.168.4.119	\t255.255.255.0	\t192.168.2.254	\t152.23.142.27	\t152.23.142.28	240	\N
241	7	\t192.168.3.1	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	241	\N
242	7	\t192.168.3.2	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	242	\N
243	7	\t192.168.3.3	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	243	\N
244	7	\t192.168.3.4	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	244	\N
245	7	\t192.168.3.5	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	245	\N
246	7	\t192.168.3.6	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	246	\N
247	7	\t192.168.3.7	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	247	\N
248	7	\t192.168.3.8	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	248	\N
249	7	\t192.168.3.9	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	249	\N
250	7	\t192.168.3.10	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	250	\N
251	7	\t192.168.3.11	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	251	\N
252	7	\t192.168.3.12	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	252	\N
253	7	\t192.168.3.13	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	253	\N
254	7	\t192.168.3.14	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	254	\N
255	7	\t192.168.3.15	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	255	\N
256	7	\t192.168.3.16	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	256	\N
257	7	\t192.168.3.17	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	257	\N
258	7	\t192.168.3.18	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	258	\N
259	7	\t192.168.3.19	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	259	\N
260	7	\t192.168.3.20	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	260	\N
261	7	\t192.168.3.21	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	261	\N
262	7	\t192.168.3.22	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	262	\N
263	7	\t192.168.3.23	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	263	\N
264	7	\t192.168.3.24	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	264	\N
265	7	\t192.168.3.25	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	265	\N
266	7	\t192.168.3.26	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	266	\N
267	7	\t192.168.3.27	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	267	\N
268	7	\t192.168.3.28	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	268	\N
269	7	\t192.168.3.29	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	269	\N
270	7	\t192.168.3.30	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	270	\N
271	7	\t192.168.3.31	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	271	\N
272	7	\t192.168.3.32	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	272	\N
273	7	\t192.168.3.33	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	273	\N
274	7	\t192.168.3.34	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	274	\N
275	7	\t192.168.3.35	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	275	\N
276	7	\t192.168.3.36	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	276	\N
277	7	\t192.168.3.37	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	277	\N
278	7	\t192.168.3.38	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	278	\N
279	7	\t192.168.3.39	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	279	\N
280	7	\t192.168.3.40	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	280	\N
281	8	\t192.168.3.80	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	281	\N
282	8	\t192.168.3.81	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	282	\N
283	8	\t192.168.3.82	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	283	\N
284	8	\t192.168.3.83	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	284	\N
285	8	\t192.168.3.84	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	285	\N
286	8	\t192.168.3.85	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	286	\N
287	8	\t192.168.3.86	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	287	\N
288	8	\t192.168.3.87	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	288	\N
289	8	\t192.168.3.88	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	289	\N
290	8	\t192.168.3.89	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	290	\N
291	8	\t192.168.3.90	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	291	\N
292	8	\t192.168.3.91	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	292	\N
293	8	\t192.168.3.92	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	293	\N
294	8	\t192.168.3.93	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	294	\N
295	8	\t192.168.3.94	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	295	\N
296	8	\t192.168.3.95	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	296	\N
297	8	\t192.168.3.96	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	297	\N
298	8	\t192.168.3.97	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	298	\N
299	8	\t192.168.3.98	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	299	\N
300	8	\t192.168.3.99	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	300	\N
301	8	\t192.168.3.100	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	301	\N
302	8	\t192.168.3.101	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	302	\N
303	8	\t192.168.3.102	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	303	\N
304	8	\t192.168.3.103	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	304	\N
305	8	\t192.168.3.104	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	305	\N
306	8	\t192.168.3.105	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	306	\N
307	8	\t192.168.3.106	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	307	\N
308	8	\t192.168.3.107	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	308	\N
309	8	\t192.168.3.108	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	309	\N
310	8	\t192.168.3.109	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	310	\N
311	8	\t192.168.3.110	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	311	\N
312	8	\t192.168.3.111	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	312	\N
313	8	\t192.168.3.112	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	313	\N
314	8	\t192.168.3.113	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	314	\N
315	8	\t192.168.3.114	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	315	\N
316	8	\t192.168.3.115	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	316	\N
317	8	\t192.168.3.116	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	317	\N
318	8	\t192.168.3.117	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	318	\N
319	8	\t192.168.3.118	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	319	\N
320	8	\t192.168.3.119	\t255.255.255.0	\t192.168.3.254	\t152.23.142.27	\t152.23.142.28	320	\N
\.


--
-- Name: port_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('port_seq_seq', 1, false);


--
-- Data for Name: room; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY room (seq, room_name, building_seq, memo) FROM stdin;
1	자101	1	\N
2	자202	1	\N
3	상101	2	\N
4	상202	2	\N
5	사101	3	\N
6	사202	3	\N
7	종101	4	\N
8	종202	4	\N
\.


--
-- Name: room_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('room_seq_seq', 1, false);


--
-- Data for Name: router; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY router (seq, ip, network, subnet_mask, dns_server, sub_dns_server, building_seq, room_seq, name) FROM stdin;
1	\t192.168.1.254	\t192.168.1.0	\t255.255.255.0	\t152.23.142.27	\t152.23.142.28	1	1	\tJa1_Router
2	\t192.168.2.254	\t192.168.2.0	\t255.255.255.0	\t152.23.142.27	\t152.23.142.28	2	3	\tS1_Router
3	\t192.168.3.254	\t192.168.3.0	\t255.255.255.0	\t152.23.142.27	\t152.23.142.28	3	5	\tSH1_Router
4	\t192.168.4.254	\t192.168.4.0	\t255.255.255.0	\t152.23.142.27	\t152.23.142.28	4	7	\tJong1_Router
\.


--
-- Name: router_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('router_seq_seq', 1, false);


--
-- Data for Name: switch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY switch (seq, router_seq, ip, subnet_mask, room_seq, name) FROM stdin;
1	1	\t192.168.1.252	\t255.255.255.0	1	\tJa1_Switch
2	1	\t192.168.1.253	\t255.255.255.0	2	\tJa2_Switch
3	2	\t192.168.2.252	\t255.255.255.0	3	\tS1_Switch
4	2	\t192.168.2.253	\t255.255.255.0	4	\tS2_Switch
5	3	\t192.168.3.252	\t255.255.255.0	5	\tSH1_Switch
6	3	\t192.168.3.253	\t255.255.255.0	6	\tSH2_Switch
7	4	\t192.168.4.252	\t255.255.255.0	7	\tJong1_Switch
8	4	\t192.168.4.253	\t255.255.255.0	8	\tJong2_Switch
\.


--
-- Name: switch_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('switch_seq_seq', 1, false);


--
-- Name: building_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY building
    ADD CONSTRAINT building_pkey PRIMARY KEY (seq);


--
-- Name: pc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pc
    ADD CONSTRAINT pc_pkey PRIMARY KEY (seq);


--
-- Name: port_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_pkey PRIMARY KEY (seq);


--
-- Name: room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY room
    ADD CONSTRAINT room_pkey PRIMARY KEY (seq);


--
-- Name: router_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_pkey PRIMARY KEY (seq);


--
-- Name: switch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY switch
    ADD CONSTRAINT switch_pkey PRIMARY KEY (seq);


--
-- Name: pc_room_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc
    ADD CONSTRAINT pc_room_seq_fkey FOREIGN KEY (room_seq) REFERENCES room(seq);


--
-- Name: port_pc_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_pc_seq_fkey FOREIGN KEY (pc_seq) REFERENCES pc(seq);


--
-- Name: port_switch_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_switch_seq_fkey FOREIGN KEY (switch_seq) REFERENCES switch(seq);


--
-- Name: room_building_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY room
    ADD CONSTRAINT room_building_seq_fkey FOREIGN KEY (building_seq) REFERENCES building(seq);


--
-- Name: router_building_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_building_seq_fkey FOREIGN KEY (building_seq) REFERENCES building(seq);


--
-- Name: router_room_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router_room_seq_fkey FOREIGN KEY (room_seq) REFERENCES room(seq);


--
-- Name: switch_router_seq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY switch
    ADD CONSTRAINT switch_router_seq_fkey FOREIGN KEY (router_seq) REFERENCES router(seq);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

