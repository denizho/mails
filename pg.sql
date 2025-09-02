--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-09-02 15:42:19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16426)
-- Name: emails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emails (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    text text NOT NULL,
    from_email character varying(255) NOT NULL,
    sender_key character varying(255) NOT NULL,
    attachments jsonb,
    status character varying(50) DEFAULT 'ожидание'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.emails OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16425)
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.emails_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.emails_id_seq OWNER TO postgres;

--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 217
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.emails_id_seq OWNED BY public.emails.id;


--
-- TOC entry 222 (class 1259 OID 16460)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    from_email character varying(255),
    sender_key character varying(255),
    to_email character varying(255),
    subject character varying(255),
    message text,
    attachments jsonb,
    status character varying(50),
    old_email character varying(255) DEFAULT NULL::character varying,
    new_email character varying(255) DEFAULT NULL::character varying,
    delivered_at timestamp without time zone
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16459)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;

--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 221
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- TOC entry 220 (class 1259 OID 16452)
-- Name: sender_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sender_keys (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sender_keys OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16451)
-- Name: sender_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sender_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sender_keys_id_seq OWNER TO postgres;

--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 219
-- Name: sender_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sender_keys_id_seq OWNED BY public.sender_keys.id;


--
-- TOC entry 4651 (class 2604 OID 16429)
-- Name: emails id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails ALTER COLUMN id SET DEFAULT nextval('public.emails_id_seq'::regclass);


--
-- TOC entry 4656 (class 2604 OID 16463)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- TOC entry 4654 (class 2604 OID 16455)
-- Name: sender_keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sender_keys ALTER COLUMN id SET DEFAULT nextval('public.sender_keys_id_seq'::regclass);


--
-- TOC entry 4812 (class 0 OID 16426)
-- Dependencies: 218
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emails (id, email, subject, text, from_email, sender_key, attachments, status, created_at) FROM stdin;
\.


--
-- TOC entry 4816 (class 0 OID 16460)
-- Dependencies: 222
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, created_at, updated_at, from_email, sender_key, to_email, subject, message, attachments, status, old_email, new_email, delivered_at) FROM stdin;
\.


--
-- TOC entry 4814 (class 0 OID 16452)
-- Dependencies: 220
-- Data for Name: sender_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sender_keys (id, key, created_at) FROM stdin;
\.


--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 217
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emails_id_seq', 195, true);


--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 221
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 120, true);


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 219
-- Name: sender_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sender_keys_id_seq', 1, false);


--
-- TOC entry 4661 (class 2606 OID 16435)
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- TOC entry 4665 (class 2606 OID 16470)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4663 (class 2606 OID 16458)
-- Name: sender_keys sender_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sender_keys
    ADD CONSTRAINT sender_keys_pkey PRIMARY KEY (id);


-- Completed on 2025-09-02 15:42:20

--
-- PostgreSQL database dump complete
--

