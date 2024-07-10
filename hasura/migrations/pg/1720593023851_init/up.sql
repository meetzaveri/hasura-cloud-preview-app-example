CREATE EXTENSION IF NOT EXISTS "pgcrypto";

SET check_function_bodies = false;
CREATE TABLE public.accounts (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    type text NOT NULL,
    provider text NOT NULL,
    "providerAccountId" text NOT NULL,
    refresh_token text,
    access_token text,
    expires_at bigint,
    token_type text,
    scope text,
    id_token text,
    session_state text,
    oauth_token_secret text,
    oauth_token text,
    "userId" uuid NOT NULL,
    refresh_token_expires_in integer
);
CREATE TABLE public.customer (
    id integer NOT NULL,
    first_name text,
    last_name text,
    email text,
    phone text,
    username text,
    ip_address text
);
CREATE TABLE public."order" (
    id integer NOT NULL,
    transaction_id text,
    product text,
    purchase_price text,
    discount_price text,
    order_date text,
    customer_id integer
);
CREATE TABLE public.orders (
    id integer NOT NULL,
    "productId" integer NOT NULL,
    quantity integer NOT NULL,
    status text NOT NULL,
    date date DEFAULT now() NOT NULL,
    total integer NOT NULL,
    users uuid
);
CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
CREATE TABLE public.products (
    id integer NOT NULL,
    name text NOT NULL,
    image text NOT NULL,
    description text NOT NULL,
    brand text NOT NULL,
    category text NOT NULL,
    price integer NOT NULL,
    hot boolean NOT NULL,
    "priceId" text
);
CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;
CREATE TABLE public.reviews (
    id integer NOT NULL,
    "productId" integer NOT NULL,
    rating integer NOT NULL,
    comment text NOT NULL,
    date date NOT NULL,
    "user" uuid
);
CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;
CREATE TABLE public.sessions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "sessionToken" text NOT NULL,
    "userId" uuid NOT NULL,
    expires timestamp with time zone
);
CREATE TABLE public.test (
    id integer,
    test_name text
);
CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text,
    email text,
    "emailVerified" timestamp with time zone,
    image text,
    roles text DEFAULT 'user'::text
);
CREATE TABLE public.verification_tokens (
    token text NOT NULL,
    identifier text NOT NULL,
    expires timestamp with time zone
);
ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);
ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);
ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (token);
ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT "accounts_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "orders_productId_fkey" FOREIGN KEY ("productId") REFERENCES public.products(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE CASCADE;
