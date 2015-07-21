--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.4
-- Dumped by pg_dump version 9.4.4
-- Started on 2015-07-21 21:13:31

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- TOC entry 2086 (class 0 OID 25103)
-- Dependencies: 173
-- Data for Name: building; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO building VALUES (1, '자연과학대');
INSERT INTO building VALUES (2, '상허연구동');
INSERT INTO building VALUES (3, '사회과학대');
INSERT INTO building VALUES (4, '종합강의동');


--
-- TOC entry 2111 (class 0 OID 0)
-- Dependencies: 172
-- Name: building_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('building_seq_seq', 1, false);


--
-- TOC entry 2090 (class 0 OID 25124)
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
INSERT INTO pc VALUES (9, 5, NULL);
INSERT INTO pc VALUES (10, 5, NULL);
INSERT INTO pc VALUES (11, 6, NULL);
INSERT INTO pc VALUES (12, 6, NULL);
INSERT INTO pc VALUES (13, 7, NULL);
INSERT INTO pc VALUES (14, 7, NULL);
INSERT INTO pc VALUES (15, 8, NULL);
INSERT INTO pc VALUES (16, 8, NULL);


--
-- TOC entry 2112 (class 0 OID 0)
-- Dependencies: 176
-- Name: pc_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_seq_seq', 1, false);


--
-- TOC entry 2096 (class 0 OID 25174)
-- Dependencies: 183
-- Data for Name: port; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO port VALUES (1, 1, '100.100.102.101', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 1, NULL);
INSERT INTO port VALUES (2, 1, '100.100.102.102', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 2, NULL);
INSERT INTO port VALUES (3, 1, '100.100.102.103', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', NULL, NULL);
INSERT INTO port VALUES (4, 2, '100.100.102.104', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 3, NULL);
INSERT INTO port VALUES (5, 2, '100.100.102.105', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 4, NULL);
INSERT INTO port VALUES (6, 2, '100.100.102.106', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', NULL, NULL);
INSERT INTO port VALUES (7, 3, '100.100.102.107', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 5, NULL);
INSERT INTO port VALUES (8, 3, '100.100.102.108', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 6, NULL);
INSERT INTO port VALUES (9, 3, '100.100.102.109', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', NULL, NULL);
INSERT INTO port VALUES (10, 4, '100.100.102.110', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 7, NULL);
INSERT INTO port VALUES (11, 4, '100.100.102.111', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 8, NULL);
INSERT INTO port VALUES (12, 4, '100.100.102.112', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', NULL, NULL);
INSERT INTO port VALUES (13, 5, '100.100.102.113', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 9, NULL);
INSERT INTO port VALUES (14, 5, '100.100.102.114', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 10, NULL);
INSERT INTO port VALUES (15, 5, '100.100.102.112', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', NULL, NULL);
INSERT INTO port VALUES (16, 6, '100.100.102.116', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 11, NULL);
INSERT INTO port VALUES (17, 6, '100.100.102.117', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 12, NULL);
INSERT INTO port VALUES (18, 6, '100.100.102.118', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', NULL, NULL);
INSERT INTO port VALUES (19, 7, '100.100.102.119', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 13, NULL);
INSERT INTO port VALUES (20, 7, '100.100.102.120', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 14, NULL);
INSERT INTO port VALUES (21, 7, '100.100.102.121', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', NULL, NULL);
INSERT INTO port VALUES (22, 8, '100.100.102.122', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 15, NULL);
INSERT INTO port VALUES (23, 8, '100.100.102.123', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', 16, NULL);
INSERT INTO port VALUES (24, 8, '100.100.102.124', '255.255.255.0', '255.255.255.0', '255.255.255.0', '255.255.255.0', NULL, NULL);


--
-- TOC entry 2113 (class 0 OID 0)
-- Dependencies: 182
-- Name: port_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('port_seq_seq', 1, false);


--
-- TOC entry 2088 (class 0 OID 25111)
-- Dependencies: 175
-- Data for Name: room; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO room VALUES (1, '101호', 1, NULL);
INSERT INTO room VALUES (2, '201호', 1, NULL);
INSERT INTO room VALUES (3, '101호', 2, NULL);
INSERT INTO room VALUES (4, '201호', 2, NULL);
INSERT INTO room VALUES (5, '103호', 3, NULL);
INSERT INTO room VALUES (6, '205호', 3, NULL);
INSERT INTO room VALUES (7, '105호', 4, NULL);
INSERT INTO room VALUES (8, '207호', 4, NULL);


--
-- TOC entry 2114 (class 0 OID 0)
-- Dependencies: 174
-- Name: room_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('room_seq_seq', 1, false);


--
-- TOC entry 2092 (class 0 OID 25137)
-- Dependencies: 179
-- Data for Name: router; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO router VALUES (1, '100.100.100.101', '255.255.255.0', '255.255.255.0', '255.255.255.0', '자연과학대 1층', 1, 1, NULL);
INSERT INTO router VALUES (2, '100.100.100.102', '255.255.255.0', '255.255.255.0', '255.255.255.0', '자연과학대 2층', 1, 2, NULL);
INSERT INTO router VALUES (3, '100.100.100.103', '255.255.255.0', '255.255.255.0', '255.255.255.0', '상허연구동 1층', 2, 3, NULL);
INSERT INTO router VALUES (4, '100.100.100.104', '255.255.255.0', '255.255.255.0', '255.255.255.0', '상허연구동 2층', 2, 4, NULL);
INSERT INTO router VALUES (5, '100.100.100.105', '255.255.255.0', '255.255.255.0', '255.255.255.0', '사회과학대 1층', 3, 5, NULL);
INSERT INTO router VALUES (6, '100.100.100.106', '255.255.255.0', '255.255.255.0', '255.255.255.0', '사회과학대 2층', 3, 6, NULL);
INSERT INTO router VALUES (7, '100.100.100.107', '255.255.255.0', '255.255.255.0', '255.255.255.0', '종합강의동 1층', 4, 7, NULL);
INSERT INTO router VALUES (8, '100.100.100.108', '255.255.255.0', '255.255.255.0', '255.255.255.0', '종합강의동 2층', 4, 8, NULL);


--
-- TOC entry 2115 (class 0 OID 0)
-- Dependencies: 178
-- Name: router_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('router_seq_seq', 1, false);


--
-- TOC entry 2094 (class 0 OID 25158)
-- Dependencies: 181
-- Data for Name: switch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO switch VALUES (1, 1, '100.100.101.101', NULL);
INSERT INTO switch VALUES (2, 1, '100.100.101.102', NULL);
INSERT INTO switch VALUES (3, 2, '100.100.101.103', NULL);
INSERT INTO switch VALUES (4, 2, '100.100.101.104', NULL);
INSERT INTO switch VALUES (5, 3, '100.100.101.105', NULL);
INSERT INTO switch VALUES (6, 3, '100.100.101.106', NULL);
INSERT INTO switch VALUES (7, 4, '100.100.101.107', NULL);
INSERT INTO switch VALUES (8, 4, '100.100.101.108', NULL);
INSERT INTO switch VALUES (9, 5, '100.100.101.109', NULL);
INSERT INTO switch VALUES (10, 5, '100.100.101.110', NULL);
INSERT INTO switch VALUES (11, 6, '100.100.101.111', NULL);
INSERT INTO switch VALUES (12, 6, '100.100.101.112', NULL);
INSERT INTO switch VALUES (13, 7, '100.100.101.113', NULL);
INSERT INTO switch VALUES (14, 7, '100.100.101.114', NULL);
INSERT INTO switch VALUES (15, 8, '100.100.101.115', NULL);
INSERT INTO switch VALUES (16, 8, '100.100.101.118', NULL);


--
-- TOC entry 2116 (class 0 OID 0)
-- Dependencies: 180
-- Name: switch_seq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('switch_seq_seq', 1, false);


-- Completed on 2015-07-21 21:13:31

--
-- PostgreSQL database dump complete
--

