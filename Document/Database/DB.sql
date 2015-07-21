--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.4
-- Dumped by pg_dump version 9.4.4
-- Started on 2015-07-21 20:08:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- TOC entry 2086 (class 0 OID 24807)
-- Dependencies: 173
-- Data for Name: building; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO building VALUES (1, '자연과학대');
INSERT INTO building VALUES (2, '상허연구동');


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

INSERT INTO pc VALUES (1, 1, NULL);
INSERT INTO pc VALUES (2, 1, NULL);
INSERT INTO pc VALUES (3, 2, NULL);
INSERT INTO pc VALUES (4, 2, NULL);
INSERT INTO pc VALUES (5, 3, NULL);
INSERT INTO pc VALUES (6, 3, NULL);
INSERT INTO pc VALUES (7, 4, NULL);
INSERT INTO pc VALUES (8, 4, NULL);


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

INSERT INTO port VALUES (1, 1, '100.100.102.101/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', 1, NULL);
INSERT INTO port VALUES (2, 1, '100.100.102.102/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', 2, NULL);
INSERT INTO port VALUES (3, 1, '100.100.102.103/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', NULL, NULL);
INSERT INTO port VALUES (4, 2, '100.100.102.104/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', 3, NULL);
INSERT INTO port VALUES (5, 2, '100.100.102.105/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', 4, NULL);
INSERT INTO port VALUES (6, 2, '100.100.102.106/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', NULL, NULL);
INSERT INTO port VALUES (7, 3, '100.100.102.107/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', 5, NULL);
INSERT INTO port VALUES (8, 3, '100.100.102.108/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', 6, NULL);
INSERT INTO port VALUES (9, 3, '100.100.102.109/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', NULL, NULL);
INSERT INTO port VALUES (10, 4, '100.100.102.110/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', 7, NULL);
INSERT INTO port VALUES (11, 4, '100.100.102.111/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', 8, NULL);
INSERT INTO port VALUES (12, 4, '100.100.102.112/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', NULL, NULL);


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

INSERT INTO room VALUES (1, '101호', 1, NULL);
INSERT INTO room VALUES (2, '201호', 1, NULL);
INSERT INTO room VALUES (3, '101호', 2, NULL);
INSERT INTO room VALUES (4, '201호', 2, NULL);


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

INSERT INTO router VALUES (1, '100.100.100.101/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '자연과학대 1층', 1, 1, NULL);
INSERT INTO router VALUES (2, '100.100.100.102/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '자연과학대 2층', 1, 2, NULL);
INSERT INTO router VALUES (3, '100.100.100.103/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '상허연구동 1층', 2, 3, NULL);
INSERT INTO router VALUES (4, '100.100.100.104/32', '255.255.255.0/32', '255.255.255.0/32', '255.255.255.0/32', '상허연구동 2층', 2, 4, NULL);


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

INSERT INTO switch VALUES (1, 1, '100.100.101.101/32', NULL);
INSERT INTO switch VALUES (2, 1, '100.100.101.102/32', NULL);
INSERT INTO switch VALUES (3, 2, '100.100.101.103/32', NULL);
INSERT INTO switch VALUES (4, 2, '100.100.101.104/32', NULL);
INSERT INTO switch VALUES (5, 3, '100.100.101.105/32', NULL);
INSERT INTO switch VALUES (6, 3, '100.100.101.106/32', NULL);
INSERT INTO switch VALUES (7, 4, '100.100.101.107/32', NULL);
INSERT INTO switch VALUES (8, 4, '100.100.101.108/32', NULL);


--
-- TOC entry 2116 (class 0 OID 0)
-- Dependencies: 180
-- Name: switch_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('switch_seq_seq', 1, false);


-- Completed on 2015-07-21 20:08:05

--
-- PostgreSQL database dump complete
--

