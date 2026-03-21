--
-- PostgreSQL database cluster dump
--

-- Started on 2026-03-21 15:40:46

\restrict ed3WvLStJrpazR7vQ8Sdyk2709ehgLMP5fp1lPmtppHAQF5zXKYxwVJwwke4V3s

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE anon;
ALTER ROLE anon WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE authenticated;
ALTER ROLE authenticated WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE authenticator;
ALTER ROLE authenticator WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:pzFAQ2nGn3bRhc7EY4OPgQ==$nACM4k5gZTOXuV//GID7xu3NCaxObRgIZfkmwgQ2HA0=:LNfwulMJOKyzDIcBHYQ4R1Z8nj6Hrap8DKWXMqyjahQ=';
CREATE ROLE dashboard_user;
ALTER ROLE dashboard_user WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB NOLOGIN REPLICATION NOBYPASSRLS;
CREATE ROLE pgbouncer;
ALTER ROLE pgbouncer WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:/9mjYxRH0pxYdT0SmVDzKg==$8oN8iOqXtb9piZH09pxgFjT673voiVnCsLEq8GZiBaU=:IHBRl+4iH5WmzK70hr2D9ozF9DrvEwaW38GWCldDncs=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:GUxnPgdOTzuaPSFj8jgdgg==$/p75A/HyLidXd2tQbcJrbiYdODXjMkV99e2EmlpWIfk=:7sdxSq//EG8c1dp7XX0oprRWFNLS6zyJOFomZoIriZU=';
CREATE ROLE service_role;
ALTER ROLE service_role WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION BYPASSRLS;
CREATE ROLE supabase_admin;
ALTER ROLE supabase_admin WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:zs30NfJGrZlPSjdI3p9e5A==$poTuxn/WoLNumsoJYHD/5m9VjUD7jKnfBBjZEMLr8jw=:CDzani8ChBN74dImztWumoMiXsAyVhJju2NK3HdMJV0=';
CREATE ROLE supabase_auth_admin;
ALTER ROLE supabase_auth_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:b2WInmUFwA5YcpqtD9I+Wg==$d8xr4ZnaaQH9RFBCutw5UxHOG47kolzXvCQRPRPeiq8=:Wb4YoOVs3cyTwk6a9CHwU/IVuOuqbG2O67CiTAa+H1g=';
CREATE ROLE supabase_etl_admin;
ALTER ROLE supabase_etl_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:efd4wcCewsph5igO4m9eMw==$F0aBgAwD1gwKWQ1DPJ4/ax+JPK5vKpaR+Wo+buPHqYA=:Z6cUqDUmXDXMAR25ehTn8Y6f8nYZLYOY+lHyJzAmJOg=';
CREATE ROLE supabase_read_only_user;
ALTER ROLE supabase_read_only_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:eo1zPaWb4uJN5/CcTNcrzA==$290nTI6uHz5f0oPA02yY9JWBB7QZvLr+apa1KfI60BM=:okkXXQ/1MXWkguHMTNFGYxRzKk54ssruDkf6Ulh/Z7Q=';
CREATE ROLE supabase_realtime_admin;
ALTER ROLE supabase_realtime_admin WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE supabase_replication_admin;
ALTER ROLE supabase_replication_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:SRUf4MOQkKI8B6bR+IqQNA==$D44ktewXL8kIZ7epWk9fvFb3+KVnSM5G8DwNYRO++iQ=:egoTNHRyhIG05qaQW4R+vbqVBWVxn2UE3Z/YuEYwrVk=';
CREATE ROLE supabase_storage_admin;
ALTER ROLE supabase_storage_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:BAd8SQ2jmwsdzjceIoB4iQ==$9pUbqorbzq7fV7BW1usZE5jH9yJ3OzoGTfa2mPShOaY=:s7SqDsOwac1lovaXHhBjRdU77DgbXbTQlCKfxpvzXik=';

--
-- User Configurations
--

--
-- User Config "anon"
--

ALTER ROLE anon SET statement_timeout TO '3s';

--
-- User Config "authenticated"
--

ALTER ROLE authenticated SET statement_timeout TO '8s';

--
-- User Config "authenticator"
--

ALTER ROLE authenticator SET session_preload_libraries TO 'safeupdate';
ALTER ROLE authenticator SET statement_timeout TO '8s';
ALTER ROLE authenticator SET lock_timeout TO '8s';

--
-- User Config "postgres"
--

ALTER ROLE postgres SET search_path TO E'\\$user', 'public', 'extensions';

--
-- User Config "supabase_admin"
--

ALTER ROLE supabase_admin SET search_path TO '$user', 'public', 'auth', 'extensions';
ALTER ROLE supabase_admin SET log_statement TO 'none';

--
-- User Config "supabase_auth_admin"
--

ALTER ROLE supabase_auth_admin SET search_path TO 'auth';
ALTER ROLE supabase_auth_admin SET idle_in_transaction_session_timeout TO '60000';
ALTER ROLE supabase_auth_admin SET log_statement TO 'none';

--
-- User Config "supabase_read_only_user"
--

ALTER ROLE supabase_read_only_user SET default_transaction_read_only TO 'on';

--
-- User Config "supabase_storage_admin"
--

ALTER ROLE supabase_storage_admin SET search_path TO 'storage';
ALTER ROLE supabase_storage_admin SET log_statement TO 'none';


--
-- Role memberships
--

GRANT anon TO authenticator WITH INHERIT FALSE GRANTED BY supabase_admin;
GRANT anon TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY supabase_admin;
GRANT authenticated TO authenticator WITH INHERIT FALSE GRANTED BY supabase_admin;
GRANT authenticated TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY supabase_admin;
GRANT authenticator TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY supabase_admin;
GRANT authenticator TO supabase_storage_admin WITH INHERIT FALSE GRANTED BY supabase_admin;
GRANT pg_create_subscription TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY supabase_admin;
GRANT pg_monitor TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY supabase_admin;
GRANT pg_monitor TO supabase_etl_admin WITH INHERIT TRUE GRANTED BY supabase_admin;
GRANT pg_monitor TO supabase_read_only_user WITH INHERIT TRUE GRANTED BY supabase_admin;
GRANT pg_read_all_data TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY supabase_admin;
GRANT pg_read_all_data TO supabase_etl_admin WITH INHERIT TRUE GRANTED BY supabase_admin;
GRANT pg_read_all_data TO supabase_read_only_user WITH INHERIT TRUE GRANTED BY supabase_admin;
GRANT pg_signal_backend TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY supabase_admin;
GRANT service_role TO authenticator WITH INHERIT FALSE GRANTED BY supabase_admin;
GRANT service_role TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY supabase_admin;
GRANT supabase_realtime_admin TO postgres WITH INHERIT TRUE GRANTED BY supabase_admin;






\unrestrict ed3WvLStJrpazR7vQ8Sdyk2709ehgLMP5fp1lPmtppHAQF5zXKYxwVJwwke4V3s

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict 0dKcgXbNGdJ0OnBcKADXzO8Zwfvb92quzPTKH7vudvbLviYVESOOmsM9YPLpBnV

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.0

-- Started on 2026-03-21 15:40:54

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

-- Completed on 2026-03-21 15:41:11

--
-- PostgreSQL database dump complete
--

\unrestrict 0dKcgXbNGdJ0OnBcKADXzO8Zwfvb92quzPTKH7vudvbLviYVESOOmsM9YPLpBnV

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict nTbvfVf01FXer1gdNg1KACUt3SVNuDhqyA3poQz7IU5lgZgJ5H6AiT1KhDcGxjj

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.0

-- Started on 2026-03-21 15:41:11

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

--
-- TOC entry 37 (class 2615 OID 16494)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- TOC entry 23 (class 2615 OID 16388)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- TOC entry 35 (class 2615 OID 16574)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- TOC entry 34 (class 2615 OID 16563)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- TOC entry 12 (class 2615 OID 16386)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- TOC entry 14 (class 2615 OID 16555)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- TOC entry 46 (class 2615 OID 16542)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- TOC entry 32 (class 2615 OID 16603)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- TOC entry 6 (class 3079 OID 16639)
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- TOC entry 2 (class 3079 OID 16389)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 4 (class 3079 OID 16443)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 5 (class 3079 OID 16604)
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- TOC entry 3 (class 3079 OID 16432)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1175 (class 1247 OID 16738)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- TOC entry 1199 (class 1247 OID 16879)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- TOC entry 1172 (class 1247 OID 16732)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1169 (class 1247 OID 16727)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1217 (class 1247 OID 16982)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1229 (class 1247 OID 17055)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1211 (class 1247 OID 16960)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1220 (class 1247 OID 16992)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1205 (class 1247 OID 16921)
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1289 (class 1247 OID 17497)
-- Name: app_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.app_role AS ENUM (
    'admin',
    'editor',
    'viewer'
);


ALTER TYPE public.app_role OWNER TO postgres;

--
-- TOC entry 1277 (class 1247 OID 17358)
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- TOC entry 1241 (class 1247 OID 17126)
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- TOC entry 1244 (class 1247 OID 17141)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- TOC entry 1283 (class 1247 OID 17400)
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- TOC entry 1280 (class 1247 OID 17371)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- TOC entry 1265 (class 1247 OID 17281)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- TOC entry 466 (class 1255 OID 16540)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 466
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 485 (class 1255 OID 16709)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- TOC entry 465 (class 1255 OID 16539)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 465
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 464 (class 1255 OID 16538)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 464
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 467 (class 1255 OID 16547)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 467
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 471 (class 1255 OID 16568)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 471
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 468 (class 1255 OID 16549)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 468
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 469 (class 1255 OID 16559)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- TOC entry 470 (class 1255 OID 16560)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- TOC entry 472 (class 1255 OID 16570)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 472
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 414 (class 1255 OID 16387)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- TOC entry 516 (class 1255 OID 17596)
-- Name: admin_delete_user(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_delete_user(target_user_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
DECLARE
  caller_id UUID;
  caller_role app_role;
  target_role app_role;
  admin_count INT;
BEGIN
  caller_id := auth.uid();

  SELECT role INTO caller_role FROM public.user_roles WHERE user_id = caller_id;
  IF caller_role != 'admin' THEN
    RAISE EXCEPTION 'Apenas administradores podem excluir usuários.';
  END IF;

  IF caller_id = target_user_id THEN
    RAISE EXCEPTION 'Você não pode excluir sua própria conta.';
  END IF;

  SELECT role INTO target_role FROM public.user_roles WHERE user_id = target_user_id;
  IF target_role = 'admin' THEN
    SELECT count(*) INTO admin_count FROM public.user_roles WHERE role = 'admin';
    IF admin_count <= 1 THEN
      RAISE EXCEPTION 'Não é possível excluir o último administrador do sistema.';
    END IF;
  END IF;

  DELETE FROM auth.users WHERE id = target_user_id;
END;
$$;


ALTER FUNCTION public.admin_delete_user(target_user_id uuid) OWNER TO postgres;

--
-- TOC entry 518 (class 1255 OID 17598)
-- Name: admin_update_user_email(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
DECLARE
  caller_id UUID;
  caller_role app_role;
BEGIN
  caller_id := auth.uid();

  SELECT role INTO caller_role FROM public.user_roles WHERE user_id = caller_id;
  IF caller_role != 'admin' THEN
    RAISE EXCEPTION 'Apenas administradores podem alterar emails.';
  END IF;

  UPDATE auth.users
  SET email = new_email, email_confirmed_at = now()
  WHERE id = target_user_id;
END;
$$;


ALTER FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text) OWNER TO postgres;

--
-- TOC entry 517 (class 1255 OID 17597)
-- Name: admin_update_user_role(uuid, public.app_role); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_update_user_role(target_user_id uuid, new_role public.app_role) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  caller_id UUID;
  caller_role app_role;
  target_role app_role;
  admin_count INT;
BEGIN
  caller_id := auth.uid();

  SELECT role INTO caller_role FROM public.user_roles WHERE user_id = caller_id;
  IF caller_role != 'admin' THEN
    RAISE EXCEPTION 'Apenas administradores podem alterar perfis.';
  END IF;

  SELECT role INTO target_role FROM public.user_roles WHERE user_id = target_user_id;

  IF target_role = 'admin' AND new_role != 'admin' THEN
    IF target_user_id = caller_id THEN
       RAISE EXCEPTION 'Você não pode remover seu próprio acesso de administrador.';
    END IF;

    SELECT count(*) INTO admin_count FROM public.user_roles WHERE role = 'admin';
    IF admin_count <= 1 THEN
      RAISE EXCEPTION 'Não é possível remover o último administrador do sistema.';
    END IF;
  END IF;

  UPDATE public.user_roles SET role = new_role WHERE user_id = target_user_id;
END;
$$;


ALTER FUNCTION public.admin_update_user_role(target_user_id uuid, new_role public.app_role) OWNER TO postgres;

--
-- TOC entry 519 (class 1255 OID 22297)
-- Name: calc_discount_percentage(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calc_discount_percentage() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NEW.original_price IS NOT NULL AND NEW.original_price > 0 AND NEW.price IS NOT NULL THEN
    NEW.discount_percentage := ROUND(((NEW.original_price - NEW.price) / NEW.original_price) * 100, 1);
  ELSE
    NEW.discount_percentage := NULL;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.calc_discount_percentage() OWNER TO postgres;

--
-- TOC entry 514 (class 1255 OID 17594)
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  INSERT INTO public.profiles (user_id, full_name)
  VALUES (NEW.id, NEW.raw_user_meta_data ->> 'full_name');

  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'viewer')
  ON CONFLICT (user_id, role) DO NOTHING;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- TOC entry 515 (class 1255 OID 17595)
-- Name: has_role(uuid, public.app_role); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.has_role(_user_id uuid, _role public.app_role) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_roles
    WHERE user_id = _user_id
      AND role = _role
  )
$$;


ALTER FUNCTION public.has_role(_user_id uuid, _role public.app_role) OWNER TO postgres;

--
-- TOC entry 521 (class 1255 OID 22501)
-- Name: increment_product_clicks(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_product_clicks() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE public.products
    SET clicks = clicks + 1
    WHERE id = NEW.product_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.increment_product_clicks() OWNER TO postgres;

--
-- TOC entry 520 (class 1255 OID 22424)
-- Name: log_price_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_price_change() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    IF (TG_OP = 'INSERT') OR 
       (TG_OP = 'UPDATE' AND NEW.price IS DISTINCT FROM OLD.price) THEN
        INSERT INTO public.price_history (product_id, price)
        VALUES (NEW.id, NEW.price);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_price_change() OWNER TO postgres;

--
-- TOC entry 522 (class 1255 OID 23730)
-- Name: update_coupons_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_coupons_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_coupons_updated_at() OWNER TO postgres;

--
-- TOC entry 513 (class 1255 OID 17593)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- TOC entry 506 (class 1255 OID 17393)
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- TOC entry 512 (class 1255 OID 17472)
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- TOC entry 508 (class 1255 OID 17405)
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- TOC entry 504 (class 1255 OID 17355)
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- TOC entry 488 (class 1255 OID 17158)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- TOC entry 507 (class 1255 OID 17401)
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- TOC entry 509 (class 1255 OID 17412)
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- TOC entry 487 (class 1255 OID 17157)
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- TOC entry 511 (class 1255 OID 17471)
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- TOC entry 486 (class 1255 OID 17155)
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- TOC entry 505 (class 1255 OID 17382)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- TOC entry 510 (class 1255 OID 17465)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- TOC entry 495 (class 1255 OID 17222)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- TOC entry 498 (class 1255 OID 17278)
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- TOC entry 491 (class 1255 OID 17197)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 490 (class 1255 OID 17196)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 489 (class 1255 OID 17195)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 499 (class 1255 OID 17334)
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- TOC entry 492 (class 1255 OID 17209)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- TOC entry 496 (class 1255 OID 17261)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- TOC entry 500 (class 1255 OID 17335)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- TOC entry 497 (class 1255 OID 17277)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- TOC entry 503 (class 1255 OID 17341)
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- TOC entry 493 (class 1255 OID 17211)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- TOC entry 502 (class 1255 OID 17339)
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- TOC entry 501 (class 1255 OID 17338)
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- TOC entry 494 (class 1255 OID 17212)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 334 (class 1259 OID 16525)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- TOC entry 4794 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 354 (class 1259 OID 17078)
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 348 (class 1259 OID 16883)
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- TOC entry 4797 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 339 (class 1259 OID 16681)
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- TOC entry 4799 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 4800 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 333 (class 1259 OID 16518)
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- TOC entry 4802 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 343 (class 1259 OID 16770)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- TOC entry 4804 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 342 (class 1259 OID 16758)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 4806 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 341 (class 1259 OID 16745)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- TOC entry 4808 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 4809 (class 0 OID 0)
-- Dependencies: 341
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 351 (class 1259 OID 16995)
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- TOC entry 353 (class 1259 OID 17068)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- TOC entry 4812 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 350 (class 1259 OID 16965)
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- TOC entry 352 (class 1259 OID 17028)
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- TOC entry 349 (class 1259 OID 16933)
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 332 (class 1259 OID 16507)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 4817 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 331 (class 1259 OID 16506)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- TOC entry 4819 (class 0 OID 0)
-- Dependencies: 331
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 346 (class 1259 OID 16812)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 4821 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 347 (class 1259 OID 16830)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 335 (class 1259 OID 16533)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 340 (class 1259 OID 16711)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 4830 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 345 (class 1259 OID 16797)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 344 (class 1259 OID 16788)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 4834 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 344
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 330 (class 1259 OID 16495)
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 397 (class 1259 OID 27144)
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 396 (class 1259 OID 27121)
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- TOC entry 370 (class 1259 OID 17503)
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    full_name text,
    avatar_url text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    price_alert_opt_in boolean DEFAULT false NOT NULL,
    newsletter_opt_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- TOC entry 371 (class 1259 OID 17516)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role public.app_role DEFAULT 'viewer'::public.app_role NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 376 (class 1259 OID 17588)
-- Name: admin_users_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.admin_users_view AS
 SELECT p.id AS profile_id,
    p.avatar_url,
    p.full_name,
    p.is_active,
    p.created_at,
    ur.role,
    p.user_id,
    u.email
   FROM ((public.profiles p
     LEFT JOIN public.user_roles ur ON ((ur.user_id = p.user_id)))
     LEFT JOIN auth.users u ON ((u.id = p.user_id)));


ALTER VIEW public.admin_users_view OWNER TO postgres;

--
-- TOC entry 373 (class 1259 OID 17545)
-- Name: banners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banners (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    title text,
    subtitle text,
    image_url text NOT NULL,
    link_url text,
    cta_text text,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.banners OWNER TO postgres;

--
-- TOC entry 377 (class 1259 OID 22129)
-- Name: brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.brands OWNER TO postgres;

--
-- TOC entry 380 (class 1259 OID 22173)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    icon text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 393 (class 1259 OID 22458)
-- Name: coupon_votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupon_votes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    coupon_id uuid NOT NULL,
    user_id uuid,
    session_token uuid,
    is_working boolean NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.coupon_votes OWNER TO postgres;

--
-- TOC entry 392 (class 1259 OID 22441)
-- Name: coupons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    platform_id uuid NOT NULL,
    code text NOT NULL,
    description text,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    discount_amount character varying,
    discount_value character varying,
    subtitle character varying,
    conditions text,
    is_link_only boolean DEFAULT false,
    reports_inactive integer DEFAULT 0,
    link_url text,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.coupons OWNER TO postgres;

--
-- TOC entry 391 (class 1259 OID 22426)
-- Name: institutional_pages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.institutional_pages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    content_html text,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    section_type character varying DEFAULT 'support'::character varying
);


ALTER TABLE public.institutional_pages OWNER TO postgres;

--
-- TOC entry 399 (class 1259 OID 27177)
-- Name: ml_product_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ml_product_mappings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    ml_item_id text NOT NULL,
    ml_permalink text,
    ml_category_id text,
    ml_seller_id text,
    ml_condition text,
    ml_sold_quantity integer DEFAULT 0,
    ml_available_quantity integer,
    ml_rating_average numeric,
    ml_rating_count integer DEFAULT 0,
    ml_status text DEFAULT 'active'::text,
    ml_original_price numeric,
    ml_current_price numeric,
    ml_thumbnail text,
    sync_status text DEFAULT 'active'::text,
    last_synced_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ml_product_mappings OWNER TO postgres;

--
-- TOC entry 400 (class 1259 OID 27200)
-- Name: ml_sync_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ml_sync_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sync_type text NOT NULL,
    status text DEFAULT 'running'::text NOT NULL,
    items_processed integer DEFAULT 0,
    items_updated integer DEFAULT 0,
    items_deactivated integer DEFAULT 0,
    error_message text,
    triggered_by uuid,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ml_sync_logs OWNER TO postgres;

--
-- TOC entry 398 (class 1259 OID 27166)
-- Name: ml_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ml_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    access_token text NOT NULL,
    refresh_token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    ml_user_id text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ml_tokens OWNER TO postgres;

--
-- TOC entry 378 (class 1259 OID 22142)
-- Name: models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    brand_id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.models OWNER TO postgres;

--
-- TOC entry 389 (class 1259 OID 22381)
-- Name: newsletter_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.newsletter_products (
    newsletter_id uuid NOT NULL,
    product_id uuid NOT NULL
);


ALTER TABLE public.newsletter_products OWNER TO postgres;

--
-- TOC entry 388 (class 1259 OID 22370)
-- Name: newsletters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.newsletters (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject text NOT NULL,
    html_content text,
    status text DEFAULT 'draft'::text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT newsletters_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'sent'::text])))
);


ALTER TABLE public.newsletters OWNER TO postgres;

--
-- TOC entry 379 (class 1259 OID 22160)
-- Name: platforms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platforms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    logo_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.platforms OWNER TO postgres;

--
-- TOC entry 390 (class 1259 OID 22408)
-- Name: price_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    price numeric NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.price_history OWNER TO postgres;

--
-- TOC entry 386 (class 1259 OID 22328)
-- Name: product_clicks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_clicks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    user_id uuid,
    session_token uuid,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.product_clicks OWNER TO postgres;

--
-- TOC entry 385 (class 1259 OID 22254)
-- Name: product_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_likes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_likes OWNER TO postgres;

--
-- TOC entry 387 (class 1259 OID 22349)
-- Name: product_trust_votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_trust_votes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    user_id uuid,
    session_token uuid,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    is_trusted boolean DEFAULT true
);


ALTER TABLE public.product_trust_votes OWNER TO postgres;

--
-- TOC entry 372 (class 1259 OID 17530)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    price numeric NOT NULL,
    original_price numeric,
    discount integer,
    image_url text,
    gallery_urls text[] DEFAULT '{}'::text[],
    badge text,
    store text NOT NULL,
    affiliate_url text NOT NULL,
    rating numeric DEFAULT 0 NOT NULL,
    review_count integer DEFAULT 0 NOT NULL,
    clicks integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    brand_id uuid,
    model_id uuid,
    platform_id uuid,
    video_url text,
    discount_percentage numeric,
    registered_by uuid,
    category_id uuid,
    external_id character varying,
    commission_rate numeric,
    sales_count integer DEFAULT 0,
    features jsonb DEFAULT '[]'::jsonb,
    available_quantity integer
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 372
-- Name: COLUMN products.external_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.external_id IS 'ID do produto na plataforma externa (ex.: Shopee) para sincronização';


--
-- TOC entry 375 (class 1259 OID 17573)
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    reporter_email text NOT NULL,
    report_type text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    resolved_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- TOC entry 374 (class 1259 OID 17557)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    user_id uuid,
    user_name text NOT NULL,
    rating integer NOT NULL,
    comment text,
    status text DEFAULT 'approved'::text NOT NULL,
    helpful_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 401 (class 1259 OID 27214)
-- Name: search_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.search_cache (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    keyword text NOT NULL,
    offset_val integer NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '24:00:00'::interval)
);


ALTER TABLE public.search_cache OWNER TO postgres;

--
-- TOC entry 394 (class 1259 OID 25968)
-- Name: shopee_product_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shopee_product_mappings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    shopee_item_id text NOT NULL,
    shopee_shop_id text,
    shopee_offer_id text,
    shopee_commission_rate numeric,
    shopee_image_url text,
    shopee_product_url text,
    shopee_short_link text,
    last_synced_at timestamp with time zone DEFAULT now(),
    sync_status text DEFAULT 'active'::text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.shopee_product_mappings OWNER TO postgres;

--
-- TOC entry 395 (class 1259 OID 25986)
-- Name: shopee_sync_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shopee_sync_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sync_type text NOT NULL,
    status text DEFAULT 'running'::text NOT NULL,
    items_processed integer DEFAULT 0,
    items_updated integer DEFAULT 0,
    items_deactivated integer DEFAULT 0,
    error_message text,
    triggered_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone
);


ALTER TABLE public.shopee_sync_logs OWNER TO postgres;

--
-- TOC entry 382 (class 1259 OID 22202)
-- Name: special_page_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.special_page_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    special_page_id uuid NOT NULL,
    product_id uuid NOT NULL
);


ALTER TABLE public.special_page_products OWNER TO postgres;

--
-- TOC entry 381 (class 1259 OID 22188)
-- Name: special_pages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.special_pages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    description text,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.special_pages OWNER TO postgres;

--
-- TOC entry 383 (class 1259 OID 22222)
-- Name: whatsapp_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.whatsapp_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    link text NOT NULL,
    active boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name text DEFAULT 'Geral'::text NOT NULL
);


ALTER TABLE public.whatsapp_groups OWNER TO postgres;

--
-- TOC entry 384 (class 1259 OID 22234)
-- Name: wishlists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wishlists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.wishlists OWNER TO postgres;

--
-- TOC entry 369 (class 1259 OID 17475)
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- TOC entry 355 (class 1259 OID 17120)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- TOC entry 358 (class 1259 OID 17143)
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- TOC entry 357 (class 1259 OID 17142)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 360 (class 1259 OID 17167)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- TOC entry 4879 (class 0 OID 0)
-- Dependencies: 360
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 364 (class 1259 OID 17286)
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- TOC entry 365 (class 1259 OID 17299)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- TOC entry 359 (class 1259 OID 17159)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- TOC entry 361 (class 1259 OID 17177)
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- TOC entry 4883 (class 0 OID 0)
-- Dependencies: 361
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 362 (class 1259 OID 17226)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- TOC entry 363 (class 1259 OID 17240)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- TOC entry 366 (class 1259 OID 17309)
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- TOC entry 3790 (class 2604 OID 16510)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4624 (class 0 OID 16525)
-- Dependencies: 334
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4641 (class 0 OID 17078)
-- Dependencies: 354
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4635 (class 0 OID 16883)
-- Dependencies: 348
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4626 (class 0 OID 16681)
-- Dependencies: 339
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.identities VALUES ('18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{"sub": "18826abb-41b4-49d6-a62d-1ec9b3a0ddb6", "email": "giulianomsg@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2026-03-11 03:11:05.1897+00', '2026-03-11 03:11:05.189767+00', '2026-03-11 03:11:05.189767+00', DEFAULT, 'faa3c8bc-d72c-4e3c-bf4e-504363dd9cf4');
INSERT INTO auth.identities VALUES ('2374d4c0-d9a8-455f-925d-f42f42f3522d', '2374d4c0-d9a8-455f-925d-f42f42f3522d', '{"sub": "2374d4c0-d9a8-455f-925d-f42f42f3522d", "email": "gmgarcia@educacao.riopreto.sp.gov.br", "full_name": "Giuliano Moretti", "email_verified": true, "phone_verified": false}', 'email', '2026-03-15 18:38:52.015842+00', '2026-03-15 18:38:52.015891+00', '2026-03-15 18:38:52.015891+00', DEFAULT, 'ea4846c0-1e3f-48b6-8777-9c992f28f8ae');
INSERT INTO auth.identities VALUES ('ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{"sub": "ae8dfd8c-5182-41d7-9a4a-c02ebba36890", "email": "amandacsagres@gmail.com", "full_name": "Amanda Cristine Sagres", "email_verified": true, "phone_verified": false}', 'email', '2026-03-16 20:09:55.952579+00', '2026-03-16 20:09:55.952633+00', '2026-03-16 20:09:55.952633+00', DEFAULT, '657419e6-8c01-44e4-b6c1-2bde2f319fb0');


--
-- TOC entry 4623 (class 0 OID 16518)
-- Dependencies: 333
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4630 (class 0 OID 16770)
-- Dependencies: 343
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.mfa_amr_claims VALUES ('2d23dd81-e3fc-45e3-9204-b8a7df5ef957', '2026-03-15 20:54:23.429385+00', '2026-03-15 20:54:23.429385+00', 'password', 'f2f24eb2-0da4-4084-ab3b-c889669231e3');
INSERT INTO auth.mfa_amr_claims VALUES ('c39787a4-367e-423f-91d2-f44e33a7b89c', '2026-03-15 20:59:04.009663+00', '2026-03-15 20:59:04.009663+00', 'password', '1282d885-d7e5-48b5-80a3-cdef219f94f8');
INSERT INTO auth.mfa_amr_claims VALUES ('23bcaafe-f8ed-4c0f-b1d1-d661afde043b', '2026-03-16 02:53:23.47674+00', '2026-03-16 02:53:23.47674+00', 'password', '5125763a-5142-4641-8bd0-669de1228308');
INSERT INTO auth.mfa_amr_claims VALUES ('c59870a3-e20f-4a00-804b-2add6ae67ef8', '2026-03-16 14:21:34.666146+00', '2026-03-16 14:21:34.666146+00', 'password', '28942304-544c-43de-908e-236fcc5144f7');
INSERT INTO auth.mfa_amr_claims VALUES ('375aa9ec-14cc-4927-a768-8aabcad473a9', '2026-03-16 14:31:53.236414+00', '2026-03-16 14:31:53.236414+00', 'password', '3c20902a-9066-44a3-b495-f9b4455fc07f');
INSERT INTO auth.mfa_amr_claims VALUES ('943a8995-1ad4-4c7f-8117-cf869d72dedc', '2026-03-16 20:10:03.595461+00', '2026-03-16 20:10:03.595461+00', 'otp', 'f754e5c2-20ea-426b-bcb5-03820ce65b63');
INSERT INTO auth.mfa_amr_claims VALUES ('6a2600de-650c-4ef8-a318-fe600e3c1ed1', '2026-03-16 23:49:17.672538+00', '2026-03-16 23:49:17.672538+00', 'password', '9adfe2f5-fb85-4584-8af6-2f3e1086262a');
INSERT INTO auth.mfa_amr_claims VALUES ('f8e2d125-c2a4-4fdc-90b7-0de505c6ebe7', '2026-03-21 03:19:32.740003+00', '2026-03-21 03:19:32.740003+00', 'password', 'df1b2b3e-477e-44b5-b273-0319ec789633');
INSERT INTO auth.mfa_amr_claims VALUES ('67dbb4d0-394a-46f2-ad92-868a640a05d6', '2026-03-21 03:32:05.622498+00', '2026-03-21 03:32:05.622498+00', 'password', '15d6f3c5-1c0e-4e87-b199-1e2511c07c93');
INSERT INTO auth.mfa_amr_claims VALUES ('b32dd5ec-32dc-4a8f-9da9-6cb0b1d763be', '2026-03-21 05:16:32.399677+00', '2026-03-21 05:16:32.399677+00', 'password', 'b2332853-38fc-4e8d-942d-c59a2ebdcf94');
INSERT INTO auth.mfa_amr_claims VALUES ('c134e625-e4b0-4a0c-b15d-a4a1c93c9857', '2026-03-21 16:52:31.484395+00', '2026-03-21 16:52:31.484395+00', 'password', '2273b0f4-3fd9-48d1-ab7f-3df59c1b1c67');


--
-- TOC entry 4629 (class 0 OID 16758)
-- Dependencies: 342
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4628 (class 0 OID 16745)
-- Dependencies: 341
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4638 (class 0 OID 16995)
-- Dependencies: 351
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4640 (class 0 OID 17068)
-- Dependencies: 353
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4637 (class 0 OID 16965)
-- Dependencies: 350
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4639 (class 0 OID 17028)
-- Dependencies: 352
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4636 (class 0 OID 16933)
-- Dependencies: 349
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4622 (class 0 OID 16507)
-- Dependencies: 332
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 36, '7eqimsw6rsyb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-15 23:43:29.228758+00', '2026-03-16 00:42:48.100002+00', 'bhtzia4s3h32', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 39, '4sn2o6wvwv6t', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-16 00:42:48.116123+00', '2026-03-16 01:57:16.074865+00', '7eqimsw6rsyb', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 40, '2fh3wsgifsiu', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-16 01:57:16.103962+00', '2026-03-16 03:08:31.019311+00', '4sn2o6wvwv6t', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 44, 'jovez36snlmw', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-16 03:08:31.029577+00', '2026-03-16 04:09:35.529795+00', '2fh3wsgifsiu', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 43, '5zzo4eiyd3e3', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-16 02:53:23.468737+00', '2026-03-16 04:09:35.526859+00', NULL, '23bcaafe-f8ed-4c0f-b1d1-d661afde043b');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 47, 'dxyqzzgvdy52', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-16 14:21:34.637293+00', '2026-03-16 19:36:26.374027+00', NULL, 'c59870a3-e20f-4a00-804b-2add6ae67ef8');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 48, 'iudxzbnpcypk', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-16 14:31:53.218192+00', '2026-03-16 19:44:00.388474+00', NULL, '375aa9ec-14cc-4927-a768-8aabcad473a9');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 51, 'v6ytifw5uddr', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', false, '2026-03-16 20:10:03.576033+00', '2026-03-16 20:10:03.576033+00', NULL, '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 37, 'syclgsxqd4pw', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-15 23:45:08.781362+00', '2026-03-17 01:12:51.831632+00', 'gsz2a6nluohe', 'c39787a4-367e-423f-91d2-f44e33a7b89c');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 46, 'gtock6kr25nq', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-16 04:09:35.680832+00', '2026-03-17 03:04:06.120469+00', '5zzo4eiyd3e3', '23bcaafe-f8ed-4c0f-b1d1-d661afde043b');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 45, 'snca2t2ltyb6', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-16 04:09:35.680843+00', '2026-03-17 03:14:00.367198+00', 'jovez36snlmw', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 54, 'in4pqcgv5ei7', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-17 03:04:06.134198+00', '2026-03-17 04:06:38.324816+00', 'gtock6kr25nq', '23bcaafe-f8ed-4c0f-b1d1-d661afde043b');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 55, 'inx7yqnn65yt', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-17 03:14:00.381792+00', '2026-03-17 04:12:34.422923+00', 'snca2t2ltyb6', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 53, 'wx65rxihui6c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-17 01:12:51.856086+00', '2026-03-17 04:19:33.240306+00', 'syclgsxqd4pw', 'c39787a4-367e-423f-91d2-f44e33a7b89c');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 58, 'a3w4ezhd3bcu', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-17 04:19:33.245766+00', '2026-03-17 10:33:18.134365+00', 'wx65rxihui6c', 'c39787a4-367e-423f-91d2-f44e33a7b89c');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 49, 'x43uyjtdm25c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-16 19:36:26.40416+00', '2026-03-17 10:55:13.852347+00', 'dxyqzzgvdy52', 'c59870a3-e20f-4a00-804b-2add6ae67ef8');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 50, 'bskbd64ezzg3', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-16 19:44:00.398119+00', '2026-03-17 10:55:13.852536+00', 'iudxzbnpcypk', '375aa9ec-14cc-4927-a768-8aabcad473a9');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 61, 'fe3qprzxqgvv', '2374d4c0-d9a8-455f-925d-f42f42f3522d', false, '2026-03-17 10:55:13.862261+00', '2026-03-17 10:55:13.862261+00', 'bskbd64ezzg3', '375aa9ec-14cc-4927-a768-8aabcad473a9');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 56, 'vkzdmdqmp76q', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-17 04:06:38.345845+00', '2026-03-17 21:58:35.142591+00', 'in4pqcgv5ei7', '23bcaafe-f8ed-4c0f-b1d1-d661afde043b');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 57, 'mynsxdib4bjf', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-17 04:12:34.428443+00', '2026-03-17 21:58:54.439372+00', 'inx7yqnn65yt', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 59, 'ycf73lodwds4', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-17 10:33:18.168156+00', '2026-03-17 22:45:02.178318+00', 'a3w4ezhd3bcu', 'c39787a4-367e-423f-91d2-f44e33a7b89c');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 63, '2uxmtyy4nffk', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-17 21:58:54.439763+00', '2026-03-18 03:35:32.501466+00', 'mynsxdib4bjf', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 62, '3exatqgghsol', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-17 21:58:35.153632+00', '2026-03-18 03:36:40.614887+00', 'vkzdmdqmp76q', '23bcaafe-f8ed-4c0f-b1d1-d661afde043b');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 30, 'wlw7ht23cq7l', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-15 20:54:23.411393+00', '2026-03-15 22:43:16.725198+00', NULL, '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 66, '75ztfytktdyd', '2374d4c0-d9a8-455f-925d-f42f42f3522d', false, '2026-03-18 03:36:40.616333+00', '2026-03-18 03:36:40.616333+00', '3exatqgghsol', '23bcaafe-f8ed-4c0f-b1d1-d661afde043b');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 60, '5kzjwtaswzqe', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-17 10:55:13.862255+00', '2026-03-18 16:40:53.956515+00', 'x43uyjtdm25c', 'c59870a3-e20f-4a00-804b-2add6ae67ef8');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 34, 'bhtzia4s3h32', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-15 22:43:16.750481+00', '2026-03-15 23:43:29.212785+00', 'wlw7ht23cq7l', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 32, 'gsz2a6nluohe', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-15 20:59:04.005896+00', '2026-03-15 23:45:08.780432+00', NULL, 'c39787a4-367e-423f-91d2-f44e33a7b89c');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 67, 'c5xbsdoyg4ag', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-18 16:40:53.982609+00', '2026-03-18 16:40:53.982609+00', '5kzjwtaswzqe', 'c59870a3-e20f-4a00-804b-2add6ae67ef8');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 52, 'hcjwacsipuvb', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-16 23:49:17.638416+00', '2026-03-18 21:39:25.953941+00', NULL, '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 68, 'rhm535qhibvj', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', false, '2026-03-18 21:39:25.981485+00', '2026-03-18 21:39:25.981485+00', 'hcjwacsipuvb', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 65, 'rvrhw46i63z5', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-18 03:35:32.554161+00', '2026-03-19 15:01:25.698544+00', '2uxmtyy4nffk', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 69, 'vvm6srfnkch5', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-19 15:01:25.728918+00', '2026-03-19 16:57:21.29549+00', 'rvrhw46i63z5', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 70, 'z5bu5rtppbo2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-19 16:57:21.325076+00', '2026-03-19 17:56:35.778417+00', 'vvm6srfnkch5', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 71, 'ec73mt3brtkn', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-19 17:56:35.785961+00', '2026-03-19 18:55:46.330739+00', 'z5bu5rtppbo2', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 72, '3ffaxgiirb5i', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-19 18:55:46.338259+00', '2026-03-19 20:14:26.973003+00', 'ec73mt3brtkn', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 73, 'zftw2kvvu2ee', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-19 20:14:26.989927+00', '2026-03-19 21:28:11.611817+00', '3ffaxgiirb5i', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 74, 'y2fgwlswbab4', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-19 21:28:11.624729+00', '2026-03-19 22:27:34.913652+00', 'zftw2kvvu2ee', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 75, 'j3ze6ia6hyn6', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-19 22:27:34.928307+00', '2026-03-20 00:02:49.341191+00', 'y2fgwlswbab4', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 76, '4y3rhmi5rowm', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-20 00:02:49.370835+00', '2026-03-20 01:01:56.740153+00', 'j3ze6ia6hyn6', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 77, 'yijl5ipskkyb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-20 01:01:56.765047+00', '2026-03-20 02:24:03.800903+00', '4y3rhmi5rowm', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 78, 'pkbpg7lrzmz4', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-20 02:24:03.821088+00', '2026-03-20 03:28:38.532146+00', 'yijl5ipskkyb', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 79, 'g3sgh5ycbmbh', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-20 03:28:38.550507+00', '2026-03-20 16:36:03.522964+00', 'pkbpg7lrzmz4', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 80, '5xdvolifq752', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-20 16:36:03.549616+00', '2026-03-20 18:56:19.035577+00', 'g3sgh5ycbmbh', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 64, 'dqrzpoepdjsw', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-17 22:45:02.207114+00', '2026-03-20 21:17:01.319308+00', 'ycf73lodwds4', 'c39787a4-367e-423f-91d2-f44e33a7b89c');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 82, 'vmk6vwxavfdx', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-20 21:17:01.342973+00', '2026-03-20 21:17:01.342973+00', 'dqrzpoepdjsw', 'c39787a4-367e-423f-91d2-f44e33a7b89c');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 81, 'ejhsttywwihj', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-20 18:56:19.064549+00', '2026-03-21 00:14:33.841295+00', '5xdvolifq752', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 83, 'v45kpb4hwrj3', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-21 00:14:33.84707+00', '2026-03-21 01:22:46.311476+00', 'ejhsttywwihj', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 84, 'vmes6jp2liqb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-21 01:22:46.349704+00', '2026-03-21 02:26:54.043519+00', 'v45kpb4hwrj3', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 85, 'va54zngoawhs', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-21 02:26:54.069841+00', '2026-03-21 02:26:54.069841+00', 'vmes6jp2liqb', '2d23dd81-e3fc-45e3-9204-b8a7df5ef957');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 87, 'lzhakj7a5c52', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-21 03:32:05.599214+00', '2026-03-21 03:32:05.599214+00', NULL, '67dbb4d0-394a-46f2-ad92-868a640a05d6');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 86, 'vdsnhkns47mv', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-21 03:19:32.69934+00', '2026-03-21 04:20:14.175285+00', NULL, 'f8e2d125-c2a4-4fdc-90b7-0de505c6ebe7');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 88, 'n2u5tx75wnb4', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-21 04:20:14.189027+00', '2026-03-21 04:20:14.189027+00', 'vdsnhkns47mv', 'f8e2d125-c2a4-4fdc-90b7-0de505c6ebe7');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 89, 'asky2n2a3h2k', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-21 05:16:32.357492+00', '2026-03-21 06:16:51.324498+00', NULL, 'b32dd5ec-32dc-4a8f-9da9-6cb0b1d763be');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 90, 'jeihtk2i5ozc', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-21 06:16:51.338807+00', '2026-03-21 07:15:38.596315+00', 'asky2n2a3h2k', 'b32dd5ec-32dc-4a8f-9da9-6cb0b1d763be');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 91, 'cteaxqy2bbjb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-21 07:15:38.601966+00', '2026-03-21 15:41:38.489247+00', 'jeihtk2i5ozc', 'b32dd5ec-32dc-4a8f-9da9-6cb0b1d763be');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 92, 'izyr4maiyfvx', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-21 15:41:38.506835+00', '2026-03-21 16:40:46.436576+00', 'cteaxqy2bbjb', 'b32dd5ec-32dc-4a8f-9da9-6cb0b1d763be');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 93, 'e2pxtpcvqynp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-21 16:40:46.459847+00', '2026-03-21 16:40:46.459847+00', 'izyr4maiyfvx', 'b32dd5ec-32dc-4a8f-9da9-6cb0b1d763be');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 94, 'b36kyt73mfln', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-21 16:52:31.470053+00', '2026-03-21 18:03:11.513573+00', NULL, 'c134e625-e4b0-4a0c-b15d-a4a1c93c9857');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 95, 'ij7misx4tojf', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-21 18:03:11.525875+00', '2026-03-21 18:03:11.525875+00', 'b36kyt73mfln', 'c134e625-e4b0-4a0c-b15d-a4a1c93c9857');


--
-- TOC entry 4633 (class 0 OID 16812)
-- Dependencies: 346
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4634 (class 0 OID 16830)
-- Dependencies: 347
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4625 (class 0 OID 16533)
-- Dependencies: 335
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.schema_migrations VALUES ('20171026211738');
INSERT INTO auth.schema_migrations VALUES ('20171026211808');
INSERT INTO auth.schema_migrations VALUES ('20171026211834');
INSERT INTO auth.schema_migrations VALUES ('20180103212743');
INSERT INTO auth.schema_migrations VALUES ('20180108183307');
INSERT INTO auth.schema_migrations VALUES ('20180119214651');
INSERT INTO auth.schema_migrations VALUES ('20180125194653');
INSERT INTO auth.schema_migrations VALUES ('00');
INSERT INTO auth.schema_migrations VALUES ('20210710035447');
INSERT INTO auth.schema_migrations VALUES ('20210722035447');
INSERT INTO auth.schema_migrations VALUES ('20210730183235');
INSERT INTO auth.schema_migrations VALUES ('20210909172000');
INSERT INTO auth.schema_migrations VALUES ('20210927181326');
INSERT INTO auth.schema_migrations VALUES ('20211122151130');
INSERT INTO auth.schema_migrations VALUES ('20211124214934');
INSERT INTO auth.schema_migrations VALUES ('20211202183645');
INSERT INTO auth.schema_migrations VALUES ('20220114185221');
INSERT INTO auth.schema_migrations VALUES ('20220114185340');
INSERT INTO auth.schema_migrations VALUES ('20220224000811');
INSERT INTO auth.schema_migrations VALUES ('20220323170000');
INSERT INTO auth.schema_migrations VALUES ('20220429102000');
INSERT INTO auth.schema_migrations VALUES ('20220531120530');
INSERT INTO auth.schema_migrations VALUES ('20220614074223');
INSERT INTO auth.schema_migrations VALUES ('20220811173540');
INSERT INTO auth.schema_migrations VALUES ('20221003041349');
INSERT INTO auth.schema_migrations VALUES ('20221003041400');
INSERT INTO auth.schema_migrations VALUES ('20221011041400');
INSERT INTO auth.schema_migrations VALUES ('20221020193600');
INSERT INTO auth.schema_migrations VALUES ('20221021073300');
INSERT INTO auth.schema_migrations VALUES ('20221021082433');
INSERT INTO auth.schema_migrations VALUES ('20221027105023');
INSERT INTO auth.schema_migrations VALUES ('20221114143122');
INSERT INTO auth.schema_migrations VALUES ('20221114143410');
INSERT INTO auth.schema_migrations VALUES ('20221125140132');
INSERT INTO auth.schema_migrations VALUES ('20221208132122');
INSERT INTO auth.schema_migrations VALUES ('20221215195500');
INSERT INTO auth.schema_migrations VALUES ('20221215195800');
INSERT INTO auth.schema_migrations VALUES ('20221215195900');
INSERT INTO auth.schema_migrations VALUES ('20230116124310');
INSERT INTO auth.schema_migrations VALUES ('20230116124412');
INSERT INTO auth.schema_migrations VALUES ('20230131181311');
INSERT INTO auth.schema_migrations VALUES ('20230322519590');
INSERT INTO auth.schema_migrations VALUES ('20230402418590');
INSERT INTO auth.schema_migrations VALUES ('20230411005111');
INSERT INTO auth.schema_migrations VALUES ('20230508135423');
INSERT INTO auth.schema_migrations VALUES ('20230523124323');
INSERT INTO auth.schema_migrations VALUES ('20230818113222');
INSERT INTO auth.schema_migrations VALUES ('20230914180801');
INSERT INTO auth.schema_migrations VALUES ('20231027141322');
INSERT INTO auth.schema_migrations VALUES ('20231114161723');
INSERT INTO auth.schema_migrations VALUES ('20231117164230');
INSERT INTO auth.schema_migrations VALUES ('20240115144230');
INSERT INTO auth.schema_migrations VALUES ('20240214120130');
INSERT INTO auth.schema_migrations VALUES ('20240306115329');
INSERT INTO auth.schema_migrations VALUES ('20240314092811');
INSERT INTO auth.schema_migrations VALUES ('20240427152123');
INSERT INTO auth.schema_migrations VALUES ('20240612123726');
INSERT INTO auth.schema_migrations VALUES ('20240729123726');
INSERT INTO auth.schema_migrations VALUES ('20240802193726');
INSERT INTO auth.schema_migrations VALUES ('20240806073726');
INSERT INTO auth.schema_migrations VALUES ('20241009103726');
INSERT INTO auth.schema_migrations VALUES ('20250717082212');
INSERT INTO auth.schema_migrations VALUES ('20250731150234');
INSERT INTO auth.schema_migrations VALUES ('20250804100000');
INSERT INTO auth.schema_migrations VALUES ('20250901200500');
INSERT INTO auth.schema_migrations VALUES ('20250903112500');
INSERT INTO auth.schema_migrations VALUES ('20250904133000');
INSERT INTO auth.schema_migrations VALUES ('20250925093508');
INSERT INTO auth.schema_migrations VALUES ('20251007112900');
INSERT INTO auth.schema_migrations VALUES ('20251104100000');
INSERT INTO auth.schema_migrations VALUES ('20251111201300');
INSERT INTO auth.schema_migrations VALUES ('20251201000000');
INSERT INTO auth.schema_migrations VALUES ('20260115000000');
INSERT INTO auth.schema_migrations VALUES ('20260121000000');
INSERT INTO auth.schema_migrations VALUES ('20260219120000');
INSERT INTO auth.schema_migrations VALUES ('20260302000000');


--
-- TOC entry 4627 (class 0 OID 16711)
-- Dependencies: 340
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.sessions VALUES ('23bcaafe-f8ed-4c0f-b1d1-d661afde043b', '2374d4c0-d9a8-455f-925d-f42f42f3522d', '2026-03-16 02:53:23.461588+00', '2026-03-18 03:36:40.621703+00', NULL, 'aal1', NULL, '2026-03-18 03:36:40.621599', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '201.22.217.10', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('c59870a3-e20f-4a00-804b-2add6ae67ef8', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 14:21:34.611833+00', '2026-03-18 16:40:54.014564+00', NULL, 'aal1', NULL, '2026-03-18 16:40:54.014458', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '186.225.138.87', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('6a2600de-650c-4ef8-a318-fe600e3c1ed1', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:49:17.589348+00', '2026-03-18 21:39:26.015408+00', NULL, 'aal1', NULL, '2026-03-18 21:39:26.015259', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '187.181.208.92', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('b32dd5ec-32dc-4a8f-9da9-6cb0b1d763be', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 05:16:32.316897+00', '2026-03-21 16:40:46.488458+00', NULL, 'aal1', NULL, '2026-03-21 16:40:46.487857', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '177.146.157.185', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('c134e625-e4b0-4a0c-b15d-a4a1c93c9857', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 16:52:31.455604+00', '2026-03-21 18:03:11.54329+00', NULL, 'aal1', NULL, '2026-03-21 18:03:11.543159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '177.146.157.185', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('943a8995-1ad4-4c7f-8117-cf869d72dedc', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:10:03.564061+00', '2026-03-16 20:10:03.564061+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '186.225.138.87', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('c39787a4-367e-423f-91d2-f44e33a7b89c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 20:59:03.99907+00', '2026-03-20 21:17:01.381906+00', NULL, 'aal1', NULL, '2026-03-20 21:17:01.381782', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '177.146.157.185', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('375aa9ec-14cc-4927-a768-8aabcad473a9', '2374d4c0-d9a8-455f-925d-f42f42f3522d', '2026-03-16 14:31:53.196959+00', '2026-03-17 10:55:13.876345+00', NULL, 'aal1', NULL, '2026-03-17 10:55:13.876239', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '186.225.138.87', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('2d23dd81-e3fc-45e3-9204-b8a7df5ef957', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 20:54:23.391956+00', '2026-03-21 02:26:54.09612+00', NULL, 'aal1', NULL, '2026-03-21 02:26:54.096011', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '177.146.157.185', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('67dbb4d0-394a-46f2-ad92-868a640a05d6', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 03:32:05.568472+00', '2026-03-21 03:32:05.568472+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '177.146.157.185', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('f8e2d125-c2a4-4fdc-90b7-0de505c6ebe7', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 03:19:32.664257+00', '2026-03-21 04:20:14.206762+00', NULL, 'aal1', NULL, '2026-03-21 04:20:14.205949', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '177.146.157.185', NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4632 (class 0 OID 16797)
-- Dependencies: 345
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4631 (class 0 OID 16788)
-- Dependencies: 344
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4620 (class 0 OID 16495)
-- Dependencies: 330
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000000', '2374d4c0-d9a8-455f-925d-f42f42f3522d', 'authenticated', 'authenticated', 'gmgarcia@educacao.riopreto.sp.gov.br', '$2a$10$utMzV3mF5nCJwUmbLzz4j.FtKhzsK006mmYSKhZ3rL1RucQYeR1hW', '2026-03-15 18:39:06.954771+00', NULL, '', '2026-03-15 18:38:52.02234+00', '', NULL, '', '', NULL, '2026-03-16 14:31:53.196848+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "2374d4c0-d9a8-455f-925d-f42f42f3522d", "email": "gmgarcia@educacao.riopreto.sp.gov.br", "full_name": "Giuliano Moretti", "email_verified": true, "phone_verified": false}', NULL, '2026-03-15 18:38:51.985624+00', '2026-03-18 03:36:40.617731+00', NULL, NULL, '', '', NULL, DEFAULT, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000000', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'authenticated', 'authenticated', 'amandacsagres@gmail.com', '$2a$10$GLlS9ei/99QSbTqAQloh6uEQMTIGAC/OlOxanAZ1joR71jDqVjG.W', '2026-03-16 20:12:26.749522+00', NULL, '', '2026-03-16 20:09:55.959872+00', '', NULL, '', '', NULL, '2026-03-16 23:49:17.589237+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "ae8dfd8c-5182-41d7-9a4a-c02ebba36890", "email": "amandacsagres@gmail.com", "full_name": "Amanda Cristine Sagres", "email_verified": true, "phone_verified": false}', NULL, '2026-03-16 20:09:55.917662+00', '2026-03-18 21:39:25.995612+00', NULL, NULL, '', '', NULL, DEFAULT, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000000', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'authenticated', 'authenticated', 'giulianomsg@gmail.com', '$2a$10$7eDvyxe8qiBx6Ejse0mkfe0jNbUV0IzQfs0Re07k5WEBUkiVN7kA.', '2026-03-11 03:25:19.886791+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-03-21 16:52:31.455502+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-03-11 03:11:05.174437+00', '2026-03-21 18:03:11.529925+00', NULL, NULL, '', '', NULL, DEFAULT, '', 0, NULL, '', NULL, false, NULL, false);


--
-- TOC entry 4679 (class 0 OID 27144)
-- Dependencies: 397
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4678 (class 0 OID 27121)
-- Dependencies: 396
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4656 (class 0 OID 17545)
-- Dependencies: 373
-- Data for Name: banners; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.banners VALUES ('09c0e1ec-56a5-42c4-9343-104f2620128a', NULL, NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1773615722587-3l91xmo00el.jpg', NULL, NULL, true, 0, '2026-03-11 03:27:31.917478+00', '2026-03-15 23:02:39.860054+00');
INSERT INTO public.banners VALUES ('f31321c2-ee84-4415-96e5-6fc6cf798dab', NULL, NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1773618191923-uuta2v4negc.png', NULL, NULL, true, 0, '2026-03-15 23:12:19.630775+00', '2026-03-15 23:43:53.043374+00');
INSERT INTO public.banners VALUES ('e195f47f-274c-4369-9c09-56a0cda2c334', 'Kit teclado e mouse gamer mouse teclado', 'Teclado Semi Mecânico + Mouse Gamer 3200dpi Rgb Led -H8', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1773619742849-3r8lt9lwull.jpg', '/produto/867a5ff6-2980-4961-a3d9-58b8a5a55425', 'Acesse a oferta', true, 0, '2026-03-16 00:02:57.472737+00', '2026-03-16 00:33:16.493672+00');
INSERT INTO public.banners VALUES ('e92a35ec-664d-4eac-b1ce-7f1cd855b965', 'Aspirador Vertical de Pó Liectroux i7 Pro Sem Fio 3 em 1 ', 'Aspira Passa Pano Autolimpante Para Sólidos e Líquidos Pelos de Pet Cachorro Gato Potente Com Filtro HEPA Bivolt', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1773619766735-e310yiv6wj.jpg', '/produto/cfd08ce1-1a30-4472-b0f9-5a431668b8bc', 'Acesse a oferta', true, 0, '2026-03-16 00:03:38.295627+00', '2026-03-16 00:34:33.496448+00');


--
-- TOC entry 4659 (class 0 OID 22129)
-- Dependencies: 377
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.brands VALUES ('d222f8c0-49d1-499d-880f-3e823cebdab5', 'LCK', '2026-03-15 23:41:27.028182+00');
INSERT INTO public.brands VALUES ('612e31cb-cfe0-4ff8-a433-6f258080ae75', 'LG', '2026-03-16 14:27:32.098644+00');
INSERT INTO public.brands VALUES ('22e97655-8957-45f8-9512-3fb1d2b14b9f', 'EQUALIV', '2026-03-16 19:38:37.543101+00');
INSERT INTO public.brands VALUES ('a38d407c-b47d-40d8-9bf8-5852b8dcd927', 'Imperial', '2026-03-16 20:24:51.379694+00');
INSERT INTO public.brands VALUES ('2f146099-debe-472a-9333-7229545a2f08', 'Elgin', '2026-03-16 23:53:15.649782+00');
INSERT INTO public.brands VALUES ('fa5f9497-65b1-4e55-8e15-251f6004750c', 'Macrilan', '2026-03-17 00:37:18.180949+00');
INSERT INTO public.brands VALUES ('ba613e78-541a-42cd-af86-a45ce0aeb055', 'Cadence', '2026-03-17 00:04:01.307689+00');
INSERT INTO public.brands VALUES ('fd806438-e4a9-4afa-a0c7-a16338105f8d', 'EOS', '2026-03-18 16:49:54.408017+00');
INSERT INTO public.brands VALUES ('fc7eff8d-8e39-4384-8816-16da373293e5', 'Maccari&Caporici', '2026-03-18 21:57:35.655514+00');
INSERT INTO public.brands VALUES ('cdff3214-2d21-4fbe-afc3-cade5080b0f0', 'Dark Lab', '2026-03-19 17:17:27.360416+00');
INSERT INTO public.brands VALUES ('73fc119a-b8cb-4e2a-b3e2-c42abc9ce67c', 'Samsung', '2026-03-19 18:00:47.668898+00');
INSERT INTO public.brands VALUES ('96368808-68b7-4952-acce-afbe609ee403', 'HP', '2026-03-19 18:11:31.197509+00');
INSERT INTO public.brands VALUES ('6bb49f7e-f5f3-4acd-9177-33a52b16ef48', 'Amvox', '2026-03-20 03:58:39.184458+00');


--
-- TOC entry 4662 (class 0 OID 22173)
-- Dependencies: 380
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categories VALUES ('3ef27b40-a2db-4664-abe6-7a1cccd8e9a3', 'Eletrônicos', 'eletronicos', NULL, '2026-03-15 17:25:42.861589+00');
INSERT INTO public.categories VALUES ('8457e2f0-3ce7-4624-afcd-6a918589d12c', 'Áudio', 'audio', NULL, '2026-03-15 17:25:42.861589+00');
INSERT INTO public.categories VALUES ('863befde-b087-4dee-bc39-36e519b18a48', 'Acessórios', 'acessorios', NULL, '2026-03-15 17:25:42.861589+00');
INSERT INTO public.categories VALUES ('4892e78b-d2cc-43b8-8a17-605b03f1d4a3', 'Casa & Decoração', 'casa-decoracao', NULL, '2026-03-15 17:25:42.861589+00');
INSERT INTO public.categories VALUES ('14d349aa-ea80-4c42-b91a-720c2ef3497c', 'Esportes', 'esportes', NULL, '2026-03-15 17:25:42.861589+00');
INSERT INTO public.categories VALUES ('af115fa7-66eb-4445-a35b-232023d163f6', 'Vitaminas e Suplementos', 'vitaminas-e-suplementos', 'https://cdn3d.iconscout.com/3d/premium/thumb/pilulas-energeticas-3d-icon-png-download-6635152.png', '2026-03-19 17:04:28.907748+00');
INSERT INTO public.categories VALUES ('b8cf1b6a-58d6-48ee-a350-0d02cc6df1f8', 'Computadores e Informática', 'informatica', 'https://cdn3d.iconscout.com/3d/premium/thumb/caderno-3d-icon-png-download-8915440.png', '2026-03-15 17:51:05.9855+00');
INSERT INTO public.categories VALUES ('1cf6748a-3b9d-4d59-8946-dedaad54eea3', 'Eletrodomésticos', 'eletrodomesticos', NULL, '2026-03-20 03:57:48.873691+00');
INSERT INTO public.categories VALUES ('49a45f32-5dad-4d05-97be-ed6dafa73c97', 'Vestuário', 'vestuario', NULL, '2026-03-20 16:48:29.850042+00');
INSERT INTO public.categories VALUES ('eaa3a6e8-e85e-4020-a75c-90b1a75287ce', 'Brinquedos', 'brinquedos', NULL, '2026-03-20 16:48:42.765899+00');
INSERT INTO public.categories VALUES ('95a00be7-7f36-4590-a2d9-f78cd0a12689', 'Saúde e Beleza', 'saude-e-beleza', NULL, '2026-03-20 16:49:17.738038+00');


--
-- TOC entry 4675 (class 0 OID 22458)
-- Dependencies: 393
-- Data for Name: coupon_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4674 (class 0 OID 22441)
-- Dependencies: 392
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4673 (class 0 OID 22426)
-- Dependencies: 391
-- Data for Name: institutional_pages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.institutional_pages VALUES ('67a57306-1b29-4d75-9c2c-2baeb5daaf40', 'Cupons', 'shopee', '<p><br></p>', true, '2026-03-16 00:46:37.853836+00', 'support');


--
-- TOC entry 4681 (class 0 OID 27177)
-- Dependencies: 399
-- Data for Name: ml_product_mappings; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4682 (class 0 OID 27200)
-- Dependencies: 400
-- Data for Name: ml_sync_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ml_sync_logs VALUES ('c4aab17c-0494-4ded-9252-cff4e15d3816', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:03:50.92+00', '2026-03-21 17:03:51.030998+00');
INSERT INTO public.ml_sync_logs VALUES ('5245fc85-b489-4b1b-8bed-abab5fb91e80', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:05:09.332+00', '2026-03-21 17:05:09.440501+00');
INSERT INTO public.ml_sync_logs VALUES ('30d3c82d-9b3e-46c3-85a9-ba8940f1993f', 'batch_sync', 'partial', 1, 0, 0, 'Item 404: {"code":404,"body":{"id":"MLB52941149","message":"Item with id MLB52941149 not found","error":"not_found","status":404,"cause":[]}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:05:45.204+00', '2026-03-21 17:05:45.805387+00');
INSERT INTO public.ml_sync_logs VALUES ('2a549ded-9115-46f1-977c-324120d3663d', 'batch_sync', 'partial', 1, 0, 0, 'Item 404: {"code":404,"body":{"id":"MLB52941149","message":"Item with id MLB52941149 not found","error":"not_found","status":404,"cause":[]}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:07:43.118+00', '2026-03-21 17:07:43.247879+00');
INSERT INTO public.ml_sync_logs VALUES ('372220a6-7394-4ce4-b1ef-d6877f4638dd', 'batch_sync', 'partial', 1, 0, 0, 'Item 404: {"code":404,"body":{"id":"MLB52941149","message":"Item with id MLB52941149 not found","error":"not_found","status":404,"cause":[]}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:16:21.763+00', '2026-03-21 17:16:21.897303+00');
INSERT INTO public.ml_sync_logs VALUES ('a1ff5828-419c-4584-a127-68f5266f1e3e', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:17:01.24+00', '2026-03-21 17:17:01.3565+00');
INSERT INTO public.ml_sync_logs VALUES ('de69e71f-bdae-4583-8fcf-e23522c64b00', 'batch_sync', 'partial', 1, 0, 0, 'Item 404: {"code":404,"body":{"id":"MLB52941149","message":"Item with id MLB52941149 not found","error":"not_found","status":404,"cause":[]}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:17:58.341+00', '2026-03-21 17:17:58.459854+00');
INSERT INTO public.ml_sync_logs VALUES ('94cd809d-2ce0-45f2-b1df-07cc417724a1', 'batch_sync', 'partial', 1, 0, 0, 'Item 404: {"code":404,"body":{"id":"MLB52941149","message":"Item with id MLB52941149 not found","error":"not_found","status":404,"cause":[]}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:19:42.673+00', '2026-03-21 17:19:42.791389+00');


--
-- TOC entry 4680 (class 0 OID 27166)
-- Dependencies: 398
-- Data for Name: ml_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ml_tokens VALUES ('a4c4140e-00ef-4995-9a55-f4c2c0403d1e', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'APP_USR-1311651017806191-032111-3325e26397c48dd726eedda99e451dd1-225054608', 'TG-69bebc8804afe200017003f4-225054608', '2026-03-21 21:43:04.774+00', '225054608', '2026-03-21 03:40:00.124155+00', '2026-03-21 15:43:04.774+00');


--
-- TOC entry 4660 (class 0 OID 22142)
-- Dependencies: 378
-- Data for Name: models; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.models VALUES ('4fa1de81-235e-4034-ac31-56b17cbc3dd3', 'd222f8c0-49d1-499d-880f-3e823cebdab5', 'XHL_HOME', '2026-03-15 23:41:48.689708+00');
INSERT INTO public.models VALUES ('369ab48d-c95c-4411-a91b-7fc0c9011a70', '612e31cb-cfe0-4ff8-a433-6f258080ae75', 'K9', '2026-03-16 14:27:45.14625+00');
INSERT INTO public.models VALUES ('313ff752-18c8-41fe-a46e-7e91796ea889', '22e97655-8957-45f8-9512-3fb1d2b14b9f', 'Body Protein', '2026-03-16 19:39:12.77201+00');
INSERT INTO public.models VALUES ('0106f1f2-780c-4ba4-bc4e-b7d50da4c312', 'a38d407c-b47d-40d8-9bf8-5852b8dcd927', 'Teflon', '2026-03-16 20:28:20.217654+00');
INSERT INTO public.models VALUES ('d0b04eef-c5e7-450d-90a5-b10a2f0a072a', '2f146099-debe-472a-9333-7229545a2f08', 'Elgin Eco Dream 9000 BTU', '2026-03-16 23:53:40.397836+00');
INSERT INTO public.models VALUES ('ea5cf827-a778-498f-8e6e-0547df9157a3', 'ba613e78-541a-42cd-af86-a45ce0aeb055', 'Sanduicheira', '2026-03-17 00:04:29.059122+00');
INSERT INTO public.models VALUES ('0d08037f-a514-4400-baab-474f65aadf54', 'fa5f9497-65b1-4e55-8e15-251f6004750c', 'KP9-1A', '2026-03-17 00:37:42.735869+00');
INSERT INTO public.models VALUES ('4c10c67b-fc64-45c6-bd08-5f559c5b468d', 'fd806438-e4a9-4afa-a0c7-a16338105f8d', 'ECF06EC', '2026-03-18 16:50:30.863811+00');
INSERT INTO public.models VALUES ('2fcaa27c-a98f-400c-bb31-46c3234b9ea2', 'fc7eff8d-8e39-4384-8816-16da373293e5', 'Jogo de Cama', '2026-03-18 21:57:47.310858+00');
INSERT INTO public.models VALUES ('de5d95db-6213-402f-84ef-2c88736e1ab1', 'cdff3214-2d21-4fbe-afc3-cade5080b0f0', 'Creatina', '2026-03-19 17:17:55.674954+00');
INSERT INTO public.models VALUES ('99fd7455-3302-455e-b01f-2f237c98cad7', '73fc119a-b8cb-4e2a-b3e2-c42abc9ce67c', 'Galaxy Book4', '2026-03-19 18:01:23.442089+00');
INSERT INTO public.models VALUES ('c011427a-d183-429f-bc8b-1156021c9556', '96368808-68b7-4952-acce-afbe609ee403', '107W', '2026-03-19 18:11:46.053421+00');
INSERT INTO public.models VALUES ('9955e247-1a27-4d7e-bf13-f7d0fe4cf6d3', '6bb49f7e-f5f3-4acd-9177-33a52b16ef48', 'ACT 407', '2026-03-20 03:59:09.564615+00');


--
-- TOC entry 4671 (class 0 OID 22381)
-- Dependencies: 389
-- Data for Name: newsletter_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.newsletter_products VALUES ('739516ec-92e4-498f-aa3d-d65e1ca573d5', '95624526-4b7c-4185-93df-9a3426c494ca');
INSERT INTO public.newsletter_products VALUES ('739516ec-92e4-498f-aa3d-d65e1ca573d5', 'f891a701-12b9-4a70-8677-5c2bee61e4f2');
INSERT INTO public.newsletter_products VALUES ('739516ec-92e4-498f-aa3d-d65e1ca573d5', 'a91825fe-8053-49ee-9b6c-c07f2d9ea2c7');


--
-- TOC entry 4670 (class 0 OID 22370)
-- Dependencies: 388
-- Data for Name: newsletters; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.newsletters VALUES ('739516ec-92e4-498f-aa3d-d65e1ca573d5', 'Promoções da Semana', '<p>Olá,</p><p>Confira nossas ofertas imperdíveis desta semana!</p>', 'draft', '2026-03-16 04:40:58.5529+00');


--
-- TOC entry 4661 (class 0 OID 22160)
-- Dependencies: 379
-- Data for Name: platforms; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.platforms VALUES ('31640105-56f9-43ab-8204-465c8717d731', 'Amazon', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/platform-1773595590624.webp', '2026-03-15 17:27:07.602531+00');
INSERT INTO public.platforms VALUES ('5a54bf84-4707-4f0f-a23c-689469fdbbb7', 'Shopee', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/platform-1773595674820.png', '2026-03-15 17:28:28.049073+00');
INSERT INTO public.platforms VALUES ('470eab59-13aa-43e1-84f0-71712bd56389', 'Mercado Livre', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/platform-1774059464441.png', '2026-03-21 02:18:26.509464+00');


--
-- TOC entry 4672 (class 0 OID 22408)
-- Dependencies: 390
-- Data for Name: price_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.price_history VALUES ('a0dd2cc7-98f5-4281-9370-d02c7ba63e57', '7003fe61-851a-48ac-841c-105e281b3240', 189.05, '2026-03-16 19:43:08.153009+00');
INSERT INTO public.price_history VALUES ('3baefc24-369e-481b-a923-739652511fbb', 'f891a701-12b9-4a70-8677-5c2bee61e4f2', 71.91, '2026-03-17 00:07:00.220193+00');
INSERT INTO public.price_history VALUES ('8fca0c1c-3740-47dd-ad2c-5c64b85ae4f1', 'a91825fe-8053-49ee-9b6c-c07f2d9ea2c7', 1595, '2026-03-17 00:07:55.025871+00');
INSERT INTO public.price_history VALUES ('af4a0495-5640-4d62-9e0e-177cebd15d29', '95624526-4b7c-4185-93df-9a3426c494ca', 68.2, '2026-03-17 00:39:26.991813+00');
INSERT INTO public.price_history VALUES ('55c47aa6-03dd-4de6-b26c-e35bd888b832', 'c4ce3766-d0fa-4e7b-b444-3df28b7fd502', 389.91, '2026-03-18 16:51:22.561262+00');
INSERT INTO public.price_history VALUES ('698f2a5f-ee48-45a5-a758-49b8d6ab3a5c', 'f891a701-12b9-4a70-8677-5c2bee61e4f2', 59.7, '2026-03-18 21:42:52.232994+00');
INSERT INTO public.price_history VALUES ('9df1b90a-4748-4d05-8d0f-fe57ec29e2ca', '95624526-4b7c-4185-93df-9a3426c494ca', 67.2, '2026-03-18 21:43:15.627415+00');
INSERT INTO public.price_history VALUES ('edbc9323-5450-44b0-9fd1-48291a4485bc', 'a91825fe-8053-49ee-9b6c-c07f2d9ea2c7', 1899, '2026-03-18 21:44:50.328983+00');
INSERT INTO public.price_history VALUES ('4881962c-317f-494a-a8c9-2cc31735ef43', '23d3425b-8c78-4c9f-8b76-11b145e53777', 64.97, '2026-03-18 21:57:55.186153+00');
INSERT INTO public.price_history VALUES ('b28a92e4-eb9b-4a05-880c-af16a2a07554', 'c4ce3766-d0fa-4e7b-b444-3df28b7fd502', 419.91, '2026-03-19 16:58:28.084883+00');
INSERT INTO public.price_history VALUES ('c87d51dd-0548-4abd-b7aa-34b31324ece9', 'd8ae643d-6100-4283-8059-93a6df1164e2', 75.9, '2026-03-19 17:19:19.250926+00');
INSERT INTO public.price_history VALUES ('eecdf7a1-84ec-4d8a-9d70-ee6c20ff9788', '13cb9b81-e991-4cf5-a2c2-fccdd1ee770c', 3836.28, '2026-03-19 18:05:33.35562+00');
INSERT INTO public.price_history VALUES ('90243e31-3d45-4f09-b187-b62b9d505cb7', '9e601a93-e57e-47a4-95be-8589694dd340', 854.9, '2026-03-19 18:12:35.114+00');
INSERT INTO public.price_history VALUES ('b55c40c0-d802-40e4-b28d-405c86847804', '9259e1e8-2450-46d5-910c-c83cda5f35fa', 2379, '2026-03-20 04:24:30.448999+00');
INSERT INTO public.price_history VALUES ('c80ae2b1-8761-4719-97c4-540abe81a897', '37af9dc6-70ac-4dec-a362-8fcbec407f52', 899, '2026-03-20 16:57:15.936966+00');
INSERT INTO public.price_history VALUES ('7b169b89-faaf-4c57-9a48-0961c05082cf', '3a9ef6c2-2f20-4d14-8044-cdf306574f4d', 50.49, '2026-03-20 16:58:43.226628+00');
INSERT INTO public.price_history VALUES ('f06deaa6-c25f-4c38-813b-8e3214b27755', 'f1586a36-4e72-445e-99fb-d93fa04e5bf0', 199.99, '2026-03-20 17:05:26.698784+00');
INSERT INTO public.price_history VALUES ('2a8913fb-4347-4e0f-a09a-582de9ecccb2', '01e2a87d-ad1c-4e2d-9e4a-62f568880b1f', 66.99, '2026-03-21 00:19:11.374449+00');
INSERT INTO public.price_history VALUES ('3d640bd2-46b4-4f0a-914f-e530e9fdbba2', '25ffa72a-0b67-44c1-ae12-f70a8d41d256', 1300, '2026-03-21 18:05:48.632509+00');
INSERT INTO public.price_history VALUES ('940743a3-ae69-44ec-912b-3ffa420138ab', '25ffa72a-0b67-44c1-ae12-f70a8d41d256', 1200, '2026-03-21 18:06:01.175453+00');


--
-- TOC entry 4668 (class 0 OID 22328)
-- Dependencies: 386
-- Data for Name: product_clicks; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_clicks VALUES ('93361d1c-4759-4873-af7d-20b334e31f09', '12495a26-4e1b-41d2-bdcf-f97c6864c8d4', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-16 23:55:14.739342+00');
INSERT INTO public.product_clicks VALUES ('c9b1c5d2-4bdb-47e6-b756-8fcf24e181bd', 'a91825fe-8053-49ee-9b6c-c07f2d9ea2c7', NULL, '42824b09-637c-4216-adce-50cb6b4b7e1c', '2026-03-18 01:03:38.785138+00');
INSERT INTO public.product_clicks VALUES ('d66a54b5-6c47-45e0-8873-300f919915f8', '95624526-4b7c-4185-93df-9a3426c494ca', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-18 21:41:15.000468+00');
INSERT INTO public.product_clicks VALUES ('05d00cbb-0187-4321-94db-b1544ca92977', 'f891a701-12b9-4a70-8677-5c2bee61e4f2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-18 21:42:09.123581+00');
INSERT INTO public.product_clicks VALUES ('c7bab38c-93ed-44d6-b6bf-e00b0af561eb', '23d3425b-8c78-4c9f-8b76-11b145e53777', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-19 15:04:44.555962+00');
INSERT INTO public.product_clicks VALUES ('60b34245-6599-4737-b158-d468fb2d4a97', 'c4ce3766-d0fa-4e7b-b444-3df28b7fd502', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-19 15:09:11.837937+00');
INSERT INTO public.product_clicks VALUES ('c1595984-182a-4782-a3be-8a96a5c5ff4b', '23d3425b-8c78-4c9f-8b76-11b145e53777', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-19 17:56:01.228748+00');
INSERT INTO public.product_clicks VALUES ('67682bbe-49cd-4b5b-961a-9ecfc00a617a', '6ed00fa8-aa77-4fad-98c3-0db651688bab', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-19 18:55:27.211554+00');
INSERT INTO public.product_clicks VALUES ('b91c5a91-bbfb-49b1-8798-c66f09f0c689', 'e2fe3739-5db6-4666-b31a-806e22dd585c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-21 17:22:28.337482+00');


--
-- TOC entry 4667 (class 0 OID 22254)
-- Dependencies: 385
-- Data for Name: product_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_likes VALUES ('16f8ad3d-863d-4f95-a606-509f6b24e9aa', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'a6204a5c-b58d-4204-9cdd-e8d99cdb0e8e', '2026-03-16 14:21:46.093147+00');


--
-- TOC entry 4669 (class 0 OID 22349)
-- Dependencies: 387
-- Data for Name: product_trust_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4655 (class 0 OID 17530)
-- Dependencies: 372
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES ('a91825fe-8053-49ee-9b6c-c07f2d9ea2c7', 'Ar Condicionado Split Hi Wall Inverter Elgin Eco Dream 9000 BTU/h Frio 45HIFI09C2WA – 220 Volts', '<p>Ar-Condicionado Split HW Elgin Eco Dream Inverter Wi-Fi</p><p><br></p><p>A linha Split High Wall&nbsp;<strong>Dream Inverter WIFI</strong>&nbsp;atende nas capacidades de 9.000 a 36.000 Btu/h, nas versões Frio e Quente-Frio. O Eco Dream Inverter da Elgin conta com uma altíssima eficiência energética com classe A trazendo mais economia, de acordo com a nova portaria. Elgin preocupada com o meio ambiente traz para o mercado a linha Inverter Eco Dream Inverter com&nbsp;<strong>gás ecológico R32</strong>. Este fluído refrigerante não agride a camada de ozônio e tem baixo potencial de aquecimento global (G.W.P), sendo este potencial de aquecimento global 1/3 do que seu antecessor R410A.</p><p><br></p><p>A unidade interna possui um display invisível indicando a temperatura, que se acende ao ligar a unidade, e se você preferir, aperte a tecla "visor” para desligar o display para maior conforto durante a noite.</p><p><br></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Conectividade Wi-Fi</span></p><p><br></p><p>Com o aplicativo&nbsp;<strong>Elgin Smart</strong>&nbsp;você pode controlar seu Eco Dream Inverter via Wi-Fi. Ajuste a temperatura, ligue ou desligue o seu aparelho de onde estiver, até mesmo por comando de voz com a&nbsp;<strong>Alexa</strong>&nbsp;e o&nbsp;<strong>Google Assistente</strong>.</p><p><br></p><p><strong>- Instalação não inclusa!</strong></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">A Marca</span></p><p><br></p><p>A Elgin, em seus mais de 66 anos de história tornou-se uma marca conhecida por sua qualidade, credibilidade e inovações constantes, sempre com o objetivo de oferecer os melhores produtos aos seus consumidores. Hoje conta com uma enorme variedade de produtos para uso comercial e residencial nos segmentos de Ar-Condicionado, Automação Comercial, Energia Solar entre outros...Sempre com o foco no bem-estar das pessoas e na preservação ambiental, a Elgin procura agregar em suas linhas de produtos, atributos sustentáveis que colaboram com as metas de redução de emissão de poluentes e baixos níveis de consumo de energia.</p><p><em>1) De acordo com a nova portaria de classificação energética do Inmetro nº269, de 22 de junho de 2021 (baseada na ISO 16.358)</em></p>', 1899, 2189, 13, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773704979886-lxnvgggtgc.jpeg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7851943107190276.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.45270689894587335.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7325696870480343.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.6152228301389535.jpg}', 'Oferta', 'Amazon', 'https://amzn.to/3NlfwbA', 0, 0, 1, true, NULL, '2026-03-16 23:54:27.052374+00', '2026-03-18 21:44:50.328983+00', '2f146099-debe-472a-9333-7229545a2f08', 'd0b04eef-c5e7-450d-90a5-b10a2f0a072a', '31640105-56f9-43ab-8204-465c8717d731', NULL, 13.2, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '3ef27b40-a2db-4664-abe6-7a1cccd8e9a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('e2fe3739-5db6-4666-b31a-806e22dd585c', 'Aspirador e Lavadora Vertical de Piso Sem Fio com Auto-limpeza 3 Modo de Limpeza Aspira Lava Esfrega', '<p>Lavadora de Piso Multifuncional FFW-F11</p><p><br></p><p>A FFW-F11 é uma lavadora de piso multifuncional que combina lavagem, aspiração e secagem em um único equipamento, proporcionando uma limpeza profunda, prática e higiênica para o uso doméstico. Ideal para pisos duros como cerâmica, porcelanato, mármore, granito e pisos laminados.</p><p><br></p><p>Principais Características</p><p><br></p><p>3 modos de limpeza</p><p><br></p><p>Modo Smart: ajusta automaticamente a potência conforme o nível de sujeira (até 40 minutos)</p><p><br></p><p>Modo Forte: indicado para sujeiras difíceis e manchas persistentes (até 22 minutos).</p><p><br></p><p>Modo Sucção a Seco: aspira água e poeira sem liberar água.</p><p><br></p><p>Sistema de auto-limpeza com secagem</p><p><br></p><p>Lava automaticamente a escova e os dutos internos e, em seguida, realiza a secagem, reduzindo odores e facilitando a manutenção.</p><p><br></p><p>Tanques de água separados</p><p><br></p><p>Água limpa: 650 ml</p><p><br></p><p>Água suja: 550 ml</p><p><br></p><p>Mais higiene e melhor desempenho durante a limpeza.</p><p><br></p><p>Tela LED inteligente</p><p><br></p><p>Indica nível de bateria, alertas de falta de água, tanque cheio, escova travada e status do equipamento.</p><p><br></p><p>Bateria recarregável</p><p><br></p><p>Bateria de 21,6 V / 4000 mAh, com tempo de carregamento de aproximadamente 6 a 8 horas.</p><p><br></p><p>Pode ser carregado tanto no 110v quanto no 220v</p><p><br></p><p>Modo de Uso</p><p><br></p><p>Antes do primeiro uso</p><p><br></p><p>Carregue totalmente o aparelho na base de carregamento.</p><p><br></p><p>Encha o tanque de água limpa com água.</p><p><br></p><p>Certifique-se de que o tanque de água suja esteja corretamente instalado.</p><p><br></p><p>Como iniciar a limpeza</p><p><br></p><p>Posicione o aparelho na vertical e incline-o levemente para trás.</p><p><br></p><p>Pressione o botão de ligar para iniciar o funcionamento.</p><p><br></p><p>Pressione o botão de modo para alternar entre:</p><p><br></p><p>Modo Smart</p><p><br></p><p>Modo Forte</p><p><br></p><p>Modo Sucção a Seco</p><p><br></p><p>⚠️ Observação: quando o aparelho está totalmente na posição vertical, ele pausa automaticamente.</p><p><br></p><p>Durante o uso</p><p><br></p><p>Utilize apenas em pisos duros e nivelados.</p><p><br></p><p>Não incline o aparelho além de 140° para evitar vazamento de água.</p><p><br></p><p>Caso o tanque de água limpa esteja vazio ou o tanque de água suja esteja cheio, o aparelho irá parar automaticamente e emitir aviso no visor.</p><p><br></p><p>Após a limpeza</p><p><br></p><p>Posicione o aparelho na base de carregamento.</p><p><br></p><p>Pressione o botão de auto-limpeza para lavar automaticamente a escova e os dutos internos.</p><p><br></p><p>Após a auto-limpeza, o aparelho iniciará o processo de secagem automática.</p><p><br></p><p>Esvazie o tanque de água suja e deixe os componentes secarem adequadamente.</p><p><br></p><p>Indicação de Uso</p><p><br></p><p>Uso exclusivo em ambientes internos.</p><p><br></p><p>Indicado para pisos de cerâmica, porcelanato, mármore, granito, madeira tratada e pisos laminados.</p><p><br></p><p>Não indicado para carpetes, tapetes ou superfícies irregulares.</p>', 1085.6, 1180, NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773585459422-tcljvwxjlvr.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773585471916-a011pn94bug.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773585475488-lvoc86nz7bo.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773585478820-k8sq5x7jy2g.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773585484951-3r4yr6gfevj.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773585497421-083pjcmtkq49.jpg}', 'Mais vendido', 'Shopee', 'https://s.shopee.com.br/1gDtpffB91', 0, 0, 1, true, NULL, '2026-03-15 14:45:27.470318+00', '2026-03-21 17:22:28.337482+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 8.0, NULL, '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('a6204a5c-b58d-4204-9cdd-e8d99cdb0e8e', 'Robô Aspirador de Pó MultiClean, Mondial, Vermelho/Preto, 30W, Bivolt - RB-09', '<p>Com o Robô Aspirador de Pó Multi Clean RB-09 é possível limpar o chão da sua casa com apenas um toque! Limpeza inteligente, ele varre, aspira, limpa e passa pano. O robô limpa com eficiência diversos tipos de piso e possui sensor antiqueda. A combinação da programação inteligente e do design compacto permite que o aspirador sugue poeiras e detritos até embaixo de móveis e em áreas de acesso mais difícil. Saiba mais sobre o RB-09 da Mondial:</p><p><br></p><p>LIMPEZA INTELIGENTE: Varre, aspira, limpa e passa pano com apenas um toque.</p><p><br></p><p>FUNÇÃO MOP: Passa pano enquanto aspira, garantindo uma limpeza profunda.</p><p><br></p><p>ESCOVAS LATERAIS: As 2 escovas laterais foram projetadas para a limpeza de cantos e frestas.</p><p><br></p><p>SUPER SLIM: Com 7,5cm de altura, entra com facilidade embaixo de móveis, camas e sofás.</p><p><br></p><p>SENSOR ANTIQUEDA: Identifica os desníveis do piso e o robô aspirador desvia de obstáculos, evitando colisões e quedas.</p><p><br></p><p>RESERVATÓRIO DE 140mL: Espaço ideal para o robô aspirador de pó sugar poeiras, cabelos, pelos dos pets e detritos.</p><p><br></p><p>PROTEÇÃO ANTIRRISCO: O robô aspirador possui uma proteção com borracha para preservar móveis e pisos contra riscos e danos.</p><p><br></p><p>PARA DIFERENTES TIPOS DE PISO: O robô aspirador Mondial limpa com eficiência diversos tipos de piso como madeira, carpetes baixos e pisos frios.</p><p><br></p><p>30W DE POTÊNCIA E 90 MINUTOS DE AUTONOMIA: Alta performance de sucção durante o tempo ideal para as tarefas mais pesadas.</p><p><br></p><p>LÂMPADA PILOTO: Indica o funcionamento do produto e, inclusive, mostra o status da bateria.</p><p><br></p><p>BIVOLT: Pode ser utilizado tanto na voltagem 127V, quanto na 220V.</p><p><br></p><p>UM ANO DE GARANTIA MONDIAL: A Mondial é a escolha de milhões de consumidores. Mondial, a escolha inteligente!</p>', 284.99, 441.56, 54, 'https://m.media-amazon.com/images/I/71uzreWVdPL._AC_SX679_.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773456925832-2j8xbbrmp3s.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773456931425-qg1x0p2us.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773456937869-uaf5ftbacog.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773456946461-rlebcy617l.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773456954032-1lmkes37du2.jpg}', 'Redução No Preço', 'Amazon', 'https://amzn.to/3NoblM6', 0, 0, 0, true, NULL, '2026-03-14 02:59:33.017817+00', '2026-03-15 19:00:19.082348+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 35.5, NULL, '3ef27b40-a2db-4664-abe6-7a1cccd8e9a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('0ba1a569-0924-48e7-ba16-be4dfc0a4577', 'Torneira de Banheiro Lavabo cuba Preta Prata Luxo Metal Cromada Moderna 1/2 Cuba Fosco Inox Quadrada', '<p>Torneira Banheiro Inox Lavabo Cuba 1/2"</p><p><br></p><p>Deixe o ambiente bonito e elegante, invista neste torneira e tenha um produto de qualidade e designer fantástico, perfeita para pequenos ambientes, essa peça oferece maior praticidade e charme. Seu mecanismo inovador de fecho rápido oferece controle total no fluxo de água em um simples toque.</p><p><br></p><p>- Fácil instalação e manutenção.</p><p>- Aço Inoxidável (Inox)</p><p>- Modelo: Curta</p><p>- Quantidade de furos: 1</p><p>- Tipo de Montagem: Mesa</p><p>- Linha: Luxo</p><p><br></p><p>Medidas aproximadas do produto</p><p><br></p><p>- Comprimento: 8 cm</p><p>- Altura: 21 cm</p><p>- Largura: 18 cm</p><p><br></p><p>Cores disponíveis: Preto, Prata</p><p>Inclui: 01 Torneira Cromada de Luxo</p>', 44.99, 100, 75, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457304562-uliwmmzh65r.jpeg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457604781-nx7wxp0l26k.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457610182-lhcoes1j7x.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457613858-0th3i4c0b6gf.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457618038-qvh5q6g9vh9.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457621650-zdewmxe48j.webp}', 'Desconto Alto', 'Shopee', 'https://s.shopee.com.br/5VQa24lVgG', 0, 0, 0, true, NULL, '2026-03-14 03:07:36.058629+00', '2026-03-15 19:00:19.082348+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 55.0, NULL, '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('cfd08ce1-1a30-4472-b0f9-5a431668b8bc', 'Aspirador Vertical de Pó Liectroux i7 Pro Sem Fio 3 em 1 Aspira Passa Pano Autolimpante Para Sólidos e Líquidos Pelos de Pet Cachorro Gato Potente Com Filtro HEPA Bivolt', '<h1><strong>Descrição do Produto</strong></h1><ol><li><strong>3 em 1:</strong>&nbsp;Aspira, Passa Pano e se Autolimpa.</li><li><strong>Sem fio:</strong>&nbsp;O i7 Pro não possui fio, para uma maior praticidade na hora da limpeza.</li><li><strong>Limpeza completa:</strong>&nbsp;Limpa pisos e carpetes.</li><li><strong>Versátil:</strong>&nbsp;Limpa sujeira molhada e seca, tais como sucos, arroz, pelos de pet, areia de gato, entre outros.</li><li><strong>Super potente:</strong>&nbsp;Máxima potência (14000 Pa) para uma limpeza eficaz, removendo as manchas.</li><li><strong>Autolimpeza e Autossecagem:</strong>&nbsp;Após a limpeza basta deixá-lo na base de carregamento e ele efetuará a limpeza e secagem da escova de limpeza automaticamente. Para que você não precise ter contato com a sujeira!</li><li><strong>Fácil usabilidade:</strong>&nbsp;Leve, flexível, fácil de manobrar e se autoimpulsiona. Para uma limpeza sem esforços!</li><li><strong>Display de led:</strong>&nbsp;Para uma melhor visualização do processo de limpeza.</li><li><strong>Baixo ruído:</strong>&nbsp;Para maior conforto.</li><li><strong>Reservatório de água limpa de alta capacidade:</strong>&nbsp;Com 600 mL, para limpar toda a casa.</li></ol>', 1798.99, 2769, 30, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773589264959-wmyekukn4m.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773589271989-40vgqzlghzo.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773589281029-crsj49lncit.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773589295632-2xuevu92dgg.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773589300906-ljbd2kyxg4g.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773589313489-e91wx4s8v1v.jpg}', 'Queridinho ', 'Amazon', 'https://amzn.to/4sJl9z4', 0, 0, 0, true, NULL, '2026-03-15 14:52:48.400558+00', '2026-03-15 19:00:19.082348+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 35.0, NULL, '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('830cafa9-bffe-442a-93b8-3931dafbfbcb', '40 Peças / 46 Peças Jogo De Chave Catraca Caixa De Ferramentas Completa Reversível Soquetes Maleta', '<p>-Conteúdo da embalagem:45 componentes + 1 caixa de ferramentas</p><p>-Tamanho：15*2.1*2.7CM</p><p>-Peso do produto: 1057G</p><p>-Cores do produto: Verde</p><p>-Pode ser usado em ar condicionado, porca de assento, para-choques, pneus, travas de porta de carro, casa (contém básico), amplamente utilizado em bicicletas, estranguladores abertos, entre outras manutenções</p><p><br></p><p>LISTA DE PEÇAS DA EMBALAGEM:</p><p><br></p><p>- 13 Soquetes 1/4"( 4mm - 4,5mm - 5mm - 5,5mm - 6mm - 7mm - 8mm - 9mm - 10mm - 11mm - 12mm - 13mm - 14mm.</p><p>                                               - Ponta Fenda: 4mm - 5,5mm - 7mm.</p><p>                                               - Ponta Philips: 1 - 2 - 3.</p><p>- 21 Soquetes com Bits{   - Ponta HEX: 3mm - 4mm - 5mm - 6mm - 7mm -8mm.</p><p>                                               - Ponta PZ: 1 - 2 - 3.</p><p>                                              - Ponta T: T10 - T15 - T20 - T25 - T30 - T40.</p><p>- 03 Chaves Hexagonais L: 1,5mm - 2mm - 2,5mm.</p><p>- 01 Cabo Fixo 1/4".</p><p>- 02 Barras Extensão 50mm (2”) e 100 mm (4”).</p><p>- 01 Extensão Flexível 150mm (6”).</p><p>- 01 Catraca Giro Rápido 1/4".</p><p>- 01 Cabo T de Contato.</p><p>- 01 Junta Universal.</p><p>- 01 Bit Adaptador.</p><p>- 01 Maleta.</p><p><br></p><p> O soquete usa AÇO TITANIUM vanádio de alta qualidade 50 bv30 formação de prensa a frio, torque 50% maior que o de aço carbono, protegido conta a ferrugem.</p><p> A cabeça do lote adota materiais CR-V, para que a peça tenha uma resistência mais alta.</p><p> Chave de catraca de giro rápido (ajuste positivo e negativo), o recurso de liberação rápida do botão de pressão garante que o soquete seja travado com segurança durante o uso, mas também permite fácil remoção ou troca rápida de soquetes.</p><p> A catraca possui 45 dentes de alta qualidade, o que melhora a performance do trabalho que será executado.</p><p> Pode ser usado em infinitos objetos desde objetos pequenos do ambiente domestico até reparro em caminhões.</p>', 35.99, 99.89, 64, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200387234-oz0n78lnq7.jpeg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200423125-mrhbztbix8j.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200431046-xlu77oe7zs.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200437938-wvctf7wnt8.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200444143-w49nkafn6mi.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200449155-yl9j2709ebh.webp}', 'Indicado', 'Shopee', 'https://s.shopee.com.br/3VfQuKsUWx', 0, 0, 0, true, NULL, '2026-03-11 03:43:08.181576+00', '2026-03-15 19:00:19.082348+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 64.0, NULL, '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('12495a26-4e1b-41d2-bdcf-f97c6864c8d4', 'Calça Jeans Preta Feminina Skinny Cintura Alta com Lycra Levanta Bumbum', '<p>-A Calça Jeans que é o sonho de toda mulher! Que vai valorizar o seu corpo, com a costura atrás levanta isso vai te ajudar no ganho de bumbum empinado que todas mulheres desejam! compre com tranquilidade! Comprou enviou!!! </p><p><br></p><p>-COMPOSIÇÃO: 69% ALGODÃO, 29% POLIESTER, 2% ELASTANO (ELA ESTICA BASTANTE, MAS MEDE SUA CINTURA E QUADRIL E COMPARA COM A TABELA DE MEDIDAS) </p><p><br></p><p>PRIMEIRO PASSO: SAIBA A SUA MEDIDIAS DE QUADRIL E CINTURA </p><p><br></p><p>SEGUNDO PASSO: COMPARE SUAS MEDIDAS COM A TABELA DE MEDIDAS DA DESCRIÇÃO AQUI EM BAIXO OU NAS FOTOS</p><p><br></p><p>TERCEIRO PASSO: REALIZE A COMPRA DA CALÇA E AO CHEGAR ARRASE FORMANDO VÁRIOS LOOKS COM A VULGATA JEANS</p><p><br></p><p>TAMANO 36</p><p><br></p><p>CINTURA: 64CM - 74CM</p><p>QUADRIL: 82CM - 106CM</p><p>COMPRIMENTO: 1,04CM</p><p><br></p><p>TAMANHO 38</p><p><br></p><p>CINTURA: 70CM - 84CM</p><p>QUADRIL: 90CM - 116CM</p><p>COMPRIMENTO: 1,04CM</p><p><br></p><p>TAMANHO 40</p><p><br></p><p>CINTURA: 74CM - 86CM</p><p>QUADRIL: 100CM - 118CM</p><p>COMPRIMENTO: 1,04CM</p><p><br></p><p>TAMANHO 42</p><p><br></p><p>CINTURA: 76CM - 88CM</p><p>QUADRIL: 104CM - 124CM</p><p>COMPRIMENTO: 1,04CM</p><p><br></p><p>TAMANHO 44</p><p><br></p><p>CINTURA: 80CM - 92CM</p><p>QUADRIL: 110CM - 126CM</p><p>COMPRIMENTO: 1,04CM</p><p><br></p><p>-COMPOSIÇÃO: 69% ALGODÃO, 29% POLIESTER, 2% ELASTANO (ELA ESTICA BASTANTE, MAS MEDE SUA CINTURA E QUADRIL E COMPARA COM A TABELA DE MEDIDAS</p>', 51.2, 59.99, 15, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200713844-3hpmqlu1mvs.webp', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200721474-owp1bwsr7mh.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200726138-x9z1x68rcvl.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773200733145-wblaw2njro.webp}', 'Indicado', 'Shopee', 'https://s.shopee.com.br/30jAJlyhuP', 0, 0, 1, true, NULL, '2026-03-11 03:47:12.513017+00', '2026-03-16 23:55:14.739342+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 14.7, NULL, '14d349aa-ea80-4c42-b91a-720c2ef3497c', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('6ed00fa8-aa77-4fad-98c3-0db651688bab', 'Máquina de Crepe Crepeira Elétrica Antiaderente Hot Dog Queijo Coalho Espetinho No Palito LCK.XHL_HOME', '<p>Máquina de Crepe Crepeira Elétrica Antiaderente Hot Dog Queijo Coalho Espetinho No Palito LCK</p><p><br></p><p>- Versatilidade Total: Prepare crepes doces ou salgados, hot dogs gourmet, queijos derretidos, linguiças grelhadas e até mesmo panquecas. A máquina é ideal para quem ama variar no cardápio!</p><p><br></p><p>- Praticidade e Facilidade de Uso: Com superfície antiaderente e aquecimento uniforme, você não precisa se preocupar com alimentos grudando ou queimando. Basta ligar na tomada, esperar esquentar e começar a cozinhar!</p><p><br></p><p>- Design Compacto e Moderno: Ocupa pouco espaço na cozinha e é fácil de limpar. Perfeita para quem busca praticidade no dia a dia.</p><p><br></p><p>- Voltagem 110V: Pronta para uso em qualquer tomada comum, sem necessidade de adaptadores.</p><p><br></p><p>- Material Resistente e Durável: Feita com materiais de alta qualidade, garantindo segurança e longa vida útil.</p><p><br></p><p>-ITENS INCLUSOS-</p><p><br></p><p>1x Crepeira Elétrica1200W</p>', 79.89, 199, 60, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457831379-cxri70pha15.webp', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457839051-xs0z8u2q1qo.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457847032-bsdnz709bx9.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773457855076-l09adga68f.webp}', 'Indicado', 'Shopee', 'https://s.shopee.com.br/8fNboOVO6l', 0, 0, 1, true, NULL, '2026-03-14 03:11:29.556701+00', '2026-03-19 18:55:27.211554+00', 'd222f8c0-49d1-499d-880f-3e823cebdab5', '4fa1de81-235e-4034-ac31-56b17cbc3dd3', '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 59.9, NULL, '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('7003fe61-851a-48ac-841c-105e281b3240', 'EQUALIV - Body Protein Neutro em Pó - Rico em Colágeno e Aminoácidos Essenciais para Desenvolvimento e Recuperação Muscular - Sem Glúten, Sem Lactose, Zero Açúcar - Sem Sabor, Lata (450g)', '<h2><strong>Informações importantes</strong></h2><p><br></p><h4><strong>Informações de segurança</strong></h4><p>“SEM ADIÇÃO DE AÇUCARES.” “ESTE NÃO É UM ALIMENTO BAIXO OU REDUZIDO EM VALOR ENERGÉTICO.” "CONSUMIR ESTE PRODUTO CONFORME A RECOMENDAÇÃO DE INGESTÃO DIÁRIA CONSTANTE DA EMBALAGEM" "GESTANTES, NUTRIZES E CRIANÇAS ATÉ 3 (TRÊS) ANOS, SOMENTE DEVEM CONSUMIR ESTE PRODUTO SOB ORIENTAÇÃO DE NUTRICIONISTAOU MÉDICO". Reg. MS.: Produto dispensado da obrigatoriedade de registro conforme RDC nº 27/2010.</p><p><br></p><h4><strong>Ingredientes</strong></h4><p>SUGESTÃO DE USO: Consumir 1 (um) ou 2 (dois) copo-medida (scoop) ao dia, antes e/ou depois do treino ou conforme orientação do médico e/ou nutricionista. Adicionar o conteúdo de 1 (um) copo-medida (scoop) para cada 200 ml de água ou bebida de sua preferência, agitando até dissolver. Ou consuma conforme orientação profissional. INGREDIENTES: Neutro: Colágeno Hidrolisado. NÃO CONTÉM GLÚTEN. SEM ADIÇÃO DE AÇÚCARES. Cacau: Colágeno hidrolisado, cacau em pó, (edulcorantes naturais) taumatina e glicosídeos de esteviol, (espessante) goma xantana e (antiumectante) dióxido de silício e (aromatizantes) aroma idêntico ao natural de creme e aroma idêntico do natural de cacauçlç. NÃO CONTÉM GLUTEN. SEM ADIÇÃO DE AÇÚCARES. Frutas Vermelhas: Colágeno hidrolisado, morango, amora e framboesa em pó, (aromatizantes) aromas naturais de baunilha e morango (espessante) goma xantana, (acidulante) ácido cítrico, (antiumectante) dióxido de silício e (edulcorantes naturais) taumatina e glicosídeos de esteviol. NÃO CONTÉM GLUTEN. SEM ADIÇÃO DE AÇÚCARES. Baunilha: Colágeno hidrolisado, triglicerídeos de cadeia média em pó, (aromatizantes) aromas naturais de baunilha, (antiumectante) dióxido de silício, (espessante) goma xantana e (edulcorantes naturais) taumatina e glicosídeos de esteviol. NÃO CONTÉM GLUTEN. SEM ADIÇÃO DE AÇÚCARES. Coco: Colágeno hidrolisado, coco em pó, triglicerídeos de cadeia média em pó, (espessantes) goma arábica, goma xantana, (antiumectante) dióxido de silício, (aromatizantes) mix de aromas natural e idênticos ao natural e (edulcorantes naturais) taumatina e glicosídeos de esteviol de Stevia rebaudiana Bertoni. NÃO CONTÉM GLÚTEN. Cookies: Colágeno hidrolisado, nibs de cacau", triglicerídeos de cadeia média, (aromatizantes) mix de aroma natural e idênticos ao natural, (antiumectante) dióxido de silício, (emulsificantes) goma xantana e goma arábica, (edulcorantes naturais) glicosídeos de esteviol de Stevia rebaudiana Bertoni e taumatina. (*) fornece quantidades não significativas de açúcares. ALÉRGICOS: PODE CONTER LEITE. NÃO CONTÉM GLÚTEN.</p><p><br></p><h4><strong>Instruções</strong></h4><p>Consumir 1 (um) ou 2 (dois) copo-medida (scoop) ao dia, antes e/ou depois do treino ou conforme orientação do médico e/ou nutricionista. Adicionar o conteúdo de 1 (um) copo-medida (scoop) para cada 200 ml de água ou bebida de sua preferência, agitando até dissolver.</p><p><br></p><h4><strong>Aviso legal</strong></h4><p>A Amazon trabalha para garantir informações corretas e completas sobre o produto, mas as páginas de oferta são criadas a partir da contribuição de terceiros que vendem na Amazon. Pode acontecer do rótulo do produto conter informações adicionais/diferentes das constantes do site, e é por isso que recomendamos que você sempre leia rótulos, advertências e modo de uso antes de consumir um produto. Para informações adicionais, por favor entre em contato com o fabricante. A Amazon não se responsabiliza por informações imprecisas ou incorretas disponibilizadas por fabricantes ou terceiros.</p><p><br></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/81eb0557-8e7c-475e-a95c-d0e92554314f.__CR0,0,970,600_PT0_SX970_V1___.png" alt="a"></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/f11e1eb1-447e-46c2-85c0-23a772225d25.__CR0,0,970,600_PT0_SX970_V1___.png" alt="a"></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/b5e2318f-303d-4873-9aba-7cce5fc8a8cc.__CR0,0,970,600_PT0_SX970_V1___.png" alt="a"></p>', 179.05, 222.9, 20, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773690180563-eegjkar6alw.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.8449942039100002.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2273626709160027.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7060452079211895.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.6697629916396866.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.705227580480899.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.31359794304408095.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7978730482419226.jpg}', 'Novidade', 'Amazon', 'https://amzn.to/3P8jJzX', 0, 0, 0, true, NULL, '2026-03-16 19:43:08.153009+00', '2026-03-16 20:16:49.637463+00', '22e97655-8957-45f8-9512-3fb1d2b14b9f', '313ff752-18c8-41fe-a46e-7e91796ea889', '31640105-56f9-43ab-8204-465c8717d731', NULL, 19.7, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '14d349aa-ea80-4c42-b91a-720c2ef3497c', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('c4ce3766-d0fa-4e7b-b444-3df28b7fd502', 'Cafeteira Espresso Eos 2 em 1 Italiana com 20 Bar de Pressão Inox Ecf06ec 110v', '<p><strong>Cafeteira Espresso EOS 2 em 1 Italiana com 20 Bar de Pressão Inox ECF06EC</strong></p><p><br></p><p>Cafeteira Espresso EOS 2 em 1 Italiana Inox ECF06EC</p><p>Para quem valoriza um bom café logo cedo ou ao longo do dia, a Cafeteira Espresso EOS 2 em 1 oferece qualidade profissional na sua cozinha. Compacta e eficiente, conta com bomba de alta pressão de 20 BAR, garantindo extração intensa, com sabor e aroma marcantes.</p><p>Ideal também para cappuccinos e lattes, vem com espumador de leite integrado, que proporciona espuma cremosa na temperatura certa. Seu design moderno em inox combina com qualquer ambiente e traz sofisticação ao preparo.</p><p>Além do desempenho, é fácil de usar e limpar, com controles intuitivos e peças removíveis que facilitam o dia a dia.</p><p>Principais vantagens:</p><p>Prepara cafés encorpados e aromáticos com extração profissional</p><p>Espumador de leite para bebidas cremosas como cappuccino e latte</p><p>Design moderno em inox, compacto e elegante</p><p>Bomba de 20 BAR que preserva o creme e aquece na medida certa</p><p>Fácil operação e limpeza prática</p>', 419.91, 554.44, 24, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773852138617-yp4yci7a2mi.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.4106207902082657.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2032296427539163.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.5847370238422237.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7637906531408734.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.8892032847863243.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.22555699099576032.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2953870401263423.jpg}', 'Cupom R$ 30', 'Amazon', 'https://amzn.to/4rGUd2h', 0, 0, 1, true, NULL, '2026-03-18 16:51:22.561262+00', '2026-03-19 16:58:28.084883+00', 'fd806438-e4a9-4afa-a0c7-a16338105f8d', '4c10c67b-fc64-45c6-bd08-5f559c5b468d', '31640105-56f9-43ab-8204-465c8717d731', 'https://www.amazon.com.br/vdp/0a3f8140c7054980b5d7696156ad7977?product=B0FHWVCVLM&ref=cm_sw_cp_r_ib_dt_RsRM2hUSbceGK', 24.3, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('f891a701-12b9-4a70-8677-5c2bee61e4f2', 'Sanduicheira Elétrica Cadence Toast & Grill, Preta, 750W, 110V', '<ul><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">NOVO DESIGN exclusivo Cadence, com Porta-fio e trava na alça;</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">IDEAL para preparar 2 sanduíches ao mesmo tempo;</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">CHAPA antiaderente, luz indicadora de funcionamento;</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">ALTA POTÊNCIA: 750W para preparos rápidos e práticos para o dia a dia;</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">COM ALÇA ISOTÉRMICA, trava de segurança e pés antiderrapantes que auxiliam na segurança durante o uso.</span></li></ul><p><br></p>', 59.7, 100.89, 41, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773706011992-sbubl28shd.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.19691294741351384.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.8038771897070267.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9852977507152725.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2849525776766926.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.5340661938006928.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.01045378692862764.jpg}', 'Oferta', 'Amazon', 'https://amzn.to/4bj54sQ', 0, 0, 1, true, NULL, '2026-03-17 00:07:00.220193+00', '2026-03-18 21:42:52.232994+00', 'ba613e78-541a-42cd-af86-a45ce0aeb055', 'ea5cf827-a778-498f-8e6e-0547df9157a3', '31640105-56f9-43ab-8204-465c8717d731', NULL, 40.8, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('95624526-4b7c-4185-93df-9a3426c494ca', 'Kit com 12 pincéis para maquiagem - Macrilan', '<p>Transforme sua rotina de beleza com o Kit Profissional Macrilan KP9-1A, o segredo para um acabamento impecável que fará você dizer ''Amei''. Este conjunto de 12 pincéis foi cuidadosamente selecionado para oferecer a versatilidade e a precisão necessárias para qualquer look, desde o básico do dia a dia até maquiagens mais elaboradas. </p><p><br></p><p>Qualidade Profissional ao Seu Alcance:</p><p>Desenvolvido pela Macrilan, uma marca reconhecida por sua excelência, este kit garante que você tenha as ferramentas certas para depositar e esfumar produtos em pó, cremosos ou líquidos. Nossas cerdas são incrivelmente macias, proporcionando uma aplicação suave e não irritante, ideal para quem está ''iniciando no mundo da maquiagem'' e busca transições uniformes e sem marcações. </p><p><br></p><p>Custo-Benefício Inigualável – Sem Objeções: Sabemos que a durabilidade é crucial. Por isso, investimos em materiais de alta qualidade para minimizar a temida ''queda de cerdas'', um problema comum em kits de entrada. </p><p><br></p><p>O Kit KP9-1A é o verdadeiro ''custo-benefício imbatível'', oferecendo desempenho de nível profissional a um preço acessível. Você compra um kit completo e durável, que realmente ''cumpre o que promete''. </p><p><br></p><p>Versatilidade Completa: O conjunto inclui pincéis essenciais para face (base, pó, blush, contorno) e olhos (esfumar, delinear, aplicar sombra), garantindo que você tenha a ferramenta certa para cada etapa. Embora os pincéis de face tenham um tamanho prático, semelhante ao de viagem, eles mantêm a densidade e o formato ideais para uma aplicação eficiente e precisa, facilitando o transporte e a organização. </p><p><br></p><p>Confiança e Credibilidade Macrilan: Ao escolher Macrilan, você investe em um produto original e de procedência, sinônimo de credibilidade no mercado brasileiro. Sua satisfação é nossa prioridade. Adquira agora o Kit KP9-1A e descubra porque milhares de clientes ''super recomendam'' esta ferramenta essencial para maquiagem. Eleve seu nível de aplicação e conquiste o acabamento que você sempre sonhou.</p>', 67.2, 93.9, 28, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773707730065-pnpimksxf6m.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.5062358174491908.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.06966345548027641.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.17444364530211587.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9422174451321388.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.4623481835030996.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.13973970928943058.jpg}', 'Muito Barato', 'Amazon', 'https://amzn.to/3P4yyUd', 0, 0, 1, true, NULL, '2026-03-17 00:39:26.991813+00', '2026-03-18 21:43:15.627415+00', 'fa5f9497-65b1-4e55-8e15-251f6004750c', '0d08037f-a514-4400-baab-474f65aadf54', '31640105-56f9-43ab-8204-465c8717d731', NULL, 28.4, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '863befde-b087-4dee-bc39-36e519b18a48', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('23d3425b-8c78-4c9f-8b76-11b145e53777', 'Jogo de Cama Casal Padrão Percal 400 Fios Ponto Palito 04 Peças, Antiácaro, Não faz bolinha Toque Extra Macio – Branco', '<ul><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Toque extremamente macio e confortável com anti pilling (não faz bolinha)</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Tecido com tratamento Antiácaro, não encolhe e não precisa passar</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Jogo de cama confeccionado em tecido Percal 400 Fios de Poliéster com detalhes em ponto palito</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Lençol ajustável com elástico na volta toda, ideal para colchão de até 30cm de Altura</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Kit composto por 04 peças (1 lençol com elástico, 1 lençol de cima com detalhes em ponto palito e 2 fronhas em ponto palito)</span></li></ul><p><br></p>', 64.97, 108.99, 40, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773871091852-j3bc1wjoy2.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.33993467783714126.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9564488174404464.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.6172358085738827.jpg}', 'Menor Preço', 'Amazon', 'https://amzn.to/4uBZoTR', 0, 0, 2, true, NULL, '2026-03-18 21:57:55.186153+00', '2026-03-19 17:56:01.228748+00', 'fc7eff8d-8e39-4384-8816-16da373293e5', '2fcaa27c-a98f-400c-bb31-46c3234b9ea2', '31640105-56f9-43ab-8204-465c8717d731', NULL, 40.4, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('d8ae643d-6100-4283-8059-93a6df1164e2', 'Creatina Pura Dark Lab 500g, Monohidratada 100% de Pureza, Sem Sabor (1kg)', '<p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/b9893dc9-d2bf-432c-93cb-cb41fe3c0300.__CR0,0,1940,1200_PT0_SX970_V1___.jpg" alt="creatina, whey, max, creatine, protein, dux, monohidratada, integralmedica, nutrition, pura"></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/0503fd5a-dac3-4649-aadf-bcd33ef34a14.__CR0,0,1940,1200_PT0_SX970_V1___.jpg" alt="creatina, whey, max, creatine, protein, dux, monohidratada, integralmedica, nutrition, pura"></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/0703ec01-e248-45b6-a638-97eea181825b.__CR0,0,1940,1200_PT0_SX970_V1___.jpg" alt="creatina, whey, max, creatine, protein, dux, monohidratada, integralmedica, nutrition, pura"></p><p><span class="ql-cursor">﻿</span><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/d0a3c1a1-f7ad-4728-99c2-fe37900aecfe.__CR0,0,1940,1200_PT0_SX970_V1___.jpg" alt="creatina, whey, max, creatine, protein, dux, monohidratada, integralmedica, nutrition, pura"></p>', 75.9, 85.9, 12, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773940742930-umfdm90qvzg.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9522582495040556.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.17836842891537785.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9272181640919159.jpg}', '100% Pura', 'Amazon', 'https://amzn.to/4774ldd', 0, 0, 0, true, NULL, '2026-03-19 17:19:19.250926+00', '2026-03-19 17:30:14.74989+00', 'cdff3214-2d21-4fbe-afc3-cade5080b0f0', 'de5d95db-6213-402f-84ef-2c88736e1ab1', '31640105-56f9-43ab-8204-465c8717d731', NULL, 11.6, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'af115fa7-66eb-4445-a35b-232023d163f6', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('13cb9b81-e991-4cf5-a2c2-fccdd1ee770c', 'Samsung Galaxy Book4 Intel® Core™ i5-1335U, Windows 11 Home, 8GB, 512GB SSD, Iris Xe, 15.6'''' Full HD LED, 1.55kg*.', '<p><span style="color: rgb(86, 89, 89);">À vista no Pix ou NuPay Limite Adicional (4% off)</span></p><p>Oferta&nbsp;90 dias de Amazon Music grátis incluso</p><p><br></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/d8d52a3b-3ea6-4e34-9f57-edff0a230af4.__CR0,27,1440,891_PT0_SX970_V1___.jpg" alt="galaxy book, notebook i5, i7, galaxy book4"></p><h3><strong>Copilot. Sua própria AI personalizada</strong></h3><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/ad3696c5-35e8-45a1-9157-b1a63a0d0d43.__CR196,0,1048,648_PT0_SX970_V1___.jpg" alt="galaxy book, notebook i5, i7, galaxy book4"></p><p>Fique em dia com as suas tarefas por meio de avisos rápidos por chat com a assistência personalizada de AI do Copilot. Além disso, utilize ferramentas de comunicação mais inteligentes: acesse contatos e envie mensagens integradas a partir do seu PC ou dispositivo móvel Samsung Galaxy com um simples comando de chat.</p><h3><strong>Desempenho com o qual você pode contar</strong></h3><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/241d1d48-5aed-4909-9812-daea212c49b6.__CR0,20,1440,891_PT0_SX970_V1___.jpg" alt="galaxy book, notebook i5, i7, galaxy book4"></p><p>Conquiste os desafios do seu dia com a última geração dos processadores Inte Core 5/7 com gráficos Intel integrados, oferecendo desempenho estável para streaming e todas as suas multitarefas. Além disso, salve todo o conteúdo que você adora com até 2TB de armazenamento.</p><h3><strong>Ecossistema Samsung Galaxy</strong></h3><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/78495afc-e542-40fb-8444-af33f3b6b2ab.__CR168,0,1104,683_PT0_SX970_V1___.jpg" alt="galaxy book, notebook i5, i7, galaxy book4"></p><h4><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/0083c620-e101-4861-b431-ea3840e17b66.__CR62,0,596,596_PT0_SX300_V1___.jpg" alt="galaxy book, notebook i5, i7, galaxy book4"></h4><p><br></p><p>Mais portas. Suporte total sem hubs externos</p><p>Fino e poderoso, o Galaxy Book4 possui uma ampla variedade de portas integradas para atender às suas necessidades de conectividade. Conecte dispositivos externos via HDMI, duas portas USB-A e duas portas USB-C, slot microSD e até mesmo uma porta RJ45 para conexões LAN de alta velocidade.</p><p><br></p><h4><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/61f0a0ba-d399-4e6d-b034-faf041d056cb.__CR260,0,460,460_PT0_SX300_V1___.jpg" alt="galaxy book, notebook i5, i7, galaxy book4"></h4><p><br></p><p>Conecte seu celular e PC para acesso integrado</p><p>Obtenha acesso direto ao conteúdo do seu celular pelo seu notebook com o Explorador de Arquivos. Basta configurar a conexão sem fio entre seus dispositivos e estará tudo pronto; pesquise os arquivos e fotos de que precisa e depois abra-os diretamente do seu PC.</p><p><br></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/2cfe2616-9cef-4d7d-a2b0-7e36a2e85c86.__CR34,0,1136,1136_PT0_SX300_V1___.jpg" alt="galaxy book, notebook i5, i7, galaxy book4"></p><p><br></p><h4>Incrivelmente fino<span class="ql-cursor">﻿</span></h4><p>O Galaxy Book4 é envolto em um corpo de metal inteiriço que pesa apenas 1,57 kg, por isso é elegante, compacto e extremamente portátil. E com um grande display Full HD de 15,6”, você pode apreciar uma imagem nítida e vibrante na tela enquanto relaxa com seus vídeos e filmes favoritos.</p>', 3836.28, 5799, 34, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773943065216-8q8rqak6fyr.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.029376995757592672.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.5547174534561247.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.14362783623812492.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2583498149717929.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2903031478878043.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.8061876549234315.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9300271803467774.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.706094074438073.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.010294357573605417.jpg}', 'Oferta', 'Amazon', 'https://amzn.to/4rK5XB7', 0, 0, 0, true, NULL, '2026-03-19 18:04:02.552336+00', '2026-03-19 18:05:33.35562+00', '73fc119a-b8cb-4e2a-b3e2-c42abc9ce67c', '99fd7455-3302-455e-b01f-2f237c98cad7', '31640105-56f9-43ab-8204-465c8717d731', NULL, 33.8, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'b8cf1b6a-58d6-48ee-a350-0d02cc6df1f8', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('3a9ef6c2-2f20-4d14-8044-cdf306574f4d', 'Fone de Ouvido Bluetooth Sem Fio Digital Alta Qualidade Intra Auricular M47', NULL, 50.49, NULL, NULL, 'https://cf.shopee.com.br/file/br-11134207-7r98o-m2dgumrr891y18', '{}', NULL, 'Brasil Mart', 'https://s.shopee.com.br/1VublYAo75', 4.8, 0, 0, true, NULL, '2026-03-20 16:58:43.226628+00', '2026-03-20 16:58:43.226628+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, NULL, 11, 0, '[]', NULL);
INSERT INTO public.products VALUES ('9e601a93-e57e-47a4-95be-8589694dd340', 'Impressora HP 107W Laser Monocromática USB e Wi-Fi 110V.', '<p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/ecb58bf7-37dc-4247-87b9-43d4947b61ee.__CR0,3,1600,495_PT0_SX970_V1___.jpg" alt=" Impressora laser 107w, impressora laser"></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/1352217a-0ba7-4146-8a76-4fe1e6255774.__CR0,3,1600,495_PT0_SX970_V1___.jpg" alt="Impressora laser 107w"></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/16bd503d-0246-4429-b05f-e2b4421dcb46.__CR0,3,1600,495_PT0_SX970_V1___.jpg" alt="Impressora laser HP 107w"></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/5c317c86-1c79-4299-8fdb-246b225dda36.__CR0,3,1600,495_PT0_SX970_V1___.jpg" alt="Impressora laser HP 107w"></p><p><img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/8c99c77c-108f-414f-b2e9-8dbbe1b2b42f.__CR0,3,1600,495_PT0_SX970_V1___.jpg" alt="Impressora Multifuncional HP Smart Tank 724"></p><p><br></p>', 854.9, 1249, 32, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773944375746-m69p5zi3hf.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7329282897085794.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.21817486504630257.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9405172446405612.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.46786668834564993.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.4159400595994377.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.3362654911494043.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.42191952433593616.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.4585613759474839.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.8611290543605202.jpg}', 'Mais vendido', 'Amazon', 'https://amzn.to/40GMFSc', 0, 0, 0, true, NULL, '2026-03-19 18:12:35.114+00', '2026-03-19 18:32:26.664103+00', '96368808-68b7-4952-acce-afbe609ee403', 'c011427a-d183-429f-bc8b-1156021c9556', '31640105-56f9-43ab-8204-465c8717d731', NULL, 31.6, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'b8cf1b6a-58d6-48ee-a350-0d02cc6df1f8', NULL, NULL, 0, '[]', NULL);
INSERT INTO public.products VALUES ('f1586a36-4e72-445e-99fb-d93fa04e5bf0', 'Jogo De Panelas 10 Peças Antiaderente Conjunto Caçarola Frigideira Fervedor Cor Coffee Cappuccino Kit Talheres', NULL, 199.99, NULL, NULL, 'https://cf.shopee.com.br/file/br-11134207-81z1k-mgqyauzfcc8wdf', '{}', NULL, 'ARARAS ONLINE', 'https://s.shopee.com.br/9KdT6PZfeq', 4.7, 0, 0, true, NULL, '2026-03-20 17:05:26.698784+00', '2026-03-20 17:05:26.698784+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, NULL, 3, 0, '[]', NULL);
INSERT INTO public.products VALUES ('01e2a87d-ad1c-4e2d-9e4a-62f568880b1f', 'Kit Teclado Semi Mecânico + Mouse Gamer 3200dpi Rgb Led -H8', NULL, 66.99, NULL, NULL, 'https://cf.shopee.com.br/file/br-11134207-7r98o-mbf5wx3w43g8e7', '{}', NULL, 'ZAKKA BARAR', 'https://s.shopee.com.br/8V4MaU9oSA', 4.8, 0, 0, true, NULL, '2026-03-21 00:19:11.374449+00', '2026-03-21 00:19:11.374449+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, NULL, 12, 0, '[]', NULL);
INSERT INTO public.products VALUES ('9259e1e8-2450-46d5-910c-c83cda5f35fa', 'Esteira Ergométrica Elétrica Gallant Elite 2.5hp 14km/h 120kg 220v (GEE12)', NULL, 2379, NULL, NULL, 'https://cf.shopee.com.br/file/br-11134207-7r98o-mbp8ig6va3ix11', '{}', NULL, 'Webcontinental', 'https://s.shopee.com.br/AKVzRyh0Hb', 4.9, 0, 0, true, NULL, '2026-03-20 04:24:30.448999+00', '2026-03-20 04:24:30.448999+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, NULL, 7.000000000000001, 0, '[]', NULL);
INSERT INTO public.products VALUES ('37af9dc6-70ac-4dec-a362-8fcbec407f52', 'Cooktop de Indução Amvox ACT 407 4 Bocas 220V Preto com Painel Touch e Mesa Vitrocerâmica', NULL, 899, NULL, NULL, 'https://cf.shopee.com.br/file/br-11134207-81zts-ml2849we4f7k45', '{}', NULL, 'Commshop', 'https://s.shopee.com.br/6AgRK1vKLM', 5, 0, 0, true, NULL, '2026-03-20 16:57:15.936966+00', '2026-03-21 07:21:18.722068+00', '6bb49f7e-f5f3-4acd-9177-33a52b16ef48', '9955e247-1a27-4d7e-bf13-f7d0fe4cf6d3', '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '1cf6748a-3b9d-4d59-8946-dedaad54eea3', NULL, 3, 0, '[]', NULL);
INSERT INTO public.products VALUES ('25ffa72a-0b67-44c1-ae12-f70a8d41d256', 'Aspirador e Lavadora Vertical de Piso Sem Fio com Auto-limpeza 3 Modo de Limpeza Aspira Lava Esfrega', NULL, 1200, NULL, NULL, 'https://cf.shopee.com.br/file/br-11134207-81ztc-mk3wlheysl4z79', '{}', NULL, 'LS GRUPO', 'https://s.shopee.com.br/qewdpcuN6', 4.8, 0, 0, true, NULL, '2026-03-21 18:05:48.632509+00', '2026-03-21 18:06:01.175453+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '863befde-b087-4dee-bc39-36e519b18a48', NULL, 3, 95, '[]', NULL);


--
-- TOC entry 4653 (class 0 OID 17503)
-- Dependencies: 370
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.profiles VALUES ('b7e0081a-852f-46ab-b0f3-1247c18b2397', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'Giuliano Moretti', NULL, true, '2026-03-11 03:11:05.173222+00', '2026-03-11 03:25:19.240478+00', false, false);
INSERT INTO public.profiles VALUES ('cb92d805-14fb-40c4-b3ec-e54509347a7e', '2374d4c0-d9a8-455f-925d-f42f42f3522d', 'Giuliano Moretti', NULL, true, '2026-03-15 18:38:51.97971+00', '2026-03-15 19:42:19.609833+00', true, true);
INSERT INTO public.profiles VALUES ('ef98ce97-1083-46b9-b819-669565f1b66f', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'Amanda Cristine', NULL, true, '2026-03-16 20:09:55.9155+00', '2026-03-16 20:12:26.132363+00', false, false);


--
-- TOC entry 4658 (class 0 OID 17573)
-- Dependencies: 375
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4657 (class 0 OID 17557)
-- Dependencies: 374
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4683 (class 0 OID 27214)
-- Dependencies: 401
-- Data for Name: search_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.search_cache VALUES ('f4c396f2-92e8-46b1-9355-adc9c9df0d6c', 'cooktop 4 bocas por indução amvox 2000w act 407 turbo 220v', 0, '[{"id": "MLB52941149", "price": 731, "title": "Cooktop 4 bocas por indução Amvox 2000w act 407 turbo 220v", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://www.mercadolivre.com.br/cooktop-4-bocas-por-induco-amvox-2000w-act-407-turbo-220v/p/MLB52941149", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_801023-MLA100199362025_122025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4122378095", "price": 2499, "title": "Cooktop 4 Bocas Por Indução Amvox 2000w Act 407 Turbo 220v", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4122378095-cooktop-4-bocas-por-induco-amvox-2000w-act-407-turbo-220v-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_914249-MLB87707896629_072025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4122391319", "price": 2499, "title": "Cooktop 4 Bocas Por Indução Amvox 2000w Act 407 Turbo 220v", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4122391319-cooktop-4-bocas-por-induco-amvox-2000w-act-407-turbo-220v-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_956387-MLB87707890803_072025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB53002032", "price": 445, "title": "Cooktop 2 Bocas Por Indução Amvox 1500w Act 204 Turbo", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://www.mercadolivre.com.br/cooktop-2-bocas-por-induco-amvox-1500w-act-204-turbo/p/MLB53002032", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_857207-MLA100008427339_122025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4122441183", "price": 1199, "title": "Cooktop 2 Bocas Por Indução Amvox 1500w Act 204 Turbo 220v", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4122441183-cooktop-2-bocas-por-induco-amvox-1500w-act-204-turbo-220v-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_738773-MLB87706882343_072025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4659474780", "price": 130, "title": "Fogão De Indução Cooktop 2000w 2 Bocas 5 Temperaturas Prato", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4659474780-fogo-de-induco-cooktop-2000w-2-bocas-5-temperaturas-prato-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_947854-MLB91412475423_092025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4122454271", "price": 1099, "title": "Cooktop 2 Bocas Por Indução Amvox 1500w Act 204 Turbo 220v", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4122454271-cooktop-2-bocas-por-induco-amvox-1500w-act-204-turbo-220v-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_887880-MLB87706897539_072025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4991785790", "price": 124, "title": "Fogão De Indução Cooktop 2 Bocas 5 Temperaturas Fogareiro", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4991785790-fogo-de-induco-cooktop-2-bocas-5-temperaturas-fogareiro-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_891379-MLB89282369480_082025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB3681970345", "price": 119, "title": "Fogão De Indução Cooktop 2 Bocas 5 Temperaturas Fogareiro", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-3681970345-fogo-de-induco-cooktop-2-bocas-5-temperaturas-fogareiro-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_993552-MLB76038365736_052024-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4659485470", "price": 124, "title": "Fogão De Indução Cooktop 2000w 2 Bocas Fogareiro Disco", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4659485470-fogo-de-induco-cooktop-2000w-2-bocas-fogareiro-disco-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_996209-MLB90976800816_082025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4991875478", "price": 130, "title": "Fogão De Indução Cooktop 2 Bocas 5 Temperaturas Fogareiro", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4991875478-fogo-de-induco-cooktop-2-bocas-5-temperaturas-fogareiro-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_853382-MLB104142905480_012026-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4589745928", "price": 125, "title": "Fogão Cooktop De Mesa Elétrico De Indução 2000w 5 Modos Top", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4589745928-fogo-cooktop-de-mesa-eletrico-de-induco-2000w-5-modos-top-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_948007-MLB72105250088_102023-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4659474652", "price": 125, "title": "Fogão De Indução Cooktop Disco Prato 2000w 2 Bocas 5 Niveis", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4659474652-fogo-de-induco-cooktop-disco-prato-2000w-2-bocas-5-niveis-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_687694-MLB93387767799_092025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB22949681", "price": 627, "title": "Fogão Cooktop De Indução 2000w Com Tampo De Vidro - Eos Cor Preto", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://www.mercadolivre.com.br/fogo-cooktop-de-induco-2000w-com-tampo-de-vidro-eos-cor-preto/p/MLB22949681", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_775418-MLA99963512659_112025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4991773002", "price": 117, "title": "Fogão De Indução Cooktop 2 Bocas 5 Niveis Fogareiro Panela", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4991773002-fogo-de-induco-cooktop-2-bocas-5-niveis-fogareiro-panela-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_687061-MLB78121460946_082024-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB5020951046", "price": 120, "title": "Fogão De Indução Cooktop 2000w 2 Bocas 5 Temperaturas Disco", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-5020951046-fogo-de-induco-cooktop-2000w-2-bocas-5-temperaturas-disco-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_765406-MLB91447927457_092025-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4991836836", "price": 130, "title": "Fogão Prato Disco Indução Cooktop 2 Bocas Fogareiro", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4991836836-fogo-prato-disco-induco-cooktop-2-bocas-fogareiro-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_999322-MLB78349210999_082024-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}, {"id": "MLB4969611012", "price": 175, "title": "Fogareiro Elétrico 110v Cooktop Indução 2000w 2 Bocas Bak", "seller": {"id": 0, "nickname": "Vendedor ML"}, "condition": "new", "permalink": "https://produto.mercadolivre.com.br/MLB-4969611012-fogareiro-eletrico-110v-cooktop-induco-2000w-2-bocas-bak-_JM", "thumbnail": "https://http2.mlstatic.com/D_Q_NP_2X_722262-MLB78151998905_082024-E.webp", "category_id": "", "currency_id": "BRL", "shipping_free": true, "sold_quantity": 0, "original_price": null, "available_quantity": 99}]', '2026-03-21 16:54:22.962335+00', '2026-03-21 22:54:22.439+00');


--
-- TOC entry 4676 (class 0 OID 25968)
-- Dependencies: 394
-- Data for Name: shopee_product_mappings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shopee_product_mappings VALUES ('c5cd8a92-c3a0-4cbd-830f-2b6ad7746d53', '9259e1e8-2450-46d5-910c-c83cda5f35fa', '22293284362', '889973435', '', 0.07, 'https://cf.shopee.com.br/file/br-11134207-7r98o-mbp8ig6va3ix11', 'https://shopee.com.br/product/889973435/22293284362', 'https://s.shopee.com.br/AKVzRyh0Hb', '2026-03-20 04:24:30.755238+00', 'active', '2026-03-20 04:24:30.755238+00');
INSERT INTO public.shopee_product_mappings VALUES ('ba02600e-1ac9-454c-9148-e99abfee565f', '37af9dc6-70ac-4dec-a362-8fcbec407f52', '58255648117', '582435128', '', 0.03, 'https://cf.shopee.com.br/file/br-11134207-81zts-ml2849we4f7k45', 'https://shopee.com.br/product/582435128/58255648117', 'https://s.shopee.com.br/6AgRK1vKLM', '2026-03-20 16:57:16.235736+00', 'active', '2026-03-20 16:57:16.235736+00');
INSERT INTO public.shopee_product_mappings VALUES ('ea605996-6c4c-4ce9-882b-5912c4e9255e', '3a9ef6c2-2f20-4d14-8044-cdf306574f4d', '21099552315', '1284769631', '', 0.11, 'https://cf.shopee.com.br/file/br-11134207-7r98o-m2dgumrr891y18', 'https://shopee.com.br/product/1284769631/21099552315', 'https://s.shopee.com.br/1VublYAo75', '2026-03-20 16:58:43.544492+00', 'active', '2026-03-20 16:58:43.544492+00');
INSERT INTO public.shopee_product_mappings VALUES ('83f795bd-fdd0-4d70-b5d0-6d00d7baccfc', 'f1586a36-4e72-445e-99fb-d93fa04e5bf0', '53750943172', '1215385259', '', 0.03, 'https://cf.shopee.com.br/file/br-11134207-81z1k-mgqyauzfcc8wdf', 'https://shopee.com.br/product/1215385259/53750943172', 'https://s.shopee.com.br/9KdT6PZfeq', '2026-03-20 17:05:27.011206+00', 'active', '2026-03-20 17:05:27.011206+00');
INSERT INTO public.shopee_product_mappings VALUES ('1cdbffaa-b043-48a5-9e1a-c6ec89f42aae', '01e2a87d-ad1c-4e2d-9e4a-62f568880b1f', '22693275207', '711141644', '', 0.12, 'https://cf.shopee.com.br/file/br-11134207-7r98o-mbf5wx3w43g8e7', 'https://shopee.com.br/product/711141644/22693275207', 'https://s.shopee.com.br/8V4MaU9oSA', '2026-03-21 00:19:11.700412+00', 'active', '2026-03-21 00:19:11.700412+00');
INSERT INTO public.shopee_product_mappings VALUES ('f98a4ea7-6ab4-4d38-9b1c-efe5702cac44', '25ffa72a-0b67-44c1-ae12-f70a8d41d256', '53404074135', '494552836', '', 0.03, 'https://cf.shopee.com.br/file/br-11134207-81ztc-mk3wlheysl4z79', 'https://shopee.com.br/product/494552836/53404074135', 'https://s.shopee.com.br/qewdpcuN6', '2026-03-21 18:05:48.893013+00', 'active', '2026-03-21 18:05:48.893013+00');


--
-- TOC entry 4677 (class 0 OID 25986)
-- Dependencies: 395
-- Data for Name: shopee_sync_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shopee_sync_logs VALUES ('23b1306c-eae3-4da2-8448-261eb5c4179f', 'batch_sync', 'success', 0, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 03:03:20.752464+00', '2026-03-20 03:03:21.148+00');
INSERT INTO public.shopee_sync_logs VALUES ('38945738-a85a-4e98-b2d3-5616fb139530', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 03:56:15.947713+00', '2026-03-20 03:56:15.828+00');
INSERT INTO public.shopee_sync_logs VALUES ('59cac797-d2e2-4dad-b4f1-74de3bda07fd', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 03:59:39.805647+00', '2026-03-20 03:59:40.986+00');
INSERT INTO public.shopee_sync_logs VALUES ('1598e654-52e1-4afa-a1c8-b2af9214d949', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 04:17:55.936565+00', '2026-03-20 04:17:57.141+00');
INSERT INTO public.shopee_sync_logs VALUES ('e4edc50f-2996-45f4-a71d-4e80cda5763e', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 04:20:44.614989+00', '2026-03-20 04:20:45.795+00');
INSERT INTO public.shopee_sync_logs VALUES ('149e2670-416e-463c-b2bd-2bd3fb2c8446', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 04:24:30.998235+00', '2026-03-20 04:24:30.861+00');
INSERT INTO public.shopee_sync_logs VALUES ('db700e3f-0691-4707-8b12-281ad4f817ee', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 16:57:16.512341+00', '2026-03-20 16:57:16.363+00');
INSERT INTO public.shopee_sync_logs VALUES ('b0bed44b-0c9a-40fa-8a50-d99f97310936', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 16:58:43.836099+00', '2026-03-20 16:58:43.675+00');
INSERT INTO public.shopee_sync_logs VALUES ('7b613cca-6b64-4b4e-81c9-21e403dc3f92', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 17:05:27.292863+00', '2026-03-20 17:05:27.136+00');
INSERT INTO public.shopee_sync_logs VALUES ('628545c6-042b-4778-9a42-5e992fda45b9', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 00:19:11.933036+00', '2026-03-21 00:19:11.822+00');
INSERT INTO public.shopee_sync_logs VALUES ('e3a21da1-be04-4592-966c-8f7c8cb79398', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:22:49.293941+00', '2026-03-21 17:22:49.175+00');
INSERT INTO public.shopee_sync_logs VALUES ('1d496fb0-efe3-4226-b201-7dce01fc668c', 'batch_sync', 'success', 6, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:23:41.357947+00', '2026-03-21 17:23:42.465+00');
INSERT INTO public.shopee_sync_logs VALUES ('fa391ee6-0d34-4d4a-9a2e-84be6aeed291', 'batch_sync', 'success', 6, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:30:54.868323+00', '2026-03-21 17:30:56.042+00');
INSERT INTO public.shopee_sync_logs VALUES ('42f63d09-a934-487a-b5ac-631dbd7c6a50', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:32:27.277415+00', '2026-03-21 17:32:27.143+00');
INSERT INTO public.shopee_sync_logs VALUES ('dc8ccbbd-07d6-4859-b923-1bff1a9734c5', 'batch_sync', 'success', 6, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:32:48.636493+00', '2026-03-21 17:32:49.799+00');
INSERT INTO public.shopee_sync_logs VALUES ('66972ed8-0acc-4f1a-9db8-bca75eeb42c9', 'batch_sync', 'success', 6, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 17:33:24.38055+00', '2026-03-21 17:33:25.559+00');
INSERT INTO public.shopee_sync_logs VALUES ('1e97c988-4ef2-4916-aad1-4ada066341cf', 'batch_sync', 'success', 6, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 18:05:19.669361+00', '2026-03-21 18:05:20.81+00');
INSERT INTO public.shopee_sync_logs VALUES ('72aa07df-9210-4042-9a0a-bf9461e53422', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 18:05:49.129525+00', '2026-03-21 18:05:49.022+00');
INSERT INTO public.shopee_sync_logs VALUES ('b423979d-8894-4cf6-a8c6-cb57f3f1ffd5', 'batch_sync', 'success', 6, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 18:06:07.867747+00', '2026-03-21 18:06:09.013+00');


--
-- TOC entry 4664 (class 0 OID 22202)
-- Dependencies: 382
-- Data for Name: special_page_products; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4663 (class 0 OID 22188)
-- Dependencies: 381
-- Data for Name: special_pages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.special_pages VALUES ('5a8f37c3-a33e-4cd3-8821-78e4c6d56d52', 'Semana do Consumidor', 'consumidor', 'até 70% de desconto em vários sites', true, '2026-03-16 03:23:48.332605+00');


--
-- TOC entry 4654 (class 0 OID 17516)
-- Dependencies: 371
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_roles VALUES ('fef04994-7b82-4b30-ac35-b4975b6f52e2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'admin');
INSERT INTO public.user_roles VALUES ('4359e1c4-e418-4b54-ad2d-2bfc32ff2bee', '2374d4c0-d9a8-455f-925d-f42f42f3522d', 'viewer');
INSERT INTO public.user_roles VALUES ('2f58229a-0be1-4751-9761-bf69ba943081', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'admin');


--
-- TOC entry 4665 (class 0 OID 22222)
-- Dependencies: 383
-- Data for Name: whatsapp_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.whatsapp_groups VALUES ('09713824-9960-43e5-a735-c0f62a661376', 'https://chat.whatsapp.com/GrfcPK6RHrl8GFeKhiEGkf', true, '2026-03-15 21:01:00.100735+00', 'Casa e Utilidades');
INSERT INTO public.whatsapp_groups VALUES ('674a19a5-17be-4c9c-9190-f2ee425c311d', 'https://chat.whatsapp.com/C90p6nXyhVzA8Fdt6DgiBW?mode=gi_t', true, '2026-03-16 00:45:19.873402+00', 'Eletrônicos');


--
-- TOC entry 4666 (class 0 OID 22234)
-- Dependencies: 384
-- Data for Name: wishlists; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4642 (class 0 OID 17120)
-- Dependencies: 355
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

INSERT INTO realtime.schema_migrations VALUES (20211116024918, '2026-03-11 02:16:12');
INSERT INTO realtime.schema_migrations VALUES (20211116045059, '2026-03-11 02:16:13');
INSERT INTO realtime.schema_migrations VALUES (20211116050929, '2026-03-11 02:16:13');
INSERT INTO realtime.schema_migrations VALUES (20211116051442, '2026-03-11 02:16:13');
INSERT INTO realtime.schema_migrations VALUES (20211116212300, '2026-03-11 02:56:17');
INSERT INTO realtime.schema_migrations VALUES (20211116213355, '2026-03-11 02:56:18');
INSERT INTO realtime.schema_migrations VALUES (20211116213934, '2026-03-11 02:56:18');
INSERT INTO realtime.schema_migrations VALUES (20211116214523, '2026-03-11 02:56:18');
INSERT INTO realtime.schema_migrations VALUES (20211122062447, '2026-03-11 02:56:18');
INSERT INTO realtime.schema_migrations VALUES (20211124070109, '2026-03-11 02:56:19');
INSERT INTO realtime.schema_migrations VALUES (20211202204204, '2026-03-11 02:56:19');
INSERT INTO realtime.schema_migrations VALUES (20211202204605, '2026-03-11 02:56:19');
INSERT INTO realtime.schema_migrations VALUES (20211210212804, '2026-03-11 02:56:20');
INSERT INTO realtime.schema_migrations VALUES (20211228014915, '2026-03-11 02:56:20');
INSERT INTO realtime.schema_migrations VALUES (20220107221237, '2026-03-11 02:56:20');
INSERT INTO realtime.schema_migrations VALUES (20220228202821, '2026-03-11 02:56:20');
INSERT INTO realtime.schema_migrations VALUES (20220312004840, '2026-03-11 02:56:20');
INSERT INTO realtime.schema_migrations VALUES (20220603231003, '2026-03-11 02:56:21');
INSERT INTO realtime.schema_migrations VALUES (20220603232444, '2026-03-11 02:56:21');
INSERT INTO realtime.schema_migrations VALUES (20220615214548, '2026-03-11 02:56:21');
INSERT INTO realtime.schema_migrations VALUES (20220712093339, '2026-03-11 02:56:21');
INSERT INTO realtime.schema_migrations VALUES (20220908172859, '2026-03-11 02:56:21');
INSERT INTO realtime.schema_migrations VALUES (20220916233421, '2026-03-11 02:56:22');
INSERT INTO realtime.schema_migrations VALUES (20230119133233, '2026-03-11 02:56:22');
INSERT INTO realtime.schema_migrations VALUES (20230128025114, '2026-03-11 02:56:22');
INSERT INTO realtime.schema_migrations VALUES (20230128025212, '2026-03-11 02:56:22');
INSERT INTO realtime.schema_migrations VALUES (20230227211149, '2026-03-11 02:56:22');
INSERT INTO realtime.schema_migrations VALUES (20230228184745, '2026-03-11 02:56:23');
INSERT INTO realtime.schema_migrations VALUES (20230308225145, '2026-03-11 02:56:23');
INSERT INTO realtime.schema_migrations VALUES (20230328144023, '2026-03-11 02:56:23');
INSERT INTO realtime.schema_migrations VALUES (20231018144023, '2026-03-11 02:56:23');
INSERT INTO realtime.schema_migrations VALUES (20231204144023, '2026-03-11 02:56:24');
INSERT INTO realtime.schema_migrations VALUES (20231204144024, '2026-03-11 02:56:24');
INSERT INTO realtime.schema_migrations VALUES (20231204144025, '2026-03-11 02:56:24');
INSERT INTO realtime.schema_migrations VALUES (20240108234812, '2026-03-11 02:56:24');
INSERT INTO realtime.schema_migrations VALUES (20240109165339, '2026-03-11 02:56:24');
INSERT INTO realtime.schema_migrations VALUES (20240227174441, '2026-03-11 02:56:25');
INSERT INTO realtime.schema_migrations VALUES (20240311171622, '2026-03-11 02:56:25');
INSERT INTO realtime.schema_migrations VALUES (20240321100241, '2026-03-11 02:56:25');
INSERT INTO realtime.schema_migrations VALUES (20240401105812, '2026-03-11 02:56:26');
INSERT INTO realtime.schema_migrations VALUES (20240418121054, '2026-03-11 02:56:26');
INSERT INTO realtime.schema_migrations VALUES (20240523004032, '2026-03-11 02:56:27');
INSERT INTO realtime.schema_migrations VALUES (20240618124746, '2026-03-11 02:56:27');
INSERT INTO realtime.schema_migrations VALUES (20240801235015, '2026-03-11 02:56:27');
INSERT INTO realtime.schema_migrations VALUES (20240805133720, '2026-03-11 02:56:27');
INSERT INTO realtime.schema_migrations VALUES (20240827160934, '2026-03-11 02:56:28');
INSERT INTO realtime.schema_migrations VALUES (20240919163303, '2026-03-11 02:56:28');
INSERT INTO realtime.schema_migrations VALUES (20240919163305, '2026-03-11 02:56:28');
INSERT INTO realtime.schema_migrations VALUES (20241019105805, '2026-03-11 02:56:28');
INSERT INTO realtime.schema_migrations VALUES (20241030150047, '2026-03-11 02:56:29');
INSERT INTO realtime.schema_migrations VALUES (20241108114728, '2026-03-11 02:56:29');
INSERT INTO realtime.schema_migrations VALUES (20241121104152, '2026-03-11 02:56:29');
INSERT INTO realtime.schema_migrations VALUES (20241130184212, '2026-03-11 02:56:30');
INSERT INTO realtime.schema_migrations VALUES (20241220035512, '2026-03-11 02:56:30');
INSERT INTO realtime.schema_migrations VALUES (20241220123912, '2026-03-11 02:56:30');
INSERT INTO realtime.schema_migrations VALUES (20241224161212, '2026-03-11 02:56:30');
INSERT INTO realtime.schema_migrations VALUES (20250107150512, '2026-03-11 02:56:30');
INSERT INTO realtime.schema_migrations VALUES (20250110162412, '2026-03-11 02:56:31');
INSERT INTO realtime.schema_migrations VALUES (20250123174212, '2026-03-11 02:56:31');
INSERT INTO realtime.schema_migrations VALUES (20250128220012, '2026-03-11 02:56:31');
INSERT INTO realtime.schema_migrations VALUES (20250506224012, '2026-03-11 02:56:31');
INSERT INTO realtime.schema_migrations VALUES (20250523164012, '2026-03-11 02:56:31');
INSERT INTO realtime.schema_migrations VALUES (20250714121412, '2026-03-11 02:56:31');
INSERT INTO realtime.schema_migrations VALUES (20250905041441, '2026-03-11 02:56:32');
INSERT INTO realtime.schema_migrations VALUES (20251103001201, '2026-03-11 02:56:32');
INSERT INTO realtime.schema_migrations VALUES (20251120212548, '2026-03-11 02:56:32');
INSERT INTO realtime.schema_migrations VALUES (20251120215549, '2026-03-11 02:56:32');
INSERT INTO realtime.schema_migrations VALUES (20260218120000, '2026-03-11 02:56:32');


--
-- TOC entry 4644 (class 0 OID 17143)
-- Dependencies: 358
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4646 (class 0 OID 17167)
-- Dependencies: 360
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO storage.buckets VALUES ('banners', 'banners', NULL, '2026-03-11 03:18:33.26887+00', '2026-03-11 03:18:33.26887+00', true, false, NULL, NULL, NULL, 'STANDARD');
INSERT INTO storage.buckets VALUES ('product-images', 'product-images', NULL, '2026-03-11 03:18:04.935894+00', '2026-03-11 03:18:04.935894+00', true, false, NULL, NULL, NULL, 'STANDARD');


--
-- TOC entry 4650 (class 0 OID 17286)
-- Dependencies: 364
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 4651 (class 0 OID 17299)
-- Dependencies: 365
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 4645 (class 0 OID 17159)
-- Dependencies: 359
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO storage.migrations VALUES (0, 'create-migrations-table', 'e18db593bcde2aca2a408c4d1100f6abba2195df', '2026-03-11 02:16:50.281273');
INSERT INTO storage.migrations VALUES (1, 'initialmigration', '6ab16121fbaa08bbd11b712d05f358f9b555d777', '2026-03-11 02:16:50.318087');
INSERT INTO storage.migrations VALUES (2, 'storage-schema', 'f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd', '2026-03-11 02:16:50.322524');
INSERT INTO storage.migrations VALUES (3, 'pathtoken-column', '2cb1b0004b817b29d5b0a971af16bafeede4b70d', '2026-03-11 02:16:50.354093');
INSERT INTO storage.migrations VALUES (4, 'add-migrations-rls', '427c5b63fe1c5937495d9c635c263ee7a5905058', '2026-03-11 02:16:50.382253');
INSERT INTO storage.migrations VALUES (5, 'add-size-functions', '79e081a1455b63666c1294a440f8ad4b1e6a7f84', '2026-03-11 02:16:50.387393');
INSERT INTO storage.migrations VALUES (6, 'change-column-name-in-get-size', 'ded78e2f1b5d7e616117897e6443a925965b30d2', '2026-03-11 02:16:50.393746');
INSERT INTO storage.migrations VALUES (7, 'add-rls-to-buckets', 'e7e7f86adbc51049f341dfe8d30256c1abca17aa', '2026-03-11 02:16:50.399759');
INSERT INTO storage.migrations VALUES (8, 'add-public-to-buckets', 'fd670db39ed65f9d08b01db09d6202503ca2bab3', '2026-03-11 02:16:50.404716');
INSERT INTO storage.migrations VALUES (9, 'fix-search-function', 'af597a1b590c70519b464a4ab3be54490712796b', '2026-03-11 02:16:50.40938');
INSERT INTO storage.migrations VALUES (10, 'search-files-search-function', 'b595f05e92f7e91211af1bbfe9c6a13bb3391e16', '2026-03-11 02:16:50.41456');
INSERT INTO storage.migrations VALUES (11, 'add-trigger-to-auto-update-updated_at-column', '7425bdb14366d1739fa8a18c83100636d74dcaa2', '2026-03-11 02:16:50.419658');
INSERT INTO storage.migrations VALUES (12, 'add-automatic-avif-detection-flag', '8e92e1266eb29518b6a4c5313ab8f29dd0d08df9', '2026-03-11 02:16:50.424757');
INSERT INTO storage.migrations VALUES (13, 'add-bucket-custom-limits', 'cce962054138135cd9a8c4bcd531598684b25e7d', '2026-03-11 02:16:50.430108');
INSERT INTO storage.migrations VALUES (14, 'use-bytes-for-max-size', '941c41b346f9802b411f06f30e972ad4744dad27', '2026-03-11 02:16:50.435163');
INSERT INTO storage.migrations VALUES (15, 'add-can-insert-object-function', '934146bc38ead475f4ef4b555c524ee5d66799e5', '2026-03-11 02:16:50.460259');
INSERT INTO storage.migrations VALUES (16, 'add-version', '76debf38d3fd07dcfc747ca49096457d95b1221b', '2026-03-11 02:16:50.465131');
INSERT INTO storage.migrations VALUES (17, 'drop-owner-foreign-key', 'f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101', '2026-03-11 02:16:50.469957');
INSERT INTO storage.migrations VALUES (18, 'add_owner_id_column_deprecate_owner', 'e7a511b379110b08e2f214be852c35414749fe66', '2026-03-11 02:16:50.475182');
INSERT INTO storage.migrations VALUES (19, 'alter-default-value-objects-id', '02e5e22a78626187e00d173dc45f58fa66a4f043', '2026-03-11 02:16:50.482966');
INSERT INTO storage.migrations VALUES (20, 'list-objects-with-delimiter', 'cd694ae708e51ba82bf012bba00caf4f3b6393b7', '2026-03-11 02:16:50.487631');
INSERT INTO storage.migrations VALUES (21, 's3-multipart-uploads', '8c804d4a566c40cd1e4cc5b3725a664a9303657f', '2026-03-11 02:16:50.494158');
INSERT INTO storage.migrations VALUES (22, 's3-multipart-uploads-big-ints', '9737dc258d2397953c9953d9b86920b8be0cdb73', '2026-03-11 02:16:50.507859');
INSERT INTO storage.migrations VALUES (23, 'optimize-search-function', '9d7e604cddc4b56a5422dc68c9313f4a1b6f132c', '2026-03-11 02:16:50.518032');
INSERT INTO storage.migrations VALUES (24, 'operation-function', '8312e37c2bf9e76bbe841aa5fda889206d2bf8aa', '2026-03-11 02:16:50.52378');
INSERT INTO storage.migrations VALUES (25, 'custom-metadata', 'd974c6057c3db1c1f847afa0e291e6165693b990', '2026-03-11 02:16:50.529287');
INSERT INTO storage.migrations VALUES (26, 'objects-prefixes', '215cabcb7f78121892a5a2037a09fedf9a1ae322', '2026-03-11 02:16:50.534349');
INSERT INTO storage.migrations VALUES (27, 'search-v2', '859ba38092ac96eb3964d83bf53ccc0b141663a6', '2026-03-11 02:16:50.538714');
INSERT INTO storage.migrations VALUES (28, 'object-bucket-name-sorting', 'c73a2b5b5d4041e39705814fd3a1b95502d38ce4', '2026-03-11 02:16:50.542889');
INSERT INTO storage.migrations VALUES (29, 'create-prefixes', 'ad2c1207f76703d11a9f9007f821620017a66c21', '2026-03-11 02:16:50.547093');
INSERT INTO storage.migrations VALUES (30, 'update-object-levels', '2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6', '2026-03-11 02:16:50.551183');
INSERT INTO storage.migrations VALUES (31, 'objects-level-index', 'b40367c14c3440ec75f19bbce2d71e914ddd3da0', '2026-03-11 02:16:50.555494');
INSERT INTO storage.migrations VALUES (32, 'backward-compatible-index-on-objects', 'e0c37182b0f7aee3efd823298fb3c76f1042c0f7', '2026-03-11 02:16:50.559734');
INSERT INTO storage.migrations VALUES (33, 'backward-compatible-index-on-prefixes', 'b480e99ed951e0900f033ec4eb34b5bdcb4e3d49', '2026-03-11 02:16:50.563847');
INSERT INTO storage.migrations VALUES (34, 'optimize-search-function-v1', 'ca80a3dc7bfef894df17108785ce29a7fc8ee456', '2026-03-11 02:16:50.568023');
INSERT INTO storage.migrations VALUES (35, 'add-insert-trigger-prefixes', '458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc', '2026-03-11 02:16:50.572465');
INSERT INTO storage.migrations VALUES (36, 'optimise-existing-functions', '6ae5fca6af5c55abe95369cd4f93985d1814ca8f', '2026-03-11 02:16:50.576639');
INSERT INTO storage.migrations VALUES (37, 'add-bucket-name-length-trigger', '3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1', '2026-03-11 02:16:50.580909');
INSERT INTO storage.migrations VALUES (38, 'iceberg-catalog-flag-on-buckets', '02716b81ceec9705aed84aa1501657095b32e5c5', '2026-03-11 02:16:50.586162');
INSERT INTO storage.migrations VALUES (39, 'add-search-v2-sort-support', '6706c5f2928846abee18461279799ad12b279b78', '2026-03-11 02:16:50.597136');
INSERT INTO storage.migrations VALUES (40, 'fix-prefix-race-conditions-optimized', '7ad69982ae2d372b21f48fc4829ae9752c518f6b', '2026-03-11 02:16:50.601585');
INSERT INTO storage.migrations VALUES (41, 'add-object-level-update-trigger', '07fcf1a22165849b7a029deed059ffcde08d1ae0', '2026-03-11 02:16:50.6059');
INSERT INTO storage.migrations VALUES (42, 'rollback-prefix-triggers', '771479077764adc09e2ea2043eb627503c034cd4', '2026-03-11 02:16:50.610139');
INSERT INTO storage.migrations VALUES (43, 'fix-object-level', '84b35d6caca9d937478ad8a797491f38b8c2979f', '2026-03-11 02:16:50.614466');
INSERT INTO storage.migrations VALUES (44, 'vector-bucket-type', '99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3', '2026-03-11 02:16:50.618641');
INSERT INTO storage.migrations VALUES (45, 'vector-buckets', '049e27196d77a7cb76497a85afae669d8b230953', '2026-03-11 02:16:50.623936');
INSERT INTO storage.migrations VALUES (46, 'buckets-objects-grants', 'fedeb96d60fefd8e02ab3ded9fbde05632f84aed', '2026-03-11 02:16:50.637829');
INSERT INTO storage.migrations VALUES (47, 'iceberg-table-metadata', '649df56855c24d8b36dd4cc1aeb8251aa9ad42c2', '2026-03-11 02:16:50.642793');
INSERT INTO storage.migrations VALUES (48, 'iceberg-catalog-ids', 'e0e8b460c609b9999ccd0df9ad14294613eed939', '2026-03-11 02:16:50.647507');
INSERT INTO storage.migrations VALUES (49, 'buckets-objects-grants-postgres', '072b1195d0d5a2f888af6b2302a1938dd94b8b3d', '2026-03-11 02:16:50.66175');
INSERT INTO storage.migrations VALUES (50, 'search-v2-optimised', '6323ac4f850aa14e7387eb32102869578b5bd478', '2026-03-11 02:16:50.667052');
INSERT INTO storage.migrations VALUES (51, 'index-backward-compatible-search', '2ee395d433f76e38bcd3856debaf6e0e5b674011', '2026-03-11 02:16:51.320111');
INSERT INTO storage.migrations VALUES (52, 'drop-not-used-indexes-and-functions', '5cc44c8696749ac11dd0dc37f2a3802075f3a171', '2026-03-11 02:16:51.32189');
INSERT INTO storage.migrations VALUES (53, 'drop-index-lower-name', 'd0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854', '2026-03-11 02:16:51.332293');
INSERT INTO storage.migrations VALUES (54, 'drop-index-object-level', '6289e048b1472da17c31a7eba1ded625a6457e67', '2026-03-11 02:16:51.335093');
INSERT INTO storage.migrations VALUES (55, 'prevent-direct-deletes', '262a4798d5e0f2e7c8970232e03ce8be695d5819', '2026-03-11 02:16:51.336868');
INSERT INTO storage.migrations VALUES (56, 'fix-optimized-search-function', 'cb58526ebc23048049fd5bf2fd148d18b04a2073', '2026-03-11 02:16:51.34277');


--
-- TOC entry 4647 (class 0 OID 17177)
-- Dependencies: 361
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO storage.objects VALUES ('68f90340-6b56-4e86-ab07-a18b8786511b', 'banners', '1773199614659-yjs26tfe55.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:27:23.452206+00', '2026-03-11 03:27:23.452206+00', '2026-03-11 03:27:23.452206+00', '{"eTag": "\"bd907da3ea6d1c919ab0da8e02824484\"", "size": 47194, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:27:24.000Z", "contentLength": 47194, "httpStatusCode": 200}', DEFAULT, '166e2d47-dd28-409c-879d-dfab2350b6e2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('a23be702-76d9-400c-84a9-af979d4b7fa8', 'banners', '1773615722587-3l91xmo00el.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 23:02:35.710956+00', '2026-03-15 23:02:35.710956+00', '2026-03-15 23:02:35.710956+00', '{"eTag": "\"7104f96b3de100c5f8b5b3f382312500\"", "size": 289638, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T23:02:36.000Z", "contentLength": 289638, "httpStatusCode": 200}', DEFAULT, '8429d443-961e-42c6-ade2-5aaac86ea7a2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9986722f-abf7-48fe-b012-325ae2dea800', 'product-images', '1773200387234-oz0n78lnq7.jpeg', NULL, '2026-03-11 03:39:48.74622+00', '2026-03-11 03:39:48.74622+00', '2026-03-11 03:39:48.74622+00', '{"eTag": "\"2efc684679efdbc4b945188a8ac24dae\"", "size": 211880, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:39:49.000Z", "contentLength": 211880, "httpStatusCode": 200}', DEFAULT, '2bcc7be3-1edc-4ae7-a347-417cdc823f0b', NULL, '{}');
INSERT INTO storage.objects VALUES ('1ce21d9d-8c8f-4c4a-b10b-3b6adfa955bd', 'product-images', '1773200423125-mrhbztbix8j.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:40:51.590462+00', '2026-03-11 03:40:51.590462+00', '2026-03-11 03:40:51.590462+00', '{"eTag": "\"9d693d5a07276bb01ab40fa66a106dff\"", "size": 48724, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:40:52.000Z", "contentLength": 48724, "httpStatusCode": 200}', DEFAULT, 'dc3167ec-5139-4ea0-9ae3-13d1120986fa', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('dcf73b28-23d0-4e45-b592-9434b2ae38b7', 'product-images', '0.9020792630858072.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 14:25:33.817861+00', '2026-03-16 14:25:33.817861+00', '2026-03-16 14:25:33.817861+00', '{"eTag": "\"bba8e9784c7b5dad59353ab172f149cb\"", "size": 60726, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T14:25:34.000Z", "contentLength": 60726, "httpStatusCode": 200}', DEFAULT, '3dbbb231-3b7e-41fb-b873-79da3caec49c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('b12c9b4f-b8ac-4318-a81b-29eac262eebb', 'product-images', '1773200431046-xlu77oe7zs.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:40:59.563094+00', '2026-03-11 03:40:59.563094+00', '2026-03-11 03:40:59.563094+00', '{"eTag": "\"2f456d129dfeef20d7396e219f6d37f2\"", "size": 128550, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:41:00.000Z", "contentLength": 128550, "httpStatusCode": 200}', DEFAULT, 'e68c1e47-0068-4656-87eb-fd0c07f2f3b3', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('205a6b65-a243-4a9e-8168-6475299635cc', 'product-images', '0.2273626709160027.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 19:42:44.56025+00', '2026-03-16 19:42:44.56025+00', '2026-03-16 19:42:44.56025+00', '{"eTag": "\"7ee27d8b4156f7035025f69e03321fd1\"", "size": 178260, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:42:45.000Z", "contentLength": 178260, "httpStatusCode": 200}', DEFAULT, 'e04b2b79-de7a-4b50-aa1c-18241759a301', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('83b6385a-0c0b-490a-90fa-33761332737e', 'product-images', '1773200437938-wvctf7wnt8.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:41:06.296925+00', '2026-03-11 03:41:06.296925+00', '2026-03-11 03:41:06.296925+00', '{"eTag": "\"d64dd86261420b190e0ee336cd065bf7\"", "size": 77120, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:41:07.000Z", "contentLength": 77120, "httpStatusCode": 200}', DEFAULT, 'a57f7db0-f0c3-4827-97eb-e5c98ab9210b', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9aa537a2-9aa8-4709-a663-e5c8f76713ad', 'product-images', '0.6697629916396866.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 19:42:44.61928+00', '2026-03-16 19:42:44.61928+00', '2026-03-16 19:42:44.61928+00', '{"eTag": "\"69ae379bca16ec1ccf57128312b0a625\"", "size": 214968, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:42:45.000Z", "contentLength": 214968, "httpStatusCode": 200}', DEFAULT, '4e0644af-5de5-41f0-beeb-573eaf1bd01a', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('063c3464-6d82-4de3-b3be-1f8783705c84', 'product-images', '1773200444143-w49nkafn6mi.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:41:12.478113+00', '2026-03-11 03:41:12.478113+00', '2026-03-11 03:41:12.478113+00', '{"eTag": "\"75672128ddb9c2fd9f6c4e82344facae\"", "size": 29510, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:41:13.000Z", "contentLength": 29510, "httpStatusCode": 200}', DEFAULT, 'd622fe0e-5135-460b-9065-63cfadee5f07', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9e71fb67-4367-42d8-a832-8918fdfb3c63', 'product-images', '1773200449155-yl9j2709ebh.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:41:17.534038+00', '2026-03-11 03:41:17.534038+00', '2026-03-11 03:41:17.534038+00', '{"eTag": "\"0e7ff5ec8386a904744e16926e4c14fe\"", "size": 103608, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:41:18.000Z", "contentLength": 103608, "httpStatusCode": 200}', DEFAULT, '0cfdea28-46f1-4081-98a1-b1dd043c60ee', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('0016d43a-8292-48d8-b7b0-fc343e039ac7', 'product-images', '1773200664047-tolc14ygfv.png', NULL, '2026-03-11 03:44:24.585553+00', '2026-03-11 03:44:24.585553+00', '2026-03-11 03:44:24.585553+00', '{"eTag": "\"9fca58e6a66029c36c6c13cf1890d391\"", "size": 90159, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:44:25.000Z", "contentLength": 90159, "httpStatusCode": 200}', DEFAULT, 'f94c376e-1df6-4be7-ae24-2ba4d776942a', NULL, '{}');
INSERT INTO storage.objects VALUES ('60a1b2a4-7c58-43df-a6b5-546ba226ba3e', 'product-images', '1773200713844-3hpmqlu1mvs.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:45:42.36332+00', '2026-03-11 03:45:42.36332+00', '2026-03-11 03:45:42.36332+00', '{"eTag": "\"d42897e66d2cb6b5575d47971f65e6c2\"", "size": 40500, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:45:43.000Z", "contentLength": 40500, "httpStatusCode": 200}', DEFAULT, '968411f9-dbde-4c9f-99a6-f8afb1e888eb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('f8fde418-ede4-4f4d-9eac-29a60881de5d', 'product-images', '1773200721474-owp1bwsr7mh.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:45:49.697211+00', '2026-03-11 03:45:49.697211+00', '2026-03-11 03:45:49.697211+00', '{"eTag": "\"54a70248ca40aa33a6b06cf552fcc179\"", "size": 42410, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:45:50.000Z", "contentLength": 42410, "httpStatusCode": 200}', DEFAULT, 'f9aab588-a97e-4731-9e09-ae7e908a94d4', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('deb76e91-29ff-486d-b592-d9932dbfa559', 'product-images', '1773200726138-x9z1x68rcvl.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:45:54.346784+00', '2026-03-11 03:45:54.346784+00', '2026-03-11 03:45:54.346784+00', '{"eTag": "\"2fe9e5679c5cba0e9e5c1f078d48b5c0\"", "size": 43750, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:45:55.000Z", "contentLength": 43750, "httpStatusCode": 200}', DEFAULT, 'f963a020-db48-4bcb-abec-4a9567749d2a', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('ddaf758a-7454-40e4-a89b-0db256b1221e', 'product-images', '1773943002477-gurhelx7n8k.png', NULL, '2026-03-19 17:56:43.27455+00', '2026-03-19 17:56:43.27455+00', '2026-03-19 17:56:43.27455+00', '{"eTag": "\"2b6a84968cc02ffc5b2c6b844d63ab11\"", "size": 65327, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:56:44.000Z", "contentLength": 65327, "httpStatusCode": 200}', DEFAULT, '83e2f464-9df8-43f2-bc4f-34f17dbae75c', NULL, '{}');
INSERT INTO storage.objects VALUES ('2b3343c9-3892-43e1-a6f6-91ee6de6e7dd', 'product-images', '1773200733145-wblaw2njro.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-11 03:46:01.379483+00', '2026-03-11 03:46:01.379483+00', '2026-03-11 03:46:01.379483+00', '{"eTag": "\"d42897e66d2cb6b5575d47971f65e6c2\"", "size": 40500, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-11T03:46:02.000Z", "contentLength": 40500, "httpStatusCode": 200}', DEFAULT, '7daa4599-3c4b-478f-9930-9e99815cba80', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('ccdac7ed-5885-45c0-a26a-b00e9740ca5c', 'banners', '1773616295878-xa5qupvjp7.png', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 23:12:10.921018+00', '2026-03-15 23:12:10.921018+00', '2026-03-15 23:12:10.921018+00', '{"eTag": "\"510cabb5322421da4a60ddbce875ae66-2\"", "size": 7012132, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T23:12:11.000Z", "contentLength": 7012132, "httpStatusCode": 200}', DEFAULT, 'a19d193d-a863-4cd8-b05a-73e8854632ee', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('4c3b0b22-be6f-443b-aced-cca46d711d0c', 'product-images', '1773456801939-1l4wkwrx17o.gif', NULL, '2026-03-14 02:53:23.635198+00', '2026-03-14 02:53:23.635198+00', '2026-03-14 02:53:23.635198+00', '{"eTag": "\"e68cc604cab69bf03b8cd228d940f5ef\"", "size": 43, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T02:53:24.000Z", "contentLength": 43, "httpStatusCode": 200}', DEFAULT, '1d794a4f-6ae6-4169-a8a2-637b3137d3b1', NULL, '{}');
INSERT INTO storage.objects VALUES ('cec25968-650b-4062-904d-14641463be93', 'product-images', '1773456925832-2j8xbbrmp3s.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 02:55:57.024208+00', '2026-03-14 02:55:57.024208+00', '2026-03-14 02:55:57.024208+00', '{"eTag": "\"5786d5f7f6453170307d33372246b80f\"", "size": 116951, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T02:55:57.000Z", "contentLength": 116951, "httpStatusCode": 200}', DEFAULT, 'ca0a26f3-9d3d-459f-a157-a4b763ab726c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('2a871d91-e004-48e7-acf1-7ecb933d7be4', 'product-images', '1773689821774-h4d7jzu4d59.jpeg', NULL, '2026-03-16 19:37:03.006264+00', '2026-03-16 19:37:03.006264+00', '2026-03-16 19:37:03.006264+00', '{"eTag": "\"1b59be242d671cbb4be39c401895f192\"", "size": 104102, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:37:03.000Z", "contentLength": 104102, "httpStatusCode": 200}', DEFAULT, '8ea66951-f902-44a9-8dd7-95030cda4218', NULL, '{}');
INSERT INTO storage.objects VALUES ('211de773-1985-4470-9987-226331fe5b46', 'product-images', '1773456931425-qg1x0p2us.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 02:56:02.304621+00', '2026-03-14 02:56:02.304621+00', '2026-03-14 02:56:02.304621+00', '{"eTag": "\"74c574b27271e71dc793293a01f28e62\"", "size": 127437, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T02:56:03.000Z", "contentLength": 127437, "httpStatusCode": 200}', DEFAULT, '918a5bad-c051-4789-bf32-09f25aebd280', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('871c3f30-f6cd-4ac2-ad3b-ac95a99feef6', 'product-images', '1773456937869-uaf5ftbacog.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 02:56:08.266086+00', '2026-03-14 02:56:08.266086+00', '2026-03-14 02:56:08.266086+00', '{"eTag": "\"77ff1224db8d1d995e39470f6ed3f7c2\"", "size": 143451, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T02:56:09.000Z", "contentLength": 143451, "httpStatusCode": 200}', DEFAULT, '1a134792-6373-4ab9-9eaf-052c4b292caf', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('f3082d70-d249-438d-b2b9-9fbb9c1b89c3', 'product-images', '1773456946461-rlebcy617l.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 02:56:16.956927+00', '2026-03-14 02:56:16.956927+00', '2026-03-14 02:56:16.956927+00', '{"eTag": "\"2ad5f2b0a92e5fd66faaa7d7ece56f56\"", "size": 171039, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T02:56:17.000Z", "contentLength": 171039, "httpStatusCode": 200}', DEFAULT, '50108858-9bdf-4be3-8f8e-ea2ba37cdae2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('933f4aa3-6d26-4cfe-8a10-72cca04f2c0d', 'product-images', '0.8449942039100002.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 19:42:44.379864+00', '2026-03-16 19:42:44.379864+00', '2026-03-16 19:42:44.379864+00', '{"eTag": "\"1b59be242d671cbb4be39c401895f192\"", "size": 104102, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:42:45.000Z", "contentLength": 104102, "httpStatusCode": 200}', DEFAULT, '18634969-8a4d-4064-a678-068db87a8d9f', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('c1ef60c7-c311-4afe-9a51-85642773c4c1', 'product-images', '1773456954032-1lmkes37du2.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 02:56:24.916504+00', '2026-03-14 02:56:24.916504+00', '2026-03-14 02:56:24.916504+00', '{"eTag": "\"b07d08d24fce95354f792aafc2b7777b\"", "size": 131029, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T02:56:25.000Z", "contentLength": 131029, "httpStatusCode": 200}', DEFAULT, 'a48c611c-5d22-4097-9376-cc367472d192', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9de42eb2-05fb-46db-95ed-6b55ee9e2517', 'product-images', '1773457304562-uliwmmzh65r.jpeg', NULL, '2026-03-14 03:01:45.3885+00', '2026-03-14 03:01:45.3885+00', '2026-03-14 03:01:45.3885+00', '{"eTag": "\"9188c3ac094e6788d7aed85f94828144\"", "size": 86196, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:01:46.000Z", "contentLength": 86196, "httpStatusCode": 200}', DEFAULT, 'dbd18d6b-59fc-4f2d-b47c-42d6f9d89392', NULL, '{}');
INSERT INTO storage.objects VALUES ('c289bb50-007d-4fb7-b97f-bc7040031c7a', 'product-images', '1773457604781-nx7wxp0l26k.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:07:15.081502+00', '2026-03-14 03:07:15.081502+00', '2026-03-14 03:07:15.081502+00', '{"eTag": "\"6cdbaf6813ca5c912c982435122e8fd4\"", "size": 16126, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:07:16.000Z", "contentLength": 16126, "httpStatusCode": 200}', DEFAULT, '6cf6240b-8505-48ec-8b3f-3e051c8a95d3', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('5c8d1afb-b9e2-4866-bd39-daaaea39a3fc', 'product-images', '1773457610182-lhcoes1j7x.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:07:20.287457+00', '2026-03-14 03:07:20.287457+00', '2026-03-14 03:07:20.287457+00', '{"eTag": "\"c92ad6dbcd441a2aa022960bb84df2f2\"", "size": 58456, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:07:21.000Z", "contentLength": 58456, "httpStatusCode": 200}', DEFAULT, '716aae7f-3107-4de2-91cb-ceb845f779b1', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('6e3b6c3c-e276-426f-ae29-2be2fe19e6b4', 'product-images', '1773457613858-0th3i4c0b6gf.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:07:24.17278+00', '2026-03-14 03:07:24.17278+00', '2026-03-14 03:07:24.17278+00', '{"eTag": "\"dac158661ca2340d4a11c0ac6f9fc4fb\"", "size": 73360, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:07:25.000Z", "contentLength": 73360, "httpStatusCode": 200}', DEFAULT, '1bd5a705-fb30-4381-84e3-ce06f12c4ab0', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9d5766c3-4d40-4a91-bd05-bc71e65ff974', 'product-images', '1773943065216-8q8rqak6fyr.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:20.92288+00', '2026-03-19 17:58:20.92288+00', '2026-03-19 17:58:20.92288+00', '{"eTag": "\"a01968e2be3c1b9ef894c35f803968ed\"", "size": 42231, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:21.000Z", "contentLength": 42231, "httpStatusCode": 200}', DEFAULT, '79b73245-06d3-46e4-9023-0633a6febc71', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9c478c59-8c88-40ee-9158-86ae7113654e', 'product-images', '1773457618038-qvh5q6g9vh9.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:07:28.107445+00', '2026-03-14 03:07:28.107445+00', '2026-03-14 03:07:28.107445+00', '{"eTag": "\"4aa3c632c3348668b9218d58cbec6048\"", "size": 17314, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:07:29.000Z", "contentLength": 17314, "httpStatusCode": 200}', DEFAULT, '180d97d6-ab3f-48c2-bd04-098a73781815', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('b0a2e117-5bd3-4e1e-aeab-fea71131758e', 'banners', '1773618191923-uuta2v4negc.png', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 23:43:47.203627+00', '2026-03-15 23:43:47.203627+00', '2026-03-15 23:43:47.203627+00', '{"eTag": "\"800ab44a3f4cb1fdf47e18faf7bfef54-2\"", "size": 8217964, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T23:43:47.000Z", "contentLength": 8217964, "httpStatusCode": 200}', DEFAULT, '4f91fbc1-4ed1-4704-8b19-eb3d5c4a2393', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('cbe20b92-60d7-460a-82bb-a1afb6a97c79', 'product-images', '1773457855076-l09adga68f.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:11:25.170956+00', '2026-03-14 03:11:25.170956+00', '2026-03-14 03:11:25.170956+00', '{"eTag": "\"3317954ce8ebdf1fcd8ea42381c515df\"", "size": 55144, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:11:26.000Z", "contentLength": 55144, "httpStatusCode": 200}', DEFAULT, '946fc33d-9136-48b7-8014-fa52feb1c111', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('c089b482-546d-40ba-a876-d5b4d8a8392e', 'product-images', '0.31359794304408095.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 19:42:44.644754+00', '2026-03-16 19:42:44.644754+00', '2026-03-16 19:42:44.644754+00', '{"eTag": "\"b5df22a540b4ae8ae08db45c3f4a485d\"", "size": 207279, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:42:45.000Z", "contentLength": 207279, "httpStatusCode": 200}', DEFAULT, '07c3d71a-a286-485d-8a5b-3a8d398d1c81', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('079d6ad0-8080-4af6-b289-8821d0fce0c0', 'product-images', '0.7060452079211895.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 19:42:44.754864+00', '2026-03-16 19:42:44.754864+00', '2026-03-16 19:42:44.754864+00', '{"eTag": "\"8ea236d06def4f0aa5398b22ce7ee92d\"", "size": 246291, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:42:45.000Z", "contentLength": 246291, "httpStatusCode": 200}', DEFAULT, '2e257f7f-1be4-44d6-9bb2-eded1b6557e9', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('8664c915-539c-4ec5-92c9-e8373ef77741', 'product-images', '0.706094074438073.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:31.448006+00', '2026-03-19 17:58:31.448006+00', '2026-03-19 17:58:31.448006+00', '{"eTag": "\"5056b4b2a9763ebe7d3ea09c400bdeb9\"", "size": 17005, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:32.000Z", "contentLength": 17005, "httpStatusCode": 200}', DEFAULT, 'ec07b38c-0abd-4b45-a460-42d496aa5670', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('0863430a-9309-4966-a9aa-44f66e90c1d1', 'product-images', '1773690180563-eegjkar6alw.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 19:43:01.536808+00', '2026-03-16 19:43:01.536808+00', '2026-03-16 19:43:01.536808+00', '{"eTag": "\"1b59be242d671cbb4be39c401895f192\"", "size": 104102, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:43:02.000Z", "contentLength": 104102, "httpStatusCode": 200}', DEFAULT, '6f2c00d7-cdec-404f-9ea6-aeecc27b5a7c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('8d727c1c-9a82-464a-bee4-366f232e9997', 'product-images', '1773691959775-1q1eivtc5q7.png', NULL, '2026-03-16 20:12:40.621809+00', '2026-03-16 20:12:40.621809+00', '2026-03-16 20:12:40.621809+00', '{"eTag": "\"9fca58e6a66029c36c6c13cf1890d391\"", "size": 90159, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:12:41.000Z", "contentLength": 90159, "httpStatusCode": 200}', DEFAULT, '67bd88c1-6389-46cc-92ab-511fb9027b48', NULL, '{}');
INSERT INTO storage.objects VALUES ('1ee77eae-1f4d-4bfc-b832-56760b5191d5', 'product-images', '0.19732941794967074.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:22:16.336658+00', '2026-03-16 20:22:16.336658+00', '2026-03-16 20:22:16.336658+00', '{"eTag": "\"0b58957da3d7b5463b6ca10f3a6c67c6\"", "size": 55746, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:22:17.000Z", "contentLength": 55746, "httpStatusCode": 200}', DEFAULT, 'd805db64-f4b7-4c1e-826d-cb16d460a53b', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('3166cdd9-d966-40b7-85ca-cf32c07455ac', 'product-images', '0.019753669837962673.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:22:16.340587+00', '2026-03-16 20:22:16.340587+00', '2026-03-16 20:22:16.340587+00', '{"eTag": "\"dfa8c723f76566a5a10af925b085c8e5\"", "size": 45124, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:22:17.000Z", "contentLength": 45124, "httpStatusCode": 200}', DEFAULT, '72fb33cb-d058-49e8-89cc-5421d94a11a2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('7eca2566-4503-445c-86ef-3dd576e9f97d', 'product-images', '0.7377313125631279.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:22:16.37051+00', '2026-03-16 20:22:16.37051+00', '2026-03-16 20:22:16.37051+00', '{"eTag": "\"00b0a16ee4995ba9f57d3fe1eab43d22\"", "size": 60466, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:22:17.000Z", "contentLength": 60466, "httpStatusCode": 200}', DEFAULT, '411d78c4-d2fd-4300-a495-e5ff1e7e5f85', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('dde7681f-e0bd-426a-97bc-d3a5691ae94b', 'product-images', '0.8316413862349953.png', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:22:16.40263+00', '2026-03-16 20:22:16.40263+00', '2026-03-16 20:22:16.40263+00', '{"eTag": "\"06b0c5fa4db8b249ccc0269a72a7a3aa\"", "size": 98670, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:22:17.000Z", "contentLength": 98670, "httpStatusCode": 200}', DEFAULT, 'efc1ffa9-25ba-49b4-832d-52e84bc30dc9', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('8b716140-5593-4686-a76f-c1e2c883ef1c', 'product-images', '0.5641408700663466.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:22:16.397968+00', '2026-03-16 20:22:16.397968+00', '2026-03-16 20:22:16.397968+00', '{"eTag": "\"cd9f2a8dad956d872c4be630af8ac59c\"", "size": 67220, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:22:17.000Z", "contentLength": 67220, "httpStatusCode": 200}', DEFAULT, 'ddf41240-48f7-4510-ade5-98f5300185bf', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('94f517a3-560b-4171-b850-2b5e2cff8d20', 'product-images', '0.078449103311789.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:22:16.5631+00', '2026-03-16 20:22:16.5631+00', '2026-03-16 20:22:16.5631+00', '{"eTag": "\"934bc6163af0952573b4e7250cf0b17d\"", "size": 128502, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:22:17.000Z", "contentLength": 128502, "httpStatusCode": 200}', DEFAULT, 'fc066ff1-1a7c-495c-837a-07123e6c5890', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('ac4be361-7032-4b44-8851-8a5b193e28ec', 'product-images', '1773457621650-zdewmxe48j.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:07:31.751446+00', '2026-03-14 03:07:31.751446+00', '2026-03-14 03:07:31.751446+00', '{"eTag": "\"0b2755c26f6c7617022b993bd32bda8d\"", "size": 24878, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:07:32.000Z", "contentLength": 24878, "httpStatusCode": 200}', DEFAULT, 'a4b63f54-aa0b-4ee7-bc02-ffff9ef85ec0', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('00b36ac4-a51b-47dc-96b6-66113288963d', 'banners', '1773619339220-vhhogvryog.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 00:02:52.258393+00', '2026-03-16 00:02:52.258393+00', '2026-03-16 00:02:52.258393+00', '{"eTag": "\"2bb6ab93eeda6144344b8e548f6a342b\"", "size": 130658, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T00:02:53.000Z", "contentLength": 130658, "httpStatusCode": 200}', DEFAULT, '3916c1be-c4a1-47f7-bf2c-1d56bd3f284e', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('f6628d26-e5b2-4d17-b26c-667b44bf17ac', 'product-images', '1773457747353-bgh3t38on4g.png', NULL, '2026-03-14 03:09:09.655268+00', '2026-03-14 03:09:09.655268+00', '2026-03-14 03:09:09.655268+00', '{"eTag": "\"9aab08dbb09044cb11ff0b0ebe1efb10\"", "size": 575664, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:09:10.000Z", "contentLength": 575664, "httpStatusCode": 200}', DEFAULT, '8a6509b8-f45d-4726-bfe3-1e58846499a3', NULL, '{}');
INSERT INTO storage.objects VALUES ('123ce89b-59ce-4a36-8243-ca194d7d9d8c', 'product-images', '1773457831379-cxri70pha15.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:11:01.79225+00', '2026-03-14 03:11:01.79225+00', '2026-03-14 03:11:01.79225+00', '{"eTag": "\"010add4f5bf45104fc968a2c115c8929\"", "size": 58812, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:11:02.000Z", "contentLength": 58812, "httpStatusCode": 200}', DEFAULT, 'd10e7873-579e-4df1-abdc-17d3862a9d07', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('0e57c6dd-3ffa-4fee-b3ed-cc68d1cc07a9', 'banners', '1773619384319-tpa4dxpux9.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 00:03:37.041365+00', '2026-03-16 00:03:37.041365+00', '2026-03-16 00:03:37.041365+00', '{"eTag": "\"6f55f275a79f72c07c20af7543314915\"", "size": 80454, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T00:03:37.000Z", "contentLength": 80454, "httpStatusCode": 200}', DEFAULT, '676548be-00aa-43c6-ac1c-997765357d88', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('8e426741-e7ed-4441-bf1c-e35537ba47ae', 'product-images', '1773457839051-xs0z8u2q1qo.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:11:09.719292+00', '2026-03-14 03:11:09.719292+00', '2026-03-14 03:11:09.719292+00', '{"eTag": "\"52e701e3e33928e8c2352a88648c5140\"", "size": 66302, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:11:10.000Z", "contentLength": 66302, "httpStatusCode": 200}', DEFAULT, '921210b4-1d30-45e7-bd22-182fdf91e3f2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('1f862794-e6f4-42c4-93c4-8dbd11f0e210', 'product-images', '0.6134864885812055.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 04:19:59.810733+00', '2026-03-20 04:19:59.810733+00', '2026-03-20 04:19:59.810733+00', '{"eTag": "\"428259208844df77c4cbc58e609a1993\"", "size": 40324, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-20T04:20:00.000Z", "contentLength": 40324, "httpStatusCode": 200}', DEFAULT, '9b18d70b-8ae7-428f-8ae0-c5f426c9ba5d', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('175e0af9-5a98-4af1-b54f-49929f9a6658', 'product-images', '1773457847032-bsdnz709bx9.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-14 03:11:17.106853+00', '2026-03-14 03:11:17.106853+00', '2026-03-14 03:11:17.106853+00', '{"eTag": "\"8e28097db4a2193620101df438ad2c9a\"", "size": 30838, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T03:11:18.000Z", "contentLength": 30838, "httpStatusCode": 200}', DEFAULT, 'f9e5889c-1faf-48ce-a2be-de85a82d10e9', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('96432e7f-bf32-4064-ae5a-fc4a24d2164b', 'banners', '1773619766735-e310yiv6wj.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 00:09:59.511039+00', '2026-03-16 00:09:59.511039+00', '2026-03-16 00:09:59.511039+00', '{"eTag": "\"a8fc12a85e370bf4ac64c44b9172264c\"", "size": 121979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T00:10:00.000Z", "contentLength": 121979, "httpStatusCode": 200}', DEFAULT, 'df52769b-2613-4346-82f1-f9d4f61e680e', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('392c845a-27a2-4d71-ae23-04a625e4db16', 'product-images', '1773585459422-tcljvwxjlvr.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 14:37:40.029847+00', '2026-03-15 14:37:40.029847+00', '2026-03-15 14:37:40.029847+00', '{"eTag": "\"f3a8078f49d7c9605fa5a28c05200f9f\"", "size": 48450, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T14:37:40.000Z", "contentLength": 48450, "httpStatusCode": 200}', DEFAULT, '3a28419b-392a-47e5-9875-fd18f96efb27', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('6015f922-b5e2-4138-a76d-a3b3aa0985e4', 'product-images', '1773585471916-a011pn94bug.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 14:37:52.459927+00', '2026-03-15 14:37:52.459927+00', '2026-03-15 14:37:52.459927+00', '{"eTag": "\"024642eea7fff6cbb02949881fdaeb4d\"", "size": 59546, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T14:37:53.000Z", "contentLength": 59546, "httpStatusCode": 200}', DEFAULT, 'f8c0b571-1ed3-429a-826a-4d8729f1b2cb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('8d32a9ee-e0ea-42ce-839e-603df03f515a', 'product-images', '1773585475488-lvoc86nz7bo.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 14:37:56.004836+00', '2026-03-15 14:37:56.004836+00', '2026-03-15 14:37:56.004836+00', '{"eTag": "\"85c52848bb41f515682e59e1056330f3\"", "size": 17155, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T14:37:56.000Z", "contentLength": 17155, "httpStatusCode": 200}', DEFAULT, 'd50eb3db-7254-4d1d-865b-8bf0972e2100', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('315aca61-f8b4-43b3-a8ba-8f8430f3550a', 'product-images', '1773585478820-k8sq5x7jy2g.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 14:37:59.438732+00', '2026-03-15 14:37:59.438732+00', '2026-03-15 14:37:59.438732+00', '{"eTag": "\"69f9305ae4341ecad1a84a39c82a2277\"", "size": 70910, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T14:38:00.000Z", "contentLength": 70910, "httpStatusCode": 200}', DEFAULT, '2d07ee2f-a1ba-4e1d-b55b-dc07fbb8152a', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('2c8ebb15-f5ce-4344-98c7-ad24d8cc4784', 'product-images', '1773585484951-3r4yr6gfevj.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 14:38:05.645088+00', '2026-03-15 14:38:05.645088+00', '2026-03-15 14:38:05.645088+00', '{"eTag": "\"6d32ab22bf5795738504116646526f36\"", "size": 66033, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T14:38:06.000Z", "contentLength": 66033, "httpStatusCode": 200}', DEFAULT, '5416eb42-5ac3-4cf8-bc90-092f2ad3bf9d', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('3eeec5bf-f7f1-4328-a2f2-1ae4fed343db', 'product-images', '1773597461298-dzzu8ylmu5.jpeg', NULL, '2026-03-15 17:57:41.931905+00', '2026-03-15 17:57:41.931905+00', '2026-03-15 17:57:41.931905+00', '{"eTag": "\"0a66aff63c81f13dd9c01c24d24f7ac8\"", "size": 230933, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:57:42.000Z", "contentLength": 230933, "httpStatusCode": 200}', DEFAULT, '2d990cc4-14a8-41c1-b37f-da4dd04bd9e3', NULL, '{}');
INSERT INTO storage.objects VALUES ('22deb1ae-6134-4dcf-83a9-36636ab6c75e', 'product-images', '1773585497421-083pjcmtkq49.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 14:38:18.322748+00', '2026-03-15 14:38:18.322748+00', '2026-03-15 14:38:18.322748+00', '{"eTag": "\"93e56b0fca069c091b1c8f0b6ccde5eb\"", "size": 264192, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T14:38:19.000Z", "contentLength": 264192, "httpStatusCode": 200}', DEFAULT, '21d616bb-1cfc-429c-965a-4dfeba50af17', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('6a96e38d-8d11-45cd-9dc9-acf2a6eab32b', 'product-images', '1773586230100-pfg9ush4y28.jpeg', NULL, '2026-03-15 14:50:30.739538+00', '2026-03-15 14:50:30.739538+00', '2026-03-15 14:50:30.739538+00', '{"eTag": "\"389d8c2af5d0852a790a841955880bbe\"", "size": 870, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T14:50:31.000Z", "contentLength": 870, "httpStatusCode": 200}', DEFAULT, '89aeac83-2388-44f8-a250-a6660ac40bf9', NULL, '{}');
INSERT INTO storage.objects VALUES ('2b7a0f60-72c5-4856-923e-211cb0201858', 'banners', '1773619742849-3r8lt9lwull.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 00:09:36.15357+00', '2026-03-16 00:09:36.15357+00', '2026-03-16 00:09:36.15357+00', '{"eTag": "\"6539f3c03cad72d41bb54355a7b58d34\"", "size": 102999, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T00:09:37.000Z", "contentLength": 102999, "httpStatusCode": 200}', DEFAULT, '54f8cdac-8e74-4684-8179-6fbd2686eb97', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('50e2b338-a500-4e6c-9465-e856ac6da446', 'product-images', '1773589264959-wmyekukn4m.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 15:41:37.353033+00', '2026-03-15 15:41:37.353033+00', '2026-03-15 15:41:37.353033+00', '{"eTag": "\"aac48df76e5bd09258740c5a331f0504\"", "size": 97446, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T15:41:38.000Z", "contentLength": 97446, "httpStatusCode": 200}', DEFAULT, '7d52a722-17a6-4245-9c26-0ea9ba0d85c9', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('394420d5-1ba6-4fd0-b71c-544a93351d3d', 'product-images', '1773589271989-40vgqzlghzo.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 15:41:44.315982+00', '2026-03-15 15:41:44.315982+00', '2026-03-15 15:41:44.315982+00', '{"eTag": "\"b46b71d6454bd7d52a79f52e0e65052d\"", "size": 108453, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T15:41:45.000Z", "contentLength": 108453, "httpStatusCode": 200}', DEFAULT, 'f4005e36-98fc-4edc-bdff-17596570b1c6', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('d0c5d8c2-7a45-4392-884d-30d8dd871b9b', 'product-images', '0.7978730482419226.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 19:42:44.740931+00', '2026-03-16 19:42:44.740931+00', '2026-03-16 19:42:44.740931+00', '{"eTag": "\"f2dc73221610f7f26922c3478bcfabaa\"", "size": 227613, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:42:45.000Z", "contentLength": 227613, "httpStatusCode": 200}', DEFAULT, 'cc9dc580-d866-4b13-b954-63759d56e478', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('c5ae72a3-7a8c-41b1-8019-28ff1d30bff9', 'product-images', '1773589281029-crsj49lncit.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 15:41:53.419759+00', '2026-03-15 15:41:53.419759+00', '2026-03-15 15:41:53.419759+00', '{"eTag": "\"6f55f275a79f72c07c20af7543314915\"", "size": 80454, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T15:41:54.000Z", "contentLength": 80454, "httpStatusCode": 200}', DEFAULT, '5735b2cc-78b9-407f-b8ae-ab4cbb9d7940', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('8a7d1858-2d4b-45cb-92d8-30a4134e4158', 'product-images', '1773589295632-2xuevu92dgg.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 15:42:08.353153+00', '2026-03-15 15:42:08.353153+00', '2026-03-15 15:42:08.353153+00', '{"eTag": "\"f5e553b44a117e31de01d3c66ccefa5e\"", "size": 85642, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T15:42:09.000Z", "contentLength": 85642, "httpStatusCode": 200}', DEFAULT, 'b2bac56f-00b1-486e-a2b8-cffc4059b87d', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('6acf889f-5510-4724-b20b-ed680b65b0e3', 'product-images', '1773692506938-mv4jdv59idb.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:21:47.857998+00', '2026-03-16 20:21:47.857998+00', '2026-03-16 20:21:47.857998+00', '{"eTag": "\"0b58957da3d7b5463b6ca10f3a6c67c6\"", "size": 55746, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:21:48.000Z", "contentLength": 55746, "httpStatusCode": 200}', DEFAULT, '4e3a4e6f-8fe9-474f-b247-6edd49b18cda', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('c749681a-2f0d-4cd0-ac37-feb04b3b7e16', 'product-images', '1773589300906-ljbd2kyxg4g.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 15:42:13.147781+00', '2026-03-15 15:42:13.147781+00', '2026-03-15 15:42:13.147781+00', '{"eTag": "\"9598c283340c2a52e4a9d2e11608c10b\"", "size": 82473, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T15:42:14.000Z", "contentLength": 82473, "httpStatusCode": 200}', DEFAULT, '310f635b-3216-4936-9370-9c6f75de693b', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('e19286cf-f5f7-44b3-8975-e3e4cfeeefdc', 'product-images', '1773589313489-e91wx4s8v1v.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 15:42:26.421364+00', '2026-03-15 15:42:26.421364+00', '2026-03-15 15:42:26.421364+00', '{"eTag": "\"1606b866e34cff427a5990be7de8e11b\"", "size": 260268, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T15:42:27.000Z", "contentLength": 260268, "httpStatusCode": 200}', DEFAULT, 'e4e946b6-c41f-4cd0-84b1-39c8f977c583', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('5610d295-597e-4243-90ce-d54f1f3036a7', 'product-images', 'platform-1773595590624.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:27:03.384523+00', '2026-03-15 17:27:03.384523+00', '2026-03-15 17:27:03.384523+00', '{"eTag": "\"243f14983c415b36ee78e7a05e8bfef9\"", "size": 6282, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:27:04.000Z", "contentLength": 6282, "httpStatusCode": 200}', DEFAULT, '2c96f6b5-1a32-41d9-a773-73772381a6bd', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('7e27a84c-33fb-42f7-80df-362d8011129c', 'product-images', 'platform-1773595674820.png', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:28:27.516881+00', '2026-03-15 17:28:27.516881+00', '2026-03-15 17:28:27.516881+00', '{"eTag": "\"4fcc4c3ac0ad5e66c0cc41c98c24c00e\"", "size": 2415, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:28:28.000Z", "contentLength": 2415, "httpStatusCode": 200}', DEFAULT, '3b1bc37c-3461-4034-8890-102817454559', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('1140c060-799d-4446-9513-f73426ba6abe', 'product-images', '1773597213934-olye4mqjlz7.jpeg', NULL, '2026-03-15 17:53:34.800203+00', '2026-03-15 17:53:34.800203+00', '2026-03-15 17:53:34.800203+00', '{"eTag": "\"ad90de1316578c9c4300a3829497d83e\"", "size": 1257911, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:53:35.000Z", "contentLength": 1257911, "httpStatusCode": 200}', DEFAULT, '9c13dbf2-7556-4ec2-81ab-987aa17d1f65', NULL, '{}');
INSERT INTO storage.objects VALUES ('2c1d4308-e473-4135-b47a-45da338168ca', 'product-images', '0.010294357573605417.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:31.533139+00', '2026-03-19 17:58:31.533139+00', '2026-03-19 17:58:31.533139+00', '{"eTag": "\"56c44e9a79ef28f9dce5266605a9d7b5\"", "size": 33607, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:32.000Z", "contentLength": 33607, "httpStatusCode": 200}', DEFAULT, 'dda58eb5-6311-46c0-8cee-c0aca05594fe', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('65865cf7-72e5-48d6-8e7f-03c0721e9569', 'product-images', '1773597473530-1vbcbg32d8i.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:58:26.654343+00', '2026-03-15 17:58:26.654343+00', '2026-03-15 17:58:26.654343+00', '{"eTag": "\"2bb6ab93eeda6144344b8e548f6a342b\"", "size": 130658, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:58:27.000Z", "contentLength": 130658, "httpStatusCode": 200}', DEFAULT, '2a5559de-9ec0-496d-9f4c-5d578c5d0d13', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('ff48efd4-a8a5-4f3e-b49f-77743eac6b74', 'product-images', '1773671097341-ot9er2kt46.jpeg', NULL, '2026-03-16 14:24:57.812009+00', '2026-03-16 14:24:57.812009+00', '2026-03-16 14:24:57.812009+00', '{"eTag": "\"067b8da017320afa35ad274951631278\"", "size": 246720, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T14:24:58.000Z", "contentLength": 246720, "httpStatusCode": 200}', DEFAULT, '8fdbdd46-2306-4ceb-af26-2254f1d1a53f', NULL, '{}');
INSERT INTO storage.objects VALUES ('b59822bb-615f-46c7-8620-230855637b47', 'product-images', '1773597485567-jnpqsr6xbwb.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:58:38.425529+00', '2026-03-15 17:58:38.425529+00', '2026-03-15 17:58:38.425529+00', '{"eTag": "\"42f83171a43f0b8fa7fcb5c19d1f61c2\"", "size": 63036, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:58:39.000Z", "contentLength": 63036, "httpStatusCode": 200}', DEFAULT, '28ad3fd5-796c-4cee-a409-dfe38b79f9f5', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('fe0d9fa0-1fa1-425b-9976-231395680ab2', 'product-images', '1773597535567-stshq5unlf.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:59:28.054461+00', '2026-03-15 17:59:28.054461+00', '2026-03-15 17:59:28.054461+00', '{"eTag": "\"2bb6ab93eeda6144344b8e548f6a342b\"", "size": 130658, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:59:28.000Z", "contentLength": 130658, "httpStatusCode": 200}', DEFAULT, '95f56ef6-10c6-478e-899e-06b5ea176dde', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('5746f6b9-15de-4a5a-91c5-ddcc6438676c', 'product-images', '0.09961339965628391.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 14:25:40.686395+00', '2026-03-16 14:25:40.686395+00', '2026-03-16 14:25:40.686395+00', '{"eTag": "\"559a4e9a6dd442222a07ac54d79fe37a\"", "size": 10844, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T14:25:41.000Z", "contentLength": 10844, "httpStatusCode": 200}', DEFAULT, 'd5e18b10-b487-47d2-af1b-6d5bf5c7e35a', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('11079b2d-8571-4914-b062-8878b34200ab', 'product-images', '1773597541699-qw5ww3lwvz8.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:59:34.06132+00', '2026-03-15 17:59:34.06132+00', '2026-03-15 17:59:34.06132+00', '{"eTag": "\"c398c4a405868ac0c23e0d3dcef385a6\"", "size": 77602, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:59:34.000Z", "contentLength": 77602, "httpStatusCode": 200}', DEFAULT, '6c9c005d-c1a1-40a2-b976-acd496a16ed0', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('1915221a-fdcc-4ac6-acc1-b62da5df6110', 'product-images', '0.8061876549234315.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:31.808895+00', '2026-03-19 17:58:31.808895+00', '2026-03-19 17:58:31.808895+00', '{"eTag": "\"77f89a50e79f7f0b4159b6b01a6eed0e\"", "size": 54506, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:32.000Z", "contentLength": 54506, "httpStatusCode": 200}', DEFAULT, 'cc5fe9ca-cb33-49f0-8054-cd7d89280b2d', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('e6c5fbb7-1e9a-4ce8-85ae-872bf0e82621', 'product-images', '1773597547475-bs2ki1avoz8.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:59:39.853448+00', '2026-03-15 17:59:39.853448+00', '2026-03-15 17:59:39.853448+00', '{"eTag": "\"73218dda4312249256d5e75e94c33bce\"", "size": 68840, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:59:40.000Z", "contentLength": 68840, "httpStatusCode": 200}', DEFAULT, '63842154-a310-45eb-9b43-c786fdcf589d', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('d67df5ce-70de-4737-a916-9044458e41d2', 'product-images', '0.42965879737264245.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 14:25:41.387894+00', '2026-03-16 14:25:41.387894+00', '2026-03-16 14:25:41.387894+00', '{"eTag": "\"79cdd2dffe8bbd574c900c18bb75f208\"", "size": 81092, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T14:25:42.000Z", "contentLength": 81092, "httpStatusCode": 200}', DEFAULT, '2c22b0b3-fb2d-4046-9047-cc6eebb53528', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('0d3dd8f8-b038-45c6-896f-e3edc7341c74', 'product-images', '1773597554936-hu3nk302h7j.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:59:47.960832+00', '2026-03-15 17:59:47.960832+00', '2026-03-15 17:59:47.960832+00', '{"eTag": "\"d0d89e0dac5abd33442bb7faeb4c666d\"", "size": 96818, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:59:48.000Z", "contentLength": 96818, "httpStatusCode": 200}', DEFAULT, 'dff16ab0-a4d6-459a-8e87-81969d9c0822', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9814f221-d65d-4902-a5bf-76b62446779f', 'product-images', '1773597560082-u9vecu6g8jl.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:59:52.408959+00', '2026-03-15 17:59:52.408959+00', '2026-03-15 17:59:52.408959+00', '{"eTag": "\"a603e03e9397c157b7fcdd755c1a64e2\"", "size": 55162, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:59:53.000Z", "contentLength": 55162, "httpStatusCode": 200}', DEFAULT, 'da5a5b2f-85cf-441e-a9ed-54a9496cda40', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('b730c2f0-2a73-4db8-b3e6-cf4466b7b01d', 'product-images', '1773597565983-wvx03r1mjzi.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 17:59:58.89001+00', '2026-03-15 17:59:58.89001+00', '2026-03-15 17:59:58.89001+00', '{"eTag": "\"d6d0708dd9fc15db5ed5de9cf8a2f0ad\"", "size": 89306, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T17:59:59.000Z", "contentLength": 89306, "httpStatusCode": 200}', DEFAULT, '92951821-e1dc-48bd-9ccb-05302a6c13ce', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('15a7e637-3f6a-4563-a69f-4dd47e5a50af', 'product-images', '0.705227580480899.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-16 19:42:44.653822+00', '2026-03-16 19:42:44.653822+00', '2026-03-16 19:42:44.653822+00', '{"eTag": "\"9a689b240dfa365873cd10330b66671d\"", "size": 235247, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T19:42:45.000Z", "contentLength": 235247, "httpStatusCode": 200}', DEFAULT, 'd8d30027-3f5b-4744-b532-086a1d788b15', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('e1c51e22-c0b7-4513-901f-eb0836661e18', 'product-images', '1773597571070-bm8833ylqkh.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-15 18:00:03.601573+00', '2026-03-15 18:00:03.601573+00', '2026-03-15 18:00:03.601573+00', '{"eTag": "\"936184729dee2e22834c1890154aab26\"", "size": 133250, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-15T18:00:04.000Z", "contentLength": 133250, "httpStatusCode": 200}', DEFAULT, 'fefca317-7a29-4791-882b-76ed6b1c066b', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('375b752d-f30e-4d0b-9868-c104d0806146', 'product-images', '0.9173336741140385.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:22:16.612885+00', '2026-03-16 20:22:16.612885+00', '2026-03-16 20:22:16.612885+00', '{"eTag": "\"d391c6bb15d131f094afb87d3f7d6ebd\"", "size": 63660, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:22:17.000Z", "contentLength": 63660, "httpStatusCode": 200}', DEFAULT, 'd2a14d76-ae4e-4c94-8f7d-5aa55fec56dd', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('56627ff0-f25a-499f-b0b3-7514a3af969d', 'product-images', '0.14362783623812492.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:31.718876+00', '2026-03-19 17:58:31.718876+00', '2026-03-19 17:58:31.718876+00', '{"eTag": "\"0b78bfcc201bb5b2491fb83a7204e30f\"", "size": 132950, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:32.000Z", "contentLength": 132950, "httpStatusCode": 200}', DEFAULT, '47af0e3e-26ec-4d6e-b830-3a437a5a5214', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('6708c656-cdc3-48b0-8127-c152f38df0da', 'product-images', '1773693050493-xzi60est18b.jpeg', NULL, '2026-03-16 20:30:51.562721+00', '2026-03-16 20:30:51.562721+00', '2026-03-16 20:30:51.562721+00', '{"eTag": "\"5a9f055e6f1351c5cad9cfffc2e2ab14\"", "size": 120059, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:30:52.000Z", "contentLength": 120059, "httpStatusCode": 200}', DEFAULT, 'f531532b-ba83-4a54-9d06-52d43b307a84', NULL, '{}');
INSERT INTO storage.objects VALUES ('dd54c3b4-dc13-467c-9f25-47c08261806f', 'product-images', '0.9300271803467774.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:31.815733+00', '2026-03-19 17:58:31.815733+00', '2026-03-19 17:58:31.815733+00', '{"eTag": "\"9032d8c9e7fd787fca1b4e987dc25d32\"", "size": 18102, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:32.000Z", "contentLength": 18102, "httpStatusCode": 200}', DEFAULT, '31f79655-4602-444a-b9c9-d757abcc0bb5', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('b15a408c-744a-4310-8a03-4d8ff63838fb', 'product-images', '0.5547174534561247.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:31.884574+00', '2026-03-19 17:58:31.884574+00', '2026-03-19 17:58:31.884574+00', '{"eTag": "\"3f472010022ec4d9d6820f99656ba639\"", "size": 110637, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:32.000Z", "contentLength": 110637, "httpStatusCode": 200}', DEFAULT, 'ab68b90b-5ee0-437e-ab10-ad31647fc585', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('91d5f126-8e42-41ba-8602-c8de805e113e', 'product-images', '0.029376995757592672.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:32.049332+00', '2026-03-19 17:58:32.049332+00', '2026-03-19 17:58:32.049332+00', '{"eTag": "\"5764b6727b212e92defbea156e1a79ba\"", "size": 133298, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:33.000Z", "contentLength": 133298, "httpStatusCode": 200}', DEFAULT, '8a3e5ae7-fd93-426c-8816-cd3306811cb7', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('490d862e-322b-4a21-b9e5-9daca3af25f3', 'product-images', '0.2903031478878043.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:32.118138+00', '2026-03-19 17:58:32.118138+00', '2026-03-19 17:58:32.118138+00', '{"eTag": "\"279f006e30a608c100fe69ad2add013f\"", "size": 115854, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:33.000Z", "contentLength": 115854, "httpStatusCode": 200}', DEFAULT, 'ce63a726-1d8e-4c63-b445-aea812eb6ea7', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('371180aa-5ffb-4e87-85df-3030339b6259', 'product-images', '1773943770749-b65e17433v.gif', NULL, '2026-03-19 18:09:31.579226+00', '2026-03-19 18:09:31.579226+00', '2026-03-19 18:09:31.579226+00', '{"eTag": "\"e68cc604cab69bf03b8cd228d940f5ef\"", "size": 43, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:09:32.000Z", "contentLength": 43, "httpStatusCode": 200}', DEFAULT, '1d36c4ea-4d7a-469d-a996-425c534333c2', NULL, '{}');
INSERT INTO storage.objects VALUES ('1b2ae532-ac73-47ff-b14e-b3ab534b125a', 'product-images', '0.7329282897085794.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:35.552357+00', '2026-03-19 18:10:35.552357+00', '2026-03-19 18:10:35.552357+00', '{"eTag": "\"266a96e9b143697a9c46d199417484a0\"", "size": 52075, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:36.000Z", "contentLength": 52075, "httpStatusCode": 200}', DEFAULT, '86eb9db8-fded-4e90-becf-dce6cd30fe0c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('b62bc6a8-dd72-4904-b403-5af4e81df1ba', 'product-images', '1773944375746-m69p5zi3hf.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:20:11.888755+00', '2026-03-19 18:20:11.888755+00', '2026-03-19 18:20:11.888755+00', '{"eTag": "\"04d978ae1150640f2a833a0c4ab652d3\"", "size": 146049, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:20:12.000Z", "contentLength": 146049, "httpStatusCode": 200}', DEFAULT, '730faa80-fae2-4b69-9875-2638d9816867', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('2f784977-1f84-44e3-bd8d-5afcd35d576e', 'product-images', '0.8164285745752561.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 04:19:59.871651+00', '2026-03-20 04:19:59.871651+00', '2026-03-20 04:19:59.871651+00', '{"eTag": "\"7339b5e6730b7399071f8f8907f57364\"", "size": 27160, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-20T04:20:00.000Z", "contentLength": 27160, "httpStatusCode": 200}', DEFAULT, '6ed26a4a-8053-46d8-b514-eb42787d86d2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('0925fe04-6da9-483e-a4fa-6d6009d89985', 'product-images', '0.9127688623400663.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-20 04:19:59.898379+00', '2026-03-20 04:19:59.898379+00', '2026-03-20 04:19:59.898379+00', '{"eTag": "\"54a6b6b67ad4a1aec8dfa6cd6274dfb4\"", "size": 19270, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-20T04:20:00.000Z", "contentLength": 19270, "httpStatusCode": 200}', DEFAULT, 'c4ea488c-f280-4161-acde-64928f04c889', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('49cea1fe-e409-4641-9562-dfec4070aa49', 'product-images', '0.2583498149717929.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:32.127907+00', '2026-03-19 17:58:32.127907+00', '2026-03-19 17:58:32.127907+00', '{"eTag": "\"387bbfb3bcb58846617037451813d56b\"", "size": 101313, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:33.000Z", "contentLength": 101313, "httpStatusCode": 200}', DEFAULT, '029ff0d5-dbf9-4cc4-ae52-f2ca3fcd5c7d', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('a6382276-35de-4329-bb82-f41e6682e6d8', 'product-images', '0.2582148944815016.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:35.919239+00', '2026-03-16 20:32:35.919239+00', '2026-03-16 20:32:35.919239+00', '{"eTag": "\"6d769eba4bdc4d1805057ea92330931f\"", "size": 20040, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:36.000Z", "contentLength": 20040, "httpStatusCode": 200}', DEFAULT, 'ae28849c-865b-4a66-94bd-51485b4b4945', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('931b80a3-555c-40df-b106-4844ab6c0f14', 'product-images', 'platform-1774059464441.png', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 02:18:22.025335+00', '2026-03-21 02:18:22.025335+00', '2026-03-21 02:18:22.025335+00', '{"eTag": "\"5ceddd19cf5b94d4d570f708ca23667a\"", "size": 24536, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-21T02:18:22.000Z", "contentLength": 24536, "httpStatusCode": 200}', DEFAULT, '2d69ec66-44f2-4cd9-850a-9fba4269e2e7', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('b37e05ef-c522-490b-8301-2e87aac20872', 'product-images', '0.46384725213935984.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:35.958356+00', '2026-03-16 20:32:35.958356+00', '2026-03-16 20:32:35.958356+00', '{"eTag": "\"eabf879e3337f1d11aae7db4c927a0b8\"", "size": 103954, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:36.000Z", "contentLength": 103954, "httpStatusCode": 200}', DEFAULT, 'b2c1f70b-8082-4803-83e2-b65862817c8c', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('f51aa2b5-7f2f-4ff6-b69e-b2d160e26af0', 'product-images', '0.32225771434351835.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:36.024796+00', '2026-03-16 20:32:36.024796+00', '2026-03-16 20:32:36.024796+00', '{"eTag": "\"4ca953e46b294bb6768d3c13e721854a\"", "size": 56040, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:36.000Z", "contentLength": 56040, "httpStatusCode": 200}', DEFAULT, '76724ca1-81d7-4fcb-98ba-a0f1cc13557a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('305f7811-1173-498a-b967-fa6d01094520', 'product-images', '0.6514552209362939.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:36.084883+00', '2026-03-16 20:32:36.084883+00', '2026-03-16 20:32:36.084883+00', '{"eTag": "\"8082ce6f9625f706cfb1f5e60de259d8\"", "size": 47978, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:36.000Z", "contentLength": 47978, "httpStatusCode": 200}', DEFAULT, 'c16b76f9-0db1-44f3-a69d-5aefd16ac681', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('c0f85aee-fc10-4e70-aa67-cbc4ab955d9f', 'product-images', '0.7180593746971142.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:36.116735+00', '2026-03-16 20:32:36.116735+00', '2026-03-16 20:32:36.116735+00', '{"eTag": "\"9104921f97e4393312b6ee9ad99d47c8\"", "size": 84534, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:37.000Z", "contentLength": 84534, "httpStatusCode": 200}', DEFAULT, '30656878-1cbd-46f2-b829-590276827ae6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('42c256c3-853f-4ea8-b13b-a9cc4ff8d981', 'product-images', '1773704979886-lxnvgggtgc.jpeg', NULL, '2026-03-16 23:49:40.49449+00', '2026-03-16 23:49:40.49449+00', '2026-03-16 23:49:40.49449+00', '{"eTag": "\"4772f5c23aca370cf6aac3b77dcb8faf\"", "size": 29193, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:49:41.000Z", "contentLength": 29193, "httpStatusCode": 200}', DEFAULT, '5de952ba-cddc-4c8c-8e54-6eb1db854835', NULL, '{}');
INSERT INTO storage.objects VALUES ('733a6e42-060d-4638-a501-8ee25197cf37', 'product-images', '0.45270689894587335.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:51:27.176596+00', '2026-03-16 23:51:27.176596+00', '2026-03-16 23:51:27.176596+00', '{"eTag": "\"d23c8216bc8d72fae028d6a911dc8df6\"", "size": 4500, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:51:28.000Z", "contentLength": 4500, "httpStatusCode": 200}', DEFAULT, '341c5ec7-95cb-41aa-96a4-c13cb0a5bc49', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('1a42cb85-c6ea-4e35-9ee4-992a5ed8740c', 'product-images', '0.6152228301389535.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:51:27.650736+00', '2026-03-16 23:51:27.650736+00', '2026-03-16 23:51:27.650736+00', '{"eTag": "\"477af41260e53b8119cb33a58bd08194\"", "size": 23142, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:51:28.000Z", "contentLength": 23142, "httpStatusCode": 200}', DEFAULT, 'aeb1f8e6-0a9c-434e-b8e3-33de0e934d0a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('4a73908b-4ec9-4d65-b71d-9099928b5d39', 'product-images', '0.7851943107190276.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:51:27.831222+00', '2026-03-16 23:51:27.831222+00', '2026-03-16 23:51:27.831222+00', '{"eTag": "\"4772f5c23aca370cf6aac3b77dcb8faf\"", "size": 29193, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:51:28.000Z", "contentLength": 29193, "httpStatusCode": 200}', DEFAULT, '25208f94-de23-4b7b-8dd0-6914c9f07bc8', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('edfcbb60-d279-44c4-9aea-a470d4e43566', 'product-images', '0.7325696870480343.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:51:27.896102+00', '2026-03-16 23:51:27.896102+00', '2026-03-16 23:51:27.896102+00', '{"eTag": "\"c6cc22ef80ef25ad1f36ac7539c0a697\"", "size": 44994, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:51:28.000Z", "contentLength": 44994, "httpStatusCode": 200}', DEFAULT, '24219d3b-8fc1-484a-b0f1-a77ebb84bcd6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('5e264012-c96b-4e8d-802b-4717682277b9', 'product-images', '1773705627889-398zgsclkma.png', NULL, '2026-03-17 00:00:28.496723+00', '2026-03-17 00:00:28.496723+00', '2026-03-17 00:00:28.496723+00', '{"eTag": "\"2b6a84968cc02ffc5b2c6b844d63ab11\"", "size": 65327, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:00:29.000Z", "contentLength": 65327, "httpStatusCode": 200}', DEFAULT, 'c8c11879-6a37-4c2b-89c1-96e12df0c5a6', NULL, '{}');
INSERT INTO storage.objects VALUES ('0acd267d-2f9b-4d73-aed8-739550fece23', 'product-images', '0.8038771897070267.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:02:16.559807+00', '2026-03-17 00:02:16.559807+00', '2026-03-17 00:02:16.559807+00', '{"eTag": "\"42f0c5e00a50d5a20a1e178796243a63\"", "size": 30761, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:02:17.000Z", "contentLength": 30761, "httpStatusCode": 200}', DEFAULT, 'a32dedcf-3d5f-41bc-bbdf-360a98a86958', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('034f3cf4-df4d-4805-b127-e5bd0681261c', 'product-images', '1773943788237-4murq1r78h7.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:23.99649+00', '2026-03-19 18:10:23.99649+00', '2026-03-19 18:10:23.99649+00', '{"eTag": "\"81470b88250eb1c232ce4dbe41ae2fe1\"", "size": 43532, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:24.000Z", "contentLength": 43532, "httpStatusCode": 200}', DEFAULT, 'e4c8883b-cd49-4be4-8f0f-246c25144057', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('8f6c37ac-282b-4da2-a9f9-043832d11e51', 'product-images', '1773706011992-sbubl28shd.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:06:53.072606+00', '2026-03-17 00:06:53.072606+00', '2026-03-17 00:06:53.072606+00', '{"eTag": "\"f687c0b98b5d3e41318c07e95d6b460d\"", "size": 56094, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:06:54.000Z", "contentLength": 56094, "httpStatusCode": 200}', DEFAULT, 'e99702f3-17bd-4887-9ca4-c68fd2380878', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('f48dba6e-60a1-4008-9c24-395872314b8a', 'product-images', '0.21817486504630257.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:35.566783+00', '2026-03-19 18:10:35.566783+00', '2026-03-19 18:10:35.566783+00', '{"eTag": "\"bd8aec652a95b460271a6d989354b84b\"", "size": 44811, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:36.000Z", "contentLength": 44811, "httpStatusCode": 200}', DEFAULT, 'c12fc63e-cfdf-4de1-975e-71340e914398', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('3a44300f-f7b6-48a1-aca3-0d58b74d1fc5', 'product-images', '0.9405172446405612.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:36.194638+00', '2026-03-19 18:10:36.194638+00', '2026-03-19 18:10:36.194638+00', '{"eTag": "\"8b4e865a2c1de5d146dd60c4d61f5616\"", "size": 43261, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:37.000Z", "contentLength": 43261, "httpStatusCode": 200}', DEFAULT, '77476bac-c17d-4611-9ad6-98fd87a42395', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('38b11af0-2e5e-4219-8bc6-6115e239bbc8', 'product-images', '0.3362654911494043.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:36.004842+00', '2026-03-19 18:10:36.004842+00', '2026-03-19 18:10:36.004842+00', '{"eTag": "\"a868317d7d6340a96c9740ce322a77e9\"", "size": 18188, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:36.000Z", "contentLength": 18188, "httpStatusCode": 200}', DEFAULT, '24cc41f2-9f8f-46a5-a792-be6ca57cb181', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('397ec0be-af84-47a4-b3cb-783e943ea552', 'product-images', '0.01045378692862764.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:02:16.562146+00', '2026-03-17 00:02:16.562146+00', '2026-03-17 00:02:16.562146+00', '{"eTag": "\"0fe37f3055452dba024e9686573335e7\"", "size": 34945, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:02:17.000Z", "contentLength": 34945, "httpStatusCode": 200}', DEFAULT, 'c2887a3d-a03b-411a-bf6d-2d14b58da075', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('c65d77eb-d20f-489a-94c0-5476d6afa74e', 'product-images', '0.2849525776766926.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:02:16.557104+00', '2026-03-17 00:02:16.557104+00', '2026-03-17 00:02:16.557104+00', '{"eTag": "\"91f25f81608d9307e95d3e75f9fea3ed\"", "size": 36119, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:02:17.000Z", "contentLength": 36119, "httpStatusCode": 200}', DEFAULT, '40c452a2-7280-4ced-b124-98437a6015d3', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('2fb360ea-c3db-460f-91ec-68b9034f390b', 'product-images', '0.9852977507152725.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:02:16.556468+00', '2026-03-17 00:02:16.556468+00', '2026-03-17 00:02:16.556468+00', '{"eTag": "\"6271fa414046fc949316e36a959e5d2c\"", "size": 28670, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:02:17.000Z", "contentLength": 28670, "httpStatusCode": 200}', DEFAULT, 'c24f1515-25e1-4c71-a85d-e98e6340f523', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('607e392e-28d5-40f1-b36e-9951c9040d10', 'product-images', '0.5340661938006928.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:02:16.601158+00', '2026-03-17 00:02:16.601158+00', '2026-03-17 00:02:16.601158+00', '{"eTag": "\"55b26e450af299bf9415f4466de6829c\"", "size": 53404, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:02:17.000Z", "contentLength": 53404, "httpStatusCode": 200}', DEFAULT, '1365bf8e-7c01-4e8c-949b-b36bdc4f4ee0', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('28e6e693-a9a6-4e06-88c4-0881c4f68e10', 'product-images', '0.19691294741351384.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:02:16.605613+00', '2026-03-17 00:02:16.605613+00', '2026-03-17 00:02:16.605613+00', '{"eTag": "\"f687c0b98b5d3e41318c07e95d6b460d\"", "size": 56094, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:02:17.000Z", "contentLength": 56094, "httpStatusCode": 200}', DEFAULT, 'd667292d-45da-434d-a787-6e2a390692f2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('a56d27b0-f38f-423a-ba12-15f487f8cac6', 'product-images', '1773707571327-ocijmmmc8mm.png', NULL, '2026-03-17 00:32:52.000466+00', '2026-03-17 00:32:52.000466+00', '2026-03-17 00:32:52.000466+00', '{"eTag": "\"2b6a84968cc02ffc5b2c6b844d63ab11\"", "size": 65327, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:32:52.000Z", "contentLength": 65327, "httpStatusCode": 200}', DEFAULT, 'ac0012fa-d187-455f-8fea-1c2ac78b9e44', NULL, '{}');
INSERT INTO storage.objects VALUES ('3e33a22a-ac1f-4173-b474-62ec768873ac', 'product-images', '0.4585613759474839.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:36.155656+00', '2026-03-19 18:10:36.155656+00', '2026-03-19 18:10:36.155656+00', '{"eTag": "\"9ea438fb956a8f5a2437204151e181f1\"", "size": 26366, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:37.000Z", "contentLength": 26366, "httpStatusCode": 200}', DEFAULT, '739c19f5-07fe-4f7d-858a-d87893a9d141', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('0ae08400-2e0b-4a29-98da-533d24542633', 'product-images', '0.42191952433593616.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:36.190996+00', '2026-03-19 18:10:36.190996+00', '2026-03-19 18:10:36.190996+00', '{"eTag": "\"6ad807e52859b2ef850e4e2708c55b9c\"", "size": 19839, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:37.000Z", "contentLength": 19839, "httpStatusCode": 200}', DEFAULT, 'cd8b510f-417c-45f1-944d-1750549ec42a', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('4bbbd606-fa5a-419f-8130-476c07414f6b', 'product-images', '0.06966345548027641.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:35:15.740727+00', '2026-03-17 00:35:15.740727+00', '2026-03-17 00:35:15.740727+00', '{"eTag": "\"f62629209cbb6c28567678409084817a\"", "size": 56085, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:35:16.000Z", "contentLength": 56085, "httpStatusCode": 200}', DEFAULT, '8041bc10-cfdc-466c-a5dc-572544a0e149', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('283848bf-2b35-4392-9207-7623b9715a66', 'product-images', '0.9422174451321388.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:35:16.248886+00', '2026-03-17 00:35:16.248886+00', '2026-03-17 00:35:16.248886+00', '{"eTag": "\"4797d494f242b2c3eee0a8b3799c06fe\"", "size": 233700, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:35:17.000Z", "contentLength": 233700, "httpStatusCode": 200}', DEFAULT, '8b92d088-3d1d-4313-81a4-d2ae05ef1a03', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('f1da0613-3757-4caa-bf73-e792d0a3032c', 'product-images', '0.17444364530211587.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:35:16.427988+00', '2026-03-17 00:35:16.427988+00', '2026-03-17 00:35:16.427988+00', '{"eTag": "\"85c1ca26e63fe9da660da39b0cb8cc2d\"", "size": 255660, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:35:17.000Z", "contentLength": 255660, "httpStatusCode": 200}', DEFAULT, 'a826c4b3-ad2e-4504-b62b-772de6f79c16', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('d26577f8-c2ca-49da-a7da-afde3e1127ae', 'product-images', '0.4623481835030996.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:35:16.44352+00', '2026-03-17 00:35:16.44352+00', '2026-03-17 00:35:16.44352+00', '{"eTag": "\"2a5d4ae4a92491c6b158e707b7539036\"", "size": 219987, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:35:17.000Z", "contentLength": 219987, "httpStatusCode": 200}', DEFAULT, '00e2978d-7995-4a9a-b97d-8a610c3c9027', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('511562a3-e707-4bb7-ba46-07055b877f0f', 'product-images', '0.13973970928943058.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:35:16.464376+00', '2026-03-17 00:35:16.464376+00', '2026-03-17 00:35:16.464376+00', '{"eTag": "\"eb034dd177b618d2e0d5f3bcb1f4f939\"", "size": 215709, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:35:17.000Z", "contentLength": 215709, "httpStatusCode": 200}', DEFAULT, '0c9bb628-d89a-4767-a74f-6c8d4d7ee88a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('b193aaa2-6d65-491b-9423-4d4fb11d4302', 'product-images', '0.5062358174491908.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:35:16.482843+00', '2026-03-17 00:35:16.482843+00', '2026-03-17 00:35:16.482843+00', '{"eTag": "\"fb1cd75280e61a0a94afa08449713336\"", "size": 212337, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:35:17.000Z", "contentLength": 212337, "httpStatusCode": 200}', DEFAULT, '5005d9fc-e451-4675-8a8c-8e18ece2e30d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('a17a3923-f7c6-4f2e-955c-e142d9e7f6ce', 'product-images', '1773707730065-pnpimksxf6m.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:35:31.494829+00', '2026-03-17 00:35:31.494829+00', '2026-03-17 00:35:31.494829+00', '{"eTag": "\"fb1cd75280e61a0a94afa08449713336\"", "size": 212337, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:35:32.000Z", "contentLength": 212337, "httpStatusCode": 200}', DEFAULT, 'd58fbd08-eb5c-45b3-9e28-65345be1dadc', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('17074421-966b-4852-9176-cd3bedc85203', 'product-images', '0.8611290543605202.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:35.986437+00', '2026-03-19 18:10:35.986437+00', '2026-03-19 18:10:35.986437+00', '{"eTag": "\"b291c0e82ca8b8689471cc0797feaaad\"", "size": 23948, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:36.000Z", "contentLength": 23948, "httpStatusCode": 200}', DEFAULT, '8589c90a-c72c-4561-afb0-2609aeb9a2e4', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('d0401b6f-8c56-40e8-a609-2432180a3692', 'product-images', '1773852067659-7ribewm8hnx.png', NULL, '2026-03-18 16:41:08.315507+00', '2026-03-18 16:41:08.315507+00', '2026-03-18 16:41:08.315507+00', '{"eTag": "\"2b6a84968cc02ffc5b2c6b844d63ab11\"", "size": 65327, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:41:09.000Z", "contentLength": 65327, "httpStatusCode": 200}', DEFAULT, 'e038709f-86a1-4d76-b4aa-45a99d44f644', NULL, '{}');
INSERT INTO storage.objects VALUES ('7aed5df9-e723-4aa0-8b8d-75fc08a235ce', 'product-images', '0.4159400595994377.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:36.161269+00', '2026-03-19 18:10:36.161269+00', '2026-03-19 18:10:36.161269+00', '{"eTag": "\"eb5a88ae8a2e739fed3c00aee266486d\"", "size": 43417, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:37.000Z", "contentLength": 43417, "httpStatusCode": 200}', DEFAULT, 'cfbd8b1b-2d47-4698-a7aa-7e8ef95200ed', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9ca825b0-2c27-4fa8-ba98-096e04dcc23b', 'product-images', '1773852117370-nd02qhx28c.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:41:58.750728+00', '2026-03-18 16:41:58.750728+00', '2026-03-18 16:41:58.750728+00', '{"eTag": "\"349726932f02b3104c951e4b0282d717\"", "size": 105087, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:41:59.000Z", "contentLength": 105087, "httpStatusCode": 200}', DEFAULT, 'cda5305b-e92b-4099-9669-b18fff28028c', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('556c8ca6-2219-464b-9c4d-f0f1d8efd75f', 'product-images', '0.46786668834564993.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:36.178515+00', '2026-03-19 18:10:36.178515+00', '2026-03-19 18:10:36.178515+00', '{"eTag": "\"76243d271bc99aebbddc16073b3a6f20\"", "size": 55494, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:37.000Z", "contentLength": 55494, "httpStatusCode": 200}', DEFAULT, 'f600515d-132c-4ff8-82c7-af2bd2ca5926', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('2bcc3ce8-3b82-4d7c-8fd2-f7992906dcc9', 'product-images', '1773852138617-yp4yci7a2mi.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:42:19.772485+00', '2026-03-18 16:42:19.772485+00', '2026-03-18 16:42:19.772485+00', '{"eTag": "\"60c4a614efcde736fb7afec82193d723\"", "size": 93023, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:42:20.000Z", "contentLength": 93023, "httpStatusCode": 200}', DEFAULT, '48d884c1-9eca-4ebc-af6d-988cea3f93c7', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('a9fb27e0-c052-4c59-aa3d-87ec686db3cb', 'product-images', '0.4106207902082657.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:43:41.970592+00', '2026-03-18 16:43:41.970592+00', '2026-03-18 16:43:41.970592+00', '{"eTag": "\"9cade3534bf50c2231627082f73625da\"", "size": 48628, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:43:42.000Z", "contentLength": 48628, "httpStatusCode": 200}', DEFAULT, '2c5e3d06-ad6f-4bd0-b4b5-1b7c17d8f455', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('9fed8eff-b137-4ca4-822e-f43ad60fd48a', 'product-images', '0.8892032847863243.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:43:42.013688+00', '2026-03-18 16:43:42.013688+00', '2026-03-18 16:43:42.013688+00', '{"eTag": "\"a27cf7cdd68d9d8e7ab23732c2ac9a5b\"", "size": 76382, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:43:42.000Z", "contentLength": 76382, "httpStatusCode": 200}', DEFAULT, 'a83903b6-4520-4650-b07e-14ca32186206', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('537cb40a-6b27-45ae-a464-1c186dffffb6', 'product-images', '0.2953870401263423.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:43:42.007483+00', '2026-03-18 16:43:42.007483+00', '2026-03-18 16:43:42.007483+00', '{"eTag": "\"6e6562ad9b1aebfbc56bd37e4350d35f\"", "size": 87541, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:43:42.000Z", "contentLength": 87541, "httpStatusCode": 200}', DEFAULT, '8e9be759-044c-43fb-b4db-7e6797e50e92', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('ac3c597e-1dd1-4da2-8461-ac1eb466df96', 'product-images', '0.5847370238422237.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:43:42.028689+00', '2026-03-18 16:43:42.028689+00', '2026-03-18 16:43:42.028689+00', '{"eTag": "\"06450feade2ef27c6d641079cb250c92\"", "size": 38538, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:43:42.000Z", "contentLength": 38538, "httpStatusCode": 200}', DEFAULT, '33690e12-d56b-4a0c-9499-ca8fc8485bf2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('48f70159-32ff-4f24-a542-7e64a571c3be', 'product-images', '0.2032296427539163.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:43:42.05519+00', '2026-03-18 16:43:42.05519+00', '2026-03-18 16:43:42.05519+00', '{"eTag": "\"fc7e28c961fe4c0797d9717522a2ed71\"", "size": 45885, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:43:42.000Z", "contentLength": 45885, "httpStatusCode": 200}', DEFAULT, '328d982c-a11b-4fed-8e55-ec172477c3be', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('6c538f47-bdcb-4838-ab0c-91df8949856d', 'product-images', '0.22555699099576032.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:43:42.072552+00', '2026-03-18 16:43:42.072552+00', '2026-03-18 16:43:42.072552+00', '{"eTag": "\"349726932f02b3104c951e4b0282d717\"", "size": 105087, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:43:43.000Z", "contentLength": 105087, "httpStatusCode": 200}', DEFAULT, '05b9d1dd-13c8-48bf-9b29-4531a9a9c797', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('732e5e11-d769-4f4f-ac16-976a4d24aa4c', 'product-images', '0.7637906531408734.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-18 16:43:42.09111+00', '2026-03-18 16:43:42.09111+00', '2026-03-18 16:43:42.09111+00', '{"eTag": "\"ea1350167e9be9c80cf3f74ae0074c99\"", "size": 99156, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T16:43:42.000Z", "contentLength": 99156, "httpStatusCode": 200}', DEFAULT, 'c4c445d4-9c80-49ee-a2b3-31c03d6797ab', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('88d80649-3d13-4748-b2ee-72d40ed131a7', 'product-images', '1773870907373-st8x0lg4sl.png', NULL, '2026-03-18 21:55:08.237596+00', '2026-03-18 21:55:08.237596+00', '2026-03-18 21:55:08.237596+00', '{"eTag": "\"2b6a84968cc02ffc5b2c6b844d63ab11\"", "size": 65327, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T21:55:09.000Z", "contentLength": 65327, "httpStatusCode": 200}', DEFAULT, 'd46d7273-8acd-41eb-9fc5-c2e8a7f8a758', NULL, '{}');
INSERT INTO storage.objects VALUES ('2a873393-8a23-4d60-8e51-0679184d8aae', 'product-images', '0.33993467783714126.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-18 21:56:03.447415+00', '2026-03-18 21:56:03.447415+00', '2026-03-18 21:56:03.447415+00', '{"eTag": "\"cd9bffa66c3110fa0a19fc7ffed11b35\"", "size": 9765, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T21:56:04.000Z", "contentLength": 9765, "httpStatusCode": 200}', DEFAULT, '41e8c80b-b211-45b3-8607-955f840e26a2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('22fe5bdb-e621-4580-a5ff-7603df4e0cb8', 'product-images', '1773944268908-wv8jgxq0ajo.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:18:25.278891+00', '2026-03-19 18:18:25.278891+00', '2026-03-19 18:18:25.278891+00', '{"eTag": "\"bd8aec652a95b460271a6d989354b84b\"", "size": 44811, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:18:26.000Z", "contentLength": 44811, "httpStatusCode": 200}', DEFAULT, '75f837f8-6e2b-4f0c-916f-f234064c66f8', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('b70f6cb0-1e44-4740-9db7-46ca60985e9f', 'product-images', '0.9564488174404464.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-18 21:56:10.420086+00', '2026-03-18 21:56:10.420086+00', '2026-03-18 21:56:10.420086+00', '{"eTag": "\"e0c65da093e5d7da66da7c598d16c64b\"", "size": 19017, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T21:56:11.000Z", "contentLength": 19017, "httpStatusCode": 200}', DEFAULT, 'f1feee82-49db-4579-8475-38ad4f7f68f3', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('ff403250-fe81-4ba7-aed9-23ec9ce7d031', 'product-images', '0.6172358085738827.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-18 21:56:10.826715+00', '2026-03-18 21:56:10.826715+00', '2026-03-18 21:56:10.826715+00', '{"eTag": "\"3da72e50c4b6f8091b959a531b925ce6\"", "size": 22481, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T21:56:11.000Z", "contentLength": 22481, "httpStatusCode": 200}', DEFAULT, '067d479d-5de3-400d-81c7-8f8aa7ce959d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('637ab178-e049-47cb-b502-a7f42a09587c', 'product-images', '1773871091852-j3bc1wjoy2.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-18 21:58:13.278578+00', '2026-03-18 21:58:13.278578+00', '2026-03-18 21:58:13.278578+00', '{"eTag": "\"cd9bffa66c3110fa0a19fc7ffed11b35\"", "size": 9765, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T21:58:14.000Z", "contentLength": 9765, "httpStatusCode": 200}', DEFAULT, 'c8ed5255-b56b-4089-a489-180bb15d8d30', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('8020f021-dafd-4a04-9177-bf27857268fb', 'product-images', '1773940158275-g1jaouktroq.png', NULL, '2026-03-19 17:09:19.0225+00', '2026-03-19 17:09:19.0225+00', '2026-03-19 17:09:19.0225+00', '{"eTag": "\"2b6a84968cc02ffc5b2c6b844d63ab11\"", "size": 65327, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:09:19.000Z", "contentLength": 65327, "httpStatusCode": 200}', DEFAULT, '3453b559-c552-423d-bb07-f1f31dd51475', NULL, '{}');
INSERT INTO storage.objects VALUES ('f3a459fc-1b82-4c38-ab1d-7eabf6891a19', 'product-images', '1773940742930-umfdm90qvzg.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:19:38.895802+00', '2026-03-19 17:19:38.895802+00', '2026-03-19 17:19:38.895802+00', '{"eTag": "\"f34ad374dc2afcc86c9846955fc1ba15\"", "size": 192287, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:19:39.000Z", "contentLength": 192287, "httpStatusCode": 200}', DEFAULT, 'c0a79f59-a5ca-4cc3-9326-1aaebfde8aab', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('16c36244-3cda-4b76-9155-35bdd6a568df', 'product-images', '0.9522582495040556.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:19:53.391124+00', '2026-03-19 17:19:53.391124+00', '2026-03-19 17:19:53.391124+00', '{"eTag": "\"c81eada9017793ddb1dc6348bdd2f0be\"", "size": 107941, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:19:54.000Z", "contentLength": 107941, "httpStatusCode": 200}', DEFAULT, 'e02ed8e7-2ea4-48a4-b59a-87eb0a99404f', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('f321c939-c632-4e96-963b-a03e373c72a3', 'product-images', '0.9272181640919159.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:19:53.49671+00', '2026-03-19 17:19:53.49671+00', '2026-03-19 17:19:53.49671+00', '{"eTag": "\"191d64027241b5ee290241d444774a24\"", "size": 135714, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:19:54.000Z", "contentLength": 135714, "httpStatusCode": 200}', DEFAULT, '10c6fb2b-ad03-4c45-8d37-746f831785c8', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('a932791f-183c-4997-ab6b-89fdc7059064', 'product-images', '0.17836842891537785.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:19:53.664773+00', '2026-03-19 17:19:53.664773+00', '2026-03-19 17:19:53.664773+00', '{"eTag": "\"6f25d7d8035db9c96700d08f5efdab57\"", "size": 248235, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:19:54.000Z", "contentLength": 248235, "httpStatusCode": 200}', DEFAULT, '80342e44-bf3f-4d8c-a608-f219eb4bee59', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');


--
-- TOC entry 4648 (class 0 OID 17226)
-- Dependencies: 362
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 4649 (class 0 OID 17240)
-- Dependencies: 363
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 4652 (class 0 OID 17309)
-- Dependencies: 366
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 3780 (class 0 OID 16608)
-- Dependencies: 336
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 331
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 95, true);


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 357
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- TOC entry 4070 (class 2606 OID 16783)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4039 (class 2606 OID 16531)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4125 (class 2606 OID 17115)
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- TOC entry 4127 (class 2606 OID 17113)
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4093 (class 2606 OID 16889)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4048 (class 2606 OID 16907)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4050 (class 2606 OID 16917)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4037 (class 2606 OID 16524)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4072 (class 2606 OID 16776)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4068 (class 2606 OID 16764)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4060 (class 2606 OID 16957)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4062 (class 2606 OID 16751)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4106 (class 2606 OID 17016)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4108 (class 2606 OID 17014)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4110 (class 2606 OID 17012)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4120 (class 2606 OID 17074)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4103 (class 2606 OID 16976)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4114 (class 2606 OID 17038)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4116 (class 2606 OID 17040)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4097 (class 2606 OID 16942)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4031 (class 2606 OID 16514)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4034 (class 2606 OID 16694)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4082 (class 2606 OID 16823)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4084 (class 2606 OID 16821)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4089 (class 2606 OID 16837)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4042 (class 2606 OID 16537)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4055 (class 2606 OID 16715)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4079 (class 2606 OID 16804)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4074 (class 2606 OID 16795)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4024 (class 2606 OID 16877)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4026 (class 2606 OID 16501)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4259 (class 2606 OID 27153)
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4255 (class 2606 OID 27136)
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4177 (class 2606 OID 17556)
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- TOC entry 4183 (class 2606 OID 22139)
-- Name: brands brands_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_name_key UNIQUE (name);


--
-- TOC entry 4185 (class 2606 OID 22137)
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- TOC entry 4195 (class 2606 OID 22183)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 4197 (class 2606 OID 22181)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4199 (class 2606 OID 22185)
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- TOC entry 4239 (class 2606 OID 22464)
-- Name: coupon_votes coupon_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_pkey PRIMARY KEY (id);


--
-- TOC entry 4241 (class 2606 OID 22468)
-- Name: coupon_votes coupon_votes_session_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_session_unique UNIQUE (coupon_id, session_token);


--
-- TOC entry 4243 (class 2606 OID 22466)
-- Name: coupon_votes coupon_votes_user_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_user_unique UNIQUE (coupon_id, user_id);


--
-- TOC entry 4235 (class 2606 OID 22450)
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- TOC entry 4231 (class 2606 OID 22435)
-- Name: institutional_pages institutional_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutional_pages
    ADD CONSTRAINT institutional_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 4233 (class 2606 OID 22437)
-- Name: institutional_pages institutional_pages_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutional_pages
    ADD CONSTRAINT institutional_pages_slug_key UNIQUE (slug);


--
-- TOC entry 4264 (class 2606 OID 27192)
-- Name: ml_product_mappings ml_product_mappings_ml_item_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_product_mappings
    ADD CONSTRAINT ml_product_mappings_ml_item_id_key UNIQUE (ml_item_id);


--
-- TOC entry 4266 (class 2606 OID 27190)
-- Name: ml_product_mappings ml_product_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_product_mappings
    ADD CONSTRAINT ml_product_mappings_pkey PRIMARY KEY (id);


--
-- TOC entry 4268 (class 2606 OID 27212)
-- Name: ml_sync_logs ml_sync_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_sync_logs
    ADD CONSTRAINT ml_sync_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4262 (class 2606 OID 27175)
-- Name: ml_tokens ml_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_tokens
    ADD CONSTRAINT ml_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4187 (class 2606 OID 22152)
-- Name: models models_brand_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_brand_id_name_key UNIQUE (brand_id, name);


--
-- TOC entry 4189 (class 2606 OID 22150)
-- Name: models models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_pkey PRIMARY KEY (id);


--
-- TOC entry 4227 (class 2606 OID 22385)
-- Name: newsletter_products newsletter_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletter_products
    ADD CONSTRAINT newsletter_products_pkey PRIMARY KEY (newsletter_id, product_id);


--
-- TOC entry 4225 (class 2606 OID 22380)
-- Name: newsletters newsletters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletters
    ADD CONSTRAINT newsletters_pkey PRIMARY KEY (id);


--
-- TOC entry 4191 (class 2606 OID 22170)
-- Name: platforms platforms_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platforms
    ADD CONSTRAINT platforms_name_key UNIQUE (name);


--
-- TOC entry 4193 (class 2606 OID 22168)
-- Name: platforms platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platforms
    ADD CONSTRAINT platforms_pkey PRIMARY KEY (id);


--
-- TOC entry 4229 (class 2606 OID 22416)
-- Name: price_history price_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4219 (class 2606 OID 22334)
-- Name: product_clicks product_clicks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_clicks
    ADD CONSTRAINT product_clicks_pkey PRIMARY KEY (id);


--
-- TOC entry 4215 (class 2606 OID 22260)
-- Name: product_likes product_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_likes
    ADD CONSTRAINT product_likes_pkey PRIMARY KEY (id);


--
-- TOC entry 4217 (class 2606 OID 22262)
-- Name: product_likes product_likes_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_likes
    ADD CONSTRAINT product_likes_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- TOC entry 4221 (class 2606 OID 22355)
-- Name: product_trust_votes product_trust_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_trust_votes
    ADD CONSTRAINT product_trust_votes_pkey PRIMARY KEY (id);


--
-- TOC entry 4223 (class 2606 OID 22357)
-- Name: product_trust_votes product_trust_votes_user_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_trust_votes
    ADD CONSTRAINT product_trust_votes_user_unique UNIQUE (product_id, user_id);


--
-- TOC entry 4174 (class 2606 OID 17544)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4165 (class 2606 OID 17513)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4167 (class 2606 OID 17515)
-- Name: profiles profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);


--
-- TOC entry 4181 (class 2606 OID 17582)
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4179 (class 2606 OID 17567)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 4272 (class 2606 OID 27223)
-- Name: search_cache search_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_cache
    ADD CONSTRAINT search_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4247 (class 2606 OID 25980)
-- Name: shopee_product_mappings shopee_product_mappings_item_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopee_product_mappings
    ADD CONSTRAINT shopee_product_mappings_item_unique UNIQUE (shopee_item_id);


--
-- TOC entry 4249 (class 2606 OID 25978)
-- Name: shopee_product_mappings shopee_product_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopee_product_mappings
    ADD CONSTRAINT shopee_product_mappings_pkey PRIMARY KEY (id);


--
-- TOC entry 4252 (class 2606 OID 25998)
-- Name: shopee_sync_logs shopee_sync_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopee_sync_logs
    ADD CONSTRAINT shopee_sync_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4205 (class 2606 OID 22207)
-- Name: special_page_products special_page_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_page_products
    ADD CONSTRAINT special_page_products_pkey PRIMARY KEY (id);


--
-- TOC entry 4207 (class 2606 OID 22209)
-- Name: special_page_products special_page_products_special_page_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_page_products
    ADD CONSTRAINT special_page_products_special_page_id_product_id_key UNIQUE (special_page_id, product_id);


--
-- TOC entry 4201 (class 2606 OID 22197)
-- Name: special_pages special_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_pages
    ADD CONSTRAINT special_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 4203 (class 2606 OID 22199)
-- Name: special_pages special_pages_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_pages
    ADD CONSTRAINT special_pages_slug_key UNIQUE (slug);


--
-- TOC entry 4237 (class 2606 OID 23729)
-- Name: coupons uq_coupons_platform_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT uq_coupons_platform_code UNIQUE (platform_id, code);


--
-- TOC entry 4169 (class 2606 OID 17522)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4171 (class 2606 OID 17524)
-- Name: user_roles user_roles_user_id_role_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role);


--
-- TOC entry 4209 (class 2606 OID 22231)
-- Name: whatsapp_groups whatsapp_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whatsapp_groups
    ADD CONSTRAINT whatsapp_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4211 (class 2606 OID 22240)
-- Name: wishlists wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (id);


--
-- TOC entry 4213 (class 2606 OID 22242)
-- Name: wishlists wishlists_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- TOC entry 4163 (class 2606 OID 17489)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4133 (class 2606 OID 17151)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4130 (class 2606 OID 17124)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4154 (class 2606 OID 17332)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4141 (class 2606 OID 17175)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4157 (class 2606 OID 17308)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4136 (class 2606 OID 17166)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4138 (class 2606 OID 17164)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4147 (class 2606 OID 17187)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4152 (class 2606 OID 17249)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4150 (class 2606 OID 17234)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4160 (class 2606 OID 17318)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4040 (class 1259 OID 16532)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4014 (class 1259 OID 16704)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4121 (class 1259 OID 17119)
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- TOC entry 4122 (class 1259 OID 17118)
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- TOC entry 4123 (class 1259 OID 17116)
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- TOC entry 4128 (class 1259 OID 17117)
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- TOC entry 4015 (class 1259 OID 16706)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4016 (class 1259 OID 16707)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4058 (class 1259 OID 16785)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4091 (class 1259 OID 16893)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4046 (class 1259 OID 16873)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 4046
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4051 (class 1259 OID 16701)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4094 (class 1259 OID 16890)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4118 (class 1259 OID 17075)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4095 (class 1259 OID 16891)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4066 (class 1259 OID 16896)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4063 (class 1259 OID 16757)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4064 (class 1259 OID 16902)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4104 (class 1259 OID 17027)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4101 (class 1259 OID 16980)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4111 (class 1259 OID 17053)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4112 (class 1259 OID 17051)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4117 (class 1259 OID 17052)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4098 (class 1259 OID 16949)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4099 (class 1259 OID 16948)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4100 (class 1259 OID 16950)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4017 (class 1259 OID 16708)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4018 (class 1259 OID 16705)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4027 (class 1259 OID 16515)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4028 (class 1259 OID 16516)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4029 (class 1259 OID 16700)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4032 (class 1259 OID 16787)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4035 (class 1259 OID 16892)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4085 (class 1259 OID 16829)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4086 (class 1259 OID 16894)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4087 (class 1259 OID 16844)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4090 (class 1259 OID 16843)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4052 (class 1259 OID 16895)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4053 (class 1259 OID 17065)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4056 (class 1259 OID 16786)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4077 (class 1259 OID 16811)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4080 (class 1259 OID 16810)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4075 (class 1259 OID 16796)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4076 (class 1259 OID 16958)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4065 (class 1259 OID 16955)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4057 (class 1259 OID 16784)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4019 (class 1259 OID 16864)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 4893 (class 0 OID 0)
-- Dependencies: 4019
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4020 (class 1259 OID 16702)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4021 (class 1259 OID 16505)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4022 (class 1259 OID 16919)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4257 (class 1259 OID 27160)
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- TOC entry 4260 (class 1259 OID 27159)
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- TOC entry 4253 (class 1259 OID 27142)
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- TOC entry 4256 (class 1259 OID 27143)
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- TOC entry 4172 (class 1259 OID 25964)
-- Name: idx_products_external_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_external_id ON public.products USING btree (external_id);


--
-- TOC entry 4269 (class 1259 OID 27225)
-- Name: idx_search_cache_exp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_search_cache_exp ON public.search_cache USING btree (expires_at);


--
-- TOC entry 4270 (class 1259 OID 27224)
-- Name: idx_search_cache_kw; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_search_cache_kw ON public.search_cache USING btree (keyword, offset_val);


--
-- TOC entry 4244 (class 1259 OID 26003)
-- Name: idx_shopee_mappings_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shopee_mappings_item_id ON public.shopee_product_mappings USING btree (shopee_item_id);


--
-- TOC entry 4245 (class 1259 OID 26004)
-- Name: idx_shopee_mappings_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shopee_mappings_product_id ON public.shopee_product_mappings USING btree (product_id);


--
-- TOC entry 4250 (class 1259 OID 26005)
-- Name: idx_shopee_sync_logs_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shopee_sync_logs_created ON public.shopee_sync_logs USING btree (created_at DESC);


--
-- TOC entry 4175 (class 1259 OID 25967)
-- Name: uq_products_external_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_products_external_id ON public.products USING btree (external_id) WHERE (external_id IS NOT NULL);


--
-- TOC entry 4131 (class 1259 OID 17490)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4161 (class 1259 OID 17491)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4134 (class 1259 OID 17494)
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- TOC entry 4139 (class 1259 OID 17176)
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4142 (class 1259 OID 17193)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4155 (class 1259 OID 17333)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4148 (class 1259 OID 17260)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4143 (class 1259 OID 17225)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4144 (class 1259 OID 17340)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4145 (class 1259 OID 17194)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4158 (class 1259 OID 17324)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4323 (class 2620 OID 17602)
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- TOC entry 4330 (class 2620 OID 22298)
-- Name: products trg_calc_discount; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_calc_discount BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.calc_discount_percentage();


--
-- TOC entry 4335 (class 2620 OID 23733)
-- Name: coupons trg_coupons_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_coupons_updated_at BEFORE UPDATE ON public.coupons FOR EACH ROW EXECUTE FUNCTION public.update_coupons_updated_at();


--
-- TOC entry 4334 (class 2620 OID 22532)
-- Name: product_clicks trg_increment_product_clicks; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_increment_product_clicks AFTER INSERT ON public.product_clicks FOR EACH ROW EXECUTE FUNCTION public.increment_product_clicks();


--
-- TOC entry 4331 (class 2620 OID 22531)
-- Name: products trg_log_price_change; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_price_change AFTER INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.log_price_change();


--
-- TOC entry 4333 (class 2620 OID 17600)
-- Name: banners update_banners_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_banners_updated_at BEFORE UPDATE ON public.banners FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4332 (class 2620 OID 17599)
-- Name: products update_products_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4329 (class 2620 OID 17601)
-- Name: profiles update_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4324 (class 2620 OID 17156)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4325 (class 2620 OID 17279)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4326 (class 2620 OID 17342)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4327 (class 2620 OID 17343)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4328 (class 2620 OID 17213)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4274 (class 2606 OID 16688)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4279 (class 2606 OID 16777)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4278 (class 2606 OID 16765)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4277 (class 2606 OID 16752)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4285 (class 2606 OID 17017)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4286 (class 2606 OID 17022)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4287 (class 2606 OID 17046)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4288 (class 2606 OID 17041)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4284 (class 2606 OID 16943)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4273 (class 2606 OID 16721)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4281 (class 2606 OID 16824)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4282 (class 2606 OID 16897)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4283 (class 2606 OID 16838)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4275 (class 2606 OID 17060)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4276 (class 2606 OID 16716)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4280 (class 2606 OID 16805)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4321 (class 2606 OID 27154)
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4320 (class 2606 OID 27137)
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4317 (class 2606 OID 22469)
-- Name: coupon_votes coupon_votes_coupon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id) ON DELETE CASCADE;


--
-- TOC entry 4318 (class 2606 OID 22474)
-- Name: coupon_votes coupon_votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4316 (class 2606 OID 22451)
-- Name: coupons coupons_platform_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_platform_id_fkey FOREIGN KEY (platform_id) REFERENCES public.platforms(id) ON DELETE CASCADE;


--
-- TOC entry 4322 (class 2606 OID 27193)
-- Name: ml_product_mappings ml_product_mappings_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_product_mappings
    ADD CONSTRAINT ml_product_mappings_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4302 (class 2606 OID 22153)
-- Name: models models_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE;


--
-- TOC entry 4313 (class 2606 OID 22386)
-- Name: newsletter_products newsletter_products_newsletter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletter_products
    ADD CONSTRAINT newsletter_products_newsletter_id_fkey FOREIGN KEY (newsletter_id) REFERENCES public.newsletters(id) ON DELETE CASCADE;


--
-- TOC entry 4314 (class 2606 OID 22391)
-- Name: newsletter_products newsletter_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletter_products
    ADD CONSTRAINT newsletter_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4315 (class 2606 OID 22417)
-- Name: price_history price_history_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4309 (class 2606 OID 22339)
-- Name: product_clicks product_clicks_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_clicks
    ADD CONSTRAINT product_clicks_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4310 (class 2606 OID 22553)
-- Name: product_clicks product_clicks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_clicks
    ADD CONSTRAINT product_clicks_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4307 (class 2606 OID 22268)
-- Name: product_likes product_likes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_likes
    ADD CONSTRAINT product_likes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4308 (class 2606 OID 22263)
-- Name: product_likes product_likes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_likes
    ADD CONSTRAINT product_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4311 (class 2606 OID 22360)
-- Name: product_trust_votes product_trust_votes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_trust_votes
    ADD CONSTRAINT product_trust_votes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4312 (class 2606 OID 22548)
-- Name: product_trust_votes product_trust_votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_trust_votes
    ADD CONSTRAINT product_trust_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4295 (class 2606 OID 22277)
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE SET NULL;


--
-- TOC entry 4296 (class 2606 OID 22320)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 4297 (class 2606 OID 22282)
-- Name: products products_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.models(id) ON DELETE SET NULL;


--
-- TOC entry 4298 (class 2606 OID 22287)
-- Name: products products_platform_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_platform_id_fkey FOREIGN KEY (platform_id) REFERENCES public.platforms(id) ON DELETE SET NULL;


--
-- TOC entry 4299 (class 2606 OID 22292)
-- Name: products products_registered_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_registered_by_fkey FOREIGN KEY (registered_by) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4301 (class 2606 OID 17583)
-- Name: reports reports_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 4300 (class 2606 OID 17568)
-- Name: reviews reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 4319 (class 2606 OID 25981)
-- Name: shopee_product_mappings shopee_product_mappings_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopee_product_mappings
    ADD CONSTRAINT shopee_product_mappings_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4303 (class 2606 OID 22215)
-- Name: special_page_products special_page_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_page_products
    ADD CONSTRAINT special_page_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4304 (class 2606 OID 22210)
-- Name: special_page_products special_page_products_special_page_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_page_products
    ADD CONSTRAINT special_page_products_special_page_id_fkey FOREIGN KEY (special_page_id) REFERENCES public.special_pages(id) ON DELETE CASCADE;


--
-- TOC entry 4294 (class 2606 OID 17525)
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4305 (class 2606 OID 22248)
-- Name: wishlists wishlists_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4306 (class 2606 OID 22243)
-- Name: wishlists wishlists_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4289 (class 2606 OID 17188)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4290 (class 2606 OID 17235)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4291 (class 2606 OID 17255)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4292 (class 2606 OID 17250)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4293 (class 2606 OID 17319)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4488 (class 0 OID 16525)
-- Dependencies: 334
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4499 (class 0 OID 16883)
-- Dependencies: 348
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4490 (class 0 OID 16681)
-- Dependencies: 339
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4487 (class 0 OID 16518)
-- Dependencies: 333
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4494 (class 0 OID 16770)
-- Dependencies: 343
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4493 (class 0 OID 16758)
-- Dependencies: 342
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4492 (class 0 OID 16745)
-- Dependencies: 341
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4500 (class 0 OID 16933)
-- Dependencies: 349
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4486 (class 0 OID 16507)
-- Dependencies: 332
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4497 (class 0 OID 16812)
-- Dependencies: 346
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4498 (class 0 OID 16830)
-- Dependencies: 347
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4489 (class 0 OID 16533)
-- Dependencies: 335
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4491 (class 0 OID 16711)
-- Dependencies: 340
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4496 (class 0 OID 16797)
-- Dependencies: 345
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4495 (class 0 OID 16788)
-- Dependencies: 344
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4485 (class 0 OID 16495)
-- Dependencies: 330
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4559 (class 3256 OID 17621)
-- Name: banners Admin can delete banners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can delete banners" ON public.banners FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4552 (class 3256 OID 17617)
-- Name: products Admin can delete products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can delete products" ON public.products FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4618 (class 3256 OID 27213)
-- Name: ml_sync_logs Admin can manage ml sync logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage ml sync logs" ON public.ml_sync_logs TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4615 (class 3256 OID 27176)
-- Name: ml_tokens Admin can manage ml_tokens; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage ml_tokens" ON public.ml_tokens TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4583 (class 3256 OID 22221)
-- Name: special_page_products Admin can manage special page products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage special page products" ON public.special_page_products TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4581 (class 3256 OID 22201)
-- Name: special_pages Admin can manage special pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage special pages" ON public.special_pages TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4614 (class 3256 OID 26002)
-- Name: shopee_sync_logs Admin can manage sync logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage sync logs" ON public.shopee_sync_logs TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4585 (class 3256 OID 22233)
-- Name: whatsapp_groups Admin can manage whatsapp groups; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage whatsapp groups" ON public.whatsapp_groups TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4565 (class 3256 OID 17627)
-- Name: reports Admin can update reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can update reports" ON public.reports FOR UPDATE USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4613 (class 3256 OID 26001)
-- Name: shopee_sync_logs Admin can view sync logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can view sync logs" ON public.shopee_sync_logs FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4563 (class 3256 OID 17625)
-- Name: reviews Admin/Editor can delete reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can delete reviews" ON public.reviews FOR DELETE USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4554 (class 3256 OID 17619)
-- Name: banners Admin/Editor can insert banners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can insert banners" ON public.banners FOR INSERT TO authenticated WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4550 (class 3256 OID 17615)
-- Name: products Admin/Editor can insert products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can insert products" ON public.products FOR INSERT TO authenticated WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4574 (class 3256 OID 22141)
-- Name: brands Admin/Editor can manage brands; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can manage brands" ON public.brands TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4579 (class 3256 OID 22187)
-- Name: categories Admin/Editor can manage categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can manage categories" ON public.categories TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4576 (class 3256 OID 22159)
-- Name: models Admin/Editor can manage models; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can manage models" ON public.models TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4577 (class 3256 OID 22172)
-- Name: platforms Admin/Editor can manage platforms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can manage platforms" ON public.platforms TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4558 (class 3256 OID 17620)
-- Name: banners Admin/Editor can update banners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can update banners" ON public.banners FOR UPDATE TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4551 (class 3256 OID 17616)
-- Name: products Admin/Editor can update products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can update products" ON public.products FOR UPDATE TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4562 (class 3256 OID 17624)
-- Name: reviews Admin/Editor can update reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can update reviews" ON public.reviews FOR UPDATE USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4564 (class 3256 OID 17626)
-- Name: reports Admin/Editor can view reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can view reports" ON public.reports FOR SELECT USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4616 (class 3256 OID 27198)
-- Name: ml_product_mappings Admin_Editor can manage ml mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin_Editor can manage ml mappings" ON public.ml_product_mappings TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4612 (class 3256 OID 26000)
-- Name: shopee_product_mappings Admin_Editor can manage shopee mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin_Editor can manage shopee mappings" ON public.shopee_product_mappings TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4605 (class 3256 OID 22537)
-- Name: coupons Admins can manage coupons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage coupons" ON public.coupons TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4603 (class 3256 OID 22535)
-- Name: institutional_pages Admins can manage institutional pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage institutional pages" ON public.institutional_pages TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4593 (class 3256 OID 22401)
-- Name: newsletter_products Admins can manage newsletter products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage newsletter products" ON public.newsletter_products TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4592 (class 3256 OID 22400)
-- Name: newsletters Admins can manage newsletters; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage newsletters" ON public.newsletters TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4600 (class 3256 OID 22530)
-- Name: price_history Admins can manage price history; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage price history" ON public.price_history TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4545 (class 3256 OID 17610)
-- Name: user_roles Admins can manage roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage roles" ON public.user_roles USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4548 (class 3256 OID 17613)
-- Name: user_roles Admins can manage user roles (Delete); Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage user roles (Delete)" ON public.user_roles FOR DELETE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4546 (class 3256 OID 17611)
-- Name: user_roles Admins can manage user roles (Insert); Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage user roles (Insert)" ON public.user_roles FOR INSERT WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4547 (class 3256 OID 17612)
-- Name: user_roles Admins can manage user roles (Update); Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage user roles (Update)" ON public.user_roles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4543 (class 3256 OID 17608)
-- Name: profiles Admins can update any profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can update any profile" ON public.profiles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4542 (class 3256 OID 17607)
-- Name: profiles Admins can update profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can update profiles" ON public.profiles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4609 (class 3256 OID 22563)
-- Name: coupons Admins can view all coupons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view all coupons" ON public.coupons FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4602 (class 3256 OID 22534)
-- Name: institutional_pages Admins can view all institutional pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view all institutional pages" ON public.institutional_pages FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4539 (class 3256 OID 17604)
-- Name: profiles Admins can view all profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view all profiles" ON public.profiles FOR SELECT USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4588 (class 3256 OID 22274)
-- Name: product_likes Anyone can count likes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can count likes" ON public.product_likes FOR SELECT USING (true);


--
-- TOC entry 4555 (class 3256 OID 17628)
-- Name: reports Anyone can create reports with email; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can create reports with email" ON public.reports FOR INSERT WITH CHECK (((reporter_email IS NOT NULL) AND (reporter_email <> ''::text)));


--
-- TOC entry 4606 (class 3256 OID 22538)
-- Name: coupon_votes Anyone can insert coupon votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can insert coupon votes" ON public.coupon_votes FOR INSERT WITH CHECK (true);


--
-- TOC entry 4594 (class 3256 OID 22525)
-- Name: product_clicks Anyone can insert product clicks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can insert product clicks" ON public.product_clicks FOR INSERT WITH CHECK (true);


--
-- TOC entry 4596 (class 3256 OID 22527)
-- Name: product_trust_votes Anyone can insert trust votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can insert trust votes" ON public.product_trust_votes FOR INSERT WITH CHECK (true);


--
-- TOC entry 4610 (class 3256 OID 22564)
-- Name: coupons Anyone can update coupon reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can update coupon reports" ON public.coupons FOR UPDATE USING (true) WITH CHECK (true);


--
-- TOC entry 4553 (class 3256 OID 17618)
-- Name: banners Anyone can view active banners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active banners" ON public.banners FOR SELECT USING (((is_active = true) OR public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4604 (class 3256 OID 22536)
-- Name: coupons Anyone can view active coupons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active coupons" ON public.coupons FOR SELECT USING ((active = true));


--
-- TOC entry 4601 (class 3256 OID 22533)
-- Name: institutional_pages Anyone can view active institutional pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active institutional pages" ON public.institutional_pages FOR SELECT USING ((active = true));


--
-- TOC entry 4549 (class 3256 OID 17614)
-- Name: products Anyone can view active products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active products" ON public.products FOR SELECT USING (((is_active = true) OR public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4580 (class 3256 OID 22200)
-- Name: special_pages Anyone can view active special pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active special pages" ON public.special_pages FOR SELECT USING (((active = true) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- TOC entry 4584 (class 3256 OID 22232)
-- Name: whatsapp_groups Anyone can view active whatsapp groups; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active whatsapp groups" ON public.whatsapp_groups FOR SELECT USING (((active = true) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- TOC entry 4573 (class 3256 OID 22140)
-- Name: brands Anyone can view brands; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view brands" ON public.brands FOR SELECT USING (true);


--
-- TOC entry 4578 (class 3256 OID 22186)
-- Name: categories Anyone can view categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view categories" ON public.categories FOR SELECT USING (true);


--
-- TOC entry 4607 (class 3256 OID 22539)
-- Name: coupon_votes Anyone can view coupon votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view coupon votes" ON public.coupon_votes FOR SELECT USING (true);


--
-- TOC entry 4617 (class 3256 OID 27199)
-- Name: ml_product_mappings Anyone can view ml mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view ml mappings" ON public.ml_product_mappings FOR SELECT USING (true);


--
-- TOC entry 4575 (class 3256 OID 22158)
-- Name: models Anyone can view models; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view models" ON public.models FOR SELECT USING (true);


--
-- TOC entry 4566 (class 3256 OID 22171)
-- Name: platforms Anyone can view platforms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view platforms" ON public.platforms FOR SELECT USING (true);


--
-- TOC entry 4598 (class 3256 OID 22529)
-- Name: price_history Anyone can view price history; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view price history" ON public.price_history FOR SELECT USING (true);


--
-- TOC entry 4595 (class 3256 OID 22526)
-- Name: product_clicks Anyone can view product clicks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view product clicks" ON public.product_clicks FOR SELECT USING (true);


--
-- TOC entry 4560 (class 3256 OID 17622)
-- Name: reviews Anyone can view reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view reviews" ON public.reviews FOR SELECT USING (true);


--
-- TOC entry 4611 (class 3256 OID 25999)
-- Name: shopee_product_mappings Anyone can view shopee mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view shopee mappings" ON public.shopee_product_mappings FOR SELECT USING (true);


--
-- TOC entry 4582 (class 3256 OID 22220)
-- Name: special_page_products Anyone can view special page products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view special page products" ON public.special_page_products FOR SELECT USING (true);


--
-- TOC entry 4597 (class 3256 OID 22528)
-- Name: product_trust_votes Anyone can view trust votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view trust votes" ON public.product_trust_votes FOR SELECT USING (true);


--
-- TOC entry 4561 (class 3256 OID 17623)
-- Name: reviews Authenticated can insert reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated can insert reviews" ON public.reviews FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4599 (class 3256 OID 22547)
-- Name: product_trust_votes Users can delete own trust votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete own trust votes" ON public.product_trust_votes FOR DELETE USING ((auth.uid() = user_id));


--
-- TOC entry 4591 (class 3256 OID 22327)
-- Name: wishlists Users can delete their own wishlists; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own wishlists" ON public.wishlists FOR DELETE TO authenticated USING ((auth.uid() = user_id));


--
-- TOC entry 4540 (class 3256 OID 17605)
-- Name: profiles Users can insert own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4590 (class 3256 OID 22326)
-- Name: wishlists Users can insert their own wishlists; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own wishlists" ON public.wishlists FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4587 (class 3256 OID 22273)
-- Name: product_likes Users can manage own likes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can manage own likes" ON public.product_likes TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4586 (class 3256 OID 22253)
-- Name: wishlists Users can manage own wishlist; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can manage own wishlist" ON public.wishlists TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4541 (class 3256 OID 17606)
-- Name: profiles Users can update own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING ((auth.uid() = user_id));


--
-- TOC entry 4608 (class 3256 OID 22546)
-- Name: product_trust_votes Users can update own trust votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own trust votes" ON public.product_trust_votes FOR UPDATE USING ((auth.uid() = user_id));


--
-- TOC entry 4538 (class 3256 OID 17603)
-- Name: profiles Users can view own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4544 (class 3256 OID 17609)
-- Name: user_roles Users can view own role; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own role" ON public.user_roles FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4589 (class 3256 OID 22325)
-- Name: wishlists Users can view their own wishlists; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own wishlists" ON public.wishlists FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- TOC entry 4513 (class 0 OID 17545)
-- Dependencies: 373
-- Name: banners; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.banners ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4516 (class 0 OID 22129)
-- Dependencies: 377
-- Name: brands; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4519 (class 0 OID 22173)
-- Dependencies: 380
-- Name: categories; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4532 (class 0 OID 22458)
-- Dependencies: 393
-- Name: coupon_votes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.coupon_votes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4531 (class 0 OID 22441)
-- Dependencies: 392
-- Name: coupons; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4530 (class 0 OID 22426)
-- Dependencies: 391
-- Name: institutional_pages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.institutional_pages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4536 (class 0 OID 27177)
-- Dependencies: 399
-- Name: ml_product_mappings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.ml_product_mappings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4537 (class 0 OID 27200)
-- Dependencies: 400
-- Name: ml_sync_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.ml_sync_logs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4535 (class 0 OID 27166)
-- Dependencies: 398
-- Name: ml_tokens; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.ml_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4517 (class 0 OID 22142)
-- Dependencies: 378
-- Name: models; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.models ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4528 (class 0 OID 22381)
-- Dependencies: 389
-- Name: newsletter_products; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.newsletter_products ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4527 (class 0 OID 22370)
-- Dependencies: 388
-- Name: newsletters; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.newsletters ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4518 (class 0 OID 22160)
-- Dependencies: 379
-- Name: platforms; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.platforms ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4529 (class 0 OID 22408)
-- Dependencies: 390
-- Name: price_history; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.price_history ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4525 (class 0 OID 22328)
-- Dependencies: 386
-- Name: product_clicks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_clicks ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4524 (class 0 OID 22254)
-- Dependencies: 385
-- Name: product_likes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_likes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4526 (class 0 OID 22349)
-- Dependencies: 387
-- Name: product_trust_votes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_trust_votes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4512 (class 0 OID 17530)
-- Dependencies: 372
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4510 (class 0 OID 17503)
-- Dependencies: 370
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4515 (class 0 OID 17573)
-- Dependencies: 375
-- Name: reports; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4514 (class 0 OID 17557)
-- Dependencies: 374
-- Name: reviews; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4533 (class 0 OID 25968)
-- Dependencies: 394
-- Name: shopee_product_mappings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.shopee_product_mappings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4534 (class 0 OID 25986)
-- Dependencies: 395
-- Name: shopee_sync_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.shopee_sync_logs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4521 (class 0 OID 22202)
-- Dependencies: 382
-- Name: special_page_products; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.special_page_products ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4520 (class 0 OID 22188)
-- Dependencies: 381
-- Name: special_pages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.special_pages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4511 (class 0 OID 17516)
-- Dependencies: 371
-- Name: user_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4522 (class 0 OID 22222)
-- Dependencies: 383
-- Name: whatsapp_groups; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.whatsapp_groups ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4523 (class 0 OID 22234)
-- Dependencies: 384
-- Name: wishlists; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4509 (class 0 OID 17475)
-- Dependencies: 369
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4568 (class 3256 OID 17668)
-- Name: objects Auth Delete Banners; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Delete Banners" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'banners'::text));


--
-- TOC entry 4572 (class 3256 OID 17672)
-- Name: objects Auth Delete Products; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Delete Products" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4557 (class 3256 OID 17666)
-- Name: objects Auth Insert Banners; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Insert Banners" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'banners'::text));


--
-- TOC entry 4570 (class 3256 OID 17670)
-- Name: objects Auth Insert Products; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Insert Products" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'product-images'::text));


--
-- TOC entry 4567 (class 3256 OID 17667)
-- Name: objects Auth Update Banners; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Update Banners" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'banners'::text));


--
-- TOC entry 4571 (class 3256 OID 17671)
-- Name: objects Auth Update Products; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Update Products" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4556 (class 3256 OID 17665)
-- Name: objects Public Access Banners; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Public Access Banners" ON storage.objects FOR SELECT USING ((bucket_id = 'banners'::text));


--
-- TOC entry 4569 (class 3256 OID 17669)
-- Name: objects Public Access Products; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Public Access Products" ON storage.objects FOR SELECT USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4502 (class 0 OID 17167)
-- Dependencies: 360
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4506 (class 0 OID 17286)
-- Dependencies: 364
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4507 (class 0 OID 17299)
-- Dependencies: 365
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4501 (class 0 OID 17159)
-- Dependencies: 359
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4503 (class 0 OID 17177)
-- Dependencies: 361
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4504 (class 0 OID 17226)
-- Dependencies: 362
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4505 (class 0 OID 17240)
-- Dependencies: 363
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4508 (class 0 OID 17309)
-- Dependencies: 366
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4619 (class 6104 OID 16426)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 37
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 23
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 38
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 46
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO anon;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO authenticated;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO service_role;
RESET SESSION AUTHORIZATION;


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 32
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 466
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 485
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 465
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 464
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- TOC entry 4707 (class 0 OID 0)
-- Dependencies: 460
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 461
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 432
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 462
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 436
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 438
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4713 (class 0 OID 0)
-- Dependencies: 429
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- TOC entry 4714 (class 0 OID 0)
-- Dependencies: 428
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 435
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4716 (class 0 OID 0)
-- Dependencies: 437
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4717 (class 0 OID 0)
-- Dependencies: 439
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 440
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 433
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 434
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 467
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 471
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 468
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 431
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 430
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 416
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 415
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 417
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 463
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 459
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 453
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 455
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 457
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 454
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 458
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 449
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 451
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 450
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4743 (class 0 OID 0)
-- Dependencies: 452
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 445
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 447
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 446
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 441
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- TOC entry 4749 (class 0 OID 0)
-- Dependencies: 443
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 442
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 4751 (class 0 OID 0)
-- Dependencies: 444
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4752 (class 0 OID 0)
-- Dependencies: 469
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4753 (class 0 OID 0)
-- Dependencies: 470
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 472
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 423
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 424
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 425
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 426
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 427
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 418
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 419
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 421
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 420
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 422
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 484
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 402
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 414
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 516
-- Name: FUNCTION admin_delete_user(target_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_delete_user(target_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.admin_delete_user(target_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.admin_delete_user(target_user_id uuid) TO service_role;


--
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 518
-- Name: FUNCTION admin_update_user_email(target_user_id uuid, new_email text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text) TO anon;
GRANT ALL ON FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text) TO authenticated;
GRANT ALL ON FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text) TO service_role;


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 517
-- Name: FUNCTION admin_update_user_role(target_user_id uuid, new_role public.app_role); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_update_user_role(target_user_id uuid, new_role public.app_role) TO anon;
GRANT ALL ON FUNCTION public.admin_update_user_role(target_user_id uuid, new_role public.app_role) TO authenticated;
GRANT ALL ON FUNCTION public.admin_update_user_role(target_user_id uuid, new_role public.app_role) TO service_role;


--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 519
-- Name: FUNCTION calc_discount_percentage(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.calc_discount_percentage() TO anon;
GRANT ALL ON FUNCTION public.calc_discount_percentage() TO authenticated;
GRANT ALL ON FUNCTION public.calc_discount_percentage() TO service_role;


--
-- TOC entry 4773 (class 0 OID 0)
-- Dependencies: 514
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- TOC entry 4774 (class 0 OID 0)
-- Dependencies: 515
-- Name: FUNCTION has_role(_user_id uuid, _role public.app_role); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO anon;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO authenticated;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO service_role;


--
-- TOC entry 4775 (class 0 OID 0)
-- Dependencies: 521
-- Name: FUNCTION increment_product_clicks(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.increment_product_clicks() TO anon;
GRANT ALL ON FUNCTION public.increment_product_clicks() TO authenticated;
GRANT ALL ON FUNCTION public.increment_product_clicks() TO service_role;


--
-- TOC entry 4776 (class 0 OID 0)
-- Dependencies: 520
-- Name: FUNCTION log_price_change(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_price_change() TO anon;
GRANT ALL ON FUNCTION public.log_price_change() TO authenticated;
GRANT ALL ON FUNCTION public.log_price_change() TO service_role;


--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 522
-- Name: FUNCTION update_coupons_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_coupons_updated_at() TO anon;
GRANT ALL ON FUNCTION public.update_coupons_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.update_coupons_updated_at() TO service_role;


--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 513
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 506
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 512
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 508
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 504
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 488
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 507
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 509
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- TOC entry 4786 (class 0 OID 0)
-- Dependencies: 487
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 511
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 486
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- TOC entry 4789 (class 0 OID 0)
-- Dependencies: 505
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- TOC entry 4790 (class 0 OID 0)
-- Dependencies: 510
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- TOC entry 4791 (class 0 OID 0)
-- Dependencies: 474
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- TOC entry 4792 (class 0 OID 0)
-- Dependencies: 476
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 4793 (class 0 OID 0)
-- Dependencies: 477
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 4795 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- TOC entry 4796 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- TOC entry 4798 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- TOC entry 4801 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- TOC entry 4803 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- TOC entry 4807 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- TOC entry 4810 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- TOC entry 4811 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- TOC entry 4813 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- TOC entry 4814 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- TOC entry 4815 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- TOC entry 4816 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- TOC entry 4818 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- TOC entry 4820 (class 0 OID 0)
-- Dependencies: 331
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- TOC entry 4833 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 397
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 396
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 371
-- Name: TABLE user_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_roles TO anon;
GRANT ALL ON TABLE public.user_roles TO authenticated;
GRANT ALL ON TABLE public.user_roles TO service_role;


--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE admin_users_view; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.admin_users_view TO anon;
GRANT ALL ON TABLE public.admin_users_view TO authenticated;
GRANT ALL ON TABLE public.admin_users_view TO service_role;


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 373
-- Name: TABLE banners; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.banners TO anon;
GRANT ALL ON TABLE public.banners TO authenticated;
GRANT ALL ON TABLE public.banners TO service_role;


--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 377
-- Name: TABLE brands; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.brands TO anon;
GRANT ALL ON TABLE public.brands TO authenticated;
GRANT ALL ON TABLE public.brands TO service_role;


--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 380
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categories TO anon;
GRANT ALL ON TABLE public.categories TO authenticated;
GRANT ALL ON TABLE public.categories TO service_role;


--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 393
-- Name: TABLE coupon_votes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.coupon_votes TO anon;
GRANT ALL ON TABLE public.coupon_votes TO authenticated;
GRANT ALL ON TABLE public.coupon_votes TO service_role;


--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 392
-- Name: TABLE coupons; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.coupons TO anon;
GRANT ALL ON TABLE public.coupons TO authenticated;
GRANT ALL ON TABLE public.coupons TO service_role;


--
-- TOC entry 4852 (class 0 OID 0)
-- Dependencies: 391
-- Name: TABLE institutional_pages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.institutional_pages TO anon;
GRANT ALL ON TABLE public.institutional_pages TO authenticated;
GRANT ALL ON TABLE public.institutional_pages TO service_role;


--
-- TOC entry 4853 (class 0 OID 0)
-- Dependencies: 399
-- Name: TABLE ml_product_mappings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ml_product_mappings TO anon;
GRANT ALL ON TABLE public.ml_product_mappings TO authenticated;
GRANT ALL ON TABLE public.ml_product_mappings TO service_role;


--
-- TOC entry 4854 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE ml_sync_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ml_sync_logs TO anon;
GRANT ALL ON TABLE public.ml_sync_logs TO authenticated;
GRANT ALL ON TABLE public.ml_sync_logs TO service_role;


--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE ml_tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ml_tokens TO anon;
GRANT ALL ON TABLE public.ml_tokens TO authenticated;
GRANT ALL ON TABLE public.ml_tokens TO service_role;


--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 378
-- Name: TABLE models; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.models TO anon;
GRANT ALL ON TABLE public.models TO authenticated;
GRANT ALL ON TABLE public.models TO service_role;


--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 389
-- Name: TABLE newsletter_products; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.newsletter_products TO anon;
GRANT ALL ON TABLE public.newsletter_products TO authenticated;
GRANT ALL ON TABLE public.newsletter_products TO service_role;


--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 388
-- Name: TABLE newsletters; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.newsletters TO anon;
GRANT ALL ON TABLE public.newsletters TO authenticated;
GRANT ALL ON TABLE public.newsletters TO service_role;


--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 379
-- Name: TABLE platforms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.platforms TO anon;
GRANT ALL ON TABLE public.platforms TO authenticated;
GRANT ALL ON TABLE public.platforms TO service_role;


--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 390
-- Name: TABLE price_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.price_history TO anon;
GRANT ALL ON TABLE public.price_history TO authenticated;
GRANT ALL ON TABLE public.price_history TO service_role;


--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 386
-- Name: TABLE product_clicks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_clicks TO anon;
GRANT ALL ON TABLE public.product_clicks TO authenticated;
GRANT ALL ON TABLE public.product_clicks TO service_role;


--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 385
-- Name: TABLE product_likes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_likes TO anon;
GRANT ALL ON TABLE public.product_likes TO authenticated;
GRANT ALL ON TABLE public.product_likes TO service_role;


--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 387
-- Name: TABLE product_trust_votes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_trust_votes TO anon;
GRANT ALL ON TABLE public.product_trust_votes TO authenticated;
GRANT ALL ON TABLE public.product_trust_votes TO service_role;


--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE products; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.products TO anon;
GRANT ALL ON TABLE public.products TO authenticated;
GRANT ALL ON TABLE public.products TO service_role;


--
-- TOC entry 4866 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reports TO anon;
GRANT ALL ON TABLE public.reports TO authenticated;
GRANT ALL ON TABLE public.reports TO service_role;


--
-- TOC entry 4867 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE reviews; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reviews TO anon;
GRANT ALL ON TABLE public.reviews TO authenticated;
GRANT ALL ON TABLE public.reviews TO service_role;


--
-- TOC entry 4868 (class 0 OID 0)
-- Dependencies: 401
-- Name: TABLE search_cache; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.search_cache TO anon;
GRANT ALL ON TABLE public.search_cache TO authenticated;
GRANT ALL ON TABLE public.search_cache TO service_role;


--
-- TOC entry 4869 (class 0 OID 0)
-- Dependencies: 394
-- Name: TABLE shopee_product_mappings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shopee_product_mappings TO anon;
GRANT ALL ON TABLE public.shopee_product_mappings TO authenticated;
GRANT ALL ON TABLE public.shopee_product_mappings TO service_role;


--
-- TOC entry 4870 (class 0 OID 0)
-- Dependencies: 395
-- Name: TABLE shopee_sync_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shopee_sync_logs TO anon;
GRANT ALL ON TABLE public.shopee_sync_logs TO authenticated;
GRANT ALL ON TABLE public.shopee_sync_logs TO service_role;


--
-- TOC entry 4871 (class 0 OID 0)
-- Dependencies: 382
-- Name: TABLE special_page_products; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.special_page_products TO anon;
GRANT ALL ON TABLE public.special_page_products TO authenticated;
GRANT ALL ON TABLE public.special_page_products TO service_role;


--
-- TOC entry 4872 (class 0 OID 0)
-- Dependencies: 381
-- Name: TABLE special_pages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.special_pages TO anon;
GRANT ALL ON TABLE public.special_pages TO authenticated;
GRANT ALL ON TABLE public.special_pages TO service_role;


--
-- TOC entry 4873 (class 0 OID 0)
-- Dependencies: 383
-- Name: TABLE whatsapp_groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.whatsapp_groups TO anon;
GRANT ALL ON TABLE public.whatsapp_groups TO authenticated;
GRANT ALL ON TABLE public.whatsapp_groups TO service_role;


--
-- TOC entry 4874 (class 0 OID 0)
-- Dependencies: 384
-- Name: TABLE wishlists; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.wishlists TO anon;
GRANT ALL ON TABLE public.wishlists TO authenticated;
GRANT ALL ON TABLE public.wishlists TO service_role;


--
-- TOC entry 4875 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- TOC entry 4876 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- TOC entry 4877 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- TOC entry 4878 (class 0 OID 0)
-- Dependencies: 357
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- TOC entry 4880 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO anon;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO authenticated;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO service_role;
RESET SESSION AUTHORIZATION;


--
-- TOC entry 4881 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- TOC entry 4882 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- TOC entry 4884 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO anon;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO authenticated;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO service_role;
RESET SESSION AUTHORIZATION;


--
-- TOC entry 4885 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- TOC entry 4886 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- TOC entry 4887 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- TOC entry 4888 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- TOC entry 2592 (class 826 OID 16553)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2593 (class 826 OID 16554)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2591 (class 826 OID 16552)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2602 (class 826 OID 16632)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2601 (class 826 OID 16631)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- TOC entry 2600 (class 826 OID 16630)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2605 (class 826 OID 16587)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2604 (class 826 OID 16586)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2603 (class 826 OID 16585)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2597 (class 826 OID 16567)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2599 (class 826 OID 16566)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2598 (class 826 OID 16565)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2584 (class 826 OID 16490)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2585 (class 826 OID 16491)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2583 (class 826 OID 16489)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2587 (class 826 OID 16493)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2582 (class 826 OID 16488)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2586 (class 826 OID 16492)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2595 (class 826 OID 16557)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2596 (class 826 OID 16558)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2594 (class 826 OID 16556)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2590 (class 826 OID 16546)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2589 (class 826 OID 16545)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2588 (class 826 OID 16544)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 3773 (class 3466 OID 16571)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- TOC entry 3778 (class 3466 OID 16650)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- TOC entry 3772 (class 3466 OID 16569)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- TOC entry 3779 (class 3466 OID 16653)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- TOC entry 3774 (class 3466 OID 16572)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- TOC entry 3775 (class 3466 OID 16573)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

-- Completed on 2026-03-21 15:42:55

--
-- PostgreSQL database dump complete
--

\unrestrict nTbvfVf01FXer1gdNg1KACUt3SVNuDhqyA3poQz7IU5lgZgJ5H6AiT1KhDcGxjj

-- Completed on 2026-03-21 15:42:55

--
-- PostgreSQL database cluster dump complete
--

